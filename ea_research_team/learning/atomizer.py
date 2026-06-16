"""
Atomizer — สกัด Atomic Insights จาก approved items
ใช้ Claude Haiku → ประหยัด token
แต่ละ atom = insight เดียว, actionable, searchable
"""
import anthropic
import json
import os
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

client = anthropic.Anthropic()
MODEL  = "claude-haiku-4-5-20251001"

PROMPT = """จากบทความนี้ สกัด 2-5 "atomic insights" สำหรับการพัฒนา EA trading

Category: {category}
Title: {title}
Content:
{content}

กฎ:
- แต่ละ atom = ข้อเท็จจริงเดียว กระชับ ไม่เกิน 2 บรรทัด
- เน้นที่ actionable — นำไปใช้กับ EA ได้จริง
- ถ้าไม่มี insight ที่เกี่ยวกับ trading ให้คืน []

ตอบเป็น JSON array เท่านั้น รูปแบบ:
[
  {{
    "insight": "ข้อเท็จจริงสั้นๆ",
    "applies_to": ["QField", "HedgeGrid", "XAUUSD"],
    "action": "นำไปทำอะไรได้",
    "confidence": "high|medium|low",
    "topic": "หมวดหมู่ เช่น ATR, Regime, Entry, Risk"
  }}
]"""


def extract_atoms(item: dict) -> list[dict]:
    """สกัด atoms จาก 1 item — คืน list of atoms"""
    try:
        resp = client.messages.create(
            model=MODEL,
            max_tokens=800,
            messages=[{"role": "user", "content": PROMPT.format(
                category=item.get("category", ""),
                title=item.get("title", ""),
                content=item.get("draft_note", item.get("content", ""))[:1500],
            )}]
        )
        text = resp.content[0].text.strip()

        # แยก JSON ออกจาก text
        start = text.find("[")
        end   = text.rfind("]") + 1
        if start == -1 or end == 0:
            return []

        atoms = json.loads(text[start:end])

        # เพิ่ม metadata
        for atom in atoms:
            atom["source_title"] = item.get("title", "")
            atom["source_url"]   = item.get("url", "")
            atom["category"]     = item.get("category", "")

        return atoms

    except Exception as e:
        print(f"[Atomizer] Error: {e}")
        return []


def format_atom_note(atom: dict, date: str) -> str:
    """แปลง atom เป็น Obsidian note"""
    applies = ", ".join(atom.get("applies_to", []))
    conf    = atom.get("confidence", "medium")
    conf_icon = {"high": "🟢", "medium": "🟡", "low": "🔴"}.get(conf, "⚪")

    return f"""---
tags: [atom, {atom.get('topic','').lower().replace(' ','-')}, {atom.get('category','').lower()}]
confidence: {conf}
applies_to: [{applies}]
date: {date}
source: "{atom.get('source_title','')}"
---

# {atom.get('insight', '')}

**Action:** {atom.get('action', '-')}
**Applies to:** {applies}
**Confidence:** {conf_icon} {conf}
**Topic:** {atom.get('topic', '-')}

> Source: [{atom.get('source_title','')}]({atom.get('source_url','')})
"""
