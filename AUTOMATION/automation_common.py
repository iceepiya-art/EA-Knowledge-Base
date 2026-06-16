"""
Shared helpers for QTrade OS safe semi-automation.

Allowed actions: import CSV data, refresh derived files, generate reports,
send informational alerts, and log automation actions.

Forbidden actions: trade entry, trade exit, lot increase, EA config changes,
live deployment, and risk override.
"""

from __future__ import annotations

import json
import logging
import sqlite3
import sys
from datetime import datetime, timedelta
from pathlib import Path
from typing import Any

import pandas as pd

BASE_DIR = Path(__file__).resolve().parents[1]
SYSTEM_CONFIG = BASE_DIR / "SYSTEM" / "config" / "system_config.json"
AUTOMATION_CONFIG = BASE_DIR / "SYSTEM" / "config" / "automation_config.json"
TELEGRAM_CONFIG = BASE_DIR / "SYSTEM" / "config" / "telegram_config.json"

FORBIDDEN_ACTIONS = {
    "trade_entry",
    "trade_exit",
    "lot_increase",
    "ea_config_change",
    "live_deployment",
    "risk_override",
}


def read_json(path: Path, default: dict | None = None) -> dict:
    if not path.exists():
        return default or {}
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def system_config() -> dict:
    return read_json(SYSTEM_CONFIG, {})


def automation_config() -> dict:
    return read_json(AUTOMATION_CONFIG, {})


def resolve_path(value: str | Path) -> Path:
    path = Path(value)
    if path.is_absolute():
        return path
    return BASE_DIR / path


def db_path() -> Path:
    cfg = system_config()
    return resolve_path(cfg.get("db", {}).get("trades_db", "DATA/processed/trades.sqlite"))


def connect_db() -> sqlite3.Connection:
    con = sqlite3.connect(db_path())
    con.row_factory = sqlite3.Row
    return con


def load_trades() -> pd.DataFrame:
    db = db_path()
    if not db.exists():
        return pd.DataFrame()
    con = connect_db()
    try:
        df = pd.read_sql_query("SELECT * FROM trades ORDER BY open_time", con)
    finally:
        con.close()
    if df.empty:
        return df
    for col in ("open_time", "close_time"):
        if col in df.columns:
            df[col] = pd.to_datetime(df[col], errors="coerce")
    for col in ("pnl_usd", "rr_actual", "duration_min", "lot_size"):
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")
    df["date"] = df["open_time"].dt.date
    df["week"] = df["open_time"].dt.strftime("%G-W%V")
    df["is_win"] = (df["outcome"] == "WIN").astype(int)
    return df


def setup_logging(name: str) -> logging.Logger:
    cfg = automation_config()
    log_dir = resolve_path(cfg.get("paths", {}).get("automation_logs", "AUTOMATION/logs"))
    log_dir.mkdir(parents=True, exist_ok=True)
    log_file = log_dir / f"{name}_{datetime.now():%Y-%m-%d}.log"

    logger = logging.getLogger(name)
    logger.setLevel(logging.INFO)
    logger.handlers.clear()
    logger.propagate = False
    fmt = logging.Formatter("%(asctime)s [%(levelname)s] %(message)s")

    fh = logging.FileHandler(log_file, encoding="utf-8")
    fh.setFormatter(fmt)
    logger.addHandler(fh)

    sh = logging.StreamHandler(sys.stdout)
    sh.setFormatter(fmt)
    logger.addHandler(sh)
    return logger


def log_action(logger: logging.Logger, action: str, status: str, details: dict[str, Any] | None = None) -> None:
    details = details or {}
    if action in FORBIDDEN_ACTIONS:
        raise RuntimeError(f"Forbidden automation action blocked: {action}")
    payload = {
        "ts": datetime.now().isoformat(timespec="seconds"),
        "action": action,
        "status": status,
        "details": details,
    }
    logger.info(json.dumps(payload, ensure_ascii=False))
    cfg = automation_config()
    log_dir = resolve_path(cfg.get("paths", {}).get("automation_logs", "AUTOMATION/logs"))
    log_dir.mkdir(parents=True, exist_ok=True)
    with open(log_dir / f"automation_actions_{datetime.now():%Y-%m-%d}.jsonl", "a", encoding="utf-8") as f:
        f.write(json.dumps(payload, ensure_ascii=False) + "\n")
    try:
        write_audit(action, status, details)
    except Exception as exc:
        logger.warning("audit_write_failed: %s", exc)


def ensure_dirs() -> list[Path]:
    cfg = automation_config()
    paths = cfg.get("paths", {})
    created = []
    for key in (
        "mt5_watch_folder",
        "daily_reports",
        "weekly_reports",
        "ea_reports",
        "risk_reports",
        "session_reports",
        "pair_reports",
        "obsidian_reports",
        "automation_state",
        "automation_logs",
    ):
        path = resolve_path(paths.get(key, "AUTOMATION"))
        path.mkdir(parents=True, exist_ok=True)
        created.append(path)
    return created


def ensure_audit_table() -> None:
    con = connect_db()
    try:
        con.execute("""
        CREATE TABLE IF NOT EXISTS automation_audit (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            logged_at DATETIME DEFAULT (datetime('now')),
            action TEXT NOT NULL,
            status TEXT NOT NULL,
            details TEXT
        )
        """)
        con.commit()
    finally:
        con.close()


def write_audit(action: str, status: str, details: dict[str, Any] | None = None) -> None:
    ensure_audit_table()
    con = connect_db()
    try:
        con.execute(
            "INSERT INTO automation_audit (action, status, details) VALUES (?, ?, ?)",
            (action, status, json.dumps(details or {}, ensure_ascii=False)),
        )
        con.commit()
    finally:
        con.close()


def summarize_trades(df: pd.DataFrame) -> dict[str, Any]:
    if df.empty:
        return {
            "trades": 0,
            "wins": 0,
            "losses": 0,
            "win_rate": None,
            "net_pnl": 0.0,
            "profit_factor": None,
            "expectancy": None,
        }
    wins = df[df["outcome"] == "WIN"]
    losses = df[df["outcome"] == "LOSS"]
    gross_win = float(wins["pnl_usd"].sum()) if not wins.empty else 0.0
    gross_loss = float(losses["pnl_usd"].sum()) if not losses.empty else 0.0
    total = int(len(df))
    return {
        "trades": total,
        "wins": int(len(wins)),
        "losses": int(len(losses)),
        "win_rate": round(len(wins) / total, 4) if total else None,
        "net_pnl": round(float(df["pnl_usd"].sum()), 2),
        "profit_factor": round(abs(gross_win / gross_loss), 3) if gross_loss else None,
        "expectancy": round(float(df["pnl_usd"].mean()), 2) if total else None,
    }


def current_loss_streak(df: pd.DataFrame) -> int:
    if df.empty or "outcome" not in df:
        return 0
    streak = 0
    for outcome in reversed(df["outcome"].tolist()):
        if outcome == "LOSS":
            streak += 1
        elif outcome in ("WIN", "BREAKEVEN"):
            break
    return streak


def week_bounds(now: datetime | None = None) -> tuple[datetime, datetime]:
    now = now or datetime.now()
    start = now - timedelta(days=now.weekday())
    start = start.replace(hour=0, minute=0, second=0, microsecond=0)
    end = start + timedelta(days=7)
    return start, end


def pct(value: Any) -> str:
    if value is None:
        return "n/a"
    return f"{float(value) * 100:.1f}%"
