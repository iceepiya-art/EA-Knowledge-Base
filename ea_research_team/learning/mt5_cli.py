"""MetaTrader 5 CLI Automation (Phase 3)

Handles automatic compilation of .mq5 files and headless backtesting via terminal64.exe.
"""
import os
import sys
import subprocess
from pathlib import Path

# Common default paths for MT5
MT5_PATHS = [
    Path(r"C:\Program Files\MetaTrader 5"),
    Path(r"C:\Program Files\FTMO MetaTrader 5"),
    Path(r"C:\Program Files\ICMarkets MetaTrader 5"),
    Path(r"C:\Program Files\MetaTrader 5 EXNESS"),
    Path(r"C:\Program Files\FTMO Global Markets MT5 Terminal")
]

def find_mt5_executable(exe_name: str) -> Path:
    for base_path in MT5_PATHS:
        exe_path = base_path / exe_name
        if exe_path.exists():
            return exe_path
    
    # If not found in defaults, check PATH or ask user
    return None

def compile_ea(mq5_path: Path) -> bool:
    """Compiles .mq5 to .ex5 using metaeditor64.exe"""
    metaeditor = find_mt5_executable("metaeditor64.exe")
    
    if not metaeditor:
        print("[-] metaeditor64.exe not found! Please check MT5 installation path.")
        return False
        
    print(f"[+] Compiling {mq5_path.name}...")
    
    inc_path = metaeditor.parent / "MQL5" / "Include"
    cmd = [
        str(metaeditor),
        f"/compile:{mq5_path.resolve()}",
        f"/inc:{inc_path}",
        "/log"
    ]
    
    # MetaEditor returns 0 on success, 1 on warning, >1 on error
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
    except subprocess.TimeoutExpired:
        print("[-] Compilation timed out! metaeditor64.exe might be stuck or waiting for UI interaction. Killing it...")
        os.system('taskkill /f /im metaeditor64.exe')
        return False
    
    # Check if .ex5 was created
    ex5_path = mq5_path.with_suffix(".ex5")
    if ex5_path.exists() and result.returncode <= 1:
        print(f"[+] Compilation successful: {ex5_path.name}")
        return True
    else:
        print(f"[-] Compilation failed with code {result.returncode}")
        # The log file is created in the same folder with .log extension
        log_path = mq5_path.with_suffix(".log")
        if log_path.exists():
            print(log_path.read_text(encoding="utf-16", errors="ignore"))
        return False

def generate_backtest_ini(ea_name: str, symbol: str, ini_path: Path, from_date: str = "2024.01.01", to_date: str = "2024.02.01", report_name: str = "Report.htm", period: str = "H1"):
    """Generates a backtest.ini configuration file for terminal64.exe"""
    
    ini_content = f"""[Tester]
Expert={ea_name}
Symbol={symbol}
Period={period}
Optimization=0
Model=0
FromDate={from_date}
ToDate={to_date}
ForwardMode=0
Deposit=10000
Currency=USD
ProfitInPips=0
Leverage=100
ExecutionMode=0
OptimizationCriterion=0
Visual=0
Report={report_name}
"""
    ini_path.write_text(ini_content, encoding="utf-8")
    return ini_path

def run_backtest(ea_path: Path, symbol: str, from_date: str, to_date: str, report_name: str = "Report.htm", period: str = "H1") -> bool:
    """Runs a headless backtest using terminal64.exe"""
    terminal = find_mt5_executable("terminal64.exe")
    
    if not terminal:
        print("[-] terminal64.exe not found!")
        return False
        
    ini_path = ea_path.parent / "backtest.ini"
    generate_backtest_ini(ea_path.stem, symbol, ini_path, from_date, to_date, report_name, period)
    
    print(f"[+] Starting Backtest: {from_date} -> {to_date}...")
    
    cmd = [
        str(terminal),
        f"/config:{ini_path.resolve()}"
    ]
    
    # Run the backtest (MT5 will close automatically when done if configured, 
    # but for safety we might need to monitor the report file creation)
    process = subprocess.Popen(cmd)
    process.wait()
    
    report_path = ea_path.parent / report_name
    if report_path.exists():
        print(f"[+] Backtest complete. Report generated at {report_path.name}")
        return True
    
    print("[-] Backtest failed to generate report.")
    return False

if __name__ == "__main__":
    print("MT5 CLI Automation module loaded.")
