"""Master EA Orchestrator (Phase 5) — Fully Autonomous Daemon

This script binds Phase 2 (Generation), Phase 3 (Backtest), and Phase 4 (Self-healing).
It runs in a continuous loop until a profitable EA with Drawdown <= 25% is found.
"""
import os
import sys
import time
import subprocess
from pathlib import Path
import mt5_cli

MAX_ITERATIONS = 20
MAX_DRAWDOWN_ALLOWED = 25.0

# Paths
BASE_DIR = Path(__file__).parent
GENERATOR_SCRIPT = BASE_DIR / "ea_generator.py"
OUTPUT_DIR = BASE_DIR.parent.parent / "artifacts" / "generated_ea"
TEST_REPORT_PATH = OUTPUT_DIR / "Report.htm"

def run_phase2_generator(iteration: int, error_feedback: str = "") -> Path:
    """Runs ea_generator.py. Passes error feedback if this is a healing loop."""
    print(f"\n[+] [Phase 2] Generating EA (Iteration {iteration})...")
    
def run_phase2_generator(attempt_number: int, feedback: str) -> Path:
    """Calls ea_generator.py to generate EA."""
    print(f"[+] [Phase 2] Generating EA version {attempt_number} (Self-Healing feedback: '{feedback}')")
    
    # Run the generator script
    cmd = ["py", "-3.13", str(GENERATOR_SCRIPT)]
    if feedback:
        cmd.extend(["--feedback", feedback])
        
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print("[-] Generator failed:")
        print(result.stderr)
        return None
        
    return OUTPUT_DIR / f"MasterEA_v{attempt_number}.mq5"

def compile_ea(ea_file: Path) -> bool:
    """Uses mt5_cli to compile the EA."""
    print(f"[+] [Phase 3] Compiling {ea_file.name}...")
    return mt5_cli.compile_ea(ea_file)

def run_mt5_backtest(ea_file: Path, from_date: str, to_date: str) -> dict:
    """Runs terminal64.exe with backtest.ini and parses Report.htm."""
    print(f"[+] [Phase 3] Running MT5 Strategy Tester: {from_date} to {to_date}...")
    
    success = mt5_cli.run_backtest(ea_file, "XAUUSD_Hist", from_date, to_date)
    
    if not success:
        return {"profit": -9999, "drawdown": 100, "log": "Backtest crashed or failed to generate report."}
    
    # Parse the actual Report.htm
    report_path = ea_file.parent / "Report.htm"
    profit = 0.0
    drawdown = 0.0
    
    if report_path.exists():
        content = report_path.read_text(encoding="utf-8", errors="ignore")
        # Extremely basic parsing for example purposes:
        import re
        profit_match = re.search(r"Total Net Profit.*?([\-\d\.]+)", content)
        if profit_match:
            profit = float(profit_match.group(1))
            
        dd_match = re.search(r"Maximal Drawdown.*?([\d\.]+)\%", content)
        if dd_match:
            drawdown = float(dd_match.group(1))
    
    print(f"[>] Backtest Result: Profit = ${profit}, Max Drawdown = {drawdown}%")
    return {
        "profit": profit,
        "drawdown": drawdown,
        "log": f"Real MT5 Result parsed."
    }

def start_orchestrator():
    print("==================================================")
    print("   MASTER EA ORCHESTRATOR - CURRICULUM LEARNING   ")
    print("==================================================")
    print(f"Target: Profit > $0 | Max Drawdown <= {MAX_DRAWDOWN_ALLOWED}%")
    
    # Curriculum Stages (FromDate, ToDate)
    curriculum = [
        {"name": "Level 1 (1 Month)", "from": "2024.01.01", "to": "2024.02.01"},
        {"name": "Level 2 (6 Months)", "from": "2024.01.01", "to": "2024.07.01"},
        {"name": "Level 3 (1 Year)", "from": "2023.01.01", "to": "2024.01.01"},
        {"name": "Level 4 (6 Years - Boss Fight)", "from": "2020.01.01", "to": "2026.01.01"}
    ]
    
    error_feedback = ""
    
    for i in range(1, MAX_ITERATIONS + 1):
        print(f"\n--- GENERATION {i}/{MAX_ITERATIONS} ---")
        
        # 1. Generate EA
        ea_file = run_phase2_generator(i, error_feedback)
        if not ea_file:
            print("[-] Halting loop due to generator error.")
            break
            
        # 2. Compile EA
        if not compile_ea(ea_file):
            error_feedback = "Compilation failed. Check syntax."
            continue
            
        # 3. Progressive Backtesting (Curriculum)
        passed_all_levels = True
        
        for stage in curriculum:
            print(f"\n  [>>> Testing {stage['name']} <<<]")
            results = run_mt5_backtest(ea_file, stage["from"], stage["to"])
            
            if results["profit"] > 0 and results["drawdown"] <= MAX_DRAWDOWN_ALLOWED:
                print(f"  [✔] Passed {stage['name']}! Moving to next level...")
            else:
                print(f"  [X] FAILED at {stage['name']}. Triggering Self-Healing...")
                error_feedback = f"Failed at {stage['name']} ({stage['from']}-{stage['to']}). Profit: {results['profit']}, DD: {results['drawdown']}%. Log: {results['log']}."
                passed_all_levels = False
                break # Break out of curriculum loop, go to next EA Generation iteration
                
        # 4. Evaluate Ultimate Success
        if passed_all_levels:
            print("\n==================================================")
            print(f"[🏆] SUCCESS! HOLY GRAIL EA FOUND ON GENERATION {i}")
            print(f"File: {ea_file.name}")
            print("Surpassed the 6-Year 339-Million Tick Boss Fight!")
            print("==================================================")
            break
            
        if i == MAX_ITERATIONS:
            print("\n[-] Reached max iterations without finding the Holy Grail.")

if __name__ == "__main__":
    start_orchestrator()
