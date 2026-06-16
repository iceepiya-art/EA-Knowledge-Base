import os
import subprocess
import sys
import json
from datetime import datetime

WORKSPACE_DIR = "G:/My Drive/save log-blueprint-skill/EA-Knowledge-Base"
PLAN_FILE = os.path.join(WORKSPACE_DIR, ".agent_handoff", "ACTIVE_PLAN.json")

def log(msg):
    print(f"[{datetime.now().isoformat()}] {msg}")
    sys.stdout.flush()

def run_step(cmd_list, step_name):
    log(f"Starting: {step_name}")
    result = subprocess.run(cmd_list, cwd=WORKSPACE_DIR, capture_output=True, text=True)
    if result.returncode != 0:
        log(f"ERROR in {step_name}:\n{result.stderr}\n{result.stdout}")
        sys.exit(1)
    log(f"Completed: {step_name}\n{result.stdout.strip()}")

def update_plan(msg):
    try:
        with open(PLAN_FILE, "r", encoding="utf-8") as f:
            plan = json.load(f)
        plan["completed"].append(f"Auto-Agent: {msg}")
        with open(PLAN_FILE, "w", encoding="utf-8") as f:
            json.dump(plan, f, indent=2, ensure_ascii=False)
    except Exception as e:
        log(f"Failed to update ACTIVE_PLAN.json: {e}")

def main():
    log("=== MQL Pipeline Agent Started ===")
    
    # 1. Intake
    run_step([sys.executable, "ea_research_team/learning/mql5_code_intake.py", "--root", "G:/My Drive/jobot", "--limit", "10", "--workers", "1"], "MQL5 Code Intake")
    
    # 2. Merge
    run_step([sys.executable, "ea_research_team/learning/merge_code_insights.py"], "Merge Code Insights")
    
    # 3. Report
    run_step([sys.executable, "ea_research_team/learning/generate_mql5_report.py"], "Generate MQL5 Report")
    
    # 4. DB Sync
    run_step([sys.executable, "ea_research_team/learning/db_bridge.py", "sync-concepts", "--apply"], "DB Sync Concepts")
    run_step([sys.executable, "ea_research_team/learning/db_bridge.py", "sync-evidence", "--apply"], "DB Sync Evidence")
    run_step([sys.executable, "ea_research_team/learning/db_bridge.py", "sync-relationships", "--apply"], "DB Sync Relationships")
    
    # 5. Concept Consolidation (Phase 3)
    run_step([sys.executable, "ea_research_team/learning/semantic_concept_consolidator.py"], "Semantic Concept Consolidator")
    
    # 6. Component Extraction (Phase 4)
    run_step([sys.executable, "ea_research_team/learning/ea_component_extractor.py"], "EA Component Extractor")
    
    # 7. Pattern Mining (Phase 5)
    run_step([sys.executable, "ea_research_team/learning/strategy_pattern_miner.py"], "Strategy Pattern Miner")
    
    # 8. Blueprint Generation (Phase 6)
    run_step([sys.executable, "ea_research_team/learning/ea_blueprint_generator.py"], "EA Blueprint Generator")
    
    update_plan("MQL Batch of 10 successfully processed end-to-end (Intake -> Blueprint).")
    log("=== MQL Pipeline Agent Completed Successfully ===")

if __name__ == "__main__":
    main()
