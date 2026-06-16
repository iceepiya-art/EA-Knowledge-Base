"""
Diag — Analyst Agent
วิเคราะห์ backtest DIAG log, trade statistics, แนะนำ fix
"""
import os
import anthropic
from config import MODEL
from tools.file_tools import read_file, agent_loop

client = anthropic.Anthropic()

SYSTEM = """คุณคือ Diag ผู้เชี่ยวชาญวิเคราะห์ backtest log ของ SMC_Universal_EA

รู้จัก DIAG format:
  [DIAG] date | sess | regime | SC100 | b1 | gate | reason
  gate counter บันทึกว่า setup ถูกบล็อคเพราะอะไร:
    gate=1   SweepFail     (CheckLiqSweep ไม่ผ่าน)
    gate=2   BOS_Fail      (BOS ไม่ยืนยัน)
    gate=4   FVG_Fail      (ไม่มี FVG)
    gate=8   OB_Fail       (ไม่มี OB)
    gate=16  Regime_Block  (SC₁₀₀ ไม่เหมาะ)
    gate=32  Session_Block (นอก session window)
    gate=64  NewsBlock     (ใกล้ news)
    gate=128 DD_Limit      (drawdown เกิน)
    gate=256 BetaDir_Block (β₁ direction ไม่ตรง)
  gate จะ bitmask OR กัน เช่น gate=281 = 256+16+8+1

สถิติที่ต้องวิเคราะห์:
- entries vs scan_fail vs sess_blocked ratio
- gate distribution (ตัวไหน block มากที่สุด)
- Short=0 patterns (market regime bias)
- win rate, PF, max DD

ตอบพร้อม:
1. สาเหตุหลักที่ทำให้ entry น้อย
2. gate ที่ควร tune
3. แนะนำ input parameter ที่ควรปรับ
4. fix priority (urgent / nice-to-have)"""

TOOLS = [
    {
        "name": "read_log_file",
        "description": "อ่านไฟล์ DIAG log หรือ backtest report",
        "input_schema": {
            "type": "object",
            "properties": {
                "path": {
                    "type": "string",
                    "description": "absolute path ของ log file",
                }
            },
            "required": ["path"],
        },
    },
    {
        "name": "parse_gate_stats",
        "description": "นับ gate bitmask จาก DIAG log text ที่ paste มา แล้ว breakdown เป็นรายเหตุผล",
        "input_schema": {
            "type": "object",
            "properties": {
                "log_text": {
                    "type": "string",
                    "description": "raw DIAG log text (paste โดยตรง)",
                }
            },
            "required": ["log_text"],
        },
    },
]

GATE_NAMES = {
    1: "SweepFail",
    2: "BOS_Fail",
    4: "FVG_Fail",
    8: "OB_Fail",
    16: "Regime_Block",
    32: "Session_Block",
    64: "NewsBlock",
    128: "DD_Limit",
    256: "BetaDir_Block",
}


def _parse_gate_stats(log_text: str) -> str:
    import re
    counter = {}
    gate_pattern = re.compile(r"gate=(\d+)")
    for m in gate_pattern.finditer(log_text):
        val = int(m.group(1))
        for bit, name in GATE_NAMES.items():
            if val & bit:
                counter[name] = counter.get(name, 0) + 1

    if not counter:
        return "ไม่พบ gate= ใน log"

    total = sum(counter.values())
    lines = [f"Gate breakdown (total bits: {total}):"]
    for name, count in sorted(counter.items(), key=lambda x: -x[1]):
        pct = count / total * 100
        lines.append(f"  {name:20s}: {count:5d} ({pct:.1f}%)")
    return "\n".join(lines)


def _execute(name: str, inputs: dict) -> str:
    if name == "read_log_file":
        return read_file(inputs["path"], max_chars=30000)
    if name == "parse_gate_stats":
        return _parse_gate_stats(inputs["log_text"])
    return f"Unknown tool: {name}"


def run_analyst_agent(task: str, log_content: str = None) -> str:
    full_task = task
    if log_content:
        full_task = f"{task}\n\n--- DIAG LOG ---\n{log_content}\n--- END LOG ---"
    return agent_loop(client, MODEL, SYSTEM, TOOLS, full_task, _execute, label="Diag")
