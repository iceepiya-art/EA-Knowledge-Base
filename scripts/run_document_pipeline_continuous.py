import os
import subprocess
import sys
import json
import time
from datetime import datetime

WORKSPACE_DIR = "G:/My Drive/save log-blueprint-skill/EA-Knowledge-Base"
PLAN_FILE = os.path.join(WORKSPACE_DIR, ".agent_handoff", "ACTIVE_PLAN.json")
MANIFEST_FILE = os.path.join(WORKSPACE_DIR, "data", "raw", "document_manifest.json")

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
        plan["completed"].append(f"Auto-Agent (Document): {msg}")
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
    # 1. Intake Documents
    run_step([sys.executable, "ea_research_team/learning/document_intake.py", "--root", "G:/My Drive/jobot", "--limit", "5"], "Document Intake")
    
    # 2. Merge Code Insights (knowledge_merger reads from structured_extractions.json and merges into knowledge_index.json)
    run_step([sys.executable, "ea_research_team/learning/knowledge_merger.py"], "Merge Knowledge")
    
    # 3. DB Sync
    run_step([sys.executable, "ea_research_team/learning/db_bridge.py", "sync-concepts", "--apply"], "DB Sync Concepts")
    run_step([sys.executable, "ea_research_team/learning/db_bridge.py", "sync-evidence", "--apply"], "DB Sync Evidence")
    run_step([sys.executable, "ea_research_team/learning/db_bridge.py", "sync-relationships", "--apply"], "DB Sync Relationships")
    
    # 4. Concept Consolidation (Phase 3)
    run_step([sys.executable, "ea_research_team/learning/semantic_concept_consolidator.py"], "Semantic Concept Consolidator")
    
    # 5. Component Extraction (Phase 4)
    run_step([sys.executable, "ea_research_team/learning/ea_component_extractor.py"], "EA Component Extractor")
    
    # 6. Pattern Mining (Phase 5)
    run_step([sys.executable, "ea_research_team/learning/strategy_pattern_miner.py"], "Strategy Pattern Miner")
    
    # 7. Blueprint Generation (Phase 6)
    run_step([sys.executable, "ea_research_team/learning/ea_blueprint_generator.py"], "EA Blueprint Generator")

def main():
    log("=== Document Pipeline Continuous Agent Started ===")
    
    batch_num = 1
    while True:
        log(f"--- Starting Document Batch {batch_num} ---")
        initial_count = get_processed_count()
        
        run_batch()
        
        final_count = get_processed_count()
        processed_this_batch = final_count - initial_count
        
        if processed_this_batch == 0:
            log("No new documents processed in this batch. All documents exhausted!")
            update_plan("Continuous Agent (Document) finished: ALL DOCUMENTS EXHAUSTED.")
            break
            
        update_plan(f"Continuous Document Batch {batch_num} processed {processed_this_batch} files. Total processed: {final_count}")
        batch_num += 1
        
        log("Waiting 5 seconds before next batch...")
        time.sleep(5)
        
    log("=== Document Pipeline Continuous Agent Completed Successfully ===")

if __name__ == "__main__":
    main()
