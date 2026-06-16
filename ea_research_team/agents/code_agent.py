"""
Nova — Code Agent
วิเคราะห์ MQL5 source code ของ EA ใดก็ได้, ค้นหา bug, เขียน code fix

ใช้ได้กับทุก EA project — ระบุ project_name หรือ absolute path ก็ได้
"""
import os
import anthropic
from config import MODEL, KB_PATH, EA_PROJECTS, KB_SOURCE_FILES, list_projects
from tools.file_tools import list_dir, read_file, find_files, agent_loop

client = anthropic.Anthropic()

SYSTEM = """คุณคือ Nova ผู้เชี่ยวชาญ MQL5 สำหรับ Expert Advisor ทุกประเภท

ความเชี่ยวชาญ:
- Grid & Hedge: HedgeGrid_V23, AcG, Better_VIII, MMF, Snowball
- SMC / ICT: SMC_Universal_EA, SMC_BOS_CHoCH, NinjaThai architecture
- Regime-Adaptive: QField (SC₁₀₀), QuantumQueen, BB_EMA_ATR
- Scalping: Gold_Breakout, NQ-GC_Scalper, EX143_Prajuab
- Arbitrage: EA1-EA5 (3-pair correlation)
- Dashboard: Dashboard_MSA, WFH_99, ZigZag+Fibonacci

ก่อนวิเคราะห์ทุกครั้ง:
1. list_ea_projects() — ดูว่ามี project อะไรบ้าง
2. read_ea_blueprint(ea_name) — อ่าน design intent ก่อน
3. list_project_files(project) / read_mql5_file(path) — เปิด source

ตอบ: วิเคราะห์ logic, ชี้ bug พร้อม line reference, เสนอ code fix
Code output: MQL5 เสมอ"""

TOOLS = [
    {
        "name": "list_ea_projects",
        "description": "แสดง EA projects ทั้งหมดที่รู้จัก พร้อม path และสถานะ",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "list_project_files",
        "description": "แสดงไฟล์ใน EA project ที่ระบุ",
        "input_schema": {
            "type": "object",
            "properties": {
                "project": {
                    "type": "string",
                    "description": "ชื่อ project จาก list_ea_projects() เช่น 'SMC_Universal_v3', 'HedgeGrid_V23' หรือ absolute path ของ folder",
                },
                "subfolder": {
                    "type": "string",
                    "description": "subfolder ภายใน project เช่น 'Experts/SMC_Universal', 'Include/SMC_Universal' (optional)",
                },
            },
            "required": ["project"],
        },
    },
    {
        "name": "read_mql5_file",
        "description": "อ่าน MQL5 source file (.mq5 หรือ .mqh)",
        "input_schema": {
            "type": "object",
            "properties": {
                "path": {
                    "type": "string",
                    "description": "absolute path ของไฟล์ หรือ relative path จาก project root (ต้องระบุ project ด้วย)",
                },
                "project": {
                    "type": "string",
                    "description": "ชื่อ project (ถ้าใช้ relative path)",
                },
            },
            "required": ["path"],
        },
    },
    {
        "name": "find_mql5_files",
        "description": "ค้นหาไฟล์ .mq5 หรือ .mqh ทั้งหมดใน project",
        "input_schema": {
            "type": "object",
            "properties": {
                "project": {
                    "type": "string",
                    "description": "ชื่อ project หรือ absolute path",
                },
                "extension": {
                    "type": "string",
                    "description": "นามสกุล: '.mq5' หรือ '.mqh' (default: ทั้งคู่)",
                },
            },
            "required": ["project"],
        },
    },
    {
        "name": "read_ea_blueprint",
        "description": "อ่าน EA blueprint จาก Knowledge Base (อ่านก่อนวิเคราะห์ code เสมอ เพื่อเข้าใจ design intent)",
        "input_schema": {
            "type": "object",
            "properties": {
                "ea_name": {
                    "type": "string",
                    "description": "ชื่อ EA เช่น 'SMC_Universal_EA', 'HedgeGrid_V23', 'QField_EA', 'Gold_PA_Breakout', 'QuantumQueen'",
                }
            },
            "required": ["ea_name"],
        },
    },
    {
        "name": "list_kb_files",
        "description": "แสดงไฟล์ใน Knowledge Base (blueprints, code patterns, NinjaThai guides)",
        "input_schema": {
            "type": "object",
            "properties": {
                "subfolder": {
                    "type": "string",
                    "description": "เช่น 'EAs', 'EAs/Ninja', 'raw', '' สำหรับ root",
                }
            },
        },
    },
    {
        "name": "read_kb_file",
        "description": "อ่านไฟล์ใน Knowledge Base (code patterns, regime logic, risk management)",
        "input_schema": {
            "type": "object",
            "properties": {
                "filename": {
                    "type": "string",
                    "description": "relative path จาก KB root เช่น '05_Code_Patterns.md', '02_Regime_Detection.md'",
                }
            },
            "required": ["filename"],
        },
    },
]


def _resolve_project_path(project: str) -> str | None:
    if os.path.isabs(project) and os.path.exists(project):
        return project
    return EA_PROJECTS.get(project)


def _execute(name: str, inputs: dict) -> str:
    if name == "list_ea_projects":
        return list_projects()

    if name == "list_project_files":
        root = _resolve_project_path(inputs["project"])
        if not root:
            return f"ไม่รู้จัก project: {inputs['project']}\n{list_projects()}"
        sub = inputs.get("subfolder", "")
        target = os.path.join(root, sub) if sub else root
        return list_dir(target)

    if name == "read_mql5_file":
        path = inputs["path"]
        if not os.path.isabs(path):
            project = inputs.get("project", "")
            root = _resolve_project_path(project)
            if not root:
                return f"ต้องระบุ project ที่ถูกต้องเพื่อใช้ relative path\n{list_projects()}"
            path = os.path.join(root, path)
        return read_file(path, max_chars=30000)

    if name == "find_mql5_files":
        root = _resolve_project_path(inputs["project"])
        if not root:
            return f"ไม่รู้จัก project: {inputs['project']}\n{list_projects()}"
        ext = inputs.get("extension", "")
        if ext:
            return find_files(root, ext)
        return find_files(root, ".mq5") + "\n" + find_files(root, ".mqh")

    if name == "read_ea_blueprint":
        ea = inputs["ea_name"]
        candidates = [
            os.path.join(KB_PATH, "EAs", f"{ea}.md"),
            os.path.join(KB_PATH, "EAs", ea + ".md"),
            os.path.join(KB_PATH, f"{ea}.md"),
        ]
        for p in candidates:
            if os.path.exists(p):
                return read_file(p)
        # fuzzy: list EAs folder and hint
        files = list_dir(os.path.join(KB_PATH, "EAs"))
        return f"ไม่พบ blueprint สำหรับ '{ea}'\nไฟล์ที่มีใน EAs/:\n{files}"

    if name == "list_kb_files":
        sub = inputs.get("subfolder", "")
        return list_dir(os.path.join(KB_PATH, sub) if sub else KB_PATH)

    if name == "read_kb_file":
        return read_file(os.path.join(KB_PATH, inputs["filename"]))

    return f"Unknown tool: {name}"


def run_code_agent(task: str, file_path: str = None, project: str = None) -> str:
    full_task = task
    if project:
        full_task = f"[Project: {project}]\n{task}"
    if file_path:
        full_task += f"\nไฟล์หลักที่ต้องวิเคราะห์: {file_path}"
    return agent_loop(client, MODEL, SYSTEM, TOOLS, full_task, _execute, label="Nova")
