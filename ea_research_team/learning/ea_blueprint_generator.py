"""EA Blueprint Generator — generates Master EA Blueprint (YAML) from ea_components.json.

Reads:
  - ea_components.json  (from Phase 4)

Writes:
  - Master_EA_Blueprint.yaml
"""
from __future__ import annotations

import argparse
import json
import sys
from datetime import datetime, timezone, timedelta
from pathlib import Path

TH_TZ = timezone(timedelta(hours=7))

DEFAULT_COMPONENTS_PATH = Path(__file__).with_name("ea_components.json")
DEFAULT_OUTPUT_PATH = Path(__file__).with_name("Master_EA_Blueprint.yaml")

def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")

def generate_yaml_blueprint(ea_components: dict) -> str:
    components = ea_components.get("components", {})
    
    yaml_lines = [
        "# Master EA Blueprint",
        f"# Generated: {_now_iso()}",
        f"# Version: {ea_components.get('version', '2.0')}",
        ""
    ]
    
    # Map EA components categories to the requested yaml keys
    cat_mapping = {
        "Entry Components": "entry",
        "Filter Components": "filter",
        "Risk Components": "risk",
        "Exit Components": "exit"
    }
    
    for cat_name, yaml_key in cat_mapping.items():
        yaml_lines.append(f"{yaml_key}:")
        rules = components.get(cat_name, [])
        if not rules:
            yaml_lines.append("  []")
            yaml_lines.append("")
            continue
            
        # Extract the highest frequency rule's canonical concepts or the rules themselves
        # For the blueprint, we just want the top 5 concept building blocks
        added = 0
        seen_concepts = set()
        
        for rule in rules:
            canon_concepts = rule.get("canonical_concepts", [])
            for c in canon_concepts:
                if c not in seen_concepts:
                    yaml_lines.append(f"  - {c}")
                    seen_concepts.add(c)
                    added += 1
            if added >= 5:
                break
                
        if added == 0:
            # Fallback to rule text if no canonical concepts mapped
            for rule in rules[:3]:
                safe_rule = rule.get('rule', '').replace('"', '')
                yaml_lines.append(f"  - \"{safe_rule}\"")
                
        yaml_lines.append("")
        
    return "\n".join(yaml_lines)

def _format_mermaid_list(rules: list[dict], max_items: int = 3) -> str:
    items = []
    seen = set()
    added = 0
    for rule in rules:
        canon_concepts = rule.get("canonical_concepts", [])
        for c in canon_concepts:
            if c not in seen:
                items.append(f"<br/>• {c}")
                seen.add(c)
                added += 1
        if added >= max_items:
            break
    if not items:
        for rule in rules[:max_items]:
            text = rule.get("rule", "").replace('"', '').replace('\n', ' ')
            if len(text) > 40: text = text[:37] + "..."
            items.append(f"<br/>• {text}")
    return "".join(items) if items else "<br/>• (None)"

def generate_mermaid_flowchart(ea_components: dict) -> str:
    components = ea_components.get("components", {})
    entry = components.get("Entry Components", [])
    filter_comp = components.get("Filter Components", [])
    risk = components.get("Risk Components", [])
    exit_comp = components.get("Exit Components", [])
    
    mermaid_lines = [
        "```mermaid",
        "graph TD",
        "    classDef primary fill:#eef2ff,stroke:#6366f1,stroke-width:2px,color:#000;",
        "    classDef data fill:#fdf4ff,stroke:#d946ef,stroke-width:1px,color:#000;",
        "    classDef filter_node fill:#fffbeb,stroke:#d97706,stroke-width:1px,color:#000;",
        "    classDef position fill:#ecfdf5,stroke:#10b981,stroke-width:1px,color:#000;",
        "    classDef manage fill:#eff6ff,stroke:#3b82f6,stroke-width:1px,color:#000;",
        "    classDef close_node fill:#f5f3ff,stroke:#8b5cf6,stroke-width:1px,color:#000;",
        "",
        "    A[1 - รับข้อมูลตลาด <br/> Price Data / ATR / Session]:::data",
        "    B[2 - AI วิเคราะห์สัญญาณ <br/> AI Signal Analysis Model <br/> Signal: BUY/SELL/HOLD]:::primary",
        f"    C[3 - กรองสัญญาณ (Filters){_format_mermaid_list(filter_comp)}]:::filter_node",
        f"    D[4 - เปิด Position (Entry){_format_mermaid_list(entry)}]:::position",
        f"    E[5 - บริหาร Position (Risk){_format_mermaid_list(risk)}]:::manage",
        f"    F[6 - เงื่อนไขปิด Position (Exit){_format_mermaid_list(exit_comp)}]:::close_node",
        "",
        "    A --> B",
        "    B --> C",
        "    C --> D",
        "    D --> E",
        "    E --> F",
        "```"
    ]
    
    md_lines = [
        f"# Master EA Blueprint Flow",
        f"**Generated:** {_now_iso()}  ",
        f"**Version:** {ea_components.get('version', '2.0')}  ",
        "",
        "## Trading Logic Pipeline",
        "",
        "\n".join(mermaid_lines),
        ""
    ]
    
    return "\n".join(md_lines)

def generate_from_files(
    components_path: Path,
    output_path: Path,
):
    if not components_path.exists():
        raise FileNotFoundError(f"ea_components.json not found: {components_path}")
        
    ea_components = json.loads(components_path.read_text(encoding="utf-8"))
    
    yaml_content = generate_yaml_blueprint(ea_components)
    mermaid_md_content = generate_mermaid_flowchart(ea_components)
    
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(yaml_content, encoding="utf-8")
    
    print(f"Master EA Blueprint generated at {output_path}")
    
    flow_path = output_path.with_name(f"{output_path.stem}_Flow.md")
    flow_path.write_text(mermaid_md_content, encoding="utf-8")
    print(f"Master EA Blueprint Flowchart generated at {flow_path}")

def main(argv: list[str] | None = None) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    parser = argparse.ArgumentParser(description="EA Blueprint Generator (Phase 6)")
    parser.add_argument("--components", default=str(DEFAULT_COMPONENTS_PATH))
    parser.add_argument("--output",     default=str(DEFAULT_OUTPUT_PATH))
    args = parser.parse_args(argv)
    
    generate_from_files(Path(args.components), Path(args.output))
    return 0

if __name__ == "__main__":
    sys.exit(main())
