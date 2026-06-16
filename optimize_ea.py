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

configs = [
    {"fvg": 5.0, "adx": 25.0},
    {"fvg": 3.0, "adx": 25.0},
    {"fvg": 1.0, "adx": 25.0},
    {"fvg": 5.0, "adx": 20.0},
    {"fvg": 3.0, "adx": 20.0},
    {"fvg": 1.0, "adx": 20.0}
]

results = []

def modify_ea(fvg, adx):
    content = ea_path.read_text(encoding='utf-8')
    content = re.sub(r'input double\s+FVG_MinSizePips\s*=\s*[\d\.]+;', f'input double    FVG_MinSizePips     = {fvg};', content)
    content = re.sub(r'input double\s+ADX_TrendThreshold\s*=\s*[\d\.]+;', f'input double    ADX_TrendThreshold  = {adx};', content)
    ea_path.write_text(content, encoding='utf-8')

def compile_ea():
    cmd = [str(metaeditor), f"/compile:{ea_path.resolve()}", "/log"]
    subprocess.run(cmd, capture_output=True, timeout=30)

def run_backtest():
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

def get_latest_log_balance():
    # Wait a moment for logs to flush
    time.sleep(2)
    log_files = glob.glob(str(tester_logs_dir / "*.log"))
    if not log_files:
        return "No Log", 0
    latest_log = max(log_files, key=os.path.getmtime)
    with open(latest_log, 'r', encoding='utf-16', errors='ignore') as f:
        content = f.read()
    if not content:
        with open(latest_log, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            
    balance_match = re.search(r'final balance ([\d\.]+) USD', content)
    deal_matches = re.findall(r'deal #\d+ buy', content) + re.findall(r'deal #\d+ sell', content)
    
    bal = float(balance_match.group(1)) if balance_match else 10000.0
    trades = len(deal_matches)
    return bal, trades

print("Starting Grid Search...")
for i, cfg in enumerate(configs):
    fvg = cfg['fvg']
    adx = cfg['adx']
    print(f"Running Test {i+1}/6: FVG={fvg}, ADX={adx}")
    modify_ea(fvg, adx)
    compile_ea()
    run_backtest()
    bal, trades = get_latest_log_balance()
    profit = bal - 10000.0
    print(f"  Result -> Profit: , Trades: {trades}")
    results.append({"fvg": fvg, "adx": adx, "profit": profit, "trades": trades})

best = max(results, key=lambda x: x['profit'])
print("\n=== OPTIMIZATION COMPLETE ===")
print(f"Best Config: FVG={best['fvg']}, ADX={best['adx']} -> Profit: ")

# Restore best params
modify_ea(best['fvg'], best['adx'])
compile_ea()
