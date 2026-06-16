import os
import glob
import shutil
import subprocess
import time

# Paths
SOURCE_BASE_DIR = r"G:\My Drive\jobot"
AGENTS_BASE_DIR = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Agents"
REPORTS_DIR = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Parallel_Reports"
MASTER_CONFIG_DIR = r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\config"

DIRS = ['EA Week1', 'EA Week2', 'EA Week3', 'EA Week4', 'EA Week5', 'EA Week6', 'EA Week7', 'EA Week8', 'EA Week9', 'EA Week10', 'ICEE PROFIT']

NUM_AGENTS = 4
MAX_EAS_PER_AGENT = 9999  # Unlimited

os.makedirs(AGENTS_BASE_DIR, exist_ok=True)
os.makedirs(REPORTS_DIR, exist_ok=True)

print("1. Identifying EAs from all target folders...")
all_eas_dict = {}

for d in DIRS:
    path = os.path.join(SOURCE_BASE_DIR, d)
    if os.path.exists(path):
        mq5_files = glob.glob(os.path.join(path, '**', '*.mq5'), recursive=True)
        ex5_files = glob.glob(os.path.join(path, '**', '*.ex5'), recursive=True)
        
        for f in mq5_files + ex5_files:
            # Create a unique key using folder name to avoid naming collisions
            base = os.path.splitext(os.path.basename(f))[0]
            unique_key = f"{d.replace(' ', '_')}_{base}"
            
            # Prioritize ex5
            if f.endswith('.ex5') or unique_key not in all_eas_dict:
                all_eas_dict[unique_key] = f

all_eas = list(all_eas_dict.values())
print(f"Total Unique EAs found across all folders: {len(all_eas)}")

# Divide into chunks
import math
chunk_size = math.ceil(len(all_eas) / NUM_AGENTS)
if chunk_size == 0:
    chunk_size = 1

chunks = [all_eas[i:i + chunk_size] for i in range(0, len(all_eas), chunk_size)]

print("\n2. Distributing Work and Launching Parallel Agents...")
processes = []

for i in range(NUM_AGENTS):
    agent_dir = os.path.join(AGENTS_BASE_DIR, f"Agent_{i+1}")
    if i >= len(chunks):
        break
        
    my_eas = chunks[i]
    experts_dir = os.path.join(agent_dir, "MQL5", "Experts", "Mass_Test")
    os.makedirs(experts_dir, exist_ok=True)
    
    print(f"Agent {i+1} received {len(my_eas)} EAs.")
    
    # Clone the user's config to ensure account is logged in for downloading Tick Data
    shutil.copytree(MASTER_CONFIG_DIR, os.path.join(agent_dir, "config"), dirs_exist_ok=True)
    
    # Copy EAs
    for ea_file in my_eas:
        shutil.copy(ea_file, experts_dir)
        
    # Compile
    metaeditor = os.path.join(agent_dir, "metaeditor64.exe")
    print(f"Agent {i+1} compiling EAs...")
    subprocess.run(f'"{metaeditor}" /portable /compile:"{experts_dir}" /log', shell=True)
    
    # Generate worker script
    worker_script = f"""import os
import glob
import subprocess

agent_dir = r"{agent_dir}"
experts_dir = r"{experts_dir}"
reports_dir = r"{REPORTS_DIR}"
terminal = os.path.join(agent_dir, "terminal64.exe")

ex5_files = glob.glob(os.path.join(experts_dir, "*.ex5"))

for count, ex5 in enumerate(ex5_files):
    ea_name = os.path.basename(ex5)
    ea_base = os.path.splitext(ea_name)[0]
    
    for tf in ["M1", "M5"]:
        report_path = os.path.join(reports_dir, f"Report_Agent{i+1}_{{ea_base}}_{{tf}}.xml")
        
        # Skip if already exists (resume capability)
        if os.path.exists(report_path):
            print(f"Agent {i+1} Skipping {{ea_name}} {{tf}} (already tested)")
            continue
            
        ini_content = f'''[Tester]
Expert=Mass_Test\\\\{{ea_name}}
Symbol=XAUUSD
Period={{tf}}
Model=4
Optimization=0
FromDate=2025.06.14
ToDate=2026.06.14
ForwardMode=0
Report={{report_path}}
ReplaceReport=1
ShutdownTerminal=1
'''
        ini_path = os.path.join(agent_dir, "tester.ini")
        # MT5 requires UTF-16 with BOM for ini files to correctly parse unicode characters
        with open(ini_path, "w", encoding="utf-16") as f:
            f.write(ini_content)
            
        print(f"Agent {i+1} Testing [{{count+1}}/{{len(ex5_files)}}]: {{ea_name}} on {{tf}}...")
        subprocess.run(f'"{{terminal}}" /portable /config:"{{ini_path}}"', shell=True)
"""
    worker_path = os.path.join(agent_dir, "worker.py")
    with open(worker_path, "w", encoding="utf-8") as f:
        f.write(worker_script)
        
    # Launch worker
    p = subprocess.Popen(["python", worker_path], cwd=agent_dir)
    processes.append(p)

print(f"\n[MASS Parallel Execution Started] Waiting for {len(processes)} agents to finish ~75 hours...")
for p in processes:
    p.wait()

print("\n=============================================")
print("MASS MT5 RUN COMPLETED!")
print(f"Reports saved to: {REPORTS_DIR}")
print("=============================================")
