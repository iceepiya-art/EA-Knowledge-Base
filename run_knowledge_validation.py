import subprocess
from pathlib import Path
import xml.etree.ElementTree as ET

terminal = Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal\terminal64.exe")
ini_path = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\backtest_validation.ini")
report_path = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\ReportValidation.xml")

def generate_ini_content(ea_name: str, risk_percent: float, rr_ratio: float) -> str:
    ini_content = f'''[Tester]
Expert={ea_name}
Symbol=XAUUSD_Hist
Period=M5
Login=121059
Optimization=0
Model=1
FromDate=2025.01.01
ToDate=2026.01.01
ForwardMode=0
Report={report_path}
ShutdownTerminal=1

[Inputs]
RiskPercent={risk_percent}
RR_Ratio={rr_ratio}
'''
    return ini_content

def validate_report_trades(report_file: str) -> tuple[bool, str]:
    path = Path(report_file)
    if not path.exists():
        return False, "Report file not found."
    
    try:
        content = path.read_text(encoding='utf-16', errors='ignore')
        if not content.strip() or "<Report>" not in content:
            content = path.read_text(encoding='utf-8', errors='ignore')
            
        import re
        trades_match = re.search(r'>Total trades(?:<[^>]+>)*\s*(\d+)', content, re.IGNORECASE)
        if not trades_match:
            root = ET.fromstring(content)
            trades_elem = root.find('.//TotalTrades')
            if trades_elem is not None:
                total_trades = int(trades_elem.text)
            else:
                return False, "Could not find total trades in report."
        else:
            total_trades = int(trades_match.group(1))

        years = 1.0
        trades_per_year = total_trades / years
        
        if trades_per_year >= 1000:
            return True, f"Valid: {total_trades} trades over {years} years ({trades_per_year:.1f} per year)."
        else:
            return False, f"Invalid: Insufficient trades. Only {total_trades} trades over {years} years ({trades_per_year:.1f} per year)."
    except Exception as e:
        return False, f"Error parsing report: {e}"

def run_backtest(ea_name: str):
    if report_path.exists():
        report_path.unlink()
        
    ini_content = generate_ini_content(ea_name, 1.0, 1.0)
    ini_path.write_text(ini_content, encoding='utf-8')
    
    cmd = [str(terminal), f"/config:{ini_path}"]
    print(f"[+] Launching backtest for {ea_name} on XAUUSD_Hist M5...")
    proc = subprocess.Popen(cmd)
    
    try:
        proc.wait(timeout=180)
        print("[+] Backtest process finished.")
    except subprocess.TimeoutExpired:
        print("[-] Backtest timed out. Killing terminal64.exe...")
        subprocess.run(["taskkill", "/F", "/IM", "terminal64.exe"], capture_output=True)

    valid, msg = validate_report_trades(str(report_path))
    print(f"Validation Result: {valid} - {msg}")

if __name__ == "__main__":
    import sys
    ea = sys.argv[1] if len(sys.argv) > 1 else "MasterEA_v1"
    run_backtest(ea)
