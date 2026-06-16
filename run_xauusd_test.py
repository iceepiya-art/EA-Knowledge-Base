import subprocess
import time
from pathlib import Path
import shutil

terminal = Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal\terminal64.exe")
ea_name = "MasterEA_v1"
ini_path = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\backtest_temp.ini")
report_path = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\MasterEA_Report.xml")

if report_path.exists():
    report_path.unlink()

ini_content = f'''[Tester]
Expert={ea_name}
Symbol=XAUUSD_Hist
Period=M15
Optimization=0
Model=1
FromDate=2026.01.01
ToDate=2026.06.05
ForwardMode=0
Report={report_path}
ShutdownTerminal=1
'''
ini_path.write_text(ini_content, encoding='utf-8')

cmd = [str(terminal), f"/config:{ini_path}"]
print("[+] Launching backtest for XAUUSD_Hist...")
proc = subprocess.Popen(cmd)

try:
    proc.wait(timeout=90)
    print("[+] Backtest process finished.")
except subprocess.TimeoutExpired:
    print("[-] Backtest timed out. Killing terminal64.exe...")
    subprocess.run(["taskkill", "/F", "/IM", "terminal64.exe"], capture_output=True)

if report_path.exists():
    print(f"[+] Report generated! Size: {report_path.stat().st_size} bytes")
    # Print the first few lines of the report to verify
    content = report_path.read_text(encoding='utf-16', errors='ignore')
    if not content:
        content = report_path.read_text(encoding='utf-8', errors='ignore')
    print("Report Extract:")
    print(content[:1000])
else:
    print("[-] No report generated.")
