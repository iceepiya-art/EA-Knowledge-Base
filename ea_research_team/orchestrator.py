"""
EA Research Team — Cody Orchestrator
Supervisor สำหรับ 11 agents ครอบคลุมทุก EA project

Usage:
  python orchestrator.py
  python orchestrator.py "ทำไม HedgeGrid ถึง lot size ใหญ่เกินไป"
  python orchestrator.py --chart path/to/screenshot.png "วิเคราะห์ setup"
"""
import sys
import argparse
import anthropic
from config import MODEL, list_projects
from agents.research_agent import run_research_agent
from agents.code_agent     import run_code_agent
from agents.analyst_agent  import run_analyst_agent
from agents.momo_agent     import run_momo_agent
from agents.iris_agent     import run_iris_agent
from agents.risco_agent    import run_risco_agent
from agents.kira_agent     import run_kira_agent
from agents.remy_agent     import run_remy_agent
from agents.penny_agent    import run_penny_agent
from agents.nara_agent     import run_nara_agent
from agents.scribe_agent   import run_scribe_agent
from tools.file_tools import agent_loop

client = anthropic.Anthropic()

SYSTEM = """คุณคือ Cody ผู้จัดการทีม EA Research Team

ทีมทั้งหมด 11 agents:
┌─ Knowledge & Code ──────────────────────────────────┐
│  Vera   — ค้นหาข้อมูลจาก KB, blueprints, guides     │
│  Nova   — วิเคราะห์/เขียน MQL5 code ทุก EA project │
│  Diag   — วิเคราะห์ DIAG log, gate stats            │
├─ Market Intelligence ────────────────────────────────┤
│  Momo   — SC₁₀₀/β₁/RSI regime detection จาก CSV    │
│  Iris   — อ่านกราฟจาก screenshot (vision)           │
│  Penny  — Currency strength 28 pairs (MMF/Dashboard) │
│  Kira   — CME PDF parser, COT report, News calendar  │
├─ Risk & Operations ─────────────────────────────────┤
│  Risco  — Lot size, DD guard, FTMO compliance       │
│  Nara   — Session timing, news alert                │
│  Remy   — Python quick backtest บน CSV data         │
└─ Memory ────────────────────────────────────────────┘
   Scribe — บันทึก log, อัปเดต CHANGELOG, สร้าง note

Route ตามลักษณะคำถาม:
- "SC₁₀₀ / regime / trend" → Momo
- "กราฟ / chart / pattern / FVG / W/M" → Iris (ต้องมี image_path)
- "lot / risk / DD / FTMO" → Risco
- "session / เวลา / ข่าว / news" → Nara
- "backtest / WR / PF / test" → Diag หรือ Remy
- "currency / strength / MMF / 28 pairs" → Penny
- "CME / PDF / options / COT" → Kira
- "บันทึก / log / changelog / blueprint" → Scribe
- "strategy / blueprint / concept" → Vera
- "code / bug / fix / MQL5" → Nova
- คำถามซับซ้อน → ส่งหลาย agents พร้อมกัน"""

TOOLS = [
    {"name": "ask_vera",   "description": "Vera: ค้นหาข้อมูล KB, blueprints, NinjaThai guides, strategy concepts",
     "input_schema": {"type": "object", "properties": {"task": {"type": "string"}}, "required": ["task"]}},

    {"name": "ask_nova",   "description": "Nova: วิเคราะห์/เขียน MQL5 source code ทุก EA project",
     "input_schema": {"type": "object", "properties": {
         "task": {"type": "string"}, "project": {"type": "string"}, "file_path": {"type": "string"}
     }, "required": ["task"]}},

    {"name": "ask_diag",   "description": "Diag: วิเคราะห์ backtest DIAG log, gate counter, fix priority",
     "input_schema": {"type": "object", "properties": {
         "task": {"type": "string"}, "log_content": {"type": "string"}
     }, "required": ["task"]}},

    {"name": "ask_momo",   "description": "Momo: คำนวณ SC₁₀₀/β₁/RSI จาก CSV → regime + EA recommendation",
     "input_schema": {"type": "object", "properties": {"task": {"type": "string"}}, "required": ["task"]}},

    {"name": "ask_iris",   "description": "Iris: วิเคราะห์กราฟจาก screenshot → pattern, FVG, BOS, setup (ต้องมี image_path)",
     "input_schema": {"type": "object", "properties": {
         "task": {"type": "string"}, "image_path": {"type": "string"}
     }, "required": ["task", "image_path"]}},

    {"name": "ask_risco",  "description": "Risco: คำนวณ lot size, ตรวจ DD, FTMO compliance",
     "input_schema": {"type": "object", "properties": {"task": {"type": "string"}}, "required": ["task"]}},

    {"name": "ask_kira",   "description": "Kira: parse CME PDF, COT report, news calendar → key levels",
     "input_schema": {"type": "object", "properties": {
         "task": {"type": "string"}, "pdf_path": {"type": "string"}
     }, "required": ["task"]}},

    {"name": "ask_remy",   "description": "Remy: รัน quick backtest บน XAUUSD M1 CSV data",
     "input_schema": {"type": "object", "properties": {"task": {"type": "string"}}, "required": ["task"]}},

    {"name": "ask_penny",  "description": "Penny: คำนวณ currency strength 28 pairs สำหรับ MMF/Dashboard",
     "input_schema": {"type": "object", "properties": {"task": {"type": "string"}}, "required": ["task"]}},

    {"name": "ask_nara",   "description": "Nara: เช็ค session timing, parse news calendar, แนะนำว่าควรเทรดไหม",
     "input_schema": {"type": "object", "properties": {"task": {"type": "string"}}, "required": ["task"]}},

    {"name": "ask_scribe", "description": "Scribe: บันทึก session log, อัปเดต CHANGELOG, สร้าง blueprint ใหม่",
     "input_schema": {"type": "object", "properties": {"task": {"type": "string"}}, "required": ["task"]}},
]

AGENT_MAP = {
    "ask_vera":   lambda i: run_research_agent(i["task"]),
    "ask_nova":   lambda i: run_code_agent(i["task"], i.get("file_path"), i.get("project")),
    "ask_diag":   lambda i: run_analyst_agent(i["task"], i.get("log_content")),
    "ask_momo":   lambda i: run_momo_agent(i["task"]),
    "ask_iris":   lambda i: run_iris_agent(i["task"], i.get("image_path")),
    "ask_risco":  lambda i: run_risco_agent(i["task"]),
    "ask_kira":   lambda i: run_kira_agent(i["task"], i.get("pdf_path")),
    "ask_remy":   lambda i: run_remy_agent(i["task"]),
    "ask_penny":  lambda i: run_penny_agent(i["task"]),
    "ask_nara":   lambda i: run_nara_agent(i["task"]),
    "ask_scribe": lambda i: run_scribe_agent(i["task"]),
}

AGENT_LABELS = {
    "ask_vera": "Vera", "ask_nova": "Nova", "ask_diag": "Diag",
    "ask_momo": "Momo", "ask_iris": "Iris", "ask_risco": "Risco",
    "ask_kira": "Kira", "ask_remy": "Remy", "ask_penny": "Penny",
    "ask_nara": "Nara", "ask_scribe": "Scribe",
}


def _execute(name: str, inputs: dict) -> str:
    fn = AGENT_MAP.get(name)
    if not fn:
        return f"Unknown agent: {name}"
    label = AGENT_LABELS.get(name, name)
    print(f"\n  → {label} กำลังทำงาน...")
    return fn(inputs)


def run(question: str) -> str:
    return agent_loop(client, MODEL, SYSTEM, TOOLS, question, _execute, label="Cody")


def main():
    parser = argparse.ArgumentParser(description="EA Research Team")
    parser.add_argument("question", nargs="*", help="คำถามหรืองานที่ต้องการ")
    parser.add_argument("--chart", help="path ของ chart screenshot (สำหรับ Iris)")
    parser.add_argument("--projects", action="store_true", help="แสดง EA projects ที่รู้จัก")
    args = parser.parse_args()

    print("=" * 65)
    print("  EA Research Team — Cody Orchestrator  (11 agents)")
    print("  Vera | Nova | Diag | Momo | Iris | Risco")
    print("  Kira | Remy | Penny | Nara | Scribe")
    print("=" * 65)

    if args.projects:
        print(list_projects())
        return

    if args.question:
        question = " ".join(args.question)
        if args.chart:
            question += f"\n[chart: {args.chart}]"
        print(f"\nคุณ: {question}\n")
        print("⚙️  Cody กำลังประมวลผล...\n")
        answer = run(question)
        print(f"\nCody:\n{answer}\n")
        return

    print("พิมพ์คำถาม หรือ 'exit' เพื่อออก | '--projects' เพื่อดู EA list\n")
    while True:
        try:
            question = input("คุณ: ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\nBye!")
            break
        if not question:
            continue
        if question.lower() in ["exit", "quit", "ออก", "q"]:
            print("Bye!")
            break
        if question == "--projects":
            print(list_projects())
            continue
        print("\n⚙️  Cody กำลังประมวลผล...\n")
        answer = run(question)
        print(f"\nCody:\n{answer}")
        print("\n" + "-" * 65 + "\n")


if __name__ == "__main__":
    main()
