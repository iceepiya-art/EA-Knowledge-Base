"""
BabyPips source for forex learning and trading process articles.

The public RSS endpoints sometimes reject simple requests, so this source uses
RSS first and falls back to scanning public BabyPips pages.
"""
from __future__ import annotations

from html.parser import HTMLParser
import re
from urllib.parse import urljoin, urlparse

import feedparser
import requests


CATEGORY = "Trading_Learn"
BASE_URL = "https://www.babypips.com"

RSS_FEEDS = [
    ("BabyPips Learn Forex", "https://www.babypips.com/learn/forex/feed"),
    ("BabyPips Trading", "https://www.babypips.com/trading/feed"),
]

INDEX_PAGES = [
    ("BabyPips Home", "https://www.babypips.com/"),
    ("BabyPips Trading", "https://www.babypips.com/trading"),
    ("BabyPips Learn Forex", "https://www.babypips.com/learn"),
]

HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36"
    )
}

KEYWORDS = {
    "xauusd": ["xau", "xau/usd", "gold", "precious metal", "bullion"],
    "technical": [
        "technical analysis",
        "chart art",
        "support",
        "resistance",
        "trend",
        "breakout",
        "pullback",
        "fibonacci",
        "moving average",
        "bollinger",
        "rsi",
        "candlestick",
    ],
    "system": [
        "trading system",
        "strategy",
        "backtest",
        "mechanical",
        "risk reward",
        "position size",
        "risk management",
        "journal",
        "process",
    ],
    "psychology": [
        "psychology",
        "discipline",
        "practice",
        "mindset",
        "worries",
        "expectations",
        "habits",
    ],
    "forex": [
        "forex",
        "currency",
        "eur/usd",
        "gbp/usd",
        "usd/jpy",
        "aud/usd",
        "jpy",
        "fed",
        "ecb",
        "boe",
        "nfp",
        "cpi",
    ],
}


class _LinkParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__()
        self.links: list[tuple[str, str]] = []
        self._href: str | None = None
        self._text: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        if tag != "a":
            return
        href = dict(attrs).get("href")
        if href:
            self._href = href
            self._text = []

    def handle_data(self, data: str) -> None:
        if self._href:
            self._text.append(data)

    def handle_endtag(self, tag: str) -> None:
        if tag != "a" or not self._href:
            return
        text = _clean_text(" ".join(self._text))
        if text:
            self.links.append((self._href, text))
        self._href = None
        self._text = []


def _clean_text(value: str) -> str:
    return re.sub(r"\s+", " ", value or "").strip()


def _score(text: str) -> tuple[int, str]:
    lowered = text.lower()
    matched_levels: list[str] = []
    score = 0

    for level, words in KEYWORDS.items():
        hits = sum(1 for word in words if word in lowered)
        if hits:
            matched_levels.append(level)
            score += hits * 8

    if "premium" in lowered:
        score -= 10
    if "quiz" in lowered or "glossary" in lowered:
        score -= 3

    level = matched_levels[0] if matched_levels else "general"
    return score, level


def _is_babypips_article(url: str) -> bool:
    parsed = urlparse(url)
    if parsed.netloc and parsed.netloc != "www.babypips.com":
        return False
    path = parsed.path.strip("/")
    if not path:
        return False
    allowed_roots = ("trading", "learn", "news")
    return path.startswith(allowed_roots)


def _item(title: str, summary: str, link: str, source_name: str) -> dict | None:
    title = _clean_text(title)
    summary = _clean_text(summary)
    link = urljoin(BASE_URL, link)

    if not title or not _is_babypips_article(link):
        return None

    score, level = _score(f"{title} {summary} {link}")
    if score <= 0:
        return None

    return {
        "title": title,
        "source": source_name,
        "category": CATEGORY,
        "level": level,
        "_score": score,
        "content": f"**{title}**\n\n{summary or 'BabyPips trading lesson or market article.'}",
        "url": link,
    }


def _fetch_rss() -> list[dict]:
    results: list[dict] = []
    for source_name, url in RSS_FEEDS:
        feed = feedparser.parse(url, request_headers=HEADERS)
        for entry in feed.entries[:15]:
            item = _item(
                entry.get("title", ""),
                entry.get("summary", "")[:800],
                entry.get("link", ""),
                source_name,
            )
            if item:
                results.append(item)
    return results


def _fetch_index_pages() -> list[dict]:
    results: list[dict] = []
    for source_name, url in INDEX_PAGES:
        try:
            response = requests.get(url, headers=HEADERS, timeout=20)
            response.raise_for_status()
            parser = _LinkParser()
            parser.feed(response.text)

            for href, title in parser.links:
                item = _item(title, "", href, source_name)
                if item:
                    results.append(item)
        except Exception as exc:
            print(f"[BabyPips] Skipped {source_name}: {exc}")
    return results


def fetch(days_back: int = 7) -> list[dict]:
    seen: set[str] = set()
    results: list[dict] = []

    try:
        candidates = _fetch_rss()
    except Exception as exc:
        print(f"[BabyPips] RSS fallback triggered: {exc}")
        candidates = []

    if not candidates:
        try:
            candidates = _fetch_index_pages()
        except Exception as exc:
            print(f"[BabyPips] Error: {exc}")
            candidates = []

    for item in sorted(candidates, key=lambda row: row.get("_score", 0), reverse=True):
        key = item.get("url") or item.get("title")
        if key in seen:
            continue
        seen.add(key)
        results.append(item)
        if len(results) >= 20:
            break

    print(f"[BabyPips] found {len(results)} items")
    return results
