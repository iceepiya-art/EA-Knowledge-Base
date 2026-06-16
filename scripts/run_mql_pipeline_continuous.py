import os
import subprocess
import sys
import json
import time
from datetime import datetime

WORKSPACE_DIR = "G:/My Drive/save log-blueprint-skill/EA-Knowledge-Base"
PLAN_FILE = os.path.join(WORKSPACE_DIR, ".agent_handoff", "ACTIVE_PLAN.json")
MANIFEST_FILE = os.path.join(WORKSPACE_DIR, "data", "raw", "mql5_code_manifest.json")

def log(msg):
    print(f"[{datetime.now().isoformat()}] {msg}")
    sys.stdout.flush()

def run_step(cmd_list, step_name):
    log(f"Starting: {step_name}")
    result = subprocess.run(cmd_list, cwd=WORKSPACE_DIR, capture_output=True, text=True)
    if result.returncode != 0:
        log(f"ERROR in {step_name}:\n{result.stderr}\n{result.stdout}")
        sys.exit(1)
    log(f"Completed: {step_name}")

def update_plan(msg):
    try:
        with open(PLAN_FILE, "r", encoding="utf-8") as f:
            plan = json.load(f)
        plan["completed"].append(f"Auto-Agent: {msg}")
        with open(PLAN_FILE, "w", encoding="utf-8") as f:
            json.dump(plan, f, indent=2, ensure_ascii=False)
    except Exception as e:
        log(f"Failed to update ACTIVE_PLAN.json: {e}")

def get_processed_count():
    try:
        if os.path.exists(MANIFEST_FILE):
            with open(MANIFEST_FILE, "r", encoding="utf-8") as f:
                data = json.load(f)
            return len(data.get("processed_hashes", {}))
    except Exception as e:
        log(f"Error reading manifest: {e}")
    return 0

def run_batch():
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

def main():
    log("=== MQL Pipeline Continuous Agent Started ===")
    
    batch_num = 1
    while True:
        log(f"--- Starting Continuous Batch {batch_num} ---")
        initial_count = get_processed_count()
        
        run_batch()
        
        final_count = get_processed_count()
        processed_this_batch = final_count - initial_count
        
        if processed_this_batch == 0:
            log("No new MQL files processed in this batch. All files exhausted!")
            update_plan("Continuous Agent finished: ALL MQL FILES EXHAUSTED.")
            break
            
        update_plan(f"Continuous Batch {batch_num} processed {processed_this_batch} files. Total processed: {final_count}")
        batch_num += 1
        
        log("Waiting 5 seconds before next batch...")
        time.sleep(5)
        
    log("=== MQL Pipeline Continuous Agent Completed Successfully ===")

if __name__ == "__main__":
    main()
