"""JSON store for Ninja strategy learning cases."""
from __future__ import annotations

from datetime import datetime
import json
import os
from uuid import uuid4


DATA_FILE = os.path.join(os.path.dirname(__file__), "ninja_strategy_cases.json")


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
        "source_url": (form.get("source_url") or "").strip(),
        "setup_type": (form.get("setup_type") or "").strip(),
        "asset": (form.get("asset") or "").strip().upper(),
        "htf": (form.get("htf") or "").strip().upper(),
        "ltf": (form.get("ltf") or "").strip().upper(),
        "market_context": (form.get("market_context") or "").strip(),
        "entry_model": (form.get("entry_model") or "").strip(),
        "confirmation": (form.get("confirmation") or "").strip(),
        "sl_logic": (form.get("sl_logic") or "").strip(),
        "tp_logic": (form.get("tp_logic") or "").strip(),
        "rr_logic": (form.get("rr_logic") or "").strip(),
        "no_trade": (form.get("no_trade") or "").strip(),
        "cme_connection": (form.get("cme_connection") or "").strip(),
        "rules_learned": (form.get("rules_learned") or "").strip(),
        "notes": (form.get("notes") or "").strip(),
        "screenshot_path": (form.get("screenshot_path") or "").strip(),
    }
    if not case["title"]:
        case["title"] = f"{case['setup_type'] or 'Ninja'} {case['asset'] or 'Strategy'} {case['created_at']}"

    cases = _load()
    cases.insert(0, case)
    _save(cases)
    return case


def recent_cases(limit: int = 6) -> list[dict]:
    return _load()[:limit]


def stats() -> dict:
    cases = _load()
    total = len(cases)
    by_type = {}
    for case in cases:
        key = case.get("setup_type") or "Other"
        by_type[key] = by_type.get(key, 0) + 1
    top_type = max(by_type.items(), key=lambda item: item[1])[0] if by_type else "-"
    return {
        "total": total,
        "setup_types": len(by_type),
        "top_type": top_type,
    }
