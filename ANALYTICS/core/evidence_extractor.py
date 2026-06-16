"""
evidence_extractor.py — Real Performance Evidence Extraction

Extracts WR, PF, DD, N, expectancy from the trades table and links them
as evidence_links to knowledge graph strategy/session/regime nodes.

Also updates knowledge_node.confidence from empirical trade performance.

Pipeline:
  trades table → compute_strategy_stats() → link_to_graph()
                                           → update_node_confidence()

No machine learning. No autonomous trading. Human-supervised only.
"""

from __future__ import annotations

import math
import sqlite3
import uuid
from datetime import datetime
from pathlib import Path
from typing import Any

# ── Paths ──────────────────────────────────────────────────────────────────────

_BASE   = Path(__file__).resolve().parents[2]
DB_PATH = _BASE / "DATA" / "processed" / "trades.sqlite"

# Strategy name → knowledge graph node ID
_STRAT_NODE = {
    "qfield":        "s_qfield",
    "qfield_ea":     "s_qfield",
    "manual":        None,       # not mapped to a specific strategy node
    "ftmo":          "s_qfield", # FTMO account trades are QField
    "hedgegrid":     "s_hedgegrid",
    "hedgegrid_v23": "s_hedgegrid",
    "quantumqueen":  "s_quantumqueen",
    "smc_universal": "s_smc_univ",
    "ninjathai":     "s_ninja",
    "mmf":           "s_mmf",
    "nq-gc":         "s_nqgc",
}

# Session name → knowledge graph node ID
_SESSION_NODE = {
    "london":    "sess_london",
    "london_ny": "sess_london",
    "ny":        "sess_ny",
    "ny_open":   "sess_ny",
    "asian":     "sess_asian",
}

# Regime name → knowledge graph node ID
_REGIME_NODE = {
    "trending":  "r_trending",
    "reverting": "r_reverting",
    "weak":      "r_weak",
    "crash":     "r_crash",
}

# ── DB helpers ─────────────────────────────────────────────────────────────────

def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    con.execute("PRAGMA journal_mode=WAL")
    return con

# ── Core statistics calculator ─────────────────────────────────────────────────

def _compute_stats(pnl_list: list[float], outcome_list: list[str]) -> dict[str, Any]:
    """
    Given lists of pnl values and outcomes, compute all performance metrics.
    outcome_list values expected: 'WIN', 'LOSS', 'BE'
    """
    n = len(pnl_list)
    if n == 0:
        return {"n": 0}

    wins   = sum(1 for o in outcome_list if o == "WIN")
    losses = sum(1 for o in outcome_list if o == "LOSS")
    be     = sum(1 for o in outcome_list if o == "BE")

    wr     = wins / (wins + losses) if (wins + losses) > 0 else 0.0
    net    = sum(pnl_list)
    avg    = net / n

    gross_win  = sum(p for p in pnl_list if p > 0)
    gross_loss = abs(sum(p for p in pnl_list if p < 0))
    pf         = gross_win / gross_loss if gross_loss > 0 else (float("inf") if gross_win > 0 else 0.0)

    avg_win  = gross_win  / wins   if wins   > 0 else 0.0
    avg_loss = gross_loss / losses if losses > 0 else 0.0
    rr       = avg_win / avg_loss if avg_loss > 0 else 0.0

    # Max drawdown
    cum = 0.0; peak = 0.0; max_dd = 0.0
    for p in pnl_list:
        cum += p
        if cum > peak:
            peak = cum
        dd = peak - cum
        if dd > max_dd:
            max_dd = dd

    # Expectancy per trade
    expectancy = (wr * avg_win) - ((1 - wr) * avg_loss) if avg_loss > 0 else net / n

    return {
        "n":           n,
        "wins":        wins,
        "losses":      losses,
        "be":          be,
        "wr":          round(wr, 4),
        "net_pnl":     round(net, 2),
        "avg_pnl":     round(avg, 2),
        "gross_win":   round(gross_win, 2),
        "gross_loss":  round(gross_loss, 2),
        "profit_factor": round(pf, 3) if pf != float("inf") else 999.0,
        "avg_win":     round(avg_win, 2),
        "avg_loss":    round(avg_loss, 2),
        "rr_ratio":    round(rr, 2),
        "max_dd":      round(max_dd, 2),
        "expectancy":  round(expectancy, 2),
    }


# ── Performance extractors ─────────────────────────────────────────────────────

def compute_strategy_stats(
    since_date: str | None = None,
    min_n: int = 10,
) -> list[dict[str, Any]]:
    """
    Compute WR, PF, DD, N per strategy + symbol combination.

    Args:
        since_date: ISO date string, e.g. '2025-01-01'. None = all time.
        min_n: Minimum trades required to report.

    Returns: list of stat dicts per (strategy, symbol).
    """
    con = _con()
    try:
        where = "WHERE outcome IN ('WIN','LOSS','BE')"
        params: list[Any] = []
        if since_date:
            where += " AND open_time >= ?"
            params.append(since_date)

        rows = con.execute(
            f"SELECT strategy, symbol, pnl_usd, outcome, open_time, session, regime "
            f"FROM trades {where} ORDER BY open_time",
            params,
        ).fetchall()
    finally:
        con.close()

    # Group by strategy + symbol
    buckets: dict[tuple[str, str], tuple[list[float], list[str]]] = {}
    for r in rows:
        key = (r["strategy"] or "unknown", r["symbol"] or "unknown")
        if key not in buckets:
            buckets[key] = ([], [])
        buckets[key][0].append(float(r["pnl_usd"] or 0))
        buckets[key][1].append(r["outcome"])

    result = []
    for (strategy, symbol), (pnls, outcomes) in buckets.items():
        stats = _compute_stats(pnls, outcomes)
        if stats["n"] < min_n:
            continue
        stats["strategy"]  = strategy
        stats["symbol"]    = symbol
        stats["since"]     = since_date or "all_time"
        stats["node_id"]   = _STRAT_NODE.get(strategy.lower())
        result.append(stats)

    return sorted(result, key=lambda x: -x["n"])


def compute_session_stats(
    strategy: str | None = None,
    since_date: str | None = None,
    min_n: int = 10,
) -> list[dict[str, Any]]:
    """Compute WR, PF, DD, N per session (optionally filtered by strategy)."""
    con = _con()
    try:
        parts = ["WHERE outcome IN ('WIN','LOSS','BE') AND session IS NOT NULL"]
        params: list[Any] = []
        if strategy:
            parts.append("AND strategy=?")
            params.append(strategy)
        if since_date:
            parts.append("AND open_time >= ?")
            params.append(since_date)
        where = " ".join(parts)

        rows = con.execute(
            f"SELECT session, pnl_usd, outcome FROM trades {where} ORDER BY session",
            params,
        ).fetchall()
    finally:
        con.close()

    buckets: dict[str, tuple[list[float], list[str]]] = {}
    for r in rows:
        key = r["session"]
        if key not in buckets:
            buckets[key] = ([], [])
        buckets[key][0].append(float(r["pnl_usd"] or 0))
        buckets[key][1].append(r["outcome"])

    result = []
    for session, (pnls, outcomes) in buckets.items():
        stats = _compute_stats(pnls, outcomes)
        if stats["n"] < min_n:
            continue
        stats["session"]  = session
        stats["strategy"] = strategy or "all"
        stats["since"]    = since_date or "all_time"
        stats["node_id"]  = _SESSION_NODE.get(session.lower())
        result.append(stats)

    return sorted(result, key=lambda x: -x["profit_factor"])


def compute_regime_stats(
    strategy: str | None = None,
    since_date: str | None = None,
    min_n: int = 5,
) -> list[dict[str, Any]]:
    """Compute WR, PF, DD, N per regime (where regime data exists)."""
    con = _con()
    try:
        parts = ["WHERE outcome IN ('WIN','LOSS','BE') AND regime IS NOT NULL AND regime != ''"]
        params: list[Any] = []
        if strategy:
            parts.append("AND strategy=?")
            params.append(strategy)
        if since_date:
            parts.append("AND open_time >= ?")
            params.append(since_date)
        where = " ".join(parts)

        rows = con.execute(
            f"SELECT regime, pnl_usd, outcome FROM trades {where}",
            params,
        ).fetchall()
    finally:
        con.close()

    buckets: dict[str, tuple[list[float], list[str]]] = {}
    for r in rows:
        key = r["regime"].lower().strip()
        if key not in buckets:
            buckets[key] = ([], [])
        buckets[key][0].append(float(r["pnl_usd"] or 0))
        buckets[key][1].append(r["outcome"])

    result = []
    for regime, (pnls, outcomes) in buckets.items():
        stats = _compute_stats(pnls, outcomes)
        if stats["n"] < min_n:
            continue
        stats["regime"]   = regime
        stats["strategy"] = strategy or "all"
        stats["node_id"]  = _REGIME_NODE.get(regime)
        result.append(stats)

    return sorted(result, key=lambda x: -x["wr"])


# ── Link evidence to knowledge graph ──────────────────────────────────────────

def _add_evidence_link(
    rel_id: str | None,
    node_id: str | None,
    evidence_type: str,
    title: str,
    description: str,
    sample_n: int,
    result_metric: str,
    confidence: float,
    supports: int,
    source_ref: str = "trades_db",
) -> str | None:
    if not node_id and not rel_id:
        return None
    ev_id = f"ev_{uuid.uuid4().hex[:12]}"
    con = _con()
    try:
        con.execute(
            """INSERT OR IGNORE INTO evidence_links
               (evidence_id, rel_id, node_id, evidence_type, title,
                description, sample_n, result_metric, confidence, supports, source_ref)
               VALUES (?,?,?,?,?,?,?,?,?,?,?)""",
            (ev_id, rel_id, node_id, evidence_type, title[:200],
             description[:500], sample_n, result_metric[:200], confidence, supports, source_ref),
        )
        if rel_id:
            con.execute(
                "UPDATE knowledge_relationships SET evidence_count = evidence_count + 1 WHERE rel_id=?",
                (rel_id,),
            )
        con.commit()
        return ev_id
    except sqlite3.Error:
        con.rollback()
        return None
    finally:
        con.close()


def _get_rel_id(from_node: str, to_node: str, rel_type: str) -> str | None:
    """Look up existing relationship or return None."""
    con = _con()
    try:
        row = con.execute(
            "SELECT rel_id FROM knowledge_relationships "
            "WHERE from_node_id=? AND to_node_id=? AND rel_type=?",
            (from_node, to_node, rel_type),
        ).fetchone()
        return row["rel_id"] if row else None
    finally:
        con.close()


def _upsert_rel(from_node: str, to_node: str, rel_type: str, strength: float, rationale: str) -> str | None:
    """Create relationship if it doesn't exist. Return rel_id."""
    import knowledge_graph as kg
    result = kg.add_relationship(
        from_node_id=from_node,
        to_node_id=to_node,
        rel_type=rel_type,
        strength=strength,
        rationale=rationale,
        created_by="evidence_extractor",
    )
    if result:
        return result
    # Already exists — look up
    return _get_rel_id(from_node, to_node, rel_type)


def _confidence_from_performance(stats: dict) -> float:
    """
    Derive confidence score (0-100) for a knowledge node from performance stats.

    Formula:
      base  = WR * 50 (WR contributes up to 50 pts)
      pf    = min(PF-1, 3) / 3 * 20 (PF above 1.0 contributes up to 20 pts)
      n_adj = min(log10(N/30), 1) * 20 (sample size contributes up to 20 pts)
      dd    = max(0, 10 - DD_pct * 100) (low DD contributes up to 10 pts)
    """
    wr   = stats.get("wr", 0)
    pf   = stats.get("profit_factor", 0)
    n    = stats.get("n", 0)
    net  = stats.get("net_pnl", 0)
    dd   = stats.get("max_dd", 0)
    balance = 50000  # reference account size

    base   = wr * 50
    pf_pt  = min(max(pf - 1.0, 0), 3.0) / 3.0 * 20
    n_pt   = min(math.log10(max(n / 30, 0.1) + 1), 1.0) * 20
    dd_pct = dd / balance if balance > 0 else 0
    dd_pt  = max(0, 10 - dd_pct * 200)

    score = base + pf_pt + n_pt + dd_pt
    # Bonus: if profitable (net > 0)
    if net > 0:
        score = min(score + 5, 100)

    return round(min(max(score, 0), 100), 1)


def link_performance_to_graph(
    since_date: str = "2025-01-01",
    min_n: int = 30,
) -> dict[str, Any]:
    """
    Extract real trade performance and link as evidence to knowledge graph.

    Creates:
    - evidence_links with real sample_n, WR, PF, DD on strategy nodes
    - works_best_in relationships for sessions with positive PF
    - fails_in relationships for regimes with negative expectancy

    Args:
        since_date: Only use trades from this date (default 2025 onwards)
        min_n: Minimum trade count for evidence to count

    Returns: summary dict
    """
    created_evidence = 0
    created_rels = 0

    # ── Strategy evidence ──────────────────────────────────────────────────────
    strat_stats = compute_strategy_stats(since_date=since_date, min_n=min_n)
    for s in strat_stats:
        node_id = s.get("node_id")
        if not node_id:
            continue

        metric_str = (
            f"WR={s['wr']:.1%} | PF={s['profit_factor']:.2f} | "
            f"N={s['n']} | MaxDD=${s['max_dd']:.0f} | "
            f"Expectancy=${s['expectancy']:.2f} | Net=${s['net_pnl']:.0f}"
        )
        desc = (
            f"{s['strategy']} on {s['symbol']} | Period: {s['since']} to present | "
            f"Wins: {s['wins']}, Losses: {s['losses']} | {metric_str}"
        )

        ev = _add_evidence_link(
            rel_id=None,
            node_id=node_id,
            evidence_type="trade_batch",
            title=f"[live] {s['strategy']} {s['symbol']} (N={s['n']})",
            description=desc,
            sample_n=s["n"],
            result_metric=metric_str,
            confidence=_confidence_from_performance(s),
            supports=1 if s["net_pnl"] > 0 else 0,
            source_ref=f"trades.sqlite | {since_date} onwards",
        )
        if ev:
            created_evidence += 1

        # Update node confidence
        perf_conf = _confidence_from_performance(s)
        con = _con()
        try:
            con.execute(
                "UPDATE knowledge_nodes SET confidence=?, updated_at=datetime('now') WHERE node_id=?",
                (perf_conf, node_id),
            )
            con.commit()
        finally:
            con.close()

    # ── Session evidence ───────────────────────────────────────────────────────
    sess_stats = compute_session_stats(strategy="QField", since_date=since_date, min_n=min_n)
    for s in sess_stats:
        sess_node = s.get("node_id")
        strat_node = "s_qfield"
        if not sess_node:
            continue

        rel_type = "works_best_in" if s["profit_factor"] >= 1.2 and s["wr"] >= 0.35 else "fails_in"
        rationale = (
            f"QField {s['session']}: WR={s['wr']:.1%}, PF={s['profit_factor']:.2f}, "
            f"N={s['n']} ({since_date} onwards)"
        )
        strength = min(95.0, _confidence_from_performance(s))

        rel_id = _upsert_rel(strat_node, sess_node, rel_type, strength, rationale)
        if rel_id:
            metric_str = (
                f"WR={s['wr']:.1%} | PF={s['profit_factor']:.2f} | "
                f"N={s['n']} | MaxDD=${s['max_dd']:.0f}"
            )
            ev = _add_evidence_link(
                rel_id=rel_id,
                node_id=None,
                evidence_type="trade_batch",
                title=f"[live] QField × {s['session']} (N={s['n']})",
                description=rationale,
                sample_n=s["n"],
                result_metric=metric_str,
                confidence=strength,
                supports=1 if rel_type == "works_best_in" else 0,
                source_ref=f"trades.sqlite | {since_date} onwards",
            )
            if ev:
                created_evidence += 1
            created_rels += 1

    # ── Regime evidence ────────────────────────────────────────────────────────
    regime_stats = compute_regime_stats(strategy="QField", since_date=since_date, min_n=5)
    for s in regime_stats:
        regime_node = s.get("node_id")
        strat_node  = "s_qfield"
        if not regime_node:
            continue

        rel_type  = "works_best_in" if s["wr"] >= 0.4 and s["profit_factor"] >= 1.0 else "fails_in"
        rationale = (
            f"QField {s['regime']} regime: WR={s['wr']:.1%}, PF={s['profit_factor']:.2f}, "
            f"N={s['n']} ({since_date} onwards)"
        )
        strength  = min(90.0, _confidence_from_performance(s))

        rel_id = _upsert_rel(strat_node, regime_node, rel_type, strength, rationale)
        if rel_id:
            metric_str = f"WR={s['wr']:.1%} | PF={s['profit_factor']:.2f} | N={s['n']}"
            ev = _add_evidence_link(
                rel_id=rel_id,
                node_id=None,
                evidence_type="trade_batch",
                title=f"[live] QField × {s['regime']} regime (N={s['n']})",
                description=rationale,
                sample_n=s["n"],
                result_metric=metric_str,
                confidence=strength,
                supports=1 if rel_type == "works_best_in" else 0,
                source_ref=f"trades.sqlite | {since_date} onwards",
            )
            if ev:
                created_evidence += 1
            created_rels += 1

    return {
        "strategy_records":  len(strat_stats),
        "session_records":   len(sess_stats),
        "regime_records":    len(regime_stats),
        "evidence_created":  created_evidence,
        "rels_created_or_updated": created_rels,
    }


# ── Hypothesis validation from trade batch ─────────────────────────────────────

def validate_hypothesis_from_trades(
    hyp_id: str,
    strategy: str,
    symbol: str,
    session: str | None = None,
    regime: str | None = None,
    since_date: str | None = None,
) -> dict[str, Any]:
    """
    Validate a hypothesis against actual trade data.

    Fetches matching trades, computes stats, and updates the hypotheses table.
    Returns validation result with pass/fail assessment.

    This is a human-supervised validation — it produces a result for the
    researcher to review, NOT an automated promotion.
    """
    con = _con()
    try:
        where = "WHERE strategy=? AND symbol=? AND outcome IN ('WIN','LOSS','BE')"
        params: list[Any] = [strategy, symbol]
        if session:
            where += " AND session=?"
            params.append(session)
        if regime:
            where += " AND regime=?"
            params.append(regime)
        if since_date:
            where += " AND open_time >= ?"
            params.append(since_date)

        rows = con.execute(
            f"SELECT pnl_usd, outcome, open_time FROM trades {where} ORDER BY open_time",
            params,
        ).fetchall()

        pnls     = [float(r["pnl_usd"] or 0) for r in rows]
        outcomes = [r["outcome"] for r in rows]
        stats    = _compute_stats(pnls, outcomes)

        if stats["n"] == 0:
            return {"hyp_id": hyp_id, "status": "no_data", "n": 0}

        # Retrieve hypothesis targets
        hyp = con.execute(
            "SELECT * FROM hypotheses WHERE hyp_id=?", (hyp_id,)
        ).fetchone()

        if not hyp:
            return {"hyp_id": hyp_id, "status": "hyp_not_found"}

        target_wr  = hyp["target_wr"] or 0.5
        target_pf  = hyp["target_pf"] or 1.5
        min_trades = hyp["min_trades"] or 30

        n_ok  = stats["n"] >= min_trades
        wr_ok = stats["wr"] >= target_wr
        pf_ok = stats["profit_factor"] >= target_pf

        all_pass  = n_ok and wr_ok and pf_ok
        new_status = (
            "validated" if all_pass else
            "observing" if n_ok else
            "testing"
        )

        # Update hypothesis record
        con.execute(
            """UPDATE hypotheses SET
               actual_n=?, actual_wr=?, actual_pf=?,
               actual_exp=?, actual_net=?, stats_at=?,
               status=?, updated_at=datetime('now')
               WHERE hyp_id=?""",
            (
                stats["n"], stats["wr"], stats["profit_factor"],
                stats["expectancy"], stats["net_pnl"],
                datetime.now().isoformat(),
                new_status, hyp_id,
            ),
        )
        con.commit()

        return {
            "hyp_id":       hyp_id,
            "status":       new_status,
            "n":            stats["n"],
            "wr":           stats["wr"],
            "pf":           stats["profit_factor"],
            "max_dd":       stats["max_dd"],
            "expectancy":   stats["expectancy"],
            "net_pnl":      stats["net_pnl"],
            "targets_met":  {"n": n_ok, "wr": wr_ok, "pf": pf_ok},
            "all_pass":     all_pass,
            "notes":        (
                f"Validated against {stats['n']} trades "
                f"({'passed' if all_pass else 'failed'} all targets)"
            ),
        }
    finally:
        con.close()


# ── Auto-generate hypothesis drafts from trade performance ────────────────────

def auto_generate_hypotheses(
    since_date: str = "2025-01-01",
    min_n: int = 30,
) -> list[dict[str, Any]]:
    """
    Scan trade performance and generate hypothesis draft candidates.

    Rules for generating a hypothesis:
    - Strategy+session combo with WR >= 40% and N >= min_n
    - Strategy+session combo with PF >= 1.5 and N >= min_n
    - Strategy alone with PF >= 2.0 and N >= min_n

    Returns list of hypothesis dicts (not yet inserted — human reviews first).
    """
    candidates: list[dict[str, Any]] = []

    # ── Session hypotheses ─────────────────────────────────────────────────────
    sess_stats = compute_session_stats(strategy="QField", since_date=since_date, min_n=min_n)
    for s in sess_stats:
        if s["profit_factor"] < 1.2 or s["wr"] < 0.3:
            continue

        edge_type = "best" if s["profit_factor"] >= 2.0 and s["wr"] >= 0.5 else "positive"
        title = f"QField has {edge_type} edge in {s['session']} session"
        candidates.append({
            "title":       title,
            "description": (
                f"QField shows {s['wr']:.1%} WR and PF={s['profit_factor']:.2f} "
                f"in {s['session']} session (N={s['n']}, since {since_date}). "
                f"Expectancy: ${s['expectancy']:.2f}/trade."
            ),
            "ea_name":    "QField",
            "symbol":     "XAUUSD",
            "session":    s["session"],
            "target_wr":  round(s["wr"] * 0.9, 3),
            "target_pf":  round(s["profit_factor"] * 0.85, 2),
            "actual_n":   s["n"],
            "actual_wr":  s["wr"],
            "actual_pf":  s["profit_factor"],
            "actual_exp": s["expectancy"],
            "actual_net": s["net_pnl"],
            "min_trades": min_n,
            "status":     "observing" if s["n"] >= 50 else "testing",
            "source_note": f"auto-generated from trade_batch evidence | {since_date} onwards",
        })

    # ── Strategy-level hypothesis ──────────────────────────────────────────────
    strat_stats = compute_strategy_stats(since_date=since_date, min_n=min_n)
    for s in strat_stats:
        if s.get("node_id") is None:
            continue
        if s["profit_factor"] < 1.5:
            continue
        title = f"{s['strategy']} profitable edge on {s['symbol']} ({since_date[:4]}+)"
        candidates.append({
            "title":       title,
            "description": (
                f"{s['strategy']} shows WR={s['wr']:.1%}, PF={s['profit_factor']:.2f}, "
                f"Expectancy=${s['expectancy']:.2f}/trade "
                f"on {s['symbol']} since {since_date} (N={s['n']}). "
                f"MaxDD=${s['max_dd']:.0f}."
            ),
            "ea_name":    s["strategy"],
            "symbol":     s["symbol"],
            "session":    None,
            "target_wr":  round(s["wr"] * 0.85, 3),
            "target_pf":  round(s["profit_factor"] * 0.80, 2),
            "actual_n":   s["n"],
            "actual_wr":  s["wr"],
            "actual_pf":  s["profit_factor"],
            "actual_exp": s["expectancy"],
            "actual_net": s["net_pnl"],
            "min_trades": min_n,
            "status":     "observing" if s["n"] >= 100 else "testing",
            "source_note": f"auto-generated from trade_batch evidence | {since_date} onwards",
        })

    return candidates


def insert_hypothesis_candidates(
    candidates: list[dict[str, Any]],
    dry_run: bool = True,
) -> dict[str, Any]:
    """
    Insert auto-generated hypothesis candidates into the hypotheses table.
    Skips duplicates by checking title.

    dry_run=True: report what would be inserted without making changes.
    """
    import uuid as _uuid
    inserted = 0
    skipped  = 0
    con = _con()
    try:
        existing_titles = {
            r[0] for r in con.execute("SELECT title FROM hypotheses").fetchall()
        }
        for cand in candidates:
            if cand["title"] in existing_titles:
                skipped += 1
                continue
            if dry_run:
                inserted += 1
                continue
            hyp_id = _uuid.uuid4().hex[:12]
            con.execute(
                """INSERT INTO hypotheses
                   (hyp_id, title, description, status, ea_name, symbol,
                    session, min_trades, target_wr, target_pf,
                    actual_n, actual_wr, actual_pf, actual_exp, actual_net,
                    stats_at, source_note, created_at, updated_at)
                   VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,datetime('now'),datetime('now'))""",
                (
                    hyp_id, cand["title"], cand["description"],
                    cand["status"], cand["ea_name"], cand["symbol"],
                    cand.get("session"), cand["min_trades"],
                    cand["target_wr"], cand["target_pf"],
                    cand["actual_n"], cand["actual_wr"], cand["actual_pf"],
                    cand["actual_exp"], cand["actual_net"],
                    datetime.now().isoformat(), cand["source_note"],
                ),
            )
            inserted += 1
            existing_titles.add(cand["title"])
        if not dry_run:
            con.commit()
    finally:
        con.close()

    return {
        "candidates":  len(candidates),
        "inserted":    inserted,
        "skipped":     skipped,
        "dry_run":     dry_run,
    }


# ── Full evidence pipeline ────────────────────────────────────────────────────

def run_evidence_pipeline(
    since_date: str = "2025-01-01",
    min_n_evidence: int = 30,
    auto_hypotheses: bool = True,
    dry_run_hyp: bool = True,
) -> dict[str, Any]:
    """
    Full evidence extraction pipeline:
    1. Extract trade performance and link to knowledge graph
    2. Auto-generate hypothesis candidates (human reviews before inserting)

    dry_run_hyp: If True, generate hypothesis candidates but don't insert them.
    """
    result: dict[str, Any] = {"started_at": datetime.now().isoformat()}

    # 1. Link performance to graph
    perf = link_performance_to_graph(since_date=since_date, min_n=min_n_evidence)
    result["performance_evidence"] = perf

    # 2. Hypothesis candidates
    if auto_hypotheses:
        candidates = auto_generate_hypotheses(since_date=since_date, min_n=min_n_evidence)
        insert_result = insert_hypothesis_candidates(candidates, dry_run=dry_run_hyp)
        result["hypothesis_candidates"] = insert_result
        result["candidates_detail"] = [
            {"title": c["title"], "status": c["status"], "n": c["actual_n"],
             "wr": c["actual_wr"], "pf": c["actual_pf"]}
            for c in candidates
        ]

    result["completed_at"] = datetime.now().isoformat()
    return result


# ── Reporting ─────────────────────────────────────────────────────────────────

def get_performance_summary(since_date: str = "2025-01-01") -> dict[str, Any]:
    """Top-level performance summary for dashboard display."""
    strat = compute_strategy_stats(since_date=since_date, min_n=10)
    sess  = compute_session_stats(strategy="QField", since_date=since_date, min_n=10)

    return {
        "strategies":  strat,
        "sessions":    sess,
        "since":       since_date,
        "generated_at": datetime.now().isoformat(),
    }
