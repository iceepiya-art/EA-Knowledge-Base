"""
performance.py — Pure computation. No Streamlit imports.
All functions accept a DataFrame, return dicts or DataFrames.
"""

import pandas as pd
import numpy as np
from typing import Optional


def compute_kpis(df: pd.DataFrame) -> dict:
    if df.empty:
        return {}

    wins   = df[df.outcome == "WIN"]
    losses = df[df.outcome == "LOSS"]
    total  = len(df)

    wr      = len(wins) / total if total else 0
    avg_win = wins.pnl_usd.mean()   if len(wins)   else 0.0
    avg_loss= losses.pnl_usd.mean() if len(losses) else 0.0

    gross_win  = wins.pnl_usd.sum()
    gross_loss = losses.pnl_usd.sum()
    pf = abs(gross_win / gross_loss) if gross_loss != 0 else None

    exp     = (wr * avg_win) + ((1 - wr) * avg_loss)
    net_pnl = df.pnl_usd.sum()

    equity  = df.pnl_usd.cumsum()
    dd      = equity - equity.cummax()
    max_dd  = dd.min()

    ret     = df.pnl_usd
    sharpe  = (ret.mean() / ret.std() * np.sqrt(252)) if ret.std() > 0 else 0.0

    # Longest consecutive loss streak
    streak_col = (df.outcome != "LOSS").cumsum()
    loss_groups = df[df.outcome == "LOSS"].groupby(streak_col).size()
    max_consec  = int(loss_groups.max()) if len(loss_groups) else 0

    avg_dur = df.duration_min.mean() if "duration_min" in df.columns else None

    return dict(
        total_trades     = total,
        win_count        = len(wins),
        loss_count       = len(losses),
        win_rate         = wr,
        profit_factor    = pf,
        expectancy       = exp,
        net_pnl          = net_pnl,
        avg_win          = avg_win,
        avg_loss         = avg_loss,
        max_drawdown     = max_dd,
        sharpe           = sharpe,
        max_consec_loss  = max_consec,
        avg_duration_min = avg_dur,
        best_trade       = float(df.pnl_usd.max()),
        worst_trade      = float(df.pnl_usd.min()),
    )


def monthly_pnl(df: pd.DataFrame) -> pd.DataFrame:
    if df.empty or "month_dt" not in df.columns:
        return pd.DataFrame()
    m = df.groupby("month_dt").agg(
        net_pnl  = ("pnl_usd", "sum"),
        trades   = ("pnl_usd", "count"),
        win_rate = ("is_win",  "mean"),
    ).reset_index()
    m["color"] = m["net_pnl"].apply(lambda v: "#26a69a" if v >= 0 else "#ef5350")
    return m


def rolling_winrate(df: pd.DataFrame, window: int = 20) -> pd.Series:
    if df.empty or len(df) < window:
        return pd.Series(dtype=float)
    return df.set_index("trade_num")["is_win"].rolling(window).mean().dropna()


def heatmap_regime_session(df: pd.DataFrame) -> Optional[pd.DataFrame]:
    needed = {"regime", "session", "is_win"}
    if not needed.issubset(df.columns):
        return None
    sub = df.dropna(subset=["regime", "session"])
    if len(sub) < 20:
        return None
    pivot = sub.pivot_table(
        values="is_win", index="regime", columns="session", aggfunc="mean"
    )
    return pivot.round(3)


def mistake_frequency(df: pd.DataFrame) -> pd.DataFrame:
    if "mistakes" not in df.columns:
        return pd.DataFrame()
    sub = df[df.mistakes.notna()].copy()
    if sub.empty:
        return pd.DataFrame()
    sub["mistake_list"] = sub["mistakes"].str.split("|")
    ex = sub.explode("mistake_list")
    ex = ex[ex["mistake_list"].str.strip() != ""]
    if ex.empty:
        return pd.DataFrame()
    return (
        ex.groupby("mistake_list")
          .agg(count=("pnl_usd","count"), avg_pnl=("pnl_usd","mean"), total_pnl=("pnl_usd","sum"))
          .reset_index()
          .rename(columns={"mistake_list": "mistake"})
          .sort_values("count", ascending=False)
          .reset_index(drop=True)
    )


def rr_distribution(df: pd.DataFrame) -> pd.DataFrame:
    cols = [c for c in ("rr_planned", "rr_actual", "outcome") if c in df.columns]
    return df[cols].dropna(subset=[c for c in cols if c != "outcome"])
