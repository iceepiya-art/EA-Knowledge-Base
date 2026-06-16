"""
risk_engine.py — Advanced Risk Management Engine

Computes a real-time risk snapshot from the trades DB and config:

  1. Daily drawdown limit          — halts at configurable % of balance
  2. Weekly drawdown limit         — cumulative weekly PnL guard
  3. Consecutive loss protection   — streak-based halt + size reduction
  4. Session lockout rules         — per-session PnL vs limit
  5. Volatility-adjusted sizing    — recent PnL std-dev scalar
  6. Pair correlation limits       — group exposure caps
  7. Dynamic position sizing       — risk-% × balance ÷ SL distance
  8. Trading halt conditions       — auto + manual halt with DB record
  9. Risk score (0–100)            — SAFE / CAUTION / WARNING / HALT

Main entry point:
    snap = get_risk_snapshot()   # everything the dashboard needs

Position sizer:
    result = compute_lot_size(entry, sl, symbol)
"""

import json
import sqlite3
import logging
import numpy as np
import pandas as pd
from pathlib import Path
from datetime import datetime, date, timedelta

log = logging.getLogger(__name__)

BASE_DIR = Path(__file__).resolve().parents[2]
DB_PATH  = BASE_DIR / "DATA"   / "processed" / "trades.sqlite"
CFG_PATH = BASE_DIR / "SYSTEM" / "config"    / "risk_config.json"

# ══════════════════════════════════════════════════════════════════════════════
# CONFIGURATION
# ══════════════════════════════════════════════════════════════════════════════

_DEFAULTS = {
    "account_balance":         50000.0,
    "risk_per_trade_pct":      1.0,
    "max_lot_size":            5.0,

    "daily_loss_limit_pct":    2.0,
    "daily_warning_pct":       1.5,

    "weekly_loss_limit_pct":   5.0,
    "weekly_warning_pct":      3.5,

    "max_consecutive_losses":  3,
    "warn_consecutive_losses": 2,

    "session_loss_limit_pct":  1.0,

    "max_open_trades":         3,
    "max_correlated_trades":   2,

    "volatility_high_scalar":  0.5,
    "atr_high_percentile":     75,

    "behavioral_alerts": {
        "lot_creep_threshold":  1.3,
        "revenge_gap_minutes":  10,
        "fomo_recent_count":    3,
    },
}

def load_config() -> dict:
    try:
        raw = json.loads(CFG_PATH.read_text(encoding="utf-8"))
        cfg = dict(_DEFAULTS)
        cfg.update({k: v for k, v in raw.items() if not k.startswith("_")})
        return cfg
    except Exception:
        return dict(_DEFAULTS)

def save_config(cfg: dict) -> None:
    data = {k: v for k, v in cfg.items() if not k.startswith("_")}
    CFG_PATH.write_text(json.dumps(data, indent=4), encoding="utf-8")

# ══════════════════════════════════════════════════════════════════════════════
# CONTRACT SIZES  (loss per lot per 1 price-unit move)
# ══════════════════════════════════════════════════════════════════════════════

_CONTRACT = {
    "XAUUSD": 100,      # 100 troy oz — 1pt move = $1 × 100 = $100 per std lot
    "XAGUSD": 5000,     # 5000 oz
    "EURUSD": 100000,   "GBPUSD": 100000,  "AUDUSD": 100000,
    "NZDUSD": 100000,   "USDCAD": 100000,  "USDCHF": 100000,
    "EURGBP": 100000,
    "USDJPY": 100000,   # note: loss in JPY — approx ÷ 150 for USD
    "NQ":     20,       # $20 per index point
    "SPX500": 50,       # $50 per index point
    "DJ30":   5,        # $5 per point
    "BTCUSD": 1,        # 1 BTC
}

# Pairs where quote ≠ USD — loss needs conversion (we approximate)
_JPY_PAIRS = {"USDJPY", "EURJPY", "GBPJPY"}

# ══════════════════════════════════════════════════════════════════════════════
# CORRELATION GROUPS
# ══════════════════════════════════════════════════════════════════════════════

_CORR_GROUPS = {
    "precious_metals": ["XAUUSD", "XAGUSD"],
    "eur_block":       ["EURUSD", "GBPUSD", "AUDUSD", "NZDUSD", "EURGBP"],
    "usd_block":       ["USDJPY", "USDCAD", "USDCHF"],
    "us_indices":      ["NQ", "SPX500", "DJ30"],
}

# ══════════════════════════════════════════════════════════════════════════════
# SCHEMA MIGRATIONS  (idempotent — safe on every startup)
# ══════════════════════════════════════════════════════════════════════════════

def _run_migrations(con: sqlite3.Connection) -> None:
    con.executescript("""
    CREATE TABLE IF NOT EXISTS risk_events (
        id           INTEGER PRIMARY KEY AUTOINCREMENT,
        logged_at    DATETIME DEFAULT (datetime('now')),
        level        TEXT NOT NULL CHECK(level IN ('INFO','CAUTION','WARNING','CRITICAL')),
        category     TEXT NOT NULL,
        message      TEXT NOT NULL,
        metric_value REAL,
        threshold    REAL
    );
    CREATE INDEX IF NOT EXISTS idx_re_logged_at ON risk_events(logged_at DESC);

    CREATE TABLE IF NOT EXISTS trading_halts (
        id         INTEGER PRIMARY KEY AUTOINCREMENT,
        started_at DATETIME DEFAULT (datetime('now')),
        ended_at   DATETIME,
        reason     TEXT NOT NULL,
        halt_type  TEXT DEFAULT 'auto' CHECK(halt_type IN ('auto','manual')),
        is_active  INTEGER DEFAULT 1  CHECK(is_active IN (0,1))
    );
    CREATE INDEX IF NOT EXISTS idx_th_active ON trading_halts(is_active);
    """)
    con.commit()

def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    _run_migrations(con)
    return con

# ══════════════════════════════════════════════════════════════════════════════
# DATA RETRIEVAL
# ══════════════════════════════════════════════════════════════════════════════

def _query(sql: str, params=()) -> pd.DataFrame:
    con = _con()
    df = pd.read_sql_query(sql, con, params=params)
    con.close()
    if not df.empty and "open_time" in df.columns:
        df["open_time"] = pd.to_datetime(df["open_time"], errors="coerce")
    return df

def get_today_trades() -> pd.DataFrame:
    return _query("""
        SELECT trade_id, open_time, symbol, direction, outcome, pnl_usd,
               session, lot_size, emotional_state
        FROM trades
        WHERE date(open_time) = date('now')
        ORDER BY open_time
    """)

def get_week_trades() -> pd.DataFrame:
    return _query("""
        SELECT trade_id, open_time, symbol, direction, outcome, pnl_usd,
               session, lot_size
        FROM trades
        WHERE date(open_time) >= date('now','weekday 0','-7 days')
        ORDER BY open_time
    """)

def get_recent_trades(n: int = 30) -> pd.DataFrame:
    return _query(f"""
        SELECT trade_id, open_time, symbol, direction, outcome, pnl_usd, lot_size
        FROM trades ORDER BY open_time DESC LIMIT {n}
    """)

def get_daily_pnl_history(days: int = 30) -> pd.DataFrame:
    return _query(f"""
        SELECT date(open_time) AS day, SUM(pnl_usd) AS daily_pnl,
               COUNT(*) AS trades, SUM(outcome='WIN') AS wins
        FROM trades
        WHERE open_time >= date('now', '-{days} days')
        GROUP BY day ORDER BY day
    """)

# ══════════════════════════════════════════════════════════════════════════════
# METRICS COMPUTATION
# ══════════════════════════════════════════════════════════════════════════════

def _consecutive_losses(df_recent: pd.DataFrame) -> int:
    """Count current consecutive loss streak from most recent trade backwards."""
    streak = 0
    for outcome in df_recent["outcome"].tolist():
        if outcome == "LOSS":
            streak += 1
        else:
            break
    return streak

def _session_pnl_today(df_today: pd.DataFrame) -> dict:
    """PnL per session for today's trades."""
    if df_today.empty or "session" not in df_today.columns:
        return {}
    return df_today.groupby("session")["pnl_usd"].sum().to_dict()

def _correlation_exposure(df_today: pd.DataFrame) -> dict:
    """How many trades per correlation group were taken today."""
    if df_today.empty:
        return {}
    exposure = {}
    for group, symbols in _CORR_GROUPS.items():
        count = df_today["symbol"].isin(symbols).sum()
        if count > 0:
            exposure[group] = int(count)
    return exposure

def _volatility_scalar(df_history: pd.DataFrame, cfg: dict) -> float:
    """
    Derive a position-size scalar from recent daily PnL volatility.
    High std-dev relative to mean → reduce size.
    Returns a multiplier (0.5 – 1.0).
    """
    if len(df_history) < 5:
        return 1.0
    pnl = df_history["daily_pnl"].dropna()
    if len(pnl) < 3:
        return 1.0
    std  = float(pnl.std())
    mean = float(abs(pnl.mean())) or 1.0
    cv   = std / mean  # coefficient of variation
    # High CV → scale down toward the configured scalar floor
    floor = cfg.get("volatility_high_scalar", 0.5)
    if cv > 2.0:   return floor
    if cv > 1.0:   return floor + (1.0 - floor) * (2.0 - cv)
    return 1.0

def _active_halt(con: sqlite3.Connection) -> dict | None:
    """Return the active halt record if one exists, else None."""
    row = con.execute(
        "SELECT * FROM trading_halts WHERE is_active = 1 ORDER BY started_at DESC LIMIT 1"
    ).fetchone()
    return dict(row) if row else None

# ══════════════════════════════════════════════════════════════════════════════
# RISK SCORE
# ══════════════════════════════════════════════════════════════════════════════

def _linear_deduction(value: float, warn_at: float, halt_at: float,
                      max_pts: float) -> float:
    """
    Map a risk metric to a score deduction.
    value:   current exposure (positive = usage, e.g. 0.015 = 1.5% daily dd)
    warn_at: threshold where deduction starts climbing rapidly
    halt_at: threshold = full max_pts deduction
    """
    if value <= 0:           return 0.0
    if value >= halt_at:     return max_pts
    if value >= warn_at:
        # warn_at → halt_at maps to half_pts → max_pts
        half_pts = max_pts * 0.45
        return half_pts + (value - warn_at) / (halt_at - warn_at) * (max_pts - half_pts)
    # 0 → warn_at maps to 0 → half_pts
    half_pts = max_pts * 0.45
    return value / warn_at * half_pts

def compute_score(metrics: dict, cfg: dict) -> dict:
    """
    Compute risk score 0–100, breakdown, status, warnings, halt_reasons.

    Score components (max deductions):
      daily_dd    : 35 pts
      weekly_dd   : 25 pts
      consec_loss : 25 pts
      session_dd  : 15 pts
    Total max deduction = 100 → score minimum = 0
    """
    bal    = cfg["account_balance"] or 1.0
    daily  = metrics.get("daily_pnl", 0.0)
    weekly = metrics.get("weekly_pnl", 0.0)
    consec = metrics.get("consecutive_losses", 0)
    worst_sess_pnl = min(metrics.get("session_pnl", {}).values() or [0.0])

    # Convert to loss fractions (positive means loss)
    daily_loss_pct   = max(0.0, -daily  / bal)
    weekly_loss_pct  = max(0.0, -weekly / bal)
    sess_loss_pct    = max(0.0, -worst_sess_pnl / bal)

    daily_warn  = cfg["daily_warning_pct"]  / 100
    daily_halt  = cfg["daily_loss_limit_pct"] / 100
    week_warn   = cfg["weekly_warning_pct"] / 100
    week_halt   = cfg["weekly_loss_limit_pct"] / 100
    c_warn      = cfg["warn_consecutive_losses"]
    c_halt      = cfg["max_consecutive_losses"]
    sess_halt   = cfg["session_loss_limit_pct"] / 100

    d_deduct = _linear_deduction(daily_loss_pct,  daily_warn, daily_halt, 35)
    w_deduct = _linear_deduction(weekly_loss_pct, week_warn,  week_halt,  25)
    s_deduct = _linear_deduction(sess_loss_pct,   sess_halt * 0.7, sess_halt, 15)

    # Consecutive-loss deduction: integer steps
    if consec == 0:                     c_deduct = 0.0
    elif consec >= c_halt:              c_deduct = 25.0
    elif consec >= c_warn:              c_deduct = 12.0 + (consec - c_warn) / max(c_halt - c_warn, 1) * 13
    else:                               c_deduct = consec / max(c_warn, 1) * 12.0

    score = max(0.0, round(100.0 - d_deduct - w_deduct - c_deduct - s_deduct, 1))

    # ── Halt conditions (binary overrides) ────────────────────────────────
    # Evaluated first so score can be capped below
    halt_reasons = []
    if daily_loss_pct  >= daily_halt:  halt_reasons.append(f"Daily loss limit reached ({daily_loss_pct*100:.1f}%)")
    if weekly_loss_pct >= week_halt:   halt_reasons.append(f"Weekly loss limit reached ({weekly_loss_pct*100:.1f}%)")
    if consec          >= c_halt:      halt_reasons.append(f"{consec} consecutive losses")
    if metrics.get("manual_halt"):     halt_reasons.append("Manual halt active")

    # ── Warnings (approaching limits) ─────────────────────────────────────
    warnings = []
    if daily_loss_pct  >= daily_warn  and not halt_reasons: warnings.append(f"Daily DD at {daily_loss_pct*100:.1f}% (limit {daily_halt*100:.0f}%)")
    if weekly_loss_pct >= week_warn   and not halt_reasons: warnings.append(f"Weekly DD at {weekly_loss_pct*100:.1f}% (limit {week_halt*100:.0f}%)")
    if consec          >= c_warn      and not halt_reasons: warnings.append(f"{consec} consecutive losses (limit {c_halt})")
    if sess_loss_pct   >= sess_halt * 0.7: warnings.append(f"Session DD at {sess_loss_pct*100:.1f}% (limit {sess_halt*100:.0f}%)")

    # Correlation warning
    for group, count in metrics.get("correlation_exposure", {}).items():
        if count >= cfg.get("max_correlated_trades", 2):
            warnings.append(f"High correlation: {count} trades in {group} group")

    # ── Status ────────────────────────────────────────────────────────────
    # Cap score to ≤24 so gauge always shows red when halted
    if halt_reasons:
        score = min(score, 24.0)

    if halt_reasons or score < 20:     status = "HALT"
    elif score < 50:                   status = "WARNING"
    elif score < 75:                   status = "CAUTION"
    else:                              status = "SAFE"

    return {
        "score":        score,
        "status":       status,
        "halt_reasons": halt_reasons,
        "warnings":     warnings,
        "breakdown": {
            "daily_dd":    round(d_deduct, 1),
            "weekly_dd":   round(w_deduct, 1),
            "consec_loss": round(c_deduct, 1),
            "session_dd":  round(s_deduct, 1),
        },
        "limits": {
            "daily_loss_pct":  round(daily_loss_pct * 100,  2),
            "weekly_loss_pct": round(weekly_loss_pct * 100, 2),
            "sess_loss_pct":   round(sess_loss_pct * 100,   2),
            "daily_limit":     round(daily_halt * 100,      1),
            "weekly_limit":    round(week_halt * 100,       1),
            "sess_limit":      round(sess_halt * 100,       1),
            "daily_used_pct":  round(daily_loss_pct / daily_halt * 100, 1) if daily_halt else 0,
            "weekly_used_pct": round(weekly_loss_pct / week_halt * 100, 1) if week_halt else 0,
        },
    }

# ══════════════════════════════════════════════════════════════════════════════
# POSITION SIZING
# ══════════════════════════════════════════════════════════════════════════════

def compute_lot_size(
    entry:   float,
    sl:      float,
    symbol:  str,
    cfg:     dict | None = None,
    vol_scalar: float = 1.0,
) -> dict:
    """
    Risk-based lot size calculator.

    lot_size = (balance × risk_pct%) / (sl_distance × contract_size)

    For JPY pairs: sl_distance is in JPY — divided by ~150 (approximate USD/JPY).
    For index contracts: sl_distance is in index points.

    Returns dict with lot_size, risk_usd, risk_pct, sl_pips, breakdown.
    """
    if cfg is None:
        cfg = load_config()

    bal      = cfg.get("account_balance", 50000.0)
    risk_pct = cfg.get("risk_per_trade_pct", 1.0)
    max_lot  = cfg.get("max_lot_size", 5.0)

    risk_usd     = bal * risk_pct / 100.0
    sl_distance  = abs(entry - sl)

    if sl_distance <= 0:
        return {"error": "SL must differ from entry", "lot_size": 0.0}

    contract     = _CONTRACT.get(symbol.upper(), 100000)
    loss_per_lot = sl_distance * contract

    # JPY-quoted pairs: convert from JPY to USD (approximate)
    if symbol.upper() in _JPY_PAIRS:
        loss_per_lot /= 150.0

    raw_lot = risk_usd / loss_per_lot if loss_per_lot > 0 else 0.0

    # Apply volatility and consecutive-loss scalars
    scaled_lot = raw_lot * vol_scalar
    final_lot  = min(round(scaled_lot, 2), max_lot)
    final_lot  = max(final_lot, 0.01)  # minimum 1 micro lot

    # Pip size reference (for display only — not used in dollar calc)
    _pip = {
        "XAUUSD":0.01,"XAGUSD":0.001,"USDJPY":0.01,"EURJPY":0.01,"GBPJPY":0.01,
        "NQ":0.25,"SPX500":0.1,"DJ30":1.0,"BTCUSD":1.0,
    }
    pip = _pip.get(symbol.upper(), 0.0001)
    sl_pips = round(sl_distance / pip, 1) if pip > 0 else sl_distance

    return {
        "lot_size":         final_lot,
        "raw_lot":          round(raw_lot, 4),
        "risk_usd":         round(risk_usd, 2),
        "risk_pct":         risk_pct,
        "sl_distance":      round(sl_distance, 4),
        "sl_pips":          round(sl_pips, 1),
        "loss_per_lot":     round(loss_per_lot, 2),
        "vol_scalar":       round(vol_scalar, 2),
        "contract_size":    contract,
        "symbol":           symbol,
        "rr_targets": {
            "1R":  round(entry + (entry - sl), 4) if entry > sl else round(entry - (sl - entry), 4),
            "2R":  round(entry + 2*(entry - sl), 4) if entry > sl else round(entry - 2*(sl - entry), 4),
            "3R":  round(entry + 3*(entry - sl), 4) if entry > sl else round(entry - 3*(sl - entry), 4),
        },
    }

# ══════════════════════════════════════════════════════════════════════════════
# HALT MANAGEMENT
# ══════════════════════════════════════════════════════════════════════════════

def set_manual_halt(active: bool, reason: str = "Manual halt") -> None:
    con = _con()
    if active:
        con.execute(
            "INSERT INTO trading_halts (reason, halt_type, is_active) VALUES (?,?,1)",
            (reason, "manual"),
        )
    else:
        con.execute(
            "UPDATE trading_halts SET is_active=0, ended_at=datetime('now') WHERE halt_type='manual' AND is_active=1"
        )
        log_risk_event("INFO", "RESUME", "Manual halt lifted", con=con)
    con.commit()
    con.close()

def _auto_halt_if_needed(halt_reasons: list[str], con: sqlite3.Connection) -> None:
    """Create auto halt record when conditions are first triggered."""
    if not halt_reasons:
        # Clear any existing auto halt
        con.execute(
            "UPDATE trading_halts SET is_active=0, ended_at=datetime('now') WHERE halt_type='auto' AND is_active=1"
        )
        return
    existing = con.execute(
        "SELECT id FROM trading_halts WHERE halt_type='auto' AND is_active=1"
    ).fetchone()
    if not existing:
        reason = " | ".join(halt_reasons)
        con.execute(
            "INSERT INTO trading_halts (reason, halt_type, is_active) VALUES (?,?,1)",
            (reason, "auto"),
        )

# ══════════════════════════════════════════════════════════════════════════════
# ALERT LOGGING
# ══════════════════════════════════════════════════════════════════════════════

def log_risk_event(
    level:    str,
    category: str,
    message:  str,
    value:    float | None = None,
    threshold: float | None = None,
    con: sqlite3.Connection | None = None,
) -> None:
    close = con is None
    if close:
        con = _con()
    try:
        con.execute(
            "INSERT INTO risk_events (level,category,message,metric_value,threshold) VALUES (?,?,?,?,?)",
            (level, category, message, value, threshold),
        )
        con.commit()
    except Exception as e:
        log.warning(f"log_risk_event failed: {e}")
    finally:
        if close:
            con.close()

def get_risk_events(limit: int = 100) -> pd.DataFrame:
    df = _query(
        f"SELECT logged_at, level, category, message, metric_value, threshold FROM risk_events ORDER BY logged_at DESC LIMIT {limit}"
    )
    if not df.empty:
        df["logged_at"] = pd.to_datetime(df["logged_at"], errors="coerce")
    return df

# ══════════════════════════════════════════════════════════════════════════════
# BEHAVIORAL ALERTS
# ══════════════════════════════════════════════════════════════════════════════

def behavioral_alerts(df_all: pd.DataFrame, df_today: pd.DataFrame, cfg: dict) -> list[dict]:
    """
    Detect behavioral risk patterns.
    Returns list of {level, message} dicts.
    """
    alerts = []
    ba = cfg.get("behavioral_alerts", {})

    # 1. Lot size creep — recent 5 vs overall average
    if "lot_size" in df_all.columns and len(df_all) >= 10:
        r5   = df_all.tail(5)["lot_size"].mean()
        avg  = df_all["lot_size"].mean()
        thresh = ba.get("lot_creep_threshold", 1.3)
        if r5 > avg * thresh:
            alerts.append({
                "level":   "WARNING",
                "message": f"Lot size creep: last-5 avg {r5:.3f} vs overall {avg:.3f} ({r5/avg:.1f}x)",
            })

    # 2. Rapid re-entry after loss (revenge trade signal)
    if not df_today.empty and "open_time" in df_today.columns:
        losses = df_today[df_today["outcome"] == "LOSS"].sort_values("open_time")
        if len(losses) >= 2:
            gaps = losses["open_time"].diff().dt.total_seconds().dropna() / 60
            min_gap = gaps.min()
            gap_t = ba.get("revenge_gap_minutes", 10)
            if min_gap < gap_t:
                alerts.append({
                    "level":   "WARNING",
                    "message": f"Rapid re-entry after loss: {min_gap:.0f} min gap (threshold {gap_t} min)",
                })

    # 3. FOMO/Revenge tags in recent trades
    if "emotional_state" in df_all.columns:
        recent_em = df_all.tail(5)["emotional_state"].value_counts()
        danger = int(recent_em.get("FOMO", 0)) + int(recent_em.get("Revenge", 0))
        thresh = ba.get("fomo_recent_count", 3)
        if danger >= thresh:
            alerts.append({
                "level":   "CRITICAL",
                "message": f"Emotional risk: {danger}/5 recent trades tagged FOMO or Revenge",
            })

    # 4. Trading outside best sessions
    if not df_today.empty and "session" in df_today.columns:
        other = df_today[df_today["session"] == "Other"]
        if len(other) >= 2:
            alerts.append({
                "level":   "CAUTION",
                "message": f"{len(other)} trades taken in 'Other' session today (off-hours)",
            })

    # 5. Losing streak today specifically
    if not df_today.empty:
        today_wr = (df_today["outcome"] == "WIN").mean()
        if len(df_today) >= 3 and today_wr < 0.30:
            alerts.append({
                "level":   "WARNING",
                "message": f"Today WR is {today_wr:.0%} ({len(df_today)} trades) — consider stopping",
            })

    return alerts

# ══════════════════════════════════════════════════════════════════════════════
# MAIN SNAPSHOT
# ══════════════════════════════════════════════════════════════════════════════

def get_risk_snapshot(cfg: dict | None = None) -> dict:
    """
    Single call that returns everything the dashboard needs.
    Safe to call on every page refresh.
    """
    if cfg is None:
        cfg = load_config()

    con = _con()

    # ── Fetch data ──────────────────────────────────────────────────────────
    df_today  = get_today_trades()
    df_week   = get_week_trades()
    df_recent = get_recent_trades(30)
    df_hist   = get_daily_pnl_history(30)

    # ── Core metrics ────────────────────────────────────────────────────────
    daily_pnl_val  = float(df_today["pnl_usd"].sum()) if not df_today.empty else 0.0
    weekly_pnl_val = float(df_week["pnl_usd"].sum())  if not df_week.empty  else 0.0
    consec         = _consecutive_losses(df_recent)
    session_pnl    = _session_pnl_today(df_today)
    corr_exposure  = _correlation_exposure(df_today)
    vol_scalar     = _volatility_scalar(df_hist, cfg)
    manual_halt    = _active_halt(con)

    metrics = {
        "daily_pnl":            daily_pnl_val,
        "weekly_pnl":           weekly_pnl_val,
        "consecutive_losses":   consec,
        "session_pnl":          session_pnl,
        "correlation_exposure": corr_exposure,
        "vol_scalar":           vol_scalar,
        "manual_halt":          manual_halt is not None,
    }

    # ── Score & status ──────────────────────────────────────────────────────
    score_result = compute_score(metrics, cfg)

    # ── Auto halt management ────────────────────────────────────────────────
    _auto_halt_if_needed(score_result["halt_reasons"], con)

    # ── Log critical events (avoid spam: check if already logged today) ─────
    if score_result["halt_reasons"]:
        for reason in score_result["halt_reasons"]:
            today_str = date.today().isoformat()
            existing = con.execute(
                "SELECT id FROM risk_events WHERE category='HALT' AND message=? AND date(logged_at)=?",
                (reason, today_str),
            ).fetchone()
            if not existing:
                log_risk_event("CRITICAL", "HALT", reason, con=con)

    con.commit()
    con.close()

    # ── Today stats ─────────────────────────────────────────────────────────
    today_trades = len(df_today)
    today_wr     = (df_today["outcome"] == "WIN").mean() * 100 if not df_today.empty else 0.0
    today_wins   = int((df_today["outcome"] == "WIN").sum())   if not df_today.empty else 0
    today_losses = int((df_today["outcome"] == "LOSS").sum())  if not df_today.empty else 0

    # ── Behavioral alerts ───────────────────────────────────────────────────
    df_all_recent = get_recent_trades(50)
    beh_alerts = behavioral_alerts(df_all_recent, df_today, cfg)

    return {
        # Score & status
        "score":         score_result["score"],
        "status":        score_result["status"],
        "halt_reasons":  score_result["halt_reasons"],
        "warnings":      score_result["warnings"],
        "breakdown":     score_result["breakdown"],
        "limits":        score_result["limits"],

        # Raw metrics
        "daily_pnl":     daily_pnl_val,
        "weekly_pnl":    weekly_pnl_val,
        "consec_losses": consec,
        "session_pnl":   session_pnl,
        "corr_exposure": corr_exposure,
        "vol_scalar":    vol_scalar,
        "manual_halt":   manual_halt,

        # Today summary
        "today_trades":  today_trades,
        "today_wr":      today_wr,
        "today_wins":    today_wins,
        "today_losses":  today_losses,

        # Behavioral
        "behavioral_alerts": beh_alerts,

        # History for charts
        "df_today":  df_today,
        "df_week":   df_week,
        "df_hist":   df_hist,
    }
