"""
knowledge_graph.py — Knowledge Relationship & Reasoning Layer for QTrade OS.

Manages a SQLite-backed knowledge graph of nodes (strategies, regimes,
sessions, principles, hypotheses, edges, concepts, behaviors, risk rules)
and typed relationships between them.

No autonomous trading. No self-modifying strategies. Human-supervised only.
"""

from __future__ import annotations

import json
import re
import sqlite3
import uuid
from datetime import datetime
from pathlib import Path
from typing import Any

# ── Paths ──────────────────────────────────────────────────────────────────────

_BASE    = Path(__file__).resolve().parents[2]
DB_PATH  = _BASE / "DATA" / "processed" / "trades.sqlite"

# ── Constants ──────────────────────────────────────────────────────────────────

NODE_TYPES = [
    "strategy", "regime", "session", "behavior",
    "risk_rule", "concept", "principle",
    "hypothesis", "edge", "research",
]

REL_TYPES = [
    "supports", "contradicts", "related_to",
    "works_best_in", "fails_in", "derived_from",
    "validated_by", "linked_to_strategy",
    "linked_to_session", "linked_to_regime",
    "linked_to_risk_model", "required_by", "enables",
]

REL_COLORS = {
    "supports":            "#26a69a",
    "contradicts":         "#ef5350",
    "related_to":          "#5c6bc0",
    "works_best_in":       "#66bb6a",
    "fails_in":            "#ffa726",
    "derived_from":        "#ab47bc",
    "validated_by":        "#29b6f6",
    "linked_to_strategy":  "#ff7043",
    "linked_to_session":   "#8d6e63",
    "linked_to_regime":    "#78909c",
    "linked_to_risk_model":"#ec407a",
    "required_by":         "#d4e157",
    "enables":             "#4db6ac",
}

NODE_COLORS = {
    "strategy":  "#ff7043",
    "regime":    "#78909c",
    "session":   "#8d6e63",
    "behavior":  "#ef5350",
    "risk_rule": "#ec407a",
    "concept":   "#5c6bc0",
    "principle": "#26a69a",
    "hypothesis":"#ab47bc",
    "edge":      "#66bb6a",
    "research":  "#ffd600",
}

# ── DB helpers ─────────────────────────────────────────────────────────────────

def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    con.execute("PRAGMA journal_mode=WAL")
    con.execute("PRAGMA foreign_keys=ON")
    return con


def _split_sql(sql: str) -> list[str]:
    clean = re.sub(r"--[^\n]*", "", sql)
    return [s.strip() for s in clean.split(";") if s.strip()]


def run_migration() -> None:
    """Apply migration 010 if knowledge_nodes table doesn't exist."""
    migration_path = _BASE / "DATA" / "migrations" / "010_knowledge_graph.sql"
    if not migration_path.exists():
        return
    sql = migration_path.read_text(encoding="utf-8")
    stmts = _split_sql(sql)
    con = _con()
    try:
        for stmt in stmts:
            try:
                con.execute(stmt)
                con.commit()
            except sqlite3.OperationalError:
                con.rollback()
    finally:
        con.close()


# ── Node CRUD ──────────────────────────────────────────────────────────────────

def upsert_node(
    node_id: str,
    node_type: str,
    title: str,
    description: str = "",
    source_id: str | None = None,
    source_table: str | None = None,
    tags: str = "",
    confidence: float = 0.0,
    status: str = "active",
    obsidian_path: str | None = None,
) -> str:
    """Insert or update a knowledge node. Returns node_id."""
    con = _con()
    try:
        con.execute(
            """INSERT INTO knowledge_nodes
               (node_id, node_type, title, description, source_id, source_table,
                tags, confidence, status, obsidian_path, updated_at)
               VALUES (?,?,?,?,?,?,?,?,?,?, datetime('now'))
               ON CONFLICT(node_id) DO UPDATE SET
                 title=excluded.title,
                 description=excluded.description,
                 tags=excluded.tags,
                 confidence=excluded.confidence,
                 status=excluded.status,
                 obsidian_path=excluded.obsidian_path,
                 updated_at=excluded.updated_at""",
            (node_id, node_type, title, description, source_id, source_table,
             tags, confidence, status, obsidian_path),
        )
        con.commit()
    finally:
        con.close()
    return node_id


def add_relationship(
    from_node_id: str,
    to_node_id: str,
    rel_type: str,
    strength: float = 50.0,
    rationale: str = "",
    created_by: str = "user",
    is_bidirectional: bool = False,
) -> str | None:
    """Add a relationship. Returns rel_id or None on duplicate."""
    rel_id = f"rel_{uuid.uuid4().hex[:12]}"
    con = _con()
    try:
        con.execute(
            """INSERT OR IGNORE INTO knowledge_relationships
               (rel_id, from_node_id, to_node_id, rel_type, strength,
                rationale, is_bidirectional, created_by)
               VALUES (?,?,?,?,?,?,?,?)""",
            (rel_id, from_node_id, to_node_id, rel_type, strength,
             rationale, int(is_bidirectional), created_by),
        )
        con.commit()
        # Check if insert happened (IGNORE means duplicate if 0 changes)
        changes = con.execute("SELECT changes()").fetchone()[0]
        return rel_id if changes else None
    finally:
        con.close()


def get_node(node_id: str) -> dict | None:
    con = _con()
    try:
        row = con.execute(
            "SELECT * FROM knowledge_nodes WHERE node_id=?", (node_id,)
        ).fetchone()
        return dict(row) if row else None
    finally:
        con.close()


def get_all_nodes(node_type: str | None = None, status: str = "active") -> list[dict]:
    con = _con()
    try:
        if node_type:
            rows = con.execute(
                "SELECT * FROM knowledge_nodes WHERE node_type=? AND status=? ORDER BY title",
                (node_type, status),
            ).fetchall()
        else:
            rows = con.execute(
                "SELECT * FROM knowledge_nodes WHERE status=? ORDER BY node_type, title",
                (status,),
            ).fetchall()
        return [dict(r) for r in rows]
    finally:
        con.close()


def get_all_relationships() -> list[dict]:
    con = _con()
    try:
        rows = con.execute(
            """SELECT kr.*,
                      fn.title AS from_title, fn.node_type AS from_type,
                      tn.title AS to_title,   tn.node_type AS to_type
               FROM knowledge_relationships kr
               JOIN knowledge_nodes fn ON fn.node_id = kr.from_node_id
               JOIN knowledge_nodes tn ON tn.node_id = kr.to_node_id
               ORDER BY kr.created_at DESC"""
        ).fetchall()
        return [dict(r) for r in rows]
    finally:
        con.close()


def get_node_relationships(node_id: str) -> list[dict]:
    """Get all relationships involving a node (as source or target)."""
    con = _con()
    try:
        rows = con.execute(
            """SELECT kr.*,
                      fn.title AS from_title, fn.node_type AS from_type,
                      tn.title AS to_title,   tn.node_type AS to_type
               FROM knowledge_relationships kr
               JOIN knowledge_nodes fn ON fn.node_id = kr.from_node_id
               JOIN knowledge_nodes tn ON tn.node_id = kr.to_node_id
               WHERE kr.from_node_id=? OR kr.to_node_id=?
               ORDER BY kr.strength DESC""",
            (node_id, node_id),
        ).fetchall()
        return [dict(r) for r in rows]
    finally:
        con.close()


def delete_relationship(rel_id: str) -> bool:
    con = _con()
    try:
        con.execute("DELETE FROM knowledge_relationships WHERE rel_id=?", (rel_id,))
        con.commit()
        return con.execute("SELECT changes()").fetchone()[0] > 0
    finally:
        con.close()


def delete_node(node_id: str) -> bool:
    """Delete a node and its relationships (cascade)."""
    con = _con()
    try:
        con.execute("DELETE FROM knowledge_nodes WHERE node_id=?", (node_id,))
        con.commit()
        return con.execute("SELECT changes()").fetchone()[0] > 0
    finally:
        con.close()


# ── Sync nodes from existing DB tables ────────────────────────────────────────

def sync_nodes_from_db() -> dict[str, int]:
    """
    Sync knowledge_nodes from:
      - mindset_principles → principle nodes
      - hypotheses         → hypothesis nodes
      - validated_edges    → edge nodes
      - research_inbox     → research nodes (inbox/validated only)

    Returns counts per source.
    """
    counts: dict[str, int] = {
        "principles": 0, "hypotheses": 0, "edges": 0, "research": 0,
    }
    con = _con()
    try:
        # ── Principles ────────────────────────────────────────────────────────
        try:
            rows = con.execute(
                """SELECT principle_id, title, concept, mindset_type,
                          quality_score, tags, status, note_path
                   FROM mindset_principles WHERE status='active'"""
            ).fetchall()
            for r in rows:
                upsert_node(
                    node_id=f"principle_{r['principle_id']}",
                    node_type="principle",
                    title=r["title"],
                    description=r["concept"] or "",
                    source_id=r["principle_id"],
                    source_table="mindset_principles",
                    tags=r["tags"] or "",
                    confidence=float(r["quality_score"] or 0),
                    obsidian_path=r["note_path"],
                )
                counts["principles"] += 1
        except sqlite3.OperationalError:
            pass

        # ── Hypotheses ────────────────────────────────────────────────────────
        try:
            rows = con.execute(
                "SELECT hyp_id, title, description, status, confidence_score FROM hypotheses"
            ).fetchall()
            for r in rows:
                upsert_node(
                    node_id=f"hyp_{r['hyp_id']}",
                    node_type="hypothesis",
                    title=r["title"],
                    description=r["description"] or "",
                    source_id=r["hyp_id"],
                    source_table="hypotheses",
                    confidence=float(r["confidence_score"] or 0),
                    status="active" if r["status"] not in ("rejected",) else "archived",
                )
                counts["hypotheses"] += 1
        except sqlite3.OperationalError:
            pass

        # ── Validated Edges ───────────────────────────────────────────────────
        try:
            rows = con.execute(
                "SELECT edge_id, hyp_id, edge_score, alert_level FROM validated_edges"
            ).fetchall()
            for r in rows:
                upsert_node(
                    node_id=f"edge_{r['edge_id']}",
                    node_type="edge",
                    title=f"Edge: {r['edge_id']}",
                    source_id=r["edge_id"],
                    source_table="validated_edges",
                    confidence=float(r["edge_score"] or 0),
                )
                counts["edges"] += 1
        except sqlite3.OperationalError:
            pass

        # ── Research Inbox (validated items only) ─────────────────────────────
        try:
            rows = con.execute(
                """SELECT item_id, title, summary, category, status
                   FROM research_inbox
                   WHERE status IN ('validated','testing','reviewing')"""
            ).fetchall()
            for r in rows:
                upsert_node(
                    node_id=f"research_{r['item_id']}",
                    node_type="research",
                    title=r["title"],
                    description=r["summary"] or "",
                    source_id=r["item_id"],
                    source_table="research_inbox",
                    tags=r["category"] or "",
                )
                counts["research"] += 1
        except sqlite3.OperationalError:
            pass

    finally:
        con.close()

    return counts


# ── Seed nodes ─────────────────────────────────────────────────────────────────

_SEED_NODES: list[dict] = [
    # Strategies
    {"node_id": "s_qfield",       "node_type": "strategy", "title": "QField_EA",
     "description": "SC₁₀₀ Regime-Adaptive XAUUSD M1 | WR 72.5% | PF 2.22 (Jan-Apr 2026)",
     "confidence": 72.5, "tags": "XAUUSD,M1,regime_adaptive"},
    {"node_id": "s_quantumqueen", "node_type": "strategy", "title": "QuantumQueen",
     "description": "Session-based XAUUSD | FTMO-safe | WR 82.1%",
     "confidence": 82.1, "tags": "XAUUSD,session,FTMO"},
    {"node_id": "s_hedgegrid",    "node_type": "strategy", "title": "HedgeGrid_V23",
     "description": "ATR Dynamic Grid | V23 fix12",
     "confidence": 60.0, "tags": "grid,ATR,dynamic"},
    {"node_id": "s_smc_univ",     "node_type": "strategy", "title": "SMC_Universal_EA",
     "description": "ICT/SMC W/M+BOS+FVG+OB | v3.0 fix21",
     "confidence": 55.0, "tags": "SMC,ICT,BOS,FVG,OB"},
    {"node_id": "s_ninja",        "node_type": "strategy", "title": "NinjaThai SMC",
     "description": "BSL/SSL+W&M Pattern+S&D+CHoCH | Manual + EA",
     "confidence": 65.0, "tags": "SMC,BSL,SSL,manual"},
    {"node_id": "s_mmf",          "node_type": "strategy", "title": "MMF_MakeMoneyFarmed",
     "description": "CCI Mean Reversion 28 pairs | v3.15",
     "confidence": 58.0, "tags": "CCI,mean_reversion,28pairs"},
    {"node_id": "s_nqgc",         "node_type": "strategy", "title": "NQ-GC_Scalper",
     "description": "CME Options Levels + QField | V51.8",
     "confidence": 63.0, "tags": "NQ,GC,scalper,CME"},

    # Regimes
    {"node_id": "r_trending",   "node_type": "regime", "title": "TRENDING Regime",
     "description": "SC₁₀₀ < 0.25 | EMA/Breakout strategies favored",
     "confidence": 90.0, "tags": "SC100,trending"},
    {"node_id": "r_reverting",  "node_type": "regime", "title": "REVERTING Regime",
     "description": "SC₁₀₀ > 0.35 | RSI(20)+SMA(50) mean reversion",
     "confidence": 90.0, "tags": "SC100,reverting"},
    {"node_id": "r_weak",       "node_type": "regime", "title": "WEAK Regime",
     "description": "SC₁₀₀ 0.25–0.35 | RSI only or HOLD",
     "confidence": 85.0, "tags": "SC100,weak"},
    {"node_id": "r_crash",      "node_type": "regime", "title": "CRASH Regime",
     "description": "SC₁₀₀ < 0.22 + spike | Momentum only",
     "confidence": 88.0, "tags": "SC100,crash,momentum"},

    # Sessions
    {"node_id": "sess_london",  "node_type": "session", "title": "London Session",
     "description": "High liquidity | 14:00-15:00 ICT focus (Thailand time)",
     "confidence": 80.0, "tags": "london,liquidity"},
    {"node_id": "sess_ny",      "node_type": "session", "title": "NY Open Session",
     "description": "Highest volatility | 20:30-21:00 Thailand time",
     "confidence": 80.0, "tags": "ny_open,volatility"},
    {"node_id": "sess_asian",   "node_type": "session", "title": "Asian Session",
     "description": "Low volatility | 07:00-08:00 Thailand time | range",
     "confidence": 70.0, "tags": "asian,low_vol,range"},

    # Behaviors (psychological failure modes)
    {"node_id": "b_fomo",       "node_type": "behavior", "title": "FOMO",
     "description": "Fear of missing out | chasing late entries | overtrading",
     "confidence": 95.0, "tags": "psychology,bias"},
    {"node_id": "b_revenge",    "node_type": "behavior", "title": "Revenge Trading",
     "description": "Trading to recover losses | increased lot size | emotional",
     "confidence": 95.0, "tags": "psychology,danger"},
    {"node_id": "b_overconf",   "node_type": "behavior", "title": "Overconfidence",
     "description": "Ignoring stop loss | oversizing | dismissing contradictory evidence",
     "confidence": 90.0, "tags": "psychology,danger"},
    {"node_id": "b_sunk_cost",  "node_type": "behavior", "title": "Sunk Cost Bias",
     "description": "Holding losing positions because of prior investment",
     "confidence": 90.0, "tags": "psychology,bias"},

    # Risk Rules
    {"node_id": "rr_daily_loss",  "node_type": "risk_rule", "title": "Daily Loss Limit",
     "description": "Stop trading when daily loss exceeds 2% equity",
     "confidence": 95.0, "tags": "risk,daily,limit"},
    {"node_id": "rr_kelly",       "node_type": "risk_rule", "title": "Kelly Cap",
     "description": "Never exceed half-Kelly position size | bet_frac = (WR-LR/RR)/2",
     "confidence": 90.0, "tags": "risk,kelly,sizing"},
    {"node_id": "rr_consec_loss", "node_type": "risk_rule", "title": "Consecutive Loss Pause",
     "description": "Pause trading after 3 consecutive losses | review before resuming",
     "confidence": 92.0, "tags": "risk,streak,discipline"},
    {"node_id": "rr_n30",         "node_type": "risk_rule", "title": "N≥30 Validation Rule",
     "description": "No hypothesis promoted without minimum 30 trade samples",
     "confidence": 95.0, "tags": "validation,statistics,minimum_n"},
    {"node_id": "rr_max_dd",      "node_type": "risk_rule", "title": "Max Drawdown Cap",
     "description": "Close all positions if portfolio drawdown exceeds 8%",
     "confidence": 95.0, "tags": "risk,drawdown,portfolio"},

    # Concepts (technical building blocks)
    {"node_id": "c_sc100",   "node_type": "concept", "title": "SC₁₀₀",
     "description": "Sign-Change Rate in 100 M1 bars | r(SC₁₀₀,β₁)=-0.95 validated on 6.2M ticks",
     "confidence": 95.0, "tags": "regime,detection,validated"},
    {"node_id": "c_atr",     "node_type": "concept", "title": "ATR",
     "description": "Average True Range | volatility measure for grid spacing and SL sizing",
     "confidence": 90.0, "tags": "volatility,indicator"},
    {"node_id": "c_bsl_ssl", "node_type": "concept", "title": "BSL/SSL",
     "description": "Buy/Sell Side Liquidity | stop hunt zones above/below key highs-lows",
     "confidence": 85.0, "tags": "SMC,ICT,liquidity"},
    {"node_id": "c_choch",   "node_type": "concept", "title": "CHoCH",
     "description": "Change of Character | SMC structure shift signal for trend reversal",
     "confidence": 85.0, "tags": "SMC,structure"},
    {"node_id": "c_fvg",     "node_type": "concept", "title": "FVG",
     "description": "Fair Value Gap | imbalance zone | magnet for price retracement",
     "confidence": 82.0, "tags": "SMC,ICT,imbalance"},
    {"node_id": "c_beta1",   "node_type": "concept", "title": "β₁ (AR1 Slope)",
     "description": "OLS slope of last 50 M1 returns | β₁>0 uptrend | β₁<0 mean-reverting",
     "confidence": 90.0, "tags": "regime,trend_strength,statistics"},
    {"node_id": "c_martingale", "node_type": "concept", "title": "Martingale",
     "description": "Doubling lot size after losses | unlimited risk exposure | forbidden",
     "confidence": 99.0, "tags": "danger,risk,forbidden"},
    {"node_id": "c_overfitting", "node_type": "concept", "title": "Overfitting",
     "description": "Over-optimizing to historical data | fails out-of-sample | silent killer",
     "confidence": 98.0, "tags": "danger,statistics,validation"},
]

_SEED_RELATIONSHIPS: list[dict] = [
    # QField_EA regime dependencies
    ("s_qfield",      "r_trending",    "works_best_in",      90, "WR 72.5% concentrated in TRENDING regime"),
    ("s_qfield",      "r_reverting",   "works_best_in",      75, "RSI+SMA adaptive in REVERTING"),
    ("s_qfield",      "r_crash",       "fails_in",           80, "Crash regime breaks momentum assumptions"),
    ("s_qfield",      "c_sc100",       "derived_from",       95, "Core regime filter built on SC₁₀₀"),
    ("s_qfield",      "c_beta1",       "derived_from",       90, "β₁ used for trend direction signal"),
    ("s_qfield",      "rr_daily_loss", "linked_to_risk_model",85, "Daily loss limit built into EA"),
    ("s_qfield",      "rr_kelly",      "linked_to_risk_model",80, "Position sizing uses Kelly fraction"),

    # QuantumQueen session dependencies
    ("s_quantumqueen","sess_london",   "works_best_in",      85, "London liquidity drives 82.1% WR"),
    ("s_quantumqueen","sess_ny",       "works_best_in",      80, "NY open volatility edge confirmed"),
    ("s_quantumqueen","sess_asian",    "fails_in",           70, "Low vol Asian session reduces edge"),
    ("s_quantumqueen","rr_daily_loss", "linked_to_risk_model",90, "FTMO daily loss cap enforced"),

    # HedgeGrid
    ("s_hedgegrid",   "c_atr",         "derived_from",       85, "Grid spacing = ATR multiplier"),
    ("s_hedgegrid",   "r_weak",        "works_best_in",      75, "Range market suits grid"),
    ("s_hedgegrid",   "r_trending",    "fails_in",           80, "Strong trend blows through grid"),
    ("s_hedgegrid",   "c_martingale",  "contradicts",        85, "Grid with lot multiplier is martingale-adjacent"),

    # SMC Universal EA
    ("s_smc_univ",    "c_bsl_ssl",    "derived_from",        90, "BSL/SSL sweep is primary signal"),
    ("s_smc_univ",    "c_choch",      "derived_from",        90, "CHoCH confirms structure shift"),
    ("s_smc_univ",    "c_fvg",        "derived_from",        85, "FVG retracement for entry"),
    ("s_smc_univ",    "sess_london",  "works_best_in",       80, "London liquidity sweeps most reliable"),
    ("s_smc_univ",    "sess_ny",      "works_best_in",       82, "NY open drives strong BOS/CHoCH"),

    # NinjaThai SMC
    ("s_ninja",       "c_bsl_ssl",    "derived_from",        95, "Pillar 1: BSL/SSL liquidity sweep"),
    ("s_ninja",       "c_choch",      "derived_from",        95, "Pillar 4: CHoCH entry confirmation"),
    ("s_smc_univ",    "s_ninja",      "derived_from",        80, "SMC_Universal_EA built from NinjaThai system"),

    # Concept relationships
    ("c_sc100",  "c_beta1",    "related_to",          90, "r=-0.95: SC₁₀₀ predicts β₁ sign"),
    ("c_sc100",  "r_trending", "validated_by",        95, "Validated on 6.2M ticks"),
    ("c_choch",  "c_bsl_ssl",  "enables",             85, "CHoCH after BSL/SSL sweep = full ICT setup"),
    ("c_fvg",    "c_choch",    "related_to",          80, "FVG often forms at CHoCH level"),

    # Risk rules & behaviors
    ("b_revenge",   "rr_consec_loss","contradicts",   95, "Revenge trading violates consecutive loss pause rule"),
    ("b_fomo",      "rr_daily_loss", "contradicts",   90, "FOMO chasing leads to daily limit breach"),
    ("b_overconf",  "rr_kelly",      "contradicts",   92, "Overconfidence leads to oversizing beyond Kelly"),
    ("b_sunk_cost", "rr_daily_loss", "contradicts",   88, "Sunk cost thinking delays cutting losses"),
    ("c_martingale","rr_kelly",      "contradicts",   99, "Martingale is mathematically opposite to Kelly cap"),
    ("c_martingale","rr_max_dd",     "contradicts",   99, "Martingale creates unbounded drawdown risk"),
    ("c_overfitting","rr_n30",       "required_by",   95, "N≥30 rule prevents overfitting on small samples"),

    # Validation chain
    ("rr_n30",   "s_qfield",   "validated_by",        85, "QField validated on 149 trades (N≥30 passed)"),
    ("rr_n30",   "s_quantumqueen","validated_by",     80, "QuantumQueen validated on sufficient sample"),

    # Session → concept
    ("sess_london","c_bsl_ssl", "linked_to_session",  85, "London sweep creates cleanest BSL/SSL levels"),
    ("sess_ny",    "c_bsl_ssl", "linked_to_session",  80, "NY open often sweeps London highs/lows"),

    # Regime → concept
    ("r_trending",  "c_beta1",  "linked_to_regime",   90, "β₁ > 0 in TRENDING regime"),
    ("r_reverting", "c_beta1",  "linked_to_regime",   90, "β₁ < 0 in REVERTING regime"),
]


def seed_nodes_and_relationships() -> dict[str, int]:
    """
    Insert seed nodes and relationships if they don't already exist.
    Safe to call multiple times (idempotent).
    """
    n_nodes = 0
    n_rels  = 0

    for n in _SEED_NODES:
        upsert_node(
            node_id=n["node_id"],
            node_type=n["node_type"],
            title=n["title"],
            description=n.get("description", ""),
            confidence=n.get("confidence", 0.0),
            tags=n.get("tags", ""),
            status="active",
        )
        n_nodes += 1

    for from_id, to_id, rel_type, strength, rationale in _SEED_RELATIONSHIPS:
        result = add_relationship(
            from_node_id=from_id,
            to_node_id=to_id,
            rel_type=rel_type,
            strength=float(strength),
            rationale=rationale,
            created_by="seed",
        )
        if result:
            n_rels += 1

    return {"nodes": n_nodes, "relationships": n_rels}


# ── Query Engine ───────────────────────────────────────────────────────────────

def query_supports_strategy(strategy_node_id: str) -> list[dict]:
    """Which principles, risk rules, and concepts support this strategy?"""
    con = _con()
    try:
        rows = con.execute(
            """SELECT kr.rel_type, kr.strength, kr.rationale,
                      fn.node_id AS from_id, fn.title AS from_title, fn.node_type AS from_type,
                      tn.title AS to_title
               FROM knowledge_relationships kr
               JOIN knowledge_nodes fn ON fn.node_id = kr.from_node_id
               JOIN knowledge_nodes tn ON tn.node_id = kr.to_node_id
               WHERE kr.to_node_id=?
                 AND kr.rel_type IN ('supports','validated_by','derived_from','enables')
               ORDER BY kr.strength DESC""",
            (strategy_node_id,),
        ).fetchall()
        return [dict(r) for r in rows]
    finally:
        con.close()


def query_regime_breaks(strategy_node_id: str) -> list[dict]:
    """Which regimes break this strategy's edge?"""
    con = _con()
    try:
        rows = con.execute(
            """SELECT kr.rel_type, kr.strength, kr.rationale,
                      tn.node_id AS regime_id, tn.title AS regime_title, tn.description
               FROM knowledge_relationships kr
               JOIN knowledge_nodes tn ON tn.node_id = kr.to_node_id
               WHERE kr.from_node_id=?
                 AND tn.node_type='regime'
                 AND kr.rel_type='fails_in'
               ORDER BY kr.strength DESC""",
            (strategy_node_id,),
        ).fetchall()
        return [dict(r) for r in rows]
    finally:
        con.close()


def query_best_sessions(strategy_node_id: str) -> list[dict]:
    """Which sessions does this strategy work best in?"""
    con = _con()
    try:
        rows = con.execute(
            """SELECT kr.rel_type, kr.strength, kr.rationale,
                      tn.node_id AS session_id, tn.title AS session_title, tn.description
               FROM knowledge_relationships kr
               JOIN knowledge_nodes tn ON tn.node_id = kr.to_node_id
               WHERE kr.from_node_id=?
                 AND tn.node_type='session'
                 AND kr.rel_type IN ('works_best_in','linked_to_session')
               ORDER BY kr.strength DESC""",
            (strategy_node_id,),
        ).fetchall()
        return [dict(r) for r in rows]
    finally:
        con.close()


def query_behavior_impact(behavior_node_id: str | None = None) -> list[dict]:
    """Which rules does each behavior contradict?"""
    con = _con()
    try:
        if behavior_node_id:
            rows = con.execute(
                """SELECT kr.strength, kr.rationale,
                          fn.title AS behavior, tn.title AS rule_broken, tn.node_type AS rule_type
                   FROM knowledge_relationships kr
                   JOIN knowledge_nodes fn ON fn.node_id = kr.from_node_id
                   JOIN knowledge_nodes tn ON tn.node_id = kr.to_node_id
                   WHERE fn.node_id=? AND kr.rel_type='contradicts'
                   ORDER BY kr.strength DESC""",
                (behavior_node_id,),
            ).fetchall()
        else:
            rows = con.execute(
                """SELECT kr.strength, kr.rationale,
                          fn.title AS behavior, tn.title AS rule_broken, tn.node_type AS rule_type
                   FROM knowledge_relationships kr
                   JOIN knowledge_nodes fn ON fn.node_id = kr.from_node_id
                   JOIN knowledge_nodes tn ON tn.node_id = kr.to_node_id
                   WHERE fn.node_type='behavior' AND kr.rel_type='contradicts'
                   ORDER BY fn.title, kr.strength DESC"""
            ).fetchall()
        return [dict(r) for r in rows]
    finally:
        con.close()


def query_concept_dependencies(concept_node_id: str) -> list[dict]:
    """What strategies and hypotheses depend on this concept?"""
    con = _con()
    try:
        rows = con.execute(
            """SELECT kr.rel_type, kr.strength,
                      fn.title AS dependent, fn.node_type AS dep_type
               FROM knowledge_relationships kr
               JOIN knowledge_nodes fn ON fn.node_id = kr.from_node_id
               WHERE kr.to_node_id=?
                 AND kr.rel_type IN ('derived_from','linked_to_strategy')
               ORDER BY kr.strength DESC""",
            (concept_node_id,),
        ).fetchall()
        return [dict(r) for r in rows]
    finally:
        con.close()


def query_strategy_regime_matrix() -> dict[str, dict[str, float]]:
    """
    Build strategy × regime compatibility matrix.
    Returns {strategy_title: {regime_title: score}} where
      score > 0 = works_best_in (positive)
      score < 0 = fails_in (negative)
      0 = no data
    """
    con = _con()
    try:
        strategies = con.execute(
            "SELECT node_id, title FROM knowledge_nodes WHERE node_type='strategy' AND status='active'"
        ).fetchall()
        regimes = con.execute(
            "SELECT node_id, title FROM knowledge_nodes WHERE node_type='regime' AND status='active'"
        ).fetchall()

        matrix: dict[str, dict[str, float]] = {}
        for s in strategies:
            matrix[s["title"]] = {}
            for r in regimes:
                row = con.execute(
                    """SELECT rel_type, strength FROM knowledge_relationships
                       WHERE from_node_id=? AND to_node_id=?
                         AND rel_type IN ('works_best_in','fails_in')
                       LIMIT 1""",
                    (s["node_id"], r["node_id"]),
                ).fetchone()
                if row:
                    score = float(row["strength"]) if row["rel_type"] == "works_best_in" else -float(row["strength"])
                    matrix[s["title"]][r["title"]] = score
                else:
                    matrix[s["title"]][r["title"]] = 0.0

        return matrix
    finally:
        con.close()


# ── Reasoning Layer ────────────────────────────────────────────────────────────

def detect_contradictions() -> list[dict]:
    """
    Find pairs of relationships that logically contradict each other.
    Simple heuristic: if A supports B and A contradicts B exist simultaneously,
    or if A works_best_in X and A fails_in X both exist.
    """
    con = _con()
    try:
        rows = con.execute(
            """SELECT
                   a.from_node_id, a.to_node_id,
                   a.rel_type AS rel_a, b.rel_type AS rel_b,
                   a.strength AS str_a, b.strength AS str_b,
                   fn.title AS from_title, tn.title AS to_title
               FROM knowledge_relationships a
               JOIN knowledge_relationships b
                 ON a.from_node_id = b.from_node_id
                AND a.to_node_id   = b.to_node_id
                AND a.rel_id != b.rel_id
               JOIN knowledge_nodes fn ON fn.node_id = a.from_node_id
               JOIN knowledge_nodes tn ON tn.node_id = a.to_node_id
               WHERE (a.rel_type='supports'      AND b.rel_type='contradicts')
                  OR (a.rel_type='works_best_in' AND b.rel_type='fails_in')
                  OR (a.rel_type='enables'       AND b.rel_type='contradicts')"""
        ).fetchall()
        return [dict(r) for r in rows]
    finally:
        con.close()


def detect_duplicate_nodes(threshold: float = 85.0) -> list[dict]:
    """
    Find nodes with very similar titles that might be duplicates.
    Simple token overlap heuristic.
    """
    nodes = get_all_nodes()
    duplicates: list[dict] = []

    def _tokens(title: str) -> set[str]:
        return set(re.findall(r"\w+", title.lower()))

    for i, n1 in enumerate(nodes):
        for n2 in nodes[i + 1:]:
            if n1["node_type"] != n2["node_type"]:
                continue
            t1 = _tokens(n1["title"])
            t2 = _tokens(n2["title"])
            union = t1 | t2
            if not union:
                continue
            overlap = len(t1 & t2) / len(union) * 100
            if overlap >= threshold:
                duplicates.append({
                    "node1_id":    n1["node_id"],
                    "node2_id":    n2["node_id"],
                    "node1_title": n1["title"],
                    "node2_title": n2["title"],
                    "node_type":   n1["node_type"],
                    "overlap_pct": round(overlap, 1),
                })

    return duplicates


def check_weak_evidence(min_evidence: int = 1) -> list[dict]:
    """
    Return relationships with fewer than min_evidence evidence items attached.
    """
    con = _con()
    try:
        rows = con.execute(
            """SELECT kr.rel_id, kr.rel_type, kr.strength, kr.evidence_count,
                      fn.title AS from_title, tn.title AS to_title,
                      kr.rationale
               FROM knowledge_relationships kr
               JOIN knowledge_nodes fn ON fn.node_id = kr.from_node_id
               JOIN knowledge_nodes tn ON tn.node_id = kr.to_node_id
               WHERE kr.evidence_count < ?
               ORDER BY kr.strength DESC""",
            (min_evidence,),
        ).fetchall()
        return [dict(r) for r in rows]
    finally:
        con.close()


def propagate_confidence(node_id: str) -> float:
    """
    Compute propagated confidence for a node based on incoming 'supports'
    and 'validated_by' relationships. Penalizes 'contradicts'.
    Returns updated confidence score.
    """
    con = _con()
    try:
        node = con.execute(
            "SELECT confidence FROM knowledge_nodes WHERE node_id=?", (node_id,)
        ).fetchone()
        if not node:
            return 0.0

        base = float(node["confidence"])

        rels = con.execute(
            """SELECT rel_type, strength FROM knowledge_relationships
               WHERE to_node_id=?""",
            (node_id,),
        ).fetchall()

        boost = 0.0
        penalty = 0.0
        for r in rels:
            if r["rel_type"] in ("supports", "validated_by", "enables"):
                boost += float(r["strength"]) * 0.1
            elif r["rel_type"] == "contradicts":
                penalty += float(r["strength"]) * 0.1

        propagated = max(0.0, min(100.0, base + boost - penalty))

        con.execute(
            "UPDATE knowledge_nodes SET confidence=?, updated_at=datetime('now') WHERE node_id=?",
            (propagated, node_id),
        )
        con.commit()
        return propagated
    finally:
        con.close()


def low_sample_alerts() -> list[dict]:
    """
    Return hypothesis and edge nodes where sample N < 30 (N≥30 rule).
    Reads from hypotheses table when available.
    """
    con = _con()
    alerts: list[dict] = []
    try:
        rows = con.execute(
            """SELECT h.hyp_id, h.title, h.actual_n, h.status
               FROM hypotheses h
               WHERE h.actual_n < 30 OR h.actual_n IS NULL
               ORDER BY h.actual_n ASC NULLS FIRST"""
        ).fetchall()
        for r in rows:
            alerts.append({
                "node_id":    f"hyp_{r['hyp_id']}",
                "title":      r["title"],
                "node_type":  "hypothesis",
                "actual_n":   r["actual_n"] or 0,
                "status":     r["status"],
                "alert":      "Low sample N < 30 — cannot validate edge",
            })
    except sqlite3.OperationalError:
        pass
    finally:
        con.close()
    return alerts


# ── Graph data for visualisation ───────────────────────────────────────────────

def get_graph_data(
    node_types: list[str] | None = None,
    rel_types:  list[str] | None = None,
    min_strength: float = 0.0,
) -> dict[str, list[dict]]:
    """
    Return filtered nodes and edges ready for Plotly graph rendering.
    nodes: [{id, label, type, color, confidence}]
    edges: [{from, to, type, strength, color, label}]
    """
    nodes = get_all_nodes()
    if node_types:
        nodes = [n for n in nodes if n["node_type"] in node_types]
    node_ids = {n["node_id"] for n in nodes}

    rels = get_all_relationships()
    if rel_types:
        rels = [r for r in rels if r["rel_type"] in rel_types]
    rels = [r for r in rels if r["strength"] >= min_strength]
    rels = [r for r in rels if r["from_node_id"] in node_ids and r["to_node_id"] in node_ids]

    graph_nodes = [
        {
            "id":         n["node_id"],
            "label":      n["title"],
            "type":       n["node_type"],
            "color":      NODE_COLORS.get(n["node_type"], "#90a4ae"),
            "confidence": n["confidence"],
        }
        for n in nodes
    ]
    graph_edges = [
        {
            "from":     r["from_node_id"],
            "to":       r["to_node_id"],
            "type":     r["rel_type"],
            "strength": r["strength"],
            "color":    REL_COLORS.get(r["rel_type"], "#90a4ae"),
            "label":    r["rel_type"].replace("_", " "),
            "rationale": r.get("rationale", ""),
            "rel_id":   r["rel_id"],
        }
        for r in rels
    ]
    return {"nodes": graph_nodes, "edges": graph_edges}


# ── Stats ──────────────────────────────────────────────────────────────────────

def get_graph_stats() -> dict[str, Any]:
    con = _con()
    try:
        total_nodes = con.execute(
            "SELECT COUNT(*) FROM knowledge_nodes WHERE status='active'"
        ).fetchone()[0]
        total_rels = con.execute(
            "SELECT COUNT(*) FROM knowledge_relationships"
        ).fetchone()[0]
        type_counts = dict(con.execute(
            "SELECT node_type, COUNT(*) FROM knowledge_nodes WHERE status='active' GROUP BY node_type"
        ).fetchall())
        rel_type_counts = dict(con.execute(
            "SELECT rel_type, COUNT(*) FROM knowledge_relationships GROUP BY rel_type"
        ).fetchall())
        avg_conf = con.execute(
            "SELECT AVG(confidence) FROM knowledge_nodes WHERE status='active'"
        ).fetchone()[0] or 0.0

        return {
            "total_nodes":     total_nodes,
            "total_rels":      total_rels,
            "type_counts":     type_counts,
            "rel_type_counts": rel_type_counts,
            "avg_confidence":  round(float(avg_conf), 1),
        }
    finally:
        con.close()


# ── Obsidian note generator ────────────────────────────────────────────────────

def generate_node_note(node_id: str) -> str | None:
    """
    Generate an Obsidian-formatted markdown note for a knowledge node.
    Includes wiki-linked [[relationships]].
    Writes to EA-Knowledge-Base/Knowledge_Graph/{node_type}/{title}.md
    """
    node = get_node(node_id)
    if not node:
        return None

    rels = get_node_relationships(node_id)
    obsidian_root = _BASE / "Knowledge_Graph" / node["node_type"].replace(" ", "_")
    obsidian_root.mkdir(parents=True, exist_ok=True)

    safe_title = re.sub(r"[^\w\s-]", "", node["title"])[:60].strip()
    date_str = datetime.now().strftime("%Y-%m-%d")
    note_path = obsidian_root / f"{date_str}_{safe_title}.md"

    outgoing = [r for r in rels if r["from_node_id"] == node_id]
    incoming = [r for r in rels if r["to_node_id"] == node_id]

    lines = [
        "---",
        f"node_id: {node['node_id']}",
        f"node_type: {node['node_type']}",
        f"title: \"{node['title']}\"",
        f"confidence: {node['confidence']}",
        f"tags: [{node.get('tags', '')}]",
        f"created: {date_str}",
        "---",
        "",
        f"# {node['title']}",
        "",
        f"> **Type:** {node['node_type']} | **Confidence:** {node['confidence']:.0f}/100",
        "",
        "## Description",
        node.get("description", "_No description_"),
        "",
    ]

    if outgoing:
        lines += ["## Outgoing Relationships", ""]
        for r in outgoing:
            lines.append(f"- **{r['rel_type'].replace('_',' ')}** → [[{r['to_title']}]] _(strength: {r['strength']:.0f})_")
            if r.get("rationale"):
                lines.append(f"  - _{r['rationale']}_")
        lines.append("")

    if incoming:
        lines += ["## Incoming Relationships", ""]
        for r in incoming:
            lines.append(f"- [[{r['from_title']}]] **{r['rel_type'].replace('_',' ')}** this _(strength: {r['strength']:.0f})_")
        lines.append("")

    lines += [
        "## Notes",
        "_Add manual notes here._",
        "",
        "---",
        f"*Auto-generated by QTrade OS Knowledge Graph | {date_str}*",
    ]

    note_path.write_text("\n".join(lines), encoding="utf-8")

    con = _con()
    try:
        con.execute(
            "UPDATE knowledge_nodes SET obsidian_path=?, updated_at=datetime('now') WHERE node_id=?",
            (str(note_path), node_id),
        )
        con.commit()
    finally:
        con.close()

    return str(note_path)
