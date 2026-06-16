from __future__ import annotations

import hashlib
import json
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any


TH_TZ = timezone(timedelta(hours=7))
DEFAULT_STRUCTURED_PATH = Path(__file__).with_name("structured_extractions.json")
DEFAULT_INDEX_PATH = Path(__file__).with_name("knowledge_index.json")
DEFAULT_MERGE_LOG_PATH = Path(__file__).with_name("knowledge_merge_log.json")


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")


class KnowledgeIndexStore:
    def __init__(self, path: str | Path = DEFAULT_INDEX_PATH):
        self.path = Path(path)

    def load(self) -> dict[str, Any]:
        if not self.path.exists():
            return {"version": 1, "concepts": {}}
        data = json.loads(self.path.read_text(encoding="utf-8"))
        if not isinstance(data, dict):
            raise ValueError("knowledge_index.json must contain a JSON object")
        data.setdefault("version", 1)
        data.setdefault("concepts", {})
        return data

    def save(self, data: dict[str, Any]) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        tmp_path = self.path.with_suffix(f".tmp-{datetime.now().strftime('%Y%m%d%H%M%S%f')}.json")
        tmp_path.write_text(json.dumps(data, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
        tmp_path.replace(self.path)


def _load_structured(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {"version": 1, "items": {}}
    data = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data, dict):
        raise ValueError("structured_extractions.json must contain a JSON object")
    data.setdefault("version", 1)
    data.setdefault("items", {})
    return data


def _load_merge_log(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {"version": 1, "events": []}
    data = json.loads(path.read_text(encoding="utf-8"))
    if not isinstance(data, dict):
        raise ValueError("knowledge_merge_log.json must contain a JSON object")
    data.setdefault("version", 1)
    data.setdefault("events", [])
    return data


def _save_json(path: Path, data: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp_path = path.with_suffix(f".tmp-{datetime.now().strftime('%Y%m%d%H%M%S%f')}.json")
    tmp_path.write_text(json.dumps(data, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
    tmp_path.replace(path)


def _confidence_from_sources(concept: dict[str, Any]) -> int:
    scores = [source.get("ea_readiness", 0) for source in concept.get("source_details", [])]
    if not scores:
        return int(concept.get("confidence", 0))
    return int(round(sum(scores) / len(scores)))


def _make_variant_id(text: str) -> str:
    return hashlib.sha256(text.strip().lower().encode("utf-8")).hexdigest()[:8]


def _update_rule_variants(concept: dict[str, Any], item: dict[str, Any]) -> None:
    variants = concept.setdefault("rule_variants", {})
    video_id = item.get("video_id", "")
    candidates = item.get("ea_rule_candidates", {})
    
    for rule_type, rules in candidates.items():
        if not rules:
            continue
        type_variants = variants.setdefault(rule_type, [])
        for rule_text in rules:
            if not isinstance(rule_text, str):
                continue
            rule_text = rule_text.strip()
            if not rule_text:
                continue
            
            found = False
            for v in type_variants:
                if v["text"].lower() == rule_text.lower():
                    if video_id not in v["sources"]:
                        v["sources"].append(video_id)
                        v["score"] += 1
                    found = True
                    break
            
            if not found:
                type_variants.append({
                    "variant_id": _make_variant_id(rule_text),
                    "text": rule_text,
                    "score": 1,
                    "sources": [video_id]
                })


def _new_concept(concept_name: str, item: dict[str, Any]) -> dict[str, Any]:
    video_id = item["video_id"]
    readiness = int(item.get("quality", {}).get("ea_readiness", 0))
    ans = {
        "concept": concept_name,
        "confidence": readiness,
        "evidence_count": 1,
        "sources": [video_id],
        "source_details": [
            {
                "video_id": video_id,
                "title": item.get("title", ""),
                "url": item.get("url", ""),
                "ea_readiness": readiness,
                "rule_completeness": int(item.get("quality", {}).get("rule_completeness", 0)),
                "merged_at": _now_iso(),
            }
        ],
        "related_rule_types": sorted(
            rule_type
            for rule_type, values in item.get("ea_rule_candidates", {}).items()
            if values
        ),
        "rule_variants": {},
        "last_updated": _now_iso(),
    }
    _update_rule_variants(ans, item)
    return ans


def _event(merge_type: str, concept_name: str, item: dict[str, Any]) -> dict[str, Any]:
    return {
        "timestamp": _now_iso(),
        "merge_type": merge_type,
        "concept": concept_name,
        "video_id": item.get("video_id", ""),
        "title": item.get("title", ""),
        "url": item.get("url", ""),
    }


def _merge_item_into_concept(
    *,
    concept_name: str,
    item: dict[str, Any],
    index: dict[str, Any],
) -> str:
    concepts = index["concepts"]
    video_id = item["video_id"]
    if concept_name not in concepts:
        concepts[concept_name] = _new_concept(concept_name, item)
        return "new"

    concept = concepts[concept_name]
    sources = concept.setdefault("sources", [])
    if video_id in sources:
        return "unchanged"

    readiness = int(item.get("quality", {}).get("ea_readiness", 0))
    sources.append(video_id)
    concept.setdefault("source_details", []).append(
        {
            "video_id": video_id,
            "title": item.get("title", ""),
            "url": item.get("url", ""),
            "ea_readiness": readiness,
            "rule_completeness": int(item.get("quality", {}).get("rule_completeness", 0)),
            "merged_at": _now_iso(),
        }
    )
    existing_rule_types = set(concept.get("related_rule_types", []))
    for rule_type, values in item.get("ea_rule_candidates", {}).items():
        if values:
            existing_rule_types.add(rule_type)
    concept["related_rule_types"] = sorted(existing_rule_types)
    concept["evidence_count"] = len(sources)
    concept["confidence"] = _confidence_from_sources(concept)
    concept["last_updated"] = _now_iso()
    _update_rule_variants(concept, item)
    return "reinforce"


def merge_structured_extractions(
    *,
    structured_path: str | Path = DEFAULT_STRUCTURED_PATH,
    index_store: KnowledgeIndexStore | None = None,
    merge_log_path: str | Path = DEFAULT_MERGE_LOG_PATH,
) -> dict[str, Any]:
    structured = _load_structured(Path(structured_path))
    store = index_store or KnowledgeIndexStore()
    log_path = Path(merge_log_path)
    index = store.load()
    log = _load_merge_log(log_path)

    result = {
        "processed_items": 0,
        "concepts_seen": 0,
        "new": 0,
        "reinforce": 0,
        "unchanged": 0,
        "conflict": 0,
        "index_path": str(store.path),
        "merge_log_path": str(log_path),
    }

    for item in structured["items"].values():
        result["processed_items"] += 1
        for concept_name in item.get("concepts", []):
            result["concepts_seen"] += 1
            merge_type = _merge_item_into_concept(
                concept_name=concept_name,
                item=item,
                index=index,
            )
            result[merge_type] += 1
            if merge_type != "unchanged":
                log["events"].append(_event(merge_type, concept_name, item))

    store.save(index)
    _save_json(log_path, log)
    return result
