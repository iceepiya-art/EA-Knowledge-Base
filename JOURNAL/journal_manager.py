"""
journal_manager.py — Annotate, query, and export trades from journal.sqlite

Usage examples:
  # Annotate a single trade
  python journal_manager.py annotate --id AUTO-XAUUSD-20260510T1432-B-00001 \
      --emotional-state Calm \
      --mistakes late_entry \
      --execution-score 7 \
      --setup-quality 4 \
      --plan-followed 1

  # Export current journal to CSV
  python journal_manager.py export --output REPORTS/weekly/export_2026-W19.csv

  # Show stats summary
  python journal_manager.py stats

  # Query by strategy
  python journal_manager.py query --strategy QField --last 30
"""

import sqlite3
import pandas as pd
import json
import argparse
import sys
import logging
from pathlib import Path
from datetime import datetime, timedelta

# ── Paths ──────────────────────────────────────────────────────────────────────
BASE_DIR = Path(__file__).resolve().parents[1]
CFG_PATH = BASE_DIR / "SYSTEM" / "config" / "system_config.json"

with open(CFG_PATH) as f:
    CFG = json.load(f)

DB_PATH = BASE_DIR / CFG["db"]["trades_db"]

logging.basicConfig(level=logging.INFO, format="%(asctime)s %(message)s")
log = logging.getLogger(__name__)

# ── Controlled vocabulary ──────────────────────────────────────────────────────
VALID_MISTAKES = {
    "late_entry", "early_entry", "moved_sl", "removed_tp",
    "oversized", "undersized", "revenge_trade", "fomo_entry",
    "wrong_session", "ignored_regime", "wrong_direction",
    "chased_price", "no_confirmation", "poor_rr",
}

VALID_EMOTIONAL = {
    "Calm", "Confident", "FOMO", "Revenge", "Bored", "Anxious", "Greedy"
}

# ── Connection ─────────────────────────────────────────────────────────────────
def get_con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    return con


# ── Annotate ───────────────────────────────────────────────────────────────────
def annotate_trade(trade_id: str, **kwargs):
    """
    Update behavioral annotation fields on a single trade.
    Every change is logged to the annotations table.

    Accepted kwargs:
      emotional_state  (str from VALID_EMOTIONAL)
      mistakes         (list[str] or pipe-separated string)
      execution_score  (int 1-10)
      setup_quality    (int 1-5)
      plan_followed    (int 0 or 1)
      entry_timing     (Early | OnTime | Late)
      exit_reason      (TP_Hit | SL_Hit | Manual_Close | Trail_Stop | EA_Close)
      notes            (str)
      screenshot_path  (str)
      news_event       (int 0 or 1)
    """
    con = get_con()
    cur = con.cursor()
    cur.execute("SELECT * FROM trades WHERE trade_id = ?", (trade_id,))
    row = cur.fetchone()
    if not row:
        log.error(f"Trade not found: {trade_id}")
        con.close()
        return

    updates = {}

    if "emotional_state" in kwargs:
        v = kwargs["emotional_state"]
        if v not in VALID_EMOTIONAL:
            log.warning(f"Invalid emotional_state '{v}'. Valid: {VALID_EMOTIONAL}")
        else:
            updates["emotional_state"] = v

    if "mistakes" in kwargs:
        raw = kwargs["mistakes"]
        if isinstance(raw, list):
            items = raw
        else:
            items = [x.strip() for x in str(raw).replace(",", "|").split("|") if x.strip()]
        invalid = set(items) - VALID_MISTAKES
        if invalid:
            log.warning(f"Unknown mistakes (ignored): {invalid}")
        valid_items = [x for x in items if x in VALID_MISTAKES]
        updates["mistakes"] = "|".join(valid_items) if valid_items else None

    for int_field, lo, hi in [
        ("execution_score", 1, 10),
        ("setup_quality", 1, 5),
        ("plan_followed", 0, 1),
        ("news_event", 0, 1),
    ]:
        if int_field in kwargs:
            v = int(kwargs[int_field])
            if lo <= v <= hi:
                updates[int_field] = v
            else:
                log.warning(f"{int_field} must be {lo}–{hi}")

    for str_field in ("entry_timing", "exit_reason", "notes", "screenshot_path"):
        if str_field in kwargs and kwargs[str_field] is not None:
            updates[str_field] = str(kwargs[str_field])

    if not updates:
        log.info("Nothing to update.")
        con.close()
        return

    # Log each change to annotations table
    for field, new_val in updates.items():
        old_val = row[field] if field in row.keys() else None
        cur.execute(
            "INSERT INTO annotations (trade_id, field_name, old_value, new_value) VALUES (?,?,?,?)",
            (trade_id, field, str(old_val), str(new_val))
        )

    # Apply update
    set_clause = ", ".join(f"{k} = ?" for k in updates)
    values = list(updates.values()) + [trade_id]
    cur.execute(f"UPDATE trades SET {set_clause} WHERE trade_id = ?", values)
    con.commit()
    con.close()
    log.info(f"Annotated {trade_id}: {updates}")


# ── Query ──────────────────────────────────────────────────────────────────────
def query_trades(
    strategy: str = None,
    symbol: str = None,
    regime: str = None,
    session: str = None,
    outcome: str = None,
    last_n_days: int = None,
    last_n_trades: int = None,
    unannotated: bool = False,
) -> pd.DataFrame:
    con = get_con()
    conditions = []
    params = []

    if strategy:
        conditions.append("strategy = ?"); params.append(strategy)
    if symbol:
        conditions.append("symbol = ?"); params.append(symbol)
    if regime:
        conditions.append("regime = ?"); params.append(regime)
    if session:
        conditions.append("session = ?"); params.append(session)
    if outcome:
        conditions.append("outcome = ?"); params.append(outcome)
    if last_n_days:
        cutoff = (datetime.now() - timedelta(days=last_n_days)).isoformat()
        conditions.append("open_time >= ?"); params.append(cutoff)
    if unannotated:
        conditions.append("emotional_state IS NULL")

    where = "WHERE " + " AND ".join(conditions) if conditions else ""
    limit = f"LIMIT {last_n_trades}" if last_n_trades else ""
    sql = f"SELECT * FROM trades {where} ORDER BY open_time DESC {limit}"

    df = pd.read_sql_query(sql, con, params=params)
    con.close()
    return df


# ── Quick stats ────────────────────────────────────────────────────────────────
def print_stats(df: pd.DataFrame = None, label: str = "All trades"):
    if df is None:
        df = query_trades()

    if df.empty:
        print("No trades found.")
        return

    wins   = df[df.outcome == "WIN"]
    losses = df[df.outcome == "LOSS"]
    total  = len(df)
    wr     = len(wins) / total if total else 0
    avg_win  = wins.pnl_usd.mean()  if len(wins)   else 0
    avg_loss = losses.pnl_usd.mean() if len(losses) else 0
    pf = abs(wins.pnl_usd.sum() / losses.pnl_usd.sum()) if len(losses) and losses.pnl_usd.sum() != 0 else float("inf")
    exp = (wr * avg_win) + ((1 - wr) * avg_loss)

    print(f"\n{'─'*50}")
    print(f"  Stats: {label}")
    print(f"{'─'*50}")
    print(f"  Trades     : {total}")
    print(f"  Win Rate   : {wr:.1%}")
    print(f"  Avg Win    : ${avg_win:,.2f}")
    print(f"  Avg Loss   : ${avg_loss:,.2f}")
    print(f"  Prof Factor: {pf:.2f}")
    print(f"  Expectancy : ${exp:,.2f}")
    print(f"  Net PnL    : ${df.pnl_usd.sum():,.2f}")
    if "strategy" in df.columns:
        print(f"\n  By Strategy:")
        for strat, g in df.groupby("strategy"):
            w = len(g[g.outcome=="WIN"])
            print(f"    {strat:<20} {w}/{len(g)} ({w/len(g):.0%}) PnL: ${g.pnl_usd.sum():,.0f}")
    if "regime" in df.columns:
        print(f"\n  By Regime:")
        for reg, g in df.groupby("regime"):
            if reg:
                w = len(g[g.outcome=="WIN"])
                print(f"    {str(reg):<14} {w}/{len(g)} ({w/len(g):.0%}) PnL: ${g.pnl_usd.sum():,.0f}")
    if "mistakes" in df.columns:
        all_mistakes = df.mistakes.dropna().str.split("|").explode()
        if not all_mistakes.empty:
            top = all_mistakes.value_counts().head(5)
            print(f"\n  Top Mistakes:")
            for m, c in top.items():
                print(f"    {m:<20} {c}×")
    print(f"{'─'*50}\n")


# ── Export to CSV ──────────────────────────────────────────────────────────────
def export_csv(output_path: str = None, **query_kwargs) -> str:
    df = query_trades(**query_kwargs)
    if not output_path:
        week = datetime.now().strftime("%Y-W%V")
        output_path = str(BASE_DIR / "REPORTS" / "weekly" / f"{week}_export.csv")
    Path(output_path).parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(output_path, index=False)
    log.info(f"Exported {len(df)} rows → {output_path}")
    return output_path


# ── AI summary prompt builder ──────────────────────────────────────────────────
def build_ai_prompt(df: pd.DataFrame = None, period: str = "Last 7 days") -> str:
    """
    Generates a structured prompt ready to paste into Claude or ChatGPT.
    Contains only stats — no raw trade data (keeps prompt concise).
    """
    if df is None:
        df = query_trades(last_n_days=7)

    wins   = df[df.outcome == "WIN"]
    losses = df[df.outcome == "LOSS"]
    total  = len(df)
    if total == 0:
        return "No trades to summarize."

    wr  = len(wins) / total
    pf  = abs(wins.pnl_usd.sum() / losses.pnl_usd.sum()) if len(losses) and losses.pnl_usd.sum() else float("inf")
    exp = (wr * wins.pnl_usd.mean() if len(wins) else 0) + ((1-wr) * losses.pnl_usd.mean() if len(losses) else 0)

    regime_lines = ""
    if "regime" in df.columns:
        for reg, g in df.groupby("regime"):
            if reg:
                w = len(g[g.outcome=="WIN"])
                regime_lines += f"  {reg}: {w}/{len(g)} ({w/len(g):.0%})\n"

    session_lines = ""
    if "session" in df.columns:
        for ses, g in df.groupby("session"):
            if ses:
                w = len(g[g.outcome=="WIN"])
                session_lines += f"  {ses}: {w}/{len(g)} ({w/len(g):.0%})\n"

    mistake_lines = ""
    if "mistakes" in df.columns:
        top_m = df.mistakes.dropna().str.split("|").explode().value_counts().head(5)
        for m, c in top_m.items():
            mistake_lines += f"  {m}: {c}×\n"

    prompt = f"""
=== WEEKLY PERFORMANCE SUMMARY — {period} ===

OVERVIEW
  Total trades    : {total}
  Win rate        : {wr:.1%}
  Profit factor   : {pf:.2f}
  Expectancy      : ${exp:,.2f}/trade
  Net PnL         : ${df.pnl_usd.sum():,.2f}
  Avg trade dur.  : {df.duration_min.mean():.0f} min (if available)

REGIME BREAKDOWN
{regime_lines or "  (no regime data)"}
SESSION BREAKDOWN
{session_lines or "  (no session data)"}
TOP MISTAKES
{mistake_lines or "  (no mistake annotations)"}
EMOTIONAL STATE
{df.emotional_state.value_counts().to_string() if "emotional_state" in df.columns else "  (not annotated)"}

=== TASK FOR AI ===
1. Identify any regime or session where WR is below 55% — suggest filtering it.
2. Identify the most frequent mistake and suggest one workflow change to fix it.
3. Flag any behavioral risk patterns (FOMO, revenge, lot creep).
4. State: is this week's edge consistent with prior weeks, or degrading?
5. Suggest 1–2 specific hypotheses to test next week.

Keep analysis to bullet points. Do not predict future prices.
Do not suggest adding complexity. Focus on removing what doesn't work.
""".strip()
    return prompt


# ── CLI ────────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Journal Manager")
    sub = parser.add_subparsers(dest="cmd")

    # annotate
    ann = sub.add_parser("annotate", help="Annotate a trade")
    ann.add_argument("--id",               required=True)
    ann.add_argument("--emotional-state",  choices=list(VALID_EMOTIONAL))
    ann.add_argument("--mistakes",         help="Pipe-separated: late_entry|moved_sl")
    ann.add_argument("--execution-score",  type=int)
    ann.add_argument("--setup-quality",    type=int)
    ann.add_argument("--plan-followed",    type=int, choices=[0,1])
    ann.add_argument("--entry-timing",     choices=["Early","OnTime","Late"])
    ann.add_argument("--notes")
    ann.add_argument("--screenshot",       dest="screenshot_path")

    # query
    qry = sub.add_parser("query", help="Query trades")
    qry.add_argument("--strategy")
    qry.add_argument("--symbol")
    qry.add_argument("--regime")
    qry.add_argument("--session")
    qry.add_argument("--outcome")
    qry.add_argument("--last",    type=int, dest="last_n_days")
    qry.add_argument("--last-n",  type=int, dest="last_n_trades")

    # stats
    sub.add_parser("stats", help="Print performance stats")

    # export
    exp_p = sub.add_parser("export", help="Export to CSV")
    exp_p.add_argument("--output")
    exp_p.add_argument("--last", type=int, dest="last_n_days")

    # ai-prompt
    ai_p = sub.add_parser("ai-prompt", help="Generate AI summary prompt")
    ai_p.add_argument("--last", type=int, default=7, dest="last_n_days")

    args = parser.parse_args()

    if args.cmd == "annotate":
        kw = {}
        for k in ("emotional_state","mistakes","execution_score","setup_quality",
                  "plan_followed","entry_timing","notes","screenshot_path"):
            attr = k.replace("_", "-") if k in ("entry_timing",) else k
            v = getattr(args, k.replace("-","_"), None)
            if v is not None:
                kw[k] = v
        annotate_trade(args.id, **kw)

    elif args.cmd == "query":
        df = query_trades(
            strategy=args.strategy, symbol=args.symbol,
            regime=args.regime, session=args.session,
            outcome=args.outcome, last_n_days=args.last_n_days,
            last_n_trades=args.last_n_trades,
        )
        print(df.to_string(index=False))

    elif args.cmd == "stats":
        print_stats()

    elif args.cmd == "export":
        export_csv(output_path=args.output, last_n_days=getattr(args,"last_n_days",None))

    elif args.cmd == "ai-prompt":
        df = query_trades(last_n_days=args.last_n_days)
        print(build_ai_prompt(df, period=f"Last {args.last_n_days} days"))

    else:
        parser.print_help()
