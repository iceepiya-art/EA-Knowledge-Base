"""
Utilities for attaching SC100 / beta1 / regime context to imported trades.
"""
from __future__ import annotations

from bisect import bisect_right
from datetime import datetime
from functools import lru_cache
from pathlib import Path

from config import HISTDATA_PATH


HISTDATA_DIR = Path(HISTDATA_PATH)
TIME_FORMATS = (
    "%Y-%m-%d %H:%M:%S",
    "%Y-%m-%d %H:%M",
    "%Y.%m.%d %H:%M:%S",
    "%Y.%m.%d %H:%M",
    "%Y/%m/%d %H:%M:%S",
    "%Y/%m/%d %H:%M",
)


def normalize_timestamp(value: str) -> str:
    dt = parse_timestamp(value)
    return dt.strftime("%Y-%m-%d %H:%M") if dt else value.strip()


def parse_timestamp(value: str) -> datetime | None:
    raw = str(value or "").strip()
    if not raw:
        return None

    for fmt in TIME_FORMATS:
        try:
            return datetime.strptime(raw, fmt)
        except ValueError:
            continue
    return None


def classify_regime(sc100: float) -> str:
    if sc100 < 0.22:
        return "CRASH"
    if sc100 < 0.25:
        return "TRENDING"
    if sc100 < 0.35:
        return "WEAK"
    return "REVERTING"


def calc_sc100(closes: list[float], n: int = 100) -> float:
    if len(closes) < n + 1:
        return 0.0

    recent = closes[-(n + 1):]
    returns = [recent[i] - recent[i - 1] for i in range(1, len(recent))]
    if len(returns) < 2:
        return 0.0

    sign_changes = sum(1 for i in range(1, len(returns)) if returns[i] * returns[i - 1] < 0)
    return sign_changes / (len(returns) - 1)


def calc_beta1(closes: list[float], n: int = 50) -> float:
    if len(closes) < n + 1:
        return 0.0

    recent = closes[-(n + 1):]
    returns = [recent[i] - recent[i - 1] for i in range(1, len(recent))]
    if len(returns) < 2:
        return 0.0

    x = returns[:-1]
    y = returns[1:]
    n_obs = len(x)
    xm = sum(x) / n_obs
    ym = sum(y) / n_obs
    cov = sum((x[i] - xm) * (y[i] - ym) for i in range(n_obs))
    var = sum((value - xm) ** 2 for value in x)
    return cov / var if var else 0.0


@lru_cache(maxsize=32)
def _load_year_series(year: int) -> tuple[list[datetime], list[float]]:
    path = HISTDATA_DIR / f"DAT_MT_XAUUSD_M1_{year}.csv"
    if not path.exists():
        return [], []

    timestamps: list[datetime] = []
    closes: list[float] = []
    with open(path, "r", encoding="utf-8", errors="ignore") as handle:
        for line in handle:
            parts = line.strip().replace(";", ",").split(",")
            if len(parts) < 6:
                continue

            dt = parse_timestamp(f"{parts[0]} {parts[1]}")
            if dt is None:
                continue

            try:
                close = float(parts[5] if len(parts) > 5 else parts[4])
            except ValueError:
                continue

            timestamps.append(dt)
            closes.append(close)

    return timestamps, closes


def infer_market_context(symbol: str, entry_time: str, sc_window: int = 100, beta_window: int = 50) -> dict:
    symbol_upper = (symbol or "").upper()
    if "XAU" not in symbol_upper and "GOLD" not in symbol_upper:
        return {"sc100": 0.0, "beta1": 0.0, "regime": "", "context_found": False}

    entry_dt = parse_timestamp(entry_time)
    if entry_dt is None:
        return {"sc100": 0.0, "beta1": 0.0, "regime": "", "context_found": False}

    timestamps, closes = _load_year_series(entry_dt.year)
    if not timestamps:
        return {"sc100": 0.0, "beta1": 0.0, "regime": "", "context_found": False}

    idx = bisect_right(timestamps, entry_dt) - 1
    min_required = max(sc_window, beta_window) + 1
    if idx + 1 < min_required:
        return {"sc100": 0.0, "beta1": 0.0, "regime": "", "context_found": False}

    history = closes[:idx + 1]
    sc100 = calc_sc100(history, sc_window)
    beta1 = calc_beta1(history, beta_window)
    return {
        "sc100": round(sc100, 4),
        "beta1": round(beta1, 6),
        "regime": classify_regime(sc100),
        "context_found": True,
    }
