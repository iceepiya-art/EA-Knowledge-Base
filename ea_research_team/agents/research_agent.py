"""
Vera — Research Agent
ค้นหาและสรุปข้อมูลจาก EA Knowledge Base (blueprints, strategy notes, regime theory)
"""
import os
import anthropic
from config import MODEL, KB_PATH
from tools.file_tools import list_dir, read_file, find_files, agent_loop

client = anthropic.Anthropic()

SYSTEM = """คุณคือ Vera ผู้เชี่ยวชาญด้านการค้นหาและสรุปข้อมูลจาก EA Knowledge Base

ความเชี่ยวชาญ:
- SC₁₀₀ Regime Detection (TRENDING / REVERTING / WEAK / CRASH)
- NinjaThai SMC: BSL/SSL sweep, W&M pattern, CHoCH, S&D zone
- EA blueprints: QField, SMC_Universal, QuantumQueen, HedgeGrid
- Red Dog Trading: EMA Cross + FVG + Not 4th Candle rule
- RACE Framework สำหรับเขียน prompt ให้ agent

วิธีทำงาน:
1. list_kb_files ดูว่ามีอะไรบ้าง
2. read_kb_file เปิดไฟล์ที่เกี่ยวข้อง
3. ตอบอย่างละเอียดพร้อม reference ถึงไฟล์ต้นทาง"""

TOOLS = [
    {
        "name": "list_kb_files",
        "description": "แสดงรายการไฟล์/folder ใน Knowledge Base",
        "input_schema": {
            "type": "object",
            "properties": {
                "subfolder": {
                    "type": "string",
                    "description": "subfolder เช่น 'EAs', 'raw', 'EAs/Ninja' หรือ '' สำหรับ root",
                }
            },
        },
    },
    {
        "name": "read_kb_file",
        "description": "อ่านเนื้อหาไฟล์ใน Knowledge Base",
        "input_schema": {
            "type": "object",
            "properties": {
                "filename": {
                    "type": "string",
                    "description": "relative path จาก KB root เช่น '02_Regime_Detection.md', 'EAs/QField_EA.md', 'EAs/Ninja/คัมภีร์ระบบเทรด NinjaThai.md'",
                }
            },
            "required": ["filename"],
        },
    },
    {
        "name": "find_kb_files",
        "description": "ค้นหาไฟล์ทั้งหมดที่มีนามสกุลที่ระบุใน Knowledge Base",
        "input_schema": {
            "type": "object",
            "properties": {
                "extension": {
                    "type": "string",
                    "description": "นามสกุลไฟล์ เช่น '.md', '.txt'",
                }
            },
            "required": ["extension"],
        },
    },
]


def _execute(name: str, inputs: dict) -> str:
    if name == "list_kb_files":
        sub = inputs.get("subfolder", "")
        return list_dir(os.path.join(KB_PATH, sub) if sub else KB_PATH)
    if name == "read_kb_file":
        return read_file(os.path.join(KB_PATH, inputs["filename"]))
    if name == "find_kb_files":
        return find_files(KB_PATH, inputs["extension"])
    return f"Unknown tool: {name}"


def run_research_agent(task: str) -> str:
    return agent_loop(client, MODEL, SYSTEM, TOOLS, task, _execute, label="Vera")
