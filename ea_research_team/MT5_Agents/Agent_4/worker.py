import os
import glob
import subprocess

agent_dir = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Agents\Agent_4"
experts_dir = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Agents\Agent_4\MQL5\Experts\Mass_Test"
reports_dir = r"G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\MT5_Parallel_Reports"
terminal = os.path.join(agent_dir, "terminal64.exe")

ex5_files = glob.glob(os.path.join(experts_dir, "*.ex5"))

for count, ex5 in enumerate(ex5_files):
    ea_name = os.path.basename(ex5)
    ea_base = os.path.splitext(ea_name)[0]
    
    for tf in ["M1", "M5"]:
        report_path = os.path.join(reports_dir, f"Report_Agent4_{ea_base}_{tf}.xml")
        
        # Skip if already exists (resume capability)
        if os.path.exists(report_path):
            print(f"Agent 4 Skipping {ea_name} {tf} (already tested)")
            continue
            
        ini_content = f'''[Tester]
Expert=Mass_Test\\{ea_name}
Symbol=XAUUSD
Period={tf}
Model=4
Optimization=0
FromDate=2025.06.14
ToDate=2026.06.14
ForwardMode=0
Report={report_path}
ReplaceReport=1
ShutdownTerminal=1
'''
        ini_path = os.path.join(agent_dir, "tester.ini")
        # MT5 requires UTF-16 with BOM for ini files to correctly parse unicode characters
        with open(ini_path, "w", encoding="utf-16") as f:
            f.write(ini_content)
            
        print(f"Agent 4 Testing [{count+1}/{len(ex5_files)}]: {ea_name} on {tf}...")
        subprocess.run(f'"{terminal}" /portable /config:"{ini_path}"', shell=True)
