"""
annotator.py — Backend CRUD for trade annotation system.

All DB writes go through save_annotation() which logs every change
to the annotations history table.
"""

import sqlite3
import json
import logging
import pandas as pd
from pathlib import Path
from datetime import datetime

log = logging.getLogger(__name__)

BASE_DIR = Path(__file__).resolve().parents[2]

def _cfg():
    p = BASE_DIR / "SYSTEM" / "config" / "system_config.json"
    return json.load(open(p, encoding="utf-8")) if p.exists() else {}

DB_PATH = BASE_DIR / _cfg().get("db", {}).get("trades_db", "DATA/processed/trades.sqlite")

# ── Controlled vocabulary ──────────────────────────────────────────────────────
SETUP_TYPES = [
    "SMC_W", "SMC_M", "Breakout", "Reversal",
    "BSL_Sweep", "SSL_Sweep", "FVG", "OB", "CHoCH",
    "Grid", "Scalp", "News", "Other",
]

REGIMES = ["TRENDING", "REVERTING", "WEAK", "CRASH", "UNKNOWN"]

EMOTIONAL_STATES = [
    "Calm", "Confident", "FOMO", "Revenge", "Bored", "Anxious", "Greedy",
]

MISTAKES = [
    "late_entry", "early_entry", "moved_sl", "removed_tp",
    "oversized", "undersized", "revenge_trade", "fomo_entry",
    "wrong_session", "ignored_regime", "wrong_direction",
    "chased_price", "no_confirmation", "poor_rr",
]

SESSION_BIASES   = ["Bullish", "Bearish", "Neutral"]
ENTRY_TIMINGS    = ["Early", "OnTime", "Late"]
EXIT_REASONS     = [
    "TP_Hit", "SL_Hit", "Manual_Close", "Trail_Stop",
    "EA_Close", "Hedge_Close", "News_Close",
]
SESSIONS         = ["Asian", "London", "London_NY", "NY", "Pre_NY", "Other"]

# Fields in trades table that can be annotated
ANNOTATION_FIELDS = {
    "setup_type", "regime", "emotional_state", "mistakes",
    "execution_score", "setup_quality", "confidence_level",
    "session_bias", "plan_followed", "entry_timing", "exit_reason",
    "notes", "session",
}


# ── Connection ─────────────────────────────────────────────────────────────────
def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    return con


# ── Migration — add new columns safely ────────────────────────────────────────
def run_migration():
    """Add confidence_level and session_bias if missing. Safe to re-run."""
    new_cols = [
        ("confidence_level", "INTEGER"),
        ("session_bias",     "TEXT"),
    ]
    con = _con()
    for col, dtype in new_cols:
        try:
            con.execute(f"ALTER TABLE trades ADD COLUMN {col} {dtype}")
            log.info(f"Migration: added column {col}")
        except sqlite3.OperationalError:
            pass  # already exists
    con.commit()
    con.close()


# ── Progress ───────────────────────────────────────────────────────────────────
def get_progress() -> dict:
    con = _con()
    cur = con.cursor()
    cur.execute("SELECT COUNT(*) FROM trades")
    total = cur.fetchone()[0]
    cur.execute("SELECT COUNT(*) FROM trades WHERE emotional_state IS NOT NULL")
    annotated = cur.fetchone()[0]
    con.close()
    return {"total": total, "annotated": annotated, "remaining": total - annotated}


# ── Query trades ───────────────────────────────────────────────────────────────
def get_trades(
    strategy:         str  = None,
    symbol:           str  = None,
    outcome:          str  = None,
    regime:           str  = None,
    session:          str  = None,
    unannotated_only: bool = False,
    search:           str  = None,
    date_from:        str  = None,
    date_to:          str  = None,
    limit:            int  = 1000,
) -> pd.DataFrame:
    conds, params = [], []

    if strategy:         conds.append("strategy = ?");              params.append(strategy)
    if symbol:           conds.append("symbol = ?");                params.append(symbol)
    if outcome:          conds.append("outcome = ?");               params.append(outcome)
    if regime:           conds.append("regime = ?");                params.append(regime)
    if session:          conds.append("session = ?");               params.append(session)
    if unannotated_only: conds.append("emotional_state IS NULL")
    if search:
        conds.append("(trade_id LIKE ? OR notes LIKE ? OR strategy LIKE ?)")
        params += [f"%{search}%", f"%{search}%", f"%{search}%"]
    if date_from:        conds.append("date(open_time) >= ?");      params.append(date_from)
    if date_to:          conds.append("date(open_time) <= ?");      params.append(date_to)

    where = ("WHERE " + " AND ".join(conds)) if conds else ""
    sql = f"""
        SELECT trade_id, open_time, symbol, strategy, direction,
               outcome, pnl_usd, session, regime, setup_type,
               emotional_state, execution_score, confidence_level,
               mistakes, notes
        FROM trades
        {where}
        ORDER BY open_time DESC
        LIMIT ?
    """
    params.append(limit)

    con = _con()
    df = pd.read_sql_query(sql, con, params=params)
    con.close()

    if not df.empty:
        df["open_time"] = pd.to_datetime(df["open_time"], errors="coerce")
        df["display"]   = (
            df["open_time"].dt.strftime("%Y-%m-%d %H:%M") + "  " +
            df["symbol"] + " " + df["direction"] + "  " +
            df["pnl_usd"].apply(lambda v: f"+${v:,.0f}" if v > 0 else f"-${abs(v):,.0f}")
        )
    return df


def get_trade(trade_id: str) -> dict:
    """Get full trade row as dict."""
    con = _con()
    cur = con.cursor()
    cur.execute("SELECT * FROM trades WHERE trade_id = ?", (trade_id,))
    row = cur.fetchone()
    con.close()
    return dict(row) if row else {}


# ── Save annotation (single trade) ────────────────────────────────────────────
def save_annotation(trade_id: str, fields: dict, annotator: str = "human") -> tuple[bool, str]:
    """
    Write annotation fields to trades table.
    Every changed field is logged to annotations table.
    Returns (success: bool, message: str).
    """
    if not trade_id:
        return False, "No trade_id"

    # Normalize mistakes list → pipe-separated string
    if "mistakes" in fields:
        v = fields["mistakes"]
        if isinstance(v, list):
            fields["mistakes"] = "|".join(v) if v else None
        elif v == "":
            fields["mistakes"] = None

    # Only keep fields that exist in the schema
    valid = {k: v for k, v in fields.items() if k in ANNOTATION_FIELDS}
    if not valid:
        return False, "No valid fields"

    con = _con()
    cur = con.cursor()
    cur.execute("SELECT * FROM trades WHERE trade_id = ?", (trade_id,))
    row = cur.fetchone()
    if not row:
        con.close()
        return False, f"Trade not found: {trade_id}"

    current = dict(row)
    changes = {}

    for field, new_val in valid.items():
        old_val  = current.get(field)
        old_norm = None if (old_val  is None or str(old_val)  == "")  else old_val
        new_norm = None if (new_val  is None or str(new_val)  == "")  else new_val
        if str(old_norm) != str(new_norm):
            changes[field] = (old_norm, new_norm)

    if not changes:
        con.close()
        return True, "No changes"

    # Update trades
    set_parts = ", ".join(f"{k} = ?" for k in changes)
    vals      = [v[1] for v in changes.values()] + [trade_id]
    cur.execute(
        f"UPDATE trades SET {set_parts}, updated_at = datetime('now') WHERE trade_id = ?",
        vals,
    )

    # Log history
    for field, (old_v, new_v) in changes.items():
        cur.execute(
            """INSERT INTO annotations
               (trade_id, field_name, old_value, new_value, annotator)
               VALUES (?, ?, ?, ?, ?)""",
            (trade_id, field, str(old_v), str(new_v), annotator),
        )

    con.commit()
    con.close()
    return True, f"Saved {len(changes)} field(s): {', '.join(changes)}"


# ── Bulk annotate ──────────────────────────────────────────────────────────────
def bulk_annotate(trade_ids: list, fields: dict) -> tuple[int, str]:
    """
    Apply same annotation fields to multiple trades.
    Only applies fields with non-None/non-empty values.
    """
    if not trade_ids:
        return 0, "No trades selected"

    apply = {
        k: v for k, v in fields.items()
        if v is not None and v != "" and v != []
    }
    if not apply:
        return 0, "No fields selected to apply"

    count = 0
    for tid in trade_ids:
        ok, _ = save_annotation(tid, dict(apply), annotator="bulk")
        if ok:
            count += 1

    return count, f"Applied to {count} / {len(trade_ids)} trades"


# ── Annotation history ─────────────────────────────────────────────────────────
def get_history(trade_id: str = None, field: str = None, limit: int = 300) -> pd.DataFrame:
    conds, params = [], []
    if trade_id: conds.append("trade_id = ?");   params.append(trade_id)
    if field:    conds.append("field_name = ?");  params.append(field)
    where = ("WHERE " + " AND ".join(conds)) if conds else ""
    sql = f"""
        SELECT annotated_at, trade_id, field_name, old_value, new_value, annotator
        FROM annotations {where}
        ORDER BY annotated_at DESC LIMIT ?
    """
    params.append(limit)
    con = _con()
    df = pd.read_sql_query(sql, con, params=params)
    con.close()
    if not df.empty:
        df["annotated_at"] = pd.to_datetime(df["annotated_at"], errors="coerce")
    return df


# ── Dropdown helpers ───────────────────────────────────────────────────────────
def distinct_values(column: str) -> list:
    """Get distinct non-null values for sidebar dropdowns."""
    if column not in {
        "strategy", "symbol", "session", "regime",
        "outcome", "setup_type", "emotional_state",
    }:
        return []
    con = _con()
    cur = con.cursor()
    cur.execute(
        f"SELECT DISTINCT {column} FROM trades WHERE {column} IS NOT NULL ORDER BY {column}"
    )
    vals = [r[0] for r in cur.fetchall()]
    con.close()
    return vals


# ══════════════════════════════════════════════════════════════════════════════
# QUICK-TAG PRESETS
# ══════════════════════════════════════════════════════════════════════════════

QUICK_TAGS = {
    "Win — Planned":  {"emotional_state":"Calm",    "plan_followed":1, "entry_timing":"OnTime",
                       "execution_score":8, "setup_quality":4, "confidence_level":4, "mistakes":[]},
    "Win — Lucky":    {"emotional_state":"Confident","plan_followed":0, "entry_timing":"Late",
                       "execution_score":5, "setup_quality":3, "confidence_level":3,
                       "mistakes":["chased_price"]},
    "Loss — Good":    {"emotional_state":"Calm",    "plan_followed":1, "entry_timing":"OnTime",
                       "execution_score":7, "setup_quality":4, "confidence_level":4, "mistakes":[]},
    "Loss — FOMO":    {"emotional_state":"FOMO",    "plan_followed":0, "entry_timing":"Late",
                       "execution_score":2, "setup_quality":2, "confidence_level":2,
                       "mistakes":["fomo_entry","chased_price"]},
    "Loss — Revenge": {"emotional_state":"Revenge", "plan_followed":0, "entry_timing":"Early",
                       "execution_score":2, "setup_quality":1, "confidence_level":1,
                       "mistakes":["revenge_trade","oversized"]},
    "Moved SL":       {"emotional_state":"Anxious", "plan_followed":0,
                       "execution_score":3, "confidence_level":2,
                       "mistakes":["moved_sl"]},
}

QUICK_TAG_KEYS = list(QUICK_TAGS.keys())   # index → keyboard key 1-6


# ══════════════════════════════════════════════════════════════════════════════
# AUTO-TAGGING
# ══════════════════════════════════════════════════════════════════════════════

_BROKER_TZ = 2   # broker server = EET = UTC+2

_SESSIONS_UTC = [
    ("Asian",     0,  8),
    ("London",    8, 13),
    ("Pre_NY",   13, 14),
    ("London_NY",14, 15),
    ("NY",       15, 20),
]

def _derive_session(open_time_str: str) -> str:
    try:
        dt = pd.to_datetime(open_time_str)
        utc_frac = ((dt.hour - _BROKER_TZ) % 24) + dt.minute / 60
        for name, start, end in _SESSIONS_UTC:
            if start <= utc_frac < end:
                return name
    except Exception:
        pass
    return "Other"

def _derive_regime_from_sc100(sc100: float | None, beta1: float | None = None) -> str | None:
    """SC₁₀₀ → regime using validated thresholds from 02_Regime_Detection.md."""
    if sc100 is not None:
        if   sc100 < 0.22: return "CRASH"
        elif sc100 < 0.25: return "TRENDING"
        elif sc100 < 0.35: return "WEAK"
        else:              return "REVERTING"
    if beta1 is not None:
        return "TRENDING" if abs(beta1) > 0.3 else "REVERTING"
    return None

def auto_tag_session(trade_id: str) -> tuple[bool, str]:
    """Re-derive session from open_time and save if different."""
    trade = get_trade(trade_id)
    if not trade:
        return False, "Trade not found"
    session = _derive_session(trade.get("open_time", ""))
    ok, msg = save_annotation(trade_id, {"session": session})
    return ok, f"Session → {session}  ({msg})"

def auto_tag_regime(trade_id: str) -> tuple[bool, str]:
    """Derive regime from sc100_value / beta1_value and save."""
    trade = get_trade(trade_id)
    if not trade:
        return False, "Trade not found"
    regime = _derive_regime_from_sc100(
        trade.get("sc100_value"), trade.get("beta1_value")
    )
    if regime is None:
        return False, "No SC100 or beta1 data — cannot auto-tag"
    ok, msg = save_annotation(trade_id, {"regime": regime})
    return ok, f"Regime → {regime}  ({msg})"

def batch_auto_tag(
    fields: list[str] | None = None,
    strategy: str | None = None,
    limit: int = 5000,
) -> dict:
    """
    Auto-tag session and/or regime for all trades missing those fields.
    Returns {'session': n_tagged, 'regime': n_tagged, 'errors': n}.
    """
    if fields is None:
        fields = ["session", "regime"]

    conds, params = [], []
    if strategy:
        conds.append("strategy = ?"); params.append(strategy)

    where_base = ("WHERE " + " AND ".join(conds)) if conds else "WHERE 1=1"

    con = _con()
    counts = {f: 0 for f in fields}
    errors = 0

    if "session" in fields:
        rows = con.execute(
            f"SELECT trade_id, open_time FROM trades {where_base} LIMIT {limit}",
            params,
        ).fetchall()
        for row in rows:
            tid, ot = row["trade_id"], row["open_time"]
            sess = _derive_session(ot)
            try:
                con.execute(
                    "UPDATE trades SET session=?, updated_at=datetime('now') WHERE trade_id=?",
                    (sess, tid),
                )
                counts["session"] += 1
            except Exception:
                errors += 1
        con.commit()

    if "regime" in fields:
        rows = con.execute(
            f"""SELECT trade_id, sc100_value, beta1_value FROM trades
                {where_base} AND regime IS NULL
                AND (sc100_value IS NOT NULL OR beta1_value IS NOT NULL)
                LIMIT {limit}""",
            params,
        ).fetchall()
        for row in rows:
            tid = row["trade_id"]
            regime = _derive_regime_from_sc100(row["sc100_value"], row["beta1_value"])
            if regime:
                try:
                    con.execute(
                        "UPDATE trades SET regime=?, updated_at=datetime('now') WHERE trade_id=?",
                        (regime, tid),
                    )
                    counts["regime"] += 1
                except Exception:
                    errors += 1
        con.commit()

    con.close()
    return {**counts, "errors": errors}


# ══════════════════════════════════════════════════════════════════════════════
# PROGRESS ANALYTICS
# ══════════════════════════════════════════════════════════════════════════════

def get_progress_by(group_by: str = "strategy") -> pd.DataFrame:
    """Annotation completion rate grouped by strategy, symbol, or session."""
    allowed = {"strategy", "symbol", "session", "outcome"}
    if group_by not in allowed:
        group_by = "strategy"
    sql = f"""
        SELECT
            {group_by}                                        AS group_name,
            COUNT(*)                                          AS total,
            SUM(emotional_state IS NOT NULL)                  AS annotated,
            SUM(setup_type IS NOT NULL)                       AS has_setup,
            SUM(regime IS NOT NULL)                           AS has_regime,
            SUM(mistakes IS NOT NULL)                         AS has_mistakes,
            SUM(execution_score IS NOT NULL)                  AS has_exec_score
        FROM trades
        WHERE {group_by} IS NOT NULL
        GROUP BY {group_by}
        ORDER BY total DESC
    """
    con = _con()
    df = pd.read_sql_query(sql, con)
    con.close()
    if not df.empty:
        df["pct_annotated"] = (df["annotated"] / df["total"] * 100).round(1)
    return df

def get_field_coverage() -> pd.DataFrame:
    """How many trades have each annotation field filled."""
    fields = [
        ("emotional_state", "Emotional State"),
        ("setup_type",      "Setup Type"),
        ("regime",          "Regime"),
        ("mistakes",        "Mistakes"),
        ("execution_score", "Exec Quality"),
        ("setup_quality",   "Setup Quality"),
        ("confidence_level","Confidence"),
        ("plan_followed",   "Plan Followed"),
        ("entry_timing",    "Entry Timing"),
        ("exit_reason",     "Exit Reason"),
        ("notes",           "Notes"),
        ("screenshot_path", "Screenshot"),
    ]
    con = _con()
    cur = con.cursor()
    cur.execute("SELECT COUNT(*) FROM trades")
    total = cur.fetchone()[0]
    rows = []
    for col, label in fields:
        cur.execute(f"SELECT COUNT(*) FROM trades WHERE {col} IS NOT NULL AND {col} != ''")
        n = cur.fetchone()[0]
        rows.append({"field": label, "count": n,
                     "pct": round(n / total * 100, 1) if total else 0})
    con.close()
    return pd.DataFrame(rows)


# ══════════════════════════════════════════════════════════════════════════════
# SCREENSHOT MANAGEMENT
# ══════════════════════════════════════════════════════════════════════════════

SS_DIR = BASE_DIR / "JOURNAL" / "screenshots"

def link_screenshot(trade_id: str, rel_path: str) -> tuple[bool, str]:
    """Save screenshot_path to trade. rel_path is relative to BASE_DIR."""
    return save_annotation(trade_id, {"screenshot_path": rel_path})

def find_screenshots_for_trade(symbol: str, date_str: str) -> list[Path]:
    """
    Discover screenshot files in JOURNAL/screenshots/YYYY/MM/DD/ that
    match the symbol name. date_str format: 'YYYY-MM-DD'.
    """
    if not date_str or len(date_str) < 10:
        return []
    year, month, day = date_str[:4], date_str[5:7], date_str[8:10]
    day_dir = SS_DIR / year / month / day
    if not day_dir.exists():
        return []
    sym_lower = symbol.lower()
    return sorted(
        f for f in day_dir.iterdir()
        if f.suffix.lower() in (".png", ".jpg", ".jpeg", ".gif", ".webp")
        and (sym_lower in f.name.lower() or not symbol)
    )

def list_screenshot_dates() -> list[str]:
    """Return sorted list of dates that have screenshot folders."""
    dates = []
    if not SS_DIR.exists():
        return dates
    for ydir in SS_DIR.iterdir():
        if not ydir.is_dir(): continue
        for mdir in ydir.iterdir():
            if not mdir.is_dir(): continue
            for ddir in mdir.iterdir():
                if ddir.is_dir():
                    dates.append(f"{ydir.name}-{mdir.name}-{ddir.name}")
    return sorted(dates, reverse=True)


# ══════════════════════════════════════════════════════════════════════════════
# EXPORT
# ══════════════════════════════════════════════════════════════════════════════

def export_annotations(output_path: Path | None = None) -> tuple[int, Path]:
    """
    Export annotated trades (emotional_state IS NOT NULL) to CSV.
    Returns (row_count, output_path).
    """
    if output_path is None:
        output_path = BASE_DIR / "DATA" / "exports" / f"annotations_{datetime.now():%Y%m%d_%H%M}.csv"
    output_path.parent.mkdir(parents=True, exist_ok=True)

    con = _con()
    df = pd.read_sql_query(
        """SELECT trade_id, open_time, close_time, symbol, strategy, direction,
                  session, regime, outcome, pnl_usd,
                  setup_type, emotional_state, plan_followed, entry_timing,
                  exit_reason, mistakes, execution_score, setup_quality,
                  confidence_level, session_bias, notes, screenshot_path
           FROM trades
           WHERE emotional_state IS NOT NULL OR setup_type IS NOT NULL
           ORDER BY open_time DESC""",
        con,
    )
    con.close()
    df.to_csv(output_path, index=False, encoding="utf-8")
    return len(df), output_path
