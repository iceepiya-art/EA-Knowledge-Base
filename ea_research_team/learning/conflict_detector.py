"""Conflict Detection + Review Queue.

Reads knowledge_index.json and structured_extractions.json, detects:
  1. contradiction  — opposing rules for the same concept across sources
  2. low_confidence — concept confidence < 60
  3. low_evidence   — concept has only 1 source video
  4. incomplete_rule — concept missing entry or stop_loss rule type

Output: conflict_review_queue.json (idempotent — uses conflict_id as key).
Existing items with status != "pending" are preserved unchanged.
"""
from __future__ import annotations

import hashlib
import json
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any

from knowledge_merger import DEFAULT_INDEX_PATH
from structured_extractor import DEFAULT_EXTRACTION_PATH


TH_TZ = timezone(timedelta(hours=7))
DEFAULT_CONFLICT_QUEUE_PATH = Path(__file__).with_name("conflict_review_queue.json")

LOW_CONFIDENCE_THRESHOLD = 60
LOW_CONFIDENCE_HIGH_THRESHOLD = 40
SINGLE_SOURCE_LIMIT = 1
MAX_RULE_LEN = 300

# Keywords that indicate direction contradiction in entry/stop_loss rules
_BUY_KEYWORDS = {"buy", "long", "bullish", "above", "uptrend", "support"}
_SELL_KEYWORDS = {"sell", "short", "bearish", "below", "downtrend", "resistance"}


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")


def make_conflict_id(concept: str, conflict_type: str, sources: list[str]) -> str:
    key = f"{concept}:{conflict_type}:{','.join(sorted(sources))}"
    return hashlib.sha256(key.encode("utf-8")).hexdigest()[:12]


class ConflictReviewStore:
    def __init__(self, path: str | Path = DEFAULT_CONFLICT_QUEUE_PATH):
        self.path = Path(path)

    def load(self) -> dict[str, Any]:
        if not self.path.exists():
            return {"version": 1, "items": {}}
        data = json.loads(self.path.read_text(encoding="utf-8"))
        data.setdefault("version", 1)
        data.setdefault("items", {})
        return data

    def save(self, data: dict[str, Any]) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        tmp = self.path.with_suffix(f".tmp-{datetime.now().strftime('%Y%m%d%H%M%S%f')}.json")
        tmp.write_text(json.dumps(data, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
        tmp.replace(self.path)


def _load_structured(path: Path | None) -> dict[str, Any]:
    if path is None or not path.exists():
        return {"version": 1, "items": {}}
    data = json.loads(path.read_text(encoding="utf-8"))
    data.setdefault("items", {})
    return data


def _direction_set(text: str) -> frozenset[str]:
    words = set(text.lower().split())
    dirs: set[str] = set()
    if words & _BUY_KEYWORDS:
        dirs.add("buy")
    if words & _SELL_KEYWORDS:
        dirs.add("sell")
    return frozenset(dirs)


def _is_contradictory(rule_a: str, rule_b: str) -> bool:
    dir_a = _direction_set(rule_a)
    dir_b = _direction_set(rule_b)

    # Opposite trade directions for the same concept are contradictory until
    # a human explicitly resolves them as separate market regimes/contexts.
    if (dir_a == frozenset(["buy"]) and dir_b == frozenset(["sell"])) or \
       (dir_a == frozenset(["sell"]) and dir_b == frozenset(["buy"])):
        return True

    # They might contradict if they are for the SAME direction (or neither) 
    # but contain opposing positional/structural keywords.
    words_a = set(rule_a.lower().split())
    words_b = set(rule_b.lower().split())
    
    opposing_pairs = [
        ("above", "below"), 
        ("high", "low"), 
        ("support", "resistance"), 
        ("uptrend", "downtrend")
    ]
    
    for w1, w2 in opposing_pairs:
        if (w1 in words_a and w2 in words_b) or (w2 in words_a and w1 in words_b):
            return True

    return False


def _short_rule(rules: list[str]) -> list[str]:
    return [r for r in rules if r and len(r) <= MAX_RULE_LEN]


def _collect_rules_by_source(
    concept_name: str,
    source_ids: list[str],
    structured: dict[str, Any],
    rule_type: str,
) -> dict[str, list[str]]:
    result: dict[str, list[str]] = {}
    for vid in source_ids:
        item = structured["items"].get(vid, {})
        if concept_name not in item.get("concepts", []):
            continue
        rules = _short_rule(item.get("ea_rule_candidates", {}).get(rule_type, []))
        if rules:
            result[vid] = rules
    return result


def _detect_contradictions(
    concept_name: str,
    concept: dict[str, Any],
    structured: dict[str, Any],
) -> list[dict[str, Any]]:
    sources = concept.get("sources", [])
    found: list[dict[str, Any]] = []

    for rule_type in ("entry", "stop_loss"):
        by_source = _collect_rules_by_source(concept_name, sources, structured, rule_type)
        source_ids = sorted(by_source)
        for idx, source_a in enumerate(source_ids):
            for source_b in source_ids[idx + 1:]:
                for rule_a in by_source[source_a]:
                    for rule_b in by_source[source_b]:
                        if not _is_contradictory(rule_a, rule_b):
                            continue
                        conflict_sources = [source_a, source_b]
                        cid = make_conflict_id(
                            concept_name,
                            f"contradiction_{rule_type}",
                            conflict_sources,
                        )
                        found.append(_build_conflict_item(
                            conflict_id=cid,
                            concept=concept_name,
                            severity="high",
                            conflict_type="contradiction",
                            summary=(
                                f"Conflicting {rule_type} rules found for "
                                f"{concept_name} across sources"
                            ),
                            affected_sources=conflict_sources,
                            rule_a=rule_a,
                            rule_b=rule_b,
                            suggested_action="manual_review",
                        ))
    return found


def _build_conflict_item(
    *,
    conflict_id: str,
    concept: str,
    severity: str,
    conflict_type: str,
    summary: str,
    affected_sources: list[str],
    rule_a: str | None = None,
    rule_b: str | None = None,
    variants: list[dict[str, Any]] | None = None,
    suggested_action: str,
) -> dict[str, Any]:
    return {
        "conflict_id": conflict_id,
        "concept": concept,
        "severity": severity,
        "type": conflict_type,
        "summary": summary,
        "affected_sources": affected_sources,
        "rule_a": rule_a,
        "rule_b": rule_b,
        "variants": variants or [],
        "suggested_action": suggested_action,
        "status": "pending",
        "detected_at": _now_iso(),
    }


def _detect_low_confidence(concept_name: str, concept: dict[str, Any]) -> dict[str, Any] | None:
    conf = concept.get("confidence", 100)
    if conf >= LOW_CONFIDENCE_THRESHOLD:
        return None
    sources = concept.get("sources", [])
    cid = make_conflict_id(concept_name, "low_confidence", sources)
    severity = "high" if conf < LOW_CONFIDENCE_HIGH_THRESHOLD else "medium"
    return _build_conflict_item(
        conflict_id=cid,
        concept=concept_name,
        severity=severity,
        conflict_type="low_confidence",
        summary=f"Confidence ต่ำ ({conf}/100) — ยังต้องการหลักฐานจาก source เพิ่มเติม",
        affected_sources=sources,
        suggested_action="manual_review",
    )


def _detect_low_evidence(concept_name: str, concept: dict[str, Any]) -> dict[str, Any] | None:
    ev = concept.get("evidence_count", len(concept.get("sources", [])))
    if ev > SINGLE_SOURCE_LIMIT:
        return None
    sources = concept.get("sources", [])
    cid = make_conflict_id(concept_name, "low_evidence", sources)
    return _build_conflict_item(
        conflict_id=cid,
        concept=concept_name,
        severity="low",
        conflict_type="low_evidence",
        summary=f"มีแหล่งข้อมูลเพียง {ev} คลิป — ควรหาแหล่งยืนยันเพิ่มก่อนนำไปใช้ใน EA",
        affected_sources=sources,
        suggested_action="manual_review",
    )


def _detect_incomplete_rule(concept_name: str, concept: dict[str, Any]) -> list[dict[str, Any]]:
    rule_types = set(concept.get("related_rule_types", []))
    sources = concept.get("sources", [])
    items: list[dict[str, Any]] = []
    missing = [rt for rt in ("entry", "stop_loss") if rt not in rule_types]
    if not missing:
        return []
    cid = make_conflict_id(concept_name, "incomplete_rule", sources)
    missing_str = " และ ".join(missing)
    return [
        _build_conflict_item(
            conflict_id=cid,
            concept=concept_name,
            severity="medium",
            conflict_type="incomplete_rule",
            summary=f"EA rule ยังไม่ครบ — ขาด {missing_str} rule",
            affected_sources=sources,
            suggested_action="manual_review",
        )
    ]


def _detect_variant_divergence(
    concept_name: str,
    concept: dict[str, Any],
) -> list[dict[str, Any]]:
    variants_dict = concept.get("rule_variants", {})
    found: list[dict[str, Any]] = []
    
    for rule_type, variants in variants_dict.items():
        if len(variants) > 1:
            sorted_variants = sorted(variants, key=lambda x: x["score"], reverse=True)
            v1 = sorted_variants[0]
            v2 = sorted_variants[1]
            
            sources = []
            for v in variants:
                sources.extend(v.get("sources", []))
            sources = list(set(sources))
            
            cid = make_conflict_id(
                concept_name,
                f"divergence_{rule_type}",
                sources,
            )
            item = _build_conflict_item(
                conflict_id=cid,
                concept=concept_name,
                severity="medium",
                conflict_type="variant_divergence",
                summary=(
                    f"พบกฎ {rule_type} มีหลายรูปแบบให้เลือก ({len(variants)} Variants)"
                ),
                affected_sources=sources,
                rule_a=f"[{v1['score']} เสียง] {v1['text']}",
                rule_b=f"[{v2['score']} เสียง] {v2['text']}",
                variants=sorted_variants,
                suggested_action="auto_merged",
            )
            # Auto-resolve variants based on design philosophy (keep both, scored)
            item["status"] = "merge_as_condition"
            item["resolution"] = "merge_as_condition"
            item["resolution_note"] = "Auto-resolved: kept variants for situational context based on user preference."
            found.append(item)
    return found


def detect_conflicts(
    *,
    index_path: str | Path = DEFAULT_INDEX_PATH,
    structured_path: str | Path | None = None,
    queue_path: str | Path = DEFAULT_CONFLICT_QUEUE_PATH,
) -> dict[str, Any]:
    index_path = Path(index_path)
    queue_path = Path(queue_path)

    if structured_path is None:
        structured_path = DEFAULT_EXTRACTION_PATH
    sp = Path(structured_path)
    structured = _load_structured(sp if sp.exists() else None)

    if not index_path.exists():
        store = ConflictReviewStore(queue_path)
        data = store.load()
        store.save(data)
        return {
            "total": 0, "new": 0, "existing": 0,
            "low_confidence": 0, "low_evidence": 0,
            "incomplete_rule": 0, "contradiction": 0,
            "queue_path": str(queue_path),
        }

    index = json.loads(index_path.read_text(encoding="utf-8"))
    concepts = index.get("concepts", {})

    store = ConflictReviewStore(queue_path)
    queue = store.load()
    existing_items = queue["items"]

    stats: dict[str, int] = {
        "total": 0, "new": 0, "existing": 0,
        "low_confidence": 0, "low_evidence": 0,
        "incomplete_rule": 0, "contradiction": 0,
        "variant_divergence": 0,
    }

    for concept_name, concept_data in concepts.items():
        candidates: list[dict[str, Any]] = []

        lc = _detect_low_confidence(concept_name, concept_data)
        if lc:
            candidates.append(lc)

        le = _detect_low_evidence(concept_name, concept_data)
        if le:
            candidates.append(le)

        candidates.extend(_detect_incomplete_rule(concept_name, concept_data))
        candidates.extend(_detect_contradictions(concept_name, concept_data, structured))
        candidates.extend(_detect_variant_divergence(concept_name, concept_data))

        for item in candidates:
            cid = item["conflict_id"]
            stats["total"] += 1
            if cid in existing_items:
                stats["existing"] += 1
            else:
                existing_items[cid] = item
                stats["new"] += 1
                stats[item["type"]] += 1

    queue["items"] = existing_items
    queue["generated_at"] = _now_iso()
    store.save(queue)

    stats["queue_path"] = str(queue_path)
    return stats


def get_pending_conflicts(
    queue_path: str | Path = DEFAULT_CONFLICT_QUEUE_PATH,
) -> list[dict[str, Any]]:
    queue_path = Path(queue_path)
    store = ConflictReviewStore(queue_path)
    queue = store.load()
    
    pending = []
    for cid, item in queue.get("items", {}).items():
        if item.get("status") == "pending":
            pending.append(item)
            
    return pending


def resolve_conflict(
    conflict_id: str,
    resolution: str,
    resolution_note: str,
    queue_path: str | Path = DEFAULT_CONFLICT_QUEUE_PATH,
) -> bool:
    queue_path = Path(queue_path)
    store = ConflictReviewStore(queue_path)
    queue = store.load()
    
    if conflict_id not in queue.get("items", {}):
        return False
        
    item = queue["items"][conflict_id]
    item["status"] = "resolved"
    item["resolution"] = resolution
    item["resolution_note"] = resolution_note
    item["resolved_at"] = _now_iso()
    
    store.save(queue)
    return True
