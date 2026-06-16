import json
import hashlib
import argparse
import sys
from datetime import datetime, timezone
from pathlib import Path

CODE_INSIGHTS_PATH = Path(r"g:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\data\raw\mql5_code_insights.json")
INDEX_PATH = Path(r"g:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\learning\knowledge_index.json")

def _hash(s: str) -> str:
    return hashlib.sha1(s.encode("utf-8")).hexdigest()[:8]

def _ensure_code_concept_schema(concept_node: dict) -> None:
    concept_node.setdefault("confidence", 90)
    concept_node.setdefault("evidence_count", 0)
    concept_node.setdefault("related_rule_types", [])
    if "execution_logic" not in concept_node["related_rule_types"]:
        concept_node["related_rule_types"].append("execution_logic")
    concept_node.setdefault("source_details", [])
    concept_node.setdefault("sources", [])
    concept_node.setdefault("rule_variants", {})
    concept_node["rule_variants"].setdefault("execution_logic", [])

def main(argv=None):
    parser = argparse.ArgumentParser(description="Merge extracted MQL code insights into knowledge_index.json.")
    parser.parse_args([] if argv is None else argv)

    if not CODE_INSIGHTS_PATH.exists():
        print("Code insights file missing.")
        return
        
    insights = json.loads(CODE_INSIGHTS_PATH.read_text(encoding="utf-8"))
    
    if INDEX_PATH.exists():
        index_data = json.loads(INDEX_PATH.read_text(encoding="utf-8"))
    else:
        index_data = {"concepts": {}}
        
    now_iso = datetime.now(timezone.utc).isoformat()
    merged_count = 0
    
    for item in insights:
        topic = f"MQL5 Code: {item.get('topic')}"
        source_file = item.get('source_file')
        file_id = _hash(source_file) if source_file else "unknown_file"
        
        if topic not in index_data["concepts"]:
            index_data["concepts"][topic] = {
                "concept": topic,
                "confidence": item.get('confidence', 90),
                "evidence_count": 0,
                "last_updated": now_iso,
                "related_rule_types": ["execution_logic"],
                "rule_variants": {
                    "execution_logic": []
                },
                "source_details": [],
                "sources": []
            }
            
        concept_node = index_data["concepts"][topic]
        _ensure_code_concept_schema(concept_node)
        
        # Add source if new
        if file_id not in concept_node["sources"]:
            concept_node["sources"].append(file_id)
            concept_node["evidence_count"] += 1
            concept_node["source_details"].append({
                "video_id": file_id,
                "url": source_file,
                "title": Path(source_file).name if source_file else "Local MQL5 File",
                "ea_readiness": 100,
                "rule_completeness": 100,
                "merged_at": now_iso
            })
            
        # Add rule variant for execution_logic
        variant_text = f"Category: {item.get('category', 'General')}\nDescription: {item.get('description', '')}\nCode Snippet: {item.get('code_snippet', '')}"
        variant_id = _hash(variant_text)
        
        exists = any(v["variant_id"] == variant_id for v in concept_node["rule_variants"]["execution_logic"])
        if not exists:
            concept_node["rule_variants"]["execution_logic"].append({
                "variant_id": variant_id,
                "text": variant_text,
                "score": 1.0,
                "sources": [file_id]
            })
            merged_count += 1
            
        concept_node["last_updated"] = now_iso

    INDEX_PATH.write_text(json.dumps(index_data, indent=2, ensure_ascii=False), encoding="utf-8")
    print(f"Merged {merged_count} code execution rules into knowledge_index.json!")

if __name__ == "__main__":
    main(sys.argv[1:])
