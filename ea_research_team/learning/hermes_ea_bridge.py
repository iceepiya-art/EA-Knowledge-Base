import requests
import json
import argparse
import sys

API_BASE = "http://localhost:5000/api/learning"

def get_status():
    """Fetches the current status of the EA Knowledge Brain."""
    try:
        response = requests.get(f"{API_BASE}/status")
        response.raise_for_status()
        return response.json()
    except Exception as e:
        return {"error": str(e)}

def trigger_pipeline():
    """Triggers the full knowledge extraction and conflict resolution pipeline."""
    try:
        response = requests.post(f"{API_BASE}/run-pipeline")
        response.raise_for_status()
        return response.json()
    except Exception as e:
        return {"error": str(e)}

def get_ea_components():
    """Fetches all the generated EA components."""
    try:
        response = requests.get(f"{API_BASE}/ea-components")
        response.raise_for_status()
        return response.json()
    except Exception as e:
        return {"error": str(e)}

def generate_blueprint():
    """Generates the Master EA Blueprint from the current knowledge."""
    try:
        response = requests.post(f"{API_BASE}/blueprint")
        response.raise_for_status()
        return response.json()
    except Exception as e:
        return {"error": str(e)}

def process_universal_input(input_data):
    """Submits a URL or text to the learning queue."""
    try:
        response = requests.post(f"{API_BASE}/universal-intake", json={"input_data": input_data, "auto_pipeline": True})
        response.raise_for_status()
        return response.json()
    except Exception as e:
        return {"error": str(e)}

def get_pipeline_status():
    """Fetches the status of the background pipeline."""
    try:
        response = requests.get(f"{API_BASE}/pipeline-status")
        response.raise_for_status()
        return response.json()
    except Exception as e:
        return {"error": str(e)}

def import_local_evidence(source_path):
    """Triggers the import of local files from a given source path."""
    try:
        response = requests.post(f"{API_BASE}/import-local", json={"source_path": source_path, "auto_pipeline": True})
        response.raise_for_status()
        return response.json()
    except Exception as e:
        return {"error": str(e)}

def get_pending_conflicts():
    """Fetches all pending conflicts from the Knowledge Brain."""
    try:
        response = requests.get(f"{API_BASE}/conflicts/pending")
        response.raise_for_status()
        return response.json()
    except Exception as e:
        return {"error": str(e)}

def resolve_conflict(conflict_id, decision, note):
    """Submits a resolution for a pending conflict."""
    try:
        payload = {
            "conflict_id": conflict_id,
            "resolution": decision,
            "resolution_note": note
        }
        response = requests.post(f"{API_BASE}/conflicts/resolve", json=payload)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        return {"error": str(e)}

def auto_resolve_all():
    """Uses LLM (Gemini) to automatically judge and resolve all pending conflicts."""
    print("Starting Hermes Auto-Resolve...")
    conflicts = get_pending_conflicts()
    if "error" in conflicts:
        print(f"Error fetching conflicts: {conflicts['error']}")
        return {"error": conflicts['error']}
        
    items = conflicts.get("items", [])
    if isinstance(conflicts.get("items"), dict):
        items = list(conflicts["items"].values())
        
    pending = [c for c in items if c.get("status") == "pending"]
    if not pending:
        print("No pending conflicts to resolve.")
        return {"status": "ok", "resolved": 0}
        
    print(f"Found {len(pending)} pending conflicts. Connecting to LLM...")
    
    import os
    import re
    gemini_key = os.environ.get("GEMINI_API_KEY")
    client = None
    if gemini_key:
        try:
            from google import genai
            from google.genai import types
            client = genai.Client()
        except ImportError:
            print("google-genai not installed.")
            return {"error": "Missing google-genai"}
    else:
        print("Warning: GEMINI_API_KEY not found in environment.")
        return {"error": "No LLM configured"}
        
    resolved_count = 0
    for i, c in enumerate(pending):
        c_id = c.get("conflict_id")
        concept = c.get("concept")
        summary = c.get("summary")
        rule_a = c.get("rule_a")
        rule_b = c.get("rule_b")
        
        print(f"[{i+1}/{len(pending)}] Resolving conflict: {concept}...")
        
        prompt = f"""
You are Hermes, the AI Conflict Judge for an EA (Expert Advisor) Knowledge Base.
Concept: {concept}
Summary: {summary}
Rule A (New): {rule_a}
Rule B (Old): {rule_b}

Decide how to resolve this conflict.
Choices:
- "accepted" (Accept Rule A)
- "keep_old" (Keep Rule B)
- "merge_as_condition" (Both are valid in different market conditions)

Respond ONLY in valid JSON format:
{{
  "decision": "merge_as_condition",
  "note": "Short explanation here"
}}
"""
        try:
            response_text = None
            
            # First try Gemini models
            for model_name in ['gemini-2.5-flash', 'gemini-2.0-flash', 'gemini-2.0-flash-lite']:
                try:
                    response = client.models.generate_content(
                        model=model_name,
                        contents=prompt,
                        config=types.GenerateContentConfig(temperature=0.1)
                    )
                    response_text = response.text.strip()
                    break # Success!
                except Exception as e:
                    err_str = str(e)
                    if "429" in err_str or "404" in err_str or "503" in err_str:
                        print(f"  -> {model_name} failed ({'Rate limit' if '429' in err_str else 'Error'}), trying next...")
                        continue
                    else:
                        raise e
            
            # If all Gemini models fail, fallback to Anthropic
            if not response_text:
                print("  -> All Gemini models failed or hit rate limits. Falling back to Anthropic Claude 3.5 Sonnet...")
                import anthropic
                import os
                try:
                    anthropic_client = anthropic.Anthropic(api_key=os.environ.get("ANTHROPIC_API_KEY"))
                    msg = anthropic_client.messages.create(
                        model="claude-sonnet-4-6",
                        max_tokens=2048,
                        temperature=0.1,
                        messages=[
                            {"role": "user", "content": prompt}
                        ]
                    )
                    response_text = msg.content[0].text.strip()
                except Exception as e:
                    print(f"  -> Anthropic failed: {str(e)}")
            
            if not response_text:
                print("  -> All AI models exhausted.")
                continue
                
            json_match = re.search(r"\{.*\}", response_text, re.DOTALL)
            if json_match:
                result = json.loads(json_match.group())
                decision = result.get("decision", "merge_as_condition")
                note = result.get("note", "Auto-resolved by Hermes")
                
                if decision not in ["accepted", "keep_old", "merge_as_condition"]:
                    decision = "merge_as_condition"
                    
                resolve_res = resolve_conflict(c_id, decision, note)
                if "error" not in resolve_res:
                    resolved_count += 1
                    print(f"  -> Resolved as {decision}")
                else:
                    print(f"  -> Failed to resolve: {resolve_res['error']}")
            else:
                print(f"  -> LLM returned invalid format: {text}")
        except Exception as e:
            print(f"  -> LLM error: {e}")
            
    print(f"Hermes Auto-Resolve complete. Resolved {resolved_count}/{len(pending)} conflicts.")
    return {"status": "ok", "resolved": resolved_count}

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Hermes Bridge to EA Knowledge Brain")
    parser.add_argument("action", choices=["status", "pipeline", "components", "blueprint", "learn", "conflicts", "pipeline-status", "import-local"], help="Action to perform")
    parser.add_argument("--data", type=str, help="Input data for 'learn' action (e.g. YouTube URL)", default="")
    parser.add_argument("--list-pending", action="store_true", help="List all pending conflicts")
    parser.add_argument("--resolve", type=str, help="Conflict ID to resolve")
    parser.add_argument("--decision", type=str, help="Resolution decision")
    parser.add_argument("--note", type=str, help="Resolution note/explanation")
    parser.add_argument("--auto-resolve", action="store_true", help="Use AI to auto-resolve all pending conflicts")
    args = parser.parse_args()

    result = {}
    if args.action == "status":
        result = get_status()
    elif args.action == "pipeline":
        result = trigger_pipeline()
    elif args.action == "components":
        result = get_ea_components()
    elif args.action == "blueprint":
        result = generate_blueprint()
    elif args.action == "pipeline-status":
        result = get_pipeline_status()
    elif args.action == "import-local":
        if not args.data:
            result = {"error": "Must provide --data for import-local action"}
        else:
            result = import_local_evidence(args.data)
    elif args.action == "learn":
        if not args.data:
            result = {"error": "Must provide --data for learn action"}
        else:
            result = process_universal_input(args.data)
    elif args.action == "conflicts":
        if args.auto_resolve:
            result = auto_resolve_all()
        elif args.list_pending:
            result = get_pending_conflicts()
        elif args.resolve:
            if not args.decision:
                result = {"error": "Must provide --decision to resolve a conflict"}
            else:
                result = resolve_conflict(args.resolve, args.decision, args.note or "")
        else:
            result = {"error": "Must provide either --list-pending, --resolve, or --auto-resolve"}

    print(json.dumps(result, indent=2, ensure_ascii=True))
