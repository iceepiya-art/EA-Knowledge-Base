"""
graph_pipeline.py — Knowledge Graph Population Pipeline

Transforms Learning Arena items (queue.json + atoms.json) into:
  - knowledge_nodes (research type)
  - knowledge_relationships (supports / linked_to_regime / linked_to_strategy / ...)
  - evidence_links (per-atom evidence records)

Also generates weak evidence warnings: low-N, overfitting risk,
regime dependency, high fragility.

Pipeline order:
  1. run_migration()            — ensure tables exist
  2. seed_nodes_and_relationships() — seed strategies/regimes/concepts
  3. import_arena_items_as_nodes()  — 429 queue items → research nodes
  4. extract_relationships_from_atoms() — 1305 atoms → rels + evidence_links
  5. detect_weak_evidence_risks()  — flag problems

No autonomous trading. Human-supervised only.
"""

from __future__ import annotations

import json
import re
import sqlite3
import uuid
from datetime import datetime
from pathlib import Path
from typing import Any

import knowledge_graph as kg

# ── Paths ──────────────────────────────────────────────────────────────────────

_BASE       = Path(__file__).resolve().parents[2]
DB_PATH     = _BASE / "DATA" / "processed" / "trades.sqlite"
QUEUE_PATH  = _BASE / "ea_research_team" / "learning" / "queue.json"
ATOMS_PATH  = _BASE / "ea_research_team" / "learning" / "atoms.json"

# ── applies_to → node ID mapping ──────────────────────────────────────────────
# All variants seen in the real atoms data

_ALL_STRATEGY_NODES = [
    "s_qfield", "s_quantumqueen", "s_hedgegrid",
    "s_smc_univ", "s_ninja", "s_mmf", "s_nqgc",
]

_EA_NODE_MAP: dict[str, str | list[str]] = {
    # QField variants
    "qfield":           "s_qfield",
    "qfield_ea":        "s_qfield",
    "qfield ea":        "s_qfield",
    # HedgeGrid variants
    "hedgegrid":        "s_hedgegrid",
    "hedgegrid_v23":    "s_hedgegrid",
    "hedgegrid v23":    "s_hedgegrid",
    # QuantumQueen
    "quantumqueen":     "s_quantumqueen",
    "quantum queen":    "s_quantumqueen",
    # SMC Universal
    "smc_universal":    "s_smc_univ",
    "smc universal":    "s_smc_univ",
    "smc_universal_ea": "s_smc_univ",
    "smcuniversal":     "s_smc_univ",
    # NinjaThai
    "ninjathai":        "s_ninja",
    "ninja":            "s_ninja",
    "ninja smc":        "s_ninja",
    # MMF
    "mmf":              "s_mmf",
    "makemoneyfar":     "s_mmf",
    "mmf_makemoneyfar": "s_mmf",
    # NQ-GC
    "nq-gc":            "s_nqgc",
    "nq_gc":            "s_nqgc",
    "nq-gc_scalper":    "s_nqgc",
    "gridbot":          "s_hedgegrid",  # approximate
    # All EAs
    "all_ea":           _ALL_STRATEGY_NODES,
    "all ea":           _ALL_STRATEGY_NODES,
    "allea":            _ALL_STRATEGY_NODES,
    "any_ea":           _ALL_STRATEGY_NODES,
    "any ea":           _ALL_STRATEGY_NODES,
    "ea":               _ALL_STRATEGY_NODES,
    "ea_volatility":    _ALL_STRATEGY_NODES,
}

# ── topic → (node_id, rel_type) mapping ───────────────────────────────────────

_TOPIC_MAP: dict[str, list[tuple[str, str]]] = {
    # Regimes
    "regime":               [("r_trending", "linked_to_regime"), ("r_reverting", "linked_to_regime"),
                              ("r_weak", "linked_to_regime"), ("r_crash", "linked_to_regime")],
    "regime_detection":     [("c_sc100", "related_to")],
    "regime detection":     [("c_sc100", "related_to")],
    "volatility":           [("r_crash", "linked_to_regime"), ("c_atr", "related_to")],
    "volatility spike":     [("r_crash", "linked_to_regime")],
    # Risk
    "risk":                 [("rr_daily_loss", "supports"), ("rr_kelly", "supports"),
                              ("rr_max_dd", "supports")],
    "risk_management":      [("rr_daily_loss", "supports"), ("rr_kelly", "supports"),
                              ("rr_max_dd", "supports"), ("rr_consec_loss", "supports")],
    "risk management":      [("rr_daily_loss", "supports"), ("rr_kelly", "supports"),
                              ("rr_max_dd", "supports")],
    "risk-management":      [("rr_daily_loss", "supports"), ("rr_kelly", "supports")],
    "position_sizing":      [("rr_kelly", "supports")],
    "position sizing":      [("rr_kelly", "supports")],
    # Concepts
    "atr":                  [("c_atr", "related_to")],
    "backtesting":          [("c_overfitting", "related_to"), ("rr_n30", "supports")],
    "optimization":         [("c_overfitting", "related_to")],
    "overfitting":          [("c_overfitting", "contradicts")],
    "correlation":          [],  # no direct node yet
    "entry":                [],  # too generic
    "exit":                 [],
    "execution":            [],
    "execution_speed":      [],
    # Sessions
    "timing":               [("sess_london", "linked_to_session"), ("sess_ny", "linked_to_session")],
    # News / macro
    "news event":           [("r_crash", "linked_to_regime")],
    "sentiment":            [("r_trending", "linked_to_regime")],
    # Signal
    "signal_generation":    [("c_fvg", "related_to"), ("c_choch", "related_to")],
    "signal generation":    [("c_fvg", "related_to")],
    "confirmation":         [("c_choch", "related_to")],
    # Validation
    "validation":           [("rr_n30", "supports")],
    "strategy_validation":  [("rr_n30", "supports"), ("c_overfitting", "related_to")],
    "strategy validation":  [("rr_n30", "supports")],
    # Direction
    "direction bias":       [("c_beta1", "related_to")],
}

# ── Confidence → strength ──────────────────────────────────────────────────────

def _conf_to_strength(conf: str) -> float:
    return {"high": 80.0, "medium": 60.0, "low": 40.0}.get(str(conf).lower(), 50.0)

# ── Arena data readers ─────────────────────────────────────────────────────────

def _read_queue() -> list[dict]:
    if not QUEUE_PATH.exists():
        return []
    return json.loads(QUEUE_PATH.read_text(encoding="utf-8"))


def _read_atoms() -> list[dict]:
    if not ATOMS_PATH.exists():
        return []
    return json.loads(ATOMS_PATH.read_text(encoding="utf-8"))

# ── HTML stripper ──────────────────────────────────────────────────────────────

_HTML_TAG = re.compile(r"<[^>]+>")
_MULTI_WS = re.compile(r"\s{2,}")


def _strip_html(text: str) -> str:
    text = _HTML_TAG.sub(" ", text)
    text = _MULTI_WS.sub(" ", text)
    return text.strip()

# ── Category classifier for nodes ─────────────────────────────────────────────

def _classify_item(item: dict) -> str:
    """Map arena category → knowledge node sub-label."""
    return {
        "Trading_Learn": "strategy",
        "AI_Updates":    "ai_engineering",
        "Macro_News":    "regime",
    }.get(item.get("category", ""), "research")

# ── applies_to normalizer ──────────────────────────────────────────────────────

def _resolve_applies_to(applies_list: list[str]) -> list[str]:
    """Resolve applies_to entries to known node IDs. Returns list of node_ids."""
    result: list[str] = []
    for raw in applies_list:
        key = raw.strip().lower()
        val = _EA_NODE_MAP.get(key)
        if val is None:
            continue
        if isinstance(val, list):
            result.extend(val)
        else:
            result.append(val)
    return list(dict.fromkeys(result))  # deduplicate preserving order


def _resolve_topics(topic_str: str) -> list[tuple[str, str]]:
    """
    Parse comma-separated topic string → list of (node_id, rel_type).
    """
    result: list[tuple[str, str]] = []
    for t in topic_str.split(","):
        key = t.strip().lower()
        mappings = _TOPIC_MAP.get(key, [])
        result.extend(mappings)
    # Deduplicate
    seen: set[tuple[str, str]] = set()
    deduped: list[tuple[str, str]] = []
    for item in result:
        if item not in seen:
            seen.add(item)
            deduped.append(item)
    return deduped

# ── Danger flag detector ───────────────────────────────────────────────────────

_DANGER_KW: dict[str, list[str]] = {
    "martingale":         ["martingale", "double after loss", "doubling lot", "lot multiplier"],
    "overfitting":        ["overfit", "curve fit", "data mining", "overoptimiz"],
    "optimization_bias":  ["optimize", "best parameters", "parameter sweep", "grid search params"],
    "revenge_trading":    ["revenge", "recover the loss", "make it back", "recover losses"],
    "overconfidence":     ["sure to win", "can't lose", "guaranteed", "always work"],
    "sunk_cost":          ["sunk cost", "already lost", "can't close", "hold and hope"],
    "recency_bias":       ["recently working", "just worked", "last few trades"],
    "survivorship_bias":  ["survivorship", "only look at winners", "best performers only"],
}


def _detect_danger_flags(text: str) -> list[str]:
    text_lc = text.lower()
    return [flag for flag, kws in _DANGER_KW.items() if any(kw in text_lc for kw in kws)]

# ── DB helpers ─────────────────────────────────────────────────────────────────

def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    con.execute("PRAGMA journal_mode=WAL")
    con.execute("PRAGMA foreign_keys=ON")
    return con


def _node_exists(node_id: str) -> bool:
    con = _con()
    try:
        row = con.execute(
            "SELECT 1 FROM knowledge_nodes WHERE node_id=?", (node_id,)
        ).fetchone()
        return row is not None
    finally:
        con.close()


def _add_evidence_link(
    rel_id: str | None,
    node_id: str,
    evidence_type: str,
    title: str,
    description: str,
    confidence: float,
    supports: int = 1,
    source_ref: str = "",
    sample_n: int = 0,
) -> str:
    ev_id = f"ev_{uuid.uuid4().hex[:12]}"
    con = _con()
    try:
        con.execute(
            """INSERT OR IGNORE INTO evidence_links
               (evidence_id, rel_id, node_id, evidence_type, title, description,
                sample_n, confidence, supports, source_ref)
               VALUES (?,?,?,?,?,?,?,?,?,?)""",
            (ev_id, rel_id, node_id, evidence_type, title[:200], description[:500],
             sample_n, confidence, supports, source_ref),
        )
        # Increment evidence_count on relationship
        if rel_id:
            con.execute(
                "UPDATE knowledge_relationships SET evidence_count = evidence_count + 1 WHERE rel_id=?",
                (rel_id,),
            )
        con.commit()
    except sqlite3.Error:
        con.rollback()
    finally:
        con.close()
    return ev_id

# ══════════════════════════════════════════════════════════════════════════════
# STEP 1 — Import arena items as research nodes
# ══════════════════════════════════════════════════════════════════════════════

_MIN_CONTENT_LEN = 80  # Skip items shorter than this (empty calendar entries)


def import_arena_items_as_nodes(
    statuses: list[str] | None = None,
    min_content_len: int = _MIN_CONTENT_LEN,
) -> dict[str, int]:
    """
    Import Learning Arena queue.json items as research knowledge_nodes.

    Only imports items with meaningful content (>= min_content_len chars).
    Skips items already in the graph.

    Returns: {created, skipped, too_short}
    """
    if statuses is None:
        statuses = ["written", "approved"]

    items = _read_queue()
    items = [i for i in items if i.get("status") in statuses]

    created = 0
    skipped = 0
    too_short = 0

    # Build set of existing source_ids to avoid re-import
    con = _con()
    try:
        existing = {
            row[0] for row in con.execute(
                "SELECT source_id FROM knowledge_nodes WHERE source_table='arena_queue'"
            ).fetchall()
        }
    finally:
        con.close()

    for item in items:
        arena_id = item["id"]

        if arena_id in existing:
            skipped += 1
            continue

        raw_content = item.get("content", "") or ""
        clean_content = _strip_html(raw_content)
        draft_note = item.get("draft_note", "") or ""

        # Merge all text for classification
        full_text = (item.get("title", "") + " " + clean_content + " " + draft_note).lower()

        if len(clean_content) < min_content_len:
            too_short += 1
            continue

        # Tags: danger flags + category
        danger_flags = _detect_danger_flags(full_text)
        tag_parts: list[str] = [item.get("category", "").lower()]
        if item.get("source"):
            src_slug = re.sub(r"[^\w]", "_", item["source"].lower())[:30]
            tag_parts.append(src_slug)
        tag_parts.extend(f"danger:{f}" for f in danger_flags)

        # Description: clean first 300 chars of content
        description = clean_content[:300]

        node_id = f"arena_{arena_id}"
        kg.upsert_node(
            node_id=node_id,
            node_type="research",
            title=item.get("title", "Untitled")[:120],
            description=description,
            source_id=arena_id,
            source_table="arena_queue",
            tags=",".join(filter(None, tag_parts)),
            confidence=0.0,  # will be updated after atom processing
            status="active",
        )
        created += 1

    return {"created": created, "skipped": skipped, "too_short": too_short}

# ══════════════════════════════════════════════════════════════════════════════
# STEP 2 — Extract relationships from atoms
# ══════════════════════════════════════════════════════════════════════════════

def extract_relationships_from_atoms(force: bool = False) -> dict[str, int]:
    """
    Process all atoms.json atoms:
    1. Find the research node for each atom's source_title.
    2. Resolve applies_to → strategy node IDs → add relationship.
    3. Resolve topic → regime/concept/risk_rule node IDs → add relationship.
    4. Create evidence_link for each relationship created.

    Returns: {rels_created, evidence_created, atoms_processed, atoms_skipped}
    """
    atoms = _read_atoms()
    items = _read_queue()

    # Build title → node_id index for research nodes
    title_to_nid: dict[str, str] = {}
    for item in items:
        nid = f"arena_{item['id']}"
        if _node_exists(nid):
            title_to_nid[item.get("title", "")] = nid

    rels_created    = 0
    evidence_created = 0
    atoms_processed  = 0
    atoms_skipped    = 0

    # Track which (research_node, target_node, rel_type) have been linked
    # to avoid adding duplicate evidence_links for the same relationship
    rel_cache: dict[tuple[str, str, str], str | None] = {}

    for atom in atoms:
        source_title = atom.get("source_title", "")
        research_nid = title_to_nid.get(source_title)
        if not research_nid:
            atoms_skipped += 1
            continue

        atoms_processed += 1
        strength   = _conf_to_strength(atom.get("confidence", "medium"))
        atom_id    = atom.get("id", "")
        insight    = atom.get("insight", "")
        action     = atom.get("action", "")
        topic_str  = atom.get("topic", "")
        applies_to = atom.get("applies_to", [])
        source_ref = atom.get("source_url", "")
        category   = atom.get("category", "")

        # Combined text for danger/context detection
        combined   = (insight + " " + action).lower()

        # Determine if this atom describes a failure/risk scenario
        is_failure_context = any(kw in combined for kw in [
            "avoid", "disable", "stop", "reduce position", "หลีกเลี่ยง",
            "ลด", "ปิด ea", "danger", "risk of", "fails", "ระวัง"
        ])

        # ── Apply strategies (via applies_to) ──────────────────────────────
        strategy_nids = _resolve_applies_to(applies_to)
        for target_nid in strategy_nids:
            if not _node_exists(target_nid):
                continue

            # Choose relationship type
            if is_failure_context:
                rel_type = "fails_in"   # research describes a failure mode
            else:
                rel_type = "supports"

            key = (research_nid, target_nid, rel_type)
            if key not in rel_cache:
                result = kg.add_relationship(
                    from_node_id=research_nid,
                    to_node_id=target_nid,
                    rel_type=rel_type,
                    strength=strength,
                    rationale=f"[atom:{atom_id}] {_strip_html(insight)[:150]}",
                    created_by="pipeline",
                )
                rel_cache[key] = result
                if result:
                    rels_created += 1

            rel_id = rel_cache.get(key)
            ev_id = _add_evidence_link(
                rel_id=rel_id,
                node_id=research_nid,
                evidence_type="arena_item",
                title=f"[{atom_id}] {source_title[:80]}",
                description=f"{_strip_html(insight)[:300]}\n\nAction: {_strip_html(action)[:200]}",
                confidence=strength,
                supports=0 if is_failure_context else 1,
                source_ref=source_ref,
            )
            evidence_created += 1

        # ── Apply topic → regime/concept/risk_rule nodes ────────────────────
        topic_targets = _resolve_topics(topic_str)
        for (target_nid, rel_type) in topic_targets:
            if not _node_exists(target_nid):
                continue

            key = (research_nid, target_nid, rel_type)
            if key not in rel_cache:
                result = kg.add_relationship(
                    from_node_id=research_nid,
                    to_node_id=target_nid,
                    rel_type=rel_type,
                    strength=strength * 0.85,  # topic links are slightly weaker
                    rationale=f"[atom:{atom_id}] topic={topic_str[:60]}",
                    created_by="pipeline",
                )
                rel_cache[key] = result
                if result:
                    rels_created += 1

            rel_id = rel_cache.get(key)
            _add_evidence_link(
                rel_id=rel_id,
                node_id=research_nid,
                evidence_type="arena_item",
                title=f"[{atom_id}] topic:{topic_str[:60]}",
                description=_strip_html(insight)[:300],
                confidence=strength * 0.85,
                supports=1,
                source_ref=source_ref,
            )
            evidence_created += 1

    return {
        "rels_created":     rels_created,
        "evidence_created": evidence_created,
        "atoms_processed":  atoms_processed,
        "atoms_skipped":    atoms_skipped,
        "total_atoms":      len(atoms),
    }

# ══════════════════════════════════════════════════════════════════════════════
# STEP 3 — Update research node confidence from atom evidence
# ══════════════════════════════════════════════════════════════════════════════

def update_node_confidence_from_evidence() -> dict[str, int]:
    """
    Recalculate confidence for each research node based on:
    - Number of atoms (evidence items) linked to it
    - Average atom confidence
    - Whether any atoms have "high" confidence (signals substantive insight)

    Returns: {nodes_updated}
    """
    atoms = _read_atoms()
    items = _read_queue()

    # Build: title → list of atom confidence values
    title_to_confs: dict[str, list[float]] = {}
    for atom in atoms:
        t = atom.get("source_title", "")
        c = _conf_to_strength(atom.get("confidence", "medium"))
        title_to_confs.setdefault(t, []).append(c)

    updated = 0
    for item in items:
        nid = f"arena_{item['id']}"
        confs = title_to_confs.get(item.get("title", ""), [])
        if not confs:
            continue
        n = len(confs)
        avg_conf = sum(confs) / n
        # Confidence formula: avg_atom_confidence + log bonus for quantity
        import math
        quantity_bonus = min(20.0, math.log1p(n) * 5)
        final_conf = min(95.0, avg_conf + quantity_bonus)

        con = _con()
        try:
            con.execute(
                "UPDATE knowledge_nodes SET confidence=?, updated_at=datetime('now') WHERE node_id=?",
                (round(final_conf, 1), nid),
            )
            con.commit()
            updated += 1
        except sqlite3.Error:
            con.rollback()
        finally:
            con.close()

    return {"nodes_updated": updated}

# ══════════════════════════════════════════════════════════════════════════════
# STEP 4 — Extract relationships from item content (secondary / keyword-based)
# ══════════════════════════════════════════════════════════════════════════════

# Keyword → (node_id, rel_type, strength)
_CONTENT_SIGNALS: list[tuple[str, str, str, float]] = [
    # Concepts
    ("sc100",        "c_sc100",      "related_to",      75.0),
    ("sc₁₀₀",        "c_sc100",      "related_to",      75.0),
    ("sign.change",  "c_sc100",      "related_to",      65.0),
    ("atr",          "c_atr",        "related_to",      70.0),
    ("average true", "c_atr",        "related_to",      70.0),
    ("bsl",          "c_bsl_ssl",    "related_to",      75.0),
    ("ssl",          "c_bsl_ssl",    "related_to",      75.0),
    ("liquidity",    "c_bsl_ssl",    "related_to",      60.0),
    ("choch",        "c_choch",      "related_to",      75.0),
    ("change of character", "c_choch", "related_to",    70.0),
    ("fair value gap","c_fvg",       "related_to",      75.0),
    ("fvg",          "c_fvg",        "related_to",      75.0),
    ("beta.1",       "c_beta1",      "related_to",      70.0),
    ("ar.1",         "c_beta1",      "related_to",      65.0),
    ("martingale",   "c_martingale", "related_to",      85.0),
    ("overfit",      "c_overfitting","related_to",      80.0),
    ("curve.fit",    "c_overfitting","related_to",      80.0),
    # Regimes
    ("trending",     "r_trending",   "linked_to_regime",65.0),
    ("breakout",     "r_trending",   "linked_to_regime",60.0),
    ("mean.revert",  "r_reverting",  "linked_to_regime",65.0),
    ("ranging",      "r_reverting",  "linked_to_regime",60.0),
    ("range.bound",  "r_reverting",  "linked_to_regime",60.0),
    ("volatil",      "r_crash",      "linked_to_regime",55.0),
    ("crash",        "r_crash",      "linked_to_regime",70.0),
    ("spike",        "r_crash",      "linked_to_regime",55.0),
    ("news event",   "r_crash",      "linked_to_regime",65.0),
    ("high impact",  "r_crash",      "linked_to_regime",60.0),
    # Sessions
    ("london",       "sess_london",  "linked_to_session",70.0),
    ("ny open",      "sess_ny",      "linked_to_session",70.0),
    ("new york",     "sess_ny",      "linked_to_session",65.0),
    ("asian",        "sess_asian",   "linked_to_session",65.0),
    # Risk rules
    ("kelly",        "rr_kelly",     "supports",        75.0),
    ("position.siz", "rr_kelly",     "supports",        65.0),
    ("daily.loss",   "rr_daily_loss","supports",        75.0),
    ("drawdown",     "rr_max_dd",    "supports",        65.0),
    ("stop.trading", "rr_consec_loss","supports",       70.0),
    ("n.?[=>]?.?30", "rr_n30",       "supports",        80.0),
    ("minimum.?30",  "rr_n30",       "supports",        75.0),
    ("sample.size",  "rr_n30",       "supports",        65.0),
    # Behaviors
    ("revenge",      "b_revenge",    "related_to",      80.0),
    ("fomo",         "b_fomo",       "related_to",      80.0),
    ("overconfiden", "b_overconf",   "related_to",      80.0),
    ("sunk.cost",    "b_sunk_cost",  "related_to",      80.0),
]


def extract_relationships_from_content(
    batch_size: int = 50,
) -> dict[str, int]:
    """
    Secondary relationship extraction using keyword matching on item content.
    Processes items that already exist as research nodes but have few relationships.
    """
    items = _read_queue()
    rels_created = 0
    items_processed = 0

    con = _con()
    try:
        low_rel_nodes = {
            row[0] for row in con.execute(
                """SELECT n.node_id FROM knowledge_nodes n
                   LEFT JOIN knowledge_relationships r ON r.from_node_id = n.node_id
                   WHERE n.source_table='arena_queue' AND n.node_type='research'
                   GROUP BY n.node_id
                   HAVING COUNT(r.rel_id) < 3"""
            ).fetchall()
        }
    finally:
        con.close()

    for item in items:
        nid = f"arena_{item['id']}"
        if nid not in low_rel_nodes:
            continue

        full_text = (
            item.get("title", "") + " " +
            _strip_html(item.get("content", "")) + " " +
            item.get("draft_note", "")
        )
        text_lc = full_text.lower()

        for pattern, target_nid, rel_type, strength in _CONTENT_SIGNALS:
            if not _node_exists(target_nid):
                continue
            if re.search(pattern, text_lc):
                rel_result = kg.add_relationship(
                    from_node_id=nid,
                    to_node_id=target_nid,
                    rel_type=rel_type,
                    strength=strength,
                    rationale=f"[content-match] pattern={pattern}",
                    created_by="pipeline",
                )
                if rel_result:
                    rels_created += 1
                    _add_evidence_link(
                        rel_id=rel_result,
                        node_id=nid,
                        evidence_type="arena_item",
                        title=f"[content] {item.get('title','')[:80]}",
                        description=f"Keyword pattern '{pattern}' matched in item content.",
                        confidence=strength,
                        supports=1,
                        source_ref=item.get("url", ""),
                    )

        items_processed += 1
        if items_processed >= batch_size:
            break

    return {"rels_created": rels_created, "items_processed": items_processed}

# ══════════════════════════════════════════════════════════════════════════════
# STEP 5 — Weak evidence risk detection
# ══════════════════════════════════════════════════════════════════════════════

def detect_weak_evidence_risks() -> list[dict[str, Any]]:
    """
    Scan all research nodes and their relationships for risk patterns:

    1. Low sample size — research node has only 1 atom (low evidence base)
    2. Overfitting risk — backtesting topic without out-of-sample reference
    3. Regime dependency — node only links to 1 specific regime
    4. High fragility — node has only 1 outgoing relationship (single point of evidence)
    5. Single-strategy risk — atom applies_to only 1 EA (not generalized)
    6. Danger flags — node tags contain 'danger:' prefix

    Returns list of warning dicts.
    """
    atoms = _read_atoms()
    items = _read_queue()

    # Build: item_id → atom list
    item_atoms: dict[str, list[dict]] = {}
    for item in items:
        item_atoms[item["id"]] = []
    for atom in atoms:
        src = atom.get("source_title", "")
        for item in items:
            if item.get("title") == src:
                item_atoms[item["id"]].append(atom)
                break

    warnings: list[dict[str, Any]] = []
    con = _con()

    try:
        nodes = con.execute(
            "SELECT * FROM knowledge_nodes WHERE source_table='arena_queue' AND node_type='research'"
        ).fetchall()

        for node in nodes:
            nid  = node["node_id"]
            aid  = node["source_id"]
            node_atoms = item_atoms.get(aid, [])
            tags = node["tags"] or ""

            # Get relationships
            rels = con.execute(
                "SELECT rel_type, to_node_id FROM knowledge_relationships WHERE from_node_id=?",
                (nid,),
            ).fetchall()
            n_rels = len(rels)

            # 1. Low sample size
            if len(node_atoms) <= 1:
                warnings.append({
                    "node_id":   nid,
                    "title":     node["title"],
                    "risk_type": "low_evidence",
                    "severity":  "medium",
                    "message":   f"Only {len(node_atoms)} atom(s) — insufficient evidence base for relationship claims",
                    "action":    "Collect more insights from this source before using as evidence",
                })

            # 2. Overfitting risk
            backtesting_atoms = [a for a in node_atoms if "backtesting" in a.get("topic","").lower()
                                  or "optimization" in a.get("topic","").lower()]
            if backtesting_atoms:
                has_oos = any("out.of.sample" in (a.get("insight","") + a.get("action","")).lower()
                              or "walk.forward" in (a.get("insight","") + a.get("action","")).lower()
                              for a in node_atoms)
                if not has_oos:
                    warnings.append({
                        "node_id":   nid,
                        "title":     node["title"],
                        "risk_type": "overfitting_risk",
                        "severity":  "high",
                        "message":   "Backtesting topic without out-of-sample or walk-forward validation reference",
                        "action":    "Verify strategy works on unseen data (OOS or walk-forward test)",
                    })

            # 3. Regime dependency
            regime_rels = [r for r in rels if r["rel_type"] == "linked_to_regime"]
            if len(regime_rels) == 1:
                warnings.append({
                    "node_id":   nid,
                    "title":     node["title"],
                    "risk_type": "regime_dependency",
                    "severity":  "medium",
                    "message":   f"Evidence only links to 1 specific regime — edge may be regime-conditional",
                    "action":    "Test whether the finding holds across multiple regimes",
                })

            # 4. High fragility
            if n_rels == 1:
                warnings.append({
                    "node_id":   nid,
                    "title":     node["title"],
                    "risk_type": "high_fragility",
                    "severity":  "low",
                    "message":   "Single outgoing relationship — this node is fragile (one point of evidence)",
                    "action":    "Gather additional supporting evidence or cross-link to more nodes",
                })

            # 5. Single-strategy risk
            strategy_rels = [r for r in rels if r["rel_type"] in ("supports","fails_in")
                             and r["to_node_id"].startswith("s_")]
            if len(strategy_rels) == 1:
                strategy_atoms = [a for a in node_atoms
                                  if len(a.get("applies_to",[])) == 1]
                if len(strategy_atoms) == len(node_atoms) and len(node_atoms) > 0:
                    warnings.append({
                        "node_id":   nid,
                        "title":     node["title"],
                        "risk_type": "single_strategy_risk",
                        "severity":  "low",
                        "message":   "All atoms apply to only 1 strategy — findings may not generalize",
                        "action":    "Test whether this insight applies to other strategies or is EA-specific",
                    })

            # 6. Danger flags in tags
            danger_tags = [t for t in tags.split(",") if t.startswith("danger:")]
            for dtag in danger_tags:
                flag = dtag.replace("danger:", "")
                warnings.append({
                    "node_id":   nid,
                    "title":     node["title"],
                    "risk_type": f"danger_flag:{flag}",
                    "severity":  "high",
                    "message":   f"Danger flag detected: {flag} — this content contains a known cognitive trap",
                    "action":    f"Review content carefully before applying — danger pattern: {flag}",
                })

    finally:
        con.close()

    # Sort by severity
    severity_order = {"high": 0, "medium": 1, "low": 2}
    warnings.sort(key=lambda w: severity_order.get(w["severity"], 3))

    return warnings


def get_weak_evidence_summary() -> dict[str, Any]:
    """Summarized counts of weak evidence risk types."""
    warnings = detect_weak_evidence_risks()
    by_type: dict[str, int] = {}
    by_severity: dict[str, int] = {"high": 0, "medium": 0, "low": 0}
    for w in warnings:
        rt = w["risk_type"].split(":")[0]
        by_type[rt] = by_type.get(rt, 0) + 1
        by_severity[w["severity"]] = by_severity.get(w["severity"], 0) + 1
    return {
        "total":       len(warnings),
        "by_type":     by_type,
        "by_severity": by_severity,
        "warnings":    warnings,
    }

# ══════════════════════════════════════════════════════════════════════════════
# STEP 6 — Full pipeline orchestrator
# ══════════════════════════════════════════════════════════════════════════════

def run_full_pipeline(
    force_reimport: bool = False,
    verbose: bool = True,
) -> dict[str, Any]:
    """
    Run the complete population pipeline:
      1. Ensure migration applied
      2. Seed default nodes & relationships
      3. Import arena items as research nodes
      4. Extract relationships from atoms
      5. Secondary content-based extraction
      6. Update node confidence scores
      7. Detect weak evidence risks

    Returns: full result dict with counts per step.
    """
    result: dict[str, Any] = {
        "started_at": datetime.now().isoformat(),
        "steps": {},
    }

    # 1. Migration
    kg.run_migration()
    result["steps"]["migration"] = "ok"

    # 2. Seed
    seed_result = kg.seed_nodes_and_relationships()
    result["steps"]["seed"] = seed_result

    # 3. Import items
    import_result = import_arena_items_as_nodes()
    result["steps"]["import_nodes"] = import_result

    # 4. Atom relationships
    atom_result = extract_relationships_from_atoms()
    result["steps"]["atom_rels"] = atom_result

    # 5. Content-based (process all in batches of 200)
    content_result = extract_relationships_from_content(batch_size=500)
    result["steps"]["content_rels"] = content_result

    # 6. Confidence update
    conf_result = update_node_confidence_from_evidence()
    result["steps"]["confidence_update"] = conf_result

    # 7. DB sync (principles, hypotheses, edges)
    sync_result = kg.sync_nodes_from_db()
    result["steps"]["db_sync"] = sync_result

    # 8. Stats
    stats = kg.get_graph_stats()
    result["graph_stats"] = stats

    # 9. Weak evidence (just count, don't include full list in result)
    weak_summary = get_weak_evidence_summary()
    result["weak_evidence_summary"] = {
        "total": weak_summary["total"],
        "by_severity": weak_summary["by_severity"],
        "by_type": weak_summary["by_type"],
    }

    result["completed_at"] = datetime.now().isoformat()
    return result

# ── Per-item relationship stats ────────────────────────────────────────────────

def get_item_relationship_stats() -> list[dict[str, Any]]:
    """
    Return per-research-node stats: title, atom count, relationship count, confidence.
    Used by pipeline status views.
    """
    atoms = _read_atoms()
    items = _read_queue()

    title_atom_count: dict[str, int] = {}
    for atom in atoms:
        t = atom.get("source_title", "")
        title_atom_count[t] = title_atom_count.get(t, 0) + 1

    con = _con()
    try:
        rows = con.execute(
            """SELECT n.node_id, n.title, n.confidence, n.tags,
                      COUNT(r.rel_id) AS rel_count
               FROM knowledge_nodes n
               LEFT JOIN knowledge_relationships r ON r.from_node_id = n.node_id
               WHERE n.source_table='arena_queue'
               GROUP BY n.node_id
               ORDER BY rel_count DESC"""
        ).fetchall()
        result = []
        for row in rows:
            title = row["title"]
            result.append({
                "node_id":    row["node_id"],
                "title":      title,
                "confidence": row["confidence"],
                "tags":       row["tags"],
                "rel_count":  row["rel_count"],
                "atom_count": title_atom_count.get(title, 0),
            })
        return result
    finally:
        con.close()


def get_pipeline_coverage() -> dict[str, Any]:
    """
    High-level coverage metrics:
    - How many arena items are in the graph?
    - How many have at least 1 relationship?
    - Distribution by category
    """
    total_items = len(_read_queue())
    total_atoms = len(_read_atoms())

    con = _con()
    try:
        n_nodes = con.execute(
            "SELECT COUNT(*) FROM knowledge_nodes WHERE source_table='arena_queue'"
        ).fetchone()[0]

        n_with_rels = con.execute(
            """SELECT COUNT(DISTINCT n.node_id)
               FROM knowledge_nodes n
               JOIN knowledge_relationships r ON r.from_node_id = n.node_id
               WHERE n.source_table='arena_queue'"""
        ).fetchone()[0]

        tag_counts = {}
        rows = con.execute(
            "SELECT tags FROM knowledge_nodes WHERE source_table='arena_queue'"
        ).fetchall()
        for row in rows:
            for tag in (row["tags"] or "").split(","):
                tag = tag.strip()
                if tag in ("ai_updates", "macro_news", "trading_learn"):
                    tag_counts[tag] = tag_counts.get(tag, 0) + 1

        total_rels = con.execute(
            "SELECT COUNT(*) FROM knowledge_relationships WHERE created_by='pipeline'"
        ).fetchone()[0]

        total_evidence = con.execute(
            "SELECT COUNT(*) FROM evidence_links WHERE evidence_type='arena_item'"
        ).fetchone()[0]

        return {
            "arena_total_items":  total_items,
            "arena_total_atoms":  total_atoms,
            "nodes_in_graph":     n_nodes,
            "nodes_with_rels":    n_with_rels,
            "nodes_no_rels":      n_nodes - n_with_rels,
            "pipeline_rels":      total_rels,
            "evidence_links":     total_evidence,
            "coverage_pct":       round(n_with_rels / max(n_nodes, 1) * 100, 1),
            "by_category":        tag_counts,
        }
    finally:
        con.close()
