"""
mt5_importer.py — Production MT5 Trade Import Pipeline v2.

Improvements over v1:
  1. Duplicate detection   — content fingerprint (open_time + symbol + dir + pnl)
  2. Incremental imports   — manifest table; skip unchanged files unless --force
  3. Session tagging       — broker-tz-aware UTC conversion, per-format override
  4. Direction tagging     — covers all MT5 export variants (type 0/1, buy stop, etc.)
  5. RR calculation        — rr_planned (levels) and rr_actual (achieved)
  6. Holding time          — close_time parsed from CSV; duration_min via DB GENERATED col
  7. Pair normalization     — broker suffix stripping, alias map (Gold → XAUUSD, etc.)
  8. Error logging         — per-row errors in DB (import_errors) and log file
  9. Import summary        — per-file stats + session/outcome breakdown

Usage:
  py -3.14 ANALYTICS/importers/mt5_importer.py --legacy
  py -3.14 ANALYTICS/importers/mt5_importer.py --all
  py -3.14 ANALYTICS/importers/mt5_importer.py --file path/to/trades.csv --strategy QField
  py -3.14 ANALYTICS/importers/mt5_importer.py --stats
"""

import hashlib
import json
import logging
import sqlite3
import sys
import argparse
import numpy as np
import pandas as pd
from pathlib import Path
from datetime import datetime

# ══════════════════════════════════════════════════════════════════════════════
# PATHS & CONFIG
# ══════════════════════════════════════════════════════════════════════════════

BASE_DIR = Path(__file__).resolve().parents[2]

def _load_cfg() -> dict:
    p = BASE_DIR / "SYSTEM" / "config" / "system_config.json"
    return json.load(open(p, encoding="utf-8")) if p.exists() else {}

CFG           = _load_cfg()
DB_PATH       = BASE_DIR / CFG.get("db", {}).get("trades_db", "DATA/processed/trades.sqlite")
EXPORT_FOLDER = BASE_DIR / CFG.get("paths", {}).get("mt5_export_folder", "DATA/raw/mt5_exports")

# ══════════════════════════════════════════════════════════════════════════════
# LOGGING
# ══════════════════════════════════════════════════════════════════════════════

LOG_DIR = BASE_DIR / "AUTOMATION" / "logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)
_log_file = LOG_DIR / f"import_{datetime.now():%Y-%m-%d}.log"

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.FileHandler(_log_file, encoding="utf-8"),
        logging.StreamHandler(sys.stdout),
    ],
)
log = logging.getLogger("mt5_importer")

# ══════════════════════════════════════════════════════════════════════════════
# CONSTANTS
# ══════════════════════════════════════════════════════════════════════════════

# Broker server is EET = UTC+2 (winter) or UTC+3 (summer DST).
# Session windows are defined in UTC — offset applied before classification.
DEFAULT_BROKER_TZ = 2  # hours ahead of UTC

_SESSIONS_UTC = [
    ("Asian",     0,  8),
    ("London",    8, 13),
    ("Pre_NY",   13, 14),
    ("London_NY",14, 15),
    ("NY",       15, 20),
]

# Broker suffix / alias → canonical symbol (all keys uppercase)
_SYMBOL_MAP = {
    "GOLD":     "XAUUSD",  "XAUUSD.":  "XAUUSD",  "XAUUSDM": "XAUUSD",
    "XAUUSD_":  "XAUUSD",  "XAUUSDSB": "XAUUSD",  "SILVER":  "XAGUSD",
    "US500":    "SPX500",  "US30":     "DJ30",     "NAS100":  "NQ",
    "USTEC":    "NQ",      "BRENT":    "UKOIL",    "WTI":     "USOIL",
    "BTCUSD.":  "BTCUSD",
}

# Pip size in price units (used for pnl_pips; not for SL/TP distance)
_PIP_SIZE = {
    "XAUUSD": 0.01, "XAGUSD": 0.001,
    "EURUSD": 0.0001, "GBPUSD": 0.0001, "USDJPY": 0.01,
    "AUDUSD": 0.0001, "NZDUSD": 0.0001, "USDCAD": 0.0001,
    "USDCHF": 0.0001, "EURGBP": 0.0001, "EURJPY": 0.01,
    "NQ": 0.25, "SPX500": 0.1, "DJ30": 1.0,
    "UKOIL": 0.001, "USOIL": 0.001, "BTCUSD": 1.0,
}

# Direction aliases — covers all MT5 export variants
_DIR_MAP = {
    "BUY": "BUY",  "LONG": "BUY",  "B": "BUY",  "L": "BUY",
    "0":   "BUY",                                              # MT5 type 0
    "BUY STOP": "BUY", "BUY LIMIT": "BUY", "BUY STOP LIMIT": "BUY",
    "SELL": "SELL", "SHORT": "SELL", "S": "SELL",
    "1":    "SELL",                                            # MT5 type 1
    "SELL STOP": "SELL", "SELL LIMIT": "SELL", "SELL STOP LIMIT": "SELL",
}

# DB columns written during upsert
_TRADE_COLS = [
    "trade_id", "source", "symbol", "strategy", "direction", "session",
    "open_time", "close_time",
    "entry_price", "sl_price", "tp_price", "close_price",
    "rr_planned", "rr_actual", "pnl_pips",
    "lot_size", "pnl_usd", "pnl_pct", "outcome",
    "regime", "sc100_value", "beta1_value",
    "rsi_at_entry", "sma50_at_entry",
    "balance_at_open", "cycle",
]

_UPSERT_SQL = f"""
INSERT INTO trades ({",".join(_TRADE_COLS)})
VALUES ({",".join(":" + c for c in _TRADE_COLS)})
ON CONFLICT(trade_id) DO UPDATE SET
    close_time  = COALESCE(excluded.close_time,  trades.close_time),
    close_price = COALESCE(excluded.close_price, trades.close_price),
    rr_actual   = COALESCE(excluded.rr_actual,   trades.rr_actual),
    pnl_pips    = COALESCE(excluded.pnl_pips,    trades.pnl_pips),
    regime      = COALESCE(excluded.regime,      trades.regime),
    sc100_value = COALESCE(excluded.sc100_value, trades.sc100_value),
    beta1_value = COALESCE(excluded.beta1_value, trades.beta1_value),
    updated_at  = datetime('now')
"""

# ══════════════════════════════════════════════════════════════════════════════
# SCHEMA MIGRATIONS  (safe to run on every import)
# ══════════════════════════════════════════════════════════════════════════════

def _run_migrations(con: sqlite3.Connection) -> None:
    con.executescript("""
    CREATE TABLE IF NOT EXISTS import_manifest (
        id            INTEGER PRIMARY KEY AUTOINCREMENT,
        file_path     TEXT    NOT NULL,
        file_size     INTEGER,
        file_mtime    TEXT,
        file_hash     TEXT    NOT NULL,
        imported_at   DATETIME DEFAULT (datetime('now')),
        rows_read     INTEGER DEFAULT 0,
        rows_parsed   INTEGER DEFAULT 0,
        rows_inserted INTEGER DEFAULT 0,
        rows_updated  INTEGER DEFAULT 0,
        rows_skipped  INTEGER DEFAULT 0,
        strategy      TEXT,
        symbol        TEXT
    );
    CREATE TABLE IF NOT EXISTS import_errors (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        logged_at   DATETIME DEFAULT (datetime('now')),
        file_path   TEXT,
        row_num     INTEGER,
        trade_id    TEXT,
        error_type  TEXT,
        error_msg   TEXT,
        raw_data    TEXT
    );
    """)
    # Add pnl_pips / rr_actual if the trades table predates v2
    for col, dtype in [("pnl_pips", "REAL"), ("rr_actual", "REAL")]:
        try:
            con.execute(f"ALTER TABLE trades ADD COLUMN {col} {dtype}")
        except sqlite3.OperationalError:
            pass
    con.commit()

# ══════════════════════════════════════════════════════════════════════════════
# UTILITY FUNCTIONS
# ══════════════════════════════════════════════════════════════════════════════

def _safe_float(v, default=None):
    try:
        f = float(v)
        return None if f != f else f  # NaN → None
    except Exception:
        return default

def _safe_int(v, default=None):
    try:
        return int(float(v))
    except Exception:
        return default

def _norm_symbol(raw: str) -> str:
    s = str(raw).strip().upper().rstrip(".")
    return _SYMBOL_MAP.get(s, s)

def _norm_direction(raw) -> str | None:
    return _DIR_MAP.get(str(raw).strip().upper())

def _norm_outcome(raw, pnl: float) -> str:
    if raw:
        r = str(raw).strip().upper()
        if r in ("WIN","W","PROFIT","WINNER","1"):   return "WIN"
        if r in ("LOSS","L","LOSE","LOSER","-1"):    return "LOSS"
        if r in ("BE","BREAKEVEN","0"):              return "BREAKEVEN"
    if pnl >  0.001: return "WIN"
    if pnl < -0.001: return "LOSS"
    return "BREAKEVEN"

def _norm_regime(raw) -> str | None:
    if raw is None: return None
    if isinstance(raw, float) and raw != raw: return None
    return {
        "TRENDING":"TRENDING","TREND":"TRENDING",
        "REVERTING":"REVERTING","REVERT":"REVERTING","MEAN":"REVERTING",
        "WEAK":"WEAK","CRASH":"CRASH",
    }.get(str(raw).strip().upper(), "UNKNOWN")

def _detect_session(dt: datetime, broker_tz: int = DEFAULT_BROKER_TZ) -> str:
    utc_frac = ((dt.hour - broker_tz) % 24) + dt.minute / 60
    for name, start, end in _SESSIONS_UTC:
        if start <= utc_frac < end:
            return name
    return "Other"

def _resolve_sl_tp(sl_raw, tp_raw, entry: float, direction: str) -> tuple:
    """Return (sl_price, tp_price) as absolute price levels.
    Distinguishes point-offset values from already-absolute prices using the
    heuristic: if |raw - entry| / entry < 0.05 the value is a price, else points."""
    sl_price = tp_price = None
    if sl_raw and entry > 0:
        if abs(sl_raw - entry) / entry < 0.05:
            sl_price = sl_raw  # already a price
        else:
            sl_price = (entry - sl_raw) if direction == "BUY" else (entry + sl_raw)
    if tp_raw and entry > 0:
        if abs(tp_raw - entry) / entry < 0.10:
            tp_price = tp_raw  # already a price
        else:
            tp_price = (entry + tp_raw) if direction == "BUY" else (entry - tp_raw)
    return sl_price, tp_price

def _compute_rr_planned(entry: float, sl: float, tp: float, direction: str):
    if not (entry and sl and tp): return None
    sl_d = (entry - sl) if direction == "BUY" else (sl - entry)
    tp_d = (tp - entry) if direction == "BUY" else (entry - tp)
    return round(tp_d / sl_d, 2) if sl_d > 0 else None

def _compute_rr_actual(entry: float, close: float, sl: float, direction: str):
    if not (entry and close and sl): return None
    sl_d = (entry - sl) if direction == "BUY" else (sl - entry)
    hit  = (close - entry) if direction == "BUY" else (entry - close)
    return round(hit / sl_d, 2) if sl_d > 0 else None

def _compute_pnl_pips(entry: float, close: float, direction: str, symbol: str):
    if not (entry and close): return None
    pip  = _PIP_SIZE.get(symbol, 0.0001)
    sign = 1 if direction == "BUY" else -1
    return round(sign * (close - entry) / pip, 1)

def _make_trade_id(row: dict, idx: int) -> str:
    sym   = row.get("symbol", "XX")
    t     = str(row.get("open_time", ""))[:16].replace("-","").replace(" ","T").replace(":","")
    d     = str(row.get("direction", "X"))[:1]
    strat = str(row.get("strategy", "?"))[:8].replace(" ","")
    return f"AUTO-{sym}-{t}-{d}-{strat}-{idx:05d}"

def _fingerprint(row: dict) -> str:
    """16-char hex fingerprint for duplicate detection across imports."""
    key = "|".join([
        str(row.get("open_time", ""))[:16],
        str(row.get("symbol", "")),
        str(row.get("direction", "")),
        f"{float(row.get('pnl_usd') or 0):.4f}",
    ])
    return hashlib.sha256(key.encode()).hexdigest()[:16]

def _file_hash(path: Path) -> str:
    h = hashlib.md5()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(65536), b""):
            h.update(chunk)
    return h.hexdigest()

# ══════════════════════════════════════════════════════════════════════════════
# FORMAT DETECTION
# ══════════════════════════════════════════════════════════════════════════════

def detect_format(df: pd.DataFrame) -> str:
    cols = {c.lower().strip() for c in df.columns}
    if "sc100" in cols and "beta1" in cols:            return "fix20"
    if "open time" in cols and "close time" in cols:   return "mt5_native"
    if "session" in cols and "month" in cols:          return "ftmo"
    return "basic"

def _is_trade_csv(df: pd.DataFrame) -> bool:
    """Reject aggregate/summary CSVs that have no trade-level time or PnL columns."""
    cols = {c.lower().strip() for c in df.columns}
    has_time   = bool(cols & {"date", "time", "open time", "open_time"})
    has_result = bool(cols & {"pnl", "profit", "result", "outcome", "pnl_usd"})
    return has_time and has_result

# ══════════════════════════════════════════════════════════════════════════════
# PARSER
# ══════════════════════════════════════════════════════════════════════════════

def _extract_times(r: dict) -> tuple[datetime, datetime]:
    """Try multiple column names for open/close datetimes."""
    # Open time
    for combo in [("date","time"), ("open_date","open_time")]:
        a, b = combo
        if a in r and b in r:
            open_dt = pd.to_datetime(f"{r[a]} {r[b]}")
            break
    else:
        for col in ("open time", "open_time", "time"):
            if col in r and str(r[col]).strip() not in ("","nan","None"):
                open_dt = pd.to_datetime(r[col]); break
        else:
            raise ValueError("No open_time column")

    # Close time (try several names; fall back to open_dt)
    for col in ("close time", "close_time", "exit_time"):
        v = r.get(col)
        if v and str(v).strip() not in ("","nan","None"):
            try:
                return open_dt, pd.to_datetime(v)
            except Exception:
                pass

    # close_date + close_time as two separate columns
    if "close_date" in r and "close_time_col" in r:
        try:
            return open_dt, pd.to_datetime(f"{r['close_date']} {r['close_time_col']}")
        except Exception:
            pass

    return open_dt, open_dt  # no close data — set equal to open

def parse_file(
    df: pd.DataFrame,
    strategy: str,
    symbol: str,
    broker_tz: int = DEFAULT_BROKER_TZ,
) -> tuple[list[dict], list[dict]]:
    """
    Universal parser for all supported CSV formats.
    Returns (parsed_rows, error_records).
    Each parsed row has a '_fp' (fingerprint) and '_row_num' key.
    """
    fmt = detect_format(df)
    if fmt == "mt5_native":
        df = df.copy()
        df.columns = [c.lower().strip() for c in df.columns]

    parsed, errors = [], []

    for i, raw_row in df.iterrows():
        r = raw_row.to_dict()
        try:
            open_dt, close_dt = _extract_times(r)

            # Symbol — CSV column wins over CLI argument
            sym = _norm_symbol(str(r.get("symbol", symbol) or symbol))

            # Direction
            dir_raw  = r.get("dir", r.get("type", r.get("direction", r.get("action", ""))))
            dirn     = _norm_direction(dir_raw)
            if dirn is None:
                # Last-resort heuristic: positive PnL + close > open → BUY
                p = _safe_float(r.get("pnl", r.get("profit", 0)), 0)
                dirn = "BUY" if p >= 0 else "SELL"

            # Prices
            entry  = _safe_float(
                r.get("close", r.get("open price", r.get("entry_price", r.get("price", 0)))), 0
            ) or 0.0
            close_ = _safe_float(
                r.get("close_price", r.get("close price", None)), entry
            ) or entry

            # SL / TP
            sl_raw = _safe_float(
                r.get("sl_pts", r.get("sl", r.get("s / l", r.get("sl_price", 0)))), 0
            ) or 0.0
            tp_raw = _safe_float(
                r.get("tp_pts", r.get("tp", r.get("t / p", r.get("tp_price", 0)))), 0
            ) or 0.0
            sl_price, tp_price = _resolve_sl_tp(sl_raw or None, tp_raw or None, entry, dirn)

            # PnL
            pnl = _safe_float(r.get("pnl", r.get("profit", 0)), 0)

            # Session: prefer explicit CSV value, then derive from open_time
            sess_raw = r.get("session", "")
            session  = (
                str(sess_raw).strip()
                if sess_raw and str(sess_raw).strip().lower() not in ("", "nan", "none")
                else _detect_session(open_dt, broker_tz)
            )

            # Derived metrics
            rr_plan = _compute_rr_planned(entry, sl_price, tp_price, dirn)
            rr_act  = _compute_rr_actual(entry, close_, sl_price, dirn)
            pips    = _compute_pnl_pips(entry, close_, dirn, sym)

            bal = _safe_float(r.get("equity", r.get("balance", 50000)), 50000)

            row = dict(
                source          = "mt5",
                symbol          = sym,
                strategy        = strategy,
                direction       = dirn,
                session         = session,
                open_time       = open_dt.isoformat(),
                close_time      = close_dt.isoformat(),
                entry_price     = entry,
                sl_price        = sl_price,
                tp_price        = tp_price,
                close_price     = close_,
                rr_planned      = rr_plan,
                rr_actual       = rr_act,
                pnl_pips        = pips,
                lot_size        = _safe_float(r.get("volume", r.get("lot_size", 0.01)), 0.01),
                pnl_usd         = pnl,
                pnl_pct         = _safe_float(r.get("pnl_pct")),
                outcome         = _norm_outcome(r.get("result", r.get("outcome", "")), pnl),
                regime          = _norm_regime(r.get("regime")),
                sc100_value     = _safe_float(r.get("sc100")),
                beta1_value     = _safe_float(r.get("beta1")),
                rsi_at_entry    = _safe_float(r.get("rsi")),
                sma50_at_entry  = _safe_float(r.get("sma50")),
                balance_at_open = (bal - pnl) if bal else None,
                cycle           = _safe_int(r.get("cycle")),
            )
            row["trade_id"] = _make_trade_id(row, i)
            row["_fp"]      = _fingerprint(row)
            row["_row_num"] = i
            parsed.append(row)

        except Exception as e:
            errors.append({
                "row_num":    i,
                "error_type": "PARSE_ERROR",
                "error_msg":  str(e),
                "raw_data":   json.dumps(
                    {k: str(v) for k, v in r.items()}, ensure_ascii=False
                )[:500],
            })

    return parsed, errors

# ══════════════════════════════════════════════════════════════════════════════
# VALIDATION
# ══════════════════════════════════════════════════════════════════════════════

def validate_row(row: dict) -> tuple[bool, list[str]]:
    """Hard validation — invalid rows are skipped and logged."""
    errs = []
    if not row.get("open_time"):                     errs.append("missing open_time")
    if not row.get("symbol"):                        errs.append("missing symbol")
    if row.get("direction") not in ("BUY","SELL"):   errs.append(f"bad direction: {row.get('direction')!r}")
    if row.get("outcome") not in ("WIN","LOSS","BREAKEVEN"):
        errs.append(f"bad outcome: {row.get('outcome')!r}")
    if row.get("pnl_usd") is None:                   errs.append("missing pnl_usd")
    if (row.get("entry_price") or 0) < 0:            errs.append("negative entry_price")
    if (row.get("lot_size") or 0) < 0:               errs.append("negative lot_size")
    return len(errs) == 0, errs

# ══════════════════════════════════════════════════════════════════════════════
# DATABASE  —  MANIFEST, ERRORS, UPSERT
# ══════════════════════════════════════════════════════════════════════════════

def _known_fingerprints(con: sqlite3.Connection) -> set:
    """Load existing fingerprints to detect cross-file duplicates."""
    try:
        rows = con.execute(
            "SELECT open_time, symbol, direction, pnl_usd FROM trades"
        ).fetchall()
        fps = set()
        for ot, sym, dirn, pnl in rows:
            key = "|".join([
                str(ot)[:16], str(sym), str(dirn), f"{float(pnl or 0):.4f}"
            ])
            fps.add(hashlib.sha256(key.encode()).hexdigest()[:16])
        return fps
    except Exception:
        return set()

def _was_imported(con: sqlite3.Connection, fhash: str) -> bool:
    row = con.execute(
        "SELECT id FROM import_manifest WHERE file_hash = ?", (fhash,)
    ).fetchone()
    return row is not None

def _record_manifest(con: sqlite3.Connection, path: Path, fhash: str, result: dict) -> None:
    stat = path.stat()
    con.execute(
        """INSERT INTO import_manifest
           (file_path, file_size, file_mtime, file_hash,
            rows_read, rows_parsed, rows_inserted, rows_updated, rows_skipped,
            strategy, symbol)
           VALUES (?,?,?,?,?,?,?,?,?,?,?)""",
        (
            str(path), stat.st_size,
            datetime.fromtimestamp(stat.st_mtime).isoformat(),
            fhash,
            result["rows_read"],  result["rows_parsed"],
            result["inserted"],   result["updated"],
            result["skipped_dup"] + result["skipped_invalid"],
            result["strategy"],   result["symbol"],
        ),
    )
    con.commit()

def _log_errors_to_db(con: sqlite3.Connection, path: Path, errors: list[dict]) -> None:
    if not errors: return
    con.executemany(
        """INSERT INTO import_errors
           (file_path, row_num, trade_id, error_type, error_msg, raw_data)
           VALUES (?,?,?,?,?,?)""",
        [
            (str(path), e.get("row_num"), e.get("trade_id"),
             e["error_type"], e["error_msg"], e.get("raw_data"))
            for e in errors
        ],
    )
    con.commit()

def _upsert_batch(
    con: sqlite3.Connection,
    rows: list[dict],
    known_fps: set,
    file_path: Path,
) -> tuple[int, int, int, int, set, list[dict]]:
    """
    Insert or update rows. Returns (inserted, updated, skipped_dup, skipped_invalid,
    new_known_fps, db_errors).
    """
    inserted = updated = skipped_dup = skipped_invalid = 0
    db_errors: list[dict] = []
    new_fps = set()

    cur = con.cursor()

    for row in rows:
        fp = row["_fp"]

        # ── 1. Content-fingerprint duplicate check ─────────────────────────
        if fp in known_fps:
            skipped_dup += 1
            continue  # expected — not an error

        # ── 2. Validation ──────────────────────────────────────────────────
        valid, val_errs = validate_row(row)
        if not valid:
            skipped_invalid += 1
            db_errors.append({
                "row_num": row["_row_num"], "trade_id": row.get("trade_id"),
                "error_type": "VALIDATION_ERROR",
                "error_msg": "; ".join(val_errs),
                "raw_data": None,
            })
            continue

        # ── 3. Check if trade_id already exists (→ UPDATE vs INSERT) ───────
        exists = cur.execute(
            "SELECT id FROM trades WHERE trade_id=?", (row["trade_id"],)
        ).fetchone()

        # ── 4. Upsert ──────────────────────────────────────────────────────
        params = {c: row.get(c) for c in _TRADE_COLS}
        try:
            cur.execute(_UPSERT_SQL, params)
            if exists: updated += 1
            else:      inserted += 1
            known_fps.add(fp)
            new_fps.add(fp)
        except sqlite3.Error as e:
            db_errors.append({
                "row_num": row["_row_num"], "trade_id": row.get("trade_id"),
                "error_type": "DB_ERROR",
                "error_msg": str(e),
                "raw_data": None,
            })

    con.commit()
    return inserted, updated, skipped_dup, skipped_invalid, new_fps, db_errors

# ══════════════════════════════════════════════════════════════════════════════
# PUBLIC API
# ══════════════════════════════════════════════════════════════════════════════

def import_csv(
    path: Path,
    strategy: str = "Unknown",
    symbol:   str = "XAUUSD",
    force:    bool = False,
    broker_tz: int = DEFAULT_BROKER_TZ,
) -> dict:
    """
    Import a single CSV file. Returns a result dict with full stats.
    Skips the file if it was already imported (same content hash) unless force=True.
    """
    result = dict(
        file=str(path.name), strategy=strategy, symbol=symbol,
        rows_read=0, rows_parsed=0,
        inserted=0, updated=0, skipped_dup=0, skipped_invalid=0,
        parse_errors=0, db_errors=0,
        outcome_counts={}, session_counts={},
        skipped_file=False, error=None,
    )

    if not path.exists():
        result["error"] = "File not found"
        log.warning(f"Not found: {path}")
        return result

    fhash = _file_hash(path)
    con   = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    _run_migrations(con)

    # ── Incremental: skip if already imported ──────────────────────────────
    if not force and _was_imported(con, fhash):
        log.info(f"SKIP (already imported): {path.name}")
        result["skipped_file"] = True
        con.close()
        return result

    # ── Load CSV ───────────────────────────────────────────────────────────
    log.info(f"Importing: {path.name}")
    try:
        df_raw = pd.read_csv(path)
    except Exception as e:
        result["error"] = f"CSV read error: {e}"
        log.error(f"Cannot read {path}: {e}")
        con.close()
        return result

    result["rows_read"] = len(df_raw)
    fmt = detect_format(df_raw)
    log.info(f"  {len(df_raw)} rows | format: {fmt}")

    if not _is_trade_csv(df_raw):
        log.warning(f"  {path.name}: no trade columns — aggregate/summary file, skipping")
        result["error"] = "Not a trade-level CSV (no date/pnl columns)"
        con.close()
        return result

    # ── Parse ──────────────────────────────────────────────────────────────
    parsed, parse_errors = parse_file(df_raw, strategy, symbol, broker_tz)
    result["rows_parsed"]  = len(parsed)
    result["parse_errors"] = len(parse_errors)

    if parse_errors:
        log.warning(f"  {len(parse_errors)} row(s) failed to parse")

    # ── Deduplicate & upsert ───────────────────────────────────────────────
    known_fps = _known_fingerprints(con)
    ins, upd, s_dup, s_inv, new_fps, db_errs = _upsert_batch(con, parsed, known_fps, path)

    result.update(
        inserted=ins, updated=upd,
        skipped_dup=s_dup, skipped_invalid=s_inv,
        db_errors=len(db_errs),
    )

    # ── Count outcomes & sessions for newly inserted rows only ─────────────
    for row in parsed:
        if row["_fp"] in new_fps:  # newly inserted in this run
            result["outcome_counts"][row.get("outcome","?")] = \
                result["outcome_counts"].get(row.get("outcome","?"), 0) + 1
            result["session_counts"][row.get("session","?")] = \
                result["session_counts"].get(row.get("session","?"), 0) + 1

    # ── Log errors to DB ───────────────────────────────────────────────────
    all_errors = parse_errors + db_errs
    _log_errors_to_db(con, path, all_errors)

    # ── Record manifest ────────────────────────────────────────────────────
    _record_manifest(con, path, fhash, result)
    con.close()

    log.info(f"  Inserted: {ins} | Updated: {upd} | "
             f"Dup: {s_dup} | Invalid: {s_inv} | Errors: {len(all_errors)}")
    return result


def import_all(strategy: str = "Unknown", symbol: str = "XAUUSD", force: bool = False) -> list[dict]:
    csvs = sorted(EXPORT_FOLDER.glob("*.csv"))
    log.info(f"Found {len(csvs)} CSV(s) in {EXPORT_FOLDER}")
    results = [import_csv(p, strategy, symbol, force=force) for p in csvs]
    return results


_LEGACY_FILES = [
    ("trades_M1.csv",       "QField", "XAUUSD"),
    ("trades_M5.csv",       "QField", "XAUUSD"),
    ("trades_M15.csv",      "QField", "XAUUSD"),
    ("trades_M30.csv",      "QField", "XAUUSD"),
    ("trades_H1.csv",       "QField", "XAUUSD"),
    ("ftmo_trades.csv",     "FTMO",   "XAUUSD"),
    ("ea_fix20_trades.csv", "QField", "XAUUSD"),
    ("trades_log.csv",      "Manual", "XAUUSD"),
    ("summary_1yr.csv",     "QField", "XAUUSD"),
    ("multitf_summary.csv", "QField", "XAUUSD"),
]

def import_legacy(force: bool = False) -> list[dict]:
    results = []
    for fname, strat, sym in _LEGACY_FILES:
        p = BASE_DIR / fname
        results.append(import_csv(p, strategy=strat, symbol=sym, force=force))
    return results

# ══════════════════════════════════════════════════════════════════════════════
# SUMMARY REPORT
# ══════════════════════════════════════════════════════════════════════════════

def print_summary(results: list[dict]) -> None:
    W   = 62
    SEP = "=" * W
    sep = "-" * W

    total_ins = sum(r["inserted"]        for r in results)
    total_upd = sum(r["updated"]         for r in results)
    total_dup = sum(r["skipped_dup"]     for r in results)
    total_inv = sum(r["skipped_invalid"] for r in results)
    total_pe  = sum(r["parse_errors"]    for r in results)
    total_de  = sum(r["db_errors"]       for r in results)
    total_skf = sum(1 for r in results if r.get("skipped_file"))

    print(f"\n{SEP}")
    print(f"  QTrade OS -- Import Summary  {datetime.now():%Y-%m-%d %H:%M}")
    print(SEP)

    # Per-file table
    print(f"  {'File':<32} {'Read':>5} {'In':>5} {'Up':>4} {'Dup':>4} {'Err':>4}")
    print(f"  {sep}")
    for r in results:
        if r.get("skipped_file"):
            print(f"  {r['file']:<32}  skip (unchanged)")
            continue
        if r.get("error"):
            err = r["error"][:28]
            print(f"  {r['file']:<32}  SKIP: {err}")
            continue
        print(
            f"  {r['file']:<32}"
            f" {r['rows_read']:>5}"
            f" {r['inserted']:>5}"
            f" {r['updated']:>4}"
            f" {r['skipped_dup']:>4}"
            f" {r['parse_errors']+r['db_errors']:>4}"
        )

    print(f"  {sep}")
    print(f"  {'TOTAL':<32}       {total_ins:>5} {total_upd:>4} {total_dup:>4} {total_pe+total_de:>4}")

    # Aggregate counters
    print(f"\n  Inserted       : {total_ins:,}")
    print(f"  Updated        : {total_upd:,}")
    print(f"  Skipped (dup)  : {total_dup:,}")
    print(f"  Skipped (inv)  : {total_inv:,}")
    print(f"  Files skipped  : {total_skf}")
    print(f"  Parse errors   : {total_pe:,}")
    print(f"  DB errors      : {total_de:,}")

    # Outcome & session breakdown from inserted rows
    outcomes, sessions = {}, {}
    for r in results:
        for k, v in r.get("outcome_counts", {}).items():
            outcomes[k] = outcomes.get(k, 0) + v
        for k, v in r.get("session_counts", {}).items():
            sessions[k] = sessions.get(k, 0) + v

    if outcomes:
        total_o = sum(outcomes.values()) or 1
        print(f"\n  Outcome breakdown (inserted trades):")
        for k in ("WIN", "LOSS", "BREAKEVEN"):
            n   = outcomes.get(k, 0)
            bar = "#" * int(n / total_o * 20)
            print(f"    {k:<12} {n:>5}  {bar}")

    if sessions:
        total_s = sum(sessions.values()) or 1
        print(f"\n  Session breakdown (inserted trades):")
        for k, n in sorted(sessions.items(), key=lambda x: -x[1]):
            bar = "#" * int(n / total_s * 20)
            print(f"    {k:<12} {n:>5}  {bar}")

    if total_pe + total_de > 0:
        print(f"\n  WARN: {total_pe+total_de} error(s) logged -> {_log_file.name}")
        print(f"        Also stored in: import_errors table (DB)")

    print(f"{SEP}\n")

    # Save summary to log file
    summary_path = LOG_DIR / f"import_summary_{datetime.now():%Y-%m-%d}.txt"
    with open(summary_path, "a", encoding="utf-8") as f:
        f.write(f"\n{'='*W}\n")
        f.write(f"Import run: {datetime.now():%Y-%m-%d %H:%M:%S}\n")
        f.write(f"Inserted: {total_ins} | Updated: {total_upd} | "
                f"Dup: {total_dup} | Invalid: {total_inv} | Errors: {total_pe+total_de}\n")
        for r in results:
            if not r.get("skipped_file") and not r.get("error"):
                f.write(f"  {r['file']}: +{r['inserted']} ={r['updated']}\n")


def print_stats() -> None:
    if not DB_PATH.exists():
        print("Database not found. Run ANALYTICS/setup_db.py first.")
        return
    con = sqlite3.connect(DB_PATH)
    cur = con.cursor()
    cur.execute("SELECT COUNT(*) FROM trades")
    total = cur.fetchone()[0]
    cur.execute("SELECT outcome, COUNT(*) FROM trades GROUP BY outcome ORDER BY outcome")
    by_outcome = cur.fetchall()
    cur.execute("SELECT strategy, COUNT(*) FROM trades GROUP BY strategy ORDER BY COUNT(*) DESC LIMIT 5")
    by_strat   = cur.fetchall()
    cur.execute("SELECT COUNT(*) FROM import_manifest") if con.execute(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='import_manifest'"
    ).fetchone() else None
    con.close()

    print(f"\n  Trades in DB : {total:,}")
    for outcome, n in by_outcome:
        print(f"    {outcome:<12}: {n:,}")
    print(f"  By strategy  :")
    for strat, n in by_strat:
        print(f"    {strat:<20}: {n:,}")
    print()

# ══════════════════════════════════════════════════════════════════════════════
# CLI
# ══════════════════════════════════════════════════════════════════════════════

if __name__ == "__main__":
    ap = argparse.ArgumentParser(description="MT5 Trade Importer v2")
    ap.add_argument("--file",      help="Import single CSV file path")
    ap.add_argument("--all",       action="store_true", help="Import all CSVs from mt5_exports/")
    ap.add_argument("--legacy",    action="store_true", help="Import existing vault CSV files")
    ap.add_argument("--stats",     action="store_true", help="Print DB trade counts")
    ap.add_argument("--force",     action="store_true", help="Re-import even if file unchanged")
    ap.add_argument("--strategy",  default="Unknown", help="Strategy tag override")
    ap.add_argument("--symbol",    default="XAUUSD",  help="Symbol override (default XAUUSD)")
    ap.add_argument("--broker-tz", type=int, default=DEFAULT_BROKER_TZ,
                    help=f"Broker server UTC offset in hours (default {DEFAULT_BROKER_TZ})")
    args = ap.parse_args()

    if args.stats:
        print_stats()

    elif args.file:
        r = import_csv(Path(args.file), args.strategy, args.symbol,
                       force=args.force, broker_tz=args.broker_tz)
        print_summary([r])
        print_stats()

    elif args.all:
        results = import_all(args.strategy, args.symbol, force=args.force)
        print_summary(results)
        print_stats()

    elif args.legacy:
        results = import_legacy(force=args.force)
        print_summary(results)
        print_stats()

    else:
        ap.print_help()
