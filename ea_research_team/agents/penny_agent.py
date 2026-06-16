"""
Penny — Currency Strength Monitor
คำนวณ CCI(1000) ของ 28 pairs → rank สกุลเงินแข็ง/อ่อน สำหรับ MMF และ Dashboard
"""
import os
import anthropic
from config import MODEL, KB_PATH
from tools.file_tools import read_file, agent_loop

client = anthropic.Anthropic()

SYSTEM = """คุณคือ Penny ผู้เชี่ยวชาญ Currency Strength Analysis สำหรับ 28 Forex pairs

8 สกุลเงินหลัก: USD EUR GBP JPY AUD NZD CAD CHF
28 pairs ครบ: EURUSD GBPUSD USDJPY USDCHF USDCAD AUDUSD NZDUSD EURGBP EURJPY EURCHF EURCAD EURAUD EURNZD GBPJPY GBPCHF GBPCAD GBPAUD GBPNZD AUDJPY AUDCHF AUDCAD AUDNZD CADJPY CADCHF CHFJPY NZDJPY NZDCAD NZDCHF

CCI(1000): Commodity Channel Index period 1000 ใช้เป็น currency strength gauge
- สูง (+) = สกุลนั้นแข็ง
- ต่ำ (-) = สกุลนั้นอ่อน
- ใช้หา pair ที่แข็งที่สุด vs อ่อนที่สุด → เข้าเทรดตาม momentum

MMF strategy: เปิดเฉพาะ pair ที่ currency strength diverge สูงสุด 3-5 pairs
Dashboard_MSA: แสดง strength bar ของ 8 สกุลเงิน

รับ input: data ที่ paste มา หรือ MT5 export หรือ strength values"""

TOOLS = [
    {
        "name": "calc_strength_from_values",
        "description": "คำนวณ currency strength ranking จาก strength values ที่ paste มา",
        "input_schema": {
            "type": "object",
            "properties": {
                "data": {
                    "type": "string",
                    "description": "strength data ในรูป 'USD:120, EUR:85, GBP:65...' หรือ JSON หรือ CSV",
                }
            },
            "required": ["data"],
        },
    },
    {
        "name": "calc_strength_from_closes",
        "description": "คำนวณ simplified currency strength จาก close prices ของ major pairs",
        "input_schema": {
            "type": "object",
            "properties": {
                "eurusd": {"type": "number"},
                "gbpusd": {"type": "number"},
                "usdjpy": {"type": "number"},
                "usdchf": {"type": "number"},
                "usdcad": {"type": "number"},
                "audusd": {"type": "number"},
                "nzdusd": {"type": "number"},
                "prev_eurusd": {"type": "number", "description": "ราคาปิดก่อนหน้า (optional สำหรับ momentum)"},
            },
            "required": ["eurusd", "gbpusd", "usdjpy", "usdchf", "usdcad", "audusd", "nzdusd"],
        },
    },
    {
        "name": "recommend_mmf_pairs",
        "description": "แนะนำ pairs ที่ควรเทรดสำหรับ MMF จาก strength ranking",
        "input_schema": {
            "type": "object",
            "properties": {
                "strongest": {"type": "array", "items": {"type": "string"}, "description": "สกุลเงินที่แข็งที่สุด (เรียงจากมากไปน้อย)"},
                "weakest":   {"type": "array", "items": {"type": "string"}, "description": "สกุลเงินที่อ่อนที่สุด (เรียงจากน้อยไปมาก)"},
                "n_pairs":   {"type": "integer", "description": "จำนวน pairs ที่ต้องการ (default 3)"},
            },
            "required": ["strongest", "weakest"],
        },
    },
    {
        "name": "read_mmf_blueprint",
        "description": "อ่าน MMF EA blueprint จาก KB",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "read_dashboard_blueprint",
        "description": "อ่าน Dashboard_MSA blueprint",
        "input_schema": {"type": "object", "properties": {}},
    },
]

CURRENCIES = ["USD", "EUR", "GBP", "JPY", "AUD", "NZD", "CAD", "CHF"]

PAIR_CURRENCIES = {
    "EURUSD": ("EUR", "USD"), "GBPUSD": ("GBP", "USD"), "USDJPY": ("USD", "JPY"),
    "USDCHF": ("USD", "CHF"), "USDCAD": ("USD", "CAD"), "AUDUSD": ("AUD", "USD"),
    "NZDUSD": ("NZD", "USD"),
}


def _calc_from_values(data: str) -> str:
    import re
    strengths = {}
    # parse "USD:120, EUR:85" or "USD=120 EUR=85" or similar
    for m in re.finditer(r'([A-Z]{3})\s*[:=]\s*(-?\d+(?:\.\d+)?)', data):
        strengths[m.group(1)] = float(m.group(2))
    if not strengths:
        return "ไม่สามารถ parse data ได้ กรุณาส่งในรูป 'USD:120, EUR:85, ...'"
    ranked = sorted(strengths.items(), key=lambda x: -x[1])
    lines = ["Currency Strength Ranking:"]
    for i, (cur, val) in enumerate(ranked, 1):
        bar = "█" * min(int(abs(val) / 10), 20)
        sign = "+" if val > 0 else ""
        lines.append(f"  {i}. {cur}: {sign}{val:.1f}  {bar}")
    return "\n".join(lines)


def _calc_from_closes(**closes) -> str:
    strength = {c: 0.0 for c in CURRENCIES}
    for pair, (base, quote) in PAIR_CURRENCIES.items():
        price = closes.get(pair.lower())
        if price is None:
            continue
        strength[base] += price * 100
        strength[quote] -= price * 100
    ranked = sorted(strength.items(), key=lambda x: -x[1])
    lines = ["Simplified Strength (from 7 major pairs):"]
    for i, (cur, val) in enumerate(ranked, 1):
        lines.append(f"  {i}. {cur}: {val:+.2f}")
    return "\n".join(lines)


def _recommend_mmf_pairs(strongest: list, weakest: list, n_pairs: int = 3) -> str:
    pairs_28 = [
        "EURUSD","GBPUSD","USDJPY","USDCHF","USDCAD","AUDUSD","NZDUSD",
        "EURGBP","EURJPY","EURCHF","EURCAD","EURAUD","EURNZD","GBPJPY",
        "GBPCHF","GBPCAD","GBPAUD","GBPNZD","AUDJPY","AUDCHF","AUDCAD",
        "AUDNZD","CADJPY","CADCHF","CHFJPY","NZDJPY","NZDCAD","NZDCHF",
    ]
    recommendations = []
    for s in strongest[:3]:
        for w in weakest[:3]:
            # construct pair name
            p1 = s + w
            p2 = w + s
            if p1 in pairs_28:
                recommendations.append(f"BUY  {p1}  ({s} strong vs {w} weak)")
            elif p2 in pairs_28:
                recommendations.append(f"SELL {p2}  ({s} strong vs {w} weak)")

    lines = [f"MMF Pair Recommendations (top {n_pairs}):"]
    for r in recommendations[:n_pairs]:
        lines.append(f"  • {r}")
    if not recommendations:
        lines.append("  ไม่พบ pair ที่ตรงกันใน 28 pairs")
    return "\n".join(lines)


def _execute(name: str, inputs: dict) -> str:
    if name == "calc_strength_from_values":
        return _calc_from_values(inputs["data"])
    if name == "calc_strength_from_closes":
        return _calc_from_closes(**{k: v for k, v in inputs.items()})
    if name == "recommend_mmf_pairs":
        return _recommend_mmf_pairs(inputs["strongest"], inputs["weakest"], inputs.get("n_pairs", 3))
    if name == "read_mmf_blueprint":
        for fname in ["MMF_MakeMoneyFarmed.md", "Dashboard_MSA.md"]:
            path = os.path.join(KB_PATH, "EAs", fname)
            if os.path.exists(path):
                return read_file(path)
        return "ไม่พบ MMF blueprint"
    if name == "read_dashboard_blueprint":
        path = os.path.join(KB_PATH, "EAs", "Dashboard_MSA.md")
        return read_file(path) if os.path.exists(path) else "ไม่พบ Dashboard_MSA.md"
    return f"Unknown tool: {name}"


def run_penny_agent(task: str) -> str:
    return agent_loop(client, MODEL, SYSTEM, TOOLS, task, _execute, label="Penny")
