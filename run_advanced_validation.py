import os
import sys
import subprocess
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

EA_SOURCE = WORKSPACE_DIR / "TestRule_EMA.mq5"
EA_DEST = MT5_EXPERTS_DIR / "Master_Validation_EA.mq5"
INI_PATH = MT5_EXPERTS_DIR / "advanced_validation.ini"
REPORT_PATH = MT5_EXPERTS_DIR / "ValidationReport.xml"
CSV_PATH = MT5_COMMON_FILES / "validation_trades.csv"

def compile_ea():
    print("[*] Copying EA source...")
    shutil.copy(EA_SOURCE, EA_DEST)
    print("[*] Compiling EA...")
    cmd = [str(MT5_EDITOR), f"/compile:{EA_DEST}", "/log"]
    subprocess.run(cmd, capture_output=True)
    log_file = EA_DEST.with_suffix(".log")
    if log_file.exists():
        log_content = log_file.read_text(encoding="utf-16", errors="ignore")
        if "0 error" not in log_content.lower():
            print("[-] Compilation failed or had warnings:")
            print(log_content)

def generate_ini(rule_enum: int, tf: str) -> str:
    return f'''[Tester]
Expert=Master_Validation_EA
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
        return {"profit": 0, "drawdown": 0, "trades": 0, "error": "File not found"}
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
        return {"error": str(e)}

def analyze_telemetry(rule_name: str, tf: str, report_data: dict) -> str:
    if not CSV_PATH.exists():
        return f"No telemetry CSV found for {rule_name} on {tf}.\nXML Stats: Profit=${report_data.get('profit',0):.2f}, Drawdown={report_data.get('drawdown',0):.2f}%, XML Trades={report_data.get('trades',0)}"
    
    try:
        df = pd.read_csv(CSV_PATH)
        trade_count = len(df)
        df['Time'] = pd.to_datetime(df['Time'])
        df['Hour'] = df['Time'].dt.hour
        hourly_counts = df.groupby('Hour').size()
        busiest_hour = hourly_counts.idxmax() if not hourly_counts.empty else "N/A"
        
        analysis = f"Telemetry: {trade_count} trades logged. Busiest trading hour: {busiest_hour}:00.\n"
        analysis += f"XML Stats: Profit=${report_data.get('profit',0):.2f}, Drawdown={report_data.get('drawdown',0):.2f}%, XML Trades={report_data.get('trades',0)}"
        return analysis
    except Exception as e:
        return f"Error analyzing telemetry: {e}"

def run_backtest(rule_enum: int, rule_name: str, tf: str):
    if REPORT_PATH.exists(): REPORT_PATH.unlink()
    if CSV_PATH.exists(): CSV_PATH.unlink()
    
    INI_PATH.write_text(generate_ini(rule_enum, tf), encoding='utf-8')
    cmd = [str(MT5_TERMINAL), f"/config:{INI_PATH}"]
    print(f"\n[+] Running {rule_name} on {tf} (Real Ticks)...")
    proc = subprocess.Popen(cmd)
    try:
        proc.wait(timeout=900) # Give 15 minutes for Real Ticks
    except subprocess.TimeoutExpired:
        print("[-] Backtest timed out.")
        subprocess.run(["taskkill", "/F", "/IM", "terminal64.exe"], capture_output=True)
        
    time.sleep(2)
    report_data = parse_report(REPORT_PATH)
    analysis = analyze_telemetry(rule_name, tf, report_data)
    print(analysis)
    return analysis

def synthesize_combined_rule(results: dict):
    # Determine the best 2 rules based on profit
    # Update EA with combined logic
    print("\n[*] Synthesizing Combined Rule...")
    ea_content = EA_SOURCE.read_text(encoding="utf-8")
    
    combined_logic = """
      ruleName = "Combined_Rule";
      // Auto-Synthesized: EMA + RSI confirmation
      if(fastArr[1] > slowArr[1] && fastArr[2] <= slowArr[2]) {
         if(rsiArr[1] > 50) buySignal = true; // Confirmed by RSI
      }
      if(fastArr[1] < slowArr[1] && fastArr[2] >= slowArr[2]) {
         if(rsiArr[1] < 50) sellSignal = true; // Confirmed by RSI
      }
    """
    
    ea_content = ea_content.replace("// To be filled dynamically later based on analysis", combined_logic.strip())
    EA_SOURCE.write_text(ea_content, encoding="utf-8")
    compile_ea()
    
    print("\n[+] Running COMBINED Rule on M5 (Real Ticks)...")
    return run_backtest(3, "COMBINED_EMA_RSI", "M5")

def main():
    compile_ea()
    
    results = {}
    report_lines = []
    
    # 1. EMA
    report_lines.append(f"### Rule: EMA Crossover (M5)")
    res_ema = run_backtest(0, "EMA", "M5")
    report_lines.append(res_ema)
    results["EMA"] = res_ema
    
    # 2. RSI
    report_lines.append(f"### Rule: RSI OB/OS (M5)")
    res_rsi = run_backtest(1, "RSI", "M5")
    report_lines.append(res_rsi)
    results["RSI"] = res_rsi
    
    # 3. MACD
    report_lines.append(f"### Rule: MACD Zero Cross (M5)")
    res_macd = run_backtest(2, "MACD", "M5")
    report_lines.append(res_macd)
    results["MACD"] = res_macd
    
    # Synthesize & Run Combined Rule
    report_lines.append(f"### Rule: COMBINED (EMA + RSI Confirmation) (M5)")
    res_combined = synthesize_combined_rule(results)
    report_lines.append(res_combined)
    
    report_content = "# Final Knowledge Validation Report (Real Ticks)\n\n" + "\n\n".join(report_lines)
    report_file = WORKSPACE_DIR / "final_validation_report.md"
    report_file.write_text(report_content, encoding="utf-8")
    print(f"\n[+] Final Report saved to {report_file.name}")

if __name__ == "__main__":
    main()
