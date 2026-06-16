import os
import subprocess
import glob

agent_dir = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Agents\Agent_1"
terminal = os.path.join(agent_dir, "terminal64.exe")
ini = os.path.join(agent_dir, "tester.ini")

ini_content = """[Tester]
Expert=Validation_Lab\\Universal_Validation_EA.ex5
Symbol=XAUUSD
Period=M5
Model=0
FromDate=2025.01.01
ToDate=2026.01.01
Report=TestReport123.xml
ReplaceReport=1
ShutdownTerminal=1

[TesterInputs]
InpRuleID=1
"""

with open(ini, "w", encoding="utf-16") as f:
    f.write(ini_content)

print("Running terminal...")
subprocess.run(f'"{terminal}" /portable /config:"{ini}"', shell=True)

xmls = glob.glob(os.path.join(agent_dir, "**", "TestReport123.xml"), recursive=True)
print("Found reports:", xmls)
