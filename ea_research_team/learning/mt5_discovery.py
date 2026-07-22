import os
import psutil
import MetaTrader5 as mt5
from pathlib import Path
from dotenv import dotenv_values, load_dotenv

# Resolve the repository configuration explicitly. find_dotenv() can otherwise
# select a parent or unrelated working-directory file when this module is run
# from a launcher or test process.
REPO_ROOT = Path(__file__).resolve().parents[2]
ENV_PATH = REPO_ROOT / ".env"
load_dotenv(ENV_PATH)
ENV_VALUES = dotenv_values(ENV_PATH)

def get_target_account() -> str:
    """Returns the target MT5 account from .env if specified."""
    explicit = os.environ.get("EXPECTED_MT5_ACCOUNT", "").replace('"', '').strip()
    if explicit:
        return explicit
    # The repository config is the operational source of truth. A launcher can
    # inherit a stale TARGET_MT5_ACCOUNT from an older shell, so use it only
    # when the repository deliberately leaves this setting unset.
    val = ENV_VALUES.get("TARGET_MT5_ACCOUNT", "") or os.environ.get("TARGET_MT5_ACCOUNT", "")
    return val.replace('"', '').replace('\\n', '').replace('\n', '').strip()

def auto_connect_mt5() -> bool:
    """
    Intelligently finds and connects to the correct MT5 Terminal.
    1. If TARGET_MT5_ACCOUNT is set, it scans all running terminal64.exe
       and finds the one logged into that account.
    2. If no target is set, it falls back to default mt5.initialize().
    """
    target = get_target_account()
    
    if not target:
        # No target specified, use default initialization
        print("[MT5 Discovery] No TARGET_MT5_ACCOUNT in .env. Using default terminal.")
        return mt5.initialize()

    print(f"[MT5 Discovery] Searching for MT5 terminal with Account: {target}...")
    
    # 1. Gather all running MT5 terminal paths
    mt5_paths = []
    for proc in psutil.process_iter(['name', 'exe']):
        try:
            name = proc.info.get('name', '')
            exe = proc.info.get('exe', '')
            if name and 'terminal64.exe' in name.lower() and exe:
                if exe not in mt5_paths:
                    mt5_paths.append(exe)
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            continue

    if not mt5_paths:
        print("[MT5 Discovery] No running terminal64.exe found! Attempting default start...")
        return mt5.initialize()

    # 2. Test each path to see if it matches the target account
    for p in mt5_paths:
        if mt5.initialize(path=p):
            acc_info = mt5.account_info()
            if acc_info and str(acc_info.login) == target:
                print(f"[MT5 Discovery] Connected successfully to Account {target} at: {p}")
                return True
            # Disconnect if not the right one so we can try the next
            mt5.shutdown()

    # 3. If we searched all running paths and failed, try default as a last resort
    print(f"[MT5 Discovery] Could not find a running terminal logged into {target}. Falling back to default...")
    if mt5.initialize():
        acc_info = mt5.account_info()
        if acc_info and str(acc_info.login) == target:
             print("[MT5 Discovery] Default terminal matched the target.")
             return True
        else:
             print(f"[MT5 Discovery] Default terminal is on Account {acc_info.login if acc_info else 'Unknown'}. Refusing to trade a different account.")
             mt5.shutdown()
             return False

    return False
