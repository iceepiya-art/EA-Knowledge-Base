"""
learning_arena_bridge.py — Learning Arena → QTrade OS integration bridge.

Reads approved/written items from the Learning Arena queue.json and atoms.json,
then syncs them into the research_inbox SQLite table used by QTrade OS dashboards.

Pipeline:
  Learning Arena (queue.json) → sync_from_arena() → research_inbox DB
                                                    → hypothesis_tracker (optional)

Does NOT touch the Learning Arena Flask app or its queue — read-only on arena side.
"""

from __future__ import annotations

import json
import sqlite3
from datetime import datetime
from pathlib import Path
from typing import Any

import pandas as pd

# ── Paths ─────────────────────────────────────────────────────────────────────

_BASE        = Path(__file__).resolve().parents[2]
DB_PATH      = _BASE / "DATA" / "processed" / "trades.sqlite"

_ARENA_ROOT  = _BASE / "ea_research_team" / "learning"
QUEUE_PATH   = _ARENA_ROOT / "queue.json"
ATOMS_PATH   = _ARENA_ROOT / "atoms.json"

# ── Arena category → QTrade OS category mapping ───────────────────────────────

_ARENA_CAT_MAP: dict[str, str] = {
    "Trading_Learn": "strategy",
    "AI_Updates":    "ai_engineering",
    "Macro_News":    "regime",
}

# ── Status mapping (arena queue status → research_inbox status) ───────────────
# Arena:   pending → approved → rejected → written
# QTrade:  inbox   → reviewing  (not yet written) | inbox (written/approved)

_ARENA_STATUS_MAP: dict[str, str] = {
    "pending":  "inbox",
    "approved": "reviewing",
    "written":  "inbox",    # written to vault → ready in QTrade inbox
    "rejected": "rejected",
}

# ── DB helpers ─────────────────────────────────────────────────────────────────

def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    con.execute("PRAGMA journal_mode=WAL")
    return con


def run_migration() -> None:
    """Apply migration 008 if the new columns don't exist yet."""
    migration_path = _BASE / "DATA" / "migrations" / "008_research_6state.sql"
    if not migration_path.exists():
        return

    sql = migration_path.read_text(encoding="utf-8")

    # Split on semicolons and run statement by statement
    stmts = [s.strip() for s in sql.split(";") if s.strip()]
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


# ── Arena data readers ─────────────────────────────────────────────────────────

def read_arena_queue() -> list[dict]:
    """Read all items from Learning Arena queue.json. Returns [] if missing."""
    if not QUEUE_PATH.exists():
        return []
    try:
        return json.loads(QUEUE_PATH.read_text(encoding="utf-8"))
    except Exception:
        return []


def read_arena_atoms() -> list[dict]:
    """Read all atoms from Learning Arena atoms.json. Returns [] if missing."""
    if not ATOMS_PATH.exists():
        return []
    try:
        return json.loads(ATOMS_PATH.read_text(encoding="utf-8"))
    except Exception:
        return []


def get_arena_queue_stats() -> dict[str, Any]:
    """Summary stats for the Learning Arena queue."""
    items = read_arena_queue()
    counts: dict[str, int] = {"pending": 0, "approved": 0, "written": 0, "rejected": 0}
    for item in items:
        s = item.get("status", "pending")
        counts[s] = counts.get(s, 0) + 1

    atoms = read_arena_atoms()
    return {
        "total":     len(items),
        "pending":   counts.get("pending",  0),
        "approved":  counts.get("approved", 0),
        "written":   counts.get("written",  0),
        "rejected":  counts.get("rejected", 0),
        "total_atoms": len(atoms),
        "queue_exists": QUEUE_PATH.exists(),
        "atoms_exists": ATOMS_PATH.exists(),
    }


# ── Already-synced check ───────────────────────────────────────────────────────

def _get_synced_arena_ids() -> set[str]:
    """Return arena_ids already in research_inbox."""
    try:
        con = _con()
        rows = con.execute(
            "SELECT arena_id FROM research_inbox WHERE arena_id IS NOT NULL"
        ).fetchall()
        con.close()
        return {r["arena_id"] for r in rows}
    except Exception:
        return set()


# ── Auto-classify without importing notebooklm_ingestor (avoid circular) ──────

_KW: dict[str, list[str]] = {
    "strategy":       ["strategy","entry","exit","signal","breakout","reversal","rsi","ema","sma",
                        "smc","ict","bos","choch","bsl","ssl","fvg","supply","demand","setup","edge"],
    "regime":         ["regime","sc100","trend","trending","reverting","crash","volatility",
                        "market state","β₁","sign change","momentum","ranging"],
    "psychology":     ["psychology","emotion","fear","fomo","greed","discipline","mindset","bias",
                        "mistake","revenge","overtrade","patience","journal","mental"],
    "risk":           ["risk","drawdown","kelly","position size","stop loss","rr ratio","risk reward",
                        "max loss","var","exposure","leverage","sizing","portfolio"],
    "execution":      ["execution","session","london","new york","asian","spread","slippage",
                        "timing","broker","mt5","latency","order"],
    "ai_engineering": ["ai","machine learning","ml","llm","language model","gpt","claude","agent",
                        "prediction","neural","deep learning","reinforcement"],
    "system_design":  ["system","architecture","pipeline","database","api","automation","ea",
                        "expert advisor","mql5","backtest","framework","obsidian","streamlit"],
}


def _classify(title: str, content: str) -> str:
    text = (title + " " + content).lower()
    scores = {cat: sum(1 for kw in kws if kw in text) for cat, kws in _KW.items()}
    best = max(scores, key=scores.get)
    return best if scores[best] > 0 else "uncategorized"


def detect_danger_flags_in_item(title: str, content: str) -> list[str]:
    """
    Detect dangerous thinking patterns in an arena item.
    Returns list of flag keys (martingale_addiction, overfitting, etc.)
    Calls mindset_tracker.detect_danger_flags when available, falls back to inline.
    """
    try:
        from mindset_tracker import detect_danger_flags
        return detect_danger_flags(title + " " + content)
    except ImportError:
        pass
    # Inline fallback (subset)
    text = (title + " " + content).lower()
    flags = []
    if any(kw in text for kw in ["martingale", "double after loss", "doubling lot"]):
        flags.append("martingale_addiction")
    if any(kw in text for kw in ["overfit", "curve fit", "data mining"]):
        flags.append("overfitting")
    if any(kw in text for kw in ["optimize", "best parameters", "parameter sweep"]):
        flags.append("optimization_bias")
    if any(kw in text for kw in ["revenge", "recover the loss", "make it back"]):
        flags.append("revenge_trading")
    return flags


# ── Atom helpers ───────────────────────────────────────────────────────────────

def get_atoms_for_item(arena_id: str) -> list[dict]:
    """Return atoms whose source_title matches the arena item title."""
    items = read_arena_queue()
    item  = next((i for i in items if i["id"] == arena_id), None)
    if not item:
        return []

    title_lc = item.get("title", "").lower()
    atoms    = read_arena_atoms()
    return [a for a in atoms if title_lc in a.get("source_title", "").lower()]


def get_recent_atoms(n: int = 20) -> list[dict]:
    """Return last N atoms from Learning Arena."""
    atoms = read_arena_atoms()
    return atoms[-n:] if atoms else []


# ── Core sync function ─────────────────────────────────────────────────────────

def sync_from_arena(statuses: list[str] | None = None, force: bool = False) -> dict[str, int]:
    """
    Sync Learning Arena items into research_inbox.

    Args:
        statuses: Arena statuses to import. Default: ["written", "approved"]
        force:    If True, re-import even if arena_id already exists.

    Returns:
        dict with keys: synced, skipped, errors, total_arena
    """
    if statuses is None:
        statuses = ["written", "approved"]

    items      = read_arena_queue()
    synced_ids = set() if force else _get_synced_arena_ids()

    to_import = [i for i in items if i.get("status") in statuses]
    all_atoms = read_arena_atoms()

    # Build atom lookup by source title
    atom_by_title: dict[str, list[dict]] = {}
    for atom in all_atoms:
        key = atom.get("source_title", "").strip()
        atom_by_title.setdefault(key, []).append(atom)

    synced = 0
    skipped = 0
    errors  = 0

    con = _con()
    try:
        for item in to_import:
            arena_id = item["id"]

            if arena_id in synced_ids and not force:
                skipped += 1
                continue

            title   = item.get("title", "Unknown")
            content = item.get("content", "")
            summary = item.get("summary", item.get("draft_note", "")[:200])

            # Map arena category → QTrade category
            arena_cat = item.get("category", "")
            qtrade_cat = _ARENA_CAT_MAP.get(arena_cat) or _classify(title, content)

            qtrade_status = _ARENA_STATUS_MAP.get(item.get("status", "pending"), "inbox")

            # Build item_id: arena_<arena_id>
            item_id = f"arena_{arena_id}"

            # Attach atoms
            item_atoms = atom_by_title.get(title, [])
            atoms_json = json.dumps(item_atoms, ensure_ascii=False) if item_atoms else None

            # Danger flag detection
            danger_flags = detect_danger_flags_in_item(title, content)
            if danger_flags:
                tags_set_pre = {"danger:" + f for f in danger_flags}
            else:
                tags_set_pre = set()

            # Tags from atoms topics
            tags_set: set[str] = tags_set_pre
            for a in item_atoms:
                if a.get("topic"):
                    tags_set.add(a["topic"].lower().replace(" ", "_"))
            if qtrade_cat != "uncategorized":
                tags_set.add(qtrade_cat)
            tags_str = ",".join(sorted(tags_set)) if tags_set else None

            # Key insights from atoms
            insights = [a.get("insight", "") for a in item_atoms if a.get("insight")]
            key_insights = json.dumps(insights[:5], ensure_ascii=False) if insights else None

            # Draft note becomes raw_notes
            raw_notes = item.get("draft_note", "")

            created_at_raw = item.get("created_at", "")
            # Normalize created_at to ISO format
            try:
                created_at = datetime.strptime(created_at_raw, "%Y-%m-%d %H:%M").isoformat()
            except Exception:
                created_at = datetime.now().isoformat()

            approved_at = item.get("approved_at")
            if approved_at:
                try:
                    approved_at = datetime.strptime(approved_at, "%Y-%m-%d %H:%M").isoformat()
                except Exception:
                    approved_at = None

            try:
                if force and arena_id in synced_ids:
                    con.execute(
                        """UPDATE research_inbox SET
                            title=?, source_type='learning_arena', source_url=?,
                            summary=?, raw_notes=?, category=?, status=?,
                            tags=?, key_insights=?, atoms_json=?,
                            arena_category=?, processed_at=?
                           WHERE arena_id=?""",
                        (title, item.get("url", ""), summary, raw_notes,
                         qtrade_cat, qtrade_status, tags_str, key_insights,
                         atoms_json, arena_cat, approved_at, arena_id)
                    )
                else:
                    con.execute(
                        """INSERT OR IGNORE INTO research_inbox
                            (item_id, title, source_type, source_url,
                             summary, raw_notes, category, status,
                             tags, key_insights, atoms_json,
                             arena_id, arena_category, created_at, processed_at)
                           VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                        (item_id, title, "learning_arena", item.get("url", ""),
                         summary, raw_notes, qtrade_cat, qtrade_status,
                         tags_str, key_insights, atoms_json,
                         arena_id, arena_cat, created_at, approved_at)
                    )
                con.commit()
                synced += 1
            except sqlite3.Error:
                con.rollback()
                errors += 1

    finally:
        con.close()

    return {
        "synced":       synced,
        "skipped":      skipped,
        "errors":       errors,
        "total_arena":  len(items),
        "import_scope": len(to_import),
    }


# ── Research-to-edge traceability ──────────────────────────────────────────────

def get_traceability_chain(hyp_id: str | None = None) -> list[dict]:
    """
    Return traceability chain rows: Research → Hypothesis → Edge.
    If hyp_id given, returns only that chain. Otherwise returns all chains.
    """
    try:
        con = _con()
        if hyp_id:
            rows = con.execute(
                """SELECT
                       ri.item_id, ri.title AS research_title, ri.category,
                       ri.status AS research_status, ri.source_type,
                       ri.arena_id, ri.arena_category,
                       h.hyp_id, h.title AS hyp_title, h.status AS hyp_status,
                       h.confidence_score, h.actual_n, h.min_trades,
                       h.actual_wr, h.actual_pf,
                       ve.edge_id, ve.edge_score, ve.alert_level,
                       ve.current_wr, ve.validated_wr
                   FROM research_inbox ri
                   LEFT JOIN hypotheses h ON h.hyp_id = ri.hyp_id
                   LEFT JOIN validated_edges ve ON ve.hyp_id = h.hyp_id
                   WHERE ri.hyp_id = ?
                   ORDER BY ri.created_at DESC""",
                (hyp_id,)
            ).fetchall()
        else:
            rows = con.execute(
                """SELECT
                       ri.item_id, ri.title AS research_title, ri.category,
                       ri.status AS research_status, ri.source_type,
                       ri.arena_id, ri.arena_category,
                       h.hyp_id, h.title AS hyp_title, h.status AS hyp_status,
                       h.confidence_score, h.actual_n, h.min_trades,
                       h.actual_wr, h.actual_pf,
                       ve.edge_id, ve.edge_score, ve.alert_level,
                       ve.current_wr, ve.validated_wr
                   FROM research_inbox ri
                   LEFT JOIN hypotheses h ON h.hyp_id = ri.hyp_id
                   LEFT JOIN validated_edges ve ON ve.hyp_id = h.hyp_id
                   WHERE ri.hyp_id IS NOT NULL
                   ORDER BY ri.created_at DESC""",
            ).fetchall()
        con.close()
        return [dict(r) for r in rows]
    except Exception:
        return []


def get_pipeline_counts() -> dict[str, Any]:
    """Return funnel counts for the full research → edge pipeline."""
    try:
        con = _con()

        # Research inbox counts by status
        r_counts = dict(con.execute(
            "SELECT status, COUNT(*) FROM research_inbox GROUP BY status"
        ).fetchall())

        # Hypothesis counts by status
        try:
            h_counts = dict(con.execute(
                "SELECT status, COUNT(*) FROM hypotheses GROUP BY status"
            ).fetchall())
        except Exception:
            h_counts = {}

        # Edge count
        try:
            edge_count = con.execute(
                "SELECT COUNT(*) FROM validated_edges"
            ).fetchone()[0]
        except Exception:
            edge_count = 0

        # Arena stats
        arena = get_arena_queue_stats()

        con.close()
        return {
            "arena_total":     arena["total"],
            "arena_written":   arena["written"],
            "arena_pending":   arena["pending"],
            "research_inbox":  r_counts.get("inbox",    0),
            "research_review": r_counts.get("reviewing",0),
            "research_total":  sum(r_counts.values()),
            "hyp_idea":        h_counts.get("idea",      0),
            "hyp_testing":     h_counts.get("testing",   0),
            "hyp_observing":   h_counts.get("observing", 0),
            "hyp_validated":   h_counts.get("validated", 0),
            "hyp_rejected":    h_counts.get("rejected",  0),
            "edges_live":      edge_count,
            "total_atoms":     arena["total_atoms"],
        }
    except Exception:
        return {}
