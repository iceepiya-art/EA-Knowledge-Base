"""
Writer — เขียน approved items ลง Obsidian vault + อัปเดต MOC
"""
import os
import sys
sys.path.insert(0, os.path.join(os.path.dirname(__file__), ".."))

from queue_store import get_approved, mark_written
from summarizer import get_save_path
from atomizer import extract_atoms, format_atom_note
from atom_store import add_atoms
from config import KB_PATH

MOC_PATH = os.path.join(KB_PATH, "00_MOC.md")

CATEGORY_SECTION = {
    "AI_Updates":    "### 🤖 AI Updates\n",
    "Macro_News":    "### 📰 Macro News\n",
    "Trading_Learn": "### 📚 Trading Knowledge\n",
}

RESEARCH_SECTION = "## 📖 Research & Context (10_Research/)"


def write_note(item: dict) -> str | None:
    """เขียน note ลง vault — คืน path ที่บันทึก"""
    save_path = get_save_path(item["category"], item["title"])
    os.makedirs(os.path.dirname(save_path), exist_ok=True)

    # ถ้าไฟล์มีอยู่แล้ว ไม่เขียนทับ
    if os.path.exists(save_path):
        print(f"[Writer] ไฟล์มีอยู่แล้ว: {save_path}")
        return save_path

    with open(save_path, "w", encoding="utf-8") as f:
        f.write(item["draft_note"])

    print(f"[Writer] บันทึกแล้ว: {os.path.basename(save_path)}")
    return save_path


def update_moc(item: dict, save_path: str):
    """เพิ่มรายการใหม่เข้า MOC"""
    if not os.path.exists(MOC_PATH):
        return

    with open(MOC_PATH, "r", encoding="utf-8") as f:
        content = f.read()

    # สร้าง relative path สำหรับ link
    rel = os.path.relpath(save_path, KB_PATH).replace("\\", "/").replace(".md", "")
    link = f"- [[{rel}]] — {item['title']}\n"

    # ตรวจว่า link มีอยู่แล้วไหม
    if rel in content:
        return

    category = item.get("category", "")
    section_header = CATEGORY_SECTION.get(category)

    if section_header and section_header in content:
        content = content.replace(section_header, section_header + link)
    elif RESEARCH_SECTION in content:
        # เพิ่มใหม่ใต้ Research section
        insert = f"\n{section_header or '### 🆕 New\n'}{link}"
        content = content.replace(RESEARCH_SECTION,
                                  RESEARCH_SECTION + insert)
    else:
        content += f"\n\n{link}"

    with open(MOC_PATH, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"[Writer] MOC อัปเดตแล้ว: {item['title']}")


def write_atoms(item: dict):
    """สกัด atoms จาก item แล้วเขียนลง vault"""
    from datetime import datetime
    date   = datetime.now().strftime("%Y-%m-%d")
    atoms  = extract_atoms(item)

    if not atoms:
        return

    # เก็บใน atoms.json + เช็ค contradiction
    added, warnings = add_atoms(atoms)
    for w in warnings:
        print(f"  [Atomizer] {w}")

    # เขียนลง vault ที่ 10_Research/Atoms/[topic]/
    atom_base = os.path.join(KB_PATH, "10_Research", "Atoms")
    for atom in atoms:
        topic    = atom.get("topic", "General").replace(" ", "_")
        folder   = os.path.join(atom_base, topic)
        os.makedirs(folder, exist_ok=True)

        slug     = atom.get("insight", "")[:40].strip().replace(" ", "_")
        slug     = "".join(c for c in slug if c.isalnum() or c in "_-")
        filename = f"{date}_{slug}.md"
        path     = os.path.join(folder, filename)

        if not os.path.exists(path):
            with open(path, "w", encoding="utf-8") as f:
                f.write(format_atom_note(atom, date))

    print(f"  [Atomizer] สกัด {added} atoms จาก: {item['title'][:50]}")


def write_all_approved() -> int:
    """เขียนทุก approved item ลง vault + สกัด atoms"""
    items   = get_approved()
    written = 0

    if not items:
        print("[Writer] ไม่มี item ที่ approve")
        return 0

    for item in items:
        path = write_note(item)
        if path:
            update_moc(item, path)
            write_atoms(item)        # สกัด atoms ด้วย
            mark_written(item["id"])
            written += 1

    print(f"\n[Writer] บันทึกทั้งหมด {written} รายการ + atoms")
    return written
