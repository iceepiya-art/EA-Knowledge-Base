import os
import subprocess

agent_dir = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Agents\Agent_2"
reports_dir = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Validation_Reports"
terminal = os.path.join(agent_dir, "terminal64.exe")
rules = [3, 4]

for rule_id in rules:
    local_report = os.path.join(agent_dir, f"Report_Rule{rule_id}.xml")
    final_report = os.path.join(reports_dir, f"Report_Rule{rule_id}.xml")
    
    if os.path.exists(final_report):
        print(f"Agent 2 Skipping Rule {rule_id} (already tested)")
        continue
        
    ini_content = f'''[Tester]
Expert=Validation_Lab\\Universal_Validation_EA.ex5
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
Report={local_report}
ReplaceReport=1
ShutdownTerminal=1

[TesterInputs]
InpRuleID={rule_id}
'''
    ini_path = os.path.join(agent_dir, "tester.ini")
    with open(ini_path, "w", encoding="utf-16") as f:
        f.write(ini_content)
        
    print(f"Agent 2 Testing Rule {rule_id}...")
    subprocess.run(f'"{terminal}" /portable /config:"{ini_path}"', shell=True)
    
    import shutil
    if os.path.exists(local_report):
        shutil.copy(local_report, final_report)
