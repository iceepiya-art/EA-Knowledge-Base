import os
import glob
import shutil
import subprocess
import time
import xml.etree.ElementTree as ET

# Paths
UNIVERSAL_EA_PATH = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Agents\Base_Experts\Universal_Validation_EA.mq5"
AGENTS_BASE_DIR = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Agents"
REPORTS_DIR = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Validation_Reports"
MASTER_CONFIG_DIR = r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850\config"
MASTER_TERMINAL = r"C:\Program Files\FTMO Global Markets MT5 Terminal\terminal64.exe"
MASTER_METAEDITOR = r"C:\Program Files\FTMO Global Markets MT5 Terminal\metaeditor64.exe"

NUM_AGENTS = 4
TOTAL_RULES = 5 # Simulating testing Rule IDs 1 to 5 for now

os.makedirs(AGENTS_BASE_DIR, exist_ok=True)
os.makedirs(REPORTS_DIR, exist_ok=True)

# Distribute rules
rules = list(range(1, TOTAL_RULES + 1))
import math
chunk_size = math.ceil(len(rules) / NUM_AGENTS)
if chunk_size == 0:
    chunk_size = 1

chunks = [rules[i:i + chunk_size] for i in range(0, len(rules), chunk_size)]

print("\n1. Distributing Work and Launching Parallel Agents...")
processes = []

for i in range(NUM_AGENTS):
    agent_dir = os.path.join(AGENTS_BASE_DIR, f"Agent_{i+1}")
    if i >= len(chunks):
        break
        
    my_rules = chunks[i]
    experts_dir = os.path.join(agent_dir, "MQL5", "Experts", "Validation_Lab")
    os.makedirs(experts_dir, exist_ok=True)
    
    print(f"Agent {i+1} received {len(my_rules)} Rules to test.")
    
    # Clone the user's config to ensure account is logged in
    shutil.copytree(MASTER_CONFIG_DIR, os.path.join(agent_dir, "config"), dirs_exist_ok=True)
    
    # Copy MetaTrader executables to make it truly portable
    if not os.path.exists(os.path.join(agent_dir, "terminal64.exe")):
        shutil.copy(MASTER_TERMINAL, agent_dir)
    if not os.path.exists(os.path.join(agent_dir, "metaeditor64.exe")):
        shutil.copy(MASTER_METAEDITOR, agent_dir)
    
    # Copy EA
    shutil.copy(UNIVERSAL_EA_PATH, experts_dir)
        
    # Compile
    metaeditor = os.path.join(agent_dir, "metaeditor64.exe")
    print(f"Agent {i+1} compiling EA...")
    subprocess.run(f'"{metaeditor}" /portable /compile:"{experts_dir}" /log', shell=True)
    
    # Generate worker script
    worker_script = f"""import os
import subprocess

agent_dir = r"{agent_dir}"
reports_dir = r"{REPORTS_DIR}"
terminal = os.path.join(agent_dir, "terminal64.exe")
rules = {my_rules}

for rule_id in rules:
    local_report = os.path.join(agent_dir, f"Report_Rule{{rule_id}}.xml")
    final_report = os.path.join(reports_dir, f"Report_Rule{{rule_id}}.xml")
    
    if os.path.exists(final_report):
        print(f"Agent {i+1} Skipping Rule {{rule_id}} (already tested)")
        continue
        
    ini_content = f'''[Tester]
Expert=Validation_Lab\\\\Universal_Validation_EA.ex5
Symbol=XAUUSD
Period=M5
Model=0
Optimization=0
FromDate=2025.01.01
ToDate=2026.01.01
ForwardMode=0
Deposit=100000
Currency=USD
Leverage=100
Report={{local_report}}
ReplaceReport=1
ShutdownTerminal=1

[TesterInputs]
InpRuleID={{rule_id}}
'''
    ini_path = os.path.join(agent_dir, "tester.ini")
    with open(ini_path, "w", encoding="utf-16") as f:
        f.write(ini_content)
        
    print(f"Agent {i+1} Testing Rule {{rule_id}}...")
    subprocess.run(f'"{{terminal}}" /portable /config:"{{ini_path}}"', shell=True)
    
    import shutil
    if os.path.exists(local_report):
        shutil.copy(local_report, final_report)
"""
    worker_path = os.path.join(agent_dir, "worker.py")
    with open(worker_path, "w", encoding="utf-8") as f:
        f.write(worker_script)
        
    # Launch worker
    p = subprocess.Popen(["python", worker_path], cwd=agent_dir)
    processes.append(p)

print(f"\n[Parallel Execution Started] Waiting for {len(processes)} agents to finish...")
for p in processes:
    p.wait()

print("\n=============================================")
print("2. Validation Run Completed! Parsing Results...")

# Analyze results (TDD Assertion)
passed_rules = []
failed_rules = []

for rule_id in range(1, TOTAL_RULES + 1):
    report_path = os.path.join(REPORTS_DIR, f"Report_Rule{rule_id}.xml")
    trades = 0
    if os.path.exists(report_path):
        try:
            tree = ET.parse(report_path)
            root = tree.getroot()
            total_trades_node = root.find(".//TotalTrades")
            if total_trades_node is not None:
                trades = int(total_trades_node.text)
        except Exception as e:
            pass
            
    if trades == 0:
        # Fallback to reading the tester log
        # Find which agent ran this rule
        for i in range(NUM_AGENTS):
            if rule_id in chunks[i]:
                log_dir = os.path.join(AGENTS_BASE_DIR, f"Agent_{i+1}", "tester", "logs")
                if os.path.exists(log_dir):
                    logs = glob.glob(os.path.join(log_dir, "*.log"))
                    if logs:
                        latest_log = max(logs, key=os.path.getctime)
                        try:
                            with open(latest_log, "r", encoding="utf-16", errors="ignore") as f:
                                content = f.read()
                                # Count successful trades
                                trades = content.count("CTrade::OrderSend:")
                        except Exception:
                            pass
                break

    if trades >= 1000:
        passed_rules.append((rule_id, trades))
    else:
        failed_rules.append((rule_id, trades))

print("\n--- TDD VALIDATION RESULTS ---")
print(f"Passed: {len(passed_rules)}")
for r, t in passed_rules:
    print(f"  [PASS] Rule {r}: {t} trades")

print(f"\nFailed (Frequency < 1000): {len(failed_rules)}")
for r, t in failed_rules:
    print(f"  [FAIL] Rule {r}: {t} trades")

# Write report
report_text = f"# Knowledge Validation Lab Report\n\nTotal Rules Tested: {TOTAL_RULES}\nPassed: {len(passed_rules)}\nFailed: {len(failed_rules)}\n\n"
report_text += "## Passed Rules\n" + "\\n".join([f"- Rule {r} ({t} trades)" for r, t in passed_rules]) + "\n\n"
report_text += "## Failed Rules\n" + "\\n".join([f"- Rule {r} ({t} trades)" for r, t in failed_rules]) + "\n"

with open(r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\raw\knowledge_validation_lab_report.md", "w") as f:
    f.write(report_text)

print("\nDetailed report saved to: raw/knowledge_validation_lab_report.md")
