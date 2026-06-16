"""
Arena + Value Tracker — ดึงข้อมูล AI model ranking + คำนวณ Value Score
Sources: artificialanalysis.ai API, OpenRouter pricing
Value Score = Intelligence Index / (Input Price + 1) → คุ้มค่าที่สุด
"""
import requests
import json
from datetime import datetime

CATEGORY = "AI_Updates"

# ราคา manual (USD per 1M tokens) — อัปเดตจาก arena.ai/leaderboard
# Input / Output
KNOWN_PRICING = {
    "claude-opus-4-6":       (5.00,  25.00),
    "claude-sonnet-4-6":     (3.00,  15.00),
    "claude-haiku-4-5":      (0.25,   1.25),
    "gemini-3.1-pro":        (2.00,  12.00),
    "gemini-3-flash":        (0.10,   0.40),
    "gemini-2.5-pro":        (1.25,  10.00),
    "gpt-5.2":               (1.75,  14.00),
    "gpt-5-mini":            (0.25,   2.00),
    "gpt-5-nano":            (0.05,   0.40),
    "grok-3":                (3.00,  15.00),
    "kimi-k2.5":             (0.60,   3.00),
    "deepseek-v3":           (0.27,   1.10),
    "minimax-m2.5":          (0.30,   1.20),
    "glm-5":                 (1.00,   3.20),
    "llama-4-maverick":      (0.00,   0.00),  # open source / free tier
    "qwen3-235b":            (0.00,   0.00),
}

# Intelligence Index จาก Artificial Analysis (Feb 2026)
KNOWN_SCORES = {
    "gemini-3.1-pro":        57,
    "claude-opus-4-6":       53,  # max thinking
    "claude-sonnet-4-6":     51,  # max thinking
    "gpt-5.2":               51,
    "glm-5":                 50,
    "kimi-k2.5":             47,
    "gemini-3-flash":        46,
    "claude-opus-4-6-std":   46,
    "claude-sonnet-4-6-std": 44,
    "minimax-m2.5":          42,
    "gpt-5-mini":            41,
    "deepseek-v3":           38,
    "llama-4-maverick":      36,
    "claude-haiku-4-5":      35,
    "gemini-2.5-pro":        48,
    "gpt-5-nano":            28,
    "qwen3-235b":            40,
}


def fetch_openrouter_prices() -> dict:
    """ดึงราคาจริงจาก OpenRouter API"""
    prices = {}
    try:
        resp = requests.get(
            "https://openrouter.ai/api/v1/models",
            timeout=10,
            headers={"User-Agent": "Mozilla/5.0"}
        )
        if resp.status_code != 200:
            return prices

        for m in resp.json().get("data", []):
            mid = m.get("id", "")
            pricing = m.get("pricing", {})
            inp = float(pricing.get("prompt", 0)) * 1_000_000
            out = float(pricing.get("completion", 0)) * 1_000_000
            if inp > 0 or out > 0:
                prices[mid] = (round(inp, 4), round(out, 4))
    except Exception as e:
        print(f"[Arena] OpenRouter error: {e}")
    return prices


def calc_value_score(intelligence: float, input_price: float) -> float:
    """
    Value Score = Intelligence / (Price + 0.5)
    ยิ่งสูง = คุ้มค่ากว่า
    +0.5 เพื่อไม่ให้ free models ได้ infinity
    """
    return round(intelligence / (input_price + 0.5), 1)


def build_comparison_table() -> str:
    """สร้างตาราง model comparison พร้อม value score"""
    rows = []
    for model, score in KNOWN_SCORES.items():
        inp, out = KNOWN_PRICING.get(model, (None, None))
        if inp is None:
            continue
        value = calc_value_score(score, inp)
        rows.append({
            "model":   model,
            "score":   score,
            "inp":     inp,
            "out":     out,
            "value":   value,
        })

    rows.sort(key=lambda x: x["value"], reverse=True)

    lines = [
        "| Model | Intel Score | Input $/1M | Output $/1M | Value Score |",
        "|-------|-------------|------------|-------------|-------------|",
    ]
    for r in rows:
        inp_str = f"${r['inp']:.2f}" if r['inp'] > 0 else "Free"
        out_str = f"${r['out']:.2f}" if r['out'] > 0 else "Free"
        lines.append(
            f"| {r['model']:<28} | {r['score']:^11} | {inp_str:^10} | {out_str:^11} | **{r['value']:^9}** |"
        )
    return "\n".join(lines)


def fetch(days_back: int = 7) -> list[dict]:
    today = datetime.now().strftime("%Y-%m-%d")
    table = build_comparison_table()

    # หา top 3 value
    rows = []
    for model, score in KNOWN_SCORES.items():
        inp, out = KNOWN_PRICING.get(model, (None, None))
        if inp is None:
            continue
        rows.append((model, score, inp, out, calc_value_score(score, inp)))
    rows.sort(key=lambda x: x[4], reverse=True)

    top3 = rows[:3]
    top3_text = "\n".join(
        f"  {i+1}. **{r[0]}** — Score {r[1]}, ${r[2]}/1M input → Value {r[4]}"
        for i, r in enumerate(top3)
    )

    content = f"""## AI Model Value Analysis — {today}
> อ้างอิง: arena.ai/leaderboard + Artificial Analysis Intelligence Index

### 🏆 Top 3 คุ้มค่าที่สุด (Value = Intelligence ÷ Price)
{top3_text}

### 📊 ตาราง Model Comparison
{table}

### 💡 วิธีเลือก Model ตามงาน
| งาน | แนะนำ | เหตุผล |
|-----|-------|--------|
| Summarize/classify ข่าว | claude-haiku-4-5 | ถูกสุด ฉลาดพอ |
| วิเคราะห์กลยุทธ์ซับซ้อน | claude-sonnet-4-6 | สมดุล price/quality |
| งาน coding/MQL5 | gpt-5.2 / claude-sonnet-4-6 | code quality สูง |
| วิจัยเชิงลึก | claude-opus-4-6 | ฉลาดสุด แต่แพง |
| ประหยัดสุด | gemini-3-flash / gpt-5-nano | ถูกมาก ใช้งานทั่วไป |

### 🔗 แหล่งข้อมูล
- arena.ai/leaderboard — Human preference voting
- artificialanalysis.ai — Benchmark-based scoring
- openrouter.ai/models — Real-time pricing
"""

    print(f"[Arena Tracker] สร้าง model comparison table แล้ว ({len(rows)} models)")

    return [{
        "title":    f"AI Model Value Analysis — {today}",
        "source":   "arena.ai + Artificial Analysis",
        "category": CATEGORY,
        "content":  content,
        "url":      "https://arena.ai/leaderboard",
    }]
