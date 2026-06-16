"""
Markdown report generator for QTrade OS safe semi-automation.
Writes reports to REPORTS and Obsidian. No trading decisions are automated.
"""

from __future__ import annotations

import shutil
from datetime import datetime, timedelta
from pathlib import Path

import pandas as pd

from automation_common import (
    BASE_DIR,
    automation_config,
    current_loss_streak,
    load_trades,
    pct,
    resolve_path,
    summarize_trades,
    week_bounds,
)


def _money(value: float | int | None) -> str:
    if value is None:
        return "n/a"
    sign = "+" if float(value) >= 0 else "-"
    return f"{sign}${abs(float(value)):,.2f}"


def _top_table(df: pd.DataFrame, dim: str) -> str:
    if df.empty or dim not in df:
        return "No data.\n"
    rows = []
    for key, group in df.dropna(subset=[dim]).groupby(dim):
        if group.empty:
            continue
        stats = summarize_trades(group)
        rows.append((str(key), stats["trades"], stats["win_rate"], stats["net_pnl"], stats["expectancy"]))
    if not rows:
        return "No data.\n"
    rows.sort(key=lambda r: r[3], reverse=True)
    out = "| Name | Trades | WR | Net PnL | Expectancy |\n|---|---:|---:|---:|---:|\n"
    for name, trades, wr, net, exp in rows:
        out += f"| {name} | {trades} | {pct(wr)} | {_money(net)} | {_money(exp)} |\n"
    return out


def _mistake_table(df: pd.DataFrame) -> str:
    if df.empty or "mistakes" not in df:
        return "No mistake annotations yet.\n"
    rows = []
    for _, row in df[df["mistakes"].notna()].iterrows():
        for mistake in str(row["mistakes"]).split("|"):
            mistake = mistake.strip()
            if mistake:
                rows.append({"mistake": mistake, "pnl_usd": row["pnl_usd"]})
    if not rows:
        return "No mistake annotations yet.\n"
    ex = pd.DataFrame(rows)
    agg = (
        ex.groupby("mistake")
        .agg(count=("pnl_usd", "count"), net_pnl=("pnl_usd", "sum"), avg_pnl=("pnl_usd", "mean"))
        .reset_index()
        .sort_values("net_pnl")
    )
    out = "| Mistake | Count | Net PnL | Avg PnL |\n|---|---:|---:|---:|\n"
    for _, row in agg.iterrows():
        out += f"| {row['mistake']} | {int(row['count'])} | {_money(row['net_pnl'])} | {_money(row['avg_pnl'])} |\n"
    return out


def _report_frontmatter(report_type: str, date_key: str) -> str:
    return (
        "---\n"
        f"type: {report_type}_report\n"
        "status: generated\n"
        f"date: {date_key}\n"
        "tags:\n"
        "  - qtrade-report\n"
        "  - safe-automation\n"
        "---\n\n"
    )


def build_report(df: pd.DataFrame, report_type: str, start: datetime, end: datetime) -> str:
    period = f"{start:%Y-%m-%d} to {(end - timedelta(seconds=1)):%Y-%m-%d}"
    stats = summarize_trades(df)
    streak = current_loss_streak(df)
    body = _report_frontmatter(report_type, start.date().isoformat())
    body += f"# QTrade OS {report_type.title()} Report - {period}\n\n"
    body += "## Safety Notice\n"
    body += "This report is informational only. It does not authorize trade entry, trade exit, lot increase, EA config changes, live deployment, or risk override.\n\n"
    body += "## Performance Snapshot\n"
    body += f"- Trades: {stats['trades']}\n"
    body += f"- Wins / Losses: {stats['wins']} / {stats['losses']}\n"
    body += f"- Win rate: {pct(stats['win_rate'])}\n"
    body += f"- Profit factor: {stats['profit_factor'] or 'n/a'}\n"
    body += f"- Expectancy: {_money(stats['expectancy'])}\n"
    body += f"- Net PnL: {_money(stats['net_pnl'])}\n"
    body += f"- Current loss streak in period: {streak}\n\n"
    body += "## Strategy Breakdown\n"
    body += _top_table(df, "strategy") + "\n"
    body += "## Session Breakdown\n"
    body += _top_table(df, "session") + "\n"
    body += "## Symbol Breakdown\n"
    body += _top_table(df, "symbol") + "\n"
    body += "## Regime Breakdown\n"
    body += _top_table(df, "regime") + "\n"
    body += "## Mistake Cost\n"
    body += _mistake_table(df) + "\n"
    body += "## Human Review Checklist\n"
    body += "- Confirm whether any risk limit was touched.\n"
    body += "- Review losing streaks before next session.\n"
    body += "- Review abnormal EA rows before changing any EA setting manually.\n"
    body += "- Add missing annotations for trades that affected the report.\n\n"
    if automation_config().get("reports", {}).get("include_ai_prompt", True):
        body += "## AI Review Prompt\n"
        body += "Using only this report and linked Obsidian research notes, suggest: one rule to keep, one rule to pause for human review, and one annotation gap to fix. Do not suggest autonomous trade execution.\n"
    return body


def write_report(report_type: str, start: datetime, end: datetime) -> dict:
    df = load_trades()
    if not df.empty:
        mask = (df["open_time"] >= start) & (df["open_time"] < end)
        df = df[mask].copy()

    cfg = automation_config()
    paths = cfg.get("paths", {})
    date_key = start.date().isoformat() if report_type == "daily" else start.strftime("%G-W%V")
    report_dir = resolve_path(paths.get(f"{report_type}_reports", f"REPORTS/{report_type}"))
    if report_type == "daily":
        report_dir = resolve_path(paths.get("daily_reports", "REPORTS/daily"))
    if report_type == "weekly":
        report_dir = resolve_path(paths.get("weekly_reports", "REPORTS/weekly"))
    report_dir.mkdir(parents=True, exist_ok=True)

    name = f"{date_key}_{report_type}_report.md"
    content = build_report(df, report_type, start, end)
    report_path = report_dir / name
    report_path.write_text(content, encoding="utf-8")

    obsidian_dir = resolve_path(paths.get("obsidian_reports", "10_Research/05_Analytics_Insights"))
    obsidian_dir.mkdir(parents=True, exist_ok=True)
    obsidian_path = obsidian_dir / name
    shutil.copyfile(report_path, obsidian_path)

    return {
        "report_path": str(report_path.relative_to(BASE_DIR)),
        "obsidian_path": str(obsidian_path.relative_to(BASE_DIR)),
        "trades": int(len(df)),
        "stats": summarize_trades(df),
    }


def write_daily_report(day: datetime | None = None) -> dict:
    day = day or datetime.now()
    start = day.replace(hour=0, minute=0, second=0, microsecond=0)
    end = start + timedelta(days=1)
    return write_report("daily", start, end)


def write_weekly_report(now: datetime | None = None) -> dict:
    start, end = week_bounds(now)
    return write_report("weekly", start, end)


def _write_named_report(folder_key: str, filename: str, content: str) -> dict:
    cfg = automation_config()
    paths = cfg.get("paths", {})
    report_dir = resolve_path(paths.get(folder_key, f"REPORTS/{folder_key.replace('_reports', '')}"))
    report_dir.mkdir(parents=True, exist_ok=True)
    report_path = report_dir / filename
    report_path.write_text(content, encoding="utf-8")

    obsidian_dir = resolve_path(paths.get("obsidian_reports", "10_Research/05_Analytics_Insights"))
    obsidian_dir.mkdir(parents=True, exist_ok=True)
    obsidian_path = obsidian_dir / filename
    shutil.copyfile(report_path, obsidian_path)
    return {
        "report_path": str(report_path.relative_to(BASE_DIR)),
        "obsidian_path": str(obsidian_path.relative_to(BASE_DIR)),
    }


def _dimension_report(df: pd.DataFrame, title: str, dim: str, report_type: str) -> str:
    now = datetime.now()
    stats = summarize_trades(df)
    body = _report_frontmatter(report_type, now.date().isoformat())
    body += f"# {title} - {now:%Y-%m-%d %H:%M}\n\n"
    body += "## Safety Notice\n"
    body += "This is a learning report only. It does not approve trade execution, lot changes, EA config changes, or risk overrides.\n\n"
    body += "## Portfolio Context\n"
    body += f"- Trades: {stats['trades']}\n"
    body += f"- Win rate: {pct(stats['win_rate'])}\n"
    body += f"- Net PnL: {_money(stats['net_pnl'])}\n"
    body += f"- Expectancy: {_money(stats['expectancy'])}\n\n"
    body += f"## {dim.title()} Intelligence\n"
    body += _top_table(df, dim) + "\n"
    body += "## Practical Review\n"
    body += "- Keep: identify conditions with positive expectancy and enough sample size.\n"
    body += "- Watch: identify conditions with negative expectancy or low sample size.\n"
    body += "- Human action: update notes or review annotations before changing any trading rule.\n"
    return body


def write_ea_performance_report() -> dict:
    df = load_trades()
    now = datetime.now()
    body = _dimension_report(df, "EA Performance Intelligence", "strategy", "ea_performance")
    if not df.empty and "strategy" in df:
        body += "\n## EA Detail\n"
        for strategy, group in df.groupby("strategy", dropna=True):
            stats = summarize_trades(group)
            body += f"\n### {strategy}\n"
            body += f"- Trades: {stats['trades']}\n"
            body += f"- Win rate: {pct(stats['win_rate'])}\n"
            body += f"- Profit factor: {stats['profit_factor'] or 'n/a'}\n"
            body += f"- Net PnL: {_money(stats['net_pnl'])}\n"
            body += f"- Expectancy: {_money(stats['expectancy'])}\n"
            body += f"- Best session: {_best_group(group, 'session')}\n"
            body += f"- Best symbol: {_best_group(group, 'symbol')}\n"
            body += f"- Best regime: {_best_group(group, 'regime')}\n"
    result = _write_named_report("ea_reports", f"{now:%Y-%m-%d}_ea_performance.md", body)
    result["trades"] = int(len(df))
    return result


def write_risk_report() -> dict:
    df = load_trades()
    now = datetime.now()
    cfg = automation_config()
    balance = float(cfg.get("reports", {}).get("account_balance", 50000.0))
    stats = summarize_trades(df)
    streak = current_loss_streak(df)
    body = _report_frontmatter("risk", now.date().isoformat())
    body += f"# Risk Intelligence - {now:%Y-%m-%d %H:%M}\n\n"
    body += "## Safety Notice\n"
    body += "This report warns and informs only. Risk overrides remain human-approved.\n\n"
    body += "## Current Risk State\n"
    body += f"- Net PnL: {_money(stats['net_pnl'])}\n"
    body += f"- Account balance reference: {_money(balance)}\n"
    body += f"- Current loss streak: {streak}\n"
    body += f"- Total trades: {stats['trades']}\n\n"
    if not df.empty:
        df2 = df.copy()
        df2["cum_pnl"] = df2["pnl_usd"].cumsum()
        df2["peak"] = df2["cum_pnl"].cummax()
        df2["drawdown"] = df2["cum_pnl"] - df2["peak"]
        max_dd = float(df2["drawdown"].min())
        body += "## Drawdown\n"
        body += f"- Max closed-trade drawdown: {_money(max_dd)}\n"
        body += f"- Max closed-trade drawdown pct of reference balance: {abs(max_dd) / balance * 100:.2f}%\n\n"
        body += "## EA Risk Breakdown\n"
        body += _top_table(df, "strategy") + "\n"
    body += "## Human Review Checklist\n"
    body += "- If drawdown or streak is above threshold, stop and review manually.\n"
    body += "- Do not increase lot size to recover losses.\n"
    body += "- Do not change live EA config from this report alone.\n"
    result = _write_named_report("risk_reports", f"{now:%Y-%m-%d}_risk_intelligence.md", body)
    result["trades"] = int(len(df))
    return result


def write_session_intelligence_report() -> dict:
    df = load_trades()
    now = datetime.now()
    body = _dimension_report(df, "Session Intelligence", "session", "session_intelligence")
    result = _write_named_report("session_reports", f"{now:%Y-%m-%d}_session_intelligence.md", body)
    result["trades"] = int(len(df))
    return result


def write_pair_intelligence_report() -> dict:
    df = load_trades()
    now = datetime.now()
    body = _dimension_report(df, "Pair Intelligence", "symbol", "pair_intelligence")
    if not df.empty and {"symbol", "regime"}.issubset(df.columns):
        body += "\n## Symbol x Regime\n"
        pivot_rows = []
        for (symbol, regime), group in df.dropna(subset=["symbol", "regime"]).groupby(["symbol", "regime"]):
            stats = summarize_trades(group)
            pivot_rows.append((symbol, regime, stats["trades"], stats["win_rate"], stats["net_pnl"], stats["expectancy"]))
        pivot_rows.sort(key=lambda r: r[4], reverse=True)
        body += "| Symbol | Regime | Trades | WR | Net PnL | Expectancy |\n|---|---|---:|---:|---:|---:|\n"
        for symbol, regime, trades, wr, net, exp in pivot_rows:
            body += f"| {symbol} | {regime} | {trades} | {pct(wr)} | {_money(net)} | {_money(exp)} |\n"
    result = _write_named_report("pair_reports", f"{now:%Y-%m-%d}_pair_intelligence.md", body)
    result["trades"] = int(len(df))
    return result


def write_learning_report_pack() -> dict:
    cfg = automation_config()
    reports_cfg = cfg.get("reports", {})
    results = {}
    if reports_cfg.get("generate_ea_reports", True):
        results["ea"] = write_ea_performance_report()
    if reports_cfg.get("generate_risk_reports", True):
        results["risk"] = write_risk_report()
    if reports_cfg.get("generate_session_reports", True):
        results["session"] = write_session_intelligence_report()
    if reports_cfg.get("generate_pair_reports", True):
        results["pair"] = write_pair_intelligence_report()
    return results


def _best_group(df: pd.DataFrame, dim: str) -> str:
    if df.empty or dim not in df:
        return "n/a"
    rows = []
    for key, group in df.dropna(subset=[dim]).groupby(dim):
        if len(group) < 3:
            continue
        rows.append((float(group["pnl_usd"].mean()), len(group), str(key)))
    if not rows:
        return "needs more data"
    rows.sort(reverse=True)
    return f"{rows[0][2]} ({rows[0][1]} trades, avg {_money(rows[0][0])})"
