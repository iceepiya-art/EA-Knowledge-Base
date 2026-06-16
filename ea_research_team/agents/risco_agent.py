"""
Risco — Risk & FTMO Guard
ตรวจสอบ lot size, DD limit, FTMO compliance ก่อน deploy EA
"""
import os
import csv
import anthropic
from config import MODEL, KB_PATH
from tools.file_tools import read_file, agent_loop

client = anthropic.Anthropic()

SYSTEM = """คุณคือ Risco ผู้เชี่ยวชาญ Risk Management และ FTMO Compliance

หน้าที่:
1. คำนวณ lot size ที่เหมาะสมจาก balance + risk% + SL
2. ตรวจสอบ drawdown ปัจจุบัน vs limit
3. เช็ค FTMO rules (daily loss limit 5%, total loss limit 10%)
4. แนะนำ position sizing สำหรับแต่ละ EA strategy
5. เตือนเมื่อ risk สูงเกินไป

FTMO Standard Rules:
- Daily Loss Limit: 5% of starting balance
- Max Total Loss: 10% of starting balance
- Profit Target: 10% (Challenge), 5% (Verification)
- Lot sizing: ≤ 0.5% risk per trade = conservative | ≤ 1% = normal | ≤ 2% = aggressive

สูตร lot size:
  lot = (balance × risk%) / (sl_pips × pip_value)
  XAUUSD pip_value = $1 per 0.01 lot per pip (100 pips = $1 per 0.01)"""

TOOLS = [
    {
        "name": "calc_lot_size",
        "description": "คำนวณ lot size จาก balance, risk%, และ SL",
        "input_schema": {
            "type": "object",
            "properties": {
                "balance":    {"type": "number", "description": "Account balance (USD)"},
                "risk_pct":   {"type": "number", "description": "Risk per trade เป็น % เช่น 1.0 = 1%"},
                "sl_pips":    {"type": "number", "description": "Stop loss ขนาด (pips หรือ points)"},
                "symbol":     {"type": "string", "description": "Symbol เช่น 'XAUUSD', 'EURUSD' (default XAUUSD)"},
                "pip_value":  {"type": "number", "description": "Pip value ต่อ 0.01 lot (default XAUUSD=1.0)"},
            },
            "required": ["balance", "risk_pct", "sl_pips"],
        },
    },
    {
        "name": "check_dd_status",
        "description": "ตรวจสอบ drawdown ปัจจุบันและแจ้งว่าปลอดภัยหรือไม่",
        "input_schema": {
            "type": "object",
            "properties": {
                "starting_balance": {"type": "number", "description": "Balance เริ่มต้นของ challenge/account"},
                "current_balance":  {"type": "number", "description": "Balance ปัจจุบัน"},
                "daily_start":      {"type": "number", "description": "Balance ต้นวัน (สำหรับเช็ค daily limit)"},
                "account_type":     {"type": "string", "description": "'ftmo' | 'live' | 'demo' (default live)"},
            },
            "required": ["starting_balance", "current_balance"],
        },
    },
    {
        "name": "read_ftmo_configs",
        "description": "อ่าน FTMO configuration จาก KB",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "read_risk_management_doc",
        "description": "อ่าน 04_Risk_Management.md เพื่อ reference",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "read_trade_log",
        "description": "อ่าน trade log CSV เพื่อคำนวณ historical DD",
        "input_schema": {
            "type": "object",
            "properties": {
                "filepath": {"type": "string", "description": "absolute path ของ trade log CSV"},
            },
            "required": ["filepath"],
        },
    },
]

PIP_VALUES = {
    "XAUUSD": 1.0,   # $1 per 0.01 lot per pip (1 pip = $0.10 per micro)
    "EURUSD": 1.0,
    "GBPUSD": 1.0,
    "USDJPY": 0.91,  # approximate
}


def _calc_lot_size(balance: float, risk_pct: float, sl_pips: float,
                   symbol: str = "XAUUSD", pip_value: float = None) -> str:
    pv = pip_value or PIP_VALUES.get(symbol.upper(), 1.0)
    risk_amount = balance * (risk_pct / 100)
    # lot = risk_amount / (sl_pips * pip_value_per_standard_lot)
    # For XAUUSD: 1 standard lot = $10/pip, 0.01 lot = $0.10/pip
    # pip_value here is per 0.01 lot, so per standard lot = pip_value * 100
    lot = risk_amount / (sl_pips * pv * 100)
    lot_rounded = round(lot, 2)

    lines = [
        f"Balance  : ${balance:,.2f}",
        f"Risk     : {risk_pct}% = ${risk_amount:,.2f}",
        f"SL       : {sl_pips} pips",
        f"Symbol   : {symbol}",
        f"Lot Size : {lot_rounded} (raw: {lot:.4f})",
        f"",
        f"Risk check:",
        f"  Conservative (0.5%): {round(balance*0.005/(sl_pips*pv*100),2)} lots",
        f"  Normal      (1.0%): {round(balance*0.01/(sl_pips*pv*100),2)} lots",
        f"  Aggressive  (2.0%): {round(balance*0.02/(sl_pips*pv*100),2)} lots",
    ]
    return "\n".join(lines)


def _check_dd_status(starting: float, current: float, daily_start: float = None,
                     account_type: str = "live") -> str:
    total_dd = (starting - current) / starting * 100
    total_dd_usd = starting - current

    lines = [f"Starting Balance : ${starting:,.2f}", f"Current Balance  : ${current:,.2f}",
             f"Total DD         : {total_dd:.2f}% (${total_dd_usd:,.2f})"]

    if account_type == "ftmo":
        daily_limit, total_limit = 5.0, 10.0
        total_remaining = total_limit - total_dd
        lines.append(f"\nFTMO Status:")
        lines.append(f"  Total limit   : {total_limit}% | Used: {total_dd:.2f}% | Remaining: {total_remaining:.2f}%")
        if total_remaining < 2:
            lines.append("  STATUS: DANGER - ใกล้ blow account!")
        elif total_remaining < 4:
            lines.append("  STATUS: WARNING - ลด lot size ทันที")
        else:
            lines.append("  STATUS: SAFE")

        if daily_start:
            daily_dd = (daily_start - current) / starting * 100
            daily_remaining = daily_limit - daily_dd
            lines.append(f"  Daily DD      : {daily_dd:.2f}% | Remaining: {daily_remaining:.2f}%")
            if daily_remaining < 1:
                lines.append("  DAILY: STOP TRADING TODAY!")
    else:
        status = "SAFE" if total_dd < 10 else ("WARNING" if total_dd < 20 else "DANGER")
        lines.append(f"STATUS: {status}")

    return "\n".join(lines)


def _read_ftmo_configs() -> str:
    path = os.path.join(KB_PATH, "ftmo_configs.csv")
    if os.path.exists(path):
        return read_file(path)
    return "ไม่พบ ftmo_configs.csv ใน KB"


def _read_trade_log(filepath: str) -> str:
    if not os.path.exists(filepath):
        return f"ไม่พบไฟล์: {filepath}"
    try:
        rows = []
        with open(filepath, encoding="utf-8") as f:
            reader = csv.DictReader(f)
            for row in reader:
                rows.append(row)
        if not rows:
            return "ไฟล์ว่างเปล่า"
        # สรุปง่ายๆ
        total = len(rows)
        keys = list(rows[0].keys())
        return f"Trade log: {total} rows\nColumns: {keys}\nFirst row: {rows[0]}\nLast row: {rows[-1]}"
    except Exception as e:
        return f"Error: {e}"


def _execute(name: str, inputs: dict) -> str:
    if name == "calc_lot_size":
        return _calc_lot_size(inputs["balance"], inputs["risk_pct"], inputs["sl_pips"],
                              inputs.get("symbol", "XAUUSD"), inputs.get("pip_value"))
    if name == "check_dd_status":
        return _check_dd_status(inputs["starting_balance"], inputs["current_balance"],
                                inputs.get("daily_start"), inputs.get("account_type", "live"))
    if name == "read_ftmo_configs":
        return _read_ftmo_configs()
    if name == "read_risk_management_doc":
        return read_file(os.path.join(KB_PATH, "04_Risk_Management.md"))
    if name == "read_trade_log":
        return _read_trade_log(inputs["filepath"])
    return f"Unknown tool: {name}"


def run_risco_agent(task: str) -> str:
    return agent_loop(client, MODEL, SYSTEM, TOOLS, task, _execute, label="Risco")
