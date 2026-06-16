"""
ea_engine.py — EA-level and portfolio analytics engine.
Pure computation: no Streamlit imports. All functions accept
DataFrames (already loaded by utils.load_trades()) or work
directly against the SQLite DB for registry operations.
"""

import sqlite3
import json
import math
import pandas as pd
import numpy as np
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parents[2]

def _cfg():
    p = BASE_DIR / "SYSTEM" / "config" / "system_config.json"
    return json.load(open(p, encoding="utf-8")) if p.exists() else {}

DB_PATH = BASE_DIR / _cfg().get("db", {}).get("trades_db", "DATA/processed/trades.sqlite")

EA_TYPES    = ["Trend", "MeanRev", "Grid", "Scalp", "SMC", "Hybrid", "Unknown"]
RISK_LEVELS = ["Low", "Medium", "High"]
STATUSES    = ["Active", "Inactive", "Testing"]


# ══════════════════════════════════════════════════════════════════════════════
# DB HELPERS
# ══════════════════════════════════════════════════════════════════════════════

def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    return con


def run_migration():
    """Apply migration 004 if ea_registry table doesn't exist yet."""
    migration = BASE_DIR / "DATA" / "migrations" / "004_ea_registry.sql"
    con = _con()
    tables = {r[0] for r in con.execute(
        "SELECT name FROM sqlite_master WHERE type='table'"
    ).fetchall()}
    if "ea_registry" not in tables and migration.exists():
        sql = migration.read_text(encoding="utf-8")
        con.executescript(sql)
        con.commit()
    con.close()


# ══════════════════════════════════════════════════════════════════════════════
# EA REGISTRY CRUD
# ══════════════════════════════════════════════════════════════════════════════

def get_registry() -> pd.DataFrame:
    """Return full ea_registry table, auto-seeded from trades if new."""
    run_migration()
    con = _con()
    # Seed any new strategy values not yet in registry
    con.execute("""
        INSERT OR IGNORE INTO ea_registry (ea_name, display_name)
        SELECT DISTINCT strategy, strategy FROM trades WHERE strategy IS NOT NULL
    """)
    con.commit()
    df = pd.read_sql_query(
        "SELECT * FROM ea_registry ORDER BY ea_name", con
    )
    con.close()
    return df


def save_registry_row(ea_name: str, fields: dict) -> tuple[bool, str]:
    allowed = {
        "display_name", "ea_type", "risk_level", "status",
        "preferred_symbol", "preferred_session",
        "inception_date", "description", "notes",
    }
    valid = {k: v for k, v in fields.items() if k in allowed}
    if not valid:
        return False, "No valid fields"
    con = _con()
    set_sql = ", ".join(f"{k}=?" for k in valid)
    con.execute(
        f"INSERT OR IGNORE INTO ea_registry (ea_name, display_name) VALUES (?, ?)",
        (ea_name, ea_name),
    )
    con.execute(
        f"UPDATE ea_registry SET {set_sql}, updated_at=datetime('now') WHERE ea_name=?",
        list(valid.values()) + [ea_name],
    )
    con.commit()
    con.close()
    return True, f"Saved {len(valid)} field(s)"


# ══════════════════════════════════════════════════════════════════════════════
# SINGLE-EA METRICS
# ══════════════════════════════════════════════════════════════════════════════

def compute_ea_metrics(df: pd.DataFrame) -> dict:
    """
    Compute full KPI set for a subset of the trades DataFrame
    (pre-filtered to a single EA by the caller).
    Returns a flat dict of metrics.
    """
    if df.empty:
        return {}

    wins   = df[df.outcome == "WIN"]
    losses = df[df.outcome == "LOSS"]
    total  = len(df)

    wr       = len(wins) / total
    avg_win  = float(wins.pnl_usd.mean())   if len(wins)   else 0.0
    avg_loss = float(losses.pnl_usd.mean()) if len(losses) else 0.0
    gross_w  = wins.pnl_usd.sum()
    gross_l  = losses.pnl_usd.sum()
    pf       = abs(gross_w / gross_l) if gross_l != 0 else None
    exp      = wr * avg_win + (1 - wr) * avg_loss
    net_pnl  = float(df.pnl_usd.sum())

    cum    = df.pnl_usd.cumsum()
    dd     = cum - cum.cummax()
    max_dd = float(dd.min())

    ret    = df.pnl_usd
    sharpe = float(ret.mean() / ret.std() * math.sqrt(252)) if ret.std() > 0 else 0.0

    # Max consecutive losses
    streak_col  = (df.outcome != "LOSS").cumsum()
    loss_groups = df[df.outcome == "LOSS"].groupby(streak_col).size()
    max_consec  = int(loss_groups.max()) if len(loss_groups) else 0

    # Kelly: f = WR - (1-WR)/avg_rr  (half-Kelly in practice)
    rr_col   = df["rr_actual"].dropna() if "rr_actual" in df.columns else pd.Series(dtype=float)
    avg_rr   = float(rr_col[rr_col > 0].mean()) if len(rr_col[rr_col > 0]) else None
    kelly    = (wr - (1 - wr) / avg_rr) if avg_rr else None
    half_kelly = round(kelly / 2, 3) if kelly is not None else None

    # Average trade duration
    dur_col   = df["duration_min"].dropna() if "duration_min" in df.columns else pd.Series(dtype=float)
    avg_dur   = float(dur_col.mean()) if len(dur_col) else None

    # Date range
    date_range = None
    if "open_time" in df.columns and not df["open_time"].isna().all():
        d0 = df["open_time"].min()
        d1 = df["open_time"].max()
        date_range = (d0, d1)

    return dict(
        total_trades     = total,
        win_count        = len(wins),
        loss_count       = len(losses),
        win_rate         = round(wr, 4),
        profit_factor    = round(min(pf, 99.0), 3) if pf else None,
        expectancy       = round(exp, 2),
        net_pnl          = round(net_pnl, 2),
        avg_win          = round(avg_win, 2),
        avg_loss         = round(avg_loss, 2),
        gross_win        = round(float(gross_w), 2),
        gross_loss       = round(float(gross_l), 2),
        max_drawdown     = round(max_dd, 2),
        sharpe           = round(sharpe, 3),
        max_consec_loss  = max_consec,
        avg_rr_actual    = round(avg_rr, 3) if avg_rr else None,
        kelly_f          = round(kelly, 3) if kelly else None,
        half_kelly       = half_kelly,
        avg_duration_min = round(avg_dur, 1) if avg_dur else None,
        best_trade       = round(float(df.pnl_usd.max()), 2),
        worst_trade      = round(float(df.pnl_usd.min()), 2),
        date_range       = date_range,
    )


# ══════════════════════════════════════════════════════════════════════════════
# EA LEADERBOARD
# ══════════════════════════════════════════════════════════════════════════════

def _rank_score(m: dict) -> float:
    """
    Composite rank score 0–100.
      WR              ×35 pts
      PF (capped 3)   ×20 pts
      Expectancy      ×15 pts  (capped at $50/trade = full score)
      Drawdown        ×20 pts  (0 DD = 20, $1000+ DD = 0)
      Sharpe          ×10 pts  (capped at 2.0)
    """
    if not m:
        return 0.0
    wr_pts  = m.get("win_rate", 0) * 35
    pf      = m.get("profit_factor") or 0
    pf_pts  = min(pf / 3.0, 1.0) * 20
    exp     = m.get("expectancy", 0) or 0
    exp_pts = min(max(exp, 0) / 50.0, 1.0) * 15
    dd      = abs(m.get("max_drawdown", 0) or 0)
    dd_pts  = max(0.0, (1 - min(dd / 1000.0, 1.0))) * 20
    sharpe  = m.get("sharpe", 0) or 0
    sh_pts  = min(max(sharpe, 0) / 2.0, 1.0) * 10
    return round(wr_pts + pf_pts + exp_pts + dd_pts + sh_pts, 1)


def build_leaderboard(df: pd.DataFrame, registry: pd.DataFrame = None) -> pd.DataFrame:
    """
    One row per EA with all KPIs and composite rank score.
    registry is optional; used to add ea_type / status columns.
    """
    if df.empty or "strategy" not in df.columns:
        return pd.DataFrame()

    rows = []
    for ea, grp in df.groupby("strategy", dropna=True):
        m = compute_ea_metrics(grp)
        if not m:
            continue
        row = {"EA": ea, **m, "rank_score": _rank_score(m)}
        rows.append(row)

    lb = pd.DataFrame(rows)
    if lb.empty:
        return lb

    if registry is not None and not registry.empty:
        reg_cols = registry[["ea_name", "ea_type", "risk_level", "status"]].copy()
        lb = lb.merge(reg_cols, left_on="EA", right_on="ea_name", how="left").drop(columns="ea_name")

    return lb.sort_values("rank_score", ascending=False).reset_index(drop=True)


# ══════════════════════════════════════════════════════════════════════════════
# EQUITY CURVES
# ══════════════════════════════════════════════════════════════════════════════

def ea_equity_curves(df: pd.DataFrame) -> pd.DataFrame:
    """
    Returns a wide DataFrame: index = trade sequence per-EA (1…N),
    columns = EA names, values = cumulative PnL.
    Useful for sparklines and individual equity charts.
    """
    if df.empty:
        return pd.DataFrame()
    curves = {}
    for ea, grp in df.sort_values("open_time").groupby("strategy", dropna=True):
        curves[ea] = grp["pnl_usd"].cumsum().values
    max_len = max(len(v) for v in curves.values())
    padded  = {k: np.pad(v, (0, max_len - len(v)), constant_values=np.nan)
               for k, v in curves.items()}
    return pd.DataFrame(padded)


def portfolio_equity(df: pd.DataFrame) -> pd.DataFrame:
    """
    Daily portfolio PnL: sum of all EAs, indexed by date.
    Returns DataFrame with columns: date, portfolio, <ea1>, <ea2>, …
    """
    if df.empty or "open_time" not in df.columns:
        return pd.DataFrame()

    df2 = df.copy()
    df2["date"] = pd.to_datetime(df2["open_time"]).dt.date

    pivot = df2.pivot_table(
        values="pnl_usd", index="date", columns="strategy",
        aggfunc="sum", fill_value=0,
    ).reset_index()

    ea_cols = [c for c in pivot.columns if c != "date"]
    pivot["portfolio"] = pivot[ea_cols].sum(axis=1)
    pivot = pivot.sort_values("date").reset_index(drop=True)

    for col in ["portfolio"] + ea_cols:
        pivot[f"cum_{col}"] = pivot[col].cumsum()

    return pivot


# ══════════════════════════════════════════════════════════════════════════════
# CORRELATION MATRIX
# ══════════════════════════════════════════════════════════════════════════════

def correlation_matrix(df: pd.DataFrame) -> pd.DataFrame:
    """
    Pearson correlation between EA daily PnL streams.
    Only includes EAs with ≥10 trading days.
    Returns correlation DataFrame (EAs × EAs).
    """
    if df.empty:
        return pd.DataFrame()

    df2 = df.copy()
    df2["date"] = pd.to_datetime(df2["open_time"]).dt.date

    daily = df2.pivot_table(
        values="pnl_usd", index="date", columns="strategy",
        aggfunc="sum", fill_value=0,
    )

    # Keep only EAs with enough trading days
    daily = daily.loc[:, daily.astype(bool).sum() >= 10]
    if daily.shape[1] < 2:
        return pd.DataFrame()

    return daily.corr(method="pearson").round(3)


# ══════════════════════════════════════════════════════════════════════════════
# BREAKDOWN MATRICES  (EA × dimension → WR / net PnL)
# ══════════════════════════════════════════════════════════════════════════════

def _breakdown(df: pd.DataFrame, dim: str) -> dict[str, pd.DataFrame]:
    """
    Returns {"wr": pivot_df, "pnl": pivot_df, "count": pivot_df}
    where rows = EA, columns = dim values (session / symbol / regime).
    """
    needed = {"strategy", dim, "outcome", "pnl_usd"}
    if not needed.issubset(df.columns):
        return {}

    sub = df.dropna(subset=["strategy", dim])
    if sub.empty:
        return {}

    grp = sub.groupby(["strategy", dim])

    wr_pivot = (
        grp["outcome"].apply(lambda s: (s == "WIN").mean())
        .unstack(dim).round(3)
    )
    pnl_pivot = (
        grp["pnl_usd"].sum()
        .unstack(dim).round(2)
    )
    cnt_pivot = (
        grp["pnl_usd"].count()
        .unstack(dim)
    )
    return {"wr": wr_pivot, "pnl": pnl_pivot, "count": cnt_pivot}


def session_breakdown(df: pd.DataFrame) -> dict:
    return _breakdown(df, "session")


def pair_breakdown(df: pd.DataFrame) -> dict:
    return _breakdown(df, "symbol")


def regime_breakdown(df: pd.DataFrame) -> dict:
    return _breakdown(df, "regime")


# ══════════════════════════════════════════════════════════════════════════════
# EXPECTANCY TABLE
# ══════════════════════════════════════════════════════════════════════════════

def expectancy_table(df: pd.DataFrame) -> pd.DataFrame:
    """
    Expectancy breakdown per EA:
      columns: EA, trades, WR, avg_win, avg_loss, expectancy, edge_ratio
    edge_ratio = avg_win / abs(avg_loss)  — how big wins are vs losses.
    """
    if df.empty:
        return pd.DataFrame()

    rows = []
    for ea, grp in df.groupby("strategy", dropna=True):
        wins   = grp[grp.outcome == "WIN"].pnl_usd
        losses = grp[grp.outcome == "LOSS"].pnl_usd
        total  = len(grp)
        wr     = len(wins) / total
        aw     = float(wins.mean())   if len(wins)   else 0.0
        al     = float(losses.mean()) if len(losses) else 0.0
        exp    = wr * aw + (1 - wr) * al
        edge   = abs(aw / al) if al != 0 else None
        rows.append({
            "EA":          ea,
            "Trades":      total,
            "WR":          round(wr, 4),
            "Avg Win":     round(aw, 2),
            "Avg Loss":    round(al, 2),
            "Expectancy":  round(exp, 2),
            "Edge Ratio":  round(edge, 3) if edge else None,
        })

    return pd.DataFrame(rows).sort_values("Expectancy", ascending=False).reset_index(drop=True)


# ══════════════════════════════════════════════════════════════════════════════
# PER-EA RISK METRICS
# ══════════════════════════════════════════════════════════════════════════════

def ea_risk_table(df: pd.DataFrame) -> pd.DataFrame:
    """
    Risk-focused metrics per EA: max DD, recovery factor,
    Sharpe, max consec loss, Kelly, VaR(95).
    """
    if df.empty:
        return pd.DataFrame()

    rows = []
    for ea, grp in df.sort_values("open_time").groupby("strategy", dropna=True):
        if len(grp) < 3:
            continue

        cum    = grp["pnl_usd"].cumsum()
        dd     = cum - cum.cummax()
        max_dd = float(dd.min())
        net    = float(grp["pnl_usd"].sum())
        rec_f  = round(abs(net / max_dd), 2) if max_dd != 0 else None

        ret    = grp["pnl_usd"]
        sharpe = float(ret.mean() / ret.std() * math.sqrt(252)) if ret.std() > 0 else 0.0
        var95  = float(ret.quantile(0.05))

        streak = (grp.outcome != "LOSS").cumsum()
        lg     = grp[grp.outcome == "LOSS"].groupby(streak).size()
        mcl    = int(lg.max()) if len(lg) else 0

        wins   = grp[grp.outcome == "WIN"].pnl_usd
        losses = grp[grp.outcome == "LOSS"].pnl_usd
        wr     = len(wins) / len(grp)
        rr_col = grp["rr_actual"].dropna() if "rr_actual" in grp.columns else pd.Series()
        avg_rr = float(rr_col[rr_col > 0].mean()) if len(rr_col[rr_col > 0]) else None
        kelly  = round(wr - (1 - wr) / avg_rr, 3) if avg_rr else None

        rows.append({
            "EA":            ea,
            "Net PnL":       round(net, 2),
            "Max DD":        round(max_dd, 2),
            "Recovery F":    rec_f,
            "Sharpe":        round(sharpe, 3),
            "VaR 95%":       round(var95, 2),
            "Max Consec L":  mcl,
            "Kelly f":       kelly,
            "Half-Kelly":    round(kelly / 2, 3) if kelly else None,
        })

    return pd.DataFrame(rows).sort_values("Sharpe", ascending=False).reset_index(drop=True)


# ══════════════════════════════════════════════════════════════════════════════
# SPARKLINE DATA
# ══════════════════════════════════════════════════════════════════════════════

def ea_sparklines(df: pd.DataFrame) -> dict[str, list[float]]:
    """Returns {ea_name: [cumulative_pnl_series]} for compact chart rendering."""
    result = {}
    for ea, grp in df.sort_values("open_time").groupby("strategy", dropna=True):
        result[ea] = grp["pnl_usd"].cumsum().tolist()
    return result
