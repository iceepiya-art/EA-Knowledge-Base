"""
Pre-filter — คัดกรองข่าวด้วย keyword scoring ก่อนส่ง Claude (ไม่เสีย token)
คะแนน 0-100 → ส่ง Claude เฉพาะที่ >= MIN_SCORE
"""

MIN_SCORE = 15  # ปรับได้ — ยิ่งสูงยิ่งเข้มงวด

# คำสำคัญสูง (+10) — ตรงประเด็นมาก
HIGH = [
    # trading systems
    "trading strategy", "backtest", "algorithmic trading", "quant", "quantitative",
    "regime", "signal", "entry", "exit", "stop loss", "take profit",
    # instruments
    "forex", "xauusd", "gold", "eurusd", "gbpusd", "usdjpy", "nasdaq", "sp500",
    "cryptocurrency", "bitcoin", "futures",
    # AI for trading
    "llm trading", "ai trading", "ml trading", "reinforcement learning trading",
    "time series forecast", "price prediction",
    # model releases (ที่น่าสนใจสำหรับ trading)
    "model release", "api pricing", "token cost", "benchmark score",
    "claude", "gpt-5", "gemini 3", "llama 4",
]

# คำสำคัญกลาง (+5) — เกี่ยวข้อง
MID = [
    "trading", "market", "portfolio", "volatility", "momentum", "trend",
    "indicator", "technical analysis", "fundamental", "macro",
    "interest rate", "fed", "inflation", "gdp", "employment",
    "machine learning", "deep learning", "neural network", "transformer",
    "agent", "automation", "python", "backtesting",
    "new model", "llm", "multimodal", "reasoning",
]

# คำสำคัญต่ำ (+2) — อาจเกี่ยวข้อง
LOW = [
    "finance", "investment", "stock", "economy", "risk",
    "ai", "data", "algorithm", "model", "prediction",
    "chart", "price", "return", "profit", "loss",
]

# คำที่ทำให้คะแนนลด (-10) — ไม่เกี่ยว
NEGATIVE = [
    "recipe", "cooking", "fashion", "celebrity", "gossip",
    "sports", "football", "basketball", "movie", "music",
    "health tips", "diet", "fitness", "travel", "tourism",
    "politics", "election", "war", "climate change",
]


def score(item: dict) -> int:
    """คืนคะแนน 0-100"""
    text = (item.get("title", "") + " " + item.get("content", "")[:500]).lower()
    s = 0
    for kw in HIGH:
        if kw in text:
            s += 10
    for kw in MID:
        if kw in text:
            s += 5
    for kw in LOW:
        if kw in text:
            s += 2
    for kw in NEGATIVE:
        if kw in text:
            s -= 10
    return max(0, min(s, 100))


def filter_items(items: list[dict], min_score: int = MIN_SCORE) -> tuple[list, list]:
    """
    แยก items เป็น passed (ส่ง Claude) กับ rejected (ตัดทิ้ง)
    คืน (passed, rejected)
    """
    passed, rejected = [], []
    for item in items:
        s = score(item)
        item["_score"] = s
        if s >= min_score:
            passed.append(item)
        else:
            rejected.append(item)
    return passed, rejected
