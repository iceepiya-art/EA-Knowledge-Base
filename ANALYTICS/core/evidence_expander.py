"""
evidence_expander.py — Evidence Coverage Expansion Pipeline

Mines 1,548 trades (2016-2026) to expand evidence_links from 5 → 50+.
Adds validation metadata to knowledge_relationships.

Evidence categories:
  1. Strategy all-time evidence (QField 11-year record)
  2. Session × strategy (all 5 sessions, all-time)
  3. Annual temporal consistency (per year, per session × year)
  4. Historical vs recent period comparison
  5. SC₁₀₀ regime compliance (1,002 trades with sc100_value)
  6. Consecutive loss event detection (risk rule validation)
  7. Equity drawdown event detection (max DD rule validation)
  8. Directional bias (SELL vs BUY performance)

Relationship validation:
  - Aggregates evidence_links into per-relationship WR / PF / N / confidence
  - Sets validation_status: validated / observing / testing / unvalidated
  - Links principle_ref where principle keywords match relationship rationale

No machine learning. No autonomous trading. Human-supervised only.
"""

from __future__ import annotations

import math
import re
import sqlite3
import uuid
from datetime import datetime
from pathlib import Path
from typing import Any

_BASE   = Path(__file__).resolve().parents[2]
DB_PATH = _BASE / "DATA" / "processed" / "trades.sqlite"

# Strategy name → knowledge graph node ID
_STRAT_NODE: dict[str, str | None] = {
    "qfield":    "s_qfield",
    "qfield_ea": "s_qfield",
    "ftmo":      "s_qfield",
    "manual":    None,          # no dedicated strategy node
}

# Session label → knowledge graph node ID
_SESSION_NODE: dict[str, str] = {
    "london":    "sess_london",
    "london_ny": "sess_london",  # London/NY overlap → London node
    "ny":        "sess_ny",
    "ny_open":   "sess_ny",
    "asian":     "sess_asian",
}

# Regime bucket → knowledge graph node ID
_REGIME_NODE: dict[str, str] = {
    "crash":     "r_crash",
    "trending":  "r_trending",
    "weak":      "r_weak",
    "reverting": "r_reverting",
}

# Risk rule & behavior node IDs
_RISK_NODES = {
    "max_dd":      "rr_max_dd",
    "consec_loss": "rr_consec_loss",
    "kelly":       "rr_kelly",
    "daily_loss":  "rr_daily_loss",
    "n30":         "rr_n30",
}
_BEHAVIOR_NODES = {
    "fomo":     "b_fomo",
    "revenge":  "b_revenge",
    "overconf": "b_overconf",
}

# Validation columns to add to knowledge_relationships
_VALIDATION_COLS = [
    "ALTER TABLE knowledge_relationships ADD COLUMN validation_status TEXT DEFAULT 'unvalidated'",
    "ALTER TABLE knowledge_relationships ADD COLUMN computed_wr REAL DEFAULT NULL",
    "ALTER TABLE knowledge_relationships ADD COLUMN computed_pf REAL DEFAULT NULL",
    "ALTER TABLE knowledge_relationships ADD COLUMN computed_n INTEGER DEFAULT 0",
    "ALTER TABLE knowledge_relationships ADD COLUMN computed_conf REAL DEFAULT NULL",
    "ALTER TABLE knowledge_relationships ADD COLUMN source_ref TEXT DEFAULT ''",
    "ALTER TABLE knowledge_relationships ADD COLUMN principle_ref TEXT DEFAULT ''",
    "ALTER TABLE knowledge_relationships ADD COLUMN hypothesis_ref TEXT DEFAULT ''",
    "ALTER TABLE knowledge_relationships ADD COLUMN last_validated_at TEXT DEFAULT NULL",
]


# ── DB helpers ─────────────────────────────────────────────────────────────────

def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    con.execute("PRAGMA journal_mode=WAL")
    return con


# ── Migration: validation columns ─────────────────────────────────────────────

def apply_validation_migration() -> bool:
    """
    Add validation metadata columns to knowledge_relationships.
    Safe to call multiple times — checks if already applied.
    """
    con = _con()
    try:
        existing = {r[1] for r in con.execute("PRAGMA table_info(knowledge_relationships)").fetchall()}
        if "validation_status" in existing:
            return False
        for stmt in _VALIDATION_COLS:
            try:
                con.execute(stmt)
                con.commit()
            except Exception:
                pass
        return True
    finally:
        con.close()


# ── Core stat helpers ──────────────────────────────────────────────────────────

def _compute_stats(pnls: list[float], outcomes: list[str]) -> dict[str, Any]:
    n = len(pnls)
    if n == 0:
        return {"n": 0}
    wins   = sum(1 for o in outcomes if o == "WIN")
    losses = sum(1 for o in outcomes if o == "LOSS")
    wr     = wins / (wins + losses) if (wins + losses) > 0 else 0.0
    net    = sum(pnls)
    gw     = sum(p for p in pnls if p > 0)
    gl     = abs(sum(p for p in pnls if p < 0))
    pf     = gw / gl if gl > 0 else (999.0 if gw > 0 else 0.0)
    avgw   = gw / wins   if wins   > 0 else 0.0
    avgl   = gl / losses if losses > 0 else 0.0
    rr     = avgw / avgl if avgl > 0 else 0.0
    exp    = (wr * avgw) - ((1 - wr) * avgl) if avgl > 0 else net / n
    cum = 0.0; peak = 0.0; dd = 0.0
    for p in pnls:
        cum += p
        peak = max(peak, cum)
        dd   = max(dd, peak - cum)
    return {
        "n": n, "wins": wins, "losses": losses,
        "wr": round(wr, 4), "net_pnl": round(net, 2),
        "profit_factor": round(min(pf, 999.0), 3),
        "avg_win": round(avgw, 2), "avg_loss": round(avgl, 2),
        "rr_ratio": round(rr, 2),
        "max_dd": round(dd, 2), "expectancy": round(exp, 2),
    }


def _confidence_from_performance(s: dict) -> float:
    wr = s.get("wr", 0); pf = s.get("profit_factor", 0)
    n  = s.get("n", 0);  net = s.get("net_pnl", 0); dd = s.get("max_dd", 0)
    base  = wr * 50
    pf_pt = min(max(pf - 1.0, 0), 3.0) / 3.0 * 20
    n_pt  = min(math.log10(max(n / 30, 0.1) + 1), 1.0) * 20
    dd_pt = max(0, 10 - (dd / 50000) * 200)
    score = base + pf_pt + n_pt + dd_pt + (5 if net > 0 else 0)
    return round(min(max(score, 0), 100), 1)


def _metric_str(s: dict) -> str:
    return (f"WR={s['wr']:.1%} | PF={s['profit_factor']:.2f} | N={s['n']} | "
            f"MaxDD=${s['max_dd']:.0f} | Expectancy=${s['expectancy']:.2f} | Net=${s['net_pnl']:.0f}")


def _parse_result_metric(text: str) -> dict[str, float]:
    """Parse 'WR=49.5% | PF=1.40 | N=206 | MaxDD=$0' → numeric dict."""
    result: dict[str, float] = {}
    if not text:
        return result
    for part in text.split("|"):
        part = part.strip()
        if "=" not in part:
            continue
        key, raw = part.split("=", 1)
        key = key.strip().upper()
        is_pct = "%" in raw
        clean = raw.strip().rstrip("%").lstrip("$").replace(",", "")
        try:
            num = float(clean)
            result[key] = num / 100.0 if is_pct else num
        except ValueError:
            pass
    return result


# ── Evidence link writer ───────────────────────────────────────────────────────

def _add_ev(
    *,
    rel_id: str | None = None,
    node_id: str | None = None,
    evidence_type: str,
    title: str,
    description: str,
    sample_n: int,
    result_metric: str,
    confidence: float,
    supports: int,
    source_ref: str = "trades.sqlite",
) -> str | None:
    if not node_id and not rel_id:
        return None
    ev_id = f"ev_{uuid.uuid4().hex[:12]}"
    con = _con()
    try:
        # Duplicate guard: same title + same target
        dup = con.execute(
            "SELECT evidence_id FROM evidence_links "
            "WHERE title=? AND (rel_id IS ? OR node_id IS ?)",
            (title[:200], rel_id, node_id),
        ).fetchone()
        if dup:
            return None

        con.execute(
            """INSERT OR IGNORE INTO evidence_links
               (evidence_id, rel_id, node_id, evidence_type, title,
                description, sample_n, result_metric, confidence, supports, source_ref)
               VALUES (?,?,?,?,?,?,?,?,?,?,?)""",
            (ev_id, rel_id, node_id, evidence_type, title[:200],
             description[:500], sample_n, result_metric[:300], confidence, supports, source_ref),
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


# ── Relationship helper ────────────────────────────────────────────────────────

def _get_or_create_rel(
    from_node: str, to_node: str, rel_type: str,
    strength: float, rationale: str,
) -> str | None:
    con = _con()
    try:
        row = con.execute(
            "SELECT rel_id FROM knowledge_relationships "
            "WHERE from_node_id=? AND to_node_id=? AND rel_type=?",
            (from_node, to_node, rel_type),
        ).fetchone()
        if row:
            return row["rel_id"]
    finally:
        con.close()
    import knowledge_graph as kg
    return kg.add_relationship(
        from_node_id=from_node, to_node_id=to_node, rel_type=rel_type,
        strength=strength, rationale=rationale, created_by="evidence_expander",
    )


# ── 1. Strategy all-time evidence ──────────────────────────────────────────────

def expand_strategy_evidence(min_n: int = 10) -> dict[str, Any]:
    """
    All strategies × symbols, all-time trade_batch evidence links.
    Covers the full 2016-2026 record rather than just 2025+.
    """
    con = _con()
    try:
        rows = con.execute(
            "SELECT strategy, symbol, pnl_usd, outcome "
            "FROM trades WHERE outcome IN ('WIN','LOSS','BE') ORDER BY open_time",
        ).fetchall()
    finally:
        con.close()

    buckets: dict[tuple[str, str], tuple[list[float], list[str]]] = {}
    for r in rows:
        k = (r["strategy"] or "unknown", r["symbol"] or "unknown")
        buckets.setdefault(k, ([], []))[0].append(float(r["pnl_usd"] or 0))
        buckets[k][1].append(r["outcome"])

    created = 0
    for (strat, sym), (pnls, outcomes) in buckets.items():
        node_id = _STRAT_NODE.get(strat.lower())
        if not node_id:
            continue
        stats = _compute_stats(pnls, outcomes)
        if stats["n"] < min_n:
            continue
        conf = _confidence_from_performance(stats)
        ev = _add_ev(
            node_id=node_id,
            evidence_type="trade_batch",
            title=f"[all-time] {strat} {sym} (N={stats['n']})",
            description=f"{strat} full 2016-2026 record on {sym}. {_metric_str(stats)}",
            sample_n=stats["n"], result_metric=_metric_str(stats),
            confidence=conf, supports=1 if stats["net_pnl"] > 0 else 0,
        )
        if ev:
            created += 1

    return {"function": "expand_strategy_evidence", "created": created}


# ── 2. Session × strategy evidence (all-time) ─────────────────────────────────

def expand_session_evidence(min_n: int = 15) -> dict[str, Any]:
    """
    All strategy × session combos, all-time.
    Creates works_best_in / fails_in relationships + evidence links.
    """
    con = _con()
    try:
        rows = con.execute(
            "SELECT strategy, session, pnl_usd, outcome "
            "FROM trades "
            "WHERE outcome IN ('WIN','LOSS','BE') AND session IS NOT NULL "
            "ORDER BY open_time",
        ).fetchall()
    finally:
        con.close()

    buckets: dict[tuple[str, str], tuple[list[float], list[str]]] = {}
    for r in rows:
        k = (r["strategy"] or "unknown", r["session"])
        buckets.setdefault(k, ([], []))[0].append(float(r["pnl_usd"] or 0))
        buckets[k][1].append(r["outcome"])

    created = 0
    for (strat, session), (pnls, outcomes) in buckets.items():
        strat_node   = _STRAT_NODE.get(strat.lower())
        session_node = _SESSION_NODE.get(session.lower())
        if not strat_node or not session_node:
            continue
        stats = _compute_stats(pnls, outcomes)
        if stats["n"] < min_n:
            continue
        conf    = _confidence_from_performance(stats)
        is_good = stats["net_pnl"] > 0 and stats["expectancy"] > 0
        rel_type = "works_best_in" if is_good else "fails_in"
        rationale = (
            f"{strat} {session} (all-time): WR={stats['wr']:.1%}, "
            f"PF={stats['profit_factor']:.2f}, N={stats['n']}"
        )
        rel_id = _get_or_create_rel(strat_node, session_node, rel_type, min(conf, 90.0), rationale)
        if rel_id:
            ev = _add_ev(
                rel_id=rel_id,
                evidence_type="trade_batch",
                title=f"[session-all] {strat} x {session} (N={stats['n']})",
                description=rationale,
                sample_n=stats["n"], result_metric=_metric_str(stats),
                confidence=conf, supports=1 if is_good else 0,
            )
            if ev:
                created += 1

    return {"function": "expand_session_evidence", "created": created}


# ── 3. Annual temporal consistency ────────────────────────────────────────────

def compute_annual_evidence(strategy: str = "QField", min_n: int = 30) -> dict[str, Any]:
    """
    Annual trade_batch evidence links for temporal consistency.
    Creates node-level evidence (one per year) showing year-by-year track record.
    """
    con = _con()
    try:
        rows = con.execute(
            "SELECT strftime('%Y', open_time) as yr, pnl_usd, outcome "
            "FROM trades WHERE strategy=? AND outcome IN ('WIN','LOSS','BE') "
            "ORDER BY open_time",
            (strategy,),
        ).fetchall()
    finally:
        con.close()

    node_id = _STRAT_NODE.get(strategy.lower())
    if not node_id:
        return {"function": "compute_annual_evidence", "created": 0}

    buckets: dict[str, tuple[list[float], list[str]]] = {}
    for r in rows:
        yr = r["yr"] or "unknown"
        buckets.setdefault(yr, ([], []))[0].append(float(r["pnl_usd"] or 0))
        buckets[yr][1].append(r["outcome"])

    created = 0
    for yr, (pnls, outcomes) in sorted(buckets.items()):
        stats = _compute_stats(pnls, outcomes)
        if stats["n"] < min_n:
            continue
        conf = _confidence_from_performance(stats)
        ev = _add_ev(
            node_id=node_id,
            evidence_type="trade_batch",
            title=f"[annual-{yr}] {strategy} XAUUSD (N={stats['n']})",
            description=(
                f"{strategy} {yr} annual record: WR={stats['wr']:.1%}, "
                f"PF={stats['profit_factor']:.2f}, Net=${stats['net_pnl']:.0f}"
            ),
            sample_n=stats["n"], result_metric=_metric_str(stats),
            confidence=conf, supports=1 if stats["net_pnl"] > 0 else 0,
            source_ref=f"trades.sqlite | year={yr}",
        )
        if ev:
            created += 1

    return {"function": "compute_annual_evidence", "created": created, "strategy": strategy}


# ── 4. Annual × session evidence ──────────────────────────────────────────────

def compute_session_annual_evidence(strategy: str = "QField", min_n: int = 10) -> dict[str, Any]:
    """
    Per-year per-session evidence for each session relationship.
    Gives temporal granularity to session × strategy relationships.
    """
    con = _con()
    try:
        rows = con.execute(
            "SELECT strftime('%Y', open_time) as yr, session, pnl_usd, outcome "
            "FROM trades WHERE strategy=? AND session IS NOT NULL "
            "AND outcome IN ('WIN','LOSS','BE') ORDER BY open_time",
            (strategy,),
        ).fetchall()
    finally:
        con.close()

    strat_node = _STRAT_NODE.get(strategy.lower())
    if not strat_node:
        return {"function": "compute_session_annual_evidence", "created": 0}

    buckets: dict[tuple[str, str], tuple[list[float], list[str]]] = {}
    for r in rows:
        k = (r["yr"] or "unk", r["session"])
        buckets.setdefault(k, ([], []))[0].append(float(r["pnl_usd"] or 0))
        buckets[k][1].append(r["outcome"])

    created = 0
    for (yr, session), (pnls, outcomes) in sorted(buckets.items()):
        session_node = _SESSION_NODE.get(session.lower())
        if not session_node:
            continue
        stats = _compute_stats(pnls, outcomes)
        if stats["n"] < min_n:
            continue
        conf     = _confidence_from_performance(stats)
        is_good  = stats["net_pnl"] > 0 and stats["expectancy"] > 0
        rel_type = "works_best_in" if is_good else "fails_in"
        rationale = (
            f"{strategy} {session} {yr}: WR={stats['wr']:.1%}, "
            f"PF={stats['profit_factor']:.2f}, N={stats['n']}"
        )
        rel_id = _get_or_create_rel(strat_node, session_node, rel_type, min(conf, 90.0), rationale)
        if rel_id:
            ev = _add_ev(
                rel_id=rel_id,
                evidence_type="trade_batch",
                title=f"[session-{yr}] {strategy} x {session} (N={stats['n']})",
                description=rationale,
                sample_n=stats["n"], result_metric=_metric_str(stats),
                confidence=conf, supports=1 if is_good else 0,
                source_ref=f"trades.sqlite | year={yr} session={session}",
            )
            if ev:
                created += 1

    return {"function": "compute_session_annual_evidence", "created": created}


# ── 5. Historical vs recent period comparison ─────────────────────────────────

def compute_period_comparison(strategy: str = "QField") -> dict[str, Any]:
    """
    Compare historical (2016-2024) vs recent (2025+) performance.
    Detects improvement or deterioration of edge over time.
    """
    node_id = _STRAT_NODE.get(strategy.lower())
    if not node_id:
        return {"function": "compute_period_comparison", "created": 0}

    con = _con()
    try:
        hist_rows = con.execute(
            "SELECT pnl_usd, outcome FROM trades "
            "WHERE strategy=? AND open_time < '2025-01-01' AND outcome IN ('WIN','LOSS','BE')",
            (strategy,),
        ).fetchall()
        recent_rows = con.execute(
            "SELECT pnl_usd, outcome FROM trades "
            "WHERE strategy=? AND open_time >= '2025-01-01' AND outcome IN ('WIN','LOSS','BE')",
            (strategy,),
        ).fetchall()
    finally:
        con.close()

    created = 0
    for period, rows_, label in [
        ("2016-2024", hist_rows, "historical"),
        ("2025-2026", recent_rows, "recent"),
    ]:
        if not rows_:
            continue
        pnls     = [float(r["pnl_usd"] or 0) for r in rows_]
        outcomes = [r["outcome"] for r in rows_]
        stats    = _compute_stats(pnls, outcomes)
        if stats["n"] < 30:
            continue
        conf = _confidence_from_performance(stats)
        ev = _add_ev(
            node_id=node_id,
            evidence_type="trade_batch",
            title=f"[period-{label}] {strategy} {period} (N={stats['n']})",
            description=(
                f"{strategy} {label} period ({period}): "
                f"WR={stats['wr']:.1%}, PF={stats['profit_factor']:.2f}, "
                f"Net=${stats['net_pnl']:.0f}"
            ),
            sample_n=stats["n"], result_metric=_metric_str(stats),
            confidence=conf, supports=1 if stats["net_pnl"] > 0 else 0,
            source_ref=f"trades.sqlite | {period}",
        )
        if ev:
            created += 1

    return {"function": "compute_period_comparison", "created": created}


# ── 6. SC₁₀₀ regime compliance analysis ──────────────────────────────────────

def analyze_regime_compliance(min_n: int = 20) -> dict[str, Any]:
    """
    Bucket trades by SC₁₀₀ value → WR per regime zone.
    Validates the SC₁₀₀ regime detection concept node and regime nodes.
    """
    con = _con()
    try:
        rows = con.execute(
            "SELECT sc100_value, pnl_usd, outcome, strategy "
            "FROM trades WHERE sc100_value > 0 AND outcome IN ('WIN','LOSS','BE')",
        ).fetchall()
    finally:
        con.close()

    # Bucket by SC₁₀₀ zone
    zones: dict[str, tuple[list[float], list[str]]] = {
        "crash": ([], []), "trending": ([], []),
        "weak": ([], []), "reverting": ([], []),
    }
    for r in rows:
        v = float(r["sc100_value"])
        if v < 0.22:
            zone = "crash"
        elif v < 0.25:
            zone = "trending"
        elif v <= 0.35:
            zone = "weak"
        else:
            zone = "reverting"
        zones[zone][0].append(float(r["pnl_usd"] or 0))
        zones[zone][1].append(r["outcome"])

    created = 0
    for zone, (pnls, outcomes) in zones.items():
        regime_node = _REGIME_NODE.get(zone)
        if not regime_node:
            continue
        stats = _compute_stats(pnls, outcomes)
        if stats["n"] < min_n:
            continue
        conf = _confidence_from_performance(stats)

        # Create relationship: s_qfield → regime_node
        is_good  = stats["net_pnl"] > 0
        rel_type = "works_best_in" if is_good else "fails_in"
        rationale = (
            f"SC₁₀₀ {zone.upper()} zone: WR={stats['wr']:.1%}, "
            f"PF={stats['profit_factor']:.2f}, N={stats['n']}"
        )
        rel_id = _get_or_create_rel("s_qfield", regime_node, rel_type, min(conf, 90.0), rationale)

        # Also link to SC₁₀₀ concept node
        sc100_rel = _get_or_create_rel("c_sc100", regime_node, "linked_to_regime", 85.0,
                                       f"SC₁₀₀ defines {zone} regime at {zone} thresholds")

        ev = _add_ev(
            rel_id=rel_id,
            evidence_type="trade_batch",
            title=f"[sc100-{zone}] QField {zone.upper()} regime (N={stats['n']})",
            description=(
                f"QField trades where SC₁₀₀ was in {zone.upper()} zone. "
                f"WR={stats['wr']:.1%}, Net=${stats['net_pnl']:.0f}. "
                f"Validates SC₁₀₀ regime detection for {zone} regime."
            ),
            sample_n=stats["n"], result_metric=_metric_str(stats),
            confidence=conf, supports=1 if is_good else 0,
            source_ref="trades.sqlite | sc100_value bucketing",
        )
        if ev:
            created += 1

    return {"function": "analyze_regime_compliance", "created": created}


# ── 7. Consecutive loss event detection ───────────────────────────────────────

def detect_consecutive_losses(min_streak: int = 3) -> dict[str, Any]:
    """
    Find consecutive loss streaks ≥ min_streak.
    Creates evidence for rr_consec_loss (showing the rule is needed).
    """
    con = _con()
    try:
        rows = con.execute(
            "SELECT strategy, outcome, open_time FROM trades "
            "WHERE outcome IN ('WIN','LOSS','BE') ORDER BY open_time",
        ).fetchall()
    finally:
        con.close()

    # Find streaks per strategy
    strat_streaks: dict[str, list[int]] = {}
    cur_strat = cur_streak = 0
    prev_strat = ""

    for r in rows:
        s = r["strategy"] or "unknown"
        if s != prev_strat:
            if prev_strat and cur_streak >= min_streak:
                strat_streaks.setdefault(prev_strat, []).append(cur_streak)
            cur_streak = 0
            prev_strat = s

        if r["outcome"] == "LOSS":
            cur_streak += 1
        else:
            if cur_streak >= min_streak:
                strat_streaks.setdefault(s, []).append(cur_streak)
            cur_streak = 0

    if cur_streak >= min_streak:
        strat_streaks.setdefault(prev_strat, []).append(cur_streak)

    created = 0
    for strat, streaks in strat_streaks.items():
        strat_node = _STRAT_NODE.get(strat.lower())
        risk_node  = _RISK_NODES["consec_loss"]
        if not strat_node:
            continue
        max_streak = max(streaks)
        count_streaks = len(streaks)
        avg_streak = sum(streaks) / len(streaks)

        rationale = (
            f"{strat} consecutive loss rule: {count_streaks} streaks of {min_streak}+ losses "
            f"(max={max_streak}, avg={avg_streak:.1f})"
        )
        rel_id = _get_or_create_rel(
            strat_node, risk_node, "required_by", 85.0,
            f"{strat} requires consecutive loss rule: {count_streaks} recorded streaks",
        )

        ev = _add_ev(
            rel_id=rel_id, node_id=risk_node,
            evidence_type="trade_batch",
            title=f"[risk-consec] {strat} loss streaks (n_streaks={count_streaks})",
            description=(
                f"{strat} recorded {count_streaks} consecutive loss streaks of {min_streak}+ losses. "
                f"Max streak: {max_streak} losses. Validates the consecutive-loss-pause rule."
            ),
            sample_n=count_streaks, result_metric=f"max_streak={max_streak} | avg={avg_streak:.1f}",
            confidence=80.0, supports=1,
            source_ref="trades.sqlite | consecutive outcome analysis",
        )
        if ev:
            created += 1

    return {"function": "detect_consecutive_losses", "created": created, "streaks": strat_streaks}


# ── 8. Equity drawdown event detection ────────────────────────────────────────

def detect_equity_drawdowns(threshold_pct: float = 0.05) -> dict[str, Any]:
    """
    Detect periods where balance_at_open dropped by threshold_pct from peak.
    Creates evidence for rr_max_dd (showing the rule is needed).
    """
    con = _con()
    try:
        rows = con.execute(
            "SELECT strategy, balance_at_open, open_time "
            "FROM trades WHERE balance_at_open > 0 ORDER BY open_time",
        ).fetchall()
    finally:
        con.close()

    # Group by strategy
    strat_balances: dict[str, list[tuple[str, float]]] = {}
    for r in rows:
        s = r["strategy"] or "unknown"
        strat_balances.setdefault(s, []).append((r["open_time"], float(r["balance_at_open"])))

    created = 0
    for strat, timeline in strat_balances.items():
        strat_node = _STRAT_NODE.get(strat.lower())
        risk_node  = _RISK_NODES["max_dd"]
        if not strat_node:
            continue

        # Detect drawdown events
        peak = 0.0; events = []; in_dd = False; dd_start = ""
        for ts, bal in timeline:
            if bal > peak:
                peak = bal
                in_dd = False
            dd_pct = (peak - bal) / peak if peak > 0 else 0
            if dd_pct >= threshold_pct and not in_dd:
                in_dd = True
                dd_start = ts
                events.append({"start": ts, "peak": peak, "low": bal, "dd_pct": dd_pct})
            elif dd_pct < threshold_pct / 2:
                in_dd = False

        if not events:
            continue

        max_dd_pct = max(e["dd_pct"] for e in events)
        n_events = len(events)

        rel_id = _get_or_create_rel(
            strat_node, risk_node, "required_by", 90.0,
            f"{strat} requires max-DD rule: {n_events} drawdown events ≥{threshold_pct:.0%}",
        )
        ev = _add_ev(
            rel_id=rel_id, node_id=risk_node,
            evidence_type="trade_batch",
            title=f"[risk-dd] {strat} drawdown events (n={n_events})",
            description=(
                f"{strat} had {n_events} drawdown events ≥{threshold_pct:.0%} from peak. "
                f"Max drawdown: {max_dd_pct:.1%}. Validates max drawdown cap rule."
            ),
            sample_n=n_events,
            result_metric=f"n_events={n_events} | max_dd_pct={max_dd_pct:.1%} | threshold={threshold_pct:.0%}",
            confidence=85.0, supports=1,
            source_ref="trades.sqlite | balance_at_open drawdown analysis",
        )
        if ev:
            created += 1

    return {"function": "detect_equity_drawdowns", "created": created}


# ── 9. Directional bias analysis ──────────────────────────────────────────────

def analyze_direction_bias(strategy: str = "QField") -> dict[str, Any]:
    """
    Compare SELL vs BUY performance for a strategy.
    Creates evidence on strategy node showing directional performance split.
    """
    node_id = _STRAT_NODE.get(strategy.lower())
    if not node_id:
        return {"function": "analyze_direction_bias", "created": 0}

    con = _con()
    try:
        rows = con.execute(
            "SELECT direction, pnl_usd, outcome FROM trades "
            "WHERE strategy=? AND outcome IN ('WIN','LOSS','BE') AND direction IS NOT NULL",
            (strategy,),
        ).fetchall()
    finally:
        con.close()

    buckets: dict[str, tuple[list[float], list[str]]] = {}
    for r in rows:
        d = r["direction"] or "unknown"
        buckets.setdefault(d, ([], []))[0].append(float(r["pnl_usd"] or 0))
        buckets[d][1].append(r["outcome"])

    created = 0
    for direction, (pnls, outcomes) in buckets.items():
        stats = _compute_stats(pnls, outcomes)
        if stats["n"] < 15:
            continue
        conf = _confidence_from_performance(stats)
        ev = _add_ev(
            node_id=node_id,
            evidence_type="trade_batch",
            title=f"[direction-{direction}] {strategy} {direction} trades (N={stats['n']})",
            description=(
                f"{strategy} {direction} direction all-time: "
                f"WR={stats['wr']:.1%}, PF={stats['profit_factor']:.2f}, Net=${stats['net_pnl']:.0f}"
            ),
            sample_n=stats["n"], result_metric=_metric_str(stats),
            confidence=conf, supports=1 if stats["net_pnl"] > 0 else 0,
            source_ref="trades.sqlite | direction analysis",
        )
        if ev:
            created += 1

    return {"function": "analyze_direction_bias", "created": created}


# ── 10. Relationship validation aggregation ───────────────────────────────────

def aggregate_relationship_stats() -> dict[str, Any]:
    """
    For every relationship that has evidence_links, aggregate:
    - computed_n, computed_wr, computed_pf, computed_conf, validation_status

    Updates knowledge_relationships with these computed fields.
    Requires apply_validation_migration() to have been called first.
    """
    con = _con()
    try:
        # Check if columns exist
        cols = {r[1] for r in con.execute("PRAGMA table_info(knowledge_relationships)").fetchall()}
        if "validation_status" not in cols:
            return {"function": "aggregate_relationship_stats", "updated": 0, "error": "migration not applied"}

        rels = con.execute("""
            SELECT kr.rel_id,
                   SUM(el.sample_n)   AS total_n,
                   AVG(el.confidence) AS avg_conf,
                   COUNT(el.evidence_id) AS ev_count,
                   GROUP_CONCAT(el.result_metric, '||') AS all_metrics
            FROM knowledge_relationships kr
            JOIN evidence_links el ON el.rel_id = kr.rel_id
            GROUP BY kr.rel_id
        """).fetchall()

        updated = 0
        for rel in rels:
            total_n  = int(rel["total_n"] or 0)
            avg_conf = float(rel["avg_conf"] or 0)

            # Parse WR and PF from all result_metric strings
            wr_sum = pf_sum = n_sum = 0.0
            for metric_str in (rel["all_metrics"] or "").split("||"):
                m = _parse_result_metric(metric_str)
                n = m.get("N", 0)
                if n > 0:
                    wr_sum  += m.get("WR", 0) * n
                    pf_sum  += m.get("PF", 1.0) * n
                    n_sum   += n

            avg_wr = round(wr_sum / n_sum, 4) if n_sum > 0 else None
            avg_pf = round(pf_sum / n_sum, 3) if n_sum > 0 else None

            # Validation status
            if total_n >= 30 and avg_conf >= 65 and (avg_pf or 0) >= 1.2:
                status = "validated"
            elif total_n >= 15 or avg_conf >= 50:
                status = "observing"
            elif rel["ev_count"] > 0:
                status = "testing"
            else:
                status = "unvalidated"

            con.execute("""
                UPDATE knowledge_relationships SET
                    computed_n = ?, computed_wr = ?, computed_pf = ?,
                    computed_conf = ?, validation_status = ?,
                    last_validated_at = datetime('now')
                WHERE rel_id = ?
            """, (total_n, avg_wr, avg_pf, avg_conf, status, rel["rel_id"]))
            updated += 1

        con.commit()
        return {"function": "aggregate_relationship_stats", "updated": updated}
    finally:
        con.close()


# ── 11. Link principles to relationships ──────────────────────────────────────

def link_principles_to_relationships() -> dict[str, Any]:
    """
    Match principle keywords to relationship rationales.
    Sets principle_ref on matching relationships for traceability.
    """
    con = _con()
    try:
        cols = {r[1] for r in con.execute("PRAGMA table_info(knowledge_relationships)").fetchall()}
        if "principle_ref" not in cols:
            return {"function": "link_principles_to_relationships", "linked": 0, "error": "migration not applied"}

        # Load all principles
        principles = con.execute(
            "SELECT principle_id, title, concept, tags FROM mindset_principles WHERE status='active'"
        ).fetchall()

        # Load all relationships
        rels = con.execute(
            "SELECT rel_id, rationale, from_node_id, to_node_id, rel_type "
            "FROM knowledge_relationships WHERE rationale IS NOT NULL AND rationale != ''"
        ).fetchall()

        linked = 0
        for rel in rels:
            rat = (rel["rationale"] or "").lower()
            if not rat:
                continue
            matches = []
            for p in principles:
                # Check if principle keywords appear in relationship rationale
                p_title_lc = (p["title"] or "").lower()
                p_concept_lc = (p["concept"] or "").lower()
                p_tags_lc = (p["tags"] or "").lower()

                # Extract key words (≥6 chars) from principle title
                keywords = [w for w in re.split(r'\W+', p_title_lc) if len(w) >= 6]
                if any(kw in rat for kw in keywords[:3]):
                    matches.append(p["principle_id"])

            if matches:
                ref = ",".join(matches[:3])
                con.execute(
                    "UPDATE knowledge_relationships SET principle_ref=? WHERE rel_id=?",
                    (ref, rel["rel_id"]),
                )
                linked += 1

        con.commit()
        return {"function": "link_principles_to_relationships", "linked": linked}
    finally:
        con.close()


# ── Full expansion pipeline ────────────────────────────────────────────────────

def run_expansion_pipeline(min_n_strat: int = 10, min_n_session: int = 15) -> dict[str, Any]:
    """
    Orchestrate the full evidence expansion pipeline.

    Steps:
    1. Apply validation migration
    2. Expand strategy evidence (all-time)
    3. Expand session evidence (all-time)
    4. Annual temporal consistency
    5. Session × annual granularity
    6. Historical vs recent period comparison
    7. SC₁₀₀ regime compliance
    8. Consecutive loss event detection
    9. Equity drawdown detection
    10. Directional bias analysis
    11. Aggregate relationship validation stats
    12. Link principles to relationships

    Returns: full pipeline summary.
    """
    started = datetime.now().isoformat()
    apply_validation_migration()

    steps: dict[str, Any] = {}

    steps["strategy_evidence"]        = expand_strategy_evidence(min_n=min_n_strat)
    steps["session_evidence"]         = expand_session_evidence(min_n=min_n_session)
    steps["annual_evidence"]          = compute_annual_evidence(strategy="QField", min_n=30)
    steps["session_annual_evidence"]  = compute_session_annual_evidence(strategy="QField", min_n=10)
    steps["period_comparison"]        = compute_period_comparison(strategy="QField")
    steps["regime_compliance"]        = analyze_regime_compliance(min_n=20)
    steps["consecutive_losses"]       = detect_consecutive_losses(min_streak=3)
    steps["equity_drawdowns"]         = detect_equity_drawdowns(threshold_pct=0.05)
    steps["direction_bias"]           = analyze_direction_bias(strategy="QField")
    steps["relationship_validation"]  = aggregate_relationship_stats()
    steps["principle_links"]          = link_principles_to_relationships()

    # Total evidence created
    total_new = sum(
        v.get("created", 0) for v in steps.values() if isinstance(v, dict)
    )

    # Current evidence_links count
    con = _con()
    try:
        total_ev = con.execute("SELECT COUNT(*) FROM evidence_links").fetchone()[0]
        validated_rels = con.execute(
            "SELECT COUNT(*) FROM knowledge_relationships WHERE validation_status='validated'"
        ).fetchone()[0]
        observing_rels = con.execute(
            "SELECT COUNT(*) FROM knowledge_relationships WHERE validation_status='observing'"
        ).fetchone()[0]
    finally:
        con.close()

    return {
        "started_at":          started,
        "completed_at":        datetime.now().isoformat(),
        "steps":               steps,
        "new_evidence_created": total_new,
        "total_evidence_links": total_ev,
        "validated_relationships": validated_rels,
        "observing_relationships": observing_rels,
    }


# ── Evidence summary for dashboard ────────────────────────────────────────────

def get_evidence_summary() -> dict[str, Any]:
    """Return evidence coverage summary for dashboard display."""
    con = _con()
    try:
        total_ev = con.execute("SELECT COUNT(*) FROM evidence_links").fetchone()[0]
        by_type = {
            r["evidence_type"]: r["n"]
            for r in con.execute(
                "SELECT evidence_type, COUNT(*) as n FROM evidence_links GROUP BY evidence_type"
            ).fetchall()
        }
        by_status: dict[str, int] = {}
        cols = {r[1] for r in con.execute("PRAGMA table_info(knowledge_relationships)").fetchall()}
        if "validation_status" in cols:
            for r in con.execute(
                "SELECT validation_status, COUNT(*) as n FROM knowledge_relationships "
                "GROUP BY validation_status"
            ).fetchall():
                by_status[r["validation_status"] or "unvalidated"] = r["n"]

        node_coverage = con.execute(
            "SELECT COUNT(DISTINCT node_id) FROM evidence_links WHERE node_id IS NOT NULL"
        ).fetchone()[0]
        rel_coverage = con.execute(
            "SELECT COUNT(DISTINCT rel_id) FROM evidence_links WHERE rel_id IS NOT NULL"
        ).fetchone()[0]

        return {
            "total_evidence_links": total_ev,
            "by_type":              by_type,
            "by_validation_status": by_status,
            "nodes_with_evidence":  node_coverage,
            "rels_with_evidence":   rel_coverage,
            "generated_at":         datetime.now().isoformat(),
        }
    finally:
        con.close()
