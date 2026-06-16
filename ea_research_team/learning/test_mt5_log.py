import os
import shutil
import subprocess
import time
from pathlib import Path

def test_single_ea():
    terminal_path = r"C:\Program Files\FTMO Global Markets MT5 Terminal\terminal64.exe"
    data_folder = r"C:\Users\ADMIN\AppData\Roaming\MetaQuotes\Terminal\81A933A9AFC5DE3C23B15CAB19C63850"
    experts_folder = Path(data_folder) / "MQL5" / "Experts" / "Advisors"
    
    # 1. Copy EA
    ea_source = Path(r"G:\My Drive\jobot\EA Week10\(Jobot) RSI Break Trend Line EA.ex5")
    ea_dest = experts_folder / "test_ea.ex5"
    shutil.copy2(ea_source, ea_dest)
    
    # 2. Clear old logs
    tester_logs_dir = Path(data_folder) / "tester" / "logs"
    if tester_logs_dir.exists():
        for f in tester_logs_dir.glob("*.log"):
            try: f.unlink()
            except: pass
            
    # 3. Create config.ini
    ini_path = Path(data_folder) / "mass_test.ini"
    config_content = f"""[Common]
Login=121059
Password=Izee123123#
Server=QRSGlobal-Server

[Tester]
Expert=Advisors\\test_ea
Symbol=XAUUSD
Period=M5
Optimization=0
Model=1
FromDate=2024.01.01
ToDate=2024.02.01
ForwardMode=0
Report=ReportTest.xml
UseLocal=1
"""
    ini_path.write_text(config_content, encoding='utf-8')
    
    # 4. Run Terminal without ShutdownTerminal
    print("Running MT5 Backtest (Will stay open)...")
    subprocess.Popen([terminal_path, f"/config:{ini_path}"])
    
    # 5. Check results after 15 seconds
    time.sleep(15)
    print("\n--- Tester Logs ---")
    if tester_logs_dir.exists():
        logs = list(tester_logs_dir.glob("*.log"))
        print(f"Found {len(logs)} log files.")
        for log_file in logs:
            print(f"\nLog file: {log_file.name}")
            with open(log_file, "r", encoding="utf-16", errors="ignore") as f:
                content = f.read()
                print('\n'.join(content.split('\n')[-30:]))
                
    report_path = Path(data_folder) / "ReportTest.xml"
    if report_path.exists():
        print(f"\nSUCCESS! {report_path.name} generated! Size: {report_path.stat().st_size} bytes")
    else:
        print("\nFAILED to generate ReportTest.xml")

if __name__ == "__main__":
    test_single_ea()
