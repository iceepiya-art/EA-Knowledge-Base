"""EA Component Extractor — groups rule candidates from knowledge index into EA components.

Reads:
  - knowledge_index.json
  - structured_extractions.json
  - master_concepts.json (canonical mappings)

Writes:
  - ea_components.json  (categorized reusable building blocks)
"""
from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any

TH_TZ = timezone(timedelta(hours=7))

# Mapping from structured_extractions keys to new canonical categories
CATEGORY_MAP = {
    "entry": "Entry Components",
    "exit": "Exit Components",
    "stop_loss": "Risk Components",  # Maps stop loss to risk
    "filter": "Filter Components",
    "regime": "Filter Components"    # Regime acts as a filter
}

DEFAULT_INDEX_PATH = Path(__file__).with_name("knowledge_index.json")
DEFAULT_STRUCTURED_PATH = Path(__file__).with_name("structured_extractions.json")
DEFAULT_MASTER_CONCEPTS_PATH = Path(__file__).with_name("master_concepts.json")
DEFAULT_OUTPUT_PATH = Path(__file__).with_name("ea_components.json")

def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")

def load_canonical_map(master_concepts_path: Path) -> dict[str, str]:
    if not master_concepts_path.exists():
        print(f"Warning: {master_concepts_path} not found. Using raw concepts.")
        return {}
        
    data = json.loads(master_concepts_path.read_text(encoding="utf-8"))
    canonical_map = {}
    for item in data.get("consolidated_concepts", []):
        canon = item.get("concept")
        aliases = item.get("aliases", [])
        canonical_map[canon] = canon
        for alias in aliases:
            canonical_map[alias] = canon
    return canonical_map

def extract_ea_components(
    knowledge_index: dict[str, Any],
    structured_extractions: dict[str, Any],
    canonical_map: dict[str, str]
) -> dict[str, Any]:
    
    # comp_category -> rule_key -> {rule, sources, canonical_concepts, frequency}
    buckets: dict[str, dict[str, Any]] = {
        "Entry Components": {},
        "Exit Components": {},
        "Filter Components": {},
        "Risk Components": {}
    }

    for video_id, item in structured_extractions.get("items", {}).items():
        raw_concepts = item.get("concepts") or []
        
        # Translate to canonical
        canon_concepts = []
        for c in raw_concepts:
            canon = canonical_map.get(c, c)
            if canon not in canon_concepts:
                canon_concepts.append(canon)
                
        candidates = item.get("ea_rule_candidates") or {}

        for raw_comp_type, rules in candidates.items():
            mapped_category = CATEGORY_MAP.get(raw_comp_type)
            if not mapped_category:
                continue
                
            for rule_text in rules:
                rule_text = rule_text.strip()
                if not rule_text:
                    continue
                
                key = rule_text.lower()
                if key not in buckets[mapped_category]:
                    buckets[mapped_category][key] = {
                        "rule": rule_text,
                        "sources": [],
                        "canonical_concepts": [],
                        "frequency": 0,
                    }
                
                entry = buckets[mapped_category][key]
                if video_id not in entry["sources"]:
                    entry["sources"].append(video_id)
                
                for c in canon_concepts:
                    if c not in entry["canonical_concepts"]:
                        entry["canonical_concepts"].append(c)
                
                entry["frequency"] += 1

    components: dict[str, list[dict[str, Any]]] = {}
    for cat in buckets.keys():
        rules = sorted(buckets[cat].values(), key=lambda r: r["frequency"], reverse=True)
        components[cat] = rules

    total_rules = sum(len(v) for v in components.values())

    return {
        "version": "2.0 (Phase 4)",
        "generated_at": _now_iso(),
        "components": components,
        "summary": {
            "total_rules": total_rules,
            "categories": list(buckets.keys())
        },
    }

def extract_from_files(
    index_path: str | Path = DEFAULT_INDEX_PATH,
    structured_path: str | Path = DEFAULT_STRUCTURED_PATH,
    master_path: str | Path = DEFAULT_MASTER_CONCEPTS_PATH,
    output_path: str | Path = DEFAULT_OUTPUT_PATH,
) -> dict[str, Any]:
    
    knowledge_index = json.loads(Path(index_path).read_text(encoding="utf-8"))
    structured = json.loads(Path(structured_path).read_text(encoding="utf-8"))
    canonical_map = load_canonical_map(Path(master_path))
    
    result = extract_ea_components(knowledge_index, structured, canonical_map)
    
    Path(output_path).parent.mkdir(parents=True, exist_ok=True)
    Path(output_path).write_text(json.dumps(result, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
    
    return result

def main(argv: list[str] | None = None) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    parser = argparse.ArgumentParser(description="EA Component Extractor Phase 4")
    parser.add_argument("--index",      default=str(DEFAULT_INDEX_PATH))
    parser.add_argument("--structured", default=str(DEFAULT_STRUCTURED_PATH))
    parser.add_argument("--master",     default=str(DEFAULT_MASTER_CONCEPTS_PATH))
    parser.add_argument("--output",     default=str(DEFAULT_OUTPUT_PATH))
    args = parser.parse_args(argv)
    
    result = extract_from_files(args.index, args.structured, args.master, args.output)
    s = result["summary"]
    print(json.dumps({
        "total_rules": s["total_rules"],
        "categories": s["categories"],
        "output": args.output,
    }, ensure_ascii=False))
    return 0

if __name__ == "__main__":
    sys.exit(main())
