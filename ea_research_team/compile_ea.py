import subprocess
import os

experts_dir = r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\MQL5\Experts\Mass_Test"
metaeditor = r"C:\Program Files\FTMO Global Markets MT5 Terminal\metaeditor64.exe"

cmd = f'"{metaeditor}" /compile:"{experts_dir}" /log'
print(f"Executing: {cmd}")

result = subprocess.run(cmd, shell=True)
print(f"Return code: {result.returncode}")

log_path = os.path.join(experts_dir, "compile.log")
if os.path.exists(log_path):
    print("--- COMPILE LOG ---")
    with open(log_path, "r", encoding="utf-16", errors="ignore") as f:
        print(f.read())
else:
    print("No compile.log found.")
