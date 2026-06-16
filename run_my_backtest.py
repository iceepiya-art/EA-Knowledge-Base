import subprocess
import time
from pathlib import Path

terminal = Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal\terminal64.exe")
ea_name = "MasterEA_v1"
ini_path = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\backtest_temp.ini")
report_path = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\MasterEA_Report.htm")

ini_content = f'''[Tester]
Expert={ea_name}
Symbol=EURUSD
Period=H1
Optimization=0
Model=2
FromDate=2024.01.01
ToDate=2024.01.14
ForwardMode=0
Report={report_path}
ShutdownTerminal=1
'''
ini_path.write_text(ini_content, encoding='utf-8')

cmd = [str(terminal), f"/config:{ini_path}"]
print("[+] Launching backtest...")
proc = subprocess.Popen(cmd)

try:
    proc.wait(timeout=60)
    print("[+] Backtest process finished.")
except subprocess.TimeoutExpired:
    print("[-] Backtest timed out. Killing terminal64.exe...")
    subprocess.run(["taskkill", "/F", "/IM", "terminal64.exe"], capture_output=True)

if report_path.exists():
    print(f"[+] Report generated! Size: {report_path.stat().st_size} bytes")
else:
    print("[-] No report generated.")
