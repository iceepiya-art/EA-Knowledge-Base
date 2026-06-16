"""
edge_stability.py — Edge Stability and Fragility Analysis

Measures the robustness of every validated relationship in the knowledge graph.

Metrics computed per relationship / strategy node:
  - fragility_score      : coefficient of variation of evidence confidence (0-100)
  - regime_dependency    : 0-1; 1.0 = only evidenced by one regime
  - session_dependency   : 0-1; 1.0 = only evidenced by one session
  - temporal_consistency : CoV of net_pnl across annual evidence periods (0-100)
  - dd_sensitivity       : WR ratio during high-DD vs low-DD balance periods (0-1)
  - stability_score      : composite inverse of all fragilities (0-100; 100 = most robust)

All metrics are stored back in knowledge_relationships (requires migration 011 columns).
"""

from __future__ import annotations

import math
import sqlite3
from datetime import datetime
from pathlib import Path
from typing import Any

_BASE   = Path(__file__).resolve().parents[2]
DB_PATH = _BASE / "DATA" / "processed" / "trades.sqlite"

_STRAT_NODE: dict[str, str] = {
    "qfield": "s_qfield",
    "ftmo":   "s_qfield",
}


# ── DB helper ──────────────────────────────────────────────────────────────────

def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    con.execute("PRAGMA journal_mode=WAL")
    return con


# ── Statistics helpers ─────────────────────────────────────────────────────────

def _cov(values: list[float]) -> float:
    """Coefficient of variation (0-1). Returns 0 if <2 values or mean=0."""
    if len(values) < 2:
        return 0.0
    mean = sum(values) / len(values)
    if abs(mean) < 1e-9:
        return 1.0
    variance = sum((v - mean) ** 2 for v in values) / len(values)
    return math.sqrt(variance) / abs(mean)


_STABILITY_COLS = [
    "ALTER TABLE knowledge_relationships ADD COLUMN stability_score REAL DEFAULT NULL",
    "ALTER TABLE knowledge_relationships ADD COLUMN fragility_score REAL DEFAULT NULL",
    "ALTER TABLE knowledge_relationships ADD COLUMN regime_dependency REAL DEFAULT NULL",
    "ALTER TABLE knowledge_relationships ADD COLUMN session_dependency REAL DEFAULT NULL",
]


def apply_stability_migration() -> bool:
    """Add stability columns to knowledge_relationships. Safe to call multiple times."""
    con = _con()
    try:
        cols = {r[1] for r in con.execute("PRAGMA table_info(knowledge_relationships)").fetchall()}
        if "stability_score" in cols:
            return False
        for stmt in _STABILITY_COLS:
            try:
                con.execute(stmt)
                con.commit()
            except Exception:
                pass
        return True
    finally:
        con.close()


def _check_stability_columns() -> bool:
    """Returns True if stability columns exist in knowledge_relationships."""
    con = _con()
    try:
        cols = {r[1] for r in con.execute("PRAGMA table_info(knowledge_relationships)").fetchall()}
        return "stability_score" in cols
    finally:
        con.close()


# ── 1. Edge fragility ─────────────────────────────────────────────────────────

def compute_edge_fragility(rel_id: str) -> float | None:
    """
    Fragility = coefficient of variation of confidence scores across evidence_links.
    0 = all evidence is equally confident (robust).
    100 = maximum variance in confidence (fragile, context-dependent).

    Returns None if fewer than 2 evidence links (can't measure variance).
    """
    con = _con()
    try:
        rows = con.execute(
            "SELECT confidence FROM evidence_links WHERE rel_id=? AND confidence IS NOT NULL",
            (rel_id,),
        ).fetchall()
    finally:
        con.close()

    confidences = [float(r["confidence"]) for r in rows]
    if len(confidences) < 2:
        return None

    return round(min(_cov(confidences) * 100, 100), 1)


# ── 2. Regime dependency ──────────────────────────────────────────────────────

def compute_regime_dependency(strategy_node_id: str) -> float:
    """
    0-1 score. High = the strategy only has evidence in one regime.
    Uses: count of distinct regime nodes connected to this strategy via evidence-backed rels.

    Known regime nodes: r_trending, r_reverting, r_weak, r_crash (4 total).
    """
    regime_nodes = {"r_trending", "r_reverting", "r_weak", "r_crash"}
    con = _con()
    try:
        # Find which regime nodes have evidence_links through relationships FROM this strategy
        rows = con.execute(
            """SELECT kr.to_node_id
               FROM knowledge_relationships kr
               JOIN evidence_links el ON el.rel_id = kr.rel_id
               WHERE kr.from_node_id = ?
                 AND kr.to_node_id IN ('r_trending','r_reverting','r_weak','r_crash')
               GROUP BY kr.to_node_id""",
            (strategy_node_id,),
        ).fetchall()
    finally:
        con.close()

    covered = len(rows)
    if covered == 0:
        return 1.0   # No regime evidence at all = fully regime-dependent (unknown)
    return round(1.0 - (covered / len(regime_nodes)), 2)


# ── 3. Session dependency ─────────────────────────────────────────────────────

def compute_session_dependency(strategy_node_id: str) -> float:
    """
    0-1 score. High = strategy only has positive evidence in one session.
    Uses: count of session nodes with PF ≥ 1.0 evidence-backed rels.

    Known session nodes: sess_london, sess_ny, sess_asian (3 total).
    """
    session_nodes = {"sess_london", "sess_ny", "sess_asian"}
    con = _con()
    try:
        # Find sessions where evidence supports a positive relationship
        rows = con.execute(
            """SELECT DISTINCT kr.to_node_id
               FROM knowledge_relationships kr
               JOIN evidence_links el ON el.rel_id = kr.rel_id
               WHERE kr.from_node_id = ?
                 AND kr.to_node_id IN ('sess_london','sess_ny','sess_asian')
                 AND el.supports = 1
               GROUP BY kr.to_node_id""",
            (strategy_node_id,),
        ).fetchall()
    finally:
        con.close()

    covered = len(rows)
    if covered == 0:
        return 1.0
    return round(1.0 - (covered / len(session_nodes)), 2)


# ── 4. Temporal consistency score ─────────────────────────────────────────────

def compute_temporal_consistency_score(strategy_node_id: str) -> float:
    """
    100 = perfectly consistent (same net PnL sign across all annual periods).
    0   = completely inconsistent (some years profitable, others losing).

    Uses annual evidence_links (title matches '[annual-YYYY]') on the strategy node.
    Measures coefficient of variation of net_pnl across years.
    Lower CoV → higher score.
    """
    from evidence_expander import _parse_result_metric

    con = _con()
    try:
        rows = con.execute(
            """SELECT result_metric FROM evidence_links
               WHERE node_id = ? AND title LIKE '[annual-%'
               ORDER BY title""",
            (strategy_node_id,),
        ).fetchall()
    finally:
        con.close()

    net_pnls = []
    for r in rows:
        m = _parse_result_metric(r["result_metric"] or "")
        net = m.get("NET", None)
        if net is not None:
            net_pnls.append(net)

    if len(net_pnls) < 2:
        return 50.0  # insufficient data — neutral score

    cov = _cov([abs(p) for p in net_pnls])  # CV of absolute net PnL magnitude
    consistency = round(max(0, 100 - cov * 100), 1)

    # Bonus: if all years are profitable (all net > 0)
    all_positive = all(p > 0 for p in net_pnls)
    if all_positive:
        consistency = min(100.0, consistency + 10)

    return consistency


# ── 5. DD sensitivity ─────────────────────────────────────────────────────────

def compute_dd_sensitivity(
    strategy: str = "QField",
    dd_threshold_pct: float = 0.05,
) -> dict[str, Any]:
    """
    Compare WR during high-DD (balance declining) vs normal periods.
    Uses balance_at_open trajectory.

    dd_sensitivity_score:
    - 1.0  = WR is identical in high-DD and normal periods (no sensitivity)
    - 0.0  = WR collapses to zero during high-DD periods (highly sensitive)
    - >1.0 = WR improves during drawdown (counter-cyclical)
    """
    con = _con()
    try:
        rows = con.execute(
            "SELECT balance_at_open, pnl_usd, outcome, open_time FROM trades "
            "WHERE strategy=? AND balance_at_open > 0 AND outcome IN ('WIN','LOSS','BE') "
            "ORDER BY open_time",
            (strategy,),
        ).fetchall()
    finally:
        con.close()

    if not rows:
        return {"strategy": strategy, "dd_sensitivity_score": None, "n": 0}

    # Tag each trade: is it in a high-DD period?
    peak = 0.0
    high_dd: list[tuple[float, str]] = []
    normal: list[tuple[float, str]] = []

    for r in rows:
        bal = float(r["balance_at_open"])
        if bal > peak:
            peak = bal
        dd_pct = (peak - bal) / peak if peak > 0 else 0.0
        p = float(r["pnl_usd"] or 0)
        o = r["outcome"]
        if dd_pct >= dd_threshold_pct:
            high_dd.append((p, o))
        else:
            normal.append((p, o))

    def _wr(pairs: list[tuple[float, str]]) -> float:
        if not pairs:
            return 0.0
        wins = sum(1 for _, o in pairs if o == "WIN")
        losses = sum(1 for _, o in pairs if o == "LOSS")
        return wins / (wins + losses) if (wins + losses) > 0 else 0.0

    wr_high_dd = _wr(high_dd)
    wr_normal  = _wr(normal)
    sensitivity = round(wr_high_dd / wr_normal, 3) if wr_normal > 0 else None

    return {
        "strategy":             strategy,
        "n_high_dd_trades":     len(high_dd),
        "n_normal_trades":      len(normal),
        "wr_high_dd":           round(wr_high_dd, 4),
        "wr_normal":            round(wr_normal, 4),
        "dd_sensitivity_score": sensitivity,
        "interpretation": (
            "neutral" if sensitivity is None else
            "not sensitive" if sensitivity >= 0.85 else
            "somewhat sensitive" if sensitivity >= 0.6 else
            "highly sensitive"
        ),
    }


# ── 6. Composite stability score ──────────────────────────────────────────────

def compute_relationship_stability(rel_id: str) -> dict[str, float | None]:
    """
    Compute all stability metrics for a single relationship.

    Returns dict with:
    - fragility_score
    - regime_dependency
    - session_dependency
    - stability_score (composite: 100 = most stable)
    """
    con = _con()
    try:
        row = con.execute(
            "SELECT from_node_id, to_node_id, rel_type, strength "
            "FROM knowledge_relationships WHERE rel_id=?",
            (rel_id,),
        ).fetchone()
    finally:
        con.close()

    if not row:
        return {}

    fragility = compute_edge_fragility(rel_id)
    from_id   = row["from_node_id"]

    # Regime and session dependency are strategy-level metrics
    reg_dep = None
    sess_dep = None
    if from_id.startswith("s_"):
        reg_dep  = compute_regime_dependency(from_id)
        sess_dep = compute_session_dependency(from_id)

    # Composite stability: start at 100, subtract fragility components
    stability = 100.0
    penalty = 0.0
    factors = 0

    if fragility is not None:
        penalty += fragility * 0.3   # up to 30 pts penalty for high fragility
        factors += 1
    if reg_dep is not None:
        penalty += reg_dep * 20      # up to 20 pts penalty for regime dependency
        factors += 1
    if sess_dep is not None:
        penalty += sess_dep * 15     # up to 15 pts penalty for session dependency
        factors += 1

    stability = max(0, round(stability - penalty, 1))

    return {
        "rel_id":            rel_id,
        "fragility_score":   fragility,
        "regime_dependency": reg_dep,
        "session_dependency": sess_dep,
        "stability_score":   stability,
    }


# ── 7. Full stability analysis run ────────────────────────────────────────────

def run_stability_analysis() -> dict[str, Any]:
    """
    Run stability analysis on all relationships that have evidence.
    Updates stability_score, fragility_score, regime_dependency, session_dependency
    in knowledge_relationships.

    Requires migration 011 columns to exist.
    """
    if not _check_stability_columns():
        return {"error": "stability columns not found — run apply_validation_migration() first"}

    con = _con()
    try:
        # All relationships with at least 1 evidence link
        rels = con.execute(
            """SELECT DISTINCT kr.rel_id
               FROM knowledge_relationships kr
               JOIN evidence_links el ON el.rel_id = kr.rel_id""",
        ).fetchall()
        rel_ids = [r["rel_id"] for r in rels]
    finally:
        con.close()

    updated = 0
    skipped = 0
    stability_scores: list[float] = []

    for rel_id in rel_ids:
        metrics = compute_relationship_stability(rel_id)
        if not metrics:
            skipped += 1
            continue

        con = _con()
        try:
            con.execute(
                """UPDATE knowledge_relationships SET
                   stability_score    = ?,
                   fragility_score    = ?,
                   regime_dependency  = ?,
                   session_dependency = ?
                   WHERE rel_id = ?""",
                (
                    metrics.get("stability_score"),
                    metrics.get("fragility_score"),
                    metrics.get("regime_dependency"),
                    metrics.get("session_dependency"),
                    rel_id,
                ),
            )
            con.commit()
            updated += 1
            if metrics.get("stability_score") is not None:
                stability_scores.append(metrics["stability_score"])
        finally:
            con.close()

    avg_stability = round(sum(stability_scores) / len(stability_scores), 1) if stability_scores else None

    # Also compute DD sensitivity for main strategies
    dd_results: dict[str, Any] = {}
    for strat in ["QField"]:
        dd_results[strat] = compute_dd_sensitivity(strat)

    return {
        "relationships_analyzed": len(rel_ids),
        "updated":                updated,
        "skipped":                skipped,
        "avg_stability_score":    avg_stability,
        "dd_sensitivity":         dd_results,
        "completed_at":           datetime.now().isoformat(),
    }


# ── 8. Stability report ───────────────────────────────────────────────────────

def get_stability_report() -> dict[str, Any]:
    """
    Full stability report for dashboard display.
    Shows: most/least stable relationships, per-metric distribution.
    """
    if not _check_stability_columns():
        return {"error": "stability columns not found"}

    con = _con()
    try:
        # Most stable relationships
        most_stable = con.execute(
            """SELECT kr.rel_id, kn1.title as from_title, kn2.title as to_title,
                      kr.rel_type, kr.strength, kr.stability_score, kr.fragility_score,
                      kr.regime_dependency, kr.session_dependency, kr.validation_status,
                      kr.computed_n, kr.computed_wr, kr.computed_pf
               FROM knowledge_relationships kr
               JOIN knowledge_nodes kn1 ON kn1.node_id = kr.from_node_id
               JOIN knowledge_nodes kn2 ON kn2.node_id = kr.to_node_id
               WHERE kr.stability_score IS NOT NULL
               ORDER BY kr.stability_score DESC
               LIMIT 20""",
        ).fetchall()

        # Least stable relationships
        least_stable = con.execute(
            """SELECT kr.rel_id, kn1.title as from_title, kn2.title as to_title,
                      kr.rel_type, kr.strength, kr.stability_score, kr.fragility_score,
                      kr.validation_status, kr.computed_n
               FROM knowledge_relationships kr
               JOIN knowledge_nodes kn1 ON kn1.node_id = kr.from_node_id
               JOIN knowledge_nodes kn2 ON kn2.node_id = kr.to_node_id
               WHERE kr.stability_score IS NOT NULL AND kr.stability_score < 70
               ORDER BY kr.stability_score ASC
               LIMIT 20""",
        ).fetchall()

        # Validation status distribution
        status_dist = {
            r["validation_status"]: r["n"]
            for r in con.execute(
                "SELECT validation_status, COUNT(*) as n FROM knowledge_relationships "
                "GROUP BY validation_status"
            ).fetchall()
        }

        # Avg metrics
        avg_row = con.execute(
            """SELECT AVG(stability_score) as avg_stab,
                      AVG(fragility_score) as avg_frag,
                      AVG(regime_dependency) as avg_reg,
                      AVG(session_dependency) as avg_sess
               FROM knowledge_relationships WHERE stability_score IS NOT NULL"""
        ).fetchone()

        return {
            "most_stable": [dict(r) for r in most_stable],
            "least_stable": [dict(r) for r in least_stable],
            "validation_status_distribution": status_dist,
            "averages": {
                "stability":         round(avg_row["avg_stab"] or 0, 1),
                "fragility":         round(avg_row["avg_frag"] or 0, 1),
                "regime_dependency": round(avg_row["avg_reg"] or 0, 3),
                "session_dependency": round(avg_row["avg_sess"] or 0, 3),
            },
            "dd_sensitivity": compute_dd_sensitivity("QField"),
            "temporal_consistency": {
                "QField": compute_temporal_consistency_score("s_qfield"),
            },
            "generated_at": datetime.now().isoformat(),
        }
    finally:
        con.close()


# ── Fragility risk report ─────────────────────────────────────────────────────

def get_fragile_relationships(max_stability: float = 60.0) -> list[dict[str, Any]]:
    """
    Returns relationships with stability_score ≤ max_stability.
    These are the edges at highest risk of not replicating out-of-sample.
    """
    if not _check_stability_columns():
        return []

    con = _con()
    try:
        rows = con.execute(
            """SELECT kr.rel_id, kn1.title as from_title, kn2.title as to_title,
                      kr.rel_type, kr.strength, kr.stability_score, kr.fragility_score,
                      kr.regime_dependency, kr.session_dependency,
                      kr.validation_status, kr.computed_n, kr.computed_wr, kr.computed_pf
               FROM knowledge_relationships kr
               JOIN knowledge_nodes kn1 ON kn1.node_id = kr.from_node_id
               JOIN knowledge_nodes kn2 ON kn2.node_id = kr.to_node_id
               WHERE kr.stability_score IS NOT NULL AND kr.stability_score <= ?
               ORDER BY kr.stability_score ASC""",
            (max_stability,),
        ).fetchall()
        return [dict(r) for r in rows]
    finally:
        con.close()
