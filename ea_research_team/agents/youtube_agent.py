"""
YouTube → Obsidian Agent
ดึง transcript จาก YouTube → ถามคำถาม trading อัตโนมัติ → บันทึกเป็น .md ใน raw/

Usage:
  from agents.youtube_agent import run_youtube_agent
  run_youtube_agent("https://youtube.com/watch?v=xxx")
"""
import re
import os
from datetime import datetime, timezone, timedelta
from urllib.parse import urlparse, parse_qs

import anthropic
from youtube_transcript_api import YouTubeTranscriptApi, TranscriptsDisabled, NoTranscriptFound
from config import MODEL, KB_PATH

client = anthropic.Anthropic()
TH_TZ = timezone(timedelta(hours=7))

# คำถามมาตรฐานสำหรับวิดีโอ trading
TRADING_QUESTIONS = [
    "กลยุทธ์หลักของวิดีโอนี้คืออะไร สรุปใน 2-3 ประโยค",
    "เงื่อนไข Entry (จุดเข้า) มีอะไรบ้าง ระบุทีละข้อ",
    "เงื่อนไข Exit และการตั้ง Stop Loss / Take Profit",
    "Indicator หรือ tool ที่ใช้ และวิธีอ่านสัญญาณ",
    "Concept หรือ Setup สำคัญที่กล่าวถึง (เช่น FVG, BOS, CHoCH, OB)",
    "ตัวอย่าง trade setup หรือ chart ที่อธิบายในวิดีโอ",
    "ข้อควรระวัง / สิ่งที่ห้ามทำ / ความผิดพลาดที่พบบ่อย",
    "สรุป 5 bullet points ที่สำคัญที่สุดของวิดีโอนี้",
]


def _extract_video_id(url: str) -> str:
    """แยก video ID จาก YouTube URL ทุกรูปแบบ"""
    patterns = [
        r"(?:v=|/v/|youtu\.be/|/embed/|/shorts/)([a-zA-Z0-9_-]{11})",
    ]
    for p in patterns:
        m = re.search(p, url)
        if m:
            return m.group(1)
    raise ValueError(f"ไม่พบ video ID จาก URL: {url}")


def _get_transcript(video_id: str) -> tuple[str, str]:
    """ดึง transcript — ลอง Thai ก่อน ถ้าไม่มีใช้ English"""
    try:
        transcript_list = YouTubeTranscriptApi.list_transcripts(video_id)
        # ลอง Thai ก่อน
        for lang in ["th", "en", "en-US", "en-GB"]:
            try:
                t = transcript_list.find_transcript([lang])
                entries = t.fetch()
                text = " ".join(e["text"] for e in entries)
                return text, lang
            except Exception:
                continue
        # fallback: auto-generated
        t = transcript_list.find_generated_transcript(["th", "en"])
        entries = t.fetch()
        text = " ".join(e["text"] for e in entries)
        return text, "auto"
    except (TranscriptsDisabled, NoTranscriptFound):
        raise RuntimeError("วิดีโอนี้ไม่มี transcript / subtitle ที่เปิดใช้งานได้")


def _ask_claude(transcript: str, questions: list[str], title: str = "") -> dict[str, str]:
    """ส่ง transcript + คำถามทั้งหมดไปถาม Claude ครั้งเดียว"""
    q_block = "\n".join(f"{i+1}. {q}" for i, q in enumerate(questions))

    prompt = f"""นี่คือ transcript จากวิดีโอ YouTube เกี่ยวกับ trading:
{'ชื่อวิดีโอ: ' + title if title else ''}

=== TRANSCRIPT ===
{transcript[:60000]}
=== END TRANSCRIPT ===

ตอบคำถามต่อไปนี้โดยอ้างอิงจาก transcript เท่านั้น:

{q_block}

ตอบเป็นภาษาไทย แยกคำตอบแต่ละข้อชัดเจน format:
**คำถามที่ N:** [คำถาม]
[คำตอบ]
"""
    msg = client.messages.create(
        model=MODEL,
        max_tokens=4096,
        messages=[{"role": "user", "content": prompt}],
    )
    raw = msg.content[0].text

    # แยก Q&A
    answers = {}
    blocks = re.split(r"\*\*คำถามที่\s*\d+:\*\*", raw)
    for i, block in enumerate(blocks[1:], 1):
        if i <= len(questions):
            answers[questions[i - 1]] = block.strip()
    return answers


def _build_md(url: str, video_id: str, lang: str,
              answers: dict[str, str], custom_questions: list[str]) -> str:
    """สร้าง Obsidian .md จากผล Q&A"""
    now = datetime.now(TH_TZ)
    date_str = now.strftime("%Y-%m-%d")
    time_str = now.strftime("%Y-%m-%d %H:%M")

    lines = [
        "---",
        "tags: [youtube, trading, research, raw]",
        f"created: {date_str}",
        f"source: {url}",
        f"transcript_lang: {lang}",
        "---",
        "",
        f"# YouTube Research — {video_id}",
        f"> Source: {url}",
        f"> Imported: {time_str}",
        "",
        "ดู [[../00_MOC]]",
        "",
        "---",
        "",
    ]

    for q in custom_questions:
        answer = answers.get(q, "(ไม่มีคำตอบ)")
        lines.append(f"## {q}")
        lines.append("")
        lines.append(answer)
        lines.append("")
        lines.append("---")
        lines.append("")

    return "\n".join(lines)


def run_youtube_agent(url: str, extra_questions: list[str] | None = None) -> str:
    """
    Pipeline หลัก: YouTube URL → .md ใน raw/

    Args:
        url: YouTube URL
        extra_questions: คำถามเพิ่มเติมนอกจาก TRADING_QUESTIONS

    Returns:
        path ของไฟล์ที่บันทึก
    """
    print(f"\n[YouTube Agent] URL: {url}")

    # 1. แยก video ID
    video_id = _extract_video_id(url)
    print(f"  Video ID: {video_id}")

    # 2. ดึง transcript
    print("  กำลังดึง transcript...")
    transcript, lang = _get_transcript(video_id)
    word_count = len(transcript.split())
    print(f"  Transcript: {word_count:,} words (lang={lang})")

    # 3. รวมคำถาม
    all_questions = TRADING_QUESTIONS + (extra_questions or [])

    # 4. ถาม Claude
    print(f"  กำลังถาม Claude ({len(all_questions)} คำถาม)...")
    answers = _ask_claude(transcript, all_questions)
    print(f"  ได้คำตอบ {len(answers)} ข้อ")

    # 5. สร้าง .md
    md_content = _build_md(url, video_id, lang, answers, all_questions)

    # 6. บันทึก
    date_str = datetime.now(TH_TZ).strftime("%Y-%m-%d")
    filename = f"{date_str}_YouTube_{video_id}.md"
    out_path = os.path.join(KB_PATH, "raw", filename)
    os.makedirs(os.path.dirname(out_path), exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as f:
        f.write(md_content)

    print(f"\n  บันทึกสำเร็จ: raw/{filename}")

    # 7. อัปเดต MOC
    _update_moc(filename, video_id, answers, all_questions)

    return out_path


def _update_moc(filename: str, video_id: str, answers: dict, questions: list) -> None:
    """เพิ่มลิงก์ไฟล์ใหม่เข้า 00_MOC.md ใต้ Raw Research"""
    moc_path = os.path.join(KB_PATH, "00_MOC.md")
    if not os.path.exists(moc_path):
        return

    # สร้าง description จากคำตอบแรก (กลยุทธ์หลัก)
    first_q = questions[0] if questions else ""
    first_a = answers.get(first_q, "")
    desc = first_a[:80].replace("\n", " ").strip() + "..." if first_a else video_id

    stem = filename.replace(".md", "")
    new_entry = f"- [[raw/{stem}]] — {desc}\n"

    with open(moc_path, "r", encoding="utf-8") as f:
        content = f.read()

    # หา section YouTube Research ถ้ามี ถ้าไม่มีสร้างใหม่
    youtube_header = "### 📹 YouTube Research\n"
    if youtube_header in content:
        content = content.replace(youtube_header, youtube_header + new_entry)
    else:
        # แทรกก่อน --- ท้าย section Raw Research
        raw_section = "## 📚 Raw Research (raw/)"
        insert_after = "### 🔬 NotebookLM Research\n"
        if insert_after in content:
            content = content.replace(
                insert_after,
                youtube_header + new_entry + "\n" + insert_after
            )
        elif raw_section in content:
            content = content.replace(
                raw_section,
                raw_section + "\n\n" + youtube_header + new_entry
            )

    # อัปเดตวันที่
    today = datetime.now(TH_TZ).strftime("%Y-%m-%d")
    content = content.replace(
        f"**Updated:** {content.split('**Updated:**')[1].split('\\n')[0].strip()}",
        f"**Updated:** {today}"
    ) if "**Updated:**" in content else content

    with open(moc_path, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"  MOC อัปเดตแล้ว: [[raw/{stem}]]")
