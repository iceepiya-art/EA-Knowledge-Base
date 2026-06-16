"""Strategy Pattern Miner — discovers recurring combinations of EA components.

Reads:
  - ea_components.json
  - structured_extractions.json

Outputs:
  - strategy_families.json
"""
import argparse
import json
import sys
from collections import defaultdict
from pathlib import Path

DEFAULT_STRUCTURED_PATH = Path(__file__).with_name("structured_extractions.json")
DEFAULT_COMPONENTS_PATH = Path(__file__).with_name("ea_components.json")
DEFAULT_OUTPUT_PATH = Path(__file__).with_name("strategy_families.json")

def mine_patterns(structured_path: Path, components_path: Path, output_path: Path):
    if not structured_path.exists() or not components_path.exists():
        print("Required files missing.")
        return

    structured = json.loads(structured_path.read_text(encoding="utf-8"))
    
    # We want to look at each video/source and see what canonical components it uses.
    # To do this, we collect all canonical concepts per source that map to an Entry, Filter, Exit, or Risk.
    
    # First, let's map canonical concepts to their component category based on ea_components.json
    components_data = json.loads(components_path.read_text(encoding="utf-8"))
    concept_to_category = {}
    
    for category, rules in components_data.get("components", {}).items():
        for rule in rules:
            for canon in rule.get("canonical_concepts", []):
                # A concept might be used in multiple ways, we just map it to a set
                if canon not in concept_to_category:
                    concept_to_category[canon] = set()
                concept_to_category[canon].add(category)
                
    # Now build the strategy combinations for each source
    source_strategies = {}
    
    for video_id, item in structured.get("items", {}).items():
        raw_concepts = item.get("concepts", [])
        
        # We don't have canonical map directly here, so we assume the concepts
        # are already canonical or we just use whatever concepts map to categories
        source_components = {"Entry": [], "Filter": [], "Risk": [], "Exit": []}
        
        for c in raw_concepts:
            # We check if c is known in our concept_to_category map.
            # If not, maybe it's not a component concept.
            cats = concept_to_category.get(c, set())
            for cat in cats:
                if "Entry" in cat:
                    source_components["Entry"].append(c)
                elif "Filter" in cat:
                    source_components["Filter"].append(c)
                elif "Risk" in cat:
                    source_components["Risk"].append(c)
                elif "Exit" in cat:
                    source_components["Exit"].append(c)
                    
        # Filter empty lists and sort
        source_components = {k: sorted(v) for k, v in source_components.items() if v}
        
        # Create a signature for this source's strategy
        signature = []
        if source_components.get("Entry"):
            signature.append("Entry(" + "+".join(source_components["Entry"][:2]) + ")")
        if source_components.get("Filter"):
            signature.append("Filter(" + "+".join(source_components["Filter"][:2]) + ")")
        if source_components.get("Risk"):
            signature.append("Risk(" + "+".join(source_components["Risk"][:2]) + ")")
        if source_components.get("Exit"):
            signature.append("Exit(" + "+".join(source_components["Exit"][:2]) + ")")
            
        sig_str = " | ".join(signature)
        if sig_str:
            source_strategies[video_id] = sig_str

    # Count frequencies of signatures
    pattern_counts = defaultdict(int)
    pattern_sources = defaultdict(list)
    
    for vid, sig in source_strategies.items():
        pattern_counts[sig] += 1
        pattern_sources[sig].append(vid)
        
    # Filter for patterns that appear in > 1 source (or top patterns)
    families = []
    for sig, count in sorted(pattern_counts.items(), key=lambda x: x[1], reverse=True):
        if count >= 1: # For now, keep all for visibility, usually >1
            confidence = min(1.0, count / 5.0) # Heuristic confidence
            families.append({
                "strategy_family": sig,
                "evidence_count": count,
                "confidence": round(confidence, 2),
                "sources": pattern_sources[sig]
            })
            
    output_data = {
        "metadata": {
            "total_sources_analyzed": len(source_strategies),
            "discovered_families": len(families)
        },
        "strategy_families": families
    }
    
    output_path.write_text(json.dumps(output_data, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Saved {len(families)} strategy families to {output_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--structured", default=str(DEFAULT_STRUCTURED_PATH))
    parser.add_argument("--components", default=str(DEFAULT_COMPONENTS_PATH))
    parser.add_argument("--output", default=str(DEFAULT_OUTPUT_PATH))
    args = parser.parse_args()
    
    mine_patterns(Path(args.structured), Path(args.components), Path(args.output))
