import os
import sys
import time
import subprocess
import requests
from datetime import datetime

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def load_env():
    env_data = {}
    for filename in ['.env', '.env.secret']:
        filepath = os.path.join(BASE_DIR, filename)
        if os.path.exists(filepath):
            try:
                with open(filepath, 'r', encoding='utf-8') as f:
                    for line in f:
                        line = line.strip()
                        if line and not line.startswith('#') and '=' in line:
                            key, val = line.split('=', 1)
                            env_data[key.strip()] = val.strip().strip('"').strip("'")
            except Exception as e:
                print(f"[!] Error loading {filename}: {e}")
                
    # Fallback for TELEGRAM_TOKEN
    token_file = os.path.join(BASE_DIR, "ea_research_team", "learning", "telegram_token.txt")
    if "TELEGRAM_TOKEN" not in env_data and os.path.exists(token_file):
        with open(token_file, "r") as f:
            env_data["TELEGRAM_TOKEN"] = f.read().strip()
            
    return env_data

def get_git_status():
    try:
        result = subprocess.run(["git", "status", "--porcelain"], cwd=BASE_DIR, capture_output=True, text=True, check=True)
        return [tuple(line.strip().split(" ", 1)) for line in result.stdout.strip().split("\n") if line.strip()]
    except Exception:
        return []

def get_git_diff():
    try:
        result = subprocess.run(["git", "diff"], cwd=BASE_DIR, capture_output=True, text=True, check=True)
        return result.stdout
    except Exception:
        return ""

def execute_git_commit(message):
    try:
        subprocess.run(["git", "add", "."], cwd=BASE_DIR, check=True)
        subprocess.run(["git", "commit", "-m", message], cwd=BASE_DIR, check=True)
        hash_res = subprocess.run(["git", "rev-parse", "--short", "HEAD"], cwd=BASE_DIR, capture_output=True, text=True, check=True)
        return hash_res.stdout.strip()
    except Exception:
        return None

def send_telegram_alert(token, chat_id, message):
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    try:
        response = requests.post(url, json={"chat_id": chat_id, "text": message, "parse_mode": "Markdown"}, timeout=10)
        if response.status_code != 200:
            requests.post(url, json={"chat_id": chat_id, "text": message}, timeout=10)
    except Exception:
        pass

def write_local_log(commit_hash, files, diff):
    log_dir = os.path.join(BASE_DIR, "logs")
    if not os.path.exists(log_dir): os.makedirs(log_dir)
    log_file = os.path.join(log_dir, "workspace_changes.log")
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_entry = f"=========================================================\nTIME: {timestamp}\nCOMMIT: {commit_hash}\nMODIFIED FILES:\n"
    for status, filepath in files: log_entry += f"  - [{status}] {filepath}\n"
    log_entry += f"\nGIT DIFF:\n{diff}\n\n"
    with open(log_file, "a", encoding="utf-8") as f: f.write(log_entry)

def daemon_loop():
    print("[*] Autosave Daemon started...")
    env = load_env()
    token, chat_id = env.get("TELEGRAM_TOKEN"), env.get("TELEGRAM_CHAT_ID")
    if not chat_id:
        print("[!] Warning: TELEGRAM_CHAT_ID is missing from .env. Logs will be saved locally, but no Telegram alerts will be sent.")
        
    debounce_time, check_interval = 5.0, 5.0
    while True:
        try:
            current_files = get_git_status()
            if current_files:
                while True:
                    time.sleep(debounce_time)
                    new_files = get_git_status()
                    if len(new_files) == len(current_files): break
                    current_files = new_files
                diff_content = get_git_diff()
                timestamp_str = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
                commit_hash = execute_git_commit(f"[Autosave] {timestamp_str} - Auto-saving modified logic")
                if commit_hash:
                    print(f"[✓] Saved changes at {timestamp_str} (Commit: {commit_hash})")
                    write_local_log(commit_hash, current_files, diff_content)
                    if token and chat_id:
                        diff_display = diff_content[:2500] + "\n\n... (truncated) ..." if len(diff_content) > 2500 else diff_content
                        status_list = "\n".join([f"`{status}` {filepath}" for status, filepath in current_files])
                        alert_msg = f"🔔 *[Autosave]*\n📁 *Project:* {os.path.basename(BASE_DIR)}\n⏰ *Time:* `{timestamp_str}`\n🆔 *Commit:* `{commit_hash}`\n\n📂 *Files Change:*\n{status_list}\n\n📝 *Code Diff:*\n```diff\n{diff_display}\n```"
                        send_telegram_alert(token, chat_id, alert_msg)
            time.sleep(check_interval)
        except KeyboardInterrupt: break
        except Exception as e: 
            print(f"[!] Exception in loop: {e}")
            time.sleep(10)

if __name__ == "__main__": daemon_loop()
