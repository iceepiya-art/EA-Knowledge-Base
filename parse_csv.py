import os
import re
import glob
from pathlib import Path
import csv

logs_dir = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\tester\logs")
artifact_csv = Path(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\artifacts\backtest_trades.csv")

log_files = glob.glob(str(logs_dir / "*.log"))
if not log_files:
    print("No logs found.")
    exit()

latest = max(log_files, key=os.path.getmtime)
with open(latest, 'r', encoding='utf-16', errors='ignore') as f:
    content = f.read()
if not content:
    with open(latest, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()

# Split by the MT5 backtest footer to find the last run
chunks = re.split(r'history cache allocated for', content)
last_chunk = chunks[-1] if len(chunks) > 1 else content

# regex to find deals: 2026.01.06 13:30:00   deal #962 buy 0.01 XAUUSD_Hist at 4459.47 done
deal_pattern = re.compile(r'(\d{4}\.\d{2}\.\d{2} \d{2}:\d{2}:\d{2})\s+deal #(\d+) (buy|sell) ([\d\.]+) [a-zA-Z0-9_]+ at ([\d\.]+) done')

trades = []
for line in last_chunk.splitlines():
    match = deal_pattern.search(line)
    if match:
        time_str = match.group(1)
        ticket = match.group(2)
        type_str = match.group(3).upper()
        volume = match.group(4)
        price = match.group(5)
        trades.append([ticket, time_str, type_str, volume, price])

with open(artifact_csv, 'w', newline='', encoding='utf-8') as f:
    writer = csv.writer(f)
    writer.writerow(['Ticket', 'Time', 'Type', 'Volume', 'Price'])
    writer.writerows(trades)

print(f"[+] Exported {len(trades)} trades to {artifact_csv}")
