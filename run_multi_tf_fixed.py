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

tfs = ["H1", "M30", "M15", "M5", "M1"]
results = []

def compile_ea(tf_enum):
    content = ea_path.read_text(encoding='utf-8')
    content = re.sub(r'input ENUM_TIMEFRAMES MainTimeframe\s*=\s*PERIOD_[A-Z0-9]+;', f'input ENUM_TIMEFRAMES MainTimeframe  = PERIOD_{tf_enum};', content)
    ea_path.write_text(content, encoding='utf-8')
    cmd = [str(metaeditor), f"/compile:{ea_path.resolve()}", "/log"]
    subprocess.run(cmd, capture_output=True, timeout=30)

def get_latest_log_balance():
    time.sleep(2)
    log_files = glob.glob(str(tester_logs_dir / "*.log"))
    if not log_files:
        return 0.0, 0
    latest_log = max(log_files, key=os.path.getmtime)
    with open(latest_log, 'r', encoding='utf-16', errors='ignore') as f:
        content = f.read()
    if not content:
        with open(latest_log, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            
    # Split by the MT5 backtest footer to find the last run
    chunks = re.split(r'history cache allocated for', content)
    last_chunk = chunks[-1] if len(chunks) > 1 else content
    
    balance_match = re.search(r'final balance ([\d\.]+) USD', last_chunk)
    deal_matches = re.findall(r'deal #\d+ buy', last_chunk) + re.findall(r'deal #\d+ sell', last_chunk)
    
    bal = float(balance_match.group(1)) if balance_match else 0.0
    trades = len(deal_matches)
    return bal, trades

for tf in tfs:
    print(f"\n[+] Running {tf}...")
    compile_ea(tf)
    ini_content = f'''[Tester]
Expert=MasterEA_v1
Symbol=XAUUSD_Hist
Period={tf}
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
        proc.wait(timeout=180)
    except subprocess.TimeoutExpired:
        subprocess.run(["taskkill", "/F", "/IM", "terminal64.exe"], capture_output=True)
    
    bal, trades = get_latest_log_balance()
    profit = bal - 10000.0 if bal > 0 else 0.0
    print(f"  -> Profit:  | Trades: {trades}")
    results.append({"tf": tf, "profit": profit, "trades": trades})

print("\n=== CORRECTED MULTI-TIMEFRAME RESULTS ===")
for r in results:
    print(f"{r['tf']}: Profit , Trades {r['trades']}")
