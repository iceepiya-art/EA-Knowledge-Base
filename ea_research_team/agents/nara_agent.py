"""
Nara — News & Session Calendar
ตรวจ session window, ข่าวสำคัญ, แนะนำว่าควรเทรดหรือหยุดพัก
"""
import os
from datetime import datetime, timezone, timedelta
import anthropic
from config import MODEL, KB_PATH
from tools.file_tools import read_file, agent_loop

client = anthropic.Anthropic()

SYSTEM = """คุณคือ Nara ผู้ดูแล Session Timing และ News Calendar

Session Windows (UTC+7 ไทย):
  Asian  : 07:00–09:00  (เปิด Tokyo)
  London : 15:00–17:00  (เปิด London, overlap Asian)
  NY Open: 19:30–21:30  (เปิด NY, overlap London = เวลาทอง)
  NY Late: 22:00–01:00  (หลัง London ปิด)

NinjaThai Sessions (High-priority):
  14:00–15:00 | 20:30–21:00

SMC_Universal_EA Sessions:
  Session1: London (08:00–11:00 UTC = 15:00–18:00 UTC+7)
  Session2: NY     (13:00–16:00 UTC = 20:00–23:00 UTC+7)
  Session3: Asian  (00:00–01:00 UTC = 07:00–08:00 UTC+7)

High-impact news → หยุดเทรด 30 นาทีก่อน-หลัง:
  NFP (ทุก 1st Friday), FOMC (6-8 ครั้ง/ปี), CPI, GDP

หน้าที่: บอกว่าตอนนี้อยู่ใน session ไหน + มีข่าวสำคัญไหม + ควรเทรดหรือไม่"""

TOOLS = [
    {
        "name": "check_current_session",
        "description": "เช็คว่าตอนนี้อยู่ใน trading session ไหน (UTC+7)",
        "input_schema": {
            "type": "object",
            "properties": {
                "datetime_str": {
                    "type": "string",
                    "description": "วันเวลาในรูป 'YYYY-MM-DD HH:MM' (UTC+7) หรือ '' สำหรับปัจจุบัน",
                }
            },
        },
    },
    {
        "name": "parse_news_events",
        "description": "วิเคราะห์ข่าวสำคัญจาก text ที่ paste มา (จาก Forex Factory หรือ Investing.com)",
        "input_schema": {
            "type": "object",
            "properties": {
                "calendar_text": {
                    "type": "string",
                    "description": "Economic calendar text",
                },
                "date": {
                    "type": "string",
                    "description": "วันที่สนใจ 'YYYY-MM-DD' (optional)",
                },
            },
            "required": ["calendar_text"],
        },
    },
    {
        "name": "should_trade_now",
        "description": "ตัดสินใจว่าควรเทรดตอนนี้หรือไม่ จาก session + news status",
        "input_schema": {
            "type": "object",
            "properties": {
                "ea_name":      {"type": "string", "description": "ชื่อ EA เช่น 'SMC_Universal', 'QField', 'HedgeGrid'"},
                "datetime_str": {"type": "string", "description": "วันเวลา UTC+7 หรือ '' สำหรับปัจจุบัน"},
                "has_news":     {"type": "boolean", "description": "มีข่าว high-impact ใน 30 นาทีหรือไม่"},
            },
            "required": ["ea_name"],
        },
    },
    {
        "name": "read_ea_session_config",
        "description": "อ่าน session configuration ของ EA จาก blueprint",
        "input_schema": {
            "type": "object",
            "properties": {
                "ea_name": {"type": "string", "description": "ชื่อ EA"},
            },
            "required": ["ea_name"],
        },
    },
]

TH_TZ = timezone(timedelta(hours=7))

SESSIONS = [
    ("Asian",   7,  0,  9,  0),
    ("London", 15,  0, 17,  0),
    ("NY_Open",19, 30, 21, 30),
    ("NY_Late",22,  0, 25,  0),  # 25:00 = 01:00 next day
    ("NinjaThai_A", 14, 0, 15, 0),
    ("NinjaThai_B", 20, 30, 21, 0),
]

HIGH_IMPACT = ["NFP", "Non-Farm", "FOMC", "Fed Rate", "CPI", "GDP", "PPI",
               "Unemployment", "Interest Rate", "Retail Sales", "ISM"]


def _check_session(datetime_str: str = "") -> str:
    if datetime_str:
        try:
            dt = datetime.strptime(datetime_str, "%Y-%m-%d %H:%M").replace(tzinfo=TH_TZ)
        except ValueError:
            dt = datetime.now(TH_TZ)
    else:
        dt = datetime.now(TH_TZ)

    hour_min = dt.hour + dt.minute / 60
    active = []
    for name, sh, sm, eh, em in SESSIONS:
        start = sh + sm / 60
        end = eh + em / 60
        if start <= hour_min <= end:
            active.append(name)

    lines = [f"เวลา (UTC+7): {dt.strftime('%Y-%m-%d %H:%M')}"]
    if active:
        lines.append(f"Active sessions: {', '.join(active)}")
    else:
        lines.append("Off-peak (ไม่อยู่ใน session หลัก)")

    # แสดง session ถัดไป
    next_sessions = []
    for name, sh, sm, _, _ in SESSIONS:
        start = sh + sm / 60
        if start > hour_min:
            mins = int((start - hour_min) * 60)
            next_sessions.append(f"{name} (อีก {mins} นาที)")
    if next_sessions:
        lines.append(f"Session ถัดไป: {next_sessions[0]}")
    return "\n".join(lines)


def _parse_news(calendar_text: str, date: str = "") -> str:
    found = []
    for line in calendar_text.split("\n"):
        for kw in HIGH_IMPACT:
            if kw.lower() in line.lower():
                found.append(line.strip())
                break
    result = "High-impact events:\n"
    result += "\n".join(f"  [!] {e}" for e in found[:15]) if found else "  ไม่พบ high-impact events"
    return result


def _should_trade(ea_name: str, datetime_str: str = "", has_news: bool = False) -> str:
    session_info = _check_session(datetime_str)
    is_in_session = "active" in session_info

    ea_sessions = {
        "SMC_Universal": ["London", "NY_Open", "NinjaThai_A", "NinjaThai_B"],
        "QField": ["London", "NY_Open", "NY_Late"],
        "HedgeGrid": ["London", "NY_Open"],
        "MMF": ["London", "NY_Open"],
        "QuantumQueen": ["London", "NY_Open"],
    }
    preferred = ea_sessions.get(ea_name, ["London", "NY_Open"])

    lines = [session_info, ""]
    if has_news:
        lines.append("DECISION: STOP — มีข่าว high-impact ใน 30 นาที รอข่าวผ่านก่อน")
    elif not is_in_session:
        lines.append(f"DECISION: WAIT — ไม่อยู่ใน session ของ {ea_name} ({', '.join(preferred)})")
    else:
        lines.append(f"DECISION: TRADE — พร้อมเทรด {ea_name}")
    return "\n".join(lines)


def _read_ea_session(ea_name: str) -> str:
    path = os.path.join(KB_PATH, "EAs", f"{ea_name}.md")
    if not os.path.exists(path):
        return f"ไม่พบ blueprint สำหรับ {ea_name}"
    content = read_file(path, max_chars=5000)
    return content


def _execute(name: str, inputs: dict) -> str:
    if name == "check_current_session":
        return _check_session(inputs.get("datetime_str", ""))
    if name == "parse_news_events":
        return _parse_news(inputs["calendar_text"], inputs.get("date", ""))
    if name == "should_trade_now":
        return _should_trade(inputs["ea_name"], inputs.get("datetime_str", ""), inputs.get("has_news", False))
    if name == "read_ea_session_config":
        return _read_ea_session(inputs["ea_name"])
    return f"Unknown tool: {name}"


def run_nara_agent(task: str) -> str:
    return agent_loop(client, MODEL, SYSTEM, TOOLS, task, _execute, label="Nara")
