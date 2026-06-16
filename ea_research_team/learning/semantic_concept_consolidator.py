import argparse
import json
import sys
import re
from pathlib import Path

DEFAULT_INDEX_PATH = Path(__file__).with_name("knowledge_index.json")
DEFAULT_OUTPUT_PATH = Path(__file__).with_name("master_concepts.json")

# Simple heuristic dictionary for fast concept consolidation
HEURISTIC_MAP = {
    "Trend Confirmation": ["ema cross", "ma cross", "moving average", "fast ma", "slow ma", "trend"],
    "Breakout": ["breakout", "bos", "break of structure", "choch", "change of character"],
    "Support & Resistance": ["support", "resistance", "snr", "supply", "demand", "fvg", "fair value gap", "order block"],
    "Momentum & Oscillators": ["rsi", "stochastic", "macd", "adx", "momentum", "divergence"],
    "Position Sizing & Risk": ["lot size", "drawdown", "martingale", "risk", "stop loss", "atr"],
    "Time & Session": ["timeframe", "session", "asian", "london", "new york", "killzone", "minute"],
    "Volatility": ["bollinger", "volatility", "standard deviation", "sd", "band"]
}

def get_canonical_name(concept_name: str) -> str:
    lower_name = concept_name.lower()
    for canon, keywords in HEURISTIC_MAP.items():
        for keyword in keywords:
            # simple keyword match
            if keyword in lower_name:
                return canon
    return concept_name # Fallback to itself if no match

def consolidate_concepts(index_path: Path, output_path: Path):
    print(f"Loading {index_path}...")
    with open(index_path, "r", encoding="utf-8") as f:
        data = json.load(f)
        
    concepts = list(data.get("concepts", {}).keys())
    
    canonical_groups = {}
    
    for c in concepts:
        canon = get_canonical_name(c)
        if canon not in canonical_groups:
            canonical_groups[canon] = []
        if c != canon:
            canonical_groups[canon].append(c)
            
    all_master_concepts = []
    for canon, aliases in canonical_groups.items():
        all_master_concepts.append({
            "concept": canon,
            "aliases": aliases
        })
    
    output_data = {
        "metadata": {
            "total_raw": len(concepts),
            "total_canonical": len(all_master_concepts)
        },
        "consolidated_concepts": all_master_concepts
    }
    
    output_path.write_text(json.dumps(output_data, ensure_ascii=False, indent=2), encoding="utf-8")
    print(f"Saved {len(all_master_concepts)} canonical concepts to {output_path} (Heuristic Mode).")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--index", default=str(DEFAULT_INDEX_PATH))
    parser.add_argument("--output", default=str(DEFAULT_OUTPUT_PATH))
    args = parser.parse_args()
    
    consolidate_concepts(Path(args.index), Path(args.output))
