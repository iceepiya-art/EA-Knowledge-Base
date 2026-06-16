import glob
import os
import re
from pathlib import Path

logs_dir = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\tester\logs")
log_files = glob.glob(str(logs_dir / "*.log"))
if not log_files:
    print("No logs")
else:
    latest = max(log_files, key=os.path.getmtime)
    with open(latest, 'r', encoding='utf-16', errors='ignore') as f:
        content = f.read()
    if not content:
        with open(latest, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    
    matches = re.findall(r'final balance ([\d\.]+) USD', content)
    print(f"All final balances found: {matches}")
