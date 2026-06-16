import telebot
import requests
import os
import json
import threading
import time
TOKEN_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "telegram_token.txt")

def get_token():
    if os.environ.get("TELEGRAM_BOT_TOKEN"):
        return os.environ.get("TELEGRAM_BOT_TOKEN")
    if os.path.exists(TOKEN_FILE):
        with open(TOKEN_FILE, "r") as f:
            return f.read().strip()
    return None

TOKEN = get_token()

if not TOKEN:
    print(f"Error: TELEGRAM_BOT_TOKEN environment variable not set, and {TOKEN_FILE} not found.")
    print("Please provide your Telegram Bot Token.")
    exit(1)

bot = telebot.TeleBot(TOKEN)
API_BASE = "http://localhost:5000/api/learning"
active_chat_ids = set()
last_notified_video_id = None

def poll_download_status():
    global last_notified_video_id, active_chat_ids
    while True:
        time.sleep(5)
        if not active_chat_ids:
            continue
        try:
            status_resp = requests.get(f"{API_BASE}/download-status")
            if status_resp.status_code == 200:
                status_data = status_resp.json()
                is_running = status_data.get("running", False)
                if is_running:
                    vid = status_data.get("current_video_id")
                    if vid and vid != last_notified_video_id:
                        title = status_data.get("current_title", "Unknown")
                        idx = status_data.get("current_index", 1)
                        total = status_data.get("total", 1)
                        ch = status_data.get("current_channel", "")
                        msg = f"🔄 [สถานะการเรียนรู้]\nกำลังแกะเนื้อหาคลิปช่อง: {ch}\nชื่อคลิป: {title}\n(คิวที่ {idx}/{total})"
                        for cid in list(active_chat_ids):
                            try:
                                bot.send_message(cid, msg)
                            except:
                                pass
                        last_notified_video_id = vid
        except Exception:
            pass

threading.Thread(target=poll_download_status, daemon=True).start()

def poll_pipeline_status(chat_id):
    while True:
        time.sleep(5)
        try:
            status_resp = requests.get(f"{API_BASE}/pipeline-status")
            if status_resp.status_code == 200:
                status_data = status_resp.json()
                is_running = status_data.get("running", False)
                if not is_running:
                    res = status_data.get("result", {})
                    msg = "✅ ประมวลผลเสร็จแล้ว!"
                    if res:
                        try:
                            wc = res.get("write_concepts", {})
                            written = wc.get("created", 0) + wc.get("updated", 0)
                            if written > 0:
                                msg = f"✅ ประมวลผลเสร็จแล้ว ได้ความรู้ใหม่ {written} เรื่อง!\nตอนนี้ถูกเขียนลงใน Obsidian เรียบร้อยแล้วครับ"
                            else:
                                msg = "✅ ประมวลผลเสร็จแล้ว! แต่ไม่มีความรู้ใหม่ที่เข้าเกณฑ์ให้บันทึกครับ"
                        except:
                            pass
                    bot.send_message(chat_id, msg)
                    break
        except Exception:
            pass

@bot.message_handler(commands=['start', 'help'])
def send_welcome(message):
    active_chat_ids.add(message.chat.id)
    bot.reply_to(message, "Welcome to the EA Knowledge Brain Remote Inbox! 🧠\n\n"
                          "Send me any of the following to learn:\n"
                          "1. A YouTube Channel or Video URL\n"
                          "2. Plain text trading rules or concepts\n"
                          "3. A screenshot of a trading chart (with caption)\n\n"
                          "I will ingest them and trigger the learning pipeline automatically.\n\n"
                          "(✅ You are now subscribed to live processing updates)")

@bot.message_handler(content_types=['text'])
def handle_text(message):
    active_chat_ids.add(message.chat.id)
    input_data = message.text
    bot.reply_to(message, "⏳ Sending to Knowledge Brain...")
    
    try:
        response = requests.post(f"{API_BASE}/universal-intake", json={
            "input_data": input_data,
            "auto_pipeline": True
        })
        if response.status_code == 200:
            data = response.json()
            if data.get("error"):
                bot.reply_to(message, f"❌ Error: {data['error']}")
            else:
                msg = data.get("message", "Data successfully received and queued for learning.")
                if data.get("pipeline") == "started":
                    msg += "\n\n🚀 Learning Pipeline started!"
                    threading.Thread(target=poll_pipeline_status, args=(message.chat.id,), daemon=True).start()
                bot.reply_to(message, f"✅ Success!\n{msg}")
        else:
            bot.reply_to(message, f"❌ Server returned status {response.status_code}")
    except Exception as e:
        bot.reply_to(message, f"❌ Connection Error: Is the EA Knowledge Brain server running?\n{e}")

@bot.message_handler(content_types=['photo'])
def handle_photo(message):
    bot.reply_to(message, "Processing image evidence...")
    try:
        # Get the largest photo
        file_info = bot.get_file(message.photo[-1].file_id)
        downloaded_file = bot.download_file(file_info.file_path)
        
        # Save locally in remote inbox directory
        import uuid
        filename = f"telegram_img_{uuid.uuid4().hex[:8]}.jpg"
        
        inbox_root = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
        inbox_dir = os.path.join(inbox_root, "inbox", "images")
        os.makedirs(inbox_dir, exist_ok=True)
        
        file_path = os.path.join(inbox_dir, filename)
        with open(file_path, 'wb') as new_file:
            new_file.write(downloaded_file)
            
        caption = message.caption or "Telegram Image Evidence"
        
        with open(file_path + ".txt", "w", encoding="utf-8") as text_file:
            text_file.write(caption)
            
        bot.reply_to(message, "Image saved. Sending Inbox to Knowledge Brain...")

        response = requests.post(f"{API_BASE}/remote-inbox/process", json={
            "auto_pipeline": True,
            "inbox_root": inbox_root,
        })
        if response.status_code == 200:
            data = response.json()
            if data.get("error"):
                bot.reply_to(message, f"Error processing image: {data['error']}")
            else:
                imported = data.get("imported", 0)
                skipped = data.get("skipped", 0)
                failed = data.get("failed", 0)
                msg = f"Image evidence processed: imported {imported}, skipped {skipped}, failed {failed}."
                if data.get("pipeline") == "started":
                    msg += "\n\nLearning Pipeline started!"
                    threading.Thread(target=poll_pipeline_status, args=(message.chat.id,), daemon=True).start()
                bot.reply_to(message, msg)
        else:
            bot.reply_to(message, f"Server returned status {response.status_code}")
        
    except Exception as e:
        bot.reply_to(message, f"Error saving or processing image: {e}")

@bot.message_handler(content_types=['document', 'video', 'audio'])
def handle_file(message):
    bot.reply_to(message, "⏳ Downloading file...")
    try:
        if message.document:
            file_info = bot.get_file(message.document.file_id)
            original_name = message.document.file_name or "file.txt"
        elif message.video:
            file_info = bot.get_file(message.video.file_id)
            original_name = message.video.file_name or "video.mp4"
        elif message.audio:
            file_info = bot.get_file(message.audio.file_id)
            original_name = message.audio.file_name or "audio.mp3"
            
        downloaded_file = bot.download_file(file_info.file_path)
        
        inbox_dir = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))), "inbox", "files")
        os.makedirs(inbox_dir, exist_ok=True)
        
        import uuid
        safe_name = f"{uuid.uuid4().hex[:6]}_{original_name}"
        file_path = os.path.join(inbox_dir, safe_name)
        
        with open(file_path, 'wb') as new_file:
            new_file.write(downloaded_file)
            
        bot.reply_to(message, "⏳ File downloaded! Sending to Knowledge Brain...")
        
        response = requests.post(f"{API_BASE}/universal-intake", json={
            "input_data": file_path,
            "auto_pipeline": True
        })
        if response.status_code == 200:
            data = response.json()
            if data.get("error"):
                bot.reply_to(message, f"❌ Error processing file: {data['error']}")
            else:
                msg = data.get("message", "File successfully received and queued for learning.")
                if data.get("pipeline") == "started":
                    msg += "\n\n🚀 Learning Pipeline started!"
                    threading.Thread(target=poll_pipeline_status, args=(message.chat.id,), daemon=True).start()
                bot.reply_to(message, f"✅ Success!\n{msg}")
        else:
            bot.reply_to(message, f"❌ Server returned status {response.status_code}")
            
    except Exception as e:
        bot.reply_to(message, f"❌ Error saving or processing file: {e}")

print("Starting Telegram Bot Polling...")
bot.infinity_polling()
