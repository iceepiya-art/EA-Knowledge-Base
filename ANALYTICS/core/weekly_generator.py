"""
weekly_generator.py — Auto weekly review generator.

Pulls the last 7 days of trade data, computes KPIs, and writes
a pre-filled markdown review note to 10_Research/13_Weekly_Reviews/.

The human fills in the qualitative sections; the stats are auto-populated.
This is a learning document, not a trading instruction.
"""

from __future__ import annotations

import json
import re
import sqlite3
from datetime import date, datetime, timedelta
from pathlib import Path

import pandas as pd

BASE_DIR     = Path(__file__).resolve().parents[2]
RESEARCH_DIR = BASE_DIR / "10_Research"
WEEKLY_DIR   = RESEARCH_DIR / "13_Weekly_Reviews"


def _cfg() -> dict:
    p = BASE_DIR / "SYSTEM" / "config" / "system_config.json"
    return json.load(open(p, encoding="utf-8")) if p.exists() else {}

DB_PATH = BASE_DIR / _cfg().get("db", {}).get("trades_db", "DATA/processed/trades.sqlite")


def _load_week_trades(date_start: date, date_end: date) -> pd.DataFrame:
    con = sqlite3.connect(DB_PATH)
    df  = pd.read_sql_query(
        "SELECT * FROM trades WHERE date(open_time) BETWEEN ? AND ? ORDER BY open_time",
        con, params=(date_start.isoformat(), date_end.isoformat()),
    )
    con.close()
    if not df.empty:
        df["open_time"]  = pd.to_datetime(df["open_time"],  errors="coerce")
        df["close_time"] = pd.to_datetime(df["close_time"], errors="coerce")
        df["pnl_usd"]    = pd.to_numeric(df["pnl_usd"],  errors="coerce")
        df["is_win"]     = (df["outcome"] == "WIN").astype(int)
    return df


def _kpis(df: pd.DataFrame) -> dict:
    if df.empty:
        return {}
    wins   = df[df.outcome == "WIN"]["pnl_usd"]
    losses = df[df.outcome == "LOSS"]["pnl_usd"]
    total  = len(df)
    wr     = len(wins) / total
    aw     = float(wins.mean())   if len(wins)   else 0.0
    al     = float(losses.mean()) if len(losses) else 0.0
    pf     = abs(wins.sum() / losses.sum()) if losses.sum() != 0 else None
    exp    = wr * aw + (1 - wr) * al
    net    = float(df["pnl_usd"].sum())
    cum    = df["pnl_usd"].cumsum()
    dd     = float((cum - cum.cummax()).min())
    return dict(
        total=total, wins=len(wins), losses=len(losses),
        wr=wr, avg_win=aw, avg_loss=al, pf=pf, exp=exp, net=net, max_dd=dd,
    )


def _best_ea(df: pd.DataFrame) -> str:
    if df.empty or "strategy" not in df.columns:
        return "—"
    g = df.groupby("strategy")["pnl_usd"].sum()
    return str(g.idxmax()) if not g.empty else "—"


def _best_session(df: pd.DataFrame) -> str:
    if df.empty or "session" not in df.columns:
        return "—"
    g = df.dropna(subset=["session"]).groupby("session")["pnl_usd"].sum()
    return str(g.idxmax()) if not g.empty else "—"


def _top_mistakes(df: pd.DataFrame, n: int = 3) -> list[str]:
    if "mistakes" not in df.columns:
        return []
    sub = df[df.mistakes.notna()]
    if sub.empty:
        return []
    all_m: list[str] = []
    for v in sub["mistakes"]:
        all_m.extend(m for m in str(v).split("|") if m.strip())
    from collections import Counter
    return [m for m, _ in Counter(all_m).most_common(n)]


def _ea_table_md(df: pd.DataFrame) -> str:
    if df.empty:
        return "_No trades this week._\n"
    rows = []
    for ea, g in df.groupby("strategy", dropna=True):
        wins = g[g.outcome == "WIN"]
        n    = len(g)
        wr   = len(wins) / n
        net  = g["pnl_usd"].sum()
        rows.append(f"| {ea} | {n} | {wr:.0%} | ${net:+,.2f} |")
    header = "| EA | Trades | WR | Net PnL |\n|---|---|---|---|\n"
    return header + "\n".join(rows) + "\n"


def _session_table_md(df: pd.DataFrame) -> str:
    if df.empty or "session" not in df.columns:
        return "_No session data._\n"
    sub = df.dropna(subset=["session"])
    if sub.empty:
        return "_No session labels this week._\n"
    rows = []
    for sess, g in sub.groupby("session"):
        wins = g[g.outcome == "WIN"]
        n    = len(g)
        wr   = len(wins) / n
        net  = g["pnl_usd"].sum()
        rows.append(f"| {sess} | {n} | {wr:.0%} | ${net:+,.2f} |")
    header = "| Session | Trades | WR | Net PnL |\n|---|---|---|---|\n"
    return header + "\n".join(rows) + "\n"


def _regime_table_md(df: pd.DataFrame) -> str:
    if df.empty or "regime" not in df.columns:
        return "_No regime data._\n"
    sub = df.dropna(subset=["regime"])
    if sub.empty:
        return "_No regime labels this week._\n"
    rows = []
    for regime, g in sub.groupby("regime"):
        wins = g[g.outcome == "WIN"]
        n    = len(g)
        wr   = len(wins) / n
        net  = g["pnl_usd"].sum()
        rows.append(f"| {regime} | {n} | {wr:.0%} | ${net:+,.2f} |")
    header = "| Regime | Trades | WR | Net PnL |\n|---|---|---|---|\n"
    return header + "\n".join(rows) + "\n"


def generate_weekly_review(
    week_str:   str | None = None,
    overwrite:  bool = False,
) -> tuple[Path, dict]:
    """
    Generate a weekly review markdown note.

    week_str: ISO week like '2026-W19'. Defaults to last complete week.
    Returns (note_path, summary_dict).
    """
    WEEKLY_DIR.mkdir(parents=True, exist_ok=True)

    # Resolve week
    if week_str is None:
        today      = date.today()
        last_mon   = today - timedelta(days=today.weekday() + 7)
        date_start = last_mon
        date_end   = last_mon + timedelta(days=6)
        iso_w      = date_start.isocalendar()
        week_str   = f"{iso_w[0]}-W{iso_w[1]:02d}"
    else:
        # Parse '2026-W19'
        m = re.match(r"(\d{4})-W(\d{1,2})", week_str)
        if not m:
            raise ValueError(f"Invalid week_str format: {week_str} (expect '2026-W19')")
        year, wnum = int(m.group(1)), int(m.group(2))
        date_start = date.fromisocalendar(year, wnum, 1)
        date_end   = date_start + timedelta(days=6)

    note_path = WEEKLY_DIR / f"{week_str}.md"
    if note_path.exists() and not overwrite:
        return note_path, {"skipped": True, "week": week_str, "path": str(note_path)}

    df   = _load_week_trades(date_start, date_end)
    k    = _kpis(df)
    now  = datetime.now().isoformat(timespec="seconds")

    # YAML frontmatter
    fm_lines = [
        "---",
        f"type: weekly_review",
        f"week: \"{week_str}\"",
        f"date_start: \"{date_start}\"",
        f"date_end: \"{date_end}\"",
        f"status: draft",
        f"total_trades: {k.get('total', 0)}",
        f"win_rate: {round(k.get('wr', 0), 4)}",
        f"net_pnl: {round(k.get('net', 0), 2)}",
        f"generated_at: \"{now}\"",
        "tags:",
        "  - weekly-review",
        "  - trading-intelligence",
        "---",
        "",
    ]

    wr_str  = f"{k['wr']:.1%}"     if k else "n/a"
    pf_str  = f"{k['pf']:.2f}"     if k and k.get('pf') else "n/a"
    exp_str = f"${k['exp']:+,.2f}" if k else "n/a"
    net_str = f"${k['net']:+,.2f}" if k else "n/a"
    dd_str  = f"${k['max_dd']:+,.2f}" if k else "n/a"
    mistakes = _top_mistakes(df)
    mistake_str = ", ".join(mistakes) if mistakes else "none tagged"

    # Document body
    body_lines = [
        f"# Weekly Review — {week_str}",
        f"**{date_start} → {date_end}**",
        "",
        "> This is a learning document. It does not authorize trade changes or risk overrides.",
        "",
        "---",
        "",
        "## Performance Summary",
        "",
        "| Metric | Value |",
        "|---|---|",
        f"| Total Trades | {k.get('total', 0)} |",
        f"| Wins / Losses | {k.get('wins', 0)} / {k.get('losses', 0)} |",
        f"| Win Rate | {wr_str} |",
        f"| Profit Factor | {pf_str} |",
        f"| Expectancy | {exp_str} |",
        f"| Net PnL | {net_str} |",
        f"| Max Drawdown | {dd_str} |",
        f"| Best EA | {_best_ea(df)} |",
        f"| Best Session | {_best_session(df)} |",
        f"| Top Mistakes | {mistake_str} |",
        "",
        "## EA Breakdown",
        "",
        _ea_table_md(df),
        "## Session Breakdown",
        "",
        _session_table_md(df),
        "## Regime Breakdown",
        "",
        _regime_table_md(df),
        "---",
        "",
        "## 🧠 What Worked  _(fill in)_",
        "- ",
        "",
        "## ❌ What Didn't Work  _(fill in)_",
        "- ",
        "",
        "## 🔄 Process Review  _(fill in)_",
        "- Did I follow the plan?",
        "- Emotional state this week:",
        "- Notable mistakes:",
        "",
        "## 💡 Research Learnings  _(fill in)_",
        "- ",
        "",
        "## 📋 Action Items for Next Week  _(fill in)_",
        "- [ ] ",
        "",
        "## 🔗 Links",
        f"- [[10_Research/_Indexes/Research_Intelligence_Index|Research Index]]",
        f"- [[10_Research/05_Analytics_Insights/README|Analytics Insights]]",
        "",
        "---",
        f"_Generated: {now}_",
    ]

    content = "\n".join(fm_lines) + "\n".join(body_lines) + "\n"
    note_path.write_text(content, encoding="utf-8")

    # Upsert weekly_reviews table
    try:
        con = sqlite3.connect(DB_PATH)
        con.execute("""
            INSERT OR REPLACE INTO weekly_reviews
              (week_key, date_start, date_end, note_path,
               total_trades, win_rate, net_pnl, profit_factor, expectancy,
               best_ea, best_session, generated_at)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,datetime('now'))
        """, (week_str, date_start.isoformat(), date_end.isoformat(),
              str(note_path.relative_to(BASE_DIR)),
              k.get("total", 0), k.get("wr"), k.get("net"),
              k.get("pf"), k.get("exp"),
              _best_ea(df), _best_session(df)))
        con.commit()
        con.close()
    except Exception:
        pass

    summary = dict(
        week=week_str,
        date_start=str(date_start),
        date_end=str(date_end),
        path=str(note_path),
        total_trades=k.get("total", 0),
        net_pnl=k.get("net", 0),
        win_rate=k.get("wr"),
    )
    return note_path, summary


def list_weekly_reviews() -> pd.DataFrame:
    """List all generated weekly reviews sorted by week desc."""
    files = sorted(WEEKLY_DIR.glob("[0-9][0-9][0-9][0-9]-W*.md"), reverse=True)
    rows = []
    for f in files:
        text = f.read_text(encoding="utf-8", errors="ignore")
        fm   = {}
        if text.startswith("---"):
            end = text.find("\n---", 3)
            if end != -1:
                for line in text[3:end].splitlines():
                    if ":" in line:
                        k2, _, v2 = line.partition(":")
                        fm[k2.strip()] = v2.strip().strip('"')
        rows.append({
            "week":         fm.get("week", f.stem),
            "date_start":   fm.get("date_start", ""),
            "date_end":     fm.get("date_end", ""),
            "total_trades": fm.get("total_trades", ""),
            "win_rate":     fm.get("win_rate", ""),
            "net_pnl":      fm.get("net_pnl", ""),
            "status":       fm.get("status", "draft"),
            "file":         f.name,
        })
    return pd.DataFrame(rows)
