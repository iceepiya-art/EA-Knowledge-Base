"""
Trade Store — เก็บ trade log ทุก trade พร้อม QField context
Schema ออกแบบให้ ANALYST agent วิเคราะห์ได้ทันที
"""
import json
import uuid
from datetime import datetime
from pathlib import Path

TRADE_FILE = Path(__file__).parent / "trades.json"


def _load() -> list[dict]:
    if not TRADE_FILE.exists():
        return []
    with open(TRADE_FILE, "r", encoding="utf-8") as f:
        return json.load(f)


def _save(trades: list[dict]):
    with open(TRADE_FILE, "w", encoding="utf-8") as f:
        json.dump(trades, f, ensure_ascii=False, indent=2)


def _trade_identity(trade: dict) -> tuple[str, str, str, str, str]:
    return (
        str(trade.get("ticket", "")),
        str(trade.get("symbol", "")),
        str(trade.get("direction", "")),
        str(trade.get("entry_time", "")),
        str(trade.get("exit_time", "")),
    )


def add_trade(
    # ── ข้อมูลพื้นฐาน ─────────────────────────────────
    symbol:       str,
    direction:    str,        # BUY | SELL
    entry_price:  float,
    exit_price:   float,
    lot:          float,
    entry_time:   str,        # "2026-05-02 14:30"
    exit_time:    str,
    profit:       float,      # USD
    # ── QField context ────────────────────────────────
    sc100:        float = 0.0,   # SC₁₀₀ ตอน entry
    beta1:        float = 0.0,   # β₁ ตอน entry
    regime:       str   = "",    # TRENDING|WEAK|REVERTING|CRASH
    tickvol_q:    str   = "",    # Q1|Q2|Q3|Q4
    exit_type:    str   = "",    # TP|RSI_EXIT|SL|MANUAL
    # ── Optional ──────────────────────────────────────
    ea_name:      str   = "QField",
    notes:        str   = "",
    ticket:       str   = "",    # MT5 ticket number
) -> str:
    trades = _load()
    candidate_key = _trade_identity({
        "ticket": ticket,
        "symbol": symbol,
        "direction": direction,
        "entry_time": entry_time,
        "exit_time": exit_time,
    })
    if any(_trade_identity(existing) == candidate_key for existing in trades):
        return ""

    trade_id = str(uuid.uuid4())[:8]

    # คำนวณ pips และ session
    pip_value = 0.1 if "XAU" in symbol or "GOLD" in symbol else 0.0001
    pips = abs(exit_price - entry_price) / pip_value if pip_value > 0 else 0
    win = profit > 0

    # session จาก entry_time
    try:
        hour = int(entry_time[11:13])
        if 0 <= hour < 8:
            session = "Asian"
        elif 8 <= hour < 13:
            session = "London"
        elif 13 <= hour < 17:
            session = "New_York"
        elif 17 <= hour < 21:
            session = "Overlap"
        else:
            session = "Late_NY"
    except Exception:
        session = "Unknown"

    trades.append({
        "id":           trade_id,
        "ticket":       ticket,
        "ea_name":      ea_name,
        "symbol":       symbol,
        "direction":    direction,
        "lot":          lot,
        "entry_price":  entry_price,
        "exit_price":   exit_price,
        "entry_time":   entry_time,
        "exit_time":    exit_time,
        "profit":       round(profit, 2),
        "pips":         round(pips, 1),
        "win":          win,
        "sc100":        round(sc100, 3),
        "beta1":        round(beta1, 3),
        "regime":       regime,
        "tickvol_q":    tickvol_q,
        "exit_type":    exit_type,
        "session":      session,
        "notes":        notes,
        "added_at":     datetime.now().strftime("%Y-%m-%d %H:%M"),
    })
    _save(trades)
    return trade_id


def get_all() -> list[dict]:
    return _load()


def get_by_ea(ea_name: str) -> list[dict]:
    return [t for t in _load() if t.get("ea_name") == ea_name]


def get_by_regime(regime: str) -> list[dict]:
    return [t for t in _load() if t.get("regime") == regime]


def get_stats(trades: list[dict] = None) -> dict:
    """คำนวณสถิติพื้นฐาน"""
    if trades is None:
        trades = _load()
    if not trades:
        return {
            "total": 0,
            "wins": 0,
            "losses": 0,
            "win_rate": 0,
            "profit_factor": 0,
            "net_profit": 0,
            "avg_win": 0,
            "avg_loss": 0,
            "max_win": 0,
            "max_loss": 0,
            "gross_profit": 0,
            "gross_loss": 0,
        }

    wins   = [t for t in trades if t.get("win")]
    losses = [t for t in trades if not t.get("win")]
    profits = [t["profit"] for t in trades]

    gross_profit = sum(t["profit"] for t in wins) if wins else 0
    gross_loss   = abs(sum(t["profit"] for t in losses)) if losses else 0

    return {
        "total":         len(trades),
        "wins":          len(wins),
        "losses":        len(losses),
        "win_rate":      round(len(wins) / len(trades) * 100, 1) if trades else 0,
        "profit_factor": round(gross_profit / gross_loss, 2) if gross_loss > 0 else 999,
        "net_profit":    round(sum(profits), 2),
        "avg_win":       round(sum(t["profit"] for t in wins) / len(wins), 2) if wins else 0,
        "avg_loss":      round(sum(t["profit"] for t in losses) / len(losses), 2) if losses else 0,
        "max_win":       round(max(profits), 2) if profits else 0,
        "max_loss":      round(min(profits), 2) if profits else 0,
        "gross_profit":  round(gross_profit, 2),
        "gross_loss":    round(gross_loss, 2),
    }


def count_trades() -> int:
    return len(_load())


def enrich_missing_contexts() -> int:
    from regime_context import infer_market_context, normalize_timestamp

    trades = _load()
    updated = 0

    for trade in trades:
        normalized_entry = normalize_timestamp(trade.get("entry_time", ""))
        normalized_exit = normalize_timestamp(trade.get("exit_time", ""))
        changed = False

        if normalized_entry != trade.get("entry_time", ""):
            trade["entry_time"] = normalized_entry
            changed = True
        if normalized_exit != trade.get("exit_time", ""):
            trade["exit_time"] = normalized_exit
            changed = True

        if trade.get("sc100") or trade.get("regime"):
            if changed:
                updated += 1
            continue

        context = infer_market_context(trade.get("symbol", ""), trade.get("entry_time", ""))
        if context.get("context_found"):
            trade["sc100"] = round(context.get("sc100", 0.0), 3)
            trade["beta1"] = round(context.get("beta1", 0.0), 3)
            trade["regime"] = context.get("regime", "")
            updated += 1
        elif changed:
            updated += 1

    if updated:
        _save(trades)
    return updated
