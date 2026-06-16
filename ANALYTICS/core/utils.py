"""
utils.py — Shared helpers: DB load, sidebar filters, formatters, group stats.
"""

import sqlite3
import json
import os
import pandas as pd
import numpy as np
import streamlit as st
from pathlib import Path
from datetime import datetime, timedelta, date

# ── Root path (works regardless of working directory) ─────────────────────────
BASE_DIR = Path(__file__).resolve().parents[2]   # EA-Knowledge-Base/

def _load_cfg():
    p = BASE_DIR / "SYSTEM" / "config" / "system_config.json"
    if p.exists():
        with open(p, encoding="utf-8") as f:
            return json.load(f)
    return {}

CFG     = _load_cfg()
DB_PATH = BASE_DIR / CFG.get("db", {}).get("trades_db", "DATA/processed/trades.sqlite")

# ── Colors ─────────────────────────────────────────────────────────────────────
C_WIN     = "#26a69a"
C_LOSS    = "#ef5350"
C_BE      = "#bdbdbd"
C_PRIMARY = "#5c6bc0"

REGIME_COLORS = {
    "TRENDING":  "#26a69a",
    "REVERTING": "#5c6bc0",
    "WEAK":      "#ffa726",
    "CRASH":     "#ef5350",
    "UNKNOWN":   "#bdbdbd",
}

# ── Data load (cached 5 min) ───────────────────────────────────────────────────
@st.cache_data(ttl=300, show_spinner="Loading trades…")
def load_trades() -> pd.DataFrame:
    if not DB_PATH.exists():
        return pd.DataFrame()
    try:
        con = sqlite3.connect(DB_PATH)
        df  = pd.read_sql_query(
            "SELECT * FROM trades ORDER BY open_time", con
        )
        con.close()
    except Exception as e:
        st.error(f"DB read error: {e}")
        return pd.DataFrame()

    if df.empty:
        return df

    for col in ("open_time", "close_time"):
        if col in df.columns:
            df[col] = pd.to_datetime(df[col], errors="coerce")

    for col in ("pnl_usd", "lot_size", "rr_planned", "rr_actual",
                "sc100_value", "beta1_value", "execution_score",
                "setup_quality", "duration_min"):
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")

    # Derived columns
    df["date"]      = df["open_time"].dt.date
    df["week"]      = df["open_time"].dt.to_period("W").astype(str)
    df["month"]     = df["open_time"].dt.to_period("M").astype(str)
    df["month_dt"]  = df["open_time"].dt.to_period("M").dt.to_timestamp()
    df["trade_num"] = range(1, len(df) + 1)
    df["cum_pnl"]   = df["pnl_usd"].cumsum()
    df["peak"]      = df["cum_pnl"].cummax()
    df["drawdown"]  = df["cum_pnl"] - df["peak"]
    df["is_win"]    = (df["outcome"] == "WIN").astype(int)
    df["color"]     = df["outcome"].map(
        {"WIN": C_WIN, "LOSS": C_LOSS, "BREAKEVEN": C_BE}
    ).fillna(C_BE)
    return df


# ── Sidebar filters ────────────────────────────────────────────────────────────
def sidebar_filters(df: pd.DataFrame) -> pd.DataFrame:
    if df.empty:
        return df

    st.sidebar.header("Filters")

    min_d = df["date"].min()
    max_d = df["date"].max()
    default_start = max(min_d, max_d - timedelta(days=90))

    dates = st.sidebar.date_input(
        "Date range", value=(default_start, max_d),
        min_value=min_d, max_value=max_d,
    )
    if isinstance(dates, (list, tuple)) and len(dates) == 2:
        df = df[(df["date"] >= dates[0]) & (df["date"] <= dates[1])]

    strats = ["All"] + sorted(df["strategy"].dropna().unique().tolist())
    s = st.sidebar.selectbox("Strategy", strats)
    if s != "All":
        df = df[df["strategy"] == s]

    syms = ["All"] + sorted(df["symbol"].dropna().unique().tolist())
    sym = st.sidebar.selectbox("Symbol", syms)
    if sym != "All":
        df = df[df["symbol"] == sym]

    st.sidebar.caption(f"**{len(df):,}** trades selected")
    return df


# ── No-data guard ──────────────────────────────────────────────────────────────
def require_data(df: pd.DataFrame, min_rows: int = 5) -> bool:
    if df.empty or len(df) < min_rows:
        st.warning(
            f"Need at least {min_rows} trades to render this page.  \n"
            "Run **IMPORT_TRADES.bat** to import your trade history."
        )
        return False
    return True


# ── Grouped statistics ─────────────────────────────────────────────────────────
def group_stats(df: pd.DataFrame, col: str) -> pd.DataFrame:
    if col not in df.columns or df.empty:
        return pd.DataFrame()
    rows = []
    for key, g in df.groupby(col, dropna=True):
        wins   = g[g.outcome == "WIN"].pnl_usd
        losses = g[g.outcome == "LOSS"].pnl_usd
        n   = len(g)
        wr  = len(wins) / n if n else 0
        pf  = abs(wins.sum() / losses.sum()) if losses.sum() != 0 else 9.99
        exp = (wr * wins.mean() if len(wins) else 0) + \
              ((1 - wr) * losses.mean() if len(losses) else 0)
        rows.append({
            col:          key,
            "N":          n,
            "WR":         round(wr, 3),
            "PF":         round(min(pf, 9.99), 2),
            "Expectancy": round(exp, 2),
            "Net PnL":    round(g.pnl_usd.sum(), 2),
            "Avg Win":    round(wins.mean(),  2) if len(wins)   else 0,
            "Avg Loss":   round(losses.mean(), 2) if len(losses) else 0,
        })
    return pd.DataFrame(rows).sort_values("WR", ascending=False).reset_index(drop=True)


# ── Formatters ─────────────────────────────────────────────────────────────────
def pct(v, decimals=1):
    if v is None or (isinstance(v, float) and np.isnan(v)):
        return "—"
    return f"{v:.{decimals}%}"

def usd(v, decimals=2):
    if v is None or (isinstance(v, float) and np.isnan(v)):
        return "—"
    sign = "+" if v > 0 else ""
    return f"{sign}${v:,.{decimals}f}"

def num(v, decimals=2):
    if v is None or (isinstance(v, float) and np.isnan(v)):
        return "—"
    return f"{v:.{decimals}f}"
