"""JSON store for expert CME reading examples."""
from __future__ import annotations

from datetime import datetime
import json
import os
from uuid import uuid4


DATA_FILE = os.path.join(os.path.dirname(__file__), "cme_reading_cases.json")


def _load() -> list[dict]:
    if not os.path.exists(DATA_FILE):
        return []
    try:
        with open(DATA_FILE, "r", encoding="utf-8") as fh:
            data = json.load(fh)
        return data if isinstance(data, list) else []
    except (json.JSONDecodeError, OSError):
        return []


def _save(cases: list[dict]) -> None:
    with open(DATA_FILE, "w", encoding="utf-8") as fh:
        json.dump(cases, fh, ensure_ascii=False, indent=2)


def add_case(form: dict) -> dict:
    case = {
        "id": uuid4().hex[:10],
        "created_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "title": (form.get("title") or "").strip(),
        "analyst": (form.get("analyst") or "").strip(),
        "product": (form.get("product") or "").strip().upper(),
        "expiration": (form.get("expiration") or "").strip().upper(),
        "chart_type": (form.get("chart_type") or "").strip(),
        "reading_time": (form.get("reading_time") or "").strip(),
        "future_price": (form.get("future_price") or "").strip(),
        "future_change": (form.get("future_change") or "").strip(),
        "put_volume": (form.get("put_volume") or "").strip(),
        "call_volume": (form.get("call_volume") or "").strip(),
        "volatility": (form.get("volatility") or "").strip(),
        "vol_change": (form.get("vol_change") or "").strip(),
        "bias": (form.get("bias") or "").strip(),
        "support": (form.get("support") or "").strip(),
        "resistance": (form.get("resistance") or "").strip(),
        "pivot": (form.get("pivot") or "").strip(),
        "target": (form.get("target") or "").strip(),
        "invalidation": (form.get("invalidation") or "").strip(),
        "skew_reading": (form.get("skew_reading") or "").strip(),
        "trade_plan": (form.get("trade_plan") or "").strip(),
        "risk_note": (form.get("risk_note") or "").strip(),
        "expert_text": (form.get("expert_text") or "").strip(),
        "image_path": (form.get("image_path") or "").strip(),
        "rules_learned": (form.get("rules_learned") or "").strip(),
    }
    if not case["title"]:
        case["title"] = f"{case['product'] or 'CME'} {case['chart_type'] or 'Reading'} {case['reading_time'] or case['created_at']}"

    cases = _load()
    cases.insert(0, case)
    _save(cases)
    return case


def recent_cases(limit: int = 6) -> list[dict]:
    return _load()[:limit]


def stats() -> dict:
    cases = _load()
    total = len(cases)
    bullish = sum(1 for case in cases if case.get("bias") == "BULLISH")
    bearish = sum(1 for case in cases if case.get("bias") == "BEARISH")
    cautious = sum(1 for case in cases if case.get("bias") in ("CAUTIOUS_BULL", "CAUTIOUS_BEAR", "RANGE"))
    return {
        "total": total,
        "bullish": bullish,
        "bearish": bearish,
        "cautious": cautious,
    }
