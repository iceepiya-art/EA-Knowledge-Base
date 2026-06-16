"""
Risk and data-quality checks for QTrade OS safe semi-automation.
Checks only. It never changes trading behavior.
"""

from __future__ import annotations

from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd

from automation_common import automation_config, current_loss_streak, load_trades, resolve_path, summarize_trades, week_bounds


def _pct_of_balance(pnl: float, balance: float) -> float:
    if balance <= 0:
        return 0.0
    return abs(pnl) / balance * 100


def _latest_csv_age_hours() -> float | None:
    cfg = automation_config()
    folder = resolve_path(cfg.get("paths", {}).get("mt5_watch_folder", "DATA/raw/mt5_exports"))
    csvs = list(folder.glob("*.csv")) if folder.exists() else []
    if not csvs:
        return None
    latest = max(csvs, key=lambda p: p.stat().st_mtime)
    return (datetime.now().timestamp() - latest.stat().st_mtime) / 3600


def evaluate_alerts() -> list[dict]:
    cfg = automation_config()
    alerts = cfg.get("alerts", {})
    report_cfg = cfg.get("reports", {})
    balance = float(report_cfg.get("account_balance", 50000.0))
    df = load_trades()
    messages: list[dict] = []

    if df.empty:
        messages.append({"level": "warning", "type": "missing_data", "message": "No trades found in SQLite database."})
        return messages

    now = datetime.now()
    today_start = now.replace(hour=0, minute=0, second=0, microsecond=0)
    week_start, week_end = week_bounds(now)
    today = df[(df["open_time"] >= today_start) & (df["open_time"] < today_start + timedelta(days=1))]
    week = df[(df["open_time"] >= week_start) & (df["open_time"] < week_end)]

    if alerts.get("risk_alerts_enabled", True):
        daily_stats = summarize_trades(today)
        weekly_stats = summarize_trades(week)
        daily_dd = _pct_of_balance(min(daily_stats["net_pnl"], 0), balance)
        weekly_dd = _pct_of_balance(min(weekly_stats["net_pnl"], 0), balance)
        if daily_dd >= float(alerts.get("daily_drawdown_warning_pct", 1.5)):
            messages.append({
                "level": "risk",
                "type": "daily_drawdown",
                "message": f"Daily drawdown warning: {daily_dd:.2f}% ({daily_stats['net_pnl']:.2f} USD). Human review required before next session.",
            })
        if weekly_dd >= float(alerts.get("weekly_drawdown_warning_pct", 3.5)):
            messages.append({
                "level": "risk",
                "type": "weekly_drawdown",
                "message": f"Weekly drawdown warning: {weekly_dd:.2f}% ({weekly_stats['net_pnl']:.2f} USD). Human review required.",
            })
        streak = current_loss_streak(df)
        if streak >= int(alerts.get("consecutive_loss_warning", 2)):
            messages.append({
                "level": "risk",
                "type": "consecutive_losses",
                "message": f"Consecutive loss warning: {streak} losses. Do not increase lots or override risk.",
            })

    if alerts.get("abnormal_ea_enabled", True) and "strategy" in week:
        min_trades = int(alerts.get("abnormal_ea_min_trades", 5))
        loss_usd = float(alerts.get("abnormal_ea_loss_usd", 500.0))
        for strategy, group in week.groupby("strategy", dropna=True):
            if len(group) < min_trades:
                continue
            stats = summarize_trades(group)
            if stats["net_pnl"] <= -abs(loss_usd):
                messages.append({
                    "level": "warning",
                    "type": "abnormal_ea_performance",
                    "message": f"Abnormal EA performance: {strategy} weekly PnL {stats['net_pnl']:.2f} USD over {stats['trades']} trades. Review manually; no config change was made.",
                })
        messages.extend(_ea_degradation_alerts(df, alerts))

    if alerts.get("missing_data_enabled", True):
        max_age = float(alerts.get("missing_csv_after_hours", 36))
        age = _latest_csv_age_hours()
        if age is None:
            messages.append({
                "level": "warning",
                "type": "missing_csv",
                "message": "No CSV files found in MT5 watch folder.",
            })
        elif age > max_age:
            messages.append({
                "level": "warning",
                "type": "stale_csv",
                "message": f"Latest MT5 CSV is {age:.1f} hours old. Check MT5 export workflow.",
            })

    return messages


def _ea_degradation_alerts(df: pd.DataFrame, alerts: dict) -> list[dict]:
    if df.empty or "strategy" not in df:
        return []
    now = datetime.now()
    recent_days = int(alerts.get("degradation_recent_days", 7))
    baseline_days = int(alerts.get("degradation_baseline_days", 30))
    min_trades = int(alerts.get("abnormal_ea_min_trades", 5))
    wr_drop = float(alerts.get("abnormal_ea_winrate_drop_pct", 25.0)) / 100.0
    recent_start = now - timedelta(days=recent_days)
    baseline_start = recent_start - timedelta(days=baseline_days)
    recent = df[df["open_time"] >= recent_start]
    baseline = df[(df["open_time"] >= baseline_start) & (df["open_time"] < recent_start)]
    if recent.empty or baseline.empty:
        return []

    out = []
    for strategy, recent_group in recent.groupby("strategy", dropna=True):
        base_group = baseline[baseline["strategy"] == strategy]
        if len(recent_group) < min_trades or len(base_group) < min_trades:
            continue
        recent_stats = summarize_trades(recent_group)
        base_stats = summarize_trades(base_group)
        recent_wr = recent_stats["win_rate"] or 0.0
        base_wr = base_stats["win_rate"] or 0.0
        exp_drop = (base_stats["expectancy"] or 0.0) - (recent_stats["expectancy"] or 0.0)
        if base_wr - recent_wr >= wr_drop or exp_drop > abs(base_stats["expectancy"] or 0.0) * 0.5:
            out.append({
                "level": "warning",
                "type": "ea_degradation",
                "message": (
                    f"EA degradation warning: {strategy}. "
                    f"Recent WR {recent_wr:.1%} vs baseline {base_wr:.1%}; "
                    f"recent expectancy {recent_stats['expectancy']} vs baseline {base_stats['expectancy']}. "
                    "Review manually; no EA config change was made."
                ),
            })
    return out
