"""
NotebookLM Source — query ความรู้จาก NotebookLM notebooks เข้า Learning System
ใช้ Python API (async) แทน CLI เพื่อรวมอยู่ใน pipeline
"""
import sys
sys.stdout.reconfigure(encoding="utf-8")

import asyncio
from datetime import datetime

CATEGORY = "Trading_Learn"

# Notebooks ที่ต้องการ query พร้อมคำถามเฉพาะทาง
# Format: (notebook_id, notebook_name, question, category)
NOTEBOOK_QUERIES = [
    # ── XAUUSD / Gold ─────────────────────────────────────────────────────
    (
        "077b6ec2-bd6f-4095-9a51-f1828772df23",
        "Gold Spot Liquidity Analysis",
        "Summarize the key BSL/SSL liquidity sweep setups and entry conditions for XAUUSD. List specific price action patterns.",
        "Trading_Learn",
    ),
    (
        "5f86bd79-234c-465b-988c-8ea75d75c14b",
        "XAUUSD W&M Reversal Patterns",
        "Explain the W and M reversal pattern rules: entry trigger, stop loss placement, and target. Give concrete examples.",
        "Trading_Learn",
    ),
    (
        "556a576f-7bb6-440e-b95b-7a6e3cf02763",
        "Trading Strategy Handbook XAUUSD",
        "What are the top 3 XAUUSD trading strategies with highest win rate? Include specific entry/exit rules.",
        "Trading_Learn",
    ),
    (
        "b2761bc1-6f89-4087-8bb0-2d4fd6c12761",
        "XAUUSD Silom 6 Dashboard",
        "What are the key signals and dashboard indicators used for XAUUSD entries? Summarize the logic.",
        "Trading_Learn",
    ),
    (
        "66e0190e-6468-4460-8ed0-c8f5d2aaa44b",
        "EZB Gold Trading Manual 2025",
        "Summarize the EZB gold trading rules: trend identification, entry setup, risk management.",
        "Trading_Learn",
    ),

    # ── SMC / Smart Money ─────────────────────────────────────────────────
    (
        "45a8a1ec-96ca-4b19-9263-c412cbbc4f54",
        "Alchemist Trading Order Books",
        "What are the key order book and market sentiment signals for trade entries? List actionable rules.",
        "Trading_Learn",
    ),
    (
        "099fecb8-f1df-47d3-9cdc-cf95e653c957",
        "PO3 Entry Model",
        "Explain the Power of Three (PO3) entry model: accumulation, manipulation, distribution phases. How to trade it?",
        "Trading_Learn",
    ),

    # ── EA / Algorithmic ──────────────────────────────────────────────────
    (
        "1197d133-aab1-42cf-8739-3079d3662ccd",
        "Farmed Hedge Currency Strength v3.40",
        "Summarize the currency strength scoring method, entry conditions, and grid/hedge rules in this strategy.",
        "Trading_Learn",
    ),
    (
        "eab60a9a-87cc-46ab-a029-d5570619eaf9",
        "DonchianGrid Pro V3",
        "How does the DonchianGrid percentage-based dynamic system work? Entry rules, lot sizing, and exit conditions.",
        "Trading_Learn",
    ),
    (
        "8fdba311-6929-4bef-8fbf-9f07cf5cce6b",
        "AI Trading Bot Dev & Research",
        "What AI/ML techniques are discussed for trading bot development? Summarize key methods and tools.",
        "AI_Updates",
    ),
    (
        "2a8271c4-8721-42fc-a185-21b438268007",
        "MTraders Algorithmic Trading",
        "Summarize the algorithmic trading strategies for Gold and Stocks. What indicators and logic are used?",
        "Trading_Learn",
    ),

    # ── Market Knowledge ──────────────────────────────────────────────────
    (
        "5f5b0137-7469-4a68-9706-3a47983077eb",
        "From Debt to Hedge Fund 23 Years",
        "What are the most important trading lessons from 23 years of experience? List top 5 insights.",
        "Trading_Learn",
    ),
    (
        "349b775b-0611-4340-b82a-74d9efeedce1",
        "Mastering Technical Trading TAT",
        "Summarize the key technical analysis methods taught. Focus on actionable rules for entries and exits.",
        "Trading_Learn",
    ),
    (
        "2eac3040-e260-4a31-b523-4db1045fc64d",
        "Trader Overseas Forex & TA",
        "What are the main forex and technical analysis strategies covered? List entry conditions.",
        "Trading_Learn",
    ),

    # ── AI Knowledge ──────────────────────────────────────────────────────
    (
        "70a79f1e-0e02-469c-9b4e-b7f955dfca39",
        "LLM Wiki Second Brain for AI",
        "What are the key methods for building a permanent AI knowledge base? Summarize the workflow and tools.",
        "AI_Updates",
    ),
    (
        "128e81bf-e25f-4f68-99c2-60f8a4c110ac",
        "Mastering Multi-Agent Sub-Agent Systems",
        "Explain the multi-agent and sub-agent architecture. How to design specialized agents for complex tasks?",
        "AI_Updates",
    ),
]

# ใช้แค่บางส่วนต่อ run เพื่อประหยัด rate limit
# สลับกันใช้ทุกวัน
DAILY_BATCH_SIZE = 5


async def _query_notebook(client, nb_id: str, nb_name: str, question: str) -> str | None:
    """Query notebook และ return answer text"""
    try:
        result = await client.chat.ask(nb_id, question)
        return result.answer
    except Exception as e:
        print(f"  [NotebookLM] Error querying '{nb_name}': {e}")
        return None


async def _fetch_async(days_back: int = 7) -> list[dict]:
    """Main async fetch — query notebooks และ return items"""
    from notebooklm import NotebookLMClient

    results = []
    today = datetime.now()

    # เลือก batch โดยใช้วันในสัปดาห์ (0-6) เพื่อหมุนเวียน
    day_index = today.weekday()
    total = len(NOTEBOOK_QUERIES)
    start = (day_index * DAILY_BATCH_SIZE) % total
    batch = []
    for i in range(DAILY_BATCH_SIZE):
        batch.append(NOTEBOOK_QUERIES[(start + i) % total])

    print(f"[NotebookLM] Query {len(batch)} notebooks (batch {start}-{start+len(batch)-1}/{total})")

    try:
        client = await NotebookLMClient.from_storage()
        async with client:
            for nb_id, nb_name, question, category in batch:
                print(f"  Querying: {nb_name[:45]}...")
                answer = await _query_notebook(client, nb_id, nb_name, question)

                if not answer or len(answer) < 50:
                    continue
                if "do not contain" in answer.lower() or "no information" in answer.lower():
                    print(f"    → No relevant content, skipping")
                    continue

                title = f"[NotebookLM] {nb_name}"
                content = f"**Question:** {question}\n\n**Answer:**\n{answer}"

                results.append({
                    "title":    title,
                    "source":   f"NotebookLM/{nb_name}",
                    "category": category,
                    "content":  content,
                    "url":      f"https://notebooklm.google.com/notebook/{nb_id}",
                    "_score":   25,  # bypass pre-filter (เรากรองเองแล้วโดยเลือก notebooks)
                })
                print(f"    → OK ({len(answer)} chars)")

    except Exception as e:
        print(f"[NotebookLM] Client error: {e}")

    print(f"[NotebookLM] ได้ {len(results)} insights")
    return results


def fetch(days_back: int = 7) -> list[dict]:
    """Sync wrapper — ให้ run.py เรียกได้ปกติ"""
    try:
        return asyncio.run(_fetch_async(days_back))
    except Exception as e:
        print(f"[NotebookLM] fetch failed: {e}")
        return []
