"""Flask API server — EA Knowledge Brain Learning Pipeline.

Endpoints:
  GET  /api/learning/status
  POST /api/learning/scan-channel
  POST /api/learning/learn-new        ← learn + auto-run full pipeline
  POST /api/learning/extract-raw
  POST /api/learning/merge-knowledge
  POST /api/learning/write-concepts
  POST /api/learning/detect-conflicts
  POST /api/learning/run-pipeline     ← 8-step auto pipeline
  GET  /api/learning/conflicts
  PATCH /api/learning/conflicts/<conflict_id>
  GET  /api/learning/knowledge-index
  GET  /api/learning/manifest
  GET  /api/learning/blueprint
  POST /api/learning/blueprint
  GET    /api/learning/settings/cookies
  POST   /api/learning/settings/cookies
  DELETE /api/learning/settings/cookies
  POST   /api/learning/settings/test-youtube

Pipeline steps (run-pipeline):
  1. extract-raw      (LLM if ANTHROPIC_API_KEY set)
  2. merge-knowledge
  3. deduplicate      (concept_deduplicator)
  4. write-concepts
  5. detect-conflicts
  6. auto-resolve     (low_evidence/incomplete_rule → accept; contradiction stays pending)
  7. ea-components
  8. blueprint

All endpoints return JSON. CORS headers allow browser requests from any origin.
"""
from __future__ import annotations

import importlib.util
import csv
import io
import json
import os
import re
import shutil
import threading
import tempfile
import subprocess
import time
from collections import Counter
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any

from flask import Flask, Response, jsonify, request
from werkzeug.utils import secure_filename

from channel_intake import scan_channel, learn_new_videos
from channel_manifest import ChannelManifestStore
from csv_analyzer import generate_csv_diagnosis
from local_evidence_intake import DEFAULT_LOCAL_RAW_DIR, import_local_evidence
from remote_inbox import get_remote_inbox_status, process_remote_inbox
from research_state import build_research_state
from concept_note_writer import write_concept_notes, DEFAULT_CONCEPTS_DIR
from concept_deduplicator import (
    deduplicate_knowledge_index,
    deduplicate_structured_extractions,
)
from conflict_detector import (
    ConflictReviewStore,
    DEFAULT_CONFLICT_QUEUE_PATH,
    detect_conflicts,
    resolve_conflict,
    get_pending_conflicts,
)
from knowledge_merger import (
    DEFAULT_INDEX_PATH,
    DEFAULT_MERGE_LOG_PATH,
    DEFAULT_STRUCTURED_PATH,
    KnowledgeIndexStore,
    merge_structured_extractions,
)
from structured_extractor import (
    DEFAULT_EXTRACTION_PATH,
    DEFAULT_RAW_DIR,
    StructuredExtractionStore,
    extract_raw_notes,
)
from ea_component_extractor import (
    DEFAULT_OUTPUT_PATH as DEFAULT_COMPONENTS_PATH,
    extract_from_files as extract_ea_components_from_files,
)
from ea_blueprint_generator import (
    DEFAULT_OUTPUT_PATH as DEFAULT_BLUEPRINT_PATH,
    generate_from_files as generate_blueprint_from_files,
)
from blade_executor import DEFAULT_BLADE_INTENTS_PATH, BladeDryRunExecutor, BladeExecutionError
from command_state import DEFAULT_COMMAND_STATE_PATH, CommandStateError, CommandStateStore
from decision_journal import DEFAULT_JOURNAL_PATH as DEFAULT_DECISION_JOURNAL_PATH
from decision_journal import DecisionJournalError, DecisionJournalStore
from ea_registry import DEFAULT_REGISTRY_PATH as DEFAULT_EA_REGISTRY_PATH
from ea_registry import EARegistryError, EARegistryStore
from risk_gate import DEFAULT_RISK_GATE_PATH, RiskGateError, RiskGateStore
from trade_records import DEFAULT_TRADE_RECORDS_PATH, TradeRecordReader

_TH_TZ = timezone(timedelta(hours=7))

VALID_STATUSES = {"pending", "accepted", "keep_old", "merge_as_condition", "resolved", "rejected"}
DEFAULT_COOKIES_PATH = Path(__file__).with_name("youtube_cookies.txt")
DEFAULT_REMOTE_INBOX_ROOT = Path.home() / "Desktop" / "EA-Knowledge-Brain"
DEFAULT_PARALLEL_SUPERVISOR_STATUS_PATH = Path(__file__).parent / ".server_manager" / "parallel_agent_supervisor_status.json"
DEFAULT_PARALLEL_AGENT_REPORTS_DIR = Path(__file__).resolve().parents[2] / ".agent_handoff" / "agent_reports"
LEARNED_VIDEO_STATUSES = {
    "raw_evidence_written",
    "structured_extracted",
    "written_to_obsidian",
    "learned",
}
RETRY_VIDEO_STATUSES = {"discovered", "needs_transcript_check", "failed"}

# Background pipeline task state (module-level so tests can inspect it)
_task_lock: threading.Lock = threading.Lock()
_task_state: dict[str, Any] = {"running": False, "result": None, "error": None}
_sync_task_state: dict[str, Any] = {"running": False, "result": None, "error": None}

_last_pipeline_activity: float = time.time()
_needs_system_sync: bool = False

def _run_system_sync() -> dict[str, str]:
    """Run db_bridge and graphify update sequentially."""
    global _needs_system_sync
    try:
        root_dir = Path(__file__).resolve().parents[2]
        db_bridge_script = root_dir / "ea_research_team" / "learning" / "db_bridge.py"
        
        # Sync DB
        for cmd_type in ["sync-concepts", "sync-evidence", "sync-relationships"]:
            subprocess.run(["python", str(db_bridge_script), cmd_type, "--apply"], cwd=str(root_dir), check=False)
            
        # Update Graphify
        subprocess.run(["graphify", "update", "."], cwd=str(root_dir), check=False)
        
        with _task_lock:
            _needs_system_sync = False
            
        return {"status": "success"}
    except Exception as e:
        return {"status": "error", "error": str(e)}

def _smart_timer_loop() -> None:
    """Check every minute if 30 minutes have passed since last activity and sync is needed."""
    while True:
        time.sleep(60)
        with _task_lock:
            needs_sync = _needs_system_sync
            idle_time = time.time() - _last_pipeline_activity
        
        if needs_sync and idle_time > 1800:
            # 30 minutes of inactivity, run sync!
            global _sync_task_state
            with _task_lock:
                if not _sync_task_state["running"]:
                    _sync_task_state = {"running": True, "result": None, "error": None}
                    threading.Thread(target=_run_sync_task_bg, daemon=True).start()

def _run_sync_task_bg() -> None:
    global _sync_task_state
    try:
        res = _run_system_sync()
        with _task_lock:
            _sync_task_state = {"running": False, "result": res, "error": None}
    except Exception as exc:
        with _task_lock:
            _sync_task_state = {"running": False, "result": None, "error": str(exc)}

# Start smart timer loop
threading.Thread(target=_smart_timer_loop, daemon=True).start()


def _run_bg_task(fn: Any, *args: Any) -> None:
    """Run fn(*args) in background; update _task_state when done."""
    global _task_state
    try:
        result = fn(*args)
        with _task_lock:
            _task_state = {"running": False, "result": result, "error": None}
    except Exception as exc:
        with _task_lock:
            _task_state = {"running": False, "result": None, "error": str(exc)}
            
    # Mark activity for smart timer
    global _last_pipeline_activity, _needs_system_sync
    with _task_lock:
        _last_pipeline_activity = time.time()
        _needs_system_sync = True

# ---------------------------------------------------------------------------
# Pipeline helpers (module-level so they can be patched in tests)
# ---------------------------------------------------------------------------

def _merge_step_results(results: list[dict[str, Any]]) -> dict[str, Any]:
    merged: dict[str, Any] = {"processed": 0, "written": 0, "skipped": 0, "failed": 0}
    merged["sources"] = []
    for result in results:
        for key in ("processed", "written", "skipped", "failed"):
            merged[key] += int(result.get(key, 0) or 0)
        source = result.get("raw_dir")
        if source:
            merged["sources"].append(source)
    return merged


def _extract_raw_dirs(
    *,
    raw_dirs: list[Path],
    structured_path: Path,
    manifest_path: Path,
    llm_client: Any | None = None,
) -> dict[str, Any]:
    store = StructuredExtractionStore(structured_path)
    manifest_store = ChannelManifestStore(manifest_path)
    results = []
    for raw_dir in raw_dirs:
        result = extract_raw_notes(
            raw_dir=raw_dir,
            store=store,
            manifest_store=manifest_store,
            llm_client=llm_client,
        )
        result["raw_dir"] = str(raw_dir)
        results.append(result)
    return _merge_step_results(results)

def _make_llm_client() -> Any | None:
    """Return a local/OpenAI-compatible client for light work, or Anthropic if set."""
    local_url = os.environ.get("LOCAL_LLM_URL")
    prefer_local = _truthy(os.environ.get("EA_KB_PREFER_LOCAL_LLM"))
    openai_key = os.environ.get("OPENAI_API_KEY")
    daily_budget = max(_env_float("EA_KB_AI_DAILY_BUDGET_UNITS", 100), 1)
    logged_units, _ = _read_ai_usage_units()
    env_used_units = max(_env_float("EA_KB_AI_USED_UNITS", 0), 0)
    used_units = logged_units if logged_units > 0 else env_used_units
    cloud_near_limit = int(round((used_units / daily_budget) * 100)) >= 70

    if local_url and (prefer_local or cloud_near_limit or not os.environ.get("ANTHROPIC_API_KEY")):
        try:
            import openai
            return openai.OpenAI(
                base_url=local_url,
                api_key=os.environ.get("LOCAL_LLM_API_KEY", "lm-studio"),
            )
        except ImportError:
            pass

    try:
        import anthropic
        if os.environ.get("ANTHROPIC_API_KEY"):
            return anthropic.Anthropic()
    except ImportError:
        pass

    if openai_key:
        try:
            import openai
            return openai.OpenAI(api_key=openai_key)
        except ImportError:
            pass
    return None


def _run_dedup(index_path: Path, structured_path: Path) -> dict[str, Any]:
    """Deduplicate knowledge_index and structured_extractions in-place. Returns stats."""
    if not index_path.exists():
        return {"concepts_before": 0, "concepts_after": 0, "removed": 0, "merged": 0}

    index_data = json.loads(index_path.read_text(encoding="utf-8"))
    before = len(index_data.get("concepts", {}))
    new_index, name_map = deduplicate_knowledge_index(index_data)
    after = len(new_index.get("concepts", {}))
    merged_pairs = {k: v for k, v in name_map.items() if k != v}

    stamp = datetime.now().strftime("%Y%m%d%H%M%S%f")
    tmp = index_path.with_suffix(f".tmp-{stamp}.json")
    tmp.write_text(json.dumps(new_index, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
    tmp.replace(index_path)

    if structured_path.exists():
        structured_data = json.loads(structured_path.read_text(encoding="utf-8"))
        new_structured = deduplicate_structured_extractions(structured_data, name_map)
        tmp2 = structured_path.with_suffix(f".tmp-{stamp}s.json")
        tmp2.write_text(json.dumps(new_structured, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
        tmp2.replace(structured_path)

    return {
        "concepts_before": before,
        "concepts_after": after,
        "removed": before - after,
        "merged": len(merged_pairs),
    }


def _auto_resolve_conflicts(queue_path: Path) -> dict[str, int]:
    """Auto-accept low_evidence/incomplete_rule conflicts; contradictions stay pending."""
    if not queue_path.exists():
        return {"auto_resolved": 0, "still_pending": 0}

    now = datetime.now(_TH_TZ).isoformat(timespec="seconds")
    store = ConflictReviewStore(queue_path)
    queue = store.load()
    auto_resolved = 0
    still_pending = 0

    for item in queue["items"].values():
        if item.get("status") != "pending":
            continue
        if item.get("type") in ("low_evidence", "low_confidence", "incomplete_rule"):
            item["status"] = "accepted"
            item["resolution"] = "accepted"
            item["resolution_note"] = "Auto-resolved by pipeline: not a structural conflict."
            item["resolved_at"] = now
            auto_resolved += 1
        else:
            still_pending += 1

    store.save(queue)
    return {"auto_resolved": auto_resolved, "still_pending": still_pending}


def _read_json_file(path: Path) -> dict[str, Any] | None:
    if not path.exists():
        return None
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
        return data if isinstance(data, dict) else None
    except Exception:
        return None


def _read_text_snapshot(path: Path) -> str | None:
    if not path.exists():
        return None
    try:
        return path.read_text(encoding="utf-8")
    except Exception:
        return None


def _restore_text_snapshot(path: Path, snapshot: str | None) -> None:
    if snapshot is None:
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(snapshot, encoding="utf-8")


def _readiness_rank(value: Any) -> int:
    return {"low": 1, "medium": 2, "high": 3}.get(str(value or "").lower(), 0)


def _component_quality(data: dict[str, Any] | None) -> tuple[int, int]:
    if not data:
        return (0, 0)
    summary = data.get("summary") if isinstance(data.get("summary"), dict) else {}
    total_rules = int(summary.get("total_rules") or data.get("total_rules") or 0)
    readiness = _readiness_rank(summary.get("ea_readiness") or data.get("ea_readiness"))
    return (readiness, total_rules)


def _blueprint_quality(data: dict[str, Any] | None) -> tuple[int, int]:
    if not data:
        return (0, 0)
    summary = data.get("summary") if isinstance(data.get("summary"), dict) else {}
    total_rules = int(summary.get("total_rules_used") or summary.get("total_rules") or 0)
    readiness = _readiness_rank(summary.get("ea_readiness") or data.get("ea_readiness"))
    return (readiness, total_rules)


def _is_quality_downgrade(
    *,
    previous_components: dict[str, Any] | None,
    new_components: dict[str, Any] | None,
    previous_blueprint: dict[str, Any] | None,
    new_blueprint: dict[str, Any] | None,
) -> bool:
    prev_component_quality = _component_quality(previous_components)
    new_component_quality = _component_quality(new_components)
    prev_blueprint_quality = _blueprint_quality(previous_blueprint)
    new_blueprint_quality = _blueprint_quality(new_blueprint)

    return (
        prev_component_quality > new_component_quality
        or prev_blueprint_quality > new_blueprint_quality
    )


def _test_youtube_connection(cookies_path: Path) -> dict[str, Any]:
    """Test YouTube access. NoTranscriptFound = IP accessible (not blocked). Patchable in tests."""
    try:
        from http.cookiejar import MozillaCookieJar
        import requests as _req
        from youtube_transcript_api import (
            YouTubeTranscriptApi, IpBlocked, NoTranscriptFound, TranscriptsDisabled,
        )

        session = _req.Session()
        cj = MozillaCookieJar()
        cj.load(str(cookies_path), ignore_discard=True, ignore_expires=True)
        session.cookies = cj  # type: ignore[assignment]
        api = YouTubeTranscriptApi(http_client=session)

        try:
            transcript_list = api.list("dQw4w9WgXcQ")
            for t_info in transcript_list:
                try:
                    entries = t_info.fetch()
                    text = " ".join(
                        (e.get("text", "") if isinstance(e, dict) else getattr(e, "text", ""))
                        for e in entries
                    )
                    return {"status": "ok", "language": t_info.language_code,
                            "words": len(text.split()), "message": "YouTube accessible"}
                except Exception:
                    continue
            return {"status": "ok", "message": "IP accessible — YouTube responding normally"}
        except IpBlocked:
            return {"status": "error", "error": "IpBlocked — cookies did not unblock the IP"}
        except (NoTranscriptFound, TranscriptsDisabled):
            # YouTube responded (not blocked) — just no captions on this test video
            return {"status": "ok", "message": "IP accessible — YouTube responding normally"}
    except Exception as exc:
        return {"status": "error", "error": type(exc).__name__ + ": " + str(exc)[:200]}


def _run_full_pipeline(app: Flask) -> dict[str, Any]:
    """Run all 8 pipeline steps. Called by run-pipeline endpoint and learn-new auto-trigger."""
    raw_dir        = _cfg(app, "RAW_DIR",             str(DEFAULT_RAW_DIR))
    local_raw_dir  = _cfg(app, "LOCAL_RAW_DIR",       str(DEFAULT_LOCAL_RAW_DIR))
    structured_path= _cfg(app, "STRUCTURED_PATH",     str(DEFAULT_EXTRACTION_PATH))
    index_path     = _cfg(app, "INDEX_PATH",           str(DEFAULT_INDEX_PATH))
    log_path       = _cfg(app, "MERGE_LOG_PATH",       str(DEFAULT_MERGE_LOG_PATH))
    concepts_dir   = _cfg(app, "CONCEPTS_DIR",         str(DEFAULT_CONCEPTS_DIR))
    queue_path     = _cfg(app, "CONFLICT_QUEUE_PATH",  str(DEFAULT_CONFLICT_QUEUE_PATH))
    components_path= _cfg(app, "COMPONENTS_PATH",      str(DEFAULT_COMPONENTS_PATH))
    blueprint_path = _cfg(app, "BLUEPRINT_PATH",       str(DEFAULT_BLUEPRINT_PATH))
    manifest_path  = _cfg(app, "MANIFEST_PATH",        str(
        Path(__file__).with_name("channel_manifest.json")
    ))

    llm_client = _make_llm_client()
    previous_components_text = _read_text_snapshot(components_path)
    previous_blueprint_text = _read_text_snapshot(blueprint_path)
    previous_components = _read_json_file(components_path)
    previous_blueprint = _read_json_file(blueprint_path)

    # 1. Extract raw notes (use LLM if key available)
    r_extract = _extract_raw_dirs(
        raw_dirs=[raw_dir, local_raw_dir],
        structured_path=structured_path,
        manifest_path=manifest_path,
        llm_client=llm_client,
    )

    # 2. Merge into knowledge index
    r_merge = merge_structured_extractions(
        structured_path=structured_path,
        index_store=KnowledgeIndexStore(index_path),
        merge_log_path=log_path,
    )

    # 3. Deduplicate concepts
    r_dedup = _run_dedup(index_path, structured_path)

    # 4. Write Obsidian concept notes
    r_write = write_concept_notes(
        index_path=index_path,
        structured_path=structured_path,
        output_dir=concepts_dir,
    )

    # 5. Detect conflicts
    r_detect = detect_conflicts(
        index_path=index_path,
        structured_path=structured_path,
        queue_path=queue_path,
    )

    # 6. Auto-resolve low-evidence conflicts
    r_resolve = _auto_resolve_conflicts(queue_path)

    # 7. Extract EA components
    r_components = extract_ea_components_from_files(index_path, structured_path, components_path)

    # 8. Generate MQL5 blueprint
    try:
        r_blueprint = generate_blueprint_from_files(
            components_path=components_path,
            output_path=blueprint_path,
        )
    except Exception as exc:
        r_blueprint = {"error": str(exc), "ea_readiness": "low"}

    r_guard = {"action": "accepted", "reason": None}
    if llm_client is None and _is_quality_downgrade(
        previous_components=previous_components,
        new_components=_read_json_file(components_path),
        previous_blueprint=previous_blueprint,
        new_blueprint=_read_json_file(blueprint_path),
    ):
        _restore_text_snapshot(components_path, previous_components_text)
        _restore_text_snapshot(blueprint_path, previous_blueprint_text)
        restored_components = _read_json_file(components_path)
        restored_blueprint = _read_json_file(blueprint_path)
        if restored_components is not None:
            r_components = restored_components
        if restored_blueprint is not None:
            r_blueprint = restored_blueprint
        r_guard = {
            "action": "restored_previous_outputs",
            "reason": "No LLM client was available and keyword-fallback output downgraded EA readiness/rule coverage.",
        }

    return {
        "extract":      r_extract,
        "merge":        r_merge,
        "dedup":        r_dedup,
        "write_concepts": r_write,
        "conflicts":    r_detect,
        "auto_resolve": r_resolve,
        "ea_components": r_components,
        "blueprint":    r_blueprint,
        "quality_guard": r_guard,
    }


def _cfg(app: Flask, key: str, default: str) -> Path:
    return Path(app.config.get(key, default))


def _cors(resp: Response) -> Response:
    resp.headers["Access-Control-Allow-Origin"] = "*"
    resp.headers["Access-Control-Allow-Headers"] = "Content-Type"
    resp.headers["Access-Control-Allow-Methods"] = "GET, POST, PATCH, OPTIONS"
    return resp


def _json(data: Any, status: int = 200) -> Response:
    resp = jsonify(data)
    resp.status_code = status
    return _cors(resp)


def _err(msg: str, status: int = 400) -> Response:
    return _json({"error": msg}, status)


def _status_counts(app: Flask) -> dict[str, Any]:
    manifest_path = _cfg(app, "MANIFEST_PATH", str(
        Path(__file__).with_name("channel_manifest.json")
    ))
    index_path = _cfg(app, "INDEX_PATH", str(DEFAULT_INDEX_PATH))
    queue_path = _cfg(app, "CONFLICT_QUEUE_PATH", str(DEFAULT_CONFLICT_QUEUE_PATH))
    concepts_dir = _cfg(app, "CONCEPTS_DIR", str(DEFAULT_CONCEPTS_DIR))

    # Channels + videos from manifest
    channels: dict[str, Any] = {"total": 0, "by_status": {}}
    videos: dict[str, int] = {
        "discovered": 0, "learned": 0, "needs_check": 0, "failed": 0, "total": 0,
    }
    if manifest_path.exists():
        raw = json.loads(manifest_path.read_text(encoding="utf-8"))
        channels["total"] = len(raw.get("channels", {}))
        for vid in raw.get("videos", {}).values():
            status = vid.get("status", "discovered")
            videos["total"] += 1
            if status in LEARNED_VIDEO_STATUSES:
                videos["learned"] += 1
            elif status == "needs_transcript_check":
                videos["needs_check"] += 1
            elif status == "failed":
                videos["failed"] += 1
            else:
                videos["discovered"] += 1

    # Concepts from knowledge index
    concepts: dict[str, Any] = {"total": 0, "avg_confidence": 0}
    if index_path.exists():
        idx = json.loads(index_path.read_text(encoding="utf-8"))
        c = idx.get("concepts", {})
        concepts["total"] = len(c)
        if c:
            concepts["avg_confidence"] = int(
                round(sum(v.get("confidence", 0) for v in c.values()) / len(c))
            )

    # Conflicts from review queue
    conflicts_stat: dict[str, int] = {"total": 0, "pending": 0, "resolved": 0}
    if queue_path.exists():
        q = json.loads(queue_path.read_text(encoding="utf-8"))
        items = q.get("items", {}).values()
        conflicts_stat["total"] = len(list(items))
        for item in q.get("items", {}).values():
            s = item.get("status", "pending")
            if s == "pending":
                conflicts_stat["pending"] += 1
            elif s == "resolved":
                conflicts_stat["resolved"] += 1

    # Concepts written (files in concepts dir)
    concepts_written = len(list(concepts_dir.glob("*.md"))) if concepts_dir.exists() else 0

    # EA rules from ea_components.json
    components_path = _cfg(app, "COMPONENTS_PATH", str(DEFAULT_COMPONENTS_PATH))
    ea_rules = 0
    if components_path.exists():
        try:
            comp = json.loads(components_path.read_text(encoding="utf-8"))
            ea_rules = comp.get("summary", {}).get("total_rules", 0)
        except Exception:
            pass

    # Blueprint ready
    blueprint_path = _cfg(app, "BLUEPRINT_PATH", str(DEFAULT_BLUEPRINT_PATH))
    blueprint_ready = blueprint_path.exists()

    return {
        "channels": channels,
        "videos": videos,
        "concepts": concepts,
        "conflicts": conflicts_stat,
        "concepts_written": concepts_written,
        "ea_rules": ea_rules,
        "blueprint_ready": blueprint_ready,
    }


def _read_json(path: Path, default: Any) -> Any:
    if not path.exists():
        return default
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return default


def _pct(done: int, total: int) -> int:
    if total <= 0:
        return 0
    return int(round((done / total) * 100))


def _structured_count(path: Path) -> int:
    data = _read_json(path, {"items": {}})
    items = data.get("items", {}) if isinstance(data, dict) else data
    return len(items) if isinstance(items, (dict, list)) else 0


def _concept_count(path: Path) -> int:
    data = _read_json(path, {"concepts": {}})
    concepts = data.get("concepts", {}) if isinstance(data, dict) else {}
    return len(concepts) if isinstance(concepts, dict) else 0


def _ea_rule_count(path: Path) -> int:
    data = _read_json(path, {})
    if not isinstance(data, dict):
        return 0
    return int(data.get("summary", {}).get("total_rules", 0) or 0)


def _blueprint_ready(path: Path) -> bool:
    data = _read_json(path, {})
    if isinstance(data, dict):
        return bool(data.get("mql5_code") or data.get("summary"))
    return path.exists()


def _current_bottleneck(
    *,
    needs_check: int,
    learned: int,
    structured_extractions: int,
    concepts: int,
    notes_written: int,
    ea_rules: int,
    blueprint_ready: bool,
) -> str:
    if needs_check > 0:
        return "transcript_intake"
    if structured_extractions == 0:
        return "structured_extraction"
    if concepts == 0:
        return "knowledge_merge"
    if notes_written == 0:
        return "obsidian_write"
    if ea_rules == 0:
        return "ea_component_extraction"
    if not blueprint_ready:
        return "blueprint_generation"
    return "ready_for_review"


def _youtube_sources(app: Flask) -> dict[str, Any]:
    manifest_path = _cfg(app, "MANIFEST_PATH", str(Path(__file__).with_name("channel_manifest.json")))
    structured_path = _cfg(app, "STRUCTURED_PATH", str(DEFAULT_STRUCTURED_PATH))
    index_path = _cfg(app, "INDEX_PATH", str(DEFAULT_INDEX_PATH))
    concepts_dir = _cfg(app, "CONCEPTS_DIR", str(DEFAULT_CONCEPTS_DIR))
    components_path = _cfg(app, "COMPONENTS_PATH", str(DEFAULT_COMPONENTS_PATH))
    blueprint_path = _cfg(app, "BLUEPRINT_PATH", str(DEFAULT_BLUEPRINT_PATH))

    manifest = _read_json(manifest_path, {"channels": {}, "videos": {}})
    raw_channels = manifest.get("channels", {}) if isinstance(manifest, dict) else {}
    raw_videos = manifest.get("videos", {}) if isinstance(manifest, dict) else {}
    videos = list(raw_videos.values()) if isinstance(raw_videos, dict) else []

    learned = sum(1 for video in videos if video.get("status") in LEARNED_VIDEO_STATUSES)
    needs_check = sum(1 for video in videos if video.get("status") == "needs_transcript_check")
    failed = sum(1 for video in videos if video.get("status") == "failed")
    total = len(videos)

    grouped: dict[str, dict[str, Any]] = {}
    for video in videos:
        channel_id = video.get("channel_id") or video.get("channel_handle") or "unknown"
        channel_info = raw_channels.get(channel_id, {}) if isinstance(raw_channels, dict) else {}
        bucket = grouped.setdefault(channel_id, {
            "channel_id": channel_id,
            "channel_name": (
                channel_info.get("channel_name")
                or channel_info.get("title")
                or video.get("channel_name")
                or channel_id
            ),
            "channel_url": channel_info.get("channel_url") or video.get("channel_url") or "",
            "videos_total": 0,
            "learned": 0,
            "remaining": 0,
            "needs_check": 0,
            "failed": 0,
            "_failure_reasons": Counter(),
            "_retry_videos": [],
        })
        status = video.get("status", "discovered")
        bucket["videos_total"] += 1
        if status in LEARNED_VIDEO_STATUSES:
            bucket["learned"] += 1
        elif status == "needs_transcript_check":
            bucket["needs_check"] += 1
        elif status == "failed":
            bucket["failed"] += 1

        reason = video.get("failure_reason")
        if reason:
            bucket["_failure_reasons"][reason] += 1
        if status in RETRY_VIDEO_STATUSES:
            bucket["_retry_videos"].append({
                "video_id": video.get("video_id", ""),
                "title": video.get("title", video.get("video_id", "")),
                "url": video.get("url", ""),
            })

    channels = []
    for item in grouped.values():
        retry_videos = sorted(item.pop("_retry_videos"), key=lambda v: (v["title"], v["video_id"]))
        failure_reasons = dict(sorted(item.pop("_failure_reasons").items()))
        item["remaining"] = item["videos_total"] - item["learned"]
        item["learning_progress_pct"] = _pct(item["learned"], item["videos_total"])
        item["failure_reasons"] = failure_reasons
        item["next_retry_video"] = retry_videos[0] if retry_videos else None
        channels.append(item)
    channels.sort(key=lambda ch: (ch["channel_name"], ch["channel_id"]))

    structured_extractions = _structured_count(structured_path)
    concepts = _concept_count(index_path)
    notes_written = len(list(concepts_dir.glob("*.md"))) if concepts_dir.exists() else 0
    ea_rules = _ea_rule_count(components_path)
    blueprint_ready = _blueprint_ready(blueprint_path)
    pipeline = {
        "discovered": total,
        "transcript_done": learned,
        "raw_evidence": learned,
        "structured_extractions": structured_extractions,
        "concepts": concepts,
        "notes_written": notes_written,
        "ea_rules": ea_rules,
        "blueprint_ready": blueprint_ready,
    }

    pipeline_progress = 0
    pipeline_progress += 15 if total else 0
    pipeline_progress += 20 if learned else 0
    pipeline_progress += 20 if structured_extractions else 0
    pipeline_progress += 15 if concepts else 0
    pipeline_progress += 10 if notes_written else 0
    pipeline_progress += 10 if ea_rules else 0
    pipeline_progress += 10 if blueprint_ready else 0

    summary = {
        "channels_tracked": len(raw_channels) if isinstance(raw_channels, dict) else len(channels),
        "videos_total": total,
        "learned": learned,
        "remaining": total - learned,
        "needs_check": needs_check,
        "failed": failed,
        "learning_progress_pct": _pct(learned, total),
        "pipeline_progress_pct": pipeline_progress,
        "current_bottleneck": _current_bottleneck(
            needs_check=needs_check,
            learned=learned,
            structured_extractions=structured_extractions,
            concepts=concepts,
            notes_written=notes_written,
            ea_rules=ea_rules,
            blueprint_ready=blueprint_ready,
        ),
    }
    return {"summary": summary, "pipeline": pipeline, "channels": channels}


def _has_module(name: str) -> bool:
    return importlib.util.find_spec(name) is not None


def _engine_status(app: Flask) -> dict[str, Any]:
    faster_whisper = _has_module("faster_whisper")
    openai_whisper = _has_module("whisper")
    whisper_cli = shutil.which("whisper") is not None
    pillow = _has_module("PIL")
    pytesseract = _has_module("pytesseract")
    tesseract_cli = shutil.which("tesseract") is not None
    cookies_path = _cfg(app, "COOKIES_PATH", str(DEFAULT_COOKIES_PATH))
    local_raw_dir = _cfg(app, "LOCAL_RAW_DIR", str(DEFAULT_LOCAL_RAW_DIR))
    local_notes = sorted(local_raw_dir.glob("*.md")) if local_raw_dir.exists() else []

    video_available = faster_whisper or openai_whisper or whisper_cli
    image_available = (pillow and pytesseract) or tesseract_cli
    has_cookies = cookies_path.exists()

    return {
        "generated_at": datetime.now(_TH_TZ).isoformat(timespec="seconds"),
        "video_transcription": {
            "status": "available" if video_available else "unavailable",
            "providers": {
                "faster_whisper": faster_whisper,
                "openai_whisper": openai_whisper,
                "whisper_cli": whisper_cli,
            },
            "message": (
                "Local video transcription is ready"
                if video_available
                else "Install faster-whisper, openai-whisper, or expose a whisper CLI"
            ),
        },
        "image_ocr": {
            "status": "available" if image_available else "unavailable",
            "providers": {
                "pillow": pillow,
                "pytesseract": pytesseract,
                "tesseract_cli": tesseract_cli,
            },
            "message": (
                "Local image OCR is ready"
                if image_available
                else "Install pytesseract with Pillow, or expose a tesseract CLI"
            ),
        },
        "youtube": {
            "status": "cookies_configured" if has_cookies else "cookies_missing",
            "has_cookies": has_cookies,
            "cookies_path": str(cookies_path),
            "size_bytes": cookies_path.stat().st_size if has_cookies else 0,
        },
        "local_raw": {
            "path": str(local_raw_dir),
            "exists": local_raw_dir.exists(),
            "notes_count": len(local_notes),
        },
    }


def _env_float(name: str, default: float) -> float:
    try:
        return float(os.environ.get(name, default))
    except (TypeError, ValueError):
        return default


def _provider_status(provider_id: str, label: str, env_var: str) -> dict[str, Any]:
    configured = bool(os.environ.get(env_var))
    return {
        "id": provider_id,
        "label": label,
        "configured": configured,
        "status": "configured" if configured else "missing",
        "used_percent": min(max(int(round(_env_float(f"EA_KB_AI_{provider_id.upper()}_USED_PERCENT", 0))), 0), 100),
    }


def _local_llm_status() -> dict[str, Any]:
    local_url = os.environ.get("LOCAL_LLM_URL", "http://127.0.0.1:1234/v1")
    configured = bool(os.environ.get("LOCAL_LLM_URL"))
    return {
        "id": "local_llm",
        "label": "LM Studio",
        "configured": configured,
        "status": "ready" if configured else "available_if_running",
        "url": local_url,
        "model": os.environ.get("LOCAL_LLM_MODEL", "google/gemma-4-e4b"),
        "role": "lightwork_fallback",
        "used_percent": 0,
    }


def _ai_usage_log_path() -> Path:
    configured = os.environ.get("EA_KB_AI_USAGE_LOG")
    if configured:
        return Path(configured)
    day = datetime.now(_TH_TZ).strftime("%Y-%m-%d")
    return Path(__file__).parent / ".server_manager" / f"ai_usage_{day}.jsonl"


def _read_ai_usage_units() -> tuple[float, dict[str, float]]:
    usage_path = _ai_usage_log_path()
    if not usage_path.exists():
        return 0.0, {}

    total = 0.0
    by_provider: dict[str, float] = {}
    try:
        for line in usage_path.read_text(encoding="utf-8").splitlines():
            if not line.strip():
                continue
            try:
                item = json.loads(line)
            except json.JSONDecodeError:
                continue
            units = float(item.get("units") or 0)
            provider = str(item.get("provider") or "unknown").lower()
            total += units
            by_provider[provider] = by_provider.get(provider, 0.0) + units
    except OSError:
        return 0.0, {}
    return total, by_provider


def _ai_budget_status() -> dict[str, Any]:
    daily_budget = max(_env_float("EA_KB_AI_DAILY_BUDGET_UNITS", 100), 1)
    logged_units, provider_units = _read_ai_usage_units()
    env_used_units = max(_env_float("EA_KB_AI_USED_UNITS", 0), 0)
    used_units = logged_units if logged_units > 0 else env_used_units
    used_percent = min(int(round((used_units / daily_budget) * 100)), 100)
    left_percent = max(100 - used_percent, 0)

    if used_percent >= 90:
        status = "stop_heavy"
        recommendation = "Stop heavy tasks"
        message = "Save now and avoid heavy LLM pipelines until the budget resets."
    elif used_percent >= 70:
        status = "save_soon"
        recommendation = "Save soon"
        message = "Continue light work, but save before running large extraction batches."
    else:
        status = "continue"
        recommendation = "Continue"
        message = "Heavy pipeline work is still allowed."

    providers = [
        _local_llm_status(),
        _provider_status("anthropic", "Claude", "ANTHROPIC_API_KEY"),
        _provider_status("gemini", "Gemini", "GEMINI_API_KEY"),
        _provider_status("openrouter", "OpenRouter", "OPENROUTER_API_KEY"),
    ]
    for provider in providers:
        units = provider_units.get(provider["id"], 0)
        if units > 0:
            provider["used_percent"] = min(int(round((units / daily_budget) * 100)), 100)
    local_ready = providers[0]["configured"]
    cloud_ready = any(p["configured"] for p in providers[1:])
    if local_ready and used_percent >= 70:
        message = "Light extraction will route to LM Studio; save cloud models for conflicts, risk, and blueprint review."
    elif local_ready and not cloud_ready:
        message = "LM Studio is ready for light extraction. Cloud LLMs are not configured."

    return {
        "generated_at": datetime.now(_TH_TZ).isoformat(timespec="seconds"),
        "status": status,
        "recommendation": recommendation,
        "message": message,
        "used_units": used_units,
        "daily_budget_units": daily_budget,
        "usage_log_path": str(_ai_usage_log_path()),
        "used_percent": used_percent,
        "left_percent": left_percent,
        "warning_percent": 70,
        "hard_stop_percent": 90,
        "mode": "Cloud LLM Ready" if cloud_ready else "Local LLM Ready" if local_ready else "Fallback Only",
        "providers": providers,
        "fallback": {
            "keyword_extraction": True,
            "local_llm_lightwork": local_ready,
            "local_whisper": _has_module("faster_whisper"),
        },
        "guard": {
            "no_llm_downgrade_protected": True,
        },
    }


def _parallel_agent_status(app: Flask) -> dict[str, Any]:
    status_path = Path(
        app.config.get("PARALLEL_SUPERVISOR_STATUS_PATH")
        or DEFAULT_PARALLEL_SUPERVISOR_STATUS_PATH
    )
    reports_dir = Path(
        app.config.get("PARALLEL_AGENT_REPORTS_DIR")
        or DEFAULT_PARALLEL_AGENT_REPORTS_DIR
    )
    if not status_path.exists():
        return {
            "running": False,
            "status": "not_started",
            "updated_at": None,
            "total": 0,
            "reports": [],
            "safe_to_execute": False,
            "blocking_reason": "not_started",
        }

    try:
        status_data = json.loads(status_path.read_text(encoding="utf-8-sig"))
    except (OSError, json.JSONDecodeError):
        return {
            "running": False,
            "status": "error",
            "updated_at": None,
            "total": 0,
            "reports": [],
            "safe_to_execute": False,
            "blocking_reason": "status_error",
        }

    reports: list[dict[str, Any]] = []
    if reports_dir.exists():
        for report_path in sorted(reports_dir.glob("*.json")):
            try:
                report = json.loads(report_path.read_text(encoding="utf-8-sig"))
            except (OSError, json.JSONDecodeError):
                continue
            reports.append({
                "job": report.get("job") or report_path.stem,
                "agent": report.get("agent") or report_path.stem,
                "status": report.get("status") or "unknown",
                "summary": report.get("summary") or "",
                "recommendation": report.get("recommendation") or "",
                "updated_at": report.get("updated_at"),
                "data": report.get("data") or {},
            })

    blocking_reason = None
    diag = next((report for report in reports if report.get("job") == "diag_runtime_health"), None)
    if not diag:
        blocking_reason = "diag_missing"
    else:
        diag_data = diag.get("data") or {}
        pipeline = diag_data.get("pipeline") or {}
        download = diag_data.get("download") or {}
        if pipeline.get("running"):
            blocking_reason = "pipeline_running"
        elif download.get("running"):
            blocking_reason = "download_running"

    with _task_lock:
        live_pipeline_running = bool(_task_state.get("running"))
    download_status_path = Path(
        app.config.get("DOWNLOAD_STATUS_PATH")
        or Path(__file__).parent / ".server_manager" / "download_status.json"
    )
    live_download_running = False
    if download_status_path.exists():
        try:
            download_state = json.loads(download_status_path.read_text(encoding="utf-8-sig"))
            live_download_running = bool(download_state.get("running"))
        except (OSError, json.JSONDecodeError):
            pass
    if live_pipeline_running:
        blocking_reason = "pipeline_running"
    elif live_download_running:
        blocking_reason = "download_running"

    return {
        "running": bool(status_data.get("running")),
        "status": status_data.get("action") or "unknown",
        "updated_at": status_data.get("updated_at"),
        "total": len(reports),
        "reports": reports,
        "safe_to_execute": blocking_reason is None,
        "blocking_reason": blocking_reason,
    }


def _truthy(value: Any) -> bool:
    return str(value or "").strip().lower() in {"1", "true", "yes", "on"}


def _format_csv_diagnosis_markdown(filename: str, diagnosis: dict[str, Any]) -> str:
    summary = diagnosis.get("diagnosis_summary") or diagnosis.get("summary") or ""
    rules = diagnosis.get("extracted_rules") or diagnosis.get("rules") or []
    stats = diagnosis.get("stats") or {}
    lines = [
        f"# CSV Diagnosis Report: {filename}",
        "",
        "## Summary",
        str(summary),
        "",
    ]
    if stats:
        lines.extend(["## Stats", ""])
        for key, value in stats.items():
            lines.append(f"- {key}: {value}")
        lines.append("")
    lines.extend(["## Extracted Rules (To be integrated into EA)", ""])
    if rules:
        lines.extend(f"- {rule}" for rule in rules)
    else:
        lines.append("- No explicit rules extracted.")
    lines.append("")
    return "\n".join(lines)


def _json_safe(value: Any) -> Any:
    if isinstance(value, Path):
        return str(value)
    return value


def create_app(config: dict | None = None) -> Flask:
    app = Flask(__name__)
    if config:
        app.config.update(config)

    # ------------------------------------------------------------------ #
    # OPTIONS pre-flight for all routes
    # ------------------------------------------------------------------ #

    @app.before_request
    def handle_options():
        if request.method == "OPTIONS":
            return _cors(Response("", status=204))

    # ------------------------------------------------------------------ #
    # GET /api/learning/status
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/status")
    def get_status():
        return _json(_status_counts(app))

    @app.route("/api/learning/health")
    def get_health():
        return _json({"status": "ok", "service": "ea-knowledge-brain"})

    def ea_registry_store() -> EARegistryStore:
        return EARegistryStore(_cfg(app, "EA_REGISTRY_PATH", str(DEFAULT_EA_REGISTRY_PATH)))

    def decision_journal_store() -> DecisionJournalStore:
        return DecisionJournalStore(
            _cfg(app, "DECISION_JOURNAL_PATH", str(DEFAULT_DECISION_JOURNAL_PATH)),
            ea_registry_store(),
        )

    def risk_gate_store() -> RiskGateStore:
        return RiskGateStore(
            _cfg(app, "RISK_GATE_PATH", str(DEFAULT_RISK_GATE_PATH)),
            ea_registry_store(),
        )

    def command_state_store() -> CommandStateStore:
        return CommandStateStore(
            _cfg(app, "COMMAND_STATE_PATH", str(DEFAULT_COMMAND_STATE_PATH)),
            ea_registry_store(),
        )

    def trade_record_reader() -> TradeRecordReader:
        return TradeRecordReader(_cfg(app, "TRADE_RECORDS_PATH", str(DEFAULT_TRADE_RECORDS_PATH)))

    def build_performance_comparison(
        *,
        ea_id: str,
        decision_stats: dict[str, Any],
        trade_stats: dict[str, Any],
        blade_intents: list[dict[str, Any]],
        command_state: dict[str, Any],
    ) -> dict[str, Any]:
        decision_total = int(decision_stats.get("total") or 0)
        trade_total = int(trade_stats.get("total_trades") or 0)
        rejected_count = sum(1 for item in blade_intents if item.get("status") == "rejected")
        blocked_count = sum(1 for item in blade_intents if item.get("status") == "blocked")
        net_pnl = trade_stats.get("net_pnl")
        risk_rejected = int(decision_stats.get("risk_rejected_count") or 0)
        summary_label = "no_trade_records"
        if trade_total:
            if (net_pnl or 0) > 0 and (risk_rejected or rejected_count or blocked_count):
                summary_label = "profitable_with_rejections"
            elif (net_pnl or 0) > 0:
                summary_label = "profitable"
            elif (net_pnl or 0) < 0:
                summary_label = "loss_making"
            else:
                summary_label = "breakeven"
        return {
            "ea_id": ea_id,
            "mode": "read_only",
            "decision_total": decision_total,
            "trade_total": trade_total,
            "decision_to_trade_ratio": round(decision_total / trade_total, 2) if trade_total else None,
            "win_rate": trade_stats.get("win_rate"),
            "net_pnl": net_pnl,
            "risk_rejected_count": risk_rejected,
            "blade_intents_total": len(blade_intents),
            "blade_rejected_count": rejected_count,
            "blade_blocked_count": blocked_count,
            "command_allowed": command_state.get("allowed"),
            "command_reasons": command_state.get("reasons") or [],
            "summary_label": summary_label,
        }

    def import_trade_records_from_csv(content: str, filename: str = "trade_records.csv") -> dict[str, Any]:
        if not content.strip():
            raise ValueError("content is required")
        reader = csv.DictReader(io.StringIO(content))
        if not reader.fieldnames:
            raise ValueError("CSV header is required")
        rows = list(reader)
        trade_path = Path(_cfg(app, "TRADE_RECORDS_PATH", str(DEFAULT_TRADE_RECORDS_PATH)))
        trade_path.parent.mkdir(parents=True, exist_ok=True)
        tmp = trade_path.with_suffix(".tmp")
        tmp.write_text(content, encoding="utf-8")
        tmp.replace(trade_path)
        return {
            "status": "imported",
            "filename": secure_filename(filename) or "trade_records.csv",
            "path": str(trade_path),
            "rows": len(rows),
            "source": "csv",
        }

    def build_operator_readiness() -> dict[str, Any]:
        registry = ea_registry_store()
        eas = registry.list_eas()
        journal = decision_journal_store()
        reader = trade_record_reader()
        blade = blade_executor()
        commands = command_state_store()
        details = []
        blocked_eas = 0
        with_comparison = 0
        eas_with_decisions = 0
        trade_sources = Counter()

        for ea in eas:
            ea_id = ea["ea_id"]
            decision_stats = journal.summarize(ea_id=ea_id)
            trade_stats = reader.summarize(ea_id=ea_id, magic_number=ea.get("magic_number"))
            blade_intents = blade.list_intents(ea_id=ea_id)
            command_state = commands.evaluate_decision({"ea_id": ea_id})
            comparison = build_performance_comparison(
                ea_id=ea_id,
                decision_stats=decision_stats,
                trade_stats=trade_stats,
                blade_intents=blade_intents,
                command_state=command_state,
            )
            with_comparison += 1 if comparison else 0
            blocked_eas += 0 if command_state.get("allowed") else 1
            eas_with_decisions += 1 if int(decision_stats.get("total") or 0) > 0 else 0
            trade_sources[trade_stats.get("source") or "unknown"] += 1
            details.append({"ea_id": ea_id, "comparison": comparison})

        all_blade_intents = blade.list_intents()
        trade_source = "not_connected"
        if trade_sources:
            trade_source = "csv" if trade_sources.get("csv") else next(iter(trade_sources))
        ready = bool(eas) and with_comparison == len(eas) and trade_source == "csv" and eas_with_decisions == len(eas)
        return {
            "mode": "dry_run_readiness",
            "ready": ready,
            "checks": {
                "api": {"ready": True},
                "ea_registry": {"ready": bool(eas), "total": len(eas)},
                "ea_detail": {"ready": with_comparison == len(eas), "with_comparison": with_comparison},
                "decision_coverage": {"ready": eas_with_decisions == len(eas), "eas_with_decisions": eas_with_decisions},
                "trade_records": {"ready": trade_source == "csv", "source": trade_source},
                "blade": {"ready": True, "total": len(all_blade_intents)},
                "command_state": {"ready": blocked_eas == 0, "blocked_eas": blocked_eas},
            },
            "eas": details,
            "operator_next_steps": [
                "Import latest MT5/backtest CSV when trade data changes.",
                "Ensure all active EAs have > 0 decisions logged in the Journal before proceeding live.",
                "Review EA Detail comparison before creating BLADE dry-run intents.",
                "Use Command State controls for start/stop/kill while order_send remains false.",
            ],
        }

    def export_operator_readiness_report(note: str = "") -> dict[str, Any]:
        readiness = build_operator_readiness()
        checks = readiness.get("checks") or {}
        reports_dir = Path(
            _cfg(app, "OPERATOR_REPORTS_DIR", str(Path(__file__).resolve().parents[2] / "raw"))
        )
        reports_dir.mkdir(parents=True, exist_ok=True)
        stamp = datetime.now(_TH_TZ).strftime("%Y%m%d_%H%M%S")
        filename = f"operator_readiness_{stamp}.md"
        path = reports_dir / filename
        lines = [
            "# Operator Readiness Report",
            "",
            f"generated_at: {datetime.now(_TH_TZ).isoformat(timespec='seconds')}",
            f"mode: {readiness.get('mode')}",
            f"ready: {str(readiness.get('ready')).lower()}",
            "",
            "## Summary",
            "",
            f"- ea_total: {checks.get('ea_registry', {}).get('total', 0)}",
            f"- comparison_count: {checks.get('ea_detail', {}).get('with_comparison', 0)}",
            f"- eas_with_decisions: {checks.get('decision_coverage', {}).get('eas_with_decisions', 0)}",
            f"- trade_source: {checks.get('trade_records', {}).get('source', 'unknown')}",
            f"- blade_total: {checks.get('blade', {}).get('total', 0)}",
            f"- blocked_eas: {checks.get('command_state', {}).get('blocked_eas', 0)}",
            "",
            "## Operator Next Steps",
            "",
        ]
        for step in readiness.get("operator_next_steps") or []:
            lines.append(f"- {step}")
        if note:
            lines.extend(["", "## Note", "", str(note)])
        lines.extend(["", "## Raw Readiness", "", "```json", json.dumps(readiness, ensure_ascii=False, indent=2), "```"])
        path.write_text("\n".join(lines) + "\n", encoding="utf-8")
        return {
            "status": "exported",
            "filename": filename,
            "path": str(path),
            "ready": readiness.get("ready"),
        }

    def latest_operator_report_snapshot() -> dict[str, Any]:
        reports_dir = Path(
            _cfg(app, "OPERATOR_REPORTS_DIR", str(Path(__file__).resolve().parents[2] / "raw"))
        )
        snapshot_name = re.compile(r"^operator_readiness_\d{8}_\d{6}\.md$")
        candidates = [
            item for item in reports_dir.glob("operator_readiness_*.md")
            if snapshot_name.match(item.name)
        ] if reports_dir.exists() else []
        reports = sorted(
            candidates,
            key=lambda item: item.stat().st_mtime,
            reverse=True,
        )
        if not reports:
            return {"ready": False, "latest_path": None, "latest_filename": None}
        latest = reports[0]
        return {
            "ready": True,
            "latest_path": str(latest),
            "latest_filename": latest.name,
        }

    def build_pre_live_checklist() -> dict[str, Any]:
        readiness = build_operator_readiness()
        readiness_checks = readiness.get("checks") or {}
        command_ready = bool((readiness_checks.get("command_state") or {}).get("ready"))
        operator_ready = bool(readiness.get("ready")) and command_ready
        intents = blade_executor().list_intents()
        blade_order_send_disabled = all(item.get("order_send") is False for item in intents)
        report_snapshot = latest_operator_report_snapshot()
        checks = {
            "operator_readiness": {
                "ready": operator_ready,
                "source_ready": bool(readiness.get("ready")),
            },
            "command_state": {
                "ready": command_ready,
                "blocked_eas": (readiness_checks.get("command_state") or {}).get("blocked_eas", 0),
            },
            "operator_report_snapshot": report_snapshot,
            "blade_order_send_disabled": {
                "ready": blade_order_send_disabled,
                "checked_intents": len(intents),
            },
            "live_execution_disabled": {
                "ready": True,
                "live_trading_enabled": False,
                "order_send_enabled": False,
            },
        }
        blocking_reasons = []
        for name, check in checks.items():
            if check.get("ready") is True:
                continue
            if name == "command_state":
                blocking_reasons.append("command_state_blocked")
            else:
                blocking_reasons.append(name)
        return {
            "mode": "pre_live_safety_checklist",
            "ready": not blocking_reasons,
            "live_trading_enabled": False,
            "order_send_enabled": False,
            "checks": checks,
            "blocking_reasons": blocking_reasons,
            "operator_readiness": readiness,
        }

    def blade_executor() -> BladeDryRunExecutor:
        registry = ea_registry_store()
        commands = CommandStateStore(
            _cfg(app, "COMMAND_STATE_PATH", str(DEFAULT_COMMAND_STATE_PATH)),
            registry,
        )
        return BladeDryRunExecutor(
            _cfg(app, "BLADE_INTENTS_PATH", str(DEFAULT_BLADE_INTENTS_PATH)),
            registry,
            commands,
        )

    @app.route("/api/trading/eas", methods=["GET"])
    def get_trading_eas():
        items = ea_registry_store().list_eas()
        return _json({"items": items, "total": len(items)})

    @app.route("/api/trading/eas", methods=["POST"])
    def post_trading_ea():
        body = request.get_json(silent=True) or {}
        try:
            ea = ea_registry_store().register_ea(body)
        except EARegistryError as exc:
            return _err(str(exc), 400)
        return _json({"ea": ea}, 201)

    @app.route("/api/trading/eas/<ea_id>", methods=["GET"])
    def get_trading_ea(ea_id: str):
        ea = ea_registry_store().get_ea(ea_id)
        if not ea:
            return _err("EA not found", 404)
        return _json({"ea": ea})

    @app.route("/api/trading/eas/<ea_id>/detail", methods=["GET"])
    def get_trading_ea_detail(ea_id: str):
        ea = ea_registry_store().get_ea(ea_id)
        if not ea:
            return _err("EA not found", 404)
        journal = decision_journal_store()
        decisions = journal.list_decisions(ea_id=ea_id)
        decision_stats = journal.summarize(ea_id=ea_id)
        trade_stats = trade_record_reader().summarize(
            ea_id=ea_id,
            magic_number=ea.get("magic_number"),
        )
        blade_intents = blade_executor().list_intents(ea_id=ea_id)
        command_state = command_state_store().evaluate_decision({"ea_id": ea_id})
        return _json({
            "ea": ea,
            "decision_stats": decision_stats,
            "recent_decisions": decisions[-12:],
            "trade_stats": trade_stats,
            "performance_comparison": build_performance_comparison(
                ea_id=ea_id,
                decision_stats=decision_stats,
                trade_stats=trade_stats,
                blade_intents=blade_intents,
                command_state=command_state,
            ),
        })

    @app.route("/api/trading/trade-records/import", methods=["POST"])
    def post_trading_trade_records_import():
        filename = "trade_records.csv"
        content = ""
        if request.files:
            upload = request.files.get("file")
            if not upload:
                return _err("file is required", 400)
            filename = upload.filename or filename
            content = upload.read().decode("utf-8-sig")
        else:
            body = request.get_json(silent=True) or {}
            filename = str(body.get("filename") or filename)
            content = str(body.get("content") or "")
        try:
            result = import_trade_records_from_csv(content, filename)
        except ValueError as exc:
            return _err(str(exc), 400)
        return _json({"trade_records": result}, 201)

    @app.route("/api/trading/operator-readiness", methods=["GET"])
    def get_trading_operator_readiness():
        return _json({"operator_readiness": build_operator_readiness()})

    @app.route("/api/trading/operator-readiness/export", methods=["POST"])
    def post_trading_operator_readiness_export():
        body = request.get_json(silent=True) or {}
        report = export_operator_readiness_report(str(body.get("note") or ""))
        return _json({"report": report}, 201)

    @app.route("/api/trading/pre-live-checklist", methods=["GET"])
    def get_trading_pre_live_checklist():
        return _json({"pre_live_checklist": build_pre_live_checklist()})

    @app.route("/api/trading/decisions", methods=["GET"])
    def get_trading_decisions():
        ea_id = request.args.get("ea_id") or None
        items = decision_journal_store().list_decisions(ea_id=ea_id)
        return _json({"items": items, "total": len(items)})

    @app.route("/api/trading/decisions", methods=["POST"])
    def post_trading_decision():
        body = request.get_json(silent=True) or {}
        try:
            decision = decision_journal_store().record_decision(body)
        except DecisionJournalError as exc:
            return _err(str(exc), 400)
        return _json({"decision": decision}, 201)

    @app.route("/api/trading/decision-stats", methods=["GET"])
    def get_trading_decision_stats():
        ea_id = request.args.get("ea_id") or None
        stats = decision_journal_store().summarize(ea_id=ea_id)
        return _json({"stats": stats})

    @app.route("/api/trading/risk/state", methods=["GET"])
    def get_trading_risk_state():
        return _json({"risk_gate": risk_gate_store().state()})

    @app.route("/api/trading/risk/evaluate", methods=["POST"])
    def post_trading_risk_evaluate():
        body = request.get_json(silent=True) or {}
        try:
            result = risk_gate_store().evaluate(body)
        except RiskGateError as exc:
            return _err(str(exc), 400)
        return _json({"risk_gate": result})

    @app.route("/api/trading/risk/kill", methods=["POST"])
    def post_trading_risk_kill():
        body = request.get_json(silent=True) or {}
        scope = str(body.get("scope") or "global").strip().lower()
        reason = str(body.get("reason") or "")
        gate = risk_gate_store()
        try:
            if scope == "global":
                state = gate.kill_global(reason)
            elif scope == "ea":
                state = gate.kill_ea(str(body.get("ea_id") or "").strip(), reason)
            else:
                return _err("scope must be global or ea", 400)
        except RiskGateError as exc:
            return _err(str(exc), 400)
        return _json({"risk_gate": state})

    @app.route("/api/trading/risk/resume", methods=["POST"])
    def post_trading_risk_resume():
        body = request.get_json(silent=True) or {}
        scope = str(body.get("scope") or "global").strip().lower()
        gate = risk_gate_store()
        try:
            if scope == "global":
                state = gate.resume_global()
            elif scope == "ea":
                state = gate.resume_ea(str(body.get("ea_id") or "").strip())
            else:
                return _err("scope must be global or ea", 400)
        except RiskGateError as exc:
            return _err(str(exc), 400)
        return _json({"risk_gate": state})

    @app.route("/api/trading/commands/state", methods=["GET"])
    def get_trading_command_state():
        return _json({"command_state": command_state_store().state()})

    @app.route("/api/trading/commands", methods=["POST"])
    def post_trading_command():
        body = request.get_json(silent=True) or {}
        try:
            command = command_state_store().dispatch(body)
        except CommandStateError as exc:
            return _err(str(exc), 400)
        return _json({"command": command}, 201)

    @app.route("/api/trading/commands/evaluate", methods=["POST"])
    def post_trading_command_evaluate():
        body = request.get_json(silent=True) or {}
        try:
            result = command_state_store().evaluate_decision(body)
        except CommandStateError as exc:
            return _err(str(exc), 400)
        return _json({"command_state": result})

    @app.route("/api/trading/blade/intents", methods=["GET"])
    def get_trading_blade_intents():
        ea_id = request.args.get("ea_id") or None
        items = blade_executor().list_intents(ea_id=ea_id)
        return _json({"items": items, "total": len(items)})

    @app.route("/api/trading/blade/dry-run", methods=["POST"])
    def post_trading_blade_dry_run():
        body = request.get_json(silent=True) or {}
        try:
            intent = blade_executor().create_intent(body)
        except (BladeExecutionError, CommandStateError) as exc:
            return _err(str(exc), 400)
        return _json({"intent": intent}, 201)

    @app.route("/api/learning/youtube-sources")
    def get_youtube_sources():
        return _json(_youtube_sources(app))

    # ------------------------------------------------------------------ #
    # POST /api/learning/scan-channel
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/scan-channel", methods=["POST"])
    def post_scan_channel():
        body = request.get_json(silent=True) or {}
        channel_url = (body.get("channel_url") or "").strip()
        if not channel_url:
            return _err("channel_url is required")
        manifest_path = _cfg(app, "MANIFEST_PATH", str(
            Path(__file__).with_name("channel_manifest.json")
        ))
        store = ChannelManifestStore(manifest_path)
        try:
            result = scan_channel(channel_url, store=store)
        except ValueError as exc:
            return _err(str(exc))
        except Exception as exc:
            return _err(str(exc), 500)
        return _json(result)

    # ------------------------------------------------------------------ #
    # POST /api/learning/learn-new
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/learn-new", methods=["POST"])
    def post_learn_new():
        global _task_state
        body = request.get_json(silent=True) or {}
        limit = body.get("limit", None)
        retry = bool(body.get("retry_needs_check", False))
        auto_pipeline = bool(body.get("auto_pipeline", True))
        manifest_path = _cfg(app, "MANIFEST_PATH", str(
            Path(__file__).with_name("channel_manifest.json")
        ))
        raw_dir = _cfg(app, "RAW_DIR", str(DEFAULT_RAW_DIR))
        store = ChannelManifestStore(manifest_path)
        result = learn_new_videos(
            store=store,
            raw_dir=raw_dir,
            limit=limit,
            retry_needs_check=retry,
        )
        if auto_pipeline and result.get("written", 0) > 0:
            with _task_lock:
                _task_state = {"running": True, "result": None, "error": None}
            t = threading.Thread(target=_run_bg_task, args=(_run_full_pipeline, app), daemon=True)
            t.start()
            return _json({**result, "pipeline": "started"})
        return _json({**result, "pipeline": None})

    # ------------------------------------------------------------------ #
    # POST /api/learning/universal-intake
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/universal-intake", methods=["POST"])
    def post_universal_intake():
        global _task_state
        import tempfile
        from urllib.parse import urlparse
        from web_scraper import scrape_website_text
        from channel_intake import scan_channel, learn_new_videos
        
        body = request.get_json(silent=True) or {}
        input_data = (body.get("input_data") or "").strip()
        auto_pipeline = bool(body.get("auto_pipeline", False))
        
        if not input_data:
            return _err("input_data is required")
            
        result = {}
        
        try:
            # 1. Is it a URL?
            if input_data.startswith("http://") or input_data.startswith("https://"):
                parsed = urlparse(input_data)
                domain = parsed.netloc.lower()
                
                # Youtube URL (Channel)
                if "youtube.com" in domain or "youtu.be" in domain:
                    if "@" in input_data or "/channel/" in input_data or "/c/" in input_data:
                        scan_res = scan_channel(input_data)
                        if scan_res.get("found", 0) > 0:
                            result = learn_new_videos(input_data, auto_pipeline=False)
                            result["message"] = f"Scanned channel and queued {scan_res.get('found')} videos. Started learning pending videos."
                        else:
                            result = {"status": "no_videos_found"}
                    else:
                        # Run download_pending_videos in the background for this URL
                        import subprocess
                        import sys
                        cmd = [sys.executable, "download_pending_videos.py", "--url", input_data]
                        if auto_pipeline:
                            cmd.append("--auto-pipeline")
                        subprocess.Popen(cmd, cwd=str(Path(__file__).parent))
                        
                        result = {
                            "status": "download_started",
                            "message": f"Started downloading and transcribing video sequentially in the background."
                        }
                        auto_pipeline = False # handled by the subprocess
                else:
                    # Generic web URL -> Scrape
                    scraped_text = scrape_website_text(input_data)
                    if not scraped_text:
                        return _err("Could not extract any text from the provided URL.")
                    with tempfile.NamedTemporaryFile(mode="w", delete=False, suffix=".txt", encoding="utf-8") as f:
                        f.write(scraped_text)
                        temp_path = f.name
                    
                    raw_dir = _cfg(app, "LOCAL_RAW_DIR", str(DEFAULT_LOCAL_RAW_DIR))
                    result = import_local_evidence(temp_path, raw_dir=raw_dir)
                    result["source_type"] = "web_scrape"
                    result["original_url"] = input_data
                    
            # 2. Is it a local file?
            elif Path(input_data).exists() and Path(input_data).is_file():
                raw_dir = _cfg(app, "LOCAL_RAW_DIR", str(DEFAULT_LOCAL_RAW_DIR))
                result = import_local_evidence(input_data, raw_dir=raw_dir)
                
            # 3. Otherwise, treat as raw text
            else:
                with tempfile.NamedTemporaryFile(mode="w", delete=False, suffix=".txt", encoding="utf-8") as f:
                    f.write(input_data)
                    temp_path = f.name
                    
                raw_dir = _cfg(app, "LOCAL_RAW_DIR", str(DEFAULT_LOCAL_RAW_DIR))
                result = import_local_evidence(temp_path, raw_dir=raw_dir, text=input_data)
                result["source_type"] = "raw_text_input"
                
        except Exception as exc:
            return _err(f"Universal Intake Error: {str(exc)}", 500)
            
        if auto_pipeline and (result.get("status") == "raw_evidence_written" or result.get("written", 0) > 0):
            with _task_lock:
                _task_state = {"running": True, "result": None, "error": None}
            t = threading.Thread(target=_run_bg_task, args=(_run_full_pipeline, app), daemon=True)
            t.start()
            return _json({**result, "pipeline": "started"})
            
        return _json({**result, "pipeline": None})

    # ------------------------------------------------------------------ #
    # POST /api/learning/universal-upload
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/universal-upload", methods=["POST"])
    def post_universal_upload():
        global _task_state
        uploads = request.files.getlist("files")
        if not uploads:
            return _err("files are required", 400)

        auto_pipeline = _truthy(request.form.get("auto_pipeline"))
        raw_dir = _cfg(app, "LOCAL_RAW_DIR", str(DEFAULT_LOCAL_RAW_DIR))
        imported = 0
        failed = 0
        file_results: list[dict[str, Any]] = []
        csv_exts = {".csv", ".xlsx"}

        with tempfile.TemporaryDirectory(prefix="ea_kb_upload_") as tmpdir:
            tmp_root = Path(tmpdir)
            for upload in uploads:
                original_name = upload.filename or "upload.bin"
                safe_name = secure_filename(original_name) or "upload.bin"
                suffix = Path(safe_name).suffix.lower()
                temp_path = tmp_root / safe_name
                upload.save(temp_path)

                try:
                    if suffix in csv_exts:
                        diagnosis = generate_csv_diagnosis(str(temp_path))
                        diagnosis_text = _format_csv_diagnosis_markdown(original_name, diagnosis)
                        diagnosis_path = tmp_root / f"{Path(safe_name).stem}_diagnosis.txt"
                        diagnosis_path.write_text(diagnosis_text, encoding="utf-8")
                        result = import_local_evidence(
                            diagnosis_path,
                            raw_dir=raw_dir,
                            text=diagnosis_text,
                        )
                        route = "csv_diagnosis"
                    else:
                        result = import_local_evidence(temp_path, raw_dir=raw_dir)
                        route = result.get("source_type") or "local_file"

                    ok = result.get("status") == "raw_evidence_written" or result.get("text_captured")
                    imported += 1 if ok else 0
                    failed += 0 if ok else 1
                    file_results.append({
                        "filename": original_name,
                        "route": route,
                        "status": _json_safe(result.get("status")),
                        "text_captured": _json_safe(result.get("text_captured")),
                        "note_path": _json_safe(result.get("note_path")),
                        "local_evidence_id": _json_safe(result.get("local_evidence_id")),
                    })
                except Exception as exc:
                    failed += 1
                    file_results.append({
                        "filename": original_name,
                        "route": "error",
                        "status": "failed",
                        "error": str(exc),
                    })

        pipeline = None
        if auto_pipeline and imported > 0:
            with _task_lock:
                _task_state = {"running": True, "result": None, "error": None}
            t = threading.Thread(target=_run_bg_task, args=(_run_full_pipeline, app), daemon=True)
            t.start()
            pipeline = "started"

        return _json({
            "status": "completed",
            "imported": imported,
            "failed": failed,
            "files": file_results,
            "pipeline": pipeline,
        })

    # ------------------------------------------------------------------ #
    # POST /api/learning/csv-diagnosis
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/csv-diagnosis", methods=["POST"])
    def post_csv_diagnosis():
        if 'file' not in request.files:
            return _err("No file uploaded", 400)
            
        file = request.files['file']
        if file.filename == '':
            return _err("No selected file", 400)
            
        if not file.filename.endswith(('.csv', '.xlsx')):
            return _err("Only CSV and XLSX files are supported", 400)
            
        import tempfile
        from csv_analyzer import generate_csv_diagnosis
        import os
        
        try:
            suffix = os.path.splitext(file.filename)[1]
            with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as tmp:
                file.save(tmp.name)
                tmp_path = tmp.name
                
            result = generate_csv_diagnosis(tmp_path)
            
            # Clean up
            os.remove(tmp_path)
            
            return _json(result)
        except Exception as exc:
            return _err(str(exc), 500)

    # ------------------------------------------------------------------ #
    # GET/POST /api/learning/import-local
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/import-local", methods=["POST"])
    def post_import_local():
        global _task_state
        body = request.get_json(silent=True) or {}
        source_path = (body.get("source_path") or "").strip()
        auto_pipeline = bool(body.get("auto_pipeline", False))
        if not source_path:
            return _err("source_path is required")
        raw_dir = _cfg(app, "LOCAL_RAW_DIR", str(DEFAULT_LOCAL_RAW_DIR))
        try:
            result = import_local_evidence(
                source_path,
                raw_dir=raw_dir,
                text=body.get("text"),
            )
        except FileNotFoundError as exc:
            return _err(str(exc), 404)
        except Exception as exc:
            return _err(str(exc), 400)
        result["note_path"] = str(result["note_path"])
        if auto_pipeline and result.get("status") == "raw_evidence_written":
            with _task_lock:
                _task_state = {"running": True, "result": None, "error": None}
            t = threading.Thread(target=_run_bg_task, args=(_run_full_pipeline, app), daemon=True)
            t.start()
            return _json({**result, "pipeline": "started"})
        return _json({**result, "pipeline": None})

    # ------------------------------------------------------------------ #
    # GET/POST /api/learning/remote-inbox
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/remote-inbox/status")
    def get_remote_inbox_status_route():
        inbox_root = _cfg(app, "REMOTE_INBOX_ROOT", str(DEFAULT_REMOTE_INBOX_ROOT))
        raw_dir = _cfg(app, "LOCAL_RAW_DIR", str(DEFAULT_LOCAL_RAW_DIR))
        try:
            return _json(get_remote_inbox_status(inbox_root, raw_dir=raw_dir))
        except Exception as exc:
            return _err(str(exc), 500)

    @app.route("/api/learning/remote-inbox/process", methods=["POST"])
    def post_remote_inbox_process():
        global _task_state
        body = request.get_json(silent=True) or {}
        auto_pipeline = bool(body.get("auto_pipeline", False))
        inbox_root = Path(body.get("inbox_root") or _cfg(app, "REMOTE_INBOX_ROOT", str(DEFAULT_REMOTE_INBOX_ROOT)))
        raw_dir = Path(body.get("raw_dir") or _cfg(app, "LOCAL_RAW_DIR", str(DEFAULT_LOCAL_RAW_DIR)))
        try:
            result = process_remote_inbox(inbox_root, raw_dir=raw_dir)
        except Exception as exc:
            return _err(str(exc), 500)
        if auto_pipeline and int(result.get("imported", 0) or 0) > 0:
            with _task_lock:
                _task_state = {"running": True, "result": None, "error": None}
            t = threading.Thread(target=_run_bg_task, args=(_run_full_pipeline, app), daemon=True)
            t.start()
            return _json({**result, "pipeline": "started"})
        return _json({**result, "pipeline": None})

    # ------------------------------------------------------------------ #
    # POST /api/learning/extract-raw
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/extract-raw", methods=["POST"])
    def post_extract_raw():
        raw_dir = _cfg(app, "RAW_DIR", str(DEFAULT_RAW_DIR))
        local_raw_dir = _cfg(app, "LOCAL_RAW_DIR", str(DEFAULT_LOCAL_RAW_DIR))
        structured_path = _cfg(app, "STRUCTURED_PATH", str(DEFAULT_EXTRACTION_PATH))
        manifest_path = _cfg(app, "MANIFEST_PATH", str(
            Path(__file__).with_name("channel_manifest.json")
        ))
        result = _extract_raw_dirs(
            raw_dirs=[raw_dir, local_raw_dir],
            structured_path=structured_path,
            manifest_path=manifest_path,
        )
        return _json(result)

    # ------------------------------------------------------------------ #
    # POST /api/learning/merge-knowledge
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/merge-knowledge", methods=["POST"])
    def post_merge_knowledge():
        structured_path = _cfg(app, "STRUCTURED_PATH", str(DEFAULT_STRUCTURED_PATH))
        index_path = _cfg(app, "INDEX_PATH", str(DEFAULT_INDEX_PATH))
        log_path = _cfg(app, "MERGE_LOG_PATH", str(DEFAULT_MERGE_LOG_PATH))
        index_store = KnowledgeIndexStore(index_path)
        result = merge_structured_extractions(
            structured_path=structured_path,
            index_store=index_store,
            merge_log_path=log_path,
        )
        return _json(result)

    # ------------------------------------------------------------------ #
    # POST /api/learning/write-concepts
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/write-concepts", methods=["POST"])
    def post_write_concepts():
        index_path = _cfg(app, "INDEX_PATH", str(DEFAULT_INDEX_PATH))
        structured_path = _cfg(app, "STRUCTURED_PATH", str(DEFAULT_STRUCTURED_PATH))
        concepts_dir = _cfg(app, "CONCEPTS_DIR", str(DEFAULT_CONCEPTS_DIR))
        result = write_concept_notes(
            index_path=index_path,
            structured_path=structured_path,
            output_dir=concepts_dir,
        )
        return _json(result)

    # ------------------------------------------------------------------ #
    # POST /api/learning/detect-conflicts
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/detect-conflicts", methods=["POST"])
    def post_detect_conflicts():
        index_path = _cfg(app, "INDEX_PATH", str(DEFAULT_INDEX_PATH))
        structured_path = _cfg(app, "STRUCTURED_PATH", str(DEFAULT_STRUCTURED_PATH))
        queue_path = _cfg(app, "CONFLICT_QUEUE_PATH", str(DEFAULT_CONFLICT_QUEUE_PATH))
        result = detect_conflicts(
            index_path=index_path,
            structured_path=structured_path,
            queue_path=queue_path,
        )
        return _json(result)

    # ------------------------------------------------------------------ #
    # POST /api/learning/run-pipeline
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/run-pipeline", methods=["POST"])
    def post_run_pipeline():
        global _task_state
        with _task_lock:
            if _task_state["running"]:
                return _json({"status": "already_running"}, 409)
            _task_state = {"running": True, "result": None, "error": None}
        t = threading.Thread(target=_run_bg_task, args=(_run_full_pipeline, app), daemon=True)
        t.start()
        return _json({"status": "started"})

    @app.route("/api/learning/pipeline-status")
    def get_pipeline_status():
        with _task_lock:
            return _json(_task_state.copy())

    # ------------------------------------------------------------------ #
    # POST /api/learning/sync-system
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/sync-system", methods=["POST"])
    def post_sync_system():
        global _sync_task_state
        with _task_lock:
            if _sync_task_state["running"]:
                return _json({"status": "already_running"}, 409)
            _sync_task_state = {"running": True, "result": None, "error": None}
        t = threading.Thread(target=_run_sync_task_bg, daemon=True)
        t.start()
        return _json({"status": "started"})
        
    @app.route("/api/learning/sync-status")
    def get_sync_status():
        with _task_lock:
            state = _sync_task_state.copy()
            # Also return timer info
            state["timer_idle_seconds"] = time.time() - _last_pipeline_activity
            state["needs_sync"] = _needs_system_sync
            return _json(state)

    # ------------------------------------------------------------------ #
    # GET /api/learning/youtube-status
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/youtube-status")
    def get_youtube_status():
        cookies_path = _cfg(app, "COOKIES_PATH", str(DEFAULT_COOKIES_PATH))
        has_cookies = cookies_path.exists()
        if not has_cookies:
            return _json({
                "status": "no_cookies",
                "has_cookies": False,
                "message": "No YouTube cookies saved",
            })

        result = _test_youtube_connection(cookies_path)
        status = result.get("status")
        if status == "error" and "IpBlocked" in str(result.get("error", "")):
            status = "blocked"
        return _json({
            **result,
            "status": status,
            "has_cookies": True,
            "message": result.get("message") or result.get("error") or "YouTube status checked",
        })

    # ------------------------------------------------------------------ #
    # GET /api/learning/trades
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/trades", methods=["GET"])
    def get_trades():
        try:
            base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
            trades_path = os.path.join(base_dir, 'trades_log.csv')
            vps_trades_path = os.path.join(base_dir, 'vps_data', 'trades_log.csv')
            
            # Prefer VPS synced trades if available and newer, otherwise use local
            final_path = trades_path
            if os.path.exists(vps_trades_path):
                if not os.path.exists(trades_path) or os.path.getmtime(vps_trades_path) > os.path.getmtime(trades_path):
                    final_path = vps_trades_path

            if not os.path.exists(final_path):
                return _cors(jsonify({"status": "error", "message": "trades_log.csv not found"})), 404
            
            with open(final_path, 'r', encoding='utf-8') as f:
                csv_data = f.read()
            resp = Response(csv_data, status=200, mimetype='text/csv')
            return _cors(resp)
        except Exception as e:
            return _cors(jsonify({"status": "error", "message": str(e)})), 500

    # ------------------------------------------------------------------ #
    # GET /dashboard
    # ------------------------------------------------------------------ #

    @app.route("/dashboard", methods=["GET"])
    def get_dashboard():
        try:
            base_dir = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
            dashboard_path = os.path.join(base_dir, '00_Dashboard', 'EA_Knowledge_Brain_Dashboard.html')
            with open(dashboard_path, 'r', encoding='utf-8') as f:
                html = f.read()
            return Response(html, mimetype='text/html')
        except Exception as e:
            return f"Error loading dashboard: {e}", 500

    # ------------------------------------------------------------------ #
    # GET /api/learning/telegram-status
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/telegram-status")
    def get_telegram_status():
        telegram_token = os.environ.get("TELEGRAM_BOT_TOKEN")
        
        # Try to read from telegram_token.txt if environment variable is not set
        token_file = Path(__file__).parent / "telegram_token.txt"
        if not telegram_token and token_file.exists():
            telegram_token = token_file.read_text().strip()
            
        if not telegram_token:
            return _json({
                "status": "unconfigured",
                "message": "TELEGRAM_BOT_TOKEN not found in environment or telegram_token.txt",
            })
        
        try:
            import requests
            resp = requests.get(f"https://api.telegram.org/bot{telegram_token}/getMe", timeout=3)
            if resp.status_code == 200:
                data = resp.json().get("result", {})
                bot_name = data.get("first_name", "Bot")
                bot_username = data.get("username", "")
                return _json({
                    "status": "ok",
                    "message": f"Connected to {bot_name} (@{bot_username})"
                })
            elif resp.status_code == 401:
                return _json({
                    "status": "offline",
                    "message": "Invalid Telegram Bot Token",
                })
            else:
                return _json({
                    "status": "offline",
                    "message": f"Telegram API error {resp.status_code}",
                })
        except Exception as exc:
            return _json({
                "status": "offline",
                "message": f"Connection error: {str(exc)}",
            })
        from youtube_channel_learning import _make_cookie_session, COOKIES_FILE
        from youtube_transcript_api import YouTubeTranscriptApi, IpBlocked, NoTranscriptFound, TranscriptsDisabled
        TEST_VIDEO = "1MiF19CBTOA"
        has_cookies = COOKIES_FILE.exists()
        try:
            session = _make_cookie_session()
            api = YouTubeTranscriptApi(http_client=session) if session else YouTubeTranscriptApi()
            tlist = api.list(TEST_VIDEO)
            for t in tlist:
                t.fetch()
                break
            return _json({"status": "ok", "has_cookies": has_cookies, "message": "YouTube accessible — ready to learn"})
        except IpBlocked:
            return _json({"status": "blocked", "has_cookies": has_cookies, "message": "IP blocked by YouTube — please wait"})
        except (NoTranscriptFound, TranscriptsDisabled):
            return _json({"status": "ok", "has_cookies": has_cookies, "message": "YouTube accessible (no transcript on test video)"})
        except Exception as e:
            return _json({"status": "error", "has_cookies": has_cookies, "message": str(e)[:120]})

    @app.route("/api/learning/engine-status")
    def get_engine_status():
        return _json(_engine_status(app))

    @app.route("/api/learning/ai-budget")
    def get_ai_budget():
        return _json(_ai_budget_status())

    @app.route("/api/learning/research-state")
    def get_research_state():
        return _json(build_research_state(
            manifest_path=_cfg(app, "MANIFEST_PATH", str(Path(__file__).with_name("channel_manifest.json"))),
            structured_path=_cfg(app, "STRUCTURED_PATH", str(DEFAULT_STRUCTURED_PATH)),
            index_path=_cfg(app, "INDEX_PATH", str(DEFAULT_INDEX_PATH)),
            conflict_queue_path=_cfg(app, "CONFLICT_QUEUE_PATH", str(DEFAULT_CONFLICT_QUEUE_PATH)),
            concepts_dir=_cfg(app, "CONCEPTS_DIR", str(DEFAULT_CONCEPTS_DIR)),
            components_path=_cfg(app, "COMPONENTS_PATH", str(DEFAULT_COMPONENTS_PATH)),
            blueprint_path=_cfg(app, "BLUEPRINT_PATH", str(DEFAULT_BLUEPRINT_PATH)),
        ))

    # ------------------------------------------------------------------ #
    # GET /api/learning/ea-components
    # POST /api/learning/ea-components  (re-run extractor)
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/ea-components", methods=["GET"])
    def get_ea_components():
        components_path = _cfg(app, "COMPONENTS_PATH", str(DEFAULT_COMPONENTS_PATH))
        data = _read_json(Path(components_path), {"components": {}, "summary": {}, "generated_at": None})
        return _json(data)

    @app.route("/api/learning/ea-components", methods=["POST"])
    def post_ea_components():
        index_path      = _cfg(app, "INDEX_PATH", str(DEFAULT_INDEX_PATH))
        structured_path = _cfg(app, "STRUCTURED_PATH", str(DEFAULT_STRUCTURED_PATH))
        components_path = _cfg(app, "COMPONENTS_PATH", str(DEFAULT_COMPONENTS_PATH))
        try:
            result = extract_ea_components_from_files(index_path, structured_path, components_path)
            return _json(result)
        except Exception as exc:
            return _err(str(exc))

    # ------------------------------------------------------------------ #
    # GET /api/learning/knowledge-index
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/knowledge-index")
    def get_knowledge_index():
        index_path = _cfg(app, "INDEX_PATH", str(DEFAULT_INDEX_PATH))
        if not index_path.exists():
            return _json({"version": 1, "concepts": {}})
        return _json(json.loads(index_path.read_text(encoding="utf-8")))

    # ------------------------------------------------------------------ #
    # GET /api/learning/manifest
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/manifest")
    def get_manifest():
        manifest_path = _cfg(app, "MANIFEST_PATH", str(
            Path(__file__).with_name("channel_manifest.json")
        ))
        if not Path(manifest_path).exists():
            return _json({"channels": {}, "videos": {}})
        return _json(json.loads(Path(manifest_path).read_text(encoding="utf-8")))

    # ------------------------------------------------------------------ #
    # GET /api/learning/blueprint
    # POST /api/learning/blueprint  (re-generate)
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/blueprint")
    def get_blueprint():
        blueprint_path = _cfg(app, "BLUEPRINT_PATH", str(DEFAULT_BLUEPRINT_PATH))
        if Path(blueprint_path).exists():
            return _json({"mql5_code": Path(blueprint_path).read_text(encoding="utf-8"), "summary": {}, "generated_at": None})
        return _json({"mql5_code": None, "summary": {}, "generated_at": None})

    @app.route("/api/learning/blueprint", methods=["POST"])
    def post_blueprint():
        components_path = _cfg(app, "COMPONENTS_PATH", str(DEFAULT_COMPONENTS_PATH))
        blueprint_path  = _cfg(app, "BLUEPRINT_PATH", str(DEFAULT_BLUEPRINT_PATH))
        try:
            result = generate_blueprint_from_files(
                components_path=components_path,
                output_path=blueprint_path,
            )
            return _json(result)
        except FileNotFoundError as exc:
            return _err(str(exc), 404)
        except Exception as exc:
            return _err(str(exc))

    # ------------------------------------------------------------------ #
    # GET /api/learning/conflicts
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/conflicts")
    def get_conflicts():
        queue_path = _cfg(app, "CONFLICT_QUEUE_PATH", str(DEFAULT_CONFLICT_QUEUE_PATH))
        store = ConflictReviewStore(queue_path)
        queue = store.load()
        items = list(queue["items"].values())

        status_filter   = request.args.get("status")
        concept_filter  = request.args.get("concept")
        type_filter     = request.args.get("type")
        severity_filter = request.args.get("severity")

        if status_filter:
            items = [i for i in items if i.get("status") == status_filter]
        if concept_filter:
            items = [i for i in items if i.get("concept") == concept_filter]
        if type_filter:
            items = [i for i in items if i.get("type") == type_filter]
        if severity_filter:
            items = [i for i in items if i.get("severity") == severity_filter]

        total = len(items)
        try:
            per_page = max(1, int(request.args.get("per_page", total or 1)))
            page = max(1, int(request.args.get("page", 1)))
        except (ValueError, TypeError):
            per_page = total or 1
            page = 1

        pages = max(1, -(-total // per_page))  # ceiling division
        start = (page - 1) * per_page
        paged = items[start: start + per_page]

        return _json({"items": paged, "total": total, "page": page, "pages": pages, "per_page": per_page})

    @app.route("/api/learning/conflicts/pending", methods=["GET"])
    def get_pending_conflicts_route():
        queue_path = _cfg(app, "CONFLICT_QUEUE_PATH", str(DEFAULT_CONFLICT_QUEUE_PATH))
        pending = get_pending_conflicts(queue_path)
        return _json({"items": pending, "total": len(pending)})

    @app.route("/api/learning/conflicts/resolve", methods=["POST"])
    def post_resolve_conflict():
        body = request.get_json(silent=True) or {}
        conflict_id = body.get("conflict_id")
        resolution = body.get("resolution")
        resolution_note = body.get("resolution_note", "")
        
        if not conflict_id or not resolution:
            return _err("conflict_id and resolution are required")
            
        queue_path = _cfg(app, "CONFLICT_QUEUE_PATH", str(DEFAULT_CONFLICT_QUEUE_PATH))
        success = resolve_conflict(conflict_id, resolution, resolution_note, queue_path)
        
        if not success:
            return _err(f"Conflict '{conflict_id}' not found", 404)
            
        return _json({"status": "resolved", "conflict_id": conflict_id})

    # ------------------------------------------------------------------ #
    # PATCH /api/learning/conflicts/<conflict_id>
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/conflicts/<conflict_id>", methods=["PATCH"])
    def patch_conflict(conflict_id: str):
        body = request.get_json(silent=True) or {}
        new_status = body.get("status")
        if not new_status:
            return _err("status is required")
        if new_status not in VALID_STATUSES:
            return _err(
                f"Invalid status '{new_status}'. "
                f"Must be one of: {', '.join(sorted(VALID_STATUSES))}"
            )
        queue_path = _cfg(app, "CONFLICT_QUEUE_PATH", str(DEFAULT_CONFLICT_QUEUE_PATH))
        store = ConflictReviewStore(queue_path)
        queue = store.load()
        if conflict_id not in queue["items"]:
            return _err(f"Conflict '{conflict_id}' not found", 404)
        queue["items"][conflict_id]["status"] = new_status
        store.save(queue)
        return _json(queue["items"][conflict_id])

    # ------------------------------------------------------------------ #
    # GET    /api/learning/settings/cookies  — status
    # POST   /api/learning/settings/cookies  — save Netscape cookies.txt
    # DELETE /api/learning/settings/cookies  — remove file
    # POST   /api/learning/settings/test-youtube — verify connectivity
    # ------------------------------------------------------------------ #

    @app.route("/api/learning/settings/cookies", methods=["GET"])
    def get_cookies_status():
        cookies_path = _cfg(app, "COOKIES_PATH", str(DEFAULT_COOKIES_PATH))
        exists = cookies_path.exists()
        return _json({
            "exists": exists,
            "size_bytes": cookies_path.stat().st_size if exists else 0,
            "path": str(cookies_path),
        })

    @app.route("/api/learning/settings/cookies", methods=["POST"])
    def save_cookies():
        body = request.get_json(silent=True) or {}
        content = body.get("content", "")
        if not content or not content.strip():
            return _err("content is required", 400)
        cookies_path = _cfg(app, "COOKIES_PATH", str(DEFAULT_COOKIES_PATH))
        stamp = datetime.now().strftime("%Y%m%d%H%M%S%f")
        tmp = cookies_path.with_suffix(f".tmp-{stamp}.txt")
        tmp.write_text(content, encoding="utf-8")
        tmp.replace(cookies_path)
        lines = len([l for l in content.splitlines() if l.strip() and not l.startswith("#")])
        return _json({"saved": True, "lines": lines, "size_bytes": cookies_path.stat().st_size})

    @app.route("/api/learning/settings/cookies", methods=["DELETE"])
    def delete_cookies():
        cookies_path = _cfg(app, "COOKIES_PATH", str(DEFAULT_COOKIES_PATH))
        if cookies_path.exists():
            cookies_path.unlink()
            return _json({"deleted": True})
        return _json({"deleted": False})

    @app.route("/api/learning/settings/test-youtube", methods=["POST"])
    def test_youtube():
        cookies_path = _cfg(app, "COOKIES_PATH", str(DEFAULT_COOKIES_PATH))
        if not cookies_path.exists():
            return _json({"status": "no_cookies",
                          "error": "No cookies file saved. Paste your YouTube cookies first."})
        result = _test_youtube_connection(cookies_path)
        return _json(result)

    @app.route("/api/learning/download-status", methods=["GET"])
    def get_download_status():
        status_path = Path(app.config.get("DOWNLOAD_STATUS_PATH") or Path(__file__).parent / ".server_manager" / "download_status.json")
        if not status_path.exists():
            return _json({"running": False, "status": "Not Running", "percent": 0})
        try:
            state = json.loads(status_path.read_text(encoding="utf-8-sig"))
            stale_seconds = int(app.config.get("DOWNLOAD_STATUS_STALE_SECONDS", 6 * 60 * 60))
            if state.get("running") and stale_seconds > 0:
                age_seconds = max(0, time.time() - status_path.stat().st_mtime)
                if age_seconds > stale_seconds:
                    return _json({
                        "running": False,
                        "status": "Stale download status",
                        "percent": 0,
                        "previous_status": state.get("status"),
                        "previous_video_id": state.get("current_video_id"),
                        "stale_age_seconds": int(age_seconds),
                    })
            return _json(state)
        except Exception:
            return _json({"running": False, "status": "Error reading status", "percent": 0})

    @app.route("/api/learning/parallel-agent-status", methods=["GET"])
    def get_parallel_agent_status():
        return _json(_parallel_agent_status(app))

    # MasterEA v3 polls this local endpoint. Keep the contract independent of
    # dashboard state so a missing signal fails safe as HOLD/no action.
    @app.route("/api/signals/latest", methods=["GET"])
    def get_latest_signal():
        symbol = (request.args.get("symbol") or "").strip()
        signal_path = Path(app.config.get("SIGNAL_FILE", Path(__file__).with_name("latest_signal.json")))
        if not signal_path.exists():
            return _json({"status": "ok", "signal": None})
        try:
            payload = json.loads(signal_path.read_text(encoding="utf-8-sig"))
        except (OSError, json.JSONDecodeError) as exc:
            return _err(f"Unable to read latest signal: {exc}", 500)
        if not symbol:
            return _json({"status": "ok", "signal": payload})
        signal = None
        if isinstance(payload, dict):
            if isinstance(payload.get(symbol), dict):
                signal = payload[symbol]
            elif str(payload.get("symbol", "")) == symbol:
                signal = payload
        return _json({"status": "ok", "signal": signal})
    return app


if __name__ == "__main__":
    app = create_app()
    print("EA Knowledge Brain API server")
    print("  http://localhost:5000")
    print("  GET  /api/learning/status")
    print("  POST /api/learning/scan-channel")
    print("  POST /api/learning/learn-new")
    print("  POST /api/learning/import-local")
    print("  POST /api/learning/extract-raw")
    print("  POST /api/learning/merge-knowledge")
    print("  POST /api/learning/write-concepts")
    print("  POST /api/learning/detect-conflicts")
    print("  POST /api/learning/run-pipeline")
    print("  GET  /api/learning/conflicts")
    print("  PATCH /api/learning/conflicts/<id>")
    app.run(
        debug=True,
        port=5000,
        use_reloader=os.environ.get("EA_KB_NO_RELOADER") != "1",
    )
