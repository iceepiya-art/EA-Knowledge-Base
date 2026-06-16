import re
from pathlib import Path

log_path = Path(r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\tester\logs\20260606.log")
with open(log_path, 'r', encoding='utf-16', errors='ignore') as f:
    content = f.read()
if not content:
    with open(log_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()

# Split by "history cache allocated" to get individual test runs
runs = re.split(r'history cache allocated for', content)
# The first element is pre-run junk. The subsequent elements correspond to the runs.
# But wait, there are H1 history cache allocations inside the runs!
# Let's split by "Test passed" or just find all "final balance"
balances = re.findall(r'final balance ([\d\.]+) USD', content)
# We know the last 5 balances belong to H1, M30, M15, M5, M1
print("All final balances found in log:", balances[-10:])

# To get trades per run, we can split by "final balance" and count "deal #... buy|sell" in each chunk
chunks = re.split(r'final balance [\d\.]+ USD', content)
for i, chunk in enumerate(chunks[-6:-1]): # the last 5 chunks before their respective final balances
    deals = len(re.findall(r'deal #\d+ buy', chunk) + re.findall(r'deal #\d+ sell', chunk))
    print(f"Run {i+1}: Trades {deals}")

