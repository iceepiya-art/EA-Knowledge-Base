import os
import re
import subprocess
import time
from pathlib import Path
import glob

terminal = Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal\terminal64.exe")
metaeditor = Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal\metaeditor64.exe")
ea_path = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\MasterEA_v1.mq5")
ini_path = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\backtest_temp.ini")
tester_logs_dir = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\tester\logs")

print("[+] Compiling...")
cmd = [str(metaeditor), f"/compile:{ea_path.resolve()}", "/log"]
subprocess.run(cmd, capture_output=True, timeout=30)

print("[+] Running backtest...")
ini_content = f'''[Tester]
Expert=MasterEA_v1
Symbol=XAUUSD_Hist
Period=M15
Optimization=0
Model=1
FromDate=2026.01.01
ToDate=2026.06.05
ForwardMode=0
ShutdownTerminal=1
'''
ini_path.write_text(ini_content, encoding='utf-8')
cmd = [str(terminal), f"/config:{ini_path}"]
proc = subprocess.Popen(cmd)
try:
    proc.wait(timeout=90)
except subprocess.TimeoutExpired:
    subprocess.run(["taskkill", "/F", "/IM", "terminal64.exe"], capture_output=True)

time.sleep(2)
log_files = glob.glob(str(tester_logs_dir / "*.log"))
if log_files:
    latest_log = max(log_files, key=os.path.getmtime)
    with open(latest_log, 'r', encoding='utf-16', errors='ignore') as f:
        content = f.read()
    if not content:
        with open(latest_log, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            
    balance_match = re.search(r'final balance ([\d\.]+) USD', content)
    deal_matches = re.findall(r'deal #\d+ buy', content) + re.findall(r'deal #\d+ sell', content)
    
    bal = float(balance_match.group(1)) if balance_match else 0.0
    trades = len(deal_matches)
    print(f"\n[!!!] BACKTEST RESULTS -> Final Balance:  | Total Deals: {trades}")
else:
    print("[-] No logs found.")
