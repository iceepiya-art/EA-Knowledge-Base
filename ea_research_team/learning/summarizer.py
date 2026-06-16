"""
Summarizer — ใช้ Claude API สรุปและสร้าง draft note
"""
try:
    import anthropic
    client = anthropic.Anthropic()
except ImportError:
    anthropic = None
    client = None

import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))
from config import KB_PATH

MODEL  = "claude-haiku-4-5-20251001"  # ใช้ Haiku เพื่อประหยัด cost

CATEGORY_PATHS = {
    "AI_Updates":    "10_Research/AI_Updates",
    "Macro_News":    "10_Research/Macro_News",
    "Trading_Learn": "10_Research/Trading_Learn",
}

SYSTEM_PROMPT = """คุณคือผู้เชี่ยวชาญด้าน Quant Trading และ AI สำหรับ Forex/Crypto
หน้าที่: สรุปข้อมูลและสร้าง Obsidian note ในรูปแบบ Markdown
ใช้ภาษาไทยเป็นหลัก ศัพท์เทคนิคให้ใช้ภาษาอังกฤษ
"""

NOTE_TEMPLATE = """ช่วยสร้าง Obsidian note จากข้อมูลนี้:

**Category:** {category}
**Source:** {source}
**Title:** {title}
**Content:**
{content}

ตอบเป็น Markdown พร้อม:
1. frontmatter (tags, source, date)
2. หัวข้อหลัก
3. สรุปสั้น 2-3 ประโยค (ภาษาไทย)
4. ประเด็นสำคัญ (bullet points)
5. **ประโยชน์ต่อระบบเทรด** — นำไปใช้ยังไงได้บ้าง
6. 🔗 Related: ลิงก์ไปยัง note ใน vault ที่เกี่ยวข้อง (ถ้ามี)

ห้ามยาวเกิน 300 คำ ให้กระชับและ actionable"""


def summarize(item: dict) -> dict:
    """รับ raw item → คืน item พร้อม summary และ draft_note"""
    prompt = NOTE_TEMPLATE.format(
        category=item.get("category", ""),
        source=item.get("source", ""),
        title=item.get("title", ""),
        content=item.get("content", "")[:1500],
    )

    try:
        response = client.messages.create(
            model=MODEL,
            max_tokens=600,
            system=SYSTEM_PROMPT,
            messages=[{"role": "user", "content": prompt}],
        )
        draft_note = response.content[0].text
        item["summary"]    = _extract_summary(draft_note)
        item["draft_note"] = draft_note
    except Exception as e:
        print(f"[Summarizer] Error: {e}")
        item["summary"]    = item.get("title", "")
        item["draft_note"] = f"# {item.get('title', '')}\n\n{item.get('content', '')}"

    return item


def _extract_summary(note: str) -> str:
    """ดึงย่อหน้าแรกจาก note เป็น summary"""
    lines = [l.strip() for l in note.split("\n") if l.strip()]
    # ข้ามบรรทัด frontmatter และ heading
    for line in lines:
        if line.startswith("#") or line.startswith("---") or line.startswith("tags"):
            continue
        if len(line) > 30:
            return line[:200]
    return lines[0][:200] if lines else ""


def get_save_path(category: str, title: str) -> str:
    """คืน path เต็มสำหรับบันทึกไฟล์"""
    from datetime import datetime
    import re
    folder = CATEGORY_PATHS.get(category, "10_Research")
    date   = datetime.now().strftime("%Y-%m-%d")
    safe   = re.sub(r'[^\w\s-]', '', title)[:50].strip().replace(" ", "_")
    return os.path.join(KB_PATH, folder, f"{date}_{safe}.md")
