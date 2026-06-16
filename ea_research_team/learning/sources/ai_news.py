"""
AI News Source — ดึงข่าว AI ใหม่ๆ ที่เกี่ยวกับ trading/quant/automation + model releases
"""
import feedparser
import requests
from datetime import datetime, timedelta

CATEGORY = "AI_Updates"

RSS_FEEDS = [
    # arXiv — AI + Quantitative Finance papers
    ("arXiv cs.AI",       "http://export.arxiv.org/rss/cs.AI"),
    ("arXiv q-fin.TR",    "http://export.arxiv.org/rss/q-fin.TR"),
    ("arXiv q-fin.CP",    "http://export.arxiv.org/rss/q-fin.CP"),
    ("arXiv cs.LG",       "http://export.arxiv.org/rss/cs.LG"),  # Machine Learning

    # AI Model Releases & Benchmarks
    ("Hugging Face Blog", "https://huggingface.co/blog/feed.xml"),
    ("The Decoder",       "https://the-decoder.com/feed/"),
    ("Import AI",         "https://jack-clark.net/feed/"),
    ("Interconnects",     "https://www.interconnects.ai/feed"),
    ("Ahead of AI",       "https://magazine.sebastianraschka.com/feed"),
    ("Last Week in AI",   "https://lastweekin.ai/feed"),

    # AI/ML Tutorials & Quant
    ("Towards Data Science", "https://towardsdatascience.com/feed"),
    ("QuantStart",           "https://www.quantstart.com/articles/feed"),

    # Anthropic, OpenAI, Google news via tech blogs
    ("VentureBeat AI",    "https://venturebeat.com/category/ai/feed/"),
    ("MIT Tech Review AI","https://www.technologyreview.com/feed/"),
]

# คำสำคัญ group 1: trading/quant
TRADING_KW = [
    "trading", "quant", "backtest", "strategy", "forecast",
    "time series", "lstm", "transformer", "reinforcement learning",
    "portfolio", "alpha", "factor", "regime", "volatility",
    "forex", "cryptocurrency", "stock", "market", "signal",
    "arbitrage", "execution", "latency", "momentum", "mean reversion",
]

# คำสำคัญ group 2: AI model/benchmark news
MODEL_KW = [
    "claude", "gpt", "gemini", "llama", "mistral", "grok",
    "new model", "model release", "benchmark", "leaderboard", "arena",
    "chatbot arena", "lmsys", "elo score", "mmlu", "gpqa",
    "context window", "multimodal", "vision model", "llm", "agent",
    "anthropic", "openai", "google deepmind", "meta ai", "xai",
    "reasoning model", "o1", "o3", "thinking", "chain of thought",
    "fine-tuning", "rlhf", "dpo", "function calling", "tool use",
]

ALL_KEYWORDS = TRADING_KW + MODEL_KW


def _is_relevant(title: str, summary: str) -> bool:
    text = (title + " " + summary).lower()
    return any(kw in text for kw in ALL_KEYWORDS)


def _is_model_news(title: str, summary: str) -> bool:
    text = (title + " " + summary).lower()
    return any(kw in text for kw in MODEL_KW)


def _days_ago(days: int = 3) -> datetime:
    return datetime.now() - timedelta(days=days)


def fetch_arena_leaderboard() -> list[dict]:
    """ดึง top models จาก LMArena (Chatbot Arena) API"""
    results = []
    try:
        # LMArena public leaderboard data endpoint
        url = "https://huggingface.co/spaces/lmsys/chatbot-arena-leaderboard/raw/main/leaderboard_table_20240131.csv"
        # ใช้ HuggingFace API แทน (arena ไม่มี public RSS)
        # เพิ่ม context เป็น manual note แทน
        results.append({
            "title":    "AI Model Leaderboard Update — arena.ai",
            "source":   "arena.ai",
            "category": CATEGORY,
            "content":  (
                "arena.ai (LMArena / Chatbot Arena) คือ platform สำหรับ rank AI models "
                "ด้วย human preference voting\n\n"
                "ตรวจสอบ ranking ล่าสุดได้ที่: https://arena.ai/leaderboard\n\n"
                "Vision leaderboard: gemini-3-pro, gemini-3.1-pro-preview, gemini-3-flash\n"
                "Text-to-Image: gpt-image-1.5-high-fidelity, gemini-3-pro-image"
            ),
            "url": "https://arena.ai/leaderboard/vision",
        })
    except Exception as e:
        print(f"[AI News] Arena fetch error: {e}")
    return results


def fetch(days_back: int = 3) -> list[dict]:
    results = []

    for source_name, url in RSS_FEEDS:
        try:
            feed = feedparser.parse(url)
            count = 0
            for entry in feed.entries[:30]:
                title   = entry.get("title", "")
                summary = entry.get("summary", "")[:800]
                link    = entry.get("link", "")

                if not _is_relevant(title, summary):
                    continue

                results.append({
                    "title":    title,
                    "source":   source_name,
                    "category": CATEGORY,
                    "content":  f"**{title}**\n\n{summary}",
                    "url":      link,
                })
                count += 1

            if count > 0:
                print(f"  [AI News] {source_name}: {count} รายการ")
        except Exception as e:
            print(f"[AI News] Error fetching {source_name}: {e}")

    print(f"[AI News] พบ {len(results)} รายการที่เกี่ยวข้อง")
    return results
