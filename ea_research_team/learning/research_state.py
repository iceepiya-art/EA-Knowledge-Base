from __future__ import annotations

import json
from collections import Counter
from pathlib import Path
from typing import Any


LEARNED_VIDEO_STATUSES = {
    "raw_evidence_written",
    "structured_extracted",
    "written_to_obsidian",
    "learned",
}


def _read_json(path: Path, default: Any) -> Any:
    if not path.exists():
        return default
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return default


def _as_items(value: Any) -> list[dict[str, Any]]:
    if isinstance(value, dict):
        return [item for item in value.values() if isinstance(item, dict)]
    if isinstance(value, list):
        return [item for item in value if isinstance(item, dict)]
    return []


def _pct(done: int, total: int) -> int:
    if total <= 0:
        return 0
    return max(0, min(100, int(round((done / total) * 100))))


def _readiness_rank(value: Any) -> int:
    return {"low": 1, "medium": 2, "high": 3}.get(str(value or "").lower(), 0)


def _quality_status(*, pending_high: int, low_confidence: int, missing_components: int, concepts: int) -> str:
    if pending_high > 0:
        return "blocked"
    if concepts == 0 or low_confidence > 0 or missing_components > 0:
        return "needs_review"
    return "pass"


def _stage_and_action(metrics: dict[str, Any], blueprint_ready: bool) -> tuple[dict[str, str], dict[str, str]]:
    videos = metrics["videos"]
    concepts = metrics["concepts"]
    conflicts = metrics["conflicts"]
    components = metrics["components"]

    if videos["total"] == 0:
        return (
            {"id": "intake_needed", "label": "Intake Needed"},
            {"id": "ingest_evidence", "label": "Ingest evidence", "command": "Process Input"},
        )
    if conflicts["pending_high"] > 0 or conflicts["pending"] >= 10:
        return (
            {"id": "conflict_review", "label": "Conflict Review"},
            {"id": "review_conflicts", "label": "Review high-impact conflicts", "command": "Review Conflicts"},
        )
    if videos["needs_check"] > 0:
        return (
            {"id": "transcript_review", "label": "Transcript Review"},
            {"id": "retry_needs_check", "label": "Retry needs-check videos", "command": "Retry Needs Check"},
        )
    if metrics["structured"]["total"] == 0:
        return (
            {"id": "raw_extraction", "label": "Raw Extraction"},
            {"id": "extract_raw", "label": "Extract raw evidence", "command": "Run Extract Raw"},
        )
    if concepts["total"] == 0:
        return (
            {"id": "knowledge_merge", "label": "Knowledge Merge"},
            {"id": "merge_knowledge", "label": "Merge knowledge", "command": "Run Merge Knowledge"},
        )
    if concepts["notes_written"] < concepts["total"]:
        return (
            {"id": "obsidian_sync", "label": "Obsidian Sync"},
            {"id": "write_concepts", "label": "Write concept notes", "command": "Write Concepts"},
        )
    if components["total_rules"] == 0 or components["missing"]:
        return (
            {"id": "ea_component_review", "label": "EA Component Review"},
            {"id": "extract_components", "label": "Extract EA components", "command": "Run EA Components"},
        )
    if not blueprint_ready:
        return (
            {"id": "blueprint_ready", "label": "Blueprint Ready"},
            {"id": "build_blueprint", "label": "Build EA blueprint", "command": "Build Blueprint"},
        )
    return (
        {"id": "ready_for_review", "label": "Ready For Research Review"},
        {"id": "review_ea_idea", "label": "Review EA idea quality", "command": "Review EA Idea"},
    )


def build_research_state(
    *,
    manifest_path: Path,
    structured_path: Path,
    index_path: Path,
    conflict_queue_path: Path,
    concepts_dir: Path,
    components_path: Path,
    blueprint_path: Path,
) -> dict[str, Any]:
    manifest = _read_json(manifest_path, {"channels": {}, "videos": {}})
    videos = _as_items(manifest.get("videos", {}) if isinstance(manifest, dict) else {})
    channels = manifest.get("channels", {}) if isinstance(manifest, dict) else {}

    video_status = Counter(video.get("status", "discovered") for video in videos)
    learned = sum(1 for video in videos if video.get("status") in LEARNED_VIDEO_STATUSES)
    needs_check = video_status.get("needs_transcript_check", 0)
    failed = video_status.get("failed", 0)

    structured = _read_json(structured_path, {"items": {}})
    structured_items = _as_items(structured.get("items", structured) if isinstance(structured, dict) else structured)

    index = _read_json(index_path, {"concepts": {}})
    concept_items = _as_items(index.get("concepts", {}) if isinstance(index, dict) else {})
    confidence_values = [
        float(concept.get("confidence") or 0)
        for concept in concept_items
        if isinstance(concept.get("confidence"), (int, float))
    ]
    low_confidence = sum(1 for value in confidence_values if value < 60)
    avg_confidence = round(sum(confidence_values) / len(confidence_values)) if confidence_values else 0
    weak_evidence = sum(1 for concept in concept_items if int(concept.get("evidence_count") or 0) < 2)
    rule_backed = sum(1 for concept in concept_items if concept.get("related_rule_types"))
    notes_written = len(list(concepts_dir.glob("*.md"))) if concepts_dir.exists() else 0

    conflicts = _read_json(conflict_queue_path, {"items": {}})
    conflict_items = _as_items(conflicts.get("items", {}) if isinstance(conflicts, dict) else {})
    pending_conflicts = [item for item in conflict_items if item.get("status", "pending") == "pending"]
    pending_high = sum(1 for item in pending_conflicts if item.get("severity") == "high")

    components = _read_json(components_path, {})
    component_summary = components.get("summary", {}) if isinstance(components, dict) else {}
    missing_components = component_summary.get("components_missing", []) or []
    complete_components = component_summary.get("components_complete", []) or []
    total_rules = int(component_summary.get("total_rules") or 0)
    component_readiness = component_summary.get("ea_readiness") or "low"

    blueprint = _read_json(blueprint_path, {})
    blueprint_ready = bool(blueprint_path.exists() and isinstance(blueprint, dict) and (blueprint.get("summary") or blueprint.get("mql5_code")))

    metrics = {
        "channels": {"total": len(channels) if isinstance(channels, dict) else 0},
        "videos": {
            "total": len(videos),
            "learned": learned,
            "needs_check": needs_check,
            "failed": failed,
            "learned_percent": _pct(learned, len(videos)),
        },
        "structured": {"total": len(structured_items)},
        "concepts": {
            "total": len(concept_items),
            "notes_written": notes_written,
            "avg_confidence": avg_confidence,
            "low_confidence": low_confidence,
            "weak_evidence": weak_evidence,
            "rule_backed": rule_backed,
        },
        "conflicts": {
            "total": len(conflict_items),
            "pending": len(pending_conflicts),
            "pending_high": pending_high,
        },
        "components": {
            "total_rules": total_rules,
            "complete": complete_components,
            "missing": missing_components,
            "readiness": component_readiness,
        },
        "blueprint": {"ready": blueprint_ready},
    }

    stage, action = _stage_and_action(metrics, blueprint_ready)
    quality_status = _quality_status(
        pending_high=pending_high,
        low_confidence=low_confidence,
        missing_components=len(missing_components),
        concepts=len(concept_items),
    )

    readiness_parts = [
        metrics["videos"]["learned_percent"],
        _pct(len(structured_items), max(1, learned)),
        _pct(len(concept_items), max(1, len(structured_items))),
        100 - min(100, pending_high * 25 + max(0, len(pending_conflicts) - 3) * 5),
        _pct(total_rules, 5),
        100 if blueprint_ready else 70 if _readiness_rank(component_readiness) >= 3 else 45 if total_rules else 20,
    ]
    readiness_percent = round(sum(readiness_parts) / len(readiness_parts))

    blockers: list[str] = []
    if pending_high:
        blockers.append(f"{pending_high} high-severity conflicts need review")
    if low_confidence:
        blockers.append(f"{low_confidence} concepts are below 60% confidence")
    if missing_components:
        blockers.append("Missing EA components: " + ", ".join(str(x) for x in missing_components[:4]))
    if failed:
        blockers.append(f"{failed} evidence items failed intake")

    return {
        "stage": stage,
        "recommended_action": action,
        "quality_gate": {
            "status": quality_status,
            "label": {"pass": "Pass", "needs_review": "Needs Review", "blocked": "Blocked"}[quality_status],
            "blockers": blockers,
        },
        "readiness_percent": max(0, min(100, readiness_percent)),
        "metrics": metrics,
    }
