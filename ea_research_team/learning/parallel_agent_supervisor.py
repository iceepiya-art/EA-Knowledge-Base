from __future__ import annotations

import json
import os
import time
import urllib.error
import urllib.request
from concurrent.futures import ThreadPoolExecutor, as_completed
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any, Callable


TH_TZ = timezone(timedelta(hours=7))
LEARNING_DIR = Path(__file__).resolve().parent
WORKSPACE_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_STATE_DIR = LEARNING_DIR / ".server_manager"
DEFAULT_REPORTS_DIR = WORKSPACE_ROOT / ".agent_handoff" / "agent_reports"
DEFAULT_JOBOT_ROOT = Path("G:/My Drive/jobot")
DEFAULT_MQL_MANIFEST_PATH = WORKSPACE_ROOT / "DATA" / "raw" / "mql5_code_manifest.json"
DEFAULT_API_BASE = "http://127.0.0.1:5000/api/learning"
DEFAULT_MANAGER_STATUS_URL = "http://127.0.0.1:5050/api/manager/status"


@dataclass(frozen=True)
class SupervisorConfig:
    workspace_root: Path = WORKSPACE_ROOT
    jobot_root: Path = DEFAULT_JOBOT_ROOT
    mql_manifest_path: Path = DEFAULT_MQL_MANIFEST_PATH
    state_dir: Path = DEFAULT_STATE_DIR
    reports_dir: Path = DEFAULT_REPORTS_DIR
    api_base: str = DEFAULT_API_BASE
    manager_status_url: str = DEFAULT_MANAGER_STATUS_URL
    interval_seconds: int = 300
    max_workers: int = 4


@dataclass(frozen=True)
class AgentContext:
    workspace_root: Path
    jobot_root: Path
    mql_manifest_path: Path
    state_dir: Path
    reports_dir: Path
    manager_status_url: str
    api: Any


class ApiClient:
    def __init__(self, api_base: str) -> None:
        self.api_base = api_base.rstrip("/")

    def get(self, path: str) -> dict[str, Any]:
        with urllib.request.urlopen(self.api_base + path, timeout=10) as resp:
            return json.loads(resp.read().decode("utf-8"))


AgentJob = Callable[[AgentContext], dict[str, Any]]


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")


def _safe_int(value: Any) -> int:
    try:
        return int(value or 0)
    except (TypeError, ValueError):
        return 0


def _read_json_url(url: str, timeout: float = 2) -> dict[str, Any]:
    started = time.perf_counter()
    try:
        with urllib.request.urlopen(url, timeout=timeout) as resp:
            data = json.loads(resp.read().decode("utf-8"))
        return {"ok": True, "data": data, "latency_ms": int((time.perf_counter() - started) * 1000)}
    except Exception as exc:
        return {
            "ok": False,
            "data": {},
            "error": str(exc),
            "latency_ms": int((time.perf_counter() - started) * 1000),
        }


def _measure_api_latency(api: Any) -> int | None:
    started = time.perf_counter()
    try:
        api.get("/health")
    except Exception:
        return None
    return int((time.perf_counter() - started) * 1000)


def _json_readability(paths: list[Path]) -> dict[str, dict[str, Any]]:
    results: dict[str, dict[str, Any]] = {}
    for path in paths:
        entry: dict[str, Any] = {"exists": path.exists(), "readable": False}
        if path.exists():
            try:
                json.loads(path.read_text(encoding="utf-8-sig"))
                entry["readable"] = True
            except Exception as exc:
                entry["error"] = str(exc)
        results[path.name] = entry
    return results


def _report_freshness(reports_dir: Path, stale_after_minutes: int = 15) -> dict[str, Any]:
    now = datetime.now(TH_TZ)
    total = 0
    stale = 0
    unreadable = 0
    newest_age_seconds: int | None = None
    for report_path in (reports_dir.glob("*.json") if reports_dir.exists() else []):
        total += 1
        try:
            report = json.loads(report_path.read_text(encoding="utf-8-sig"))
            updated_at = report.get("updated_at")
            updated = datetime.fromisoformat(updated_at) if updated_at else None
        except Exception:
            unreadable += 1
            stale += 1
            continue
        if not updated:
            stale += 1
            continue
        age = int((now - updated).total_seconds())
        newest_age_seconds = age if newest_age_seconds is None else min(newest_age_seconds, age)
        if age > stale_after_minutes * 60:
            stale += 1
    return {
        "total": total,
        "stale_count": stale,
        "unreadable_count": unreadable,
        "newest_age_seconds": newest_age_seconds,
        "stale_after_minutes": stale_after_minutes,
    }


def _paid_api_guard() -> dict[str, Any]:
    paid_or_metered_env = [
        name
        for name in ("ANTHROPIC_API_KEY", "OPENAI_API_KEY", "GEMINI_API_KEY", "GOOGLE_API_KEY")
        if os.environ.get(name)
    ]
    return {
        "unknown_billing_treated_as_paid": True,
        "paid_loop_allowed": False,
        "configured_provider_env_count": len(paid_or_metered_env),
        "configured_provider_env_names": paid_or_metered_env,
    }


def _system_watchdog(context: AgentContext) -> dict[str, Any]:
    manager_probe = _read_json_url(context.manager_status_url, timeout=8)
    manager_data = manager_probe.get("data") or {}
    server_manager = {
        "ok": bool(manager_probe.get("ok")),
        "manager_online": bool(manager_data.get("manager_online")),
        "api_online": bool(manager_data.get("api_online")),
        "managed": bool(manager_data.get("managed")),
        "pid": manager_data.get("pid"),
        "auto_worker_managed": bool(manager_data.get("auto_worker_managed")),
        "parallel_supervisor_managed": bool(manager_data.get("parallel_supervisor_managed")),
        "telegram_managed": bool(manager_data.get("telegram_managed")),
        "latency_ms": manager_probe.get("latency_ms"),
    }
    runtime_files = _json_readability([
        context.state_dir / "download_status.json",
        context.state_dir / "parallel_agent_supervisor_status.json",
    ])
    freshness = _report_freshness(context.reports_dir)
    api_latency_ms = _measure_api_latency(context.api)
    warnings: list[str] = []
    if not server_manager["ok"]:
        warnings.append("server_manager_unreachable")
    elif not server_manager["managed"]:
        warnings.append("flask_api_not_managed")
    if api_latency_ms is None:
        warnings.append("flask_health_unavailable")
    for name, item in runtime_files.items():
        if item["exists"] and not item["readable"]:
            warnings.append(f"{name}_unreadable")
    if freshness["stale_count"]:
        warnings.append("stale_agent_reports")
    return {
        "server_manager": server_manager,
        "api_latency_ms": api_latency_ms,
        "runtime_files": runtime_files,
        "report_freshness": freshness,
        "paid_api_guard": _paid_api_guard(),
        "warnings": warnings,
    }


class ParallelAgentSupervisor:
    def __init__(
        self,
        config: SupervisorConfig | None = None,
        *,
        api: Any | None = None,
        jobs: dict[str, AgentJob] | None = None,
    ) -> None:
        self.config = config or SupervisorConfig()
        self.api = api or ApiClient(self.config.api_base)
        self.jobs = jobs or default_jobs()
        self.config.state_dir.mkdir(parents=True, exist_ok=True)
        self.config.reports_dir.mkdir(parents=True, exist_ok=True)
        self.status_path = self.config.state_dir / "parallel_agent_supervisor_status.json"

    def tick(self) -> dict[str, Any]:
        try:
            result = self._tick()
        except (urllib.error.URLError, TimeoutError, OSError) as exc:
            result = {"action": "api_unavailable", "error": str(exc), "reports": []}
        except Exception as exc:
            result = {"action": "error", "error": str(exc), "reports": []}
        self._write_status(result)
        return result

    def _tick(self) -> dict[str, Any]:
        context = AgentContext(
            workspace_root=self.config.workspace_root,
            jobot_root=self.config.jobot_root,
            mql_manifest_path=self.config.mql_manifest_path,
            state_dir=self.config.state_dir,
            reports_dir=self.config.reports_dir,
            manager_status_url=self.config.manager_status_url,
            api=self.api,
        )
        reports: list[dict[str, Any]] = []
        with ThreadPoolExecutor(max_workers=self.config.max_workers) as executor:
            futures = {
                executor.submit(job, context): name
                for name, job in self.jobs.items()
            }
            for future in as_completed(futures):
                name = futures[future]
                try:
                    report = future.result()
                except Exception as exc:
                    report = {
                        "agent": name,
                        "status": "error",
                        "summary": str(exc),
                        "recommendation": "Review this agent job before trusting its output.",
                    }
                report = {"job": name, "updated_at": _now_iso(), **report}
                self._write_report(name, report)
                reports.append(report)
        reports.sort(key=lambda item: item["job"])
        return {"action": "agent_reports", "total": len(reports), "reports": reports}

    def run_forever(self) -> None:
        while True:
            self.tick()
            time.sleep(self.config.interval_seconds)

    def _write_report(self, name: str, report: dict[str, Any]) -> None:
        path = self.config.reports_dir / f"{name}.json"
        self._write_json(path, report)

    def _write_status(self, result: dict[str, Any]) -> None:
        payload = {"running": True, "updated_at": _now_iso(), **result}
        self._write_json(self.status_path, payload)

    def _write_json(self, path: Path, payload: dict[str, Any]) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        tmp = path.with_suffix(".tmp")
        tmp.write_text(json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
        tmp.replace(path)


def default_jobs() -> dict[str, AgentJob]:
    return {
        "vera_knowledge_audit": vera_knowledge_audit,
        "nova_source_audit": nova_source_audit,
        "diag_runtime_health": diag_runtime_health,
        "momo_regime_data_audit": momo_regime_data_audit,
        "iris_chart_inbox_audit": iris_chart_inbox_audit,
        "penny_currency_data_audit": penny_currency_data_audit,
        "kira_macro_calendar_audit": kira_macro_calendar_audit,
        "scribe_handoff_audit": scribe_handoff_audit,
        "risco_rule_risk_audit": risco_rule_risk_audit,
        "nara_session_gate_audit": nara_session_gate_audit,
        "remy_backtest_artifact_audit": remy_backtest_artifact_audit,
        "hermes_conflict_triage_audit": hermes_conflict_triage_audit,
        "youtube_queue_audit": youtube_queue_audit,
    }


def _count_files(root: Path, patterns: tuple[str, ...], limit: int = 50) -> tuple[int, list[str]]:
    files: list[Path] = []
    if root.exists():
        for pattern in patterns:
            files.extend(path for path in root.rglob(pattern) if path.is_file())
    files = sorted(files)
    return len(files), [str(path) for path in files[:limit]]


def vera_knowledge_audit(context: AgentContext) -> dict[str, Any]:
    status = context.api.get("/status")
    concepts = status.get("concepts") or {}
    return {
        "agent": "Vera",
        "status": "ok" if status.get("blueprint_ready") else "warning",
        "summary": f"Knowledge base has {concepts.get('total', 0)} concepts and blueprint_ready={status.get('blueprint_ready')}.",
        "recommendation": "Use knowledge gaps from local reports before adding paid learning sources.",
        "data": {
            "concepts_total": concepts.get("total", 0),
            "avg_confidence": concepts.get("avg_confidence", 0),
            "blueprint_ready": status.get("blueprint_ready"),
        },
    }


def nova_source_audit(context: AgentContext) -> dict[str, Any]:
    try:
        import mql5_code_intake as intake
        manifest = intake.load_manifest(context.mql_manifest_path)
        candidates = intake.discover_mql_files(
            [context.jobot_root],
            manifest=manifest,
            limit=10,
        )
    except Exception:
        candidates = []
        if context.jobot_root.exists():
            for pattern in ("*.mq4", "*.mq5", "*.mqh"):
                candidates.extend(context.jobot_root.rglob(pattern))
            candidates = sorted(path for path in candidates if path.is_file())[:10]
    preview = [str(path) for path in candidates[:10]]
    command = f'mql5_code_intake.py --root "{context.jobot_root}" --limit 10 --workers 1'
    return {
        "agent": "Nova",
        "status": "ok",
        "summary": f"Found {len(candidates)} unprocessed MQL/source candidates for the next controlled batch.",
        "recommendation": "Queue a controlled source-first MQL batch when pipeline and download are idle.",
        "data": {
            "candidate_count": len(candidates),
            "preview": preview,
            "next_batch": preview,
            "command": command,
        },
    }


def momo_regime_data_audit(context: AgentContext) -> dict[str, Any]:
    count, preview = _count_files(context.workspace_root, ("*.csv",), limit=5)
    return {
        "agent": "Momo",
        "status": "ok" if count else "warning",
        "summary": f"Found {count} local CSV files for possible regime analysis.",
        "recommendation": "Use local CSV regime checks before requesting external market data.",
        "data": {"csv_count": count, "preview": preview},
    }


def iris_chart_inbox_audit(context: AgentContext) -> dict[str, Any]:
    count, preview = _count_files(context.workspace_root / "inbox", ("*.png", "*.jpg", "*.jpeg", "*.webp"), limit=5)
    return {
        "agent": "Iris",
        "status": "ok" if count else "warning",
        "summary": f"Found {count} chart/image inbox files for manual or approved vision analysis.",
        "recommendation": "Do not run vision analysis automatically; wait for explicit chart task.",
        "data": {"image_count": count, "preview": preview},
    }


def penny_currency_data_audit(context: AgentContext) -> dict[str, Any]:
    count, preview = _count_files(context.workspace_root, ("*strength*.csv", "*currency*.csv", "*mmf*.csv"), limit=5)
    return {
        "agent": "Penny",
        "status": "ok" if count else "warning",
        "summary": f"Found {count} local currency-strength/MMF data files.",
        "recommendation": "Prefer local/free currency data before paid market APIs.",
        "data": {"currency_data_count": count, "preview": preview},
    }


def kira_macro_calendar_audit(context: AgentContext) -> dict[str, Any]:
    count, preview = _count_files(context.workspace_root, ("*COT*.pdf", "*cot*.pdf", "*calendar*.json", "*news*.json"), limit=5)
    return {
        "agent": "Kira",
        "status": "ok" if count else "warning",
        "summary": f"Found {count} local macro/calendar/COT files.",
        "recommendation": "Use local or verified-free macro sources before paid APIs.",
        "data": {"macro_file_count": count, "preview": preview},
    }


def diag_runtime_health(context: AgentContext) -> dict[str, Any]:
    pipeline = context.api.get("/pipeline-status")
    download = context.api.get("/download-status")
    status = context.api.get("/status")
    watchdog = _system_watchdog(context)
    pipeline_running = bool(pipeline.get("running"))
    download_running = bool(download.get("running"))
    if pipeline_running or download_running:
        recommendation = "Keep write-heavy jobs paused until pipeline and download are idle."
    else:
        recommendation = "Write-heavy jobs may be considered after a fresh status check."
    videos = status.get("videos") or {}
    concepts = status.get("concepts") or {}
    conflicts = status.get("conflicts") or {}
    pipeline_result = pipeline.get("result") or {}
    blueprint = pipeline_result.get("blueprint") or {}
    compact_pipeline = {
        "running": pipeline_running,
        "error": pipeline.get("error"),
    }
    if blueprint.get("generated_at"):
        compact_pipeline["generated_at"] = blueprint.get("generated_at")
    compact_download = {
        "running": download_running,
        "status": download.get("status"),
        "current_index": download.get("current_index"),
        "total": download.get("total"),
        "success": download.get("success"),
        "failed": download.get("failed"),
    }
    compact_status = {
        "blueprint_ready": status.get("blueprint_ready"),
        "concepts_total": concepts.get("total"),
        "ea_rules": status.get("ea_rules"),
        "conflicts_pending": conflicts.get("pending"),
        "videos": videos,
    }
    report_status = "warning" if watchdog["warnings"] else "ok"
    return {
        "agent": "Diag",
        "status": report_status,
        "summary": (
            f"pipeline_running={pipeline_running}, download_running={download_running}, "
            f"learned={videos.get('learned')}, needs_check={videos.get('needs_check')}, "
            f"watchdog_warnings={len(watchdog['warnings'])}."
        ),
        "recommendation": recommendation,
        "data": {
            "pipeline": compact_pipeline,
            "download": compact_download,
            "learning_status": compact_status,
            "watchdog": watchdog,
        },
    }


def nara_session_gate_audit(context: AgentContext) -> dict[str, Any]:
    now = datetime.now(TH_TZ)
    hour = now.hour
    asia = 6 <= hour < 14
    london = 14 <= hour < 22
    new_york = hour >= 19 or hour < 3
    active = [name for name, enabled in {"asia": asia, "london": london, "new_york": new_york}.items() if enabled]
    return {
        "agent": "Nara",
        "status": "ok",
        "summary": f"Current TH hour={hour}; active session gates={','.join(active) if active else 'none'}.",
        "recommendation": "Use session gate as advisory only until EA rules explicitly consume it.",
        "data": {"th_hour": hour, "active_sessions": active},
    }


def remy_backtest_artifact_audit(context: AgentContext) -> dict[str, Any]:
    count, preview = _count_files(context.workspace_root, ("*trades*.csv", "*Report*.htm", "*Report*.html"), limit=5)
    return {
        "agent": "Remy",
        "status": "ok" if count else "warning",
        "summary": f"Found {count} local backtest/trade report artifacts.",
        "recommendation": "Use local backtest artifacts before launching new backtest loops.",
        "data": {"artifact_count": count, "preview": preview},
    }


def scribe_handoff_audit(context: AgentContext) -> dict[str, Any]:
    active_plan = context.workspace_root / ".agent_handoff" / "ACTIVE_PLAN.json"
    if not active_plan.exists():
        return {
            "agent": "Scribe",
            "status": "warning",
            "summary": "ACTIVE_PLAN.json is missing.",
            "recommendation": "Create ACTIVE_PLAN.json before continuing coordinated work.",
        }
    data = json.loads(active_plan.read_text(encoding="utf-8-sig"))
    next_actions = data.get("next_actions") or []
    return {
        "agent": "Scribe",
        "status": "ok",
        "summary": f"Active plan status={data.get('status')} with {len(next_actions)} next actions.",
        "recommendation": "Keep ACTIVE_PLAN.json current after each verified task.",
        "data": {
            "last_updated": data.get("last_updated"),
            "current_step": data.get("current_step"),
            "next_action_count": len(next_actions),
        },
    }


def risco_rule_risk_audit(context: AgentContext) -> dict[str, Any]:
    status = context.api.get("/status")
    rule_count = _safe_int(status.get("ea_rules"))
    conflict_total = _safe_int((status.get("conflicts") or {}).get("total"))
    conflict_pending = _safe_int((status.get("conflicts") or {}).get("pending"))
    if conflict_pending:
        recommendation = "Review pending conflicts before expanding EA blueprint rules."
        report_status = "warning"
    else:
        recommendation = "Risk audit can focus on rule quality because no pending conflicts are reported."
        report_status = "ok"
    return {
        "agent": "Risco",
        "status": report_status,
        "summary": f"EA rules={rule_count}, conflicts_total={conflict_total}, conflicts_pending={conflict_pending}.",
        "recommendation": recommendation,
        "data": {
            "ea_rules": rule_count,
            "conflicts_total": conflict_total,
            "conflicts_pending": conflict_pending,
        },
    }


def hermes_conflict_triage_audit(context: AgentContext) -> dict[str, Any]:
    status = context.api.get("/status")
    pending = _safe_int((status.get("conflicts") or {}).get("pending"))
    return {
        "agent": "Hermes",
        "status": "warning" if pending else "ok",
        "summary": f"Pending conflicts={pending}; auto paid judging remains disabled.",
        "recommendation": "Build local evidence packets first; use Gemini Pro only one high-impact conflict at a time after approval.",
        "data": {"conflicts_pending": pending, "auto_resolve_enabled": False},
    }


def youtube_queue_audit(context: AgentContext) -> dict[str, Any]:
    status = context.api.get("/status")
    videos = status.get("videos") or {}
    needs_check = _safe_int(videos.get("needs_check"))
    return {
        "agent": "YouTube",
        "status": "warning" if needs_check else "ok",
        "summary": f"YouTube/VDO queue has {needs_check} needs_check items; intake remains paused.",
        "recommendation": "Do not start VDO/YouTube intake without explicit one-item local-only approval.",
        "data": {"needs_check": needs_check, "auto_intake_enabled": False},
    }


def main() -> int:
    ParallelAgentSupervisor().run_forever()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
