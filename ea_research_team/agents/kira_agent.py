"""
Kira — CME PDF & Report Parser
Parse CME Options Expiry, COT Report, News Calendar → key levels
"""
import os
import anthropic
from config import MODEL, KB_PATH
from tools.file_tools import read_file, agent_loop

client = anthropic.Anthropic()

SYSTEM = """คุณคือ Kira ผู้เชี่ยวชาญ parse ข้อมูลจาก CME, COT Report, และ Economic Calendar

หน้าที่:
1. อ่าน CME Gold/NQ Options PDF → หา Max Pain, Put Wall, Call Wall
2. อ่าน COT Report → ดู Commercials positioning (net long/short)
3. Parse News Calendar → หาข่าวสำคัญและเวลา
4. แปลงข้อมูลเป็น key trading levels สำหรับ XAUUSD และ NQ

Output format:
- Key levels พร้อมอธิบายว่าทำไมถึงสำคัญ
- Bias (Bullish/Bearish/Neutral) จาก institutional positioning
- Advice สำหรับ Gold_Breakout, NQ-GC_Scalper, SMC_Universal

หมายเหตุ: ถ้าไม่มี pdfplumber ให้รับ text ที่ paste มาโดยตรง"""

TOOLS = [
    {
        "name": "parse_pdf_file",
        "description": "อ่าน PDF file และ extract text (ต้องติดตั้ง pdfplumber)",
        "input_schema": {
            "type": "object",
            "properties": {
                "filepath": {"type": "string", "description": "absolute path ของ PDF file"},
                "pages":    {"type": "string", "description": "หน้าที่ต้องการ เช่น '1-3' หรือ 'all' (default all)"},
            },
            "required": ["filepath"],
        },
    },
    {
        "name": "extract_options_levels",
        "description": "วิเคราะห์ text จาก CME Options data และหา Max Pain, Put/Call walls",
        "input_schema": {
            "type": "object",
            "properties": {
                "text": {"type": "string", "description": "raw text จาก CME PDF หรือ paste โดยตรง"},
                "symbol": {"type": "string", "description": "'GC' (Gold) หรือ 'NQ' (Nasdaq)"},
            },
            "required": ["text"],
        },
    },
    {
        "name": "parse_news_calendar",
        "description": "วิเคราะห์ economic calendar text และหาข่าวสำคัญ",
        "input_schema": {
            "type": "object",
            "properties": {
                "text":     {"type": "string", "description": "calendar text ที่ paste มา"},
                "timezone": {"type": "string", "description": "timezone เช่น 'UTC+7' สำหรับไทย (default UTC+7)"},
            },
            "required": ["text"],
        },
    },
    {
        "name": "read_cot_data",
        "description": "อ่านและวิเคราะห์ COT (Commitment of Traders) data",
        "input_schema": {
            "type": "object",
            "properties": {
                "text": {"type": "string", "description": "COT data text"},
            },
            "required": ["text"],
        },
    },
    {
        "name": "read_kb_scalper",
        "description": "อ่าน NQ-GC_Scalper blueprint เพื่อ reference CME levels",
        "input_schema": {"type": "object", "properties": {}},
    },
]


def _parse_pdf(filepath: str, pages: str = "all") -> str:
    try:
        import pdfplumber
        with pdfplumber.open(filepath) as pdf:
            if pages == "all":
                text = "\n".join(p.extract_text() or "" for p in pdf.pages)
            else:
                start, end = (int(x)-1 for x in pages.split("-")) if "-" in pages else (int(pages)-1, int(pages))
                text = "\n".join(pdf.pages[i].extract_text() or "" for i in range(start, min(end+1, len(pdf.pages))))
        return text[:20000] if len(text) > 20000 else text
    except ImportError:
        return "ERROR: ต้องติดตั้ง pdfplumber ก่อน: pip install pdfplumber\nหรือ paste text จาก PDF โดยตรงแล้วใช้ extract_options_levels"
    except Exception as e:
        return f"Error reading PDF: {e}"


def _extract_options_levels(text: str, symbol: str = "GC") -> str:
    import re
    # หา strike prices และ OI/Volume จาก text
    prices = re.findall(r'\b(\d{3,5}(?:\.\d+)?)\b', text)
    prices = sorted(set(float(p) for p in prices if 1000 < float(p) < 99999), key=lambda x: x)

    hint = f"Symbol: {symbol}\nพบ price levels: {prices[:20] if prices else 'ไม่พบ'}\n"
    hint += "Claude จะวิเคราะห์ข้อมูลนี้เพื่อหา Max Pain และ wall levels"
    return hint + "\n\nRAW TEXT (ส่วนแรก):\n" + text[:3000]


def _parse_news_calendar(text: str, timezone: str = "UTC+7") -> str:
    high_impact = ["NFP", "CPI", "FOMC", "Fed", "GDP", "PPI", "PMI", "Unemployment",
                   "Interest Rate", "ดอกเบี้ย", "เงินเฟ้อ", "ตัวเลขการจ้างงาน"]
    found = []
    for line in text.split("\n"):
        for kw in high_impact:
            if kw.lower() in line.lower():
                found.append(line.strip())
                break
    result = f"Timezone: {timezone}\nHigh-impact events found:\n"
    result += "\n".join(f"  • {e}" for e in found[:20]) if found else "  ไม่พบ high-impact events"
    return result


def _execute(name: str, inputs: dict) -> str:
    if name == "parse_pdf_file":
        return _parse_pdf(inputs["filepath"], inputs.get("pages", "all"))
    if name == "extract_options_levels":
        return _extract_options_levels(inputs["text"], inputs.get("symbol", "GC"))
    if name == "parse_news_calendar":
        return _parse_news_calendar(inputs["text"], inputs.get("timezone", "UTC+7"))
    if name == "read_cot_data":
        return "COT Analysis:\n" + inputs["text"][:5000]
    if name == "read_kb_scalper":
        for fname in ["NQ-GC_Scalper_Markdown.md", "NQ-GC_Scalper_Obsidian.md"]:
            path = os.path.join(KB_PATH, "EAs", fname)
            if os.path.exists(path):
                return read_file(path)
        return "ไม่พบ NQ-GC_Scalper blueprint"
    return f"Unknown tool: {name}"


def run_kira_agent(task: str, pdf_path: str = None) -> str:
    full_task = task
    if pdf_path:
        full_task += f"\nPDF file: {pdf_path}"
    return agent_loop(client, MODEL, SYSTEM, TOOLS, full_task, _execute, label="Kira")
