import os
import sys
import subprocess
import json
from pathlib import Path
import xml.etree.ElementTree as ET
import time
import shutil

try:
    import pandas as pd
except ImportError:
    subprocess.run([sys.executable, "-m", "pip", "install", "pandas"])
    import pandas as pd

WORKSPACE_DIR = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base")
MT5_TERMINAL = Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal\terminal64.exe")
MT5_EDITOR = Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal\metaeditor64.exe")
MT5_DATA_FOLDER = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850")
MT5_EXPERTS_DIR = MT5_DATA_FOLDER / "MQL5" / "Experts"
MT5_COMMON_FILES = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\Common\Files")

EA_SOURCE = WORKSPACE_DIR / "Universal_EA.mq5"
EA_DEST = MT5_EXPERTS_DIR / "Universal_EA.mq5"
INI_PATH = MT5_EXPERTS_DIR / "universal_validation.ini"
REPORT_PATH = MT5_EXPERTS_DIR / "UniversalReport.xml"
CSV_PATH = MT5_COMMON_FILES / "validation_trades.csv"

COMPONENTS_FILE = WORKSPACE_DIR / "ea_research_team" / "learning" / "ea_components.json"

def get_top_concepts():
    if not COMPONENTS_FILE.exists():
        return ["EMA", "RSI", "MACD", "Bollinger", "Stochastic"]
    
    try:
        data = json.loads(COMPONENTS_FILE.read_text(encoding="utf-8"))
        concept_freq = {}
        for cat in data.get("components", {}).values():
            for rule in cat:
                for c in rule.get("canonical_concepts", []):
                    concept_freq[c] = concept_freq.get(c, 0) + rule.get("frequency", 1)
                    
        # Sort and get top 5
        sorted_concepts = sorted(concept_freq.items(), key=lambda x: x[1], reverse=True)
        top_concepts = [c[0] for c in sorted_concepts[:5]]
        if not top_concepts:
            return ["Trend", "Momentum", "Support/Resistance", "Volatility", "Volume"]
        return top_concepts
    except Exception as e:
        print(f"Error reading concepts: {e}")
        return ["EMA", "RSI", "MACD", "Bollinger", "Stochastic"]

def compile_ea():
    print("[*] Copying Universal EA source...")
    shutil.copy(EA_SOURCE, EA_DEST)
    print("[*] Compiling EA...")
    cmd = [str(MT5_EDITOR), f"/compile:{EA_DEST}", "/log"]
    subprocess.run(cmd, capture_output=True)
    log_file = EA_DEST.with_suffix(".log")
    if log_file.exists():
        log_content = log_file.read_text(encoding="utf-16", errors="ignore")
        if "0 error" not in log_content.lower():
            print("[-] Compilation warnings or errors:")
            print(log_content)
            
def generate_ini(rule_enum: int, tf: str) -> str:
    return f'''[Tester]
Expert=Universal_EA
Symbol=XAUUSD_Hist
Period={tf}
Login=121059
Optimization=0
Model=4
FromDate=2025.01.01
ToDate=2025.06.01
ForwardMode=0
Report={REPORT_PATH}
ShutdownTerminal=1

[Inputs]
InpActiveRule={rule_enum}
RiskPercent=1.0
ATRMultiplier=2.0
'''

def parse_report(report_file: Path) -> dict:
    if not report_file.exists():
        return {"profit": -9999, "drawdown": 0, "trades": 0, "error": "No file"}
    try:
        content = report_file.read_text(encoding='utf-16', errors='ignore')
        if not content.strip() or "<Report>" not in content:
            content = report_file.read_text(encoding='utf-8', errors='ignore')
        profit, drawdown, trades = 0.0, 0.0, 0
        root = ET.fromstring(content)
        profit_elem = root.find('.//NetProfit')
        if profit_elem is not None: profit = float(profit_elem.text)
        dd_elem = root.find('.//EquityDrawdown')
        if dd_elem is not None: drawdown = float(dd_elem.text)
        trades_elem = root.find('.//TotalTrades')
        if trades_elem is not None: trades = int(trades_elem.text)
        return {"profit": profit, "drawdown": drawdown, "trades": trades}
    except Exception as e:
        return {"profit": -9999, "error": str(e)}

def analyze_telemetry(rule_name: str, report_data: dict) -> str:
    base_stats = f"Profit: ${report_data.get('profit',0):.2f} | DD: {report_data.get('drawdown',0):.2f}% | Trades: {report_data.get('trades',0)}"
    if not CSV_PATH.exists():
        return f"{base_stats} (No telemetry CSV)"
    
    try:
        df = pd.read_csv(CSV_PATH)
        df['Time'] = pd.to_datetime(df['Time'])
        df['Hour'] = df['Time'].dt.hour
        hourly_counts = df.groupby('Hour').size()
        busiest_hour = hourly_counts.idxmax() if not hourly_counts.empty else "N/A"
        return f"{base_stats} | Busiest Hour: {busiest_hour}:00"
    except Exception as e:
        return f"{base_stats} | Telemetry Error: {e}"

def run_backtest(rule_enum: int, rule_name: str, tf: str):
    if REPORT_PATH.exists(): REPORT_PATH.unlink()
    if CSV_PATH.exists(): CSV_PATH.unlink()
    
    INI_PATH.write_text(generate_ini(rule_enum, tf), encoding='utf-8')
    cmd = [str(MT5_TERMINAL), f"/config:{INI_PATH}"]
    print(f"\n[+] Running {rule_name} on {tf} (Real Ticks)...")
    proc = subprocess.Popen(cmd)
    try:
        proc.wait(timeout=1200) # Give 20 mins for Real Ticks
    except subprocess.TimeoutExpired:
        print("[-] Backtest timed out.")
        subprocess.run(["taskkill", "/F", "/IM", "terminal64.exe"], capture_output=True)
        
    time.sleep(2)
    report_data = parse_report(REPORT_PATH)
    analysis = analyze_telemetry(rule_name, report_data)
    print(f"Result for {rule_name}: {analysis}")
    return report_data, analysis

def synthesize_combined_rule(results: dict):
    # Find top 2 rules based on profit
    valid_results = {k: v[0] for k, v in results.items() if v[0].get('trades', 0) > 0}
    if len(valid_results) < 2:
        return {"profit": 0}, "Not enough valid trades to combine rules."
        
    sorted_rules = sorted(valid_results.items(), key=lambda x: x[1].get('profit', -9999), reverse=True)
    best1 = sorted_rules[0][0]
    best2 = sorted_rules[1][0]
    
    print(f"\n[*] Synthesizing Combined Rule from: {best1} + {best2}...")
    
    # We update Universal_EA.mq5
    ea_content = EA_SOURCE.read_text(encoding="utf-8")
    
    # We will inject a dynamic #define in the EA or just a comment
    combined_logic = f"""
      ruleName = "Combined_{best1}_{best2}";
      // Auto-Synthesized Logic
      bool signal1_buy = false, signal1_sell = false;
      bool signal2_buy = false, signal2_sell = false;
      
      GetSignal_{best1}(signal1_buy, signal1_sell);
      GetSignal_{best2}(signal2_buy, signal2_sell);
      
      if(signal1_buy && signal2_buy) buySignal = true;
      if(signal1_sell && signal2_sell) sellSignal = true;
    """
    
    ea_content = ea_content.replace("// [DYNAMIC_COMBINED_LOGIC_HERE]", combined_logic.strip())
    EA_SOURCE.write_text(ea_content, encoding="utf-8")
    compile_ea()
    
    print(f"\n[+] Running COMBINED Rule ({best1}+{best2}) on M5 (Real Ticks)...")
    return run_backtest(99, f"COMBINED_{best1}_{best2}", "M5")

def main():
    top_concepts = get_top_concepts()
    print(f"Top 5 Concepts from DB: {top_concepts}")
    
    # We map concepts to our rule implementations in Universal_EA.mq5
    # For simplicity, we assume we implemented rules 0 to 4 corresponding to top 5 generic ideas.
    rule_names = ["Trend_MA", "Momentum_RSI", "Volatility_BB", "Breakout_Price", "Oscillator_MACD"]
    
    compile_ea()
    results = {}
    report_lines = []
    
    report_lines.append(f"## Top Concepts Extracted: {', '.join(top_concepts)}\n")
    
    for i, rname in enumerate(rule_names):
        report_lines.append(f"### Rule: {rname} (M5)")
        rep_data, text_analysis = run_backtest(i, rname, "M5")
        report_lines.append(text_analysis)
        results[rname] = (rep_data, text_analysis)
        
    report_lines.append(f"### Rule: COMBINED (M5)")
    rep_data, text_analysis = synthesize_combined_rule(results)
    report_lines.append(text_analysis)
    
    report_content = "# Universal Knowledge Validation Report (Real Ticks)\n\n" + "\n\n".join(report_lines)
    report_file = WORKSPACE_DIR / "final_validation_report.md"
    report_file.write_text(report_content, encoding="utf-8")
    print(f"\n[+] Final Report saved to {report_file.name}")

if __name__ == "__main__":
    main()
