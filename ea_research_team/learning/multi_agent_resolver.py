import os
import json
import requests
import re
from concurrent.futures import ThreadPoolExecutor, as_completed
import time
import argparse

try:
    import google.genai as genai
    from google.genai import types
except ImportError:
    genai = None

API_BASE = "http://localhost:5000/api/learning"

def get_pending_conflicts():
    try:
        response = requests.get(f"{API_BASE}/conflicts/pending")
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"Error fetching conflicts: {e}")
        return {"error": str(e)}

def resolve_conflict_api(conflict_id, decision, note):
    try:
        payload = {
            "conflict_id": conflict_id,
            "resolution": decision,
            "resolution_note": note
        }
        response = requests.post(f"{API_BASE}/conflicts/resolve", json=payload)
        response.raise_for_status()
        return True
    except Exception as e:
        print(f"Error resolving conflict {conflict_id}: {e}")
        return False

def resolve_single_conflict(client, conflict):
    c_id = conflict.get("conflict_id")
    concept = conflict.get("concept")
    summary = conflict.get("summary")
    rule_a = conflict.get("rule_a")
    rule_b = conflict.get("rule_b")
    
    prompt = f"""
    You are Hermes, the AI Chief Judge for an EA (Expert Advisor) Knowledge Base.
    You are hosting a panel debate with two other agents:
    - Risco Agent (Risk Management & FTMO Guard): Evaluates strict adherence to 5% daily loss, 10% max loss, and conservative risk management.
    - Analyst Agent (Market Logic): Evaluates structural validity for technical analysis (Trend vs Sideways).
    
    Current Conflict: {concept}
    Summary: {summary}
    Rule A (New): {rule_a}
    Rule B (Old): {rule_b}
    
    First, provide a brief debate between Risco and Analyst. 
    Then, as Hermes, decide how to resolve this conflict based on their input.
    
    Choices:
    - "accepted" (Accept Rule A because it's superior/safer)
    - "keep_old" (Keep Rule B because it's superior/safer)
    - "merge_as_condition" (Both are valid in different market regimes/conditions)
    
    Respond with the debate, and then ONLY output valid JSON format at the very end like this:
    ```json
    {{
      "decision": "merge_as_condition",
      "note": "Short explanation of the panel consensus"
    }}
    ```
    """
    
    max_retries = 3
    for attempt in range(max_retries):
        try:
            response = client.models.generate_content(
                model="gemini-2.5-flash",
                contents=prompt,
                config=types.GenerateContentConfig(temperature=0.2)
            )
            response_text = response.text
            
            json_match = re.search(r"\{.*\}", response_text, re.DOTALL)
            if json_match:
                result = json.loads(json_match.group())
                decision = result.get("decision", "merge_as_condition")
                note = result.get("note", "Resolved by Multi-Agent Panel")
                
                if decision not in ["accepted", "keep_old", "merge_as_condition"]:
                    decision = "merge_as_condition"
                    
                if resolve_conflict_api(c_id, decision, note):
                    return True, c_id, decision
                else:
                    return False, c_id, "API Error"
            else:
                return False, c_id, "Invalid JSON from LLM"
                
        except Exception as e:
            err_str = str(e)
            if "429" in err_str:
                time.sleep(2 ** attempt)  # Exponential backoff
            else:
                return False, c_id, f"LLM Error: {err_str}"
                
    return False, c_id, "Max retries exceeded"

def main():
    parser = argparse.ArgumentParser(description="Multi-Agent Concurrent Resolver")
    parser.add_argument("--workers", type=int, default=10, help="Number of concurrent workers")
    args = parser.parse_args()

    print("Starting Multi-Agent Concurrent Auto-Resolve...")
    
    gemini_key = os.environ.get("GEMINI_API_KEY")
    if not gemini_key or not genai:
        print("Error: GEMINI_API_KEY environment variable is not set or google-genai is missing.")
        return

    client = genai.Client()
    
    conflicts_data = get_pending_conflicts()
    if "error" in conflicts_data:
        return
        
    items = conflicts_data.get("items", [])
    if isinstance(conflicts_data.get("items"), dict):
        items = list(conflicts_data["items"].values())
        
    pending = [c for c in items if c.get("status") == "pending"]
    if not pending:
        print("No pending conflicts to resolve. Database is clean!")
        return
        
    print(f"Found {len(pending)} pending conflicts. Processing with {args.workers} workers...")
    
    resolved_count = 0
    failed_count = 0
    start_time = time.time()
    
    with ThreadPoolExecutor(max_workers=args.workers) as executor:
        futures = {executor.submit(resolve_single_conflict, client, c): c for c in pending}
        
        for future in as_completed(futures):
            success, c_id, msg = future.result()
            if success:
                resolved_count += 1
                print(f"[+] Conflict {c_id[:8]} resolved as '{msg}' ({resolved_count}/{len(pending)})")
            else:
                failed_count += 1
                print(f"[-] Conflict {c_id[:8]} failed: {msg}")

    elapsed = time.time() - start_time
    print(f"\nMulti-Agent Resolve Complete in {elapsed:.2f} seconds!")
    print(f"Successfully Resolved: {resolved_count}")
    print(f"Failed: {failed_count}")

if __name__ == "__main__":
    main()
