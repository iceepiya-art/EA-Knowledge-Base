"""
Market Data Source — ดึงข้อมูล volatility + market conditions
Sources:
  - Yahoo Finance API: OHLC data → คำนวณ ATR volatility (ฟรี ไม่ต้อง auth)
  - Myfxbook: community sentiment
  - CME / HistData: reference links
"""
import requests
from datetime import datetime

CATEGORY = "Macro_News"

# Yahoo Finance symbols → pip multiplier
PAIRS = {
    "EURUSD=X": ("EURUSD", 10000),
    "GBPUSD=X": ("GBPUSD", 10000),
    "USDJPY=X": ("USDJPY", 100),
    "USDCHF=X": ("USDCHF", 10000),
    "AUDUSD=X": ("AUDUSD", 10000),
    "USDCAD=X": ("USDCAD", 10000),
    "GC=F":     ("XAUUSD", 1),     # Gold futures (USD)
}


def fetch_yahoo_volatility() -> dict:
    """ดึง OHLC จาก Yahoo Finance → คำนวณ Average Daily Range (pips/points)"""
    result = {}
    headers = {"User-Agent": "Mozilla/5.0"}

    for symbol, (pair, multiplier) in PAIRS.items():
        try:
            url = (f"https://query1.finance.yahoo.com/v8/finance/chart/{symbol}"
                   f"?interval=1d&range=10d")
            resp = requests.get(url, headers=headers, timeout=10)
            if resp.status_code != 200:
                continue

            data   = resp.json()
            chart  = data["chart"]["result"][0]
            highs  = chart["indicators"]["quote"][0].get("high", [])
            lows   = chart["indicators"]["quote"][0].get("low", [])
            closes = chart["indicators"]["quote"][0].get("close", [])

            if not highs or not lows:
                continue

            # คำนวณ True Range แล้วหาค่าเฉลี่ย
            trs = []
            for i in range(1, len(highs)):
                if highs[i] and lows[i] and closes[i-1]:
                    tr = max(
                        highs[i] - lows[i],
                        abs(highs[i] - closes[i-1]),
                        abs(lows[i] - closes[i-1])
                    )
                    trs.append(tr * multiplier)

            if trs:
                atr = sum(trs) / len(trs)
                last_close = closes[-1]
                unit = "pips" if multiplier > 1 else "USD"
                result[pair] = {
                    "atr":   round(atr, 1),
                    "unit":  unit,
                    "close": round(last_close, 5) if multiplier > 1 else round(last_close, 2),
                }
        except Exception as e:
            print(f"  [Market Data] {pair} error: {e}")

    return result


def fetch_myfxbook_outlook() -> dict | None:
    """ดึง community sentiment (long/short %) จาก Myfxbook API"""
    try:
        resp = requests.get(
            "https://www.myfxbook.com/api/get-community-outlook.json",
            timeout=10,
            headers={"User-Agent": "Mozilla/5.0"}
        )
        if resp.status_code != 200:
            return None

        data = resp.json()
        symbols = data.get("symbols", [])
        result = {}
        for s in symbols:
            name = s.get("name", "").upper().replace("/", "")
            if name in PAIRS:
                result[name] = {
                    "long_pct":  s.get("longsPercentage", 0),
                    "short_pct": s.get("shortsPercentage", 0),
                    "long_vol":  s.get("longVolume", 0),
                    "short_vol": s.get("shortVolume", 0),
                }
        return result if result else None

    except Exception as e:
        print(f"[Market Data] Myfxbook outlook error: {e}")
        return None


def build_market_note(volatility: dict, sentiment: dict | None) -> str:
    today = datetime.now().strftime("%Y-%m-%d")
    lines = [
        f"## Market Conditions — {today}",
        f"> Source: Yahoo Finance (ATR 10d) + Myfxbook sentiment\n",
    ]

    # Volatility table
    if volatility:
        lines += [
            "### 📊 Average Daily Range (ATR 10 วัน)",
            "| Pair | ATR | Last Close | ประเมิน |",
            "|------|-----|------------|---------|",
        ]
        for pair, v in volatility.items():
            atr  = v["atr"]
            unit = v["unit"]
            close = v["close"]
            if pair == "XAUUSD":
                level = "สูงมาก" if atr > 30 else ("สูง" if atr > 20 else "ปกติ")
            else:
                level = "สูงมาก" if atr > 100 else ("สูง" if atr > 70 else "ปกติ")
            lines.append(f"| {pair} | {atr:.1f} {unit} | {close} | {level} |")
        lines.append("")

    # Sentiment table
    if sentiment:
        lines += [
            "### 🧭 Community Sentiment (Myfxbook)",
            "| Pair | Long % | Short % | Bias |",
            "|------|--------|---------|------|",
        ]
        for pair, s in sentiment.items():
            lp = s["long_pct"]
            sp = s["short_pct"]
            bias = "Bullish" if lp > 60 else ("Bearish" if sp > 60 else "Neutral")
            lines.append(f"| {pair} | {lp:.0f}% | {sp:.0f}% | {bias} |")
        lines.append("")

    lines += [
        "### 📐 CME Expected Range (Options-Based)",
        "> https://www.cmegroup.com/tools-information/quikstrike/vol2vol-expected-range.html",
        "> ใช้สำหรับ: ตั้ง TP/SL ให้สอดคล้องกับที่ options market คาดการณ์ไว้",
        "",
        "### 📥 Historical Data (HistData)",
        "> https://www.histdata.com/download-free-forex-data/",
        "> Formats: M1, M5, M15, M30, H1 — ใช้สำหรับ backtest EA ใน MT5",
    ]

    return "\n".join(lines)


def fetch(days_back: int = 7) -> list[dict]:
    today = datetime.now().strftime("%Y-%m-%d")
    results = []

    print("  [Market Data] ดึง volatility จาก Yahoo Finance...")
    volatility = fetch_yahoo_volatility()

    print("  [Market Data] ดึง sentiment จาก Myfxbook...")
    sentiment  = fetch_myfxbook_outlook()

    content = build_market_note(volatility, sentiment)
    has_data = bool(volatility)

    results.append({
        "title":    f"Market Volatility & Sentiment — {today}",
        "source":   "Myfxbook + CME + HistData",
        "category": CATEGORY,
        "content":  content,
        "url":      "https://www.myfxbook.com/forex-market/volatility",
    })

    status = "live data" if has_data else "reference links"
    print(f"[Market Data] สร้าง market note แล้ว ({status})")
    return results
