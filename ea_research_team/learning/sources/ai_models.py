"""
AI Models Tracker — ติดตาม model releases, benchmark scores, API pricing
Sources: Artificial Analysis, OpenRouter, tech blogs ที่ cover model comparisons
"""
import feedparser
import requests
import json
from datetime import datetime, timedelta

CATEGORY = "AI_Updates"

# RSS feeds ที่ cover model benchmarks + pricing
RSS_FEEDS = [
    ("Simon Willison",        "https://simonwillison.net/atom/everything/"),
    ("Artificial Analysis Blog", "https://artificialanalysis.ai/blog/rss.xml"),
    ("OpenRouter Blog",       "https://openrouter.ai/blog/rss.xml"),
    ("LMSYS Blog",            "https://lmsys.org/blog/rss.xml"),
    ("Zeta Alpha AI",         "https://www.zeta-alpha.com/post/feed"),
    ("One Useful Thing",      "https://www.oneusefulthing.org/feed"),  # Ethan Mollick on AI
]

# keywords เฉพาะ model comparison / pricing
MODEL_BENCH_KW = [
    # benchmark names
    "intelligence index", "artificial analysis", "elo score", "arena score",
    "mmlu", "gpqa", "humaneval", "swe-bench", "aime", "math benchmark",
    "leaderboard", "benchmark", "evaluation", "rank", "score",
    # model names (May 2026)
    "claude opus", "claude sonnet", "claude haiku",
    "gemini 3", "gemini 2.5", "gpt-5", "gpt-4o",
    "llama 4", "llama 3", "mistral", "grok", "kimi", "glm-5",
    "minimax", "qwen", "deepseek", "phi-4",
    # pricing keywords
    "api pricing", "price per token", "cost per million", "token cost",
    "input token", "output token", "api cost", "cheaper model",
    "price drop", "free tier", "rate limit",
    # capability keywords
    "context window", "multimodal", "vision", "reasoning", "thinking",
    "new model", "model release", "model update", "model launch",
]


def _is_relevant(title: str, summary: str) -> bool:
    text = (title + " " + summary).lower()
    return any(kw in text for kw in MODEL_BENCH_KW)


def fetch_openrouter_models() -> list[dict]:
    """ดึง model list + pricing จาก OpenRouter API (ไม่ต้อง API key)"""
    results = []
    try:
        resp = requests.get(
            "https://openrouter.ai/api/v1/models",
            timeout=10,
            headers={"User-Agent": "Mozilla/5.0"}
        )
        if resp.status_code != 200:
            return results

        data = resp.json()
        models = data.get("data", [])

        # filter เฉพาะ top models ที่รู้จัก
        TOP_PROVIDERS = ["anthropic", "openai", "google", "meta-llama", "mistralai",
                         "x-ai", "deepseek", "qwen", "minimax", "moonshot"]

        interesting = []
        for m in models:
            mid = m.get("id", "").lower()
            if any(p in mid for p in TOP_PROVIDERS):
                pricing = m.get("pricing", {})
                prompt_price  = float(pricing.get("prompt", 0)) * 1_000_000
                completion_price = float(pricing.get("completion", 0)) * 1_000_000
                interesting.append({
                    "id":          m.get("id", ""),
                    "name":        m.get("name", ""),
                    "context":     m.get("context_length", 0),
                    "input_price": round(prompt_price, 4),
                    "output_price": round(completion_price, 4),
                })

        if not interesting:
            return results

        # สร้าง summary table
        interesting.sort(key=lambda x: x["input_price"])
        lines = ["| Model | Context | Input $/1M | Output $/1M |",
                 "|-------|---------|------------|-------------|"]
        for m in interesting[:20]:
            ctx = f"{m['context']//1000}K" if m['context'] else "-"
            lines.append(f"| {m['name'][:35]} | {ctx} | ${m['input_price']} | ${m['output_price']} |")

        today = datetime.now().strftime("%Y-%m-%d")
        content = f"## AI Model Pricing (OpenRouter) — {today}\n\n" + "\n".join(lines)

        results.append({
            "title":    f"AI Model Pricing Update — OpenRouter {today}",
            "source":   "OpenRouter API",
            "category": CATEGORY,
            "content":  content,
            "url":      "https://openrouter.ai/models",
        })
        print(f"  [AI Models] OpenRouter: {len(interesting)} models fetched")

    except Exception as e:
        print(f"[AI Models] OpenRouter error: {e}")

    return results


def fetch_rss_model_news() -> list[dict]:
    """ดึงข่าว model benchmarks จาก RSS feeds"""
    results = []
    for source_name, url in RSS_FEEDS:
        try:
            feed = feedparser.parse(url)
            count = 0
            for entry in feed.entries[:20]:
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
                print(f"  [AI Models] {source_name}: {count} รายการ")
        except Exception as e:
            print(f"[AI Models] Error {source_name}: {e}")

    return results


def fetch(days_back: int = 7) -> list[dict]:
    results = []
    results.extend(fetch_openrouter_models())   # pricing snapshot
    results.extend(fetch_rss_model_news())       # benchmark/release news
    print(f"[AI Models] รวม {len(results)} รายการ")
    return results
