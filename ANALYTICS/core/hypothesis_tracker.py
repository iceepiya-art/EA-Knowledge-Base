"""
hypothesis_tracker.py — Hypothesis-to-Evidence pipeline.

5-state lifecycle:
  idea → testing → observing → validated | rejected

Evidence is tracked via hypothesis_evidence.
Every field change is logged to hypothesis_audit.
"""

from __future__ import annotations

import re
import sqlite3
from datetime import date
from pathlib import Path
from typing import Any

import pandas as pd

BASE_DIR     = Path(__file__).resolve().parents[2]
RESEARCH_DIR = BASE_DIR / "10_Research"
HYP_DIR      = RESEARCH_DIR / "11_Hypotheses"
EDGE_DIR     = RESEARCH_DIR / "12_Validated_Edges"
WEEKLY_DIR   = RESEARCH_DIR / "13_Weekly_Reviews"

STATUSES = ["idea", "testing", "observing", "validated", "rejected"]
STATUS_COLORS = {
    "idea":      "#8892b0",
    "testing":   "#ffd600",
    "observing": "#fb8c00",
    "validated": "#26a69a",
    "rejected":  "#ef5350",
}
PRIORITIES  = {1: "High", 2: "Medium", 3: "Low"}
EV_TYPES    = ["trade_stats", "manual", "backtest", "external", "counter"]
ALERT_COLORS = {"ok": "#26a69a", "watch": "#ffd600", "warn": "#fb8c00", "degrade": "#ef5350"}


def _cfg() -> dict:
    import json
    p = BASE_DIR / "SYSTEM" / "config" / "system_config.json"
    return json.load(open(p, encoding="utf-8")) if p.exists() else {}


DB_PATH = BASE_DIR / _cfg().get("db", {}).get("trades_db", "DATA/processed/trades.sqlite")


# ══════════════════════════════════════════════════════════════════════════════
# DB UTILS
# ══════════════════════════════════════════════════════════════════════════════

def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    return con


def _split_sql(sql: str) -> list[str]:
    """Split SQL script into individual statements, stripping comment lines."""
    stmts = []
    for stmt in sql.split(";"):
        lines = [l for l in stmt.splitlines() if not l.strip().startswith("--")]
        clean = " ".join(lines).strip()
        if clean:
            stmts.append(clean)
    return stmts


def run_migration() -> None:
    """Apply migrations 005 and 006 as needed."""
    con = _con()
    tables = {r[0] for r in con.execute(
        "SELECT name FROM sqlite_master WHERE type='table'"
    ).fetchall()}

    if "hypotheses" not in tables:
        mig = BASE_DIR / "DATA" / "migrations" / "005_hypothesis.sql"
        if mig.exists():
            try:
                con.executescript(mig.read_text(encoding="utf-8"))
                con.commit()
            except sqlite3.Error:
                pass
        tables = {r[0] for r in con.execute(
            "SELECT name FROM sqlite_master WHERE type='table'"
        ).fetchall()}

    if "hypothesis_evidence" not in tables:
        mig = BASE_DIR / "DATA" / "migrations" / "006_hypothesis_v2.sql"
        if mig.exists():
            for stmt in _split_sql(mig.read_text(encoding="utf-8")):
                try:
                    con.execute(stmt)
                    con.commit()
                except sqlite3.Error:
                    pass

    con.close()


def ensure_folders() -> None:
    for d in (HYP_DIR, EDGE_DIR, WEEKLY_DIR):
        d.mkdir(parents=True, exist_ok=True)
    _seed_readme(HYP_DIR,    "11_Hypotheses",
                 "Testable hypotheses: idea → testing → observing → validated | rejected.")
    _seed_readme(EDGE_DIR,   "12_Validated_Edges",
                 "Confirmed trading edges with ongoing performance tracking.")
    _seed_readme(WEEKLY_DIR, "13_Weekly_Reviews",
                 "Auto-generated weekly reviews from trade data.")


def _seed_readme(folder: Path, name: str, desc: str) -> None:
    p = folder / "README.md"
    if not p.exists():
        p.write_text(f"# {name}\n\n{desc}\n", encoding="utf-8")


# ══════════════════════════════════════════════════════════════════════════════
# ID GENERATION
# ══════════════════════════════════════════════════════════════════════════════

def _next_id(table: str, prefix: str) -> str:
    con = _con()
    n   = con.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
    con.close()
    return f"{prefix}-{n + 1:03d}"


# ══════════════════════════════════════════════════════════════════════════════
# AUDIT TRAIL
# ══════════════════════════════════════════════════════════════════════════════

def _audit(
    con: sqlite3.Connection,
    hyp_id: str,
    field_name: str,
    old_value: Any,
    new_value: Any,
    changed_by: str = "human",
) -> None:
    try:
        con.execute(
            "INSERT INTO hypothesis_audit (hyp_id, field_name, old_value, new_value, changed_by) "
            "VALUES (?,?,?,?,?)",
            (hyp_id, field_name,
             str(old_value) if old_value is not None else None,
             str(new_value) if new_value is not None else None,
             changed_by),
        )
    except sqlite3.Error:
        pass


def get_audit_trail(hyp_id: str) -> pd.DataFrame:
    con = _con()
    df = pd.read_sql_query(
        "SELECT * FROM hypothesis_audit WHERE hyp_id=? ORDER BY changed_at DESC",
        con, params=(hyp_id,),
    )
    con.close()
    return df


# ══════════════════════════════════════════════════════════════════════════════
# EVIDENCE TRACKING
# ══════════════════════════════════════════════════════════════════════════════

def record_evidence(
    hyp_id: str,
    title: str,
    description: str = "",
    ev_type: str = "trade_stats",
    trades_n: int | None = None,
    win_rate: float | None = None,
    profit_factor: float | None = None,
    expectancy: float | None = None,
    net_pnl: float | None = None,
    date_from: str | None = None,
    date_to: str | None = None,
    supports: int = 1,
    strength: int = 3,
    source_ref: str = "",
) -> tuple[bool, int, str]:
    """Record a piece of evidence for a hypothesis. Returns (ok, ev_id, message)."""
    con = _con()
    try:
        cur = con.execute("""
            INSERT INTO hypothesis_evidence
              (hyp_id, ev_type, title, description, trades_n, win_rate, profit_factor,
               expectancy, net_pnl, date_from, date_to, supports, strength, source_ref)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)
        """, (hyp_id, ev_type, title, description, trades_n, win_rate, profit_factor,
              expectancy, net_pnl, date_from, date_to, supports, strength, source_ref))
        ev_id = cur.lastrowid
        _audit(con, hyp_id, "evidence_added", None, f"{ev_id}:{title}", "human")
        con.commit()
        return True, ev_id, f"Evidence {ev_id} recorded"
    except sqlite3.Error as e:
        return False, 0, str(e)
    finally:
        con.close()


def get_evidence(hyp_id: str) -> pd.DataFrame:
    con = _con()
    df = pd.read_sql_query(
        "SELECT * FROM hypothesis_evidence WHERE hyp_id=? ORDER BY recorded_at DESC",
        con, params=(hyp_id,),
    )
    con.close()
    return df


# ══════════════════════════════════════════════════════════════════════════════
# HYPOTHESIS CRUD
# ══════════════════════════════════════════════════════════════════════════════

def create_hypothesis(
    title: str,
    description: str = "",
    rationale: str = "",
    ea_name: str | None = None,
    symbol: str | None = None,
    session: str | None = None,
    regime: str | None = None,
    direction: str | None = None,
    custom_filter: str = "",
    target_wr: float | None = None,
    target_pf: float | None = None,
    target_exp: float | None = None,
    min_trades: int = 30,
    priority: int = 2,
    notes: str = "",
    source_note: str = "",
) -> tuple[bool, str, str]:
    """Insert a new hypothesis and write a markdown note. Returns (ok, hyp_id, message)."""
    run_migration()
    ensure_folders()
    hyp_id = _next_id("hypotheses", "HYP")

    con = _con()
    con.execute("""
        INSERT INTO hypotheses
          (hyp_id, title, description, rationale, status, priority,
           ea_name, symbol, session, regime, direction, custom_filter,
           target_wr, target_pf, target_exp, min_trades, notes, source_note)
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
    """, (hyp_id, title, description, rationale, "idea", priority,
          ea_name, symbol, session, regime, direction, custom_filter or None,
          target_wr, target_pf, target_exp, min_trades, notes, source_note))
    _audit(con, hyp_id, "status", None, "idea", "human")
    con.commit()
    con.close()

    note_path = _write_hypothesis_note(
        hyp_id, title, description, rationale, ea_name, symbol,
        session, regime, direction, target_wr, target_pf, target_exp,
        min_trades, priority, notes,
    )
    return True, hyp_id, f"Created {hyp_id} → {note_path.name}"


_ALLOWED_UPDATE = {
    "title", "description", "rationale", "status", "priority",
    "ea_name", "symbol", "session", "regime", "direction", "custom_filter",
    "target_wr", "target_pf", "target_exp", "min_trades",
    "notes", "source_note", "hypothesis_note",
}

_LIFECYCLE_TS = {
    "testing":   "testing_since=datetime('now')",
    "observing": "observing_since=datetime('now')",
    "validated": "validated_at=datetime('now')",
    "rejected":  "rejected_at=datetime('now')",
}


def update_hypothesis(hyp_id: str, fields: dict) -> tuple[bool, str]:
    valid = {k: v for k, v in fields.items() if k in _ALLOWED_UPDATE}
    if not valid:
        return False, "No valid fields"

    hyp = get_hypothesis(hyp_id)
    if not hyp:
        return False, f"{hyp_id} not found"

    set_parts = [f"{k}=?" for k in valid]
    new_status = valid.get("status")
    if new_status and new_status != hyp.get("status") and new_status in _LIFECYCLE_TS:
        set_parts.append(_LIFECYCLE_TS[new_status])
    set_parts.append("updated_at=datetime('now')")

    con = _con()
    con.execute(
        f"UPDATE hypotheses SET {', '.join(set_parts)} WHERE hyp_id=?",
        list(valid.values()) + [hyp_id],
    )
    for k, new_v in valid.items():
        if str(hyp.get(k)) != str(new_v):
            _audit(con, hyp_id, k, hyp.get(k), new_v, "human")
    con.commit()
    con.close()
    return True, f"Updated {len(valid)} field(s)"


def get_hypotheses(status: str | None = None) -> pd.DataFrame:
    run_migration()
    con = _con()
    sql, params = "SELECT * FROM hypotheses", []
    if status:
        sql += " WHERE status = ?"; params.append(status)
    sql += " ORDER BY priority ASC, created_at DESC"
    df = pd.read_sql_query(sql, con, params=params)
    con.close()
    return df


def get_hypothesis(hyp_id: str) -> dict | None:
    run_migration()
    con = _con()
    row = con.execute("SELECT * FROM hypotheses WHERE hyp_id=?", (hyp_id,)).fetchone()
    con.close()
    return dict(row) if row else None


# ══════════════════════════════════════════════════════════════════════════════
# LIFECYCLE TRANSITIONS
# ══════════════════════════════════════════════════════════════════════════════

def advance_to_observing(hyp_id: str) -> tuple[bool, str]:
    """Move testing → observing when N >= min_trades."""
    hyp = get_hypothesis(hyp_id)
    if not hyp:
        return False, f"{hyp_id} not found"
    if hyp["status"] != "testing":
        return False, f"{hyp_id} is '{hyp['status']}', not 'testing'"
    n     = int(hyp.get("actual_n") or 0)
    min_n = int(hyp.get("min_trades") or 30)
    if n < min_n:
        return False, f"Need {min_n} trades, have {n}"
    con = _con()
    con.execute("""
        UPDATE hypotheses
        SET status='observing', observing_since=datetime('now'), updated_at=datetime('now')
        WHERE hyp_id=?
    """, (hyp_id,))
    _audit(con, hyp_id, "status", "testing", "observing", "system")
    con.commit()
    con.close()
    return True, f"{hyp_id} → observing"


def auto_check_observing(df: pd.DataFrame | None = None) -> int:
    """Auto-advance testing → observing for hypotheses with N >= min_trades."""
    hyps = get_hypotheses("testing")
    if hyps.empty:
        return 0
    advanced = 0
    for _, row in hyps.iterrows():
        stats = compute_live_stats(row.to_dict(), df)
        if stats.get("actual_n", 0) >= int(row.get("min_trades") or 30):
            ok, _ = advance_to_observing(row["hyp_id"])
            if ok:
                advanced += 1
    return advanced


def reject_hypothesis(hyp_id: str, reason: str = "") -> tuple[bool, str]:
    hyp = get_hypothesis(hyp_id)
    if not hyp:
        return False, f"{hyp_id} not found"
    con = _con()
    con.execute("""
        UPDATE hypotheses
        SET status='rejected', rejected_at=datetime('now'), updated_at=datetime('now')
        WHERE hyp_id=?
    """, (hyp_id,))
    _audit(con, hyp_id, "status", hyp.get("status"), "rejected", "human")
    if reason:
        _audit(con, hyp_id, "rejection_reason", None, reason, "human")
    con.commit()
    con.close()
    return True, f"{hyp_id} rejected"


# ══════════════════════════════════════════════════════════════════════════════
# LIVE STATS
# ══════════════════════════════════════════════════════════════════════════════

def compute_live_stats(hyp: dict, df: pd.DataFrame | None = None) -> dict:
    """Filter trades by hypothesis dimensions; return actual KPIs."""
    if df is None:
        con = sqlite3.connect(DB_PATH)
        df  = pd.read_sql_query("SELECT * FROM trades", con)
        con.close()
        if not df.empty:
            for col in ("open_time", "close_time"):
                df[col] = pd.to_datetime(df[col], errors="coerce")
            df["pnl_usd"] = pd.to_numeric(df["pnl_usd"], errors="coerce")

    if df is None or df.empty:
        return dict(actual_n=0, actual_wr=None, actual_pf=None, actual_exp=None, actual_net=None)

    mask = pd.Series([True] * len(df), index=df.index)
    if hyp.get("ea_name"):   mask &= df["strategy"]  == hyp["ea_name"]
    if hyp.get("symbol"):    mask &= df["symbol"]     == hyp["symbol"]
    if hyp.get("session"):   mask &= df["session"]    == hyp["session"]
    if hyp.get("regime"):    mask &= df["regime"]     == hyp["regime"]
    if hyp.get("direction"): mask &= df["direction"]  == hyp["direction"]

    sub = df[mask].copy()
    if sub.empty:
        return dict(actual_n=0, actual_wr=None, actual_pf=None, actual_exp=None, actual_net=None)

    wins   = sub[sub["outcome"] == "WIN"]["pnl_usd"]
    losses = sub[sub["outcome"] == "LOSS"]["pnl_usd"]
    n      = len(sub)
    wr     = len(wins) / n
    pf     = abs(wins.sum() / losses.sum()) if losses.sum() != 0 else None
    exp    = (wr * float(wins.mean()) if len(wins) else 0) + \
             ((1 - wr) * float(losses.mean()) if len(losses) else 0)

    return dict(
        actual_n   = n,
        actual_wr  = round(wr, 4),
        actual_pf  = round(min(pf, 99.0), 3) if pf else None,
        actual_exp = round(exp, 2),
        actual_net = round(float(sub["pnl_usd"].sum()), 2),
    )


def refresh_all_stats(df: pd.DataFrame | None = None) -> int:
    """Recompute live stats and confidence scores for all hypotheses."""
    hyps = get_hypotheses()
    if hyps.empty:
        return 0
    con = _con()
    updated = 0
    for _, row in hyps.iterrows():
        stats = compute_live_stats(row.to_dict(), df)
        conf  = compute_confidence_score({**row.to_dict(), **stats})
        con.execute("""
            UPDATE hypotheses SET
              actual_n=?, actual_wr=?, actual_pf=?,
              actual_exp=?, actual_net=?, stats_at=datetime('now'),
              confidence_score=?
            WHERE hyp_id=?
        """, (stats["actual_n"], stats["actual_wr"], stats["actual_pf"],
              stats["actual_exp"], stats["actual_net"], conf, row["hyp_id"]))
        updated += 1
    con.commit()
    con.close()
    return updated


# ══════════════════════════════════════════════════════════════════════════════
# SCORING
# ══════════════════════════════════════════════════════════════════════════════

def compute_confidence_score(hyp: dict) -> float:
    """0-100: sample(30) + WR vs target(25) + PF vs target(25) + depth(20)."""
    score = 0.0
    n     = int(hyp.get("actual_n") or 0)
    min_n = int(hyp.get("min_trades") or 30)

    score += min(n / max(min_n * 2, 1), 1.0) * 30

    wr, twr = hyp.get("actual_wr"), hyp.get("target_wr")
    if wr and twr:
        if   wr >= twr:        score += 25
        elif wr >= twr * 0.90: score += 15
        elif wr >= twr * 0.80: score += 8
    elif wr and wr > 0.50:     score += 10

    pf, tpf = hyp.get("actual_pf"), hyp.get("target_pf")
    if pf and tpf:
        if   pf >= tpf:        score += 25
        elif pf >= tpf * 0.90: score += 15
        elif pf >= tpf * 0.80: score += 8
    elif pf and pf > 1.2:      score += 10

    if   n >= min_n * 2: score += 20
    elif n >= min_n:      score += 12
    elif n >= min_n // 2: score += 5

    return round(min(score, 100.0), 1)


def compute_edge_score(edge: dict) -> float:
    """0-100: WR(35) + PF(25) + Expectancy(20) + Sample size(20)."""
    wr  = float(edge.get("current_wr")  or edge.get("validated_wr")  or 0)
    pf  = float(edge.get("current_pf")  or edge.get("validated_pf")  or 0)
    exp = float(edge.get("current_exp") or edge.get("validated_exp") or 0)
    n   = int(edge.get("current_n")     or edge.get("sample_n")      or 0)

    score = 0.0
    if   wr >= 0.70: score += 35
    elif wr >= 0.65: score += 28
    elif wr >= 0.60: score += 20
    elif wr >= 0.55: score += 12
    elif wr >= 0.50: score += 4

    if   pf >= 2.0: score += 25
    elif pf >= 1.8: score += 20
    elif pf >= 1.5: score += 15
    elif pf >= 1.3: score += 8
    elif pf >= 1.1: score += 3

    if   exp >= 20: score += 20
    elif exp >= 10: score += 15
    elif exp >=  5: score += 10
    elif exp >=  1: score += 5

    if   n >= 200: score += 20
    elif n >= 100: score += 15
    elif n >=  50: score += 10
    elif n >=  30: score += 5

    return round(min(score, 100.0), 1)


def _alert_level(wr_drift: float | None, pf_drift: float | None) -> str:
    if wr_drift is None:
        return "ok"
    if   wr_drift < -0.20 or (pf_drift is not None and pf_drift < -0.60):
        return "degrade"
    elif wr_drift < -0.10 or (pf_drift is not None and pf_drift < -0.35):
        return "warn"
    elif wr_drift < -0.05 or (pf_drift is not None and pf_drift < -0.20):
        return "watch"
    return "ok"


# ══════════════════════════════════════════════════════════════════════════════
# PROMOTE TO VALIDATED EDGE
# ══════════════════════════════════════════════════════════════════════════════

def promote_to_edge(
    hyp_id: str,
    confidence: int = 3,
    condition: str = "",
    notes: str = "",
    df: pd.DataFrame | None = None,
) -> tuple[bool, str, str]:
    """Promote an observing/testing hypothesis to a validated edge."""
    hyp = get_hypothesis(hyp_id)
    if not hyp:
        return False, "", f"Hypothesis {hyp_id} not found"
    if hyp["status"] not in ("testing", "observing"):
        return False, "", f"{hyp_id} must be testing or observing (is '{hyp['status']}')"

    stats   = compute_live_stats(hyp, df)
    edge_id = _next_id("validated_edges", "EDGE")
    today   = date.today().isoformat()

    if not condition:
        parts = [f"{lbl}={hyp[k]}" for k, lbl in [
            ("ea_name","EA"),("symbol","Symbol"),("session","Session"),
            ("regime","Regime"),("direction","Dir"),
        ] if hyp.get(k)]
        condition = " AND ".join(parts) if parts else "See description"

    edge_data = {
        "current_wr": stats["actual_wr"], "current_pf": stats["actual_pf"],
        "current_exp": stats["actual_exp"], "current_n": stats["actual_n"],
    }
    e_score = compute_edge_score(edge_data)

    con = _con()
    con.execute("""
        INSERT INTO validated_edges
          (edge_id, hyp_id, title, description, ea_name, symbol, session,
           regime, direction, condition, sample_n, validated_wr, validated_pf,
           validated_exp, current_n, current_wr, current_pf, current_exp,
           stats_at, confidence, is_active, validated_at, notes, edge_score)
        VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,datetime('now'),?,1,?,?,?)
    """, (
        edge_id, hyp_id, hyp["title"], hyp.get("description", ""),
        hyp.get("ea_name"), hyp.get("symbol"), hyp.get("session"),
        hyp.get("regime"), hyp.get("direction"), condition,
        stats["actual_n"], stats["actual_wr"], stats["actual_pf"], stats["actual_exp"],
        stats["actual_n"], stats["actual_wr"], stats["actual_pf"], stats["actual_exp"],
        confidence, today, notes, e_score,
    ))
    con.execute("""
        UPDATE hypotheses
        SET status='validated', validated_at=datetime('now'), updated_at=datetime('now')
        WHERE hyp_id=?
    """, (hyp_id,))
    _audit(con, hyp_id, "status", hyp["status"], "validated", "human")
    _audit(con, hyp_id, "promoted_to", None, edge_id, "human")
    con.commit()
    con.close()

    note_path = _write_edge_note(edge_id, hyp, stats, condition, confidence, notes, e_score)
    return True, edge_id, f"Promoted to {edge_id} (score={e_score}) → {note_path.name}"


# ══════════════════════════════════════════════════════════════════════════════
# VALIDATED EDGES CRUD
# ══════════════════════════════════════════════════════════════════════════════

def get_edges(active_only: bool = True) -> pd.DataFrame:
    run_migration()
    con = _con()
    sql = "SELECT * FROM validated_edges"
    if active_only:
        sql += " WHERE is_active=1"
    sql += " ORDER BY edge_score DESC, validated_at DESC"
    df = pd.read_sql_query(sql, con)
    con.close()
    return df


def refresh_edge_stats(df: pd.DataFrame | None = None) -> int:
    """Recompute current stats, drift, alert_level, and edge_score for all edges."""
    edges = get_edges(active_only=False)
    if edges.empty:
        return 0
    con = _con()
    updated = 0
    for _, edge in edges.iterrows():
        filt   = {k: edge.get(k) for k in ("ea_name","symbol","session","regime","direction")}
        stats  = compute_live_stats(filt, df)
        c_wr   = stats["actual_wr"]
        v_wr   = edge.get("validated_wr")
        c_pf   = stats["actual_pf"]
        v_pf   = edge.get("validated_pf")
        wr_drift = (c_wr - float(v_wr)) if (c_wr and v_wr) else None
        pf_drift = (c_pf - float(v_pf)) if (c_pf and v_pf) else None
        alert  = _alert_level(wr_drift, pf_drift)
        e_score = compute_edge_score({**edge.to_dict(),
                                      "current_wr": c_wr, "current_pf": c_pf,
                                      "current_exp": stats["actual_exp"],
                                      "current_n": stats["actual_n"]})
        con.execute("""
            UPDATE validated_edges SET
              current_n=?, current_wr=?, current_pf=?, current_exp=?,
              stats_at=datetime('now'), wr_drift=?, pf_drift=?,
              alert_level=?, edge_score=?
            WHERE edge_id=?
        """, (stats["actual_n"], c_wr, c_pf, stats["actual_exp"],
              wr_drift, pf_drift, alert, e_score, edge["edge_id"]))
        updated += 1
    con.commit()
    con.close()
    return updated


def deactivate_edge(edge_id: str, reason: str = "") -> tuple[bool, str]:
    con = _con()
    con.execute(
        "UPDATE validated_edges SET is_active=0, "
        "notes=COALESCE(notes||' | ','')|| ? WHERE edge_id=?",
        (f"Deactivated: {reason}", edge_id),
    )
    con.commit()
    con.close()
    return True, f"{edge_id} deactivated"


# ══════════════════════════════════════════════════════════════════════════════
# MARKDOWN NOTE WRITERS
# ══════════════════════════════════════════════════════════════════════════════

def _fm(fields: dict) -> str:
    lines = ["---"]
    for k, v in fields.items():
        if isinstance(v, list):
            lines.append(f"{k}:")
            for item in v:
                lines.append(f'  - "{item}"')
        elif v is None or v == "":
            lines.append(f"{k}: ~")
        elif isinstance(v, (int, float)):
            lines.append(f"{k}: {v}")
        else:
            lines.append(f'{k}: "{v}"')
    lines.append("---\n")
    return "\n".join(lines)


def _write_hypothesis_note(
    hyp_id, title, description, rationale,
    ea_name, symbol, session, regime, direction,
    target_wr, target_pf, target_exp, min_trades, priority, notes,
) -> Path:
    ensure_folders()
    slug = re.sub(r"[^a-zA-Z0-9_-]", "_", title)[:50]
    path = HYP_DIR / f"{hyp_id}_{slug}.md"
    tags = ["hypothesis", "research-idea"]
    if ea_name:  tags.append(f"ea/{ea_name.lower()}")
    if session:  tags.append(f"session/{session.lower()}")
    if regime:   tags.append(f"regime/{regime.lower()}")
    if symbol:   tags.append(f"symbol/{symbol.lower()}")

    content = _fm({
        "type": "hypothesis", "hyp_id": hyp_id, "status": "idea",
        "title": title, "priority": priority,
        "ea": ea_name or "", "symbol": symbol or "",
        "session": session or "", "regime": regime or "", "direction": direction or "",
        "target_wr": target_wr or "", "target_pf": target_pf or "",
        "target_exp": target_exp or "", "min_trades": min_trades,
        "created": date.today().isoformat(), "tags": tags,
    })
    content += f"# {hyp_id}: {title}\n\n"
    content += f"## Rationale\n{rationale or 'Why do you think this edge exists?'}\n\n"
    content += f"## Hypothesis\n{description or 'Describe the specific testable claim.'}\n\n"
    content += "## Filter Conditions\n"
    for k, v in [("EA", ea_name), ("Symbol", symbol), ("Session", session),
                 ("Regime", regime), ("Direction", direction)]:
        content += f"- **{k}**: {v or 'Any'}\n"
    content += "\n## Validation Targets\n"
    content += f"- Min trades needed: **{min_trades}**\n"
    content += f"- Target WR: {f'{target_wr:.1%}' if target_wr else 'not set'}\n"
    content += f"- Target PF: {f'{target_pf:.2f}' if target_pf else 'not set'}\n"
    content += f"- Target Expectancy: {f'${target_exp:,.2f}/trade' if target_exp else 'not set'}\n"
    content += "\n## Evidence\n_Recorded via dashboard. Do not edit manually._\n\n"
    content += "## Notes\n"
    content += f"{notes or 'Add research notes and sources here.'}\n\n"
    content += "## Safety Gate\n"
    content += "This hypothesis does NOT become a live trading rule until:\n"
    content += f"1. Sample N ≥ {min_trades} trades collected (auto-advances to Observing)\n"
    content += "2. Human reviews evidence and manually promotes to Validated Edge\n\n"
    path.write_text(content, encoding="utf-8")
    return path


def _write_edge_note(
    edge_id: str, hyp: dict, stats: dict,
    condition: str, confidence: int, notes: str, edge_score: float = 0.0,
) -> Path:
    ensure_folders()
    slug  = re.sub(r"[^a-zA-Z0-9_-]", "_", hyp.get("title", edge_id))[:50]
    path  = EDGE_DIR / f"{edge_id}_{slug}.md"
    today = date.today().isoformat()

    content = _fm({
        "type": "validated_edge", "edge_id": edge_id,
        "hyp_id": hyp.get("hyp_id", ""), "status": "validated",
        "title": hyp.get("title", ""),
        "ea": hyp.get("ea_name", ""), "symbol": hyp.get("symbol", ""),
        "session": hyp.get("session", ""), "regime": hyp.get("regime", ""),
        "direction": hyp.get("direction", ""), "condition": condition,
        "confidence": confidence, "edge_score": edge_score,
        "sample_n": stats.get("actual_n", 0),
        "validated_wr": stats.get("actual_wr", ""),
        "validated_pf": stats.get("actual_pf", ""),
        "validated_at": today,
        "tags": ["validated-edge", "trading-intelligence"],
    })
    wr  = stats.get("actual_wr")
    pf  = stats.get("actual_pf")
    exp = stats.get("actual_exp")
    content += f"# {edge_id}: {hyp.get('title', '')}\n\n"
    content += f"## Description\n{hyp.get('description', 'No description.')}\n\n"
    content += f"## Condition\n`{condition}`\n\n"
    content += "## Validated Evidence\n"
    content += f"- Sample N: **{stats.get('actual_n', 0)}** trades\n"
    content += (f"- Win Rate: **{wr:.1%}**\n" if wr else "- Win Rate: —\n")
    content += (f"- Profit Factor: **{pf:.2f}**\n" if pf else "- Profit Factor: —\n")
    content += (f"- Expectancy: **${exp:,.2f}**/trade\n" if exp else "- Expectancy: —\n")
    content += f"- Edge Score: **{edge_score}/100**\n"
    content += f"- Confidence: {'★' * confidence}{'☆' * (5 - confidence)}\n"
    content += f"- Validated: {today}\n\n"
    content += "## Ongoing Monitoring\n"
    content += "_Live stats and drift alerts updated by dashboard._\n\n"
    content += "## Rule Statement\n"
    content += f"{notes or 'Write the concrete trading rule this edge produces.'}\n\n"
    content += "## Safety Gate\n"
    content += "This edge is **informational only**. "
    content += "It does not authorize automatic trade execution.\n"
    path.write_text(content, encoding="utf-8")
    return path


# ══════════════════════════════════════════════════════════════════════════════
# SYNC TEST IDEAS → DB
# ══════════════════════════════════════════════════════════════════════════════

def _parse_frontmatter(text: str) -> dict:
    if not text.startswith("---"):
        return {}
    end = text.find("\n---", 3)
    if end == -1:
        return {}
    result: dict = {}
    for line in text[3:end].strip().splitlines():
        if ":" in line:
            k, _, v = line.partition(":")
            result[k.strip()] = v.strip().strip('"')
    return result


_STATUS_MAP = {
    "untested": "idea", "idea": "idea", "testing": "testing",
    "observing": "observing", "validated": "validated", "rejected": "rejected",
}


def sync_test_ideas_to_db() -> int:
    """Import 10_Test_Ideas/*.md into hypotheses table. Returns count of new rows."""
    run_migration()
    ensure_folders()
    test_dir = RESEARCH_DIR / "10_Test_Ideas"
    if not test_dir.exists():
        return 0

    con = _con()
    existing = {r[0] for r in con.execute(
        "SELECT source_note FROM hypotheses"
    ).fetchall()}
    inserted = 0

    for md in sorted(test_dir.glob("*.md")):
        if md.name.lower() == "readme.md":
            continue
        rel = str(md.relative_to(BASE_DIR))
        if rel in existing:
            continue

        text = md.read_text(encoding="utf-8", errors="ignore")
        fm   = _parse_frontmatter(text)
        if fm.get("type") not in ("research_idea", "test_idea", "hypothesis"):
            continue

        hyp_id  = _next_id("hypotheses", "HYP")
        title   = fm.get("title") or md.stem.replace("_", " ")
        status  = _STATUS_MAP.get(fm.get("idea_status") or fm.get("status") or "", "idea")
        ea_name = (fm.get("strategies") or "").split(",")[0].strip() or None
        symbol  = (fm.get("symbols")    or "").split(",")[0].strip() or None
        session = (fm.get("sessions")   or "").split(",")[0].strip() or None
        regime  = (fm.get("regimes")    or "").split(",")[0].strip() or None

        con.execute("""
            INSERT OR IGNORE INTO hypotheses
              (hyp_id, title, status, ea_name, symbol, session, regime,
               source_note, created_at)
            VALUES (?,?,?,?,?,?,?,?,datetime('now'))
        """, (hyp_id, title, status, ea_name, symbol, session, regime, rel))
        inserted += 1

    con.commit()
    con.close()
    return inserted
