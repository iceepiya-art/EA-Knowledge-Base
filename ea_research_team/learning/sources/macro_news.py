"""
Macro News Source — ดึงข่าวเศรษฐกิจที่กระทบตลาด Forex/Gold/Crypto
"""
import requests
from datetime import datetime, timedelta

CATEGORY = "Macro_News"

# ForexFactory calendar API (unofficial)
FF_URL = "https://nfs.faireconomy.media/ff_calendar_thisweek.json"

HIGH_IMPACT_EVENTS = [
    "Non-Farm", "NFP", "CPI", "Fed", "FOMC", "Interest Rate",
    "GDP", "Unemployment", "Retail Sales", "PMI", "PPI",
    "Inflation", "Jackson Hole", "ECB", "BOJ", "BOE",
    "Treasury", "Debt", "Trade Balance", "ISM",
]

CURRENCIES = ["USD", "EUR", "GBP", "JPY", "AUD", "CAD", "CHF", "XAU", "BTC"]


def _is_high_impact(event: dict) -> bool:
    title    = event.get("title", "")
    impact   = event.get("impact", "").lower()
    currency = event.get("country", "")
    if impact not in ("high", "medium"):
        return False
    if currency not in CURRENCIES:
        return False
    return True


def fetch_forexfactory() -> list[dict]:
    results = []
    try:
        r = requests.get(FF_URL, timeout=10,
                         headers={"User-Agent": "Mozilla/5.0"})
        events = r.json()
        for ev in events:
            if not _is_high_impact(ev):
                continue
            date     = ev.get("date", "")
            title    = ev.get("title", "")
            currency = ev.get("country", "")
            impact   = ev.get("impact", "")
            forecast = ev.get("forecast", "-")
            previous = ev.get("previous", "-")

            content = (
                f"**{title}** ({currency})\n"
                f"- Date: {date}\n"
                f"- Impact: {impact.upper()}\n"
                f"- Forecast: {forecast} | Previous: {previous}"
            )
            results.append({
                "title":    f"{currency} {title}",
                "source":   "ForexFactory",
                "category": CATEGORY,
                "content":  content,
                "url":      "https://www.forexfactory.com/calendar",
            })
    except Exception as e:
        print(f"[Macro News] ForexFactory error: {e}")

    return results


def fetch_rss_macro() -> list[dict]:
    import feedparser
    results = []
    feeds = [
        ("Reuters Business", "https://feeds.reuters.com/reuters/businessNews"),
        ("FXStreet",         "https://www.fxstreet.com/rss/news"),
    ]
    keywords = ["fed", "rate", "inflation", "gdp", "employment",
                "dollar", "gold", "crypto", "bitcoin", "fomc", "ecb"]

    for name, url in feeds:
        try:
            feed = feedparser.parse(url)
            for entry in feed.entries[:15]:
                title   = entry.get("title", "")
                summary = entry.get("summary", "")[:600]
                link    = entry.get("link", "")
                text    = (title + summary).lower()
                if not any(kw in text for kw in keywords):
                    continue
                results.append({
                    "title":    title,
                    "source":   name,
                    "category": CATEGORY,
                    "content":  f"**{title}**\n\n{summary}",
                    "url":      link,
                })
        except Exception as e:
            print(f"[Macro News] RSS error {name}: {e}")

    return results


def fetch(days_back: int = 3) -> list[dict]:
    results = []
    results.extend(fetch_forexfactory())
    results.extend(fetch_rss_macro())
    print(f"[Macro News] พบ {len(results)} รายการ")
    return results
