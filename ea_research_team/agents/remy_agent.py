"""
Remy — Python Quick Backtest Runner
รัน backtest บน XAUUSD M1 CSV โดยไม่ต้องเปิด MT5
"""
import os
import csv
import anthropic
from config import MODEL, KB_PATH, HISTDATA_PATH
from tools.file_tools import read_file, find_files, agent_loop

client = anthropic.Anthropic()

SYSTEM = """คุณคือ Remy ผู้เชี่ยวชาญ backtest และ strategy validation

หน้าที่:
1. โหลด XAUUSD M1 data จาก CSV (15 ปี: 2010–2026)
2. รัน quick backtest สำหรับ strategy ที่กำหนด
3. คำนวณ WR, PF, MaxDD, Expectancy, Sharpe
4. เปรียบเทียบ parameter sets
5. อ่าน existing backtest results จาก KB

Strategies ที่ implement ได้:
- SC₁₀₀ + RSI mean-reversion (QField style)
- EMA Cross + FVG breakout (SMC style)
- Custom entry/exit logic ที่ user กำหนด

หมายเหตุ: backtest นี้เป็น simplified version — ไม่รวม spread, slippage
ใช้สำหรับ quick validation ก่อนเปิด MT5"""

TOOLS = [
    {
        "name": "list_data_files",
        "description": "แสดงรายการ CSV data files ที่มี",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "run_sc100_backtest",
        "description": "รัน backtest แบบ SC₁₀₀ regime-adaptive (QField style)",
        "input_schema": {
            "type": "object",
            "properties": {
                "year":         {"type": "integer", "description": "ปีที่ต้องการ backtest เช่น 2024"},
                "rsi_period":   {"type": "integer", "description": "RSI period (default 20)"},
                "rsi_oversold": {"type": "number",  "description": "RSI oversold level (default 30)"},
                "rsi_overbought":{"type":"number",  "description": "RSI overbought level (default 70)"},
                "tp_pips":      {"type": "number",  "description": "Take profit pips (default 50)"},
                "sl_pips":      {"type": "number",  "description": "Stop loss pips (default 30)"},
                "sc100_thresh": {"type": "number",  "description": "SC₁₀₀ threshold สำหรับ REVERTING (default 0.35)"},
            },
            "required": ["year"],
        },
    },
    {
        "name": "read_existing_backtest",
        "description": "อ่าน backtest results จาก KB (CSV หรือ Python scripts)",
        "input_schema": {
            "type": "object",
            "properties": {
                "filename": {"type": "string", "description": "ชื่อไฟล์ เช่น 'trades_M1.csv', 'ea_fix20_trades.csv', 'summary_1yr.csv'"},
            },
            "required": ["filename"],
        },
    },
    {
        "name": "read_backtest_script",
        "description": "อ่าน Python backtest script ที่มีอยู่แล้วใน KB",
        "input_schema": {"type": "object", "properties": {}},
    },
]


def _load_year_bars(year: int) -> list[dict]:
    candidates = [
        os.path.join(HISTDATA_PATH, f"DAT_MT_XAUUSD_M1_{year}.csv"),
        os.path.join(HISTDATA_PATH, f"XAUUSD_M1_{year}.csv"),
    ]
    for path in candidates:
        if os.path.exists(path):
            bars = []
            with open(path, encoding="utf-8") as f:
                for line in f:
                    parts = line.strip().replace(";", ",").split(",")
                    if len(parts) < 5:
                        continue
                    try:
                        bars.append({
                            "dt": parts[0],
                            "open": float(parts[1]),
                            "high": float(parts[2]),
                            "low":  float(parts[3]),
                            "close": float(parts[4]),
                        })
                    except ValueError:
                        continue
            return bars
    return []


def _calc_sc100(closes: list[float], n: int = 100) -> float:
    if len(closes) < n + 1:
        return 0.5
    r = [closes[i] - closes[i-1] for i in range(len(closes)-n, len(closes))]
    changes = sum(1 for i in range(1, len(r)) if r[i] * r[i-1] < 0)
    return changes / (len(r) - 1)


def _calc_rsi(closes: list[float], period: int = 20) -> float:
    if len(closes) < period + 1:
        return 50.0
    gains, losses = [], []
    for i in range(-period, 0):
        d = closes[i] - closes[i-1]
        (gains if d > 0 else losses).append(abs(d))
    ag = sum(gains) / period if gains else 0
    al = sum(losses) / period if losses else 0.001
    return 100 - (100 / (1 + ag / al))


def _run_sc100_backtest(year: int, rsi_period: int = 20, rsi_oversold: float = 30,
                        rsi_overbought: float = 70, tp_pips: float = 50,
                        sl_pips: float = 30, sc100_thresh: float = 0.35) -> str:
    bars = _load_year_bars(year)
    if not bars:
        return f"ไม่พบ data สำหรับปี {year}\nลองใช้ list_data_files() ดูว่ามีอะไรบ้าง"

    closes = [b["close"] for b in bars]
    trades = []
    in_trade = None
    warmup = 150

    for i in range(warmup, len(closes)):
        close = closes[i]

        if in_trade:
            entry, direction, tp, sl = in_trade
            if direction == "BUY":
                if close >= tp:
                    trades.append({"result": "WIN", "pnl": tp_pips})
                    in_trade = None
                elif close <= sl:
                    trades.append({"result": "LOSS", "pnl": -sl_pips})
                    in_trade = None
            else:
                if close <= tp:
                    trades.append({"result": "WIN", "pnl": tp_pips})
                    in_trade = None
                elif close >= sl:
                    trades.append({"result": "LOSS", "pnl": -sl_pips})
                    in_trade = None
            continue

        sc = _calc_sc100(closes[:i+1])
        rsi = _calc_rsi(closes[:i+1], rsi_period)

        if sc > sc100_thresh:  # REVERTING regime
            if rsi < rsi_oversold:
                in_trade = (close, "BUY", close + tp_pips, close - sl_pips)
            elif rsi > rsi_overbought:
                in_trade = (close, "SELL", close - tp_pips, close + sl_pips)

    # Statistics
    if not trades:
        return f"ปี {year}: ไม่มี trade เลย (bars: {len(bars)}, SC₁₀₀ thresh: {sc100_thresh})"

    wins = [t for t in trades if t["result"] == "WIN"]
    losses = [t for t in trades if t["result"] == "LOSS"]
    total_profit = sum(t["pnl"] for t in wins)
    total_loss = abs(sum(t["pnl"] for t in losses))
    pf = total_profit / total_loss if total_loss > 0 else float("inf")
    wr = len(wins) / len(trades) * 100

    # MaxDD (simplified)
    equity = 0
    peak = 0
    max_dd = 0
    for t in trades:
        equity += t["pnl"]
        if equity > peak:
            peak = equity
        dd = peak - equity
        if dd > max_dd:
            max_dd = dd

    lines = [
        f"Backtest {year} | SC₁₀₀>{sc100_thresh} + RSI({rsi_period}) <{rsi_oversold}/{rsi_overbought}",
        f"TP={tp_pips}p | SL={sl_pips}p",
        f"---",
        f"Trades  : {len(trades)} (W:{len(wins)} L:{len(losses)})",
        f"Win Rate: {wr:.1f}%",
        f"PF      : {pf:.2f}",
        f"Net     : {total_profit - total_loss:.0f} pips",
        f"MaxDD   : {max_dd:.0f} pips",
        f"Bars    : {len(bars):,}",
    ]
    return "\n".join(lines)


def _execute(name: str, inputs: dict) -> str:
    if name == "list_data_files":
        if not os.path.exists(HISTDATA_PATH):
            return f"ไม่พบ HISTDATA folder"
        files = sorted(f for f in os.listdir(HISTDATA_PATH) if f.endswith(".csv"))
        return "\n".join(files) if files else "ไม่พบ CSV"
    if name == "run_sc100_backtest":
        return _run_sc100_backtest(
            inputs["year"],
            inputs.get("rsi_period", 20),
            inputs.get("rsi_oversold", 30),
            inputs.get("rsi_overbought", 70),
            inputs.get("tp_pips", 50),
            inputs.get("sl_pips", 30),
            inputs.get("sc100_thresh", 0.35),
        )
    if name == "read_existing_backtest":
        path = os.path.join(KB_PATH, inputs["filename"])
        return read_file(path)
    if name == "read_backtest_script":
        for fname in ["analyze_xauusd.py", "test_ea_fix20.py"]:
            path = os.path.join(KB_PATH, fname)
            if os.path.exists(path):
                return read_file(path, max_chars=10000)
        return "ไม่พบ backtest script"
    return f"Unknown tool: {name}"


def run_remy_agent(task: str) -> str:
    return agent_loop(client, MODEL, SYSTEM, TOOLS, task, _execute, label="Remy")
