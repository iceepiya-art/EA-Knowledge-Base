"""
Scribe — KB Writer & Logger
บันทึก session log, อัปเดต CHANGELOG, เพิ่ม blueprint ใหม่เข้า KB
"""
import os
from datetime import datetime, timezone, timedelta
import anthropic
from config import MODEL, KB_PATH, EA_PROJECTS
from tools.file_tools import read_file, agent_loop

client = anthropic.Anthropic()

TH_TZ = timezone(timedelta(hours=7))

SYSTEM = """คุณคือ Scribe ผู้ดูแล Knowledge Base และ Documentation

หน้าที่:
1. บันทึก session log หลัง backtest หรือ live trading
2. อัปเดต CHANGELOG ของ EA เมื่อมี fix ใหม่
3. สร้าง blueprint .md ใหม่จากข้อมูลที่ได้รับ
4. อัปเดต 00_MOC.md index
5. สรุปผล research เป็น structured note

Format มาตรฐาน KB:
- Session log: `logs/YYYY-MM-DD_[EA]_session.md`
- Blueprint: `EAs/[EA_Name].md` พร้อม frontmatter YAML
- CHANGELOG entry: `## fix[N] — YYYY-MM-DD\\n\\n### สาเหตุ\\n### การแก้ไข\\n### ผลลัพธ์`"""

TOOLS = [
    {
        "name": "write_session_log",
        "description": "บันทึก trading session log เข้า KB",
        "input_schema": {
            "type": "object",
            "properties": {
                "ea_name":   {"type": "string", "description": "ชื่อ EA"},
                "content":   {"type": "string", "description": "เนื้อหา session log"},
                "date":      {"type": "string", "description": "วันที่ 'YYYY-MM-DD' หรือ '' สำหรับวันนี้"},
            },
            "required": ["ea_name", "content"],
        },
    },
    {
        "name": "append_changelog",
        "description": "เพิ่ม entry ใหม่ใน CHANGELOG ของ EA",
        "input_schema": {
            "type": "object",
            "properties": {
                "ea_name":    {"type": "string", "description": "ชื่อ EA เช่น 'SMC_Universal', 'HedgeGrid_V23'"},
                "fix_number": {"type": "string", "description": "หมายเลข fix เช่น '27'"},
                "title":      {"type": "string", "description": "หัวข้อ fix"},
                "cause":      {"type": "string", "description": "สาเหตุของปัญหา"},
                "fix":        {"type": "string", "description": "วิธีแก้ไข"},
                "result":     {"type": "string", "description": "ผลลัพธ์ที่คาดหวัง"},
            },
            "required": ["ea_name", "fix_number", "title", "fix"],
        },
    },
    {
        "name": "create_blueprint",
        "description": "สร้าง EA blueprint .md ใหม่ใน EAs/ folder",
        "input_schema": {
            "type": "object",
            "properties": {
                "ea_name":   {"type": "string", "description": "ชื่อ EA (ใช้เป็นชื่อไฟล์)"},
                "content":   {"type": "string", "description": "เนื้อหา blueprint (Markdown)"},
                "overwrite": {"type": "boolean", "description": "เขียนทับถ้ามีอยู่แล้ว (default false)"},
            },
            "required": ["ea_name", "content"],
        },
    },
    {
        "name": "write_raw_note",
        "description": "บันทึก research note ใหม่เข้า raw/ folder",
        "input_schema": {
            "type": "object",
            "properties": {
                "filename": {"type": "string", "description": "ชื่อไฟล์ .md เช่น 'New_Strategy_Analysis.md'"},
                "content":  {"type": "string", "description": "เนื้อหา (Markdown พร้อม YAML frontmatter)"},
            },
            "required": ["filename", "content"],
        },
    },
    {
        "name": "read_existing_file",
        "description": "อ่านไฟล์ที่มีอยู่แล้วก่อน append หรือ overwrite",
        "input_schema": {
            "type": "object",
            "properties": {
                "filepath": {"type": "string", "description": "relative path จาก KB root"},
            },
            "required": ["filepath"],
        },
    },
    {
        "name": "list_logs",
        "description": "แสดง session logs ที่มีอยู่",
        "input_schema": {"type": "object", "properties": {}},
    },
]


def _safe_write(path: str, content: str, overwrite: bool = True) -> str:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    if os.path.exists(path) and not overwrite:
        return f"ไฟล์มีอยู่แล้ว: {path} (ใช้ overwrite=true เพื่อเขียนทับ)"
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
    return f"บันทึกสำเร็จ: {path}"


def _write_session_log(ea_name: str, content: str, date: str = "") -> str:
    d = date or datetime.now(TH_TZ).strftime("%Y-%m-%d")
    log_dir = os.path.join(KB_PATH, "logs")
    filename = f"{d}_{ea_name}_session.md"
    path = os.path.join(log_dir, filename)
    now = datetime.now(TH_TZ).strftime("%Y-%m-%d %H:%M")
    full_content = f"---\ndate: {d}\nea: {ea_name}\ncreated: {now}\n---\n\n# Session Log — {ea_name} ({d})\n\n{content}\n"
    return _safe_write(path, full_content)


def _append_changelog(ea_name: str, fix_number: str, title: str,
                      fix: str, cause: str = "", result: str = "") -> str:
    date = datetime.now(TH_TZ).strftime("%Y-%m-%d")
    entry = f"\n## fix{fix_number} — {date}\n\n**{title}**\n"
    if cause:
        entry += f"\n### สาเหตุ\n{cause}\n"
    entry += f"\n### การแก้ไข\n{fix}\n"
    if result:
        entry += f"\n### ผลลัพธ์ที่คาดหวัง\n{result}\n"

    # หา CHANGELOG ใน EA projects
    changelog_paths = []
    for proj_path in EA_PROJECTS.values():
        p = os.path.join(proj_path, "CHANGELOG.md")
        if os.path.exists(p) and ea_name.lower().replace("_", "") in proj_path.lower().replace("_", ""):
            changelog_paths.append(p)

    # fallback: KB EAs folder
    kb_cl = os.path.join(KB_PATH, "EAs", ea_name, "CHANGELOG.md")
    if os.path.exists(kb_cl):
        changelog_paths.append(kb_cl)

    if not changelog_paths:
        # สร้างใหม่ใน KB
        path = os.path.join(KB_PATH, "logs", f"CHANGELOG_{ea_name}.md")
        existing = read_file(path) if os.path.exists(path) else f"# CHANGELOG — {ea_name}\n"
        return _safe_write(path, existing + entry)

    results = []
    for path in changelog_paths:
        existing = read_file(path)
        results.append(_safe_write(path, existing + entry))
    return "\n".join(results)


def _create_blueprint(ea_name: str, content: str, overwrite: bool = False) -> str:
    path = os.path.join(KB_PATH, "EAs", f"{ea_name}.md")
    return _safe_write(path, content, overwrite)


def _write_raw_note(filename: str, content: str) -> str:
    if not filename.endswith(".md"):
        filename += ".md"
    path = os.path.join(KB_PATH, "raw", filename)
    return _safe_write(path, content)


def _list_logs() -> str:
    log_dir = os.path.join(KB_PATH, "logs")
    if not os.path.exists(log_dir):
        return "ยังไม่มี logs folder (จะถูกสร้างเมื่อมีการบันทึกครั้งแรก)"
    files = sorted(os.listdir(log_dir))
    return "\n".join(files) if files else "ไม่มี logs"


def _execute(name: str, inputs: dict) -> str:
    if name == "write_session_log":
        return _write_session_log(inputs["ea_name"], inputs["content"], inputs.get("date", ""))
    if name == "append_changelog":
        return _append_changelog(inputs["ea_name"], inputs["fix_number"], inputs["title"],
                                 inputs["fix"], inputs.get("cause", ""), inputs.get("result", ""))
    if name == "create_blueprint":
        return _create_blueprint(inputs["ea_name"], inputs["content"], inputs.get("overwrite", False))
    if name == "write_raw_note":
        return _write_raw_note(inputs["filename"], inputs["content"])
    if name == "read_existing_file":
        return read_file(os.path.join(KB_PATH, inputs["filepath"]))
    if name == "list_logs":
        return _list_logs()
    return f"Unknown tool: {name}"


def run_scribe_agent(task: str) -> str:
    return agent_loop(client, MODEL, SYSTEM, TOOLS, task, _execute, label="Scribe")
