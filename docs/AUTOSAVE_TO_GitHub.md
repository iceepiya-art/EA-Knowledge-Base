# 🛡️ AUTOSAVE TO GITHUB: Agentic Micro-Saves & Recovery Spec

> [!NOTE]
> **ระบบกล่องดำบันทึกโค้ดอัตโนมัติความถี่สูง (High-Frequency Micro-Saves System)**
> เอกสารนี้คือ **พิมพ์เขียวระบบ (Blueprint)** ที่รวมเอาแนวคิด วิธีติดตั้งใช้งานอย่างละเอียด ซอร์สโค้ดในการสร้าง และคู่มือกู้คืนโค้ด (Jig Recovery) ไว้ในไฟล์เดียว ออกแบบมาเป็นแบบ **กลาง (Generic)** เพื่อให้ทั้ง **มนุษย์ (Developer)** และ **AI Agents** อ่านแล้วนำไปสร้างและรันระบบเซฟงานในโปรเจกต์ใดๆ ได้ทันที!

---

## 1. วิธีติดตั้งและเปิดใช้งาน (How to Setup & Run)

เฮียหรือผู้ใช้สามารถนำบลูปริ้นท์นี้ไปตั้งค่าใช้งานกับโปรเจกต์ใหม่ได้ง่ายๆ ผ่าน 2 แนวทาง:

### 🅰️ แนวทางรันผ่าน AI Agent (ง่ายที่สุด)
หากโปรแกรมเขียนโค้ดของเฮียมีตัวช่วย AI Agent (เช่น Cursor, Windsurf, Antigravity):
1. คัดลอกไฟล์ `AUTOSAVE_TO_GitHub.md` นี้ไปวางในโฟลเดอร์ `docs/` ของโปรเจกต์ใหม่
2. พิมพ์บอก AI Agent ในช่องแชทว่า:
   > *"ช่วยอ่านไฟล์คู่มือ docs/AUTOSAVE_TO_GitHub.md แล้วเขียนไฟล์โค้ดและรันระบบเซฟงานอัตโนมัติเบื้องหลังให้ฉันที"*
3. AI Agent จะสร้างไฟล์สคริปต์และรันตัวเฝ้าเซฟงานในพื้นหลังให้ทันทีโดยอัตโนมัติครับ

### 🅱️ แนวทางสร้างและรันด้วยตนเอง (Manual Setup)
1. **สร้างไฟล์โค้ด:** นำโค้ด Python ในข้อ 4 ไปสร้างเป็นไฟล์ในโปรเจกต์ตำแหน่ง `scripts/workspace_autosave_daemon.py`
2. **สร้างสคริปต์เปิดรัน (สำหรับ Mac/Linux):** นำโค้ดเชลล์ในข้อ 4 ไปสร้างไฟล์ `run_autosave.sh` ไว้ที่ Root ของโปรเจกต์ จากนั้นรันคำสั่ง:
   ```bash
   chmod +x run_autosave.sh && ./run_autosave.sh
   ```
3. **สร้างสคริปต์เปิดรัน (สำหรับ Windows):** นำโค้ดข้อ 4 ไปสร้างไฟล์ `run_autosave.bat` ไว้ที่ Root ของโปรเจกต์ แล้วดับเบิ้ลคลิกรันใช้งาน
4. **ตั้งค่า Telegram:** ใส่ค่าในไฟล์คอนฟิกความลับของคุณ (เช่น `.env` หรือ `.env.secret`) ดังนี้:
   ```env
   TELEGRAM_TOKEN="รหัส_Token_ของบอท_Telegram"
   TELEGRAM_CHAT_ID="รหัส_Chat_ID_ของกลุ่มหรือแชทส่วนตัว"
   ```

---

## 2. ที่มาและแนวคิดของระบบ (Background & Flow)

เมื่อนักพัฒนาใช้งานตัวช่วยเขียนโค้ด AI บนสภาพแวดล้อมจำกัดโทเค็น ปัญหาใหญ่ที่พบคือ **"โทเค็นหมดกลางคัน (Token Rate Limit Lockout)"** ทำให้ขาดความต่อเนื่อง ลืมลอจิกสำคัญที่กำลังคิด หรือคอมพิวเตอร์ขัดข้องจนข้อมูลสูญหาย

ระบบ **Autosave to GitHub** จะคอยตรวจจับความเคลื่อนไหวทางกายภาพของโค้ด และเซฟงานลง Git พร้อมส่งแชทสรุปการแก้ไขแจ้งเตือนเข้า Telegram เสมอ

### แผนภาพการทำงานของระบบ (System Flowchart)
```mermaid
graph TD
    A[เริ่มบันทึกไฟล์โค้ด] --> B[ตรวจเช็ก git status --porcelain ทุก 5 วินาที]
    B -- ตรวจพบไฟล์แก้ไข/สร้างใหม่ --> C[หน่วงเวลานิ่งของโค้ด 5 วินาที Debounce]
    C --> D[ดึง Git Diff รายละเอียดรหัสโค้ด]
    D --> E[สั่ง Git Commit อัตโนมัติลงเครื่อง]
    E --> F[บันทึก Log ละเอียดลง Local File]
    F --> G[ส่งแจ้งเตือนสรุปสั้นและ Diff เข้า Telegram]
```

---

## 3. ปัญหาที่อาจเกิดขึ้นและแนวทางการแก้ไข (Known Issues & Gotchas)

การใช้ระบบทำงานร่วมกับ Git และ Telegram บนสคริปต์เบื้องหลังอาจพบปัญหาเหล่านี้ได้:

### ⚠️ A. ไฟล์ที่อยู่ใน `.gitignore` จะไม่ถูกเซฟ
* **ปัญหา:** หากแก้ไขไฟล์ที่เป็นความลับหรืออยู่นอกขอบเขต Git เช่น โฟลเดอร์ทดลองเล่นชั่วคราว หรือไฟล์รหัสผ่าน ตัวระบบจะไม่บันทึกและไม่แจ้งเตือน
* **วิธีแก้:** ตรวจสอบให้แน่ใจว่าไฟล์ที่ต้องการให้ระบบช่วยจำ ไม่ได้ถูกระบุไว้ในเงื่อนไขการบล็อกของไฟล์ `.gitignore` ของโครงการ

### ⚠️ B. การจำกัดความยาวแชทของ Telegram (4096 Characters Limit)
* **ปัญหา:** หากมีการแก้ไขโค้ดปริมาณมหาศาลในครั้งเดียว ข้อความแจ้งเตือนของ Telegram จะยาวเกินขีดจำกัด ทำให้ส่งไม่ผ่านหรือ Diff แสดงผลได้ไม่ครบถ้วน
* **วิธีแก้:** สคริปต์หลักจะทำการหั่นเนื้อหา (Truncate) ให้เหลือไม่เกิน 2,500 ตัวอักษรเพื่อส่งแจ้งเตือน หากต้องการดูโค้ดเต็มๆ ให้เข้าไปเปิดไฟล์ `logs/workspace_changes.log` ในเครื่องแทน

### ⚠️ C. สคริปต์เบื้องหลังหลุดการทำงาน (Daemon Crash/Offline)
* **ปัญหา:** หากเปิดใช้งานหลายโปรเจกต์ หรือรันคอมมานด์แล้วสคริปต์ดับไปโดยไม่รู้ตัว จะทำให้ระบบเซฟหยุดทำงาน
* **วิธีแก้:** AI Agent ที่เข้ามารับช่วงต่อ ต้องรันคำสั่งเช็กสถานะโปรเซสในข้อ 5 เสมอ ถ้าพบว่าดับให้สั่งเปิดรันใหม่ทันที

### ⚠️ D. ประวัติ Git Commit มีความถี่สูงเกินไป (Commit Noise)
* **ปัญหา:** การเซฟอัตโนมัติจะสร้าง Commit จำนวนมากใน Git History ทำให้กดยากในโปรแกรม Git ทั่วไป
* **วิธีแก้:** ใช้รหัสอ้างอิงจาก Telegram เพื่อเช็กสเตตัสเวลาที่ต้องการดึงเฉพาะไฟล์นั้นๆ แทนที่จะไล่กดดูทีละ Commit

---

## 4. ซอร์สโค้ดและพิมพ์เขียวสำหรับสั่งสร้างระบบ (System Blueprints)

เมื่อเอเยนต์ AI อ่านหัวข้อนี้ สามารถคัดลอกรหัสซอร์สโค้ดไปสร้างไฟล์ในโฟลเดอร์ปลายทางได้ทันที:

### 📄 พิมพ์เขียวที่ 1: บอทตรวจจับความเคลื่อนไหว
ให้ AI Agent เขียนโค้ดนี้ลงในไฟล์ [scripts/workspace_autosave_daemon.py](scripts/workspace_autosave_daemon.py):

```python
# scripts/workspace_autosave_daemon.py
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
                    write_local_log(commit_hash, current_files, diff_content)
                    if token and chat_id:
                        diff_display = diff_content[:2500] + "\n\n... (truncated) ..." if len(diff_content) > 2500 else diff_content
                        status_list = "\n".join([f"`{status}` {filepath}" for status, filepath in current_files])
                        alert_msg = f"🔔 *[Autosave]*\n📁 *Project:* {os.path.basename(BASE_DIR)}\n⏰ *Time:* `{timestamp_str}`\n🆔 *Commit:* `{commit_hash}`\n\n📂 *Files Change:*\n{status_list}\n\n📝 *Code Diff:*\n```diff\n{diff_display}\n```"
                        send_telegram_alert(token, chat_id, alert_msg)
            time.sleep(check_interval)
        except KeyboardInterrupt: break
        except Exception: time.sleep(10)

if __name__ == "__main__": daemon_loop()
```

### 📄 พิมพ์เขียวที่ 2: สคริปต์รันเบื้องหลังสำหรับ Mac OS (run_autosave.sh)
เขียนรหัสนี้ลงในไฟล์ [run_autosave.sh](run_autosave.sh):
```bash
#!/bin/bash
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASE_DIR"
mkdir -p logs
if ps aux | grep workspace_autosave_daemon.py | grep -v grep > /dev/null; then
    echo "[!] Already running."
else
    nohup python3 scripts/workspace_autosave_daemon.py > logs/autosave_stdout.log 2>&1 &
    echo "[✓] Autosave Daemon started in background."
fi
```

### 📄 พิมพ์เขียวที่ 3: สคริปต์รันสำหรับ Windows (run_autosave.bat)
เขียนรหัสนี้ลงในไฟล์ [run_autosave.bat](run_autosave.bat):
```cmd
@echo off
title Workspace Autosave Daemon
cd /d "%~dp0"
echo [*] Starting Workspace Autosave Daemon...
start "Workspace_Autosave" python scripts/workspace_autosave_daemon.py
echo [✓] Autosave Daemon started.
timeout /t 3
```

---

## 5. 🤖 ข้อสั่งการระดับ AI Agent (Agent Execution spec)

หากผู้ใช้วางไฟล์ `AUTOSAVE_TO_GitHub.md` นี้ลงในโปรเจกต์ใดๆ ให้ AI Agent ตัวถัดไปทำตามคำสั่งนี้ทันที:

1. **สร้างไฟล์ตามพิมพ์เขียว:** หากในโฟลเดอร์ไม่มีไฟล์ `scripts/workspace_autosave_daemon.py` และ `run_autosave.sh` ให้เขียนโค้ดตามบล็อกข้อ 4 ลงไปทันที
2. **เปิดสิทธิ์คำสั่งรันงาน:** รันคำสั่งอนุญาตสิทธิ์:
   ```bash
   chmod +x run_autosave.sh
   ```
3. **เปิดรันระบบในเบื้องหลัง:** รันคำสั่ง:
   ```bash
   ./run_autosave.sh
   ```
4. **คำสั่งตรวจสอบ (Check Process):** ตรวจสอบสถานะการทำงานผ่านคำสั่ง:
   ```bash
   ps aux | grep workspace_autosave_daemon.py | grep -v grep
   ```

---

## 6. 🛠️ คู่มือสำหรับนักพัฒนา (Jig Section Recovery Guide)

หากเกิดปัญหารหัสพังและต้องการกู้คืนโค้ดแยกตามแต่ละสเตจเวลา (Jig Section):

1. **ค้นหารหัส Commit Hash:** ไปเปิดประวัติแชท Telegram และค้นหาแจ้งเตือนตามสเตจเวลาที่ต้องการกู้ คัดลอกรหัส `Commit Hash` 7 หลักมา (เช่น `6796d7d`)
2. **สั่งให้ AI หรือพิมพ์คอมมานด์เพื่อกู้คืน:**
   * **กู้คืนเฉพาะบางไฟล์ที่พัง (แนะนำ):**
     ```bash
     git checkout <COMMIT_HASH> -- <path/to/file>
     ```
     *ตัวอย่าง:* ดึงโค้ดเฉพาะไฟล์ `CDC_Scanner.py` ณ ตอนคอมมิต `6796d7d` กลับมา:
     ```bash
     git checkout 6796d7d -- bot/CDC_Scanner/CDC_Scanner.py
     ```
   * **กู้คืนทั้งโปรเจกต์ย้อนกลับไปจุดนั้นถาวร (Hard Rollback):**
     ```bash
     git reset --hard <COMMIT_HASH>
     ```
