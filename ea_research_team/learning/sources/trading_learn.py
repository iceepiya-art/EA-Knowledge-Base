"""
Trading Learn Source — ดึงความรู้ระบบเทรดและ indicators
"""
import feedparser

CATEGORY = "Trading_Learn"

RSS_FEEDS = [
    # ── MQL5 (แหล่งหลัก) ──────────────────────────────────────
    ("MQL5 Articles",       "https://www.mql5.com/en/articles/rss"),
    ("MQL5 Code Base",      "https://www.mql5.com/en/code/rss"),

    # ── Quant / Systematic Trading ────────────────────────────
    ("Quantocracy",         "https://quantocracy.com/feed/"),          # รวม quant blogs ทั้งหมด
    ("Alpha Architect",     "https://alphaarchitect.com/feed/"),       # factor investing research
    ("Ernest Chan Blog",    "https://epchan.blogspot.com/feeds/posts/default"),  # algo trading expert
    ("CSS Analytics",       "https://cssanalytics.wordpress.com/feed/"),
    ("Price Action Lab",    "https://www.priceactionlab.com/Blog/feed/"),
    ("QuantInsti Blog",     "https://blog.quantinsti.com/feed/"),
    ("AlgoTrading101",      "https://algotrading101.com/learn/feed/"),

    # ── Technical Analysis ────────────────────────────────────
    ("TradingView Blog",    "https://www.tradingview.com/blog/en/feed/"),
    ("StockCharts Blog",    "https://stockcharts.com/articles/feed"),

    # ── Forex / Gold / Commodity ──────────────────────────────
    ("DailyFX",             "https://www.dailyfx.com/feeds/all"),
    ("Kitco Gold News",     "https://www.kitco.com/rss/KitcoNewsLatest.xml"),
    ("Investopedia",        "https://www.investopedia.com/feedbuilder/feed/getfeed/?feedName=rss_headline"),
]

# ระดับ indicator / system
LEVEL_KEYWORDS = {
    "basic":    ["moving average", "rsi", "macd", "bollinger", "stochastic",
                 "ema", "sma", "support", "resistance", "trend"],
    "mid":      ["atr", "vwap", "ichimoku", "fibonacci", "divergence",
                 "breakout", "momentum", "oscillator", "pivot", "cci"],
    "advanced": ["market profile", "order flow", "volume profile", "delta",
                 "wyckoff", "smc", "smart money", "liquidity", "imbalance",
                 "fair value gap", "fvg", "ob", "order block", "bos", "choch"],
    "system":   ["strategy", "backtest", "system", "algorithm", "quantitative",
                 "edge", "win rate", "risk reward", "drawdown", "sharpe",
                 "factor", "alpha", "momentum factor", "mean reversion",
                 "carry trade", "trend following", "systematic"],
    "mql5":     ["mql5", "mql4", "expert advisor", "indicator", "script",
                 "metatrader", "mt5", "mt4", "ea ", "trading robot",
                 "custom indicator", "icustom", "oncalculate", "ontick",
                 "position", "order", "trade", "chartobject"],
    "gold":     ["gold", "xauusd", "xau", "precious metal", "bullion",
                 "silver", "xagusd", "commodity", "oil", "crude"],
    "forex":    ["forex", "currency", "eurusd", "gbpusd", "usdjpy",
                 "dollar", "euro", "yen", "pound", "pip", "spread",
                 "central bank", "interest rate", "fed", "ecb", "boj"],
}


def _get_level(text: str) -> str:
    text = text.lower()
    for level in ["mql5", "advanced", "system", "mid", "gold", "forex", "basic"]:
        if any(kw in text for kw in LEVEL_KEYWORDS[level]):
            return level
    return "general"


def _is_relevant(title: str, summary: str, source: str) -> bool:
    text = (title + " " + summary).lower()
    # MQL5 articles ทุกอันเกี่ยวข้องกับเราเสมอ
    if "mql5" in source.lower():
        return True
    all_kw = [kw for kws in LEVEL_KEYWORDS.values() for kw in kws]
    return any(kw in text for kw in all_kw)


def fetch(days_back: int = 7) -> list[dict]:
    results = []

    for source_name, url in RSS_FEEDS:
        try:
            feed = feedparser.parse(url)
            for entry in feed.entries[:15]:
                title   = entry.get("title", "")
                summary = entry.get("summary", "")[:800]
                link    = entry.get("link", "")

                if not _is_relevant(title, summary, source_name):
                    continue

                level = _get_level(title + " " + summary)
                results.append({
                    "title":    title,
                    "source":   source_name,
                    "category": CATEGORY,
                    "level":    level,
                    "content":  f"**{title}**\n\n{summary}",
                    "url":      link,
                })
        except Exception as e:
            print(f"[Trading Learn] Error {source_name}: {e}")

    print(f"[Trading Learn] พบ {len(results)} รายการ")
    return results
