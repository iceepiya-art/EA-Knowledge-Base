"""
graph_integrity.py — Knowledge Graph Integrity & Quality Checks

Runs structural and semantic health checks on the knowledge graph:

  find_orphan_nodes()          — nodes with no relationships (dead weight)
  find_unsupported_claims()    — high-strength claims with no evidence
  find_duplicate_concepts()    — similar nodes that may be the same thing
  find_contradiction_conflicts() — opposing rel types between same pair
  find_isolated_clusters()     — groups of nodes disconnected from core graph
  find_stale_nodes()           — nodes not updated in N days
  generate_integrity_report()  — full composite health report
  repair_orphan_nodes()        — auto-link orphans to category nodes
  promote_high_confidence_rels() — upgrade strength on evidence-backed rels
"""

from __future__ import annotations

import re
import sqlite3
from collections import defaultdict
from datetime import datetime, timedelta
from pathlib import Path
from typing import Any

import knowledge_graph as kg

# ── DB helper ──────────────────────────────────────────────────────────────────

_BASE   = Path(__file__).resolve().parents[2]
DB_PATH = _BASE / "DATA" / "processed" / "trades.sqlite"


def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    con.execute("PRAGMA journal_mode=WAL")
    return con

# ══════════════════════════════════════════════════════════════════════════════
# CHECK 1 — Orphan nodes
# ══════════════════════════════════════════════════════════════════════════════

def find_orphan_nodes(min_age_hours: int = 0) -> list[dict]:
    """
    Nodes that have zero relationships (in or out).
    These contribute nothing to reasoning paths.

    Args:
        min_age_hours: Only return orphans older than this many hours
                       (avoids flagging freshly created nodes).
    Returns:
        list of node dicts with 'orphan_reason'
    """
    con = _con()
    try:
        rows = con.execute(
            """SELECT n.*
               FROM knowledge_nodes n
               WHERE n.status = 'active'
                 AND NOT EXISTS (
                     SELECT 1 FROM knowledge_relationships r
                     WHERE r.from_node_id = n.node_id OR r.to_node_id = n.node_id
                 )"""
        ).fetchall()
        result = []
        cutoff = datetime.now() - timedelta(hours=min_age_hours)
        for r in rows:
            if min_age_hours > 0:
                try:
                    created = datetime.fromisoformat(r["created_at"])
                    if created > cutoff:
                        continue
                except Exception:
                    pass
            d = dict(r)
            d["orphan_reason"] = "No relationships — not connected to any other node"
            result.append(d)
        return result
    finally:
        con.close()


def count_orphans_by_type() -> dict[str, int]:
    orphans = find_orphan_nodes()
    counts: dict[str, int] = {}
    for o in orphans:
        t = o["node_type"]
        counts[t] = counts.get(t, 0) + 1
    return counts

# ══════════════════════════════════════════════════════════════════════════════
# CHECK 2 — Unsupported claims
# ══════════════════════════════════════════════════════════════════════════════

def find_unsupported_claims(
    min_strength: float = 70.0,
    exclude_seed: bool = True,
) -> list[dict]:
    """
    High-strength relationships with no attached evidence.
    These are the most dangerous for institutional credibility.

    Seed relationships are excluded by default — they represent
    axioms (e.g. Martingale contradicts Kelly) that are definitionally
    true and don't require empirical evidence.

    Args:
        min_strength: Flag rels at or above this strength
        exclude_seed: Exclude 'seed' created_by relationships (axioms)
    """
    con = _con()
    try:
        query = """
            SELECT kr.rel_id, kr.rel_type, kr.strength, kr.evidence_count,
                   kr.rationale, kr.created_by, kr.created_at,
                   fn.title AS from_title, fn.node_type AS from_type,
                   tn.title AS to_title,   tn.node_type AS to_type
            FROM knowledge_relationships kr
            JOIN knowledge_nodes fn ON fn.node_id = kr.from_node_id
            JOIN knowledge_nodes tn ON tn.node_id = kr.to_node_id
            WHERE kr.evidence_count = 0
              AND kr.strength >= ?
        """
        params: list[Any] = [min_strength]
        if exclude_seed:
            query += " AND kr.created_by != 'seed'"
        query += " ORDER BY kr.strength DESC"

        rows = con.execute(query, params).fetchall()
        result = []
        for r in rows:
            d = dict(r)
            d["risk_level"] = (
                "critical" if r["strength"] >= 90 else
                "high"     if r["strength"] >= 80 else
                "medium"
            )
            d["recommendation"] = (
                f"Add at least 1 evidence item for this "
                f"'{r['rel_type']}' relationship. "
                f"Strength {r['strength']:.0f} without evidence is an unsupported claim."
            )
            result.append(d)
        return result
    finally:
        con.close()

# ══════════════════════════════════════════════════════════════════════════════
# CHECK 3 — Duplicate concepts
# ══════════════════════════════════════════════════════════════════════════════

_STOP_WORDS = {
    "the","a","an","and","or","of","in","for","to","with","on","at",
    "by","from","is","are","has","that","this","was","been","be",
    "using","use","how","why","when","what","which","as","about",
    "it","its","into","via","per","vs","vs.","over","between"
}


def _title_tokens(title: str) -> frozenset[str]:
    words = re.findall(r"\w+", title.lower())
    return frozenset(w for w in words if w not in _STOP_WORDS and len(w) > 2)


def find_duplicate_concepts(
    threshold_pct: float = 75.0,
    same_type_only: bool = True,
    exclude_types: list[str] | None = None,
) -> list[dict]:
    """
    Find nodes with high title token overlap — likely duplicates.
    Uses Jaccard similarity on meaningful title tokens.

    Args:
        threshold_pct: Flag pairs with Jaccard*100 >= this value
        same_type_only: If True, only compare nodes of the same type
        exclude_types: Node types to skip. Default: ['research'] (calendar events inflate count)
    """
    if exclude_types is None:
        exclude_types = ["research"]
    nodes = [n for n in kg.get_all_nodes() if n["node_type"] not in exclude_types]
    duplicates: list[dict] = []
    seen: set[tuple[str, str]] = set()

    for i, n1 in enumerate(nodes):
        t1 = _title_tokens(n1["title"])
        if not t1:
            continue
        for n2 in nodes[i + 1:]:
            if same_type_only and n1["node_type"] != n2["node_type"]:
                continue
            t2 = _title_tokens(n2["title"])
            if not t2:
                continue
            intersection = len(t1 & t2)
            union = len(t1 | t2)
            if union == 0:
                continue
            jaccard = intersection / union * 100
            if jaccard < threshold_pct:
                continue
            key = tuple(sorted([n1["node_id"], n2["node_id"]]))
            if key in seen:
                continue
            seen.add(key)
            # Get relationship counts for each
            n1_rels = len(kg.get_node_relationships(n1["node_id"]))
            n2_rels = len(kg.get_node_relationships(n2["node_id"]))
            duplicates.append({
                "node1_id":    n1["node_id"],
                "node2_id":    n2["node_id"],
                "node1_title": n1["title"],
                "node2_title": n2["title"],
                "node_type":   n1["node_type"],
                "overlap_pct": round(jaccard, 1),
                "node1_rels":  n1_rels,
                "node2_rels":  n2_rels,
                "recommendation": (
                    f"Consider merging — keep {'node1' if n1_rels >= n2_rels else 'node2'} "
                    f"(more relationships). Re-point relationships from duplicate to survivor."
                ),
            })

    return sorted(duplicates, key=lambda x: -x["overlap_pct"])

# ══════════════════════════════════════════════════════════════════════════════
# CHECK 4 — Contradiction conflicts
# ══════════════════════════════════════════════════════════════════════════════

def find_contradiction_conflicts(min_combined_strength: float = 100.0) -> list[dict]:
    """
    Find relationships that contradict each other between the same node pair.
    Only flags pairs where the total combined strength is significant.

    E.g.: QField works_best_in TRENDING (str 90) AND QField fails_in TRENDING (str 85)
    """
    raw = kg.detect_contradictions()
    result = []
    for c in raw:
        combined = c.get("str_a", 0) + c.get("str_b", 0)
        if combined < min_combined_strength:
            continue
        c["combined_strength"] = combined
        c["severity"] = (
            "critical" if combined >= 160 else
            "high"     if combined >= 130 else
            "medium"
        )
        c["recommendation"] = (
            f"Review '{c['rel_a']}' vs '{c['rel_b']}' between "
            f"'{c['from_title']}' and '{c['to_title']}'. "
            "These may be context-dependent — add rationale or delete the weaker one."
        )
        result.append(c)
    return sorted(result, key=lambda x: -x["combined_strength"])

# ══════════════════════════════════════════════════════════════════════════════
# CHECK 5 — Isolated clusters
# ══════════════════════════════════════════════════════════════════════════════

def find_isolated_clusters(min_cluster_size: int = 2) -> list[dict]:
    """
    Find groups of nodes that are connected to each other but not to the
    main graph (seed nodes). Uses union-find on the relationship graph.

    Returns list of clusters (excluding the main component).
    """
    nodes = kg.get_all_nodes()
    rels  = kg.get_all_relationships()

    node_ids = {n["node_id"] for n in nodes}

    # Seed node IDs (manually verified, part of core graph)
    SEED_PREFIX = {"s_", "r_", "c_", "b_", "rr_", "sess_"}
    seed_nodes = {nid for nid in node_ids if any(nid.startswith(p) for p in SEED_PREFIX)}

    # Build adjacency
    adj: dict[str, set[str]] = {nid: set() for nid in node_ids}
    for r in rels:
        fid, tid = r["from_node_id"], r["to_node_id"]
        if fid in adj and tid in adj:
            adj[fid].add(tid)
            adj[tid].add(fid)

    # BFS from each seed node to find main component
    visited: set[str] = set()
    queue = list(seed_nodes)
    while queue:
        nid = queue.pop()
        if nid in visited:
            continue
        visited.add(nid)
        for neighbor in adj.get(nid, set()):
            if neighbor not in visited:
                queue.append(neighbor)

    # All nodes NOT in main component
    isolated = node_ids - visited
    if not isolated:
        return []

    # Group into clusters via BFS within isolated set
    clusters: list[set[str]] = []
    remaining = set(isolated)
    while remaining:
        start = next(iter(remaining))
        cluster: set[str] = set()
        q = [start]
        while q:
            nid = q.pop()
            if nid in cluster:
                continue
            cluster.add(nid)
            for neighbor in adj.get(nid, set()):
                if neighbor in remaining and neighbor not in cluster:
                    q.append(neighbor)
        remaining -= cluster
        clusters.append(cluster)

    result = []
    node_map = {n["node_id"]: n for n in nodes}
    for cluster in clusters:
        if len(cluster) < min_cluster_size:
            # Single orphan — covered by find_orphan_nodes
            continue
        members = [node_map[nid] for nid in cluster if nid in node_map]
        result.append({
            "size":    len(cluster),
            "members": [{"node_id": m["node_id"], "title": m["title"],
                         "node_type": m["node_type"]} for m in members],
            "recommendation": (
                f"Cluster of {len(cluster)} nodes is isolated from the main graph. "
                "Add at least 1 relationship connecting it to a seed node "
                "(strategy, regime, concept, or risk_rule)."
            ),
        })

    return sorted(result, key=lambda x: -x["size"])

# ══════════════════════════════════════════════════════════════════════════════
# CHECK 6 — Stale nodes
# ══════════════════════════════════════════════════════════════════════════════

def find_stale_nodes(stale_days: int = 90) -> list[dict]:
    """
    Find non-research nodes that haven't been updated in stale_days days.
    Research nodes are excluded (they're from static arena data).
    """
    cutoff = (datetime.now() - timedelta(days=stale_days)).isoformat()
    con = _con()
    try:
        rows = con.execute(
            """SELECT node_id, node_type, title, confidence, updated_at
               FROM knowledge_nodes
               WHERE status='active'
                 AND node_type NOT IN ('research')
                 AND (updated_at < ? OR updated_at IS NULL)
               ORDER BY updated_at ASC""",
            (cutoff,),
        ).fetchall()
        result = []
        for r in rows:
            d = dict(r)
            d["stale_days"] = stale_days
            d["recommendation"] = (
                f"This node hasn't been reviewed in {stale_days}+ days. "
                "Re-validate relationships or update confidence score."
            )
            result.append(d)
        return result
    finally:
        con.close()

# ══════════════════════════════════════════════════════════════════════════════
# CHECK 7 — Evidence quality audit
# ══════════════════════════════════════════════════════════════════════════════

def audit_evidence_quality() -> dict[str, Any]:
    """
    Audit all evidence_links for quality:
    - Count by evidence_type
    - Count with sample_n > 0 (has actual trade data)
    - Count with high/medium/low confidence
    - Average confidence per type
    """
    con = _con()
    try:
        rows = con.execute(
            """SELECT evidence_type, confidence, sample_n, supports
               FROM evidence_links"""
        ).fetchall()
        if not rows:
            return {"total": 0}

        by_type: dict[str, list[float]] = {}
        with_n: int = 0
        supporting: int = 0

        for r in rows:
            et = r["evidence_type"]
            by_type.setdefault(et, []).append(float(r["confidence"] or 0))
            if (r["sample_n"] or 0) > 0:
                with_n += 1
            if r["supports"]:
                supporting += 1

        total = len(rows)
        type_summary = {
            et: {
                "count":      len(confs),
                "avg_conf":   round(sum(confs) / len(confs), 1),
                "pct_of_total": round(len(confs) / total * 100, 1),
            }
            for et, confs in by_type.items()
        }

        return {
            "total":            total,
            "with_sample_n":    with_n,
            "supporting":       supporting,
            "undermining":      total - supporting,
            "pct_with_n":       round(with_n / total * 100, 1),
            "by_type":          type_summary,
        }
    finally:
        con.close()

# ══════════════════════════════════════════════════════════════════════════════
# COMPOSITE INTEGRITY REPORT
# ══════════════════════════════════════════════════════════════════════════════

def generate_integrity_report(
    stale_days: int = 90,
    dup_threshold: float = 75.0,
    unsupported_min_strength: float = 70.0,
) -> dict[str, Any]:
    """
    Run all integrity checks and return a comprehensive health report.
    Includes: pass/fail status, counts, severity breakdown, and action items.
    """
    stats = kg.get_graph_stats()

    orphans       = find_orphan_nodes(min_age_hours=0)
    unsupported   = find_unsupported_claims(min_strength=unsupported_min_strength)
    duplicates    = find_duplicate_concepts(threshold_pct=dup_threshold)
    contradictions= find_contradiction_conflicts()
    isolated      = find_isolated_clusters()
    stale         = find_stale_nodes(stale_days=stale_days)
    evidence_audit= audit_evidence_quality()

    # Overall health score (0-100)
    # Orphan research nodes are expected (not all arena items get atom coverage)
    # Seed rels with no evidence are axioms — excluded from unsupported count
    # Real threats: user-created unsupported claims, contradictions, isolated clusters
    total_nodes = max(stats["total_nodes"], 1)
    total_rels  = max(stats["total_rels"], 1)

    deductions = 0.0
    # Orphans: only penalize if > 30% of nodes (some orphans are normal for research nodes)
    orphan_pct = len(orphans) / total_nodes
    if orphan_pct > 0.30:
        deductions += min(15.0, (orphan_pct - 0.30) * 50)
    # Unsupported user claims (seed excluded by default)
    for u in unsupported:
        deductions += {"critical": 4.0, "high": 2.0, "medium": 0.5}.get(u.get("risk_level",""), 0.2)
    deductions = min(deductions, 30.0)
    # Contradictions
    deductions += min(20.0, len(contradictions) * 4.0)
    # Duplicates (non-research only)
    deductions += min(10.0, len(duplicates) * 1.5)
    # Isolated clusters
    deductions += min(15.0, len(isolated) * 3.0)
    health_score = max(0.0, min(100.0, 100.0 - deductions))

    # Status
    status = "excellent" if health_score >= 90 else \
             "good"      if health_score >= 75 else \
             "fair"      if health_score >= 60 else \
             "poor"

    # Top action items (sorted by severity)
    action_items: list[dict[str, str]] = []

    for u in unsupported[:5]:
        if u.get("risk_level") == "critical":
            action_items.append({
                "priority": "🔴 Critical",
                "area":     "Unsupported claim",
                "action":   f"Add evidence for: '{u['from_title']}' {u['rel_type']} '{u['to_title']}' (str {u['strength']:.0f})",
            })
    for c in contradictions[:3]:
        action_items.append({
            "priority": f"{'🔴 Critical' if c['severity']=='critical' else '🟡 High'}",
            "area":     "Contradiction",
            "action":   c["recommendation"],
        })
    for d in duplicates[:3]:
        action_items.append({
            "priority": "🟡 Medium",
            "area":     "Duplicate concept",
            "action":   d["recommendation"],
        })
    if len(orphans) > 10:
        action_items.append({
            "priority": "🟢 Low",
            "area":     "Orphan nodes",
            "action":   f"{len(orphans)} orphan research nodes — link them or archive if irrelevant",
        })

    return {
        "generated_at":   datetime.now().isoformat(),
        "health_score":   round(health_score, 1),
        "status":         status,
        "graph_stats":    stats,
        "checks": {
            "orphan_nodes":       {"count": len(orphans),       "items": orphans[:20]},
            "unsupported_claims": {"count": len(unsupported),   "items": unsupported[:20]},
            "duplicate_concepts": {"count": len(duplicates),    "items": duplicates[:20]},
            "contradictions":     {"count": len(contradictions),"items": contradictions},
            "isolated_clusters":  {"count": len(isolated),      "items": isolated[:10]},
            "stale_nodes":        {"count": len(stale),         "items": stale[:20]},
        },
        "evidence_audit":  evidence_audit,
        "top_action_items": action_items[:10],
    }

# ══════════════════════════════════════════════════════════════════════════════
# AUTO-REPAIR — Orphan nodes
# ══════════════════════════════════════════════════════════════════════════════

# Category tag → best linking node for orphan research nodes
_ORPHAN_LINK_MAP: dict[str, tuple[str, str, float]] = {
    "ai_updates":    ("s_qfield",    "supports",        40.0),
    "trading_learn": ("s_qfield",    "supports",        45.0),
    "macro_news":    ("r_crash",     "linked_to_regime",45.0),
    "strategy":      ("s_qfield",    "supports",        40.0),
    "regime":        ("r_trending",  "linked_to_regime",40.0),
}


def repair_orphan_nodes(
    strategy: str = "link",
    dry_run: bool = True,
) -> dict[str, Any]:
    """
    Auto-repair orphan nodes.

    strategy='link'   → add a weak fallback relationship based on category tag
    strategy='archive'→ mark status='archived' for all orphans

    dry_run=True → report what would happen without making changes.

    Returns: {repaired, skipped, dry_run}
    """
    orphans = find_orphan_nodes(min_age_hours=1)
    repaired = 0
    skipped  = 0

    for node in orphans:
        nid  = node["node_id"]
        tags = (node.get("tags") or "").lower().split(",")

        if strategy == "archive":
            if not dry_run:
                con = _con()
                try:
                    con.execute(
                        "UPDATE knowledge_nodes SET status='archived', updated_at=datetime('now') WHERE node_id=?",
                        (nid,),
                    )
                    con.commit()
                finally:
                    con.close()
            repaired += 1

        elif strategy == "link":
            # Find best category match
            link_target: tuple[str, str, float] | None = None
            for tag in tags:
                tag = tag.strip()
                if tag in _ORPHAN_LINK_MAP:
                    link_target = _ORPHAN_LINK_MAP[tag]
                    break
            if link_target is None:
                skipped += 1
                continue

            target_nid, rel_type, strength = link_target
            if not dry_run:
                kg.add_relationship(
                    from_node_id=nid,
                    to_node_id=target_nid,
                    rel_type=rel_type,
                    strength=strength,
                    rationale="[auto-repair] orphan node linked to category default",
                    created_by="pipeline",
                )
            repaired += 1

    return {
        "total_orphans": len(orphans),
        "repaired":      repaired,
        "skipped":       skipped,
        "strategy":      strategy,
        "dry_run":       dry_run,
    }

# ══════════════════════════════════════════════════════════════════════════════
# CONFIDENCE PROMOTER — Upgrade rels backed by strong evidence
# ══════════════════════════════════════════════════════════════════════════════

def promote_high_confidence_rels(
    min_evidence: int = 3,
    strength_bonus: float = 10.0,
    max_strength: float = 95.0,
    dry_run: bool = True,
) -> dict[str, Any]:
    """
    Relationships with >= min_evidence evidence items get a strength bonus.
    This rewards rels that have been validated by multiple atoms.
    """
    con = _con()
    try:
        candidates = con.execute(
            """SELECT rel_id, strength, evidence_count,
                      from_node_id, to_node_id, rel_type
               FROM knowledge_relationships
               WHERE evidence_count >= ?
                 AND strength < ?
               ORDER BY evidence_count DESC""",
            (min_evidence, max_strength),
        ).fetchall()

        promoted = 0
        for r in candidates:
            new_strength = min(max_strength, float(r["strength"]) + strength_bonus)
            if not dry_run:
                con.execute(
                    "UPDATE knowledge_relationships SET strength=? WHERE rel_id=?",
                    (new_strength, r["rel_id"]),
                )
                promoted += 1
            else:
                promoted += 1  # count what would be promoted

        if not dry_run:
            con.commit()

        return {
            "candidates":  len(candidates),
            "promoted":    promoted,
            "dry_run":     dry_run,
            "bonus_applied": strength_bonus,
        }
    finally:
        con.close()

# ══════════════════════════════════════════════════════════════════════════════
# GRAPH METRICS — Advanced analytics
# ══════════════════════════════════════════════════════════════════════════════

def compute_node_centrality() -> list[dict]:
    """
    Compute simplified degree centrality for all nodes.
    Degree = in_degree + out_degree (weighted by relationship strength).
    Returns top nodes by centrality — these are the most connected / influential.
    """
    con = _con()
    try:
        nodes = con.execute(
            "SELECT node_id, title, node_type, confidence FROM knowledge_nodes WHERE status='active'"
        ).fetchall()

        centrality: dict[str, float] = {n["node_id"]: 0.0 for n in nodes}

        rels = con.execute(
            "SELECT from_node_id, to_node_id, strength FROM knowledge_relationships"
        ).fetchall()
        for r in rels:
            w = float(r["strength"]) / 100.0
            if r["from_node_id"] in centrality:
                centrality[r["from_node_id"]] += w
            if r["to_node_id"] in centrality:
                centrality[r["to_node_id"]] += w

        result = []
        for n in nodes:
            nid = n["node_id"]
            result.append({
                "node_id":    nid,
                "title":      n["title"],
                "node_type":  n["node_type"],
                "confidence": n["confidence"],
                "centrality": round(centrality[nid], 2),
            })

        return sorted(result, key=lambda x: -x["centrality"])
    finally:
        con.close()


def get_relationship_type_health() -> list[dict]:
    """
    For each relationship type: count, avg strength, avg evidence count.
    Reveals which relationship types are well-supported vs. bare assertions.
    """
    con = _con()
    try:
        rows = con.execute(
            """SELECT rel_type,
                      COUNT(*) AS count,
                      AVG(strength) AS avg_strength,
                      AVG(evidence_count) AS avg_evidence,
                      SUM(CASE WHEN evidence_count = 0 THEN 1 ELSE 0 END) AS no_evidence_count
               FROM knowledge_relationships
               GROUP BY rel_type
               ORDER BY count DESC"""
        ).fetchall()
        return [dict(r) for r in rows]
    finally:
        con.close()


def get_strategy_coverage_depth() -> list[dict]:
    """
    For each strategy node: how many relationships does it have, broken down by type?
    Reveals which strategies are well-researched vs. under-supported.
    """
    strategies = kg.get_all_nodes(node_type="strategy")
    result = []
    con = _con()
    try:
        for s in strategies:
            nid = s["node_id"]
            rows = con.execute(
                """SELECT rel_type, COUNT(*) AS count, AVG(strength) AS avg_str
                   FROM knowledge_relationships
                   WHERE from_node_id=? OR to_node_id=?
                   GROUP BY rel_type""",
                (nid, nid),
            ).fetchall()
            type_breakdown = {r["rel_type"]: {"count": r["count"], "avg_str": round(float(r["avg_str"]), 1)}
                              for r in rows}
            total_rels = sum(v["count"] for v in type_breakdown.values())

            result.append({
                "strategy":       s["title"],
                "node_id":        nid,
                "confidence":     s["confidence"],
                "total_rels":     total_rels,
                "rel_breakdown":  type_breakdown,
                "coverage_score": min(100.0, total_rels * 5),  # 20 rels = 100%
                "gaps": [
                    rt for rt in ("works_best_in", "fails_in", "linked_to_risk_model",
                                  "supports", "derived_from", "validated_by")
                    if rt not in type_breakdown
                ],
            })
    finally:
        con.close()

    return sorted(result, key=lambda x: -x["total_rels"])
