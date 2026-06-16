import subprocess
from pathlib import Path
import xml.etree.ElementTree as ET
import time
import re

terminal = Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal\terminal64.exe")
ini_path = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\backtest_rsi.ini")
report_path = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\ReportRSI.xml")

def generate_ini_content(rsi_period: int) -> str:
    ini_content = f'''[Tester]
Expert=TestRule_RSI
Symbol=XAUUSD_Hist
Period=M5
Login=121059
Optimization=0
Model=1
FromDate=2025.01.01
ToDate=2025.06.01
ForwardMode=0
Report={report_path}
ShutdownTerminal=1

[Inputs]
InpRSIPeriod={rsi_period}
InpLotSize=0.1
'''
    return ini_content

def parse_report(report_file: str) -> dict:
    path = Path(report_file)
    if not path.exists():
        return {"profit": 0, "drawdown": 0, "trades": 0, "error": "File not found"}
    
    try:
        content = path.read_text(encoding='utf-16', errors='ignore')
        if not content.strip() or "<Report>" not in content:
            content = path.read_text(encoding='utf-8', errors='ignore')
            
        profit = 0.0
        drawdown = 0.0
        trades = 0
        
        # Parse XML
        root = ET.fromstring(content)
        profit_elem = root.find('.//NetProfit')
        if profit_elem is not None: profit = float(profit_elem.text)
            
        dd_elem = root.find('.//EquityDrawdown')
        if dd_elem is not None: drawdown = float(dd_elem.text)
            
        trades_elem = root.find('.//TotalTrades')
        if trades_elem is not None: trades = int(trades_elem.text)

        return {"profit": profit, "drawdown": drawdown, "trades": trades}
    except Exception as e:
        # Fallback to regex for HTML if it exported HTML instead of XML
        profit_match = re.search(r'>Total Net Profit.*?([\-\d\.]+)', content, re.IGNORECASE)
        if profit_match:
            return {"profit": float(profit_match.group(1)), "drawdown": 0, "trades": 0}
        return {"error": str(e)}

def run_experiment():
    results = {}
    periods = [10, 14, 21]
    
    for p in periods:
        if report_path.exists():
            report_path.unlink()
            
        ini_content = generate_ini_content(p)
        ini_path.write_text(ini_content, encoding='utf-8')
        
        cmd = [str(terminal), f"/config:{ini_path}"]
        print(f"[+] Running backtest for RSI Period = {p}...")
        proc = subprocess.Popen(cmd)
        
        try:
            proc.wait(timeout=180)
            print(f"[+] Backtest finished for RSI {p}.")
        except subprocess.TimeoutExpired:
            print(f"[-] Backtest timed out for RSI {p}.")
            subprocess.run(["taskkill", "/F", "/IM", "terminal64.exe"], capture_output=True)

        res = parse_report(str(report_path))
        print(f"Result for RSI {p}: {res}")
        results[p] = res
        time.sleep(2) # Give terminal time to close fully
        
    print("\n--- FINAL RESULTS ---")
    for p, res in results.items():
        print(f"RSI Period {p}: Profit=${res.get('profit',0)} DD={res.get('drawdown',0)}% Trades={res.get('trades',0)}")

if __name__ == "__main__":
    run_experiment()
