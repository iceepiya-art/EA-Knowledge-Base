"""Simple JSON store for manual prop trading cases."""
from __future__ import annotations

from datetime import datetime
import json
import os
from uuid import uuid4


DATA_FILE = os.path.join(os.path.dirname(__file__), "prop_cases.json")


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


def _score_part(value: str) -> int:
    try:
        score = int(float(value or 0))
    except ValueError:
        score = 0
    return max(0, min(score, 25))


def add_case(form: dict) -> dict:
    case = {
        "id": uuid4().hex[:10],
        "created_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "symbol": (form.get("symbol") or "").strip().upper(),
        "account": (form.get("account") or "").strip(),
        "session": (form.get("session") or "").strip(),
        "bias": (form.get("bias") or "").strip(),
        "verdict": (form.get("verdict") or "").strip(),
        "result": (form.get("result") or "").strip(),
        "entry": (form.get("entry") or "").strip(),
        "stop_loss": (form.get("stop_loss") or "").strip(),
        "take_profit": (form.get("take_profit") or "").strip(),
        "rr": (form.get("rr") or "").strip(),
        "risk_percent": (form.get("risk_percent") or "").strip(),
        "contracts": (form.get("contracts") or "").strip(),
        "cme_reason": (form.get("cme_reason") or "").strip(),
        "rr_reason": (form.get("rr_reason") or "").strip(),
        "smc_trigger": (form.get("smc_trigger") or "").strip(),
        "mistake": (form.get("mistake") or "").strip(),
        "lesson": (form.get("lesson") or "").strip(),
        "screenshot_path": (form.get("screenshot_path") or "").strip(),
        "score_cme": _score_part(form.get("score_cme", "")),
        "score_rr": _score_part(form.get("score_rr", "")),
        "score_smc": _score_part(form.get("score_smc", "")),
        "score_risk": _score_part(form.get("score_risk", "")),
    }
    case["score_total"] = case["score_cme"] + case["score_rr"] + case["score_smc"] + case["score_risk"]

    cases = _load()
    cases.insert(0, case)
    _save(cases)
    return case


def recent_cases(limit: int = 8) -> list[dict]:
    return _load()[:limit]


def stats() -> dict:
    cases = _load()
    total = len(cases)
    wins = sum(1 for case in cases if case.get("result") == "WIN")
    losses = sum(1 for case in cases if case.get("result") == "LOSS")
    be = sum(1 for case in cases if case.get("result") == "BE")
    skipped = sum(1 for case in cases if case.get("verdict") == "SKIP")
    avg_score = round(sum(case.get("score_total", 0) for case in cases) / total, 1) if total else 0
    win_rate = round((wins / max(wins + losses, 1)) * 100, 1) if wins or losses else 0
    return {
        "total": total,
        "wins": wins,
        "losses": losses,
        "be": be,
        "skipped": skipped,
        "avg_score": avg_score,
        "win_rate": win_rate,
    }
