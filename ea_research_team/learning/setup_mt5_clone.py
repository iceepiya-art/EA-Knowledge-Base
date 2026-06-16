import os
import shutil
import subprocess
import time
from pathlib import Path

def setup_and_test_clone():
    source_dir = r"C:\Program Files\FTMO Global Markets MT5 Terminal"
    clone_dir = r"C:\Users\ADMIN\Documents\MT5_Clone_Screener"
    
    # 1. Clone MT5
    if not os.path.exists(clone_dir):
        print(f"Cloning MT5 to {clone_dir}...")
        shutil.copytree(source_dir, clone_dir)
        print("Cloning complete.")
    else:
        print("Clone already exists.")
        
    experts_folder = Path(clone_dir) / "MQL5" / "Experts" / "MassTest"
    experts_folder.mkdir(parents=True, exist_ok=True)
    
    # 2. Copy EA
    ea_source = Path(r"G:\My Drive\jobot\EA Week10\(Jobot) RSI Break Trend Line EA.ex5")
    ea_dest = experts_folder / "test_ea.ex5"
    shutil.copy2(ea_source, ea_dest)
    
    # 3. Clear old logs & reports
    tester_logs_dir = Path(clone_dir) / "tester" / "logs"
    if tester_logs_dir.exists():
        for f in tester_logs_dir.glob("*.log"):
            try: f.unlink()
            except: pass
            
    report_path = Path(clone_dir) / "tester" / "Report.xml"
    if report_path.exists():
        try: report_path.unlink()
        except: pass
                
    # 4. Create config.ini with User Login
    ini_path = Path(clone_dir) / "mass_test.ini"
    config_content = f"""[Common]
Login=121059
Password=Izee123123#
Server=QRSGlobal-Server

[Tester]
Expert=MassTest\\test_ea
Symbol=XAUUSD
Period=M5
Optimization=0
Model=1
FromDate=2024.01.01
ToDate=2024.02.01
ForwardMode=0
Report=Report.xml
ShutdownTerminal=1
"""
    ini_path.write_text(config_content, encoding='utf-8')
    
    # 5. Run Terminal in portable mode
    terminal_exe = Path(clone_dir) / "terminal64.exe"
    print("Running Isolated MT5 Headless Backtest (/portable)...")
    
    # Needs to run with cwd as clone_dir for portable to work correctly sometimes
    process = subprocess.run([str(terminal_exe), "/portable", f"/config:mass_test.ini"], cwd=clone_dir)
    
    # 6. Check results
    time.sleep(5)
    print("\n--- Tester Logs ---")
    if tester_logs_dir.exists():
        logs = list(tester_logs_dir.glob("*.log"))
        print(f"Found {len(logs)} log files.")
        for log_file in logs:
            print(f"\nLog file: {log_file.name}")
            with open(log_file, "r", encoding="utf-16", errors="ignore") as f:
                content = f.read()
                lines = content.split('\n')
                print('\n'.join(lines[-30:]))
                
    print("\n--- Report XML ---")
    if report_path.exists():
        print(f"SUCCESS! Report.xml was generated! Size: {report_path.stat().st_size} bytes")
    else:
        print("FAILED to generate Report.xml")

if __name__ == "__main__":
    setup_and_test_clone()
