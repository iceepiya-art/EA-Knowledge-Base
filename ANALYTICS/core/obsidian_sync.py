"""
obsidian_sync.py — Obsidian ↔ DB ↔ Dashboard Bidirectional Sync

Batch-writes all principles and knowledge graph nodes to the Obsidian vault.
Updates note_path / obsidian_path in the DB after each write.
Provides sync status reporting for the dashboard.

Phases:
  1. Principles    → sync_all_principles()  — all rows in mindset_principles
  2. KG Nodes      → sync_knowledge_nodes() — strategies, regimes, concepts, etc.
  3. Full pipeline → run_full_sync()        — both phases + summary
  4. Status        → get_sync_status()      — what's written vs missing
"""

from __future__ import annotations

import sqlite3
import sys
from datetime import datetime
from pathlib import Path
from typing import Any

_BASE   = Path(__file__).resolve().parents[2]
DB_PATH = _BASE / "DATA" / "processed" / "trades.sqlite"

# Ensure core modules are importable when called from dashboard
_CORE = Path(__file__).resolve().parent
if str(_CORE) not in sys.path:
    sys.path.insert(0, str(_CORE))

# ── DB helper ──────────────────────────────────────────────────────────────────

def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    con.execute("PRAGMA journal_mode=WAL")
    return con


# ── Phase 1: Principles → Obsidian ────────────────────────────────────────────

def sync_all_principles(force: bool = False) -> dict[str, Any]:
    """
    Batch-write all active principles to the Obsidian vault.

    Each principle is written via mindset_tracker.write_principle_note(), which
    also updates the note_path column in mindset_principles.

    Args:
        force: Re-write even if note_path is already set and file exists.

    Returns: phase summary dict
    """
    import mindset_tracker as mt

    con = _con()
    try:
        rows = con.execute(
            "SELECT principle_id, title, note_path "
            "FROM mindset_principles WHERE status='active' ORDER BY created_at",
        ).fetchall()
    finally:
        con.close()

    written  = 0
    skipped  = 0
    failed   = 0
    errors: list[str] = []

    for row in rows:
        pid   = row["principle_id"]
        title = row["title"]
        existing = row["note_path"]

        # Skip if already synced and file exists (unless force=True)
        if existing and not force:
            full = _BASE / existing
            if full.exists():
                skipped += 1
                continue

        try:
            path = mt.write_principle_note(pid)
            if path:
                written += 1
            else:
                failed += 1
                errors.append(f"{pid} ({title[:40]}): write_principle_note returned None")
        except Exception as e:
            failed += 1
            errors.append(f"{pid} ({title[:40]}): {e}")

    return {
        "phase":   "principles",
        "total":   len(rows),
        "written": written,
        "skipped": skipped,
        "failed":  failed,
        "errors":  errors,
    }


# ── Phase 2: Knowledge Nodes → Obsidian ───────────────────────────────────────

def sync_knowledge_nodes(
    node_types: list[str] | None = None,
    force: bool = False,
) -> dict[str, Any]:
    """
    Batch-write knowledge graph nodes to the Obsidian vault.

    Uses knowledge_graph.generate_node_note() for each node, which writes to
    EA-Knowledge-Base/Knowledge_Graph/{node_type}/ and updates obsidian_path.

    Args:
        node_types: Restrict to these types. Default: all except 'research'
                    (research nodes are 400+ calendar/news items — too noisy).
        force:      Re-write even if obsidian_path already set and file exists.

    Returns: phase summary dict
    """
    import knowledge_graph as kg

    if node_types is None:
        node_types = [
            "strategy", "regime", "session", "behavior",
            "risk_rule", "concept", "principle", "hypothesis", "edge",
        ]

    con = _con()
    try:
        ph = ",".join("?" * len(node_types))
        rows = con.execute(
            f"SELECT node_id, node_type, title, obsidian_path "
            f"FROM knowledge_nodes "
            f"WHERE node_type IN ({ph}) AND status='active' "
            f"ORDER BY node_type, title",
            node_types,
        ).fetchall()
    finally:
        con.close()

    written  = 0
    skipped  = 0
    failed   = 0
    by_type: dict[str, int] = {}
    errors: list[str] = []

    for row in rows:
        nid      = row["node_id"]
        ntype    = row["node_type"]
        existing = row["obsidian_path"]

        if existing and not force:
            full = _BASE / existing
            if full.exists():
                skipped += 1
                continue

        try:
            path = kg.generate_node_note(nid)
            if path:
                written += 1
                by_type[ntype] = by_type.get(ntype, 0) + 1
            else:
                failed += 1
                errors.append(f"{nid} ({row['title'][:40]}): generate_node_note returned None")
        except Exception as e:
            failed += 1
            errors.append(f"{nid} ({row['title'][:40]}): {e}")

    return {
        "phase":   "knowledge_nodes",
        "total":   len(rows),
        "written": written,
        "skipped": skipped,
        "failed":  failed,
        "by_type": by_type,
        "errors":  errors,
    }


# ── Full sync pipeline ─────────────────────────────────────────────────────────

def run_full_sync(force: bool = False) -> dict[str, Any]:
    """
    Complete Obsidian sync in two phases.

    Returns combined summary with per-phase details.
    """
    started = datetime.now().isoformat()

    p1 = sync_all_principles(force=force)
    p2 = sync_knowledge_nodes(force=force)

    return {
        "started_at":    started,
        "completed_at":  datetime.now().isoformat(),
        "principles":    p1,
        "knowledge_nodes": p2,
        "total_written": p1["written"] + p2["written"],
        "total_skipped": p1["skipped"] + p2["skipped"],
        "total_failed":  p1["failed"]  + p2["failed"],
        "all_errors":    p1["errors"]  + p2["errors"],
    }


# ── Sync status report ─────────────────────────────────────────────────────────

def get_sync_status() -> dict[str, Any]:
    """
    Report on current sync state without writing anything.

    Checks DB note_path columns AND verifies files actually exist on disk.
    Returns counts per category so the dashboard can show what's stale.
    """
    con = _con()
    try:
        # ── Principles ──────────────────────────────────────────────────────
        total_p = con.execute(
            "SELECT COUNT(*) FROM mindset_principles WHERE status='active'"
        ).fetchone()[0]

        p_rows = con.execute(
            "SELECT principle_id, title, note_path "
            "FROM mindset_principles WHERE status='active'",
        ).fetchall()

        p_db_set   = sum(1 for r in p_rows if r["note_path"])
        p_on_disk  = sum(1 for r in p_rows if r["note_path"] and (_BASE / r["note_path"]).exists())
        p_missing  = [
            {"id": r["principle_id"], "title": r["title"][:60]}
            for r in p_rows
            if not r["note_path"] or not (_BASE / r["note_path"]).exists()
        ]

        # ── Knowledge nodes ─────────────────────────────────────────────────
        node_rows = con.execute(
            "SELECT node_type, node_id, title, obsidian_path "
            "FROM knowledge_nodes WHERE status='active'",
        ).fetchall()

        by_type: dict[str, dict] = {}
        for r in node_rows:
            t = r["node_type"]
            if t not in by_type:
                by_type[t] = {"total": 0, "db_set": 0, "on_disk": 0}
            by_type[t]["total"] += 1
            if r["obsidian_path"]:
                by_type[t]["db_set"] += 1
                if (_BASE / r["obsidian_path"]).exists():
                    by_type[t]["on_disk"] += 1

    finally:
        con.close()

    return {
        "principles": {
            "total":     total_p,
            "db_path_set": p_db_set,
            "files_exist": p_on_disk,
            "needs_sync":  total_p - p_on_disk,
            "missing":     p_missing,
        },
        "knowledge_nodes": by_type,
        "generated_at": datetime.now().isoformat(),
    }


# ── Incremental resync (for stale files) ──────────────────────────────────────

def resync_stale(max_age_days: int = 7) -> dict[str, Any]:
    """
    Re-write Obsidian notes that are older than max_age_days or missing.

    Principles updated in DB more recently than the note file get re-written.
    """
    import mindset_tracker as mt
    import knowledge_graph as kg

    now = datetime.now()
    rewritten_p  = 0
    rewritten_kg = 0

    # ── Stale principles ───────────────────────────────────────────────────
    con = _con()
    try:
        p_rows = con.execute(
            "SELECT principle_id, note_path, updated_at "
            "FROM mindset_principles WHERE status='active'",
        ).fetchall()
    finally:
        con.close()

    for r in p_rows:
        pid   = r["principle_id"]
        npath = r["note_path"]
        needs_write = True

        if npath:
            full = _BASE / npath
            if full.exists():
                mtime = datetime.fromtimestamp(full.stat().st_mtime)
                age   = (now - mtime).days
                if age < max_age_days:
                    needs_write = False

        if needs_write:
            try:
                if mt.write_principle_note(pid):
                    rewritten_p += 1
            except Exception:
                pass

    # ── Stale KG nodes ─────────────────────────────────────────────────────
    con = _con()
    try:
        n_rows = con.execute(
            "SELECT node_id, node_type, obsidian_path, updated_at "
            "FROM knowledge_nodes "
            "WHERE status='active' AND node_type NOT IN ('research')",
        ).fetchall()
    finally:
        con.close()

    for r in n_rows:
        nid   = r["node_id"]
        npath = r["obsidian_path"]
        needs_write = True

        if npath:
            full = _BASE / npath
            if full.exists():
                mtime = datetime.fromtimestamp(full.stat().st_mtime)
                age   = (now - mtime).days
                if age < max_age_days:
                    needs_write = False

        if needs_write:
            try:
                if kg.generate_node_note(nid):
                    rewritten_kg += 1
            except Exception:
                pass

    return {
        "principles_rewritten":    rewritten_p,
        "kg_nodes_rewritten":      rewritten_kg,
        "max_age_days":            max_age_days,
        "completed_at":            datetime.now().isoformat(),
    }
