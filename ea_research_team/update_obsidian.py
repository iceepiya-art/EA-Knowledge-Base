"""
Update Obsidian MOC — สแกน raw/ แล้วเพิ่มไฟล์ใหม่เข้า 00_MOC.md
"""
import os
import sys
sys.stdout.reconfigure(encoding="utf-8")
from datetime import datetime, timezone, timedelta

sys.path.insert(0, os.path.dirname(__file__))
from config import KB_PATH

TH_TZ = timezone(timedelta(hours=7))
MOC_PATH = os.path.join(KB_PATH, "00_MOC.md")
RAW_PATH = os.path.join(KB_PATH, "raw")
RAW_SECTION = "## 📚 Raw Research (raw/)"
NEW_SECTION  = "### 🆕 Recently Added\n"


def get_raw_files() -> list[str]:
    """ดึงชื่อไฟล์ .md ทั้งหมดใน raw/ แบบ Recursive"""
    if not os.path.exists(RAW_PATH):
        return []
    
    md_files = []
    for root, dirs, files in os.walk(RAW_PATH):
        for f in files:
            if f.endswith(".md") and not f.startswith("."):
                # Get relative path from RAW_PATH
                rel_path = os.path.relpath(os.path.join(root, f), RAW_PATH)
                md_files.append(rel_path.replace("\\", "/"))
    return sorted(md_files)


def get_linked_in_moc(content: str) -> set[str]:
    """ดึง filename ที่ link อยู่ใน MOC แล้ว"""
    import re
    # จับ [[raw/xxx]] หรือ [[raw/xxx|label]]
    matches = re.findall(r"\[\[raw/([^\]|]+)", content)
    return {m.strip() for m in matches}


def build_entry(filename: str) -> str:
    """สร้าง MOC entry จากชื่อไฟล์"""
    stem = filename.replace(".md", "")
    filepath = os.path.join(RAW_PATH, filename.replace("/", os.sep))
    title = os.path.basename(stem)
    try:
        with open(filepath, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line.startswith("# "):
                    title = line[2:].strip()
                    break
                if line == "---" and title != stem:
                    break
    except Exception:
        pass
    return f"- [[raw/{stem}]] — {title}\n"


def update_moc(dry_run: bool = False) -> int:
    """อัปเดต MOC — คืนจำนวนไฟล์ที่เพิ่ม"""
    if not os.path.exists(MOC_PATH):
        print("ไม่พบ 00_MOC.md")
        return 0

    with open(MOC_PATH, "r", encoding="utf-8") as f:
        content = f.read()

    raw_files  = get_raw_files()
    linked     = get_linked_in_moc(content)
    missing    = [f for f in raw_files if f.replace(".md", "") not in linked]

    if not missing:
        print("MOC ครบแล้ว ไม่มีไฟล์ใหม่")
        return 0

    print(f"พบไฟล์ใหม่ {len(missing)} ไฟล์:")
    new_entries = ""
    for f in missing:
        entry = build_entry(f)
        print(f"  + {entry.strip()}")
        new_entries += entry

    if dry_run:
        print("(dry run — ไม่ได้บันทึก)")
        return len(missing)

    # แทรกใต้ RAW_SECTION
    if NEW_SECTION in content:
        content = content.replace(NEW_SECTION, NEW_SECTION + new_entries)
    elif RAW_SECTION in content:
        content = content.replace(
            RAW_SECTION,
            RAW_SECTION + "\n\n" + NEW_SECTION + new_entries
        )
    else:
        content += f"\n\n{RAW_SECTION}\n\n{NEW_SECTION}{new_entries}"

    # อัปเดตวันที่
    today = datetime.now(TH_TZ).strftime("%Y-%m-%d")
    import re
    content = re.sub(r"\*\*Updated:\*\* \d{4}-\d{2}-\d{2}", f"**Updated:** {today}", content)

    with open(MOC_PATH, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"\nMOC อัปเดตแล้ว ({len(missing)} รายการ)")
    return len(missing)


if __name__ == "__main__":
    dry = "--dry" in sys.argv
    update_moc(dry_run=dry)
