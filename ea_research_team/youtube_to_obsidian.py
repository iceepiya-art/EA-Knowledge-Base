"""
YouTube → Obsidian — ใช้งานตรงๆ ไม่ต้องผ่าน orchestrator

Usage:
  python youtube_to_obsidian.py https://youtube.com/watch?v=xxx
  python youtube_to_obsidian.py https://youtu.be/xxx "คำถามพิเศษ 1" "คำถามพิเศษ 2"
"""
import sys
import os

sys.path.insert(0, os.path.dirname(__file__))
from agents.youtube_agent import run_youtube_agent

def main():
    if len(sys.argv) >= 2:
        url = sys.argv[1]
        extra = sys.argv[2:] if len(sys.argv) > 2 else []
    else:
        print("=" * 45)
        print("  YouTube -> Obsidian")
        print("=" * 45)
        url = input("\nวาง YouTube URL แล้วกด Enter: ").strip()
        if not url:
            print("ไม่มี URL")
            sys.exit(1)
        extra = []

    try:
        path = run_youtube_agent(url, extra_questions=extra if extra else None)
        print(f"\n✅ เสร็จแล้ว! ไฟล์อยู่ที่:\n   {path}")
        print("\nเปิด Obsidian แล้วกด Ctrl+R เพื่อ refresh vault")
    except Exception as e:
        print(f"\n❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
