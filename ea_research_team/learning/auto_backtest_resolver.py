import argparse
import json
import os
import re
import sys
from pathlib import Path
import tempfile
import shutil

from conflict_detector import get_pending_conflicts, resolve_conflict, DEFAULT_CONFLICT_QUEUE_PATH
from ea_generator import generate_ea, DEFAULT_BLUEPRINT_PATH
import mt5_cli

def parse_report_metrics(report_path: Path) -> dict:
    if not report_path.exists():
        return {"profit": -9999.0, "drawdown": 100.0, "profit_factor": 0.0}
    content = report_path.read_text(encoding="utf-8", errors="ignore")
    
    profit = 0.0
    drawdown = 0.0
    profit_factor = 0.0
    
    profit_match = re.search(r"Total Net Profit.*?([\-\d\.]+)", content)
    if profit_match:
        profit = float(profit_match.group(1))
        
    dd_match = re.search(r"Maximal Drawdown.*?([\d\.]+)\%", content)
    if dd_match:
        drawdown = float(dd_match.group(1))
        
    pf_match = re.search(r"Profit Factor.*?([\d\.]+)", content)
    if pf_match:
        profit_factor = float(pf_match.group(1))
        
    return {"profit": profit, "drawdown": drawdown, "profit_factor": profit_factor}

def build_mock_components(rule_text: str) -> str:
    comps = {
        "Tested_Strategy": {
            "entry": [rule_text],
            "stop_loss": ["Use ATR based trailing stop"]
        }
    }
    return json.dumps(comps, indent=2, ensure_ascii=False)

def resolve_single_conflict(conflict: dict) -> bool:
    cid = conflict["conflict_id"]
    concept = conflict["concept"]
    
    print(f"\n[+] Resolving Conflict: {cid} ({concept})")
    
    if conflict.get("type") == "variant_divergence":
        variants = conflict.get("variants", [])
        if len(variants) < 2:
            print("[-] Not enough variants to compare.")
            return False
        rule_a = variants[0]["text"]
        rule_b = variants[1]["text"]
    else:
        rule_a = conflict.get("rule_a")
        rule_b = conflict.get("rule_b")
        
    if not rule_a or not rule_b:
        print("[-] Missing rule_a or rule_b. Cannot backtest.")
        return False
        
    api_key = os.getenv("GEMINI_API_KEY")
    if not api_key:
        print("[-] Missing GEMINI_API_KEY.")
        return False
        
    blueprint = DEFAULT_BLUEPRINT_PATH.read_text(encoding="utf-8") if DEFAULT_BLUEPRINT_PATH.exists() else "Basic Trend Blueprint"
    
    work_dir = Path(tempfile.mkdtemp(prefix="ea_backtest_resolver_"))
    
    # Generate EAs
    ea_files = {}
    for variant_name, rule_text in [("A", rule_a), ("B", rule_b)]:
        print(f"  -> Generating EA Variant {variant_name}...")
        comps = build_mock_components(rule_text)
        try:
            mql5_code = generate_ea(blueprint, comps, api_key)
        except Exception as e:
            err_str = str(e).lower()
            print(f"[-] Generation failed for Variant {variant_name}: {e}")
            if "credit balance is too low" in err_str or "api key" in err_str or "429" in err_str:
                print("[!] CRITICAL: API Credit/Quota error detected. Halting entire script to prevent infinite billing loop.")
                sys.exit(1)
            return False
            
        ea_file = work_dir / f"Resolver_{cid}_{variant_name}.mq5"
        ea_file.write_text(mql5_code, encoding="utf-8")
        
        print(f"  -> Compiling Variant {variant_name}...")
        if not mt5_cli.compile_ea(ea_file):
            print(f"[-] Compilation failed for Variant {variant_name}")
            return False
        ea_files[variant_name] = ea_file

    curriculum = [
        {"name": "1 Month", "from": "2024.01.01", "to": "2024.02.01"},
        {"name": "1 Year", "from": "2023.01.01", "to": "2024.01.01"},
        {"name": "2 Years", "from": "2022.01.01", "to": "2024.01.01"},
        {"name": "3 Years", "from": "2021.01.01", "to": "2024.01.01"}
    ]
    periods = ["H1", "M30", "M15"]
    
    scores = {"A": 0.0, "B": 0.0}
    max_dd = 30.0
    
    print(f"  -> Starting Curriculum Backtests for both variants...")
    for stage in curriculum:
        for p in periods:
            for variant_name in ["A", "B"]:
                ea_file = ea_files[variant_name]
                report_name = f"Report_{variant_name}_{stage['name'].replace(' ', '_')}_{p}.htm"
                mt5_cli.run_backtest(ea_file, "XAUUSD_Hist", stage["from"], stage["to"], report_name=report_name, period=p)
                metrics = parse_report_metrics(ea_file.parent / report_name)
                
                # Evaluation metric: Highest Net Profit, but DD must not exceed 30%
                profit = metrics["profit"]
                dd = metrics["drawdown"]
                if dd <= max_dd and profit > 0:
                    scores[variant_name] += profit
                    print(f"    [+] {variant_name} on {stage['name']} ({p}): Pass (Profit: {profit}, DD: {dd}%)")
                else:
                    print(f"    [-] {variant_name} on {stage['name']} ({p}): Fail (Profit: {profit}, DD: {dd}%)")
                    
    print(f"\n  -> Final Scores (Total Valid Net Profit): Variant A: {scores['A']}, Variant B: {scores['B']}")
    
    winner = "A" if scores["A"] >= scores["B"] else "B"
    decision = f"accepted_rule_{winner.lower()}"
    note = f"Variant {winner} won empirically across 1m, 1y, 2y, 3y (H1, M30, M15). Score {scores[winner]} vs {scores['B' if winner == 'A' else 'A']}."
    
    print(f"[🏆] Winner: Variant {winner}")
    print(f"  -> Updating conflict {cid} status to resolved...")
    
    resolve_conflict(cid, decision, note)
    shutil.rmtree(work_dir, ignore_errors=True)
    return True

def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Auto Backtest Resolver")
    parser.add_argument("--limit", type=int, default=1, help="Max conflicts to resolve in this run")
    args = parser.parse_args(argv)
    
    conflicts = get_pending_conflicts()
    if not conflicts:
        print("No pending conflicts to resolve.")
        return 0
        
    print(f"Found {len(conflicts)} pending conflicts. Processing up to {args.limit}...")
    processed = 0
    for conflict in conflicts:
        if processed >= args.limit:
            break
        ctype = conflict.get("type", "")
        if ctype not in ["contradiction", "variant_divergence"]:
            continue
            
        success = resolve_single_conflict(conflict)
        if success:
            processed += 1
            
    print(f"Finished processing {processed} conflicts.")
    return 0

if __name__ == "__main__":
    sys.exit(main())

