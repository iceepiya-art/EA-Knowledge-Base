"""JSON store for AlphaEdge SMC Pro + CME manual forward cases."""
from __future__ import annotations

from datetime import datetime
import json
import os
from uuid import uuid4


DATA_FILE = os.path.join(os.path.dirname(__file__), "alphaedge_journal.json")


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


def _text(form: dict, key: str) -> str:
    return (form.get(key) or "").strip()


def _upper(form: dict, key: str) -> str:
    return _text(form, key).upper()


def _to_float(value, default: float = 0.0) -> float:
    if value in (None, ""):
        return default
    try:
        cleaned = str(value).replace(",", "").replace("$", "").replace("%", "").strip()
        return float(cleaned)
    except (TypeError, ValueError):
        return default


def add_case(form: dict) -> dict:
    now = datetime.now()
    trade_date = _text(form, "trade_date") or now.strftime("%Y-%m-%d")
    symbol = _upper(form, "symbol") or "GOLD"
    direction = _upper(form, "direction") or "WAIT"
    outcome = _upper(form, "outcome") or "OPEN"
    setup_grade = _upper(form, "setup_grade") or "B"

    case = {
        "id": uuid4().hex[:10],
        "created_at": now.strftime("%Y-%m-%d %H:%M:%S"),
        "trade_date": trade_date,
        "symbol": symbol,
        "timeframe": _upper(form, "timeframe") or "M5",
        "direction": direction,
        "setup_grade": setup_grade,
        "outcome": outcome,
        "cme_bias": _upper(form, "cme_bias"),
        "ema_bias": _upper(form, "ema_bias"),
        "structure_bias": _upper(form, "structure_bias"),
        "cme_level": _text(form, "cme_level"),
        "entry": _text(form, "entry"),
        "sl": _text(form, "sl"),
        "tp": _text(form, "tp"),
        "planned_rr": _text(form, "planned_rr"),
        "result_r": _text(form, "result_r"),
        "pnl_points": _text(form, "pnl_points"),
        "pnl_money": _text(form, "pnl_money"),
        "risk_money": _text(form, "risk_money"),
        "setup": _text(form, "setup"),
        "confirmation": _text(form, "confirmation"),
        "mistake": _text(form, "mistake"),
        "rule_learned": _text(form, "rule_learned"),
        "screenshot_path": _text(form, "screenshot_path"),
        "notes": _text(form, "notes"),
    }
    if not case["setup"]:
        case["setup"] = f"{symbol} {direction} {trade_date}"

    cases = _load()
    cases.insert(0, case)
    _save(cases)
    return case


def recent_cases(limit: int = 8) -> list[dict]:
    return _load()[:limit]


def stats() -> dict:
    cases = _load()
    total = len(cases)
    wins = sum(1 for case in cases if (case.get("outcome") or "").upper() == "WIN")
    losses = sum(1 for case in cases if (case.get("outcome") or "").upper() == "LOSS")
    breakeven = sum(1 for case in cases if (case.get("outcome") or "").upper() == "BE")
    open_cases = sum(1 for case in cases if (case.get("outcome") or "").upper() == "OPEN")
    avoid = sum(1 for case in cases if (case.get("outcome") or "").upper() == "AVOID")
    closed = wins + losses
    win_rate = round((wins / closed) * 100, 1) if closed else 0.0

    r_values = [_to_float(case.get("result_r")) for case in cases if case.get("result_r")]
    rr_values = [_to_float(case.get("planned_rr")) for case in cases if case.get("planned_rr")]
    avg_r = round(sum(r_values) / len(r_values), 2) if r_values else 0.0
    avg_rr = round(sum(rr_values) / len(rr_values), 2) if rr_values else 0.0

    by_symbol: dict[str, int] = {}
    for case in cases:
        key = (case.get("symbol") or "OTHER").upper()
        by_symbol[key] = by_symbol.get(key, 0) + 1
    top_symbol = max(by_symbol.items(), key=lambda item: item[1])[0] if by_symbol else "-"

    return {
        "total": total,
        "wins": wins,
        "losses": losses,
        "breakeven": breakeven,
        "open": open_cases,
        "avoid": avoid,
        "closed": closed,
        "win_rate": win_rate,
        "avg_r": avg_r,
        "avg_rr": avg_rr,
        "a_plus": sum(1 for case in cases if (case.get("setup_grade") or "").upper() == "A+"),
        "top_symbol": top_symbol,
    }
