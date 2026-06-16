import os
import re
import subprocess
import time
from pathlib import Path
import glob
import shutil

terminal = Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal\terminal64.exe")
metaeditor = Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal\metaeditor64.exe")
ea_path = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\artifacts\generated_ea\MasterEA_v1.mq5")
dest_path = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\MasterEA_v1.mq5")
ini_path = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\backtest_master.ini")
tester_files_dir = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\tester\Agent-127.0.0.1-3000\MQL5\Files")
artifact_csv = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\artifacts\backtest_trades.csv")

shutil.copyfile(ea_path, dest_path)
cmd = [str(metaeditor), f"/compile:{dest_path.resolve()}", "/log"]
subprocess.run(cmd, capture_output=True, timeout=30)

ini_content = f'''[Tester]
Expert=MasterEA_v1
Symbol=XAUUSD_Hist
Period=M15
Optimization=0
Model=1
Deposit=10000
Currency=USD
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
csv_file = tester_files_dir / "backtest_trades.csv"
if csv_file.exists():
    shutil.copyfile(csv_file, artifact_csv)
    print(f"\n[+] Successfully exported trades to CSV: {artifact_csv}")
else:
    print(f"\n[-] CSV file not found at {csv_file}")
