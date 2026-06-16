import os
import glob
import shutil
import subprocess
import time
from pathlib import Path

# Paths
SOURCE_DIR = r"G:\My Drive\jobot\EA Week1"
ORIGINAL_TERMINAL_DIR = r"C:\Program Files\FTMO Global Markets MT5 Terminal"
AGENTS_BASE_DIR = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Agents"
REPORTS_DIR = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Parallel_Reports"

NUM_AGENTS = 4
MAX_EAS_PER_AGENT = 999  # Set higher for full run. 2 * 4 = 8 EAs total for demo.

os.makedirs(AGENTS_BASE_DIR, exist_ok=True)
os.makedirs(REPORTS_DIR, exist_ok=True)

print("1. Preparing MT5 Clones (Agents)...")
agent_dirs = []
for i in range(1, NUM_AGENTS + 1):
    agent_dir = os.path.join(AGENTS_BASE_DIR, f"Agent_{i}")
    agent_dirs.append(agent_dir)
    if not os.path.exists(os.path.join(agent_dir, "terminal64.exe")):
        print(f"Cloning MT5 to {agent_dir} (This may take a minute)...")
        # Copy directory tree
        shutil.copytree(ORIGINAL_TERMINAL_DIR, agent_dir, dirs_exist_ok=True)
    else:
        print(f"Agent {i} already cloned at {agent_dir}")

print("\n2. Finding EAs...")
mq5_files = glob.glob(os.path.join(SOURCE_DIR, "*.mq5"))
ex5_files = glob.glob(os.path.join(SOURCE_DIR, "*.ex5"))

# We prioritize ex5, then mq5 (avoiding duplicates if both exist)
ea_dict = {}
for f in mq5_files + ex5_files:
    base = os.path.splitext(os.path.basename(f))[0]
    # Keep the ex5 if both exist, otherwise mq5
    if f.endswith('.ex5') or base not in ea_dict:
        ea_dict[base] = f

all_eas = list(ea_dict.values())
print(f"Found {len(all_eas)} unique EAs.")

# Divide into chunks
chunk_size = MAX_EAS_PER_AGENT
chunks = [all_eas[i:i + chunk_size] for i in range(0, min(len(all_eas), NUM_AGENTS * chunk_size), chunk_size)]

print("\n3. Distributing Work and Launching Parallel Agents...")
processes = []

for i, agent_dir in enumerate(agent_dirs):
    if i >= len(chunks):
        break
    
    my_eas = chunks[i]
    experts_dir = os.path.join(agent_dir, "MQL5", "Experts", "Jobot_Week1")
    os.makedirs(experts_dir, exist_ok=True)
    
    print(f"Agent {i+1} received {len(my_eas)} EAs.")
    
    # Copy EAs to agent's MQL5 folder
    for ea_file in my_eas:
        shutil.copy(ea_file, experts_dir)
        
    # Compile
    metaeditor = os.path.join(agent_dir, "metaeditor64.exe")
    print(f"Agent {i+1} compiling EAs...")
    subprocess.run(f'"{metaeditor}" /portable /compile:"{experts_dir}" /log', shell=True)
    
    # Generate tester batch script because MT5 tester.ini only runs 1 EA. 
    # To run multiple EAs sequentially in the SAME agent, we need a python sub-script 
    # or just run them one by one blockingly? 
    # Actually, we can write a python worker script inside each agent folder!
    
    worker_script = f"""import os
import glob
import subprocess

agent_dir = r"{agent_dir}"
experts_dir = r"{experts_dir}"
reports_dir = r"{REPORTS_DIR}"
terminal = os.path.join(agent_dir, "terminal64.exe")

ex5_files = glob.glob(os.path.join(experts_dir, "*.ex5"))

for ex5 in ex5_files:
    ea_name = os.path.basename(ex5)
    ea_base = os.path.splitext(ea_name)[0]
    
    # Just M1 for demo speed
    for tf in ["M1", "M5"]:
        report_path = os.path.join(reports_dir, f"Report_Agent{i+1}_{{ea_base}}_{{tf}}.xml")
        ini_content = f'''[Tester]
Expert=Jobot_Week1\\\\{{ea_name}}
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
        with open(ini_path, "w", encoding="utf-8") as f:
            f.write(ini_content)
            
        print(f"Agent {i+1} Testing {{ea_name}} on {{tf}}...")
        subprocess.run(f'"{{terminal}}" /portable /config:"{{ini_path}}"', shell=True)
"""
    worker_path = os.path.join(agent_dir, "worker.py")
    with open(worker_path, "w", encoding="utf-8") as f:
        f.write(worker_script)
        
    # Launch worker asynchronously
    p = subprocess.Popen(["python", worker_path], cwd=agent_dir)
    processes.append(p)

print(f"\n[Parallel Execution Started] Waiting for {len(processes)} agents to finish...")
for p in processes:
    p.wait()

print("\n=============================================")
print("All Agents Completed Successfully!")
print(f"Reports saved to: {REPORTS_DIR}")
print("=============================================")
