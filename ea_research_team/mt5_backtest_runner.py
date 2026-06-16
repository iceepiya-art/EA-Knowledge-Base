import os
import glob
import shutil
import subprocess
from pathlib import Path

# Paths
SOURCE_DIR = r"G:\My Drive\jobot\EA Week1"
TERMINAL_EXE = r"C:\Program Files\FTMO Global Markets MT5 Terminal\terminal64.exe"
METAEDITOR_EXE = r"C:\Program Files\FTMO Global Markets MT5 Terminal\metaeditor64.exe"
MT5_DATA_DIR = r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850"

EXPERTS_DIR = os.path.join(MT5_DATA_DIR, r"MQL5\Experts\Jobot_Week1")
TESTER_DIR = os.path.join(MT5_DATA_DIR, r"Tester")
REPORTS_DIR = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Reports"

# Limits for the demo run (Set to 999 to run all)
MAX_EAS = 3

os.makedirs(EXPERTS_DIR, exist_ok=True)
os.makedirs(REPORTS_DIR, exist_ok=True)

print("1. Finding all .mq5 and .ex5 files...")
mq5_files = glob.glob(os.path.join(SOURCE_DIR, "*.mq5"))
ex5_files = glob.glob(os.path.join(SOURCE_DIR, "*.ex5"))

print(f"Found {len(mq5_files)} .mq5 and {len(ex5_files)} .ex5 files.")

# Copy files to Experts folder
for f in mq5_files + ex5_files:
    shutil.copy(f, EXPERTS_DIR)

print("2. Compiling .mq5 files...")
# Batch compile the whole folder
compile_cmd = f'"{METAEDITOR_EXE}" /compile:"{EXPERTS_DIR}" /log'
subprocess.run(compile_cmd, shell=True)

# Get all compiled .ex5 files in the destination
final_ex5_files = glob.glob(os.path.join(EXPERTS_DIR, "*.ex5"))
print(f"Total compiled EAs ready to test: {len(final_ex5_files)}")

count = 0
for ex5_path in final_ex5_files:
    if count >= MAX_EAS:
        break
        
    ea_name = os.path.basename(ex5_path)
    ea_base = os.path.splitext(ea_name)[0]
    
    print(f"\n--- Testing EA: {ea_name} ---")
    
    # 1 Year, Real Ticks (Model=4)
    # M1 and M5 requires two runs, we'll do M1 here as an example
    for timeframe in ["M1", "M5"]:
        print(f"Running Timeframe: {timeframe}")
        report_name = f"Report_{ea_base}_{timeframe}"
        report_path = os.path.join(REPORTS_DIR, f"{report_name}.xml")
        
        ini_content = f"""[Tester]
Expert=Jobot_Week1\\{ea_name}
Symbol=XAUUSD
Period={timeframe}
Model=4
Optimization=0
FromDate=2025.06.14
ToDate=2026.06.14
ForwardMode=0
Report={report_path}
ReplaceReport=1
ShutdownTerminal=1
"""
        ini_path = os.path.join(MT5_DATA_DIR, "tester.ini")
        with open(ini_path, "w", encoding="utf-8") as f:
            f.write(ini_content)
            
        print("Launching MT5 Terminal...")
        # Run terminal blockingly
        cmd = f'"{TERMINAL_EXE}" /config:"{ini_path}"'
        subprocess.run(cmd, shell=True)
        
        print(f"Completed! Report saved to {report_path}")
        
    count += 1

print("\nAll selected EAs have been tested!")
