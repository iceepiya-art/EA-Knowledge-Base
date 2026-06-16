import json
import argparse
import sys
from collections import defaultdict
from pathlib import Path

CODE_INSIGHTS_PATH = Path(r"g:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\data\raw\mql5_code_insights.json")
REPORT_PATH = Path(r"g:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\artifacts\mql5_learning_report.md")

def main(argv=None):
    parser = argparse.ArgumentParser(description="Generate a markdown report from extracted MQL code insights.")
    parser.parse_args([] if argv is None else argv)

    if not CODE_INSIGHTS_PATH.exists():
        print("No insights found.")
        return
        
    insights = json.loads(CODE_INSIGHTS_PATH.read_text(encoding="utf-8"))
    
    # Group by directory/project
    by_project = defaultdict(list)
    for item in insights:
        src = item.get("source_file", "")
        # Extract just the EA folder name
        parts = Path(src).parts
        project_name = "Unknown"
        for p in parts:
            if "Desktop" in parts:
                idx = parts.index("Desktop")
                if len(parts) > idx + 1:
                    project_name = parts[idx + 1]
                    break
        by_project[project_name].append(item)
        
    # Write a markdown report
    report_path = REPORT_PATH
    report_path.parent.mkdir(parents=True, exist_ok=True)
    
    with open(report_path, "w", encoding="utf-8") as f:
        f.write("# 🧠 รายงานผลการสกัดความรู้ MQL5 จาก 7 โปรเจกต์\n\n")
        f.write(f"ระบบทำการสแกนไฟล์ `.mq5` และ `.mqh` และสกัดโครงสร้าง Logic ออกมาได้ **ทั้งหมด {len(insights)} หัวข้อ** ตามที่คุณระบุไว้\n\n")
        
        for proj, items in by_project.items():
            f.write(f"## 📁 {proj} ({len(items)} เรื่อง)\n")
            # Group by category within project
            by_cat = defaultdict(list)
            for it in items:
                cat = it.get("category", "General")
                by_cat[cat].append(it.get("topic"))
                
            for cat, topics in by_cat.items():
                f.write(f"**{cat}**\n")
                for t in topics:
                    f.write(f"- {t}\n")
            f.write("\n---\n")
            
    print(f"Report saved to {report_path}")

if __name__ == "__main__":
    main(sys.argv[1:])
