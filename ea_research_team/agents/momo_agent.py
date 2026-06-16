"""
Momo — Market Regime Monitor
คำนวณ SC₁₀₀, β₁, RSI จาก XAUUSD M1 CSV → บอก Regime + แนะนำ EA
"""
import os
import csv
import math
import anthropic
from config import MODEL, KB_PATH, HISTDATA_PATH
from tools.file_tools import read_file, agent_loop

client = anthropic.Anthropic()

SYSTEM = """คุณคือ Momo ผู้เชี่ยวชาญด้าน Market Regime Detection

หน้าที่: คำนวณ SC₁₀₀, β₁, RSI จาก historical data แล้วบอกว่าตลาดอยู่ใน regime ไหน
และแนะนำว่าควรใช้ EA / strategy ไหน

Regime ตาม SC₁₀₀:
  < 0.22 + spike = CRASH    → Momentum only (ห้ามเปิด grid)
  < 0.25         = TRENDING  → EMA/Breakout (SMC_Universal, QField momentum mode)
  0.25–0.35      = WEAK      → RSI only / HOLD
  > 0.35         = REVERTING → RSI(20)+SMA(50) (QField mean-reversion mode)

β₁ (AR1 slope):
  > 0 = uptrend momentum
  < 0 = mean-reverting / downtrend

เครื่องมือที่มี:
1. list_data_files() — ดูว่ามี CSV data ปีไหนบ้าง
2. load_bars(filename) — โหลด OHLC bars จาก CSV
3. calc_regime(bars, n_sc100, n_beta) — คำนวณ SC₁₀₀, β₁, RSI แล้วบอก regime
4. read_regime_doc() — อ่าน 02_Regime_Detection.md เพื่อ reference"""

TOOLS = [
    {
        "name": "list_data_files",
        "description": "แสดงรายการ CSV data files ที่มีใน HISTDATA folder",
        "input_schema": {"type": "object", "properties": {}},
    },
    {
        "name": "load_bars",
        "description": "โหลด OHLC bars จากไฟล์ CSV (คืนค่า n bars ล่าสุด)",
        "input_schema": {
            "type": "object",
            "properties": {
                "filename": {"type": "string", "description": "ชื่อไฟล์ CSV เช่น 'DAT_MT_XAUUSD_M1_2025.csv'"},
                "n_bars":   {"type": "integer", "description": "จำนวน bars ล่าสุดที่ต้องการ (default 200)"},
            },
            "required": ["filename"],
        },
    },
    {
        "name": "calc_regime",
        "description": "คำนวณ SC₁₀₀, β₁, RSI(14) จาก close prices แล้ว classify regime",
        "input_schema": {
            "type": "object",
            "properties": {
                "closes":   {"type": "array", "items": {"type": "number"}, "description": "array of close prices (ต้องการอย่างน้อย 150 bars)"},
                "n_sc100":  {"type": "integer", "description": "จำนวน bars สำหรับ SC₁₀₀ (default 100)"},
                "n_beta":   {"type": "integer", "description": "จำนวน bars สำหรับ β₁ (default 50)"},
            },
            "required": ["closes"],
        },
    },
    {
        "name": "read_regime_doc",
        "description": "อ่าน 02_Regime_Detection.md เพื่อ reference สูตรและ threshold",
        "input_schema": {"type": "object", "properties": {}},
    },
]


def _list_data_files() -> str:
    if not os.path.exists(HISTDATA_PATH):
        return f"ไม่พบ HISTDATA folder: {HISTDATA_PATH}"
    files = sorted(f for f in os.listdir(HISTDATA_PATH) if f.endswith(".csv"))
    return "\n".join(files) if files else "ไม่พบ CSV files"


def _load_bars(filename: str, n_bars: int = 200) -> dict:
    path = os.path.join(HISTDATA_PATH, filename)
    if not os.path.exists(path):
        return {"error": f"ไม่พบไฟล์: {path}"}
    closes = []
    try:
        with open(path, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                # รองรับ format: "20100103 170100,1087.40,..." หรือ "date,open,high,low,close,..."
                parts = line.replace(";", ",").split(",")
                if len(parts) < 5:
                    continue
                try:
                    closes.append(float(parts[4]))
                except ValueError:
                    continue  # skip header
    except Exception as e:
        return {"error": str(e)}
    closes = closes[-n_bars:]
    return {"closes": closes, "count": len(closes), "last": closes[-1] if closes else None}


def _calc_regime(closes: list, n_sc100: int = 100, n_beta: int = 50) -> dict:
    if len(closes) < n_sc100 + 2:
        return {"error": f"ต้องการอย่างน้อย {n_sc100+2} bars (มี {len(closes)})"}

    # SC₁₀₀: sign-change rate ใน n_sc100 bars ล่าสุด
    recent = closes[-(n_sc100 + 1):]
    returns = [recent[i] - recent[i-1] for i in range(1, len(recent))]
    sign_changes = sum(1 for i in range(1, len(returns)) if returns[i] * returns[i-1] < 0)
    sc100 = sign_changes / (len(returns) - 1) if len(returns) > 1 else 0.5

    # β₁: AR(1) OLS slope ใน n_beta bars ล่าสุด
    beta_closes = closes[-(n_beta + 1):]
    beta_returns = [beta_closes[i] - beta_closes[i-1] for i in range(1, len(beta_closes))]
    x, y = beta_returns[:-1], beta_returns[1:]
    n = len(x)
    xm, ym = sum(x)/n, sum(y)/n
    cov = sum((x[i]-xm)*(y[i]-ym) for i in range(n))
    var = sum((x[i]-xm)**2 for i in range(n))
    beta1 = cov / var if var != 0 else 0.0

    # RSI(14)
    gains, losses = [], []
    for i in range(1, min(15, len(closes))):
        d = closes[-i] - closes[-i-1]
        (gains if d > 0 else losses).append(abs(d))
    avg_gain = sum(gains) / 14 if gains else 0
    avg_loss = sum(losses) / 14 if losses else 0.001
    rsi = 100 - (100 / (1 + avg_gain / avg_loss))

    # Regime
    if sc100 < 0.22:
        regime = "CRASH"
        advice = "ห้าม Grid! ใช้ Momentum only — QField CRASH mode"
    elif sc100 < 0.25:
        regime = "TRENDING"
        advice = "EMA/Breakout ดีที่สุด — SMC_Universal, QField momentum, Gold_Breakout"
    elif sc100 < 0.35:
        regime = "WEAK"
        advice = "RSI-only หรือ HOLD — ลด lot size, ระวัง false signal"
    else:
        regime = "REVERTING"
        advice = "Mean-reversion ดี — QField RSI+SMA mode, MMF CCI"

    direction = "UP (β₁>0)" if beta1 > 0 else "DOWN (β₁<0)"

    return {
        "SC100": round(sc100, 4),
        "beta1": round(beta1, 6),
        "RSI14": round(rsi, 2),
        "regime": regime,
        "direction": direction,
        "advice": advice,
        "bars_used": len(closes),
    }


def _execute(name: str, inputs: dict) -> str:
    if name == "list_data_files":
        return _list_data_files()
    if name == "load_bars":
        result = _load_bars(inputs["filename"], inputs.get("n_bars", 200))
        if "error" in result:
            return result["error"]
        return f"โหลดสำเร็จ: {result['count']} bars | Last close: {result['last']}\ncloses (ใช้ calc_regime ต่อได้): {result['closes'][-20:]}"
    if name == "calc_regime":
        result = _calc_regime(inputs["closes"], inputs.get("n_sc100", 100), inputs.get("n_beta", 50))
        if "error" in result:
            return result["error"]
        lines = [
            f"SC₁₀₀  = {result['SC100']}",
            f"β₁     = {result['beta1']}  ({result['direction']})",
            f"RSI(14)= {result['RSI14']}",
            f"Regime = {result['regime']}",
            f"Advice : {result['advice']}",
        ]
        return "\n".join(lines)
    if name == "read_regime_doc":
        return read_file(os.path.join(KB_PATH, "02_Regime_Detection.md"))
    return f"Unknown tool: {name}"


def run_momo_agent(task: str) -> str:
    return agent_loop(client, MODEL, SYSTEM, TOOLS, task, _execute, label="Momo")
