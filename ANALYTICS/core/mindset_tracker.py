"""
mindset_tracker.py — Mindset & Principles Learning System for QTrade OS.

Stores and manages:
  - Trading principles, risk philosophy, quantitative mindset frameworks
  - Research methodology and validation standards
  - Engineering process discipline and decision frameworks
  - Behavioral lessons and anti-patterns (danger flags)

Each principle has 8 structured fields + danger flags + quality/confidence scoring.
Writes Obsidian notes to the knowledge vault.
"""

from __future__ import annotations

import json
import re
import sqlite3
from datetime import datetime
from pathlib import Path
from typing import Any

import pandas as pd

# ── Paths ──────────────────────────────────────────────────────────────────────
_BASE   = Path(__file__).resolve().parents[2]
DB_PATH = _BASE / "DATA" / "processed" / "trades.sqlite"

# ── Constants ──────────────────────────────────────────────────────────────────

MINDSET_TYPES: dict[str, str] = {
    "trading_principle":    "📈 Trading Principle",
    "risk_philosophy":      "🛡 Risk Philosophy",
    "quantitative_mindset": "🔢 Quantitative Mindset",
    "research_methodology": "🔍 Research Methodology",
    "validation_standard":  "✅ Validation Standard",
    "engineering_process":  "⚙️ Engineering Process",
    "decision_framework":   "🧭 Decision Framework",
    "behavioral_lesson":    "🧠 Behavioral Lesson",
}

MINDSET_COLORS: dict[str, str] = {
    "trading_principle":    "#26a69a",
    "risk_philosophy":      "#ef5350",
    "quantitative_mindset": "#5c6bc0",
    "research_methodology": "#ffd600",
    "validation_standard":  "#29b6f6",
    "engineering_process":  "#8d6e63",
    "decision_framework":   "#ab47bc",
    "behavioral_lesson":    "#fb8c00",
}

# Mindset type → Obsidian category mapping
MINDSET_TO_CATEGORY: dict[str, str] = {
    "trading_principle":    "Trading_Principles",
    "risk_philosophy":      "Risk_Frameworks",
    "quantitative_mindset": "Mental_Models",
    "research_methodology": "Research_Standards",
    "validation_standard":  "Research_Standards",
    "engineering_process":  "Engineering_Principles",
    "decision_framework":   "Mental_Models",
    "behavioral_lesson":    "Trading_Principles",
}

OBSIDIAN_CATEGORIES = [
    "Mental_Models",
    "Trading_Principles",
    "Research_Standards",
    "Risk_Frameworks",
    "Engineering_Principles",
    "AI_Workflow_Principles",
]

DANGER_FLAGS: dict[str, str] = {
    "martingale_addiction": "🎲 Martingale Addiction",
    "overfitting":          "📈 Overfitting",
    "optimization_bias":    "🎯 Optimization Bias",
    "revenge_trading":      "😠 Revenge Trading",
    "overconfidence":       "💪 Overconfidence",
    "sunk_cost":            "⚓ Sunk Cost Fallacy",
    "recency_bias":         "📅 Recency Bias",
    "survivorship_bias":    "🪦 Survivorship Bias",
}

DANGER_KEYWORDS: dict[str, list[str]] = {
    "martingale_addiction": [
        "martingale", "double after loss", "doubling lot", "2x after loss",
        "recover by increasing", "lot multiplier after loss",
    ],
    "overfitting": [
        "overfit", "curve fit", "parameter tuning", "optimize on backtest",
        "in-sample only", "n-fit", "data mining", "perfect backtest",
    ],
    "optimization_bias": [
        "best parameters", "optimal setting", "maximize profit factor",
        "parameter sweep", "grid search backtest", "cherry pick",
    ],
    "revenge_trading": [
        "revenge", "recover the loss", "make it back", "emotional trade",
        "after losing", "must recover", "double down after loss",
    ],
    "overconfidence": [
        "guaranteed", "always works", "never fails", "100% win", "perfect strategy",
        "foolproof", "can't lose", "sure thing",
    ],
    "sunk_cost": [
        "already invested", "can't give up now", "too far in", "keep going because",
        "can't stop now", "sunk cost",
    ],
    "recency_bias": [
        "last month was great", "recently profitable", "just started working",
        "works now", "current market", "this month only", "recent performance",
    ],
    "survivorship_bias": [
        "successful traders", "winning strategies only", "profitable examples",
        "proven strategies", "only show winners",
    ],
}

STATUS_COLORS = {
    "active":   "#26a69a",
    "draft":    "#ffd600",
    "archived": "#546e7a",
}

# ── DB helpers ─────────────────────────────────────────────────────────────────

def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    con.execute("PRAGMA journal_mode=WAL")
    return con


def _split_sql(sql: str) -> list[str]:
    # Strip line comments then split on semicolons — safe for DDL without triggers
    clean = re.sub(r"--[^\n]*", "", sql)
    return [s.strip() for s in clean.split(";") if s.strip()]


def run_migration() -> None:
    """Apply migration 009 (mindset_principles table)."""
    mig = _BASE / "DATA" / "migrations" / "009_mindset.sql"
    if not mig.exists():
        return
    con = _con()
    tables = {r[0] for r in con.execute(
        "SELECT name FROM sqlite_master WHERE type='table'"
    ).fetchall()}
    if "mindset_principles" not in tables:
        for stmt in _split_sql(mig.read_text(encoding="utf-8")):
            try:
                con.execute(stmt)
                con.commit()
            except sqlite3.Error:
                pass
        seed_principles(con)
    con.close()


# ── ID generator ───────────────────────────────────────────────────────────────

def _next_id(con: sqlite3.Connection) -> str:
    n = con.execute("SELECT COUNT(*) FROM mindset_principles").fetchone()[0]
    return f"MP-{n + 1:03d}"


# ── Quality & Confidence scoring ───────────────────────────────────────────────

def compute_quality_score(p: dict) -> float:
    """0-100: based on how many of the 8 structured fields are populated."""
    fields = [
        "concept", "why_it_matters", "failure_cases", "practical_applications",
        "related_strategies", "related_risk_rules", "related_sessions",
        "implementation_checklist",
    ]
    filled = sum(1 for f in fields if p.get(f) and p[f] not in ("[]", ""))
    base = (filled / len(fields)) * 70

    # Bonus: reviewed, applied, has source
    bonus = 0
    if p.get("review_count", 0) > 0:
        bonus += 10
    if p.get("applied_count", 0) > 0:
        bonus += 10
    if p.get("source_ref"):
        bonus += 10
    return min(base + bonus, 100)


def compute_confidence_score(p: dict) -> float:
    """0-100: trust level — increases with real-world application and review."""
    base = 40.0
    reviews   = min(int(p.get("review_count",   0)), 5) * 6    # +30 max
    applied   = min(int(p.get("applied_count",  0)), 5) * 4    # +20 max
    violations = min(int(p.get("violation_count",0)), 3) * -5  # -15 max (danger)
    src_type   = p.get("source_type", "manual")
    src_bonus  = {"seed": 10, "research": 8, "arena": 5, "manual": 0}.get(src_type, 0)
    return min(max(base + reviews + applied + violations + src_bonus, 0), 100)


# ── Danger detection ───────────────────────────────────────────────────────────

def detect_danger_flags(text: str) -> list[str]:
    """Scan free text and return matching danger flag keys."""
    text_lc  = text.lower()
    detected = []
    for flag, keywords in DANGER_KEYWORDS.items():
        if any(kw in text_lc for kw in keywords):
            detected.append(flag)
    return detected


def get_danger_summary() -> dict[str, Any]:
    """Return count of principles with each danger flag."""
    try:
        con = _con()
        rows = con.execute(
            "SELECT danger_flags FROM mindset_principles WHERE status='active'"
        ).fetchall()
        con.close()
        counts: dict[str, int] = {k: 0 for k in DANGER_FLAGS}
        for row in rows:
            flags = json.loads(row["danger_flags"] or "[]")
            for f in flags:
                if f in counts:
                    counts[f] += 1
        return counts
    except Exception:
        return {}


# ── CRUD ───────────────────────────────────────────────────────────────────────

def create_principle(
    title:                   str,
    mindset_type:            str,
    concept:                 str  = "",
    why_it_matters:          str  = "",
    failure_cases:           list | None = None,
    practical_applications:  list | None = None,
    related_strategies:      list | None = None,
    related_risk_rules:      list | None = None,
    related_sessions:        list | None = None,
    implementation_checklist: list | None = None,
    danger_flags:            list | None = None,
    quality_score:           float = 0.0,
    source_ref:              str  = "",
    source_type:             str  = "manual",
    tags:                    str  = "",
    status:                  str  = "active",
) -> tuple[bool, str, str]:
    if mindset_type not in MINDSET_TYPES:
        return False, "", f"Invalid mindset_type: {mindset_type}"

    def _j(v):
        return json.dumps(v or [], ensure_ascii=False)

    category = MINDSET_TO_CATEGORY.get(mindset_type, "Mental_Models")

    p = {
        "concept":                  concept,
        "why_it_matters":           why_it_matters,
        "failure_cases":            _j(failure_cases),
        "practical_applications":   _j(practical_applications),
        "related_strategies":       _j(related_strategies),
        "related_risk_rules":       _j(related_risk_rules),
        "related_sessions":         _j(related_sessions),
        "implementation_checklist": _j(implementation_checklist),
        "danger_flags":             _j(danger_flags),
        "quality_score":            quality_score,
        "source_ref":               source_ref,
        "source_type":              source_type,
    }
    conf = compute_confidence_score({**p, "review_count": 0, "applied_count": 0})

    con = _con()
    pid = _next_id(con)
    try:
        con.execute(
            """INSERT INTO mindset_principles
               (principle_id, title, mindset_type, category,
                concept, why_it_matters, failure_cases, practical_applications,
                related_strategies, related_risk_rules, related_sessions,
                implementation_checklist, danger_flags,
                quality_score, confidence_score,
                source_ref, source_type, tags, status)
               VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
            (pid, title, mindset_type, category,
             concept, why_it_matters, p["failure_cases"], p["practical_applications"],
             p["related_strategies"], p["related_risk_rules"], p["related_sessions"],
             p["implementation_checklist"], p["danger_flags"],
             quality_score, conf,
             source_ref, source_type, tags, status)
        )
        con.commit()
        return True, pid, f"Created {pid}: {title[:50]}"
    except sqlite3.Error as e:
        return False, "", str(e)
    finally:
        con.close()


def update_principle(pid: str, fields: dict) -> tuple[bool, str]:
    if not fields:
        return False, "No fields to update"
    allowed = {
        "title", "mindset_type", "concept", "why_it_matters", "failure_cases",
        "practical_applications", "related_strategies", "related_risk_rules",
        "related_sessions", "implementation_checklist", "danger_flags",
        "quality_score", "source_ref", "tags", "status",
    }
    safe = {k: v for k, v in fields.items() if k in allowed}
    if not safe:
        return False, "No valid fields"
    if "mindset_type" in safe and safe["mindset_type"] in MINDSET_TO_CATEGORY:
        safe["category"] = MINDSET_TO_CATEGORY[safe["mindset_type"]]

    sets  = ", ".join(f"{k}=?" for k in safe)
    vals  = list(safe.values()) + [pid]
    try:
        con = _con()
        con.execute(f"UPDATE mindset_principles SET {sets} WHERE principle_id=?", vals)
        con.commit()
        con.close()
        return True, f"Updated {pid}"
    except sqlite3.Error as e:
        return False, str(e)


def record_session(
    principle_id: str,
    session_type: str  = "review",
    notes:        str  = "",
    trade_context: str = "",
) -> bool:
    """Log a review / apply / violation event and update counters."""
    try:
        con = _con()
        con.execute(
            """INSERT INTO mindset_sessions (principle_id, session_type, notes, trade_context)
               VALUES (?,?,?,?)""",
            (principle_id, session_type, notes, trade_context),
        )
        if session_type == "apply":
            con.execute(
                "UPDATE mindset_principles SET applied_count=applied_count+1, last_reviewed=datetime('now') WHERE principle_id=?",
                (principle_id,),
            )
        elif session_type == "violation":
            con.execute(
                "UPDATE mindset_principles SET violation_count=violation_count+1, last_reviewed=datetime('now') WHERE principle_id=?",
                (principle_id,),
            )
        elif session_type == "review":
            con.execute(
                "UPDATE mindset_principles SET review_count=review_count+1, last_reviewed=datetime('now') WHERE principle_id=?",
                (principle_id,),
            )
        # Recompute confidence
        row = con.execute(
            "SELECT * FROM mindset_principles WHERE principle_id=?", (principle_id,)
        ).fetchone()
        if row:
            conf = compute_confidence_score(dict(row))
            con.execute(
                "UPDATE mindset_principles SET confidence_score=? WHERE principle_id=?",
                (conf, principle_id),
            )
        con.commit()
        con.close()
        return True
    except Exception:
        return False


def get_principles(
    mindset_type: str | None = None,
    category:     str | None = None,
    status:       str | None = None,
    danger_flag:  str | None = None,
) -> pd.DataFrame:
    run_migration()
    con  = _con()
    sql  = "SELECT * FROM mindset_principles"
    wh, params = [], []
    if mindset_type:
        wh.append("mindset_type=?"); params.append(mindset_type)
    if category:
        wh.append("category=?"); params.append(category)
    if status:
        wh.append("status=?"); params.append(status)
    if wh:
        sql += " WHERE " + " AND ".join(wh)
    sql += " ORDER BY quality_score DESC, created_at DESC"
    rows = con.execute(sql, params).fetchall()
    con.close()
    df = pd.DataFrame([dict(r) for r in rows]) if rows else pd.DataFrame()
    if not df.empty and danger_flag:
        df = df[df["danger_flags"].apply(
            lambda x: danger_flag in json.loads(x or "[]")
        )]
    return df


def get_principle(pid: str) -> dict | None:
    run_migration()
    con = _con()
    row = con.execute(
        "SELECT * FROM mindset_principles WHERE principle_id=?", (pid,)
    ).fetchone()
    con.close()
    return dict(row) if row else None


def get_sessions(pid: str) -> pd.DataFrame:
    con = _con()
    rows = con.execute(
        "SELECT * FROM mindset_sessions WHERE principle_id=? ORDER BY created_at DESC",
        (pid,),
    ).fetchall()
    con.close()
    return pd.DataFrame([dict(r) for r in rows]) if rows else pd.DataFrame()


# ── Obsidian note writer ───────────────────────────────────────────────────────

def _j_load(v: str | None) -> list:
    if not v:
        return []
    try:
        return json.loads(v)
    except Exception:
        return []


def write_principle_note(pid: str) -> str | None:
    """Write structured Obsidian note to the vault. Returns path or None."""
    p = get_principle(pid)
    if not p:
        return None

    category = p.get("category", "Mental_Models")
    folder   = _BASE / category
    folder.mkdir(exist_ok=True)

    date_str = datetime.now().strftime("%Y-%m-%d")
    safe     = re.sub(r"[^\w\s-]", "", p["title"])[:50].strip().replace(" ", "_")
    fname    = f"{date_str}_{safe}.md"
    path     = folder / fname

    failures = _j_load(p.get("failure_cases"))
    apps     = _j_load(p.get("practical_applications"))
    strats   = _j_load(p.get("related_strategies"))
    rules    = _j_load(p.get("related_risk_rules"))
    sessions = _j_load(p.get("related_sessions"))
    checklist = _j_load(p.get("implementation_checklist"))
    flags    = _j_load(p.get("danger_flags"))
    mtype    = p.get("mindset_type", "")
    tags_raw = p.get("tags", "") or ""
    tags     = [t.strip() for t in tags_raw.split(",") if t.strip()]
    all_tags = list({mtype.replace("_", "-"), category.replace("_", "-").lower(),
                     "principle", "mindset"} | set(tags))

    def _bullets(items, prefix="- "):
        return "\n".join(f"{prefix}{item}" for item in items) if items else "_None documented yet._"

    def _checklist(items):
        return "\n".join(f"- [ ] {item}" for item in items) if items else "_No checklist items yet._"

    danger_block = ""
    if flags:
        flag_labels = [DANGER_FLAGS.get(f, f) for f in flags]
        danger_block = f"\n> ⚠️ **Danger flags:** {', '.join(flag_labels)}\n"

    content = f"""---
tags: [{', '.join(all_tags)}]
mindset_type: {mtype}
category: {category}
quality_score: {p.get('quality_score', 0):.0f}
confidence_score: {p.get('confidence_score', 0):.0f}
source: "{p.get('source_ref', '')}"
source_type: {p.get('source_type', 'manual')}
created: {date_str}
principle_id: {pid}
---

# {p['title']}
{danger_block}
## Concept

{p.get('concept', '_Not documented._')}

## Why It Matters

{p.get('why_it_matters', '_Not documented._')}

## Failure Cases

{_bullets(failures)}

## Practical Applications

{_bullets(apps)}

## Related Strategies

{_bullets(strats)}

## Related Risk Rules

{_bullets(rules)}

## Related Sessions / Regimes

{_bullets(sessions)}

## Implementation Checklist

{_checklist(checklist)}

---

*Quality: {p.get('quality_score', 0):.0f}/100 · Confidence: {p.get('confidence_score', 0):.0f}/100 · Applied: {p.get('applied_count', 0)}×*
*Source: {p.get('source_ref', 'manual')} · Generated by QTrade OS Mindset System*
"""

    if path.exists():
        path.write_text(content, encoding="utf-8")
    else:
        path.write_text(content, encoding="utf-8")

    # Write path back to DB
    con = _con()
    rel = str(path.relative_to(_BASE)).replace("\\", "/")
    con.execute(
        "UPDATE mindset_principles SET note_path=? WHERE principle_id=?",
        (rel, pid),
    )
    con.commit()
    con.close()
    return str(path)


# ── Seed data ──────────────────────────────────────────────────────────────────

_SEEDS: list[dict] = [
    # ── Trading Principles ──────────────────────────────────────────────────
    dict(
        title="Regime-First: Identify SC₁₀₀ State Before Any Entry",
        mindset_type="trading_principle",
        concept="Always check SC₁₀₀ before placing a trade. The regime determines which strategy family is valid. SC₁₀₀ < 0.25 = TRENDING (momentum), > 0.35 = REVERTING (RSI+SMA), 0.22+spike = CRASH. Trading in the wrong regime is the largest source of random losses.",
        why_it_matters="SC₁₀₀ has r = -0.95 correlation with β₁. Strategies profitable in TRENDING regimes become loss-generating in REVERTING regimes. Ignoring regime is like driving without a map.",
        failure_cases=["Using RSI reversals during TRENDING regime (SC₁₀₀ < 0.25)", "Running momentum EAs in REVERTING market (SC₁₀₀ > 0.35)", "One universal signal used regardless of regime"],
        practical_applications=["Check SC₁₀₀ at session open before any trade", "Block wrong-regime EAs in config", "Tag every trade with regime in QTrade OS"],
        related_strategies=["QField_EA", "SMC_Universal_EA", "QuantumQueen"],
        related_risk_rules=["Stop EA with >5 consecutive losses in same regime"],
        related_sessions=["All sessions — check regime first"],
        implementation_checklist=["SC₁₀₀ computed on last 100 M1 bars", "Regime label visible in dashboard", "Trade tagged with regime"],
        danger_flags=[],
        quality_score=95.0, source_ref="02_Regime_Detection.md", source_type="seed",
    ),
    dict(
        title="Martingale is Risk of Ruin, Not a Strategy",
        mindset_type="trading_principle",
        concept="Martingale (doubling lot size after losses) guarantees account blow-up given sufficient time. Expected value approaches -∞ as session length increases. It is a financing mechanism, not a trading edge.",
        why_it_matters="Martingale produces spectacular short-term results that create powerful cognitive reinforcement. The longer it works, the larger the eventual blow-up. Risk of ruin = 1.0 over infinite trials.",
        failure_cases=["HFT_EA: Martingale ×5 — survived 6 months, then -80% in one session", "Better_VIII: ×1.5 multiplier — 'safe' but still infinite ruin probability", "Recovering losses by doubling position without changing edge"],
        practical_applications=["Never use martingale on live FTMO accounts", "In grid EAs: use fixed spacing not size escalation", "Recovering losses: time and patience, not size"],
        related_strategies=["HFT_EA (avoid)", "HedgeGrid_V23 (fixed grid — not martingale)"],
        related_risk_rules=["Max lot = 2× initial regardless of drawdown", "Hard lot cap in all EA parameters"],
        related_sessions=["All — applies universally"],
        implementation_checklist=["All EA lot-sizing code reviewed for martingale logic", "Escalation factor cap defined", "FTMO: martingale hard-disabled"],
        danger_flags=["martingale_addiction"],
        quality_score=99.0, source_ref="04_Risk_Management.md", source_type="seed",
    ),
    dict(
        title="Session Edge: Not All Hours Are Equal",
        mindset_type="trading_principle",
        concept="XAUUSD volatility and edge quality vary dramatically by session. London open (14:00-15:00 TH) and NY open (20:30-21:00) consistently show higher edge. Trade only during sessions where your specific strategy has demonstrated edge.",
        why_it_matters="A strategy with 60% WR in London may have 45% WR in Asian session. Running EAs outside validated session windows dilutes edge and inflates drawdown without proportional return.",
        failure_cases=["Running QField_EA 24/7 without session filter", "Treating all trading hours as equal", "Adding Asian session trades 'to make up for quiet day'"],
        practical_applications=["Filter every EA by validated session in config", "QTrade OS session analysis: check WR by session monthly", "NinjaThai entries: 14:00-15:00 and 20:30-21:00 only"],
        related_strategies=["QField_EA", "QuantumQueen", "NinjaThai SMC"],
        related_risk_rules=["EA blocked outside validated session window"],
        related_sessions=["London (14:00-15:00 TH)", "NY open (20:30-21:00 TH)"],
        implementation_checklist=["Session filter in EA code", "QTrade OS session stats reviewed monthly", "Session tag on all trades"],
        danger_flags=[],
        quality_score=94.0, source_ref="03_Signal_Logic.md", source_type="seed",
    ),
    # ── Risk Philosophy ─────────────────────────────────────────────────────
    dict(
        title="Kelly Fraction: Never Exceed 25% of Theoretical Kelly",
        mindset_type="risk_philosophy",
        concept="Kelly criterion gives the theoretically optimal bet size. Always use fractional Kelly (≤25%) because Kelly assumes perfect edge estimation which we never have. Full Kelly volatility is unacceptably high.",
        why_it_matters="At 50% Kelly, drawdown is half but long-run growth is 75% of full Kelly — far better risk-adjusted. Full Kelly produces catastrophic drawdowns in the short run even with positive edge.",
        failure_cases=["Using full Kelly directly without edge variance adjustment", "Recalculating Kelly after a win streak and scaling up aggressively", "Ignoring Kelly entirely and using fixed 1% regardless of edge quality"],
        practical_applications=["Compute Kelly = WR - (1-WR)/RR from last 30 trades", "Position size = 0.25 × Kelly × account_balance", "Recalculate monthly, not daily"],
        related_strategies=["QField_EA", "QuantumQueen"],
        related_risk_rules=["Daily loss limit = 2%", "Max single trade risk = 0.5%", "Kelly cap = 25%"],
        related_sessions=["All sessions"],
        implementation_checklist=["Kelly formula in risk engine", "Capped at 25%", "Reviewed monthly after stats update"],
        danger_flags=[],
        quality_score=92.0, source_ref="04_Risk_Management.md", source_type="seed",
    ),
    dict(
        title="Correlation Kills Diversification: Check Before Adding Any EA",
        mindset_type="risk_philosophy",
        concept="Two EAs trading XAUUSD during London open with momentum signals are NOT diversified — they will both lose simultaneously. True portfolio diversification requires low equity-curve correlation.",
        why_it_matters="Portfolio-level drawdown can be 2-3× any single-EA drawdown if EAs are correlated. The Correlation page (page 10) exists for this reason: run it before deploying any new EA.",
        failure_cases=["Running QField + QuantumQueen + NinjaThai all on XAUUSD without checking correlation", "Adding a 'hedge' EA with r > 0.7 vs main EA", "Treating different timeframes as diversification when they trade the same signal"],
        practical_applications=["Check QTrade OS Correlation page before every deployment", "Target: no pair above r = 0.6", "Diversify by: symbol, session, regime, strategy type"],
        related_strategies=["QField_EA", "QuantumQueen", "HedgeGrid_V23", "MMF_MakeMoneyFarmed"],
        related_risk_rules=["Max portfolio correlation: r ≤ 0.6 between any two EAs"],
        related_sessions=["All"],
        implementation_checklist=["Correlation check run before deployment", "Correlation matrix updated monthly", "Alert if correlation > 0.6"],
        danger_flags=[],
        quality_score=92.0, source_ref="04_Risk_Management.md", source_type="seed",
    ),
    # ── Quantitative Mindset ────────────────────────────────────────────────
    dict(
        title="N ≥ 30: Declare No Results Before Statistical Minimum",
        mindset_type="quantitative_mindset",
        concept="A win rate computed on fewer than 30 trades is noise. At N=10, a 60% WR could easily be 45%-75% at 95% confidence. Declare no edge, make no strategy decisions, and promote nothing until N ≥ 30. Prefer N ≥ 100 for edge promotion.",
        why_it_matters="Small sample confidence intervals are enormous. The most dangerous decision is promoting a strategy based on 10-15 trades — variance will destroy the account before the edge can manifest.",
        failure_cases=["Promoting a new EA after 15 backtested trades", "Declaring 'the market changed' after 5 losses", "Adjusting parameters after every 3-5 trades"],
        practical_applications=["Set min_trades=30 as default in all hypothesis tracking", "Display N prominently in all strategy dashboards", "Refuse to compute confidence score until N ≥ 30"],
        related_strategies=["All — universal principle"],
        related_risk_rules=["Hypothesis min_trades threshold enforced in hypothesis_tracker.py"],
        related_sessions=["All"],
        implementation_checklist=["min_trades field in every hypothesis", "N displayed in QTrade dashboard", "Warning shown when N < 30 in any analysis"],
        danger_flags=["overfitting"],
        quality_score=98.0, source_ref="05_Code_Patterns.md", source_type="seed",
    ),
    dict(
        title="Profit Factor Over Win Rate: The Complete Statistical Picture",
        mindset_type="quantitative_mindset",
        concept="Win rate alone is meaningless without RR. A strategy with 40% WR and 3:1 RR has PF = 2.0 — better than 65% WR with 0.8:1 RR (PF = 1.49). Always evaluate on Profit Factor and Expectancy per trade.",
        why_it_matters="Win rate is psychologically satisfying but statistically incomplete. Many traders optimize for WR and end up with a profitable-looking but net-losing system: small wins, large losses.",
        failure_cases=["Comparing two strategies only by win rate", "Moving SL to break-even too early to protect the WR metric", "Adding filters that improve WR but collapse RR"],
        practical_applications=["Report PF + Expectancy on every strategy card", "Set minimum PF target in hypothesis creation (default 1.5)", "Monthly review: WR + PF + Expectancy together"],
        related_strategies=["All"],
        related_risk_rules=["Minimum PF ≥ 1.3 for any strategy to remain active"],
        related_sessions=["All"],
        implementation_checklist=["PF displayed in QTrade OS dashboard", "PF target in all hypothesis records", "PF alert if drops below 1.3 on live edge"],
        danger_flags=[],
        quality_score=95.0, source_ref="01_AI_Agent_Design.md", source_type="seed",
    ),
    dict(
        title="Survivorship Bias: Study the Graveyard, Not Just the Winners",
        mindset_type="quantitative_mindset",
        concept="When evaluating any strategy, always ask: 'What strategies with similar logic failed and why?' The strategies you encounter are survivors. For every QField that works, there are 10 similar regime-adaptive strategies that failed.",
        why_it_matters="Survivorship bias causes systematic overestimation of strategy success rates. If you only study winning strategies, you inherit their parameters without understanding why similar approaches failed.",
        failure_cases=["Buying a course because the instructor's 3 strategies are profitable", "Optimizing only on bull-market data", "Selecting parameters from a backtest without asking why others failed"],
        practical_applications=["Document failed hypotheses in QTrade OS (rejected status)", "Before adopting any strategy: search for counter-examples", "Track rejection rate: healthy pipeline rejects 60-70% of ideas"],
        related_strategies=["All research pipeline"],
        related_risk_rules=["Rejection tracking in hypothesis_tracker"],
        related_sessions=["All"],
        implementation_checklist=["Rejected hypotheses documented with reason", "Success rate of hypothesis pipeline tracked", "Counter-examples sought before any promotion"],
        danger_flags=["survivorship_bias"],
        quality_score=91.0, source_ref="Fooled by Randomness — Taleb", source_type="seed",
    ),
    dict(
        title="Occam's Razor: Simpler Models Generalize Better",
        mindset_type="quantitative_mindset",
        concept="Given two strategies with equal backtest performance, prefer the simpler one. More parameters = more degrees of freedom = more overfitting risk. QField uses 3 signals (SC₁₀₀ + RSI + SMA) and achieves 72.5% WR.",
        why_it_matters="Complex systems are harder to understand, debug, and generalize. Complexity must be justified by out-of-sample improvement, not in-sample improvement.",
        failure_cases=["Adding a 5th indicator to an already-profitable strategy", "Multi-timeframe systems with 20+ parameters", "Dashboard with 15 metrics when 3 would suffice"],
        practical_applications=["Before adding any indicator: 'what specific failure mode does this fix?'", "Maximum 5 parameters per strategy", "QField as 3-signal standard to benchmark against"],
        related_strategies=["QField_EA (reference model)"],
        related_risk_rules=["Strategy complexity audit before deployment"],
        related_sessions=["All"],
        implementation_checklist=["Parameter count ≤ 5 per EA", "Each indicator has testable rationale", "Complexity justified by out-of-sample improvement"],
        danger_flags=["overfitting", "optimization_bias"],
        quality_score=90.0, source_ref="01_AI_Agent_Design.md", source_type="seed",
    ),
    # ── Research Methodology ────────────────────────────────────────────────
    dict(
        title="Hypothesis-First: Write the Null Hypothesis Before Testing",
        mindset_type="research_methodology",
        concept="Before any backtest or analysis, write: 'I believe X because Y. The null hypothesis is that X produces no edge over baseline.' This forces clarity and prevents post-hoc rationalization of random results.",
        why_it_matters="Without a pre-specified hypothesis, data mining produces false discoveries. The human brain finds patterns in random data. Pre-registration prevents the 'I knew it would work' illusion.",
        failure_cases=["Running 100 parameter combinations then calling the best a 'strategy'", "Looking at equity curves and constructing a story about why they worked", "Changing success criteria after seeing partial results"],
        practical_applications=["Use hypothesis_tracker.py create_hypothesis() before any testing", "Write null hypothesis in the description field", "Lock in target_wr and target_pf before observing data"],
        related_strategies=["All hypothesis pipeline"],
        related_risk_rules=["Never promote without N ≥ 30 and confidence_score ≥ 60"],
        related_sessions=["All"],
        implementation_checklist=["Hypothesis created before looking at results", "Null hypothesis explicitly stated", "Success criteria locked before testing"],
        danger_flags=["overfitting", "optimization_bias"],
        quality_score=96.0, source_ref="Research methodology best practices", source_type="seed",
    ),
    dict(
        title="Source Quality Determines Output Quality",
        mindset_type="research_methodology",
        concept="Not all research sources have equal validity. Priority order: peer-reviewed journals > audited fund reports > experienced practitioner accounts > course materials > YouTube > social media. Always ask: 'What is this person's incentive?'",
        why_it_matters="Garbage in, garbage out. A strategy adopted from YouTube without validation contaminates the knowledge vault with unvalidated claims that waste testing capital and time.",
        failure_cases=["Implementing any strategy from YouTube without validation", "Trusting backtests provided by the strategy seller", "Adopting risk management rules from anonymous forum posts"],
        practical_applications=["Score source quality 1-5 in Research Inbox", "Higher source quality = higher initial confidence score", "Search for counter-evidence before testing any claim"],
        related_strategies=["Research pipeline in QTrade OS"],
        related_risk_rules=["Only test with minimum lot size for first 30 trades"],
        related_sessions=["All"],
        implementation_checklist=["Source quality scored in Research Inbox", "Counter-evidence searched", "Testing starts with minimum size only"],
        danger_flags=["survivorship_bias"],
        quality_score=87.0, source_ref="Research methodology best practices", source_type="seed",
    ),
    dict(
        title="Separate Research from Trading: Different Time, Different Mindset",
        mindset_type="research_methodology",
        concept="Research and trading are cognitively incompatible activities. Research requires patience and skepticism. Trading requires decisive execution. Never conduct research during active trading sessions.",
        why_it_matters="Mixing research and trading corrupts both. During research you're tempted to trade ideas before validation. During trading, research distracts from execution discipline.",
        failure_cases=["Reading trading articles between trades and 'trying it'", "Adjusting EA parameters during a live session based on live P&L", "Watching the market while running research analysis"],
        practical_applications=["Research sessions: fixed time, no trading platform open", "Trading sessions: no research, no parameter changes", "Dual calendar: research days vs trading days"],
        related_strategies=["All"],
        related_risk_rules=["No EA parameter changes during live trading sessions"],
        related_sessions=["Separate from trading sessions"],
        implementation_checklist=["Research schedule defined", "Trading schedule defined", "No overlap between the two"],
        danger_flags=["revenge_trading"],
        quality_score=85.0, source_ref="Professional trading practice", source_type="seed",
    ),
    # ── Validation Standards ────────────────────────────────────────────────
    dict(
        title="Backtest ≠ Forward Test: Mandatory Walk-Forward Validation",
        mindset_type="validation_standard",
        concept="Every strategy that passes backtest must go through forward testing before live deployment. Backtest results confirm the hypothesis — forward test results are the actual edge.",
        why_it_matters="Backtest overfitting is the #1 cause of live trading failure. A strategy can have 80% WR in backtest and 45% WR live due to: lookahead bias, spread not modeled, curve fitting, market regime shift.",
        failure_cases=["Deploying a strategy with only MT5 backtests", "Calling 6 months of paper trading 'forward test' if used for optimization", "Adjusting SL parameters based on backtest results"],
        practical_applications=["Minimum 30 live trades before any conclusion", "Track forward test in QTrade OS with 'observing' status", "Compare backtest WR vs forward WR — gap > 15% is a red flag"],
        related_strategies=["All"],
        related_risk_rules=["Hypothesis: testing → observing at N=30", "Confidence score ≥ 60 required for promotion"],
        related_sessions=["All"],
        implementation_checklist=["Backtest imported to QTrade OS", "Forward test started with minimum lot", "30 trades collected before review", "Backtest vs live comparison done"],
        danger_flags=["overfitting", "optimization_bias"],
        quality_score=97.0, source_ref="04_Risk_Management.md", source_type="seed",
    ),
    dict(
        title="Overfitting: The Model That Memorized the Past",
        mindset_type="validation_standard",
        concept="A model is overfit when it describes training data perfectly but fails on new data. In trading: an EA with 15 parameters optimized on 2 years of data is near-certain to be overfit. Rule of thumb: need 10× more data points than free parameters.",
        why_it_matters="Overfit strategies show dramatically better backtest than live performance. Every parameter added to an EA that was tuned on historical data costs predictive power on future data.",
        failure_cases=["RSI period optimized to 14 for XAUUSD M1 because 65% WR on 2023 data", "Adding 8 indicator filters until the backtest curve looks smooth", "Reporting backtest from the same period used for optimization"],
        practical_applications=["Walk-forward optimization: optimize on 70%, validate on 30%", "Limit free parameters to 3-5 maximum per EA", "Require out-of-sample test before any claim"],
        related_strategies=["All EA optimization"],
        related_risk_rules=["Minimum out-of-sample period: 20% of backtest period"],
        related_sessions=["All"],
        implementation_checklist=["Parameter count documented", "Out-of-sample test run", "Walk-forward validation report attached"],
        danger_flags=["overfitting", "optimization_bias"],
        quality_score=97.0, source_ref="Research Standards", source_type="seed",
    ),
    dict(
        title="Stop Optimization, Start Robustness Testing",
        mindset_type="validation_standard",
        concept="Instead of asking 'what parameters maximize profit?', ask 'what parameter ranges show consistent profit across many market conditions?' Robust strategies work across a range of parameters, not just at one optimized point.",
        why_it_matters="An EA optimized to exact RSI(14) and SL(1.5×ATR) that only works at those exact values is a curve fit, not a strategy. A robust EA shows profit at RSI(12-16) and SL(1.2-1.8×ATR).",
        failure_cases=["Reporting only the best-performing parameter set", "Optimizing with 0.1 precision on parameters that shouldn't be that precise", "Not testing sensitivity: 'what if SL is 10% larger?'"],
        practical_applications=["Sensitivity analysis: ±20% on all parameters", "Report results from parameter ranges, not single optimum", "Use minimum precision: 0.5×ATR increments, not 0.01"],
        related_strategies=["All optimization workflows"],
        related_risk_rules=["Sensitivity test required before any deployment"],
        related_sessions=["All"],
        implementation_checklist=["Sensitivity analysis done on ±20% of all parameters", "Results shown for ranges not just optimum", "Robustness documented in EA notes"],
        danger_flags=["optimization_bias", "overfitting"],
        quality_score=94.0, source_ref="Quantitative Trading research standards", source_type="seed",
    ),
    # ── Engineering Process ─────────────────────────────────────────────────
    dict(
        title="One Variable at a Time: Controlled Change Protocol",
        mindset_type="engineering_process",
        concept="When debugging or optimizing an EA, change exactly one parameter or logic element at a time. Test, record results, then proceed. Never change multiple things simultaneously.",
        why_it_matters="Changing multiple variables simultaneously makes it impossible to attribute causation. If performance changes, you don't know which change caused it. This leads to parameter explosion and loss of system understanding.",
        failure_cases=["Changing RSI period, session filter, and SL multiplier in one run", "Copying a working EA and modifying 5 things before testing", "Rolling back after poor results without knowing which change caused them"],
        practical_applications=["Keep a change log for every EA modification", "Use EA version numbers for every parameter change", "A/B comparison: old version vs new version on same period"],
        related_strategies=["All EA development"],
        related_risk_rules=["Never change live EA parameters without backtest comparison"],
        related_sessions=["All"],
        implementation_checklist=["Change log in EA notes", "Version number incremented", "Before/after comparison run", "Result recorded in EA registry"],
        danger_flags=["optimization_bias"],
        quality_score=90.0, source_ref="05_Code_Patterns.md", source_type="seed",
    ),
    dict(
        title="Documentation as Code: If It's Not Written, It Doesn't Exist",
        mindset_type="engineering_process",
        concept="Every EA design decision, parameter rationale, and known limitation must be documented in the knowledge vault. An undocumented EA is a black box that cannot be safely operated, modified, or handed off.",
        why_it_matters="Human memory decays. The reasoning behind 'why SL=1.5×ATR' is obvious in the moment and forgotten in 3 weeks. Without documentation, future modifications are made blindly, destroying carefully calibrated balance.",
        failure_cases=["Changing an EA parameter without understanding why the original was chosen", "Operating an EA without knowing its failure modes", "Inheriting an EA without context documentation"],
        practical_applications=["EA blueprint note before writing any code", "Parameter rationale in ea_notes.json", "Known issues documented in EA blueprint"],
        related_strategies=["All"],
        related_risk_rules=["No EA deployed without blueprint note"],
        related_sessions=["All"],
        implementation_checklist=["EA blueprint note exists", "Parameter rationale documented", "Known limitations listed", "CLAUDE.md updated"],
        danger_flags=[],
        quality_score=91.0, source_ref="05_Code_Patterns.md", source_type="seed",
    ),
    dict(
        title="AI Context Management: CLAUDE.md is the Save State",
        mindset_type="engineering_process",
        concept="Treat the AI context window as RAM: finite, cleared between sessions. CLAUDE.md, memory files, and HANDOFF documents are the 'save state' of the AI's working knowledge. Without explicit context management, every session starts from zero.",
        why_it_matters="Without context management: repeated mistakes, inconsistent architectural decisions, inability to build on previous work. The CLAUDE.md + memory system is the engineering solution to AI session amnesia.",
        failure_cases=["Asking Claude to 'fix the EA' without providing previous session context", "Not updating CLAUDE.md after major architectural decisions", "Relying on AI to remember details from 3 sessions ago"],
        practical_applications=["Update CLAUDE.md after every major system change", "Use memory system for user preferences and project state", "HANDOFF documents for between-session continuity"],
        related_strategies=["All AI-assisted development"],
        related_risk_rules=["Review CLAUDE.md before every AI session"],
        related_sessions=["All development sessions"],
        implementation_checklist=["CLAUDE.md updated after major changes", "Memory files written for key decisions", "HANDOFF document at session end"],
        danger_flags=[],
        quality_score=89.0, source_ref="CLAUDE.md + Memory system", source_type="seed",
    ),
    # ── Decision Frameworks ─────────────────────────────────────────────────
    dict(
        title="Pre-Mortem: Imagine Failure Before Committing",
        mindset_type="decision_framework",
        concept="Before any significant decision (deploying a new EA, increasing position size, entering a new market), spend 5 minutes imagining the decision has already failed catastrophically. What went wrong?",
        why_it_matters="The brain builds confirming narratives for decisions already leaning toward. Pre-mortem breaks this by forcing explicit failure scenario thinking before commitment, when the cost of reversing is zero.",
        failure_cases=["Deploying an EA without asking 'how could this blow up?'", "Doubling position size after a good month without stress-testing the downside", "Ignoring warning signs because 'the strategy is working overall'"],
        practical_applications=["Before promoting any hypothesis: write 3 ways it could fail live", "Before increasing lot size: simulate worst drawdown from streak stats", "Use 'devil's advocate' review before any large decision"],
        related_strategies=["All deployment decisions"],
        related_risk_rules=["Max drawdown stress test before any size increase"],
        related_sessions=["All"],
        implementation_checklist=["Pre-mortem written before hypothesis promotion", "3 failure scenarios documented", "Risk mitigation for each scenario defined"],
        danger_flags=["overconfidence"],
        quality_score=88.0, source_ref="Thinking, Fast and Slow — Kahneman", source_type="seed",
    ),
    dict(
        title="Process Over Outcome: Judge Decisions by Quality, Not Results",
        mindset_type="decision_framework",
        concept="A good process can produce a bad outcome (bad luck) and a bad process can produce a good outcome (good luck). Judge trading decisions by whether they followed the process correctly, not by whether they were profitable.",
        why_it_matters="Short-term trading results are dominated by randomness. Outcome-based feedback causes adoption of bad processes that got lucky and abandonment of good processes after unlucky runs.",
        failure_cases=["Feeling confident because last week was profitable despite process violations", "Feeling doubtful because a correctly-executed trade lost", "Copying a trade idea because someone made money on it without knowing their process"],
        practical_applications=["Weekly review: score each trade on process quality (1-5) separately from P&L", "Track process quality score vs P&L over time — they should converge long-term", "Celebrate correct process execution, not profitable outcomes"],
        related_strategies=["All"],
        related_risk_rules=["Process violation = mandatory review regardless of outcome"],
        related_sessions=["All"],
        implementation_checklist=["Process quality score in trade annotation", "Weekly process quality trend tracked", "Monthly: correlation of process score vs PnL reviewed"],
        danger_flags=["recency_bias"],
        quality_score=92.0, source_ref="The Art of Thinking Clearly — Dobelli", source_type="seed",
    ),
    # ── Behavioral Lessons ───────────────────────────────────────────────────
    dict(
        title="FOMO Quantification: Measure the Cost Before Acting",
        mindset_type="behavioral_lesson",
        concept="Before entering a FOMO trade (missed the move, chasing entry), compute: 'If I enter here, my SL is X pips away, risk is Y. What is my expected value on this entry vs waiting for the next setup?' FOMO entries typically have negative EV.",
        why_it_matters="FOMO is the most common behavioral loss driver. QTrade OS data consistently shows FOMO-tagged trades have lower WR and worse RR than planned entries. Quantifying the cost makes it concrete.",
        failure_cases=["Entering after a large candle move without a new setup", "Reducing size on a valid setup then adding at worse price", "Chasing breakouts without volume/regime confirmation"],
        practical_applications=["Tag every trade as 'planned' or 'FOMO' in QTrade OS annotation", "Review FOMO-tagged trade stats monthly", "Rule: no entry if 50% or more of projected move has already happened"],
        related_strategies=["All discretionary trades"],
        related_risk_rules=["FOMO trades capped at 0.25% risk (half normal)"],
        related_sessions=["London open", "NY open"],
        implementation_checklist=["FOMO tag in QTrade OS trade annotation", "Monthly FOMO cost calculation", "FOMO rule posted at trading station"],
        danger_flags=["revenge_trading"],
        quality_score=93.0, source_ref="EAs/Ninja/บันทึกการวิเคราะห์ความพ่ายแพ้...md", source_type="seed",
    ),
    dict(
        title="Revenge Trading: The Certainty Trap After Losses",
        mindset_type="behavioral_lesson",
        concept="Revenge trading is taking a non-system trade after a loss to recover capital. It typically involves: (1) larger than normal size, (2) no system validation, (3) emotional urgency. It produces net losses in over 90% of cases.",
        why_it_matters="Revenge trades double losses: the original loss plus the revenge loss. One revenge trade session can erase weeks of systematic gains and destroy the discipline the entire edge depends on.",
        failure_cases=["After hitting daily loss limit, opening one more 'recovery' trade", "Switching from XAUUSD to NQ after XAUUSD loss", "Increasing lot size after 3 consecutive losses"],
        practical_applications=["Hard rule: if daily limit hit, close MT5 — no exceptions", "Implement software daily loss limit in all EAs", "Journal: flag every trade entered after a loss and review weekly"],
        related_strategies=["All"],
        related_risk_rules=["Daily loss limit: hard stop", "3-consecutive-loss pause rule"],
        related_sessions=["All"],
        implementation_checklist=["Daily loss limit in EA risk engine", "Consecutive loss counter in QTrade OS", "Weekly review of loss-sequence trades"],
        danger_flags=["revenge_trading"],
        quality_score=96.0, source_ref="EAs/Ninja/บันทึกการวิเคราะห์ความพ่ายแพ้...md", source_type="seed",
    ),
    dict(
        title="Recency Bias: Last Month's Results Are Not the Strategy",
        mindset_type="behavioral_lesson",
        concept="After a good month, position sizes tend to increase. After a bad month, they decrease or the strategy gets abandoned. Both reactions are driven by recency bias — overweighting recent events vs the full statistical distribution.",
        why_it_matters="Position sizing based on recent performance introduces destructive feedback loops. Increasing after wins and decreasing after losses is the opposite of what mathematical expectation recommends.",
        failure_cases=["Doubling lot size in May because April was profitable", "Stopping QField EA after 2 losing weeks", "Changing strategy parameters because last week was different"],
        practical_applications=["Position sizing from 6-month rolling stats, not last month", "Strategy evaluation: minimum 3 months before any conclusion", "Changes require full statistical review, not performance reaction"],
        related_strategies=["All"],
        related_risk_rules=["No sizing changes within 30-day review windows"],
        related_sessions=["All"],
        implementation_checklist=["Position size from 6-month stats", "Strategy review on schedule not on reaction", "Recency bias check in weekly review template"],
        danger_flags=["recency_bias"],
        quality_score=88.0, source_ref="Behavioral finance principles", source_type="seed",
    ),
]


def seed_principles(con: sqlite3.Connection | None = None) -> int:
    """Insert seed principles. Returns count inserted."""
    close_after = con is None
    if con is None:
        con = _con()
    n = 0
    for s in _SEEDS:
        pid = _next_id(con)
        def _j(v):
            return json.dumps(v or [], ensure_ascii=False)
        category = MINDSET_TO_CATEGORY.get(s["mindset_type"], "Mental_Models")
        p = {**s, "failure_cases": _j(s.get("failure_cases")),
             "practical_applications": _j(s.get("practical_applications")),
             "related_strategies": _j(s.get("related_strategies")),
             "related_risk_rules": _j(s.get("related_risk_rules")),
             "related_sessions": _j(s.get("related_sessions")),
             "implementation_checklist": _j(s.get("implementation_checklist")),
             "danger_flags": _j(s.get("danger_flags"))}
        conf = compute_confidence_score({**p, "review_count": 0, "applied_count": 0})
        try:
            con.execute(
                """INSERT OR IGNORE INTO mindset_principles
                   (principle_id, title, mindset_type, category,
                    concept, why_it_matters, failure_cases, practical_applications,
                    related_strategies, related_risk_rules, related_sessions,
                    implementation_checklist, danger_flags,
                    quality_score, confidence_score, source_ref, source_type, status)
                   VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                (pid, s["title"], s["mindset_type"], category,
                 s.get("concept",""), s.get("why_it_matters",""),
                 p["failure_cases"], p["practical_applications"],
                 p["related_strategies"], p["related_risk_rules"],
                 p["related_sessions"], p["implementation_checklist"],
                 p["danger_flags"], s.get("quality_score", 0),
                 conf, s.get("source_ref",""), s.get("source_type","seed"),
                 "active")
            )
            con.commit()
            n += 1
        except sqlite3.Error:
            pass
    if close_after:
        con.close()
    return n


# ── Additional seed principles (Phase 2 expansion) ────────────────────────────

_ADDITIONAL_SEEDS: list[dict] = [
    # ── Risk Philosophy × 5 ────────────────────────────────────────────────
    dict(
        title="Max Drawdown Cap Protocol: Hard Ceiling at 10%",
        mindset_type="risk_philosophy",
        concept="Set a hard maximum drawdown limit of 10% from peak equity. When reached, ALL EAs pause automatically until a human review is completed. No exceptions, no 'just one more trade to recover'. The cap exists precisely because emotional reasoning says to ignore it.",
        why_it_matters="Drawdown is exponentially harder to recover from as it deepens. A 10% DD requires 11% gain to recover. A 20% DD requires 25%. A 40% DD requires 67%. Capping at 10% preserves capital and decision-making capacity.",
        failure_cases=["Letting HedgeGrid accumulate floating loss beyond 10% hoping for reversal", "Disabling the daily loss limit after a string of wins", "Treating FTMO 10% rule as a target, not a ceiling"],
        practical_applications=["Set MaxDrawdown parameter in all EAs to hard-stop at 10%", "QTrade OS alert when equity DD > 7% (early warning)", "Monthly review: if max DD > 5% in any month, investigate cause before continuing"],
        related_strategies=["All EAs — universal"],
        related_risk_rules=["Daily loss limit = 2%", "Max position risk = 0.5%", "3-consecutive-loss pause"],
        related_sessions=["All"],
        implementation_checklist=["MaxDrawdown hard-coded in all EAs", "7% early warning in QTrade OS", "Monthly DD review in Weekly Review page"],
        danger_flags=[],
        quality_score=97.0, source_ref="04_Risk_Management.md + FTMO rules", source_type="seed",
    ),
    dict(
        title="Consecutive Loss Pause: 3 Losses = 24-Hour Stop",
        mindset_type="risk_philosophy",
        concept="After 3 consecutive losses from any single strategy in one session, that strategy pauses for 24 hours. This is not optional. The rule exists because consecutive losses indicate either: (1) regime mismatch, (2) system breakdown, or (3) execution errors — all requiring investigation.",
        why_it_matters="The human urge after 3 losses is to 'make it back'. The system urge is to continue because 'statistically it should recover'. Both are wrong. 3 consecutive losses exceeds 1-sigma expectation for most strategies and warrants investigation, not continuation.",
        failure_cases=["Running QField through 5 losses in one London session and continuing", "Manually overriding the pause 'because the setup is perfect'", "Counting losses across different days as non-consecutive"],
        practical_applications=["Consecutive loss counter in EA risk engine (rr_consec_loss rule)", "QTrade OS alert: red banner after 3 consecutive losses", "Investigation checklist: SC₁₀₀, spread, news events, system logs"],
        related_strategies=["QField_EA", "QuantumQueen", "SMC_Universal_EA"],
        related_risk_rules=["rr_consec_loss node in knowledge graph", "Daily loss limit enforced first"],
        related_sessions=["All — applies within any session"],
        implementation_checklist=["ConsecutiveLossLimit parameter in all EAs", "QTrade OS counter visible in dashboard", "Investigation template for post-pause review"],
        danger_flags=["revenge_trading"],
        quality_score=95.0, source_ref="04_Risk_Management.md", source_type="seed",
    ),
    dict(
        title="Equity Curve Filter: Only Trade Above the 20-Day Equity MA",
        mindset_type="risk_philosophy",
        concept="Track the daily closing equity as a series and compute its 20-day moving average. Only deploy full-size positions when equity is above its own 20-day MA. When below, reduce size by 50%. This creates an automatic regime filter at the account level.",
        why_it_matters="A strategy's edge may be real but the market regime may make it temporarily unprofitable. The equity curve MA acts as a meta-regime filter — it doesn't care why performance degraded, only that it has. Reducing size during drawdown periods prevents catastrophic loss compounding.",
        failure_cases=["Trading full size during a 3-week drawdown streak", "Ignoring the equity MA because 'the strategy is still fundamentally sound'", "Not tracking equity MA because 'it adds complexity'"],
        practical_applications=["QTrade OS: plot 20-day equity MA on performance page", "When equity < 20-day MA: all EA lots ×0.5", "Track: how many weeks spent below equity MA per month"],
        related_strategies=["All portfolio-level management"],
        related_risk_rules=["Max DD cap", "Consecutive loss pause"],
        related_sessions=["All — account-level rule"],
        implementation_checklist=["Daily equity tracked in QTrade OS", "20-day MA computed", "Size reduction rule documented in EA config guide"],
        danger_flags=["recency_bias"],
        quality_score=90.0, source_ref="Portfolio risk management principles", source_type="seed",
    ),
    dict(
        title="Volatility Regime Risk Scaling: Size Down in CRASH Regime",
        mindset_type="risk_philosophy",
        concept="When SC₁₀₀ signals CRASH regime (< 0.22 + spike), reduce all position sizes by 50-75%. CRASH regimes have 3-5× normal volatility — a 1% risk position behaves like a 3-5% risk position. Risk must be scaled to actual volatility, not nominal percentages.",
        why_it_matters="Fixed lot sizes in variable volatility environments create unpredictable dollar risk. A 0.1 lot on XAUUSD costs ~$1/pip in normal conditions. In CRASH regime, the same lot on a 200-pip swing is a $200 loss — potentially 4% of a $5,000 account.",
        failure_cases=["Running fixed lots through CRASH regimes without ATR-based adjustment", "Treating CRASH regime as 'high momentum opportunity' and increasing size", "Not accounting for widened spreads during CRASH events"],
        practical_applications=["ATR-based lot sizing: lot = risk_dollars / (ATR × lot_value)", "QField and HedgeGrid: CrashRegimeMultiplier = 0.5 parameter", "Spread filter: skip trades when spread > 3× baseline"],
        related_strategies=["QField_EA", "HedgeGrid_V23", "SMC_Universal_EA"],
        related_risk_rules=["ATR Near Distance filter (Code Pattern #13)", "Kelly cap = 25%"],
        related_sessions=["All — especially London and NY open which see most CRASH events"],
        implementation_checklist=["ATR-based position sizing in all EAs", "CrashRegimeMultiplier parameter exists", "Spread check before each trade"],
        danger_flags=["overconfidence"],
        quality_score=93.0, source_ref="04_Risk_Management.md + 02_Regime_Detection.md", source_type="seed",
    ),
    dict(
        title="Portfolio Heat: Cap Total Open Risk to 3% at Any Moment",
        mindset_type="risk_philosophy",
        concept="At any given time, the sum of all open position risk (distance to SL × lot size) across all EAs must not exceed 3% of account equity. Portfolio heat is the aggregate risk exposure — it must be managed at the portfolio level, not just per-trade.",
        why_it_matters="Running QField + HedgeGrid + QuantumQueen simultaneously on XAUUSD can create correlated risk spikes. A single news event can trigger all SLs simultaneously. Portfolio heat management prevents this compounding loss scenario.",
        failure_cases=["Running 3 EAs each at 1% risk simultaneously on the same pair", "Not accounting for open floating loss in hedge positions", "Treating each EA's risk independently when they share correlated price drivers"],
        practical_applications=["Portfolio heat dashboard in QTrade OS (page 10 correlation + open risk)", "Before opening any new position: check total open risk", "Max single position: 0.5%, max portfolio heat: 3%"],
        related_strategies=["All multi-EA setups"],
        related_risk_rules=["Daily loss limit = 2%", "Kelly cap = 25%", "Correlation check r ≤ 0.6"],
        related_sessions=["All — especially during simultaneous multi-EA operation"],
        implementation_checklist=["Portfolio heat metric in QTrade OS", "Max heat parameter defined", "Alert when heat > 2.5%"],
        danger_flags=[],
        quality_score=91.0, source_ref="04_Risk_Management.md", source_type="seed",
    ),
    # ── Quantitative Mindset × 3 (anti-overfitting) ─────────────────────────
    dict(
        title="Walk-Forward Validation Is Non-Negotiable",
        mindset_type="quantitative_mindset",
        concept="Every strategy that passes in-sample optimization must be tested on a completely separate out-of-sample forward period. Standard: optimize on 70% of data, validate on 30%. The validation period must not be touched during development.",
        why_it_matters="In-sample results are always better than out-of-sample. If they're not, something is wrong with the test setup. Walk-forward validation is the only way to measure actual predictive power vs curve-fitting to historical noise.",
        failure_cases=["Optimizing on 2022-2024 then 'forward testing' on 2024-2025 data that was visible during development", "Using the same dataset for both optimization and final reporting", "Stopping walk-forward when the out-of-sample result is bad instead of reporting it"],
        practical_applications=["Split data: 70/30 before any optimization begins", "Lock the 30% validation set and don't touch it", "Report both IS and OOS results side by side in QTrade OS"],
        related_strategies=["All optimization workflows"],
        related_risk_rules=["Minimum OOS period: 6 months for any claim"],
        related_sessions=["All"],
        implementation_checklist=["Data split done before optimization", "OOS set never viewed during development", "IS/OOS comparison in hypothesis record"],
        danger_flags=["overfitting", "optimization_bias"],
        quality_score=97.0, source_ref="Quantitative Trading — Ernest Chan", source_type="seed",
    ),
    dict(
        title="Out-of-Sample Data Is Sacred: Never Touch It During Development",
        mindset_type="quantitative_mindset",
        concept="The out-of-sample validation period must be completely isolated from the development process. Looking at OOS data, even casually, contaminates it. Treat it like a sealed envelope — only opened once, at the end, for the final report.",
        why_it_matters="Unconscious data snooping is pervasive and undetectable. If you've seen the OOS data even once during development, your parameter choices will be biased toward it. The contaminated OOS set is then just a larger IS set.",
        failure_cases=["Checking whether OOS equity curve 'looks reasonable' mid-development", "Using OOS results to pick between two parameter sets", "Running strategy on full dataset 'just to see' before finalizing parameters"],
        practical_applications=["Define and document the OOS period date range before any analysis", "Keep OOS data in a separate file that requires deliberate action to open", "Final step only: run on OOS and report — no further changes allowed after"],
        related_strategies=["All quantitative research"],
        related_risk_rules=["OOS contamination = restart from scratch"],
        related_sessions=["All"],
        implementation_checklist=["OOS period defined in writing before development", "OOS file kept separate", "Report explicitly states 'OOS not viewed during development'"],
        danger_flags=["overfitting", "optimization_bias"],
        quality_score=95.0, source_ref="Advances in Financial Machine Learning — Marcos de Prado", source_type="seed",
    ),
    dict(
        title="Monte Carlo Simulation Before Going Live",
        mindset_type="quantitative_mindset",
        concept="Before deploying any strategy live, run Monte Carlo simulation on the validated trade sequence: randomly resample trades with replacement 1,000+ times. The 5th percentile of simulated equity curves is your worst-case realistic drawdown estimate.",
        why_it_matters="A single backtest is one possible realization of a random process. Monte Carlo shows the distribution of possible outcomes given your edge. If the 5th percentile MC drawdown exceeds your risk tolerance, the strategy is too risky — regardless of how good the single backtest looks.",
        failure_cases=["Deploying after seeing one good equity curve without considering path dependency", "Using backtest MaxDD as the risk estimate (far too optimistic)", "Not accounting for position sizing's effect on DD distribution"],
        practical_applications=["Run 1,000 MC simulations on last 30+ validated trades", "Report 5th percentile MC DD as the risk estimate for position sizing", "If MC 5th pct DD > 15%, reduce position size until it's under control"],
        related_strategies=["QField_EA", "QuantumQueen"],
        related_risk_rules=["Max DD cap 10%", "Kelly cap 25%"],
        related_sessions=["All"],
        implementation_checklist=["Monte Carlo script exists for each strategy", "5th pct MC DD reported in hypothesis record", "Position size computed from MC DD, not backtest DD"],
        danger_flags=["overfitting", "overconfidence"],
        quality_score=92.0, source_ref="Quantitative Trading research standards", source_type="seed",
    ),
    # ── Trading Principle × 4 (regime-aware) ───────────────────────────────
    dict(
        title="SC₁₀₀ Threshold Discipline: No Manual Override of Regime Signals",
        mindset_type="trading_principle",
        concept="Once SC₁₀₀ signals a regime, the corresponding strategy rules apply — no manual override based on chart reading or intuition. SC₁₀₀ has r = -0.95 with β₁. Human intuition about 'what the market feels like' has far lower predictive validity.",
        why_it_matters="The entire value of SC₁₀₀ depends on consistent application. Selectively applying it when it confirms what you already wanted to do removes the systematic edge entirely. Regime detection only works when followed unconditionally.",
        failure_cases=["SC₁₀₀ = 0.38 (REVERTING) but manually entering a momentum trade because 'the trend looks clear'", "Overriding CRASH regime block because 'this move is different'", "Applying SC₁₀₀ only in losing streaks as an excuse to stop, not as systematic rule"],
        practical_applications=["QField EA enforces SC₁₀₀ at code level — cannot be overridden without changing source", "Manual trading: post SC₁₀₀ value visibly before any trade evaluation", "Weekly review: count any manual overrides and examine outcomes"],
        related_strategies=["QField_EA", "SMC_Universal_EA", "QuantumQueen"],
        related_risk_rules=["Regime check first in all EA entry logic"],
        related_sessions=["All — check SC₁₀₀ at each session open"],
        implementation_checklist=["SC₁₀₀ enforced in code, not parameter", "Regime visible in QTrade OS at session open", "Override incidents tracked in weekly review"],
        danger_flags=["overconfidence", "recency_bias"],
        quality_score=96.0, source_ref="02_Regime_Detection.md", source_type="seed",
    ),
    dict(
        title="Regime-Adaptive Position Sizing: Scale Risk to Regime Confidence",
        mindset_type="trading_principle",
        concept="Position size should scale with regime clarity, not just be a fixed percentage. TRENDING regime (SC₁₀₀ < 0.22): full size. WEAK regime (SC₁₀₀ 0.25-0.35): half size. CRASH (< 0.22 + spike): 25% size. REVERTING with RSI confirmation: full size.",
        why_it_matters="Regime transitions are the highest-uncertainty periods. WEAK regime has ambiguous regime identity — both momentum and reversal setups have lower edge quality. Reducing size in uncertain regimes directly reduces variance without sacrificing expected return.",
        failure_cases=["Full size in WEAK regime where both bulls and bears could be right", "Not scaling down during CRASH despite 3-5× elevated volatility", "Using the same lot size regardless of SC₁₀₀ reading"],
        practical_applications=["RegimeSizeMultiplier in QField: TRENDING=1.0, REVERTING=0.8, WEAK=0.5, CRASH=0.25", "Document size multipliers in EA config", "Review: does size scaling improve Sharpe ratio vs fixed sizing?"],
        related_strategies=["QField_EA"],
        related_risk_rules=["Kelly cap = 25%", "Volatility regime risk scaling"],
        related_sessions=["All"],
        implementation_checklist=["RegimeSizeMultiplier coded in QField", "Config file documents multipliers", "A/B test: regime-scaled vs fixed sizing on 30+ trades"],
        danger_flags=[],
        quality_score=92.0, source_ref="02_Regime_Detection.md + 04_Risk_Management.md", source_type="seed",
    ),
    dict(
        title="WEAK Regime: Cash Is a Position",
        mindset_type="trading_principle",
        concept="When SC₁₀₀ is 0.25-0.35 (WEAK regime), the market has no clear directional bias. The correct action is often to hold no position. 'Cash is a position' means recognizing that not trading is an active, valid decision — not a failure to act.",
        why_it_matters="WEAK regime produces the worst risk-adjusted returns because both momentum and reversal signals are unreliable. Trading in WEAK regime is paying the spread and slippage for below-expectation outcomes. Patience is the edge.",
        failure_cases=["Forcing trades in WEAK regime because 'I should be trading today'", "Treating missed setups in WEAK regime as lost opportunities", "Using lower timeframes to 'find' setups that don't exist on higher timeframe"],
        practical_applications=["QField EA blocks new entries in WEAK regime by default", "Manual trading: WEAK regime = observation only, no new positions", "Track: P&L of WEAK regime trades — verify they underperform TRENDING/REVERTING"],
        related_strategies=["QField_EA", "QuantumQueen"],
        related_risk_rules=["Session window discipline — fewer valid hours in WEAK regime"],
        related_sessions=["All — WEAK regime applies across sessions"],
        implementation_checklist=["WEAK regime entry block in QField", "WEAK regime labeled in QTrade OS dashboard", "Monthly: count WEAK regime trades and check their average outcome"],
        danger_flags=["overconfidence", "recency_bias"],
        quality_score=91.0, source_ref="02_Regime_Detection.md", source_type="seed",
    ),
    dict(
        title="CRASH Regime: Exit Not Entry (Momentum Only, No Reversals)",
        mindset_type="trading_principle",
        concept="CRASH regime (SC₁₀₀ < 0.22 with spike) is a one-directional momentum event. The rule is: exit existing reversal/mean-reversion positions immediately, do not enter new reversal trades, only momentum-aligned trades are permitted.",
        why_it_matters="Reversals in CRASH regimes are the largest single-trade loss events in trading history. Markets in CRASH can trend 5-10× their normal range before mean-reversion occurs. 'Catching the falling knife' in CRASH is the fastest path to ruin.",
        failure_cases=["RSI oversold in CRASH regime → enter long → market drops another 200 pips", "HedgeGrid adding grid levels into a CRASH (each level becomes a new loss)", "Averaging down into a CRASH regime position"],
        practical_applications=["QField EA: in CRASH, only momentum signals are allowed (β₁ direction)", "HedgeGrid: crash override parameter that halts new grid levels", "Manual trading: if SC₁₀₀ < 0.22 + spike detected, close all mean-reversion positions"],
        related_strategies=["QField_EA", "HedgeGrid_V23 (halt grid in CRASH)"],
        related_risk_rules=["Max DD cap = 10%", "Volatility regime risk scaling (25% size in CRASH)"],
        related_sessions=["All — CRASH events most common around news events"],
        implementation_checklist=["CRASH regime reversal block in QField", "HedgeGrid CrashHalt parameter", "SC₁₀₀ spike detection implemented"],
        danger_flags=["sunk_cost", "overconfidence"],
        quality_score=95.0, source_ref="02_Regime_Detection.md + EAs/Ninja/บันทึกการวิเคราะห์ความพ่ายแพ้...md", source_type="seed",
    ),
    # ── Engineering Process × 4 (execution-aware) ──────────────────────────
    dict(
        title="Session Window Discipline: Hard Block Outside Validated Hours",
        mindset_type="engineering_process",
        concept="Every EA must have a hard-coded session filter that blocks new entries outside validated trading hours. This is not a soft guideline — it's an engineering constraint. Session filter is as important as stop-loss.",
        why_it_matters="Outside validated session windows (London 14:00-15:00, NY 20:30-21:00), the same strategy typically shows 20-35% lower win rate. The session isn't just a time preference — it reflects liquidity, volatility profile, and institutional participation.",
        failure_cases=["Running QField at 10:00 TH (Asian session) because 'the setup looks good'", "Disabling session filter because 'today is different'", "EA without session filter running 24/7 accumulating off-session losses"],
        practical_applications=["Session parameter (StartHour, EndHour) in every EA — cannot be disabled without source change", "QTrade OS: flag any trade tagged outside session window", "Monthly review: check off-session trade count and outcomes"],
        related_strategies=["QField_EA", "QuantumQueen", "SMC_Universal_EA"],
        related_risk_rules=["Session check before every entry in EA code"],
        related_sessions=["London (14:00-15:00 TH)", "NY open (20:30-21:00 TH)"],
        implementation_checklist=["SessionStart/SessionEnd hardcoded in all EAs", "Off-session trade flag in QTrade OS", "Session discipline tracked in weekly review"],
        danger_flags=["overconfidence"],
        quality_score=94.0, source_ref="03_Signal_Logic.md", source_type="seed",
    ),
    dict(
        title="Spread Filter: Check Spread Before Every Trade Entry",
        mindset_type="engineering_process",
        concept="Before each trade entry, check current spread against a baseline. Skip entry if spread > 2× baseline for the symbol/session combination. XAUUSD baseline: ~15-25 points in London/NY. Spread spikes indicate reduced liquidity and increased slippage risk.",
        why_it_matters="An elevated spread directly erodes edge. A strategy with 1.5× ATR target and 15-point spread needs price to move 15 points just to break even. At 45-point spread, the trade starts 3× further in the hole — effectively destroying the edge.",
        failure_cases=["Entering XAUUSD during news events with 80+ point spread", "Not checking spread in Asian session where XAUUSD spread is 40+ points", "EA without spread filter running through gap opens with extreme spreads"],
        practical_applications=["MaxSpread parameter in all EAs (default: 30 for XAUUSD)", "Code Pattern #13 (ATR Near Distance) already includes spread consideration", "QTrade OS: log spread at entry time for each trade"],
        related_strategies=["All EAs"],
        related_risk_rules=["MaxSpread in EA parameters = non-negotiable"],
        related_sessions=["All — especially Asian and news events"],
        implementation_checklist=["MaxSpread parameter in every EA", "Spread logged per trade in QTrade OS", "Weekly: review spread vs slippage correlation"],
        danger_flags=[],
        quality_score=90.0, source_ref="05_Code_Patterns.md", source_type="seed",
    ),
    dict(
        title="News Event Protocol: No New Entries Within 5 Minutes of High-Impact News",
        mindset_type="engineering_process",
        concept="Identify high-impact news events (NFP, FOMC, CPI, Gold-specific announcements) and block all new trade entries from 5 minutes before to 5 minutes after release. Existing positions may be held if SL is already set.",
        why_it_matters="During high-impact news, spreads widen 3-10×, slippage becomes unpredictable, and SC₁₀₀-based regime detection becomes unreliable due to artificial volatility spike. The 10-minute window is the highest-risk period for systematic strategies.",
        failure_cases=["QField entering a trade 2 minutes before NFP at 19:30 TH", "Running without news filter on FOMC meeting days", "Keeping open hedge positions through news that creates gap risk"],
        practical_applications=["News filter parameter (UseNewsFilter=true) in all EAs", "Economic calendar API or manual block list in EA", "Pre-session checklist: check economic calendar for the day"],
        related_strategies=["QField_EA", "QuantumQueen", "HedgeGrid_V23"],
        related_risk_rules=["Spread filter + news filter are paired requirements"],
        related_sessions=["London", "NY open — highest news frequency"],
        implementation_checklist=["News filter coded in each EA", "Economic calendar reviewed pre-session", "Post-news entry resumption check (spread back to baseline)"],
        danger_flags=[],
        quality_score=91.0, source_ref="03_Signal_Logic.md", source_type="seed",
    ),
    dict(
        title="Slippage Budget: Track and Cap Slippage as a Hidden Cost",
        mindset_type="engineering_process",
        concept="Slippage (difference between expected entry/exit and actual fill price) is a real but invisible cost. Set a maximum acceptable slippage per trade (e.g., 5 points for XAUUSD) and track actual slippage in QTrade OS. If monthly average slippage exceeds budget, investigate broker and execution.",
        why_it_matters="Slippage consistently erodes edge in ways that don't appear in backtests. A strategy with 10-point average win may be eroded by 5-point average slippage — cutting expected value by 50%. Tracking slippage reveals broker quality and execution timing issues.",
        failure_cases=["Running high-frequency entries during London open without tracking slippage cost", "Backtesting with 0 slippage model then wondering why live results are worse", "Not accounting for slippage in position sizing calculations"],
        practical_applications=["Log entry/exit planned vs actual price in QTrade OS trade annotation", "Monthly: compute average slippage per trade per symbol", "If avg slippage > 5 pts: review entry timing, broker VPS, EA execution speed"],
        related_strategies=["All EAs — especially high-frequency"],
        related_risk_rules=["Include slippage in expected value calculations"],
        related_sessions=["London open and NY open — highest volume, highest slippage risk"],
        implementation_checklist=["Slippage field in QTrade OS trade log", "Monthly slippage report", "MaxSlippage parameter in MQL5 OrderSend() calls"],
        danger_flags=[],
        quality_score=88.0, source_ref="05_Code_Patterns.md", source_type="seed",
    ),
]


def seed_additional_principles(dry_run: bool = False) -> dict[str, Any]:
    """
    Insert the Phase 2 expansion principles (16 new principles).

    Checks for existing titles to avoid duplicates.
    dry_run=True: report what would be inserted without making changes.

    Returns: summary dict with counts
    """
    con = _con()
    existing_titles: set[str] = set()
    try:
        existing_titles = {
            r[0] for r in con.execute("SELECT title FROM mindset_principles").fetchall()
        }
    except Exception:
        pass

    inserted = 0
    skipped  = 0
    errors: list[str] = []

    for s in _ADDITIONAL_SEEDS:
        if s["title"] in existing_titles:
            skipped += 1
            continue
        if dry_run:
            inserted += 1
            continue

        def _j(v):
            import json as _json
            return _json.dumps(v or [], ensure_ascii=False)

        category = MINDSET_TO_CATEGORY.get(s["mindset_type"], "Mental_Models")
        p = {
            "concept":                  s.get("concept", ""),
            "why_it_matters":           s.get("why_it_matters", ""),
            "failure_cases":            _j(s.get("failure_cases")),
            "practical_applications":   _j(s.get("practical_applications")),
            "related_strategies":       _j(s.get("related_strategies")),
            "related_risk_rules":       _j(s.get("related_risk_rules")),
            "related_sessions":         _j(s.get("related_sessions")),
            "implementation_checklist": _j(s.get("implementation_checklist")),
            "danger_flags":             _j(s.get("danger_flags")),
        }
        conf = compute_confidence_score({**p, "review_count": 0, "applied_count": 0})
        pid  = _next_id(con)

        try:
            con.execute(
                """INSERT OR IGNORE INTO mindset_principles
                   (principle_id, title, mindset_type, category,
                    concept, why_it_matters, failure_cases, practical_applications,
                    related_strategies, related_risk_rules, related_sessions,
                    implementation_checklist, danger_flags,
                    quality_score, confidence_score, source_ref, source_type, status)
                   VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                (pid, s["title"], s["mindset_type"], category,
                 p["concept"], p["why_it_matters"],
                 p["failure_cases"], p["practical_applications"],
                 p["related_strategies"], p["related_risk_rules"],
                 p["related_sessions"], p["implementation_checklist"],
                 p["danger_flags"],
                 s.get("quality_score", 0), conf,
                 s.get("source_ref", ""), s.get("source_type", "seed"),
                 "active"),
            )
            con.commit()
            existing_titles.add(s["title"])
            inserted += 1
        except Exception as e:
            errors.append(f"{pid} {s['title'][:40]}: {e}")

    if not dry_run:
        con.close()
    else:
        con.close()

    return {
        "total_additional": len(_ADDITIONAL_SEEDS),
        "inserted": inserted,
        "skipped":  skipped,
        "errors":   errors,
        "dry_run":  dry_run,
    }


# ── Summary helpers for dashboard ─────────────────────────────────────────────

def get_principle_summary() -> dict[str, Any]:
    """Return counts and averages for the dashboard header."""
    run_migration()
    con = _con()
    try:
        total = con.execute(
            "SELECT COUNT(*) FROM mindset_principles WHERE status='active'"
        ).fetchone()[0]
        by_type = dict(con.execute(
            "SELECT mindset_type, COUNT(*) FROM mindset_principles WHERE status='active' GROUP BY mindset_type"
        ).fetchall())
        avg_quality = con.execute(
            "SELECT AVG(quality_score) FROM mindset_principles WHERE status='active'"
        ).fetchone()[0] or 0
        avg_conf = con.execute(
            "SELECT AVG(confidence_score) FROM mindset_principles WHERE status='active'"
        ).fetchone()[0] or 0
        applied_total = con.execute(
            "SELECT SUM(applied_count) FROM mindset_principles WHERE status='active'"
        ).fetchone()[0] or 0
        violations_total = con.execute(
            "SELECT SUM(violation_count) FROM mindset_principles WHERE status='active'"
        ).fetchone()[0] or 0
        danger_rows = con.execute(
            "SELECT danger_flags FROM mindset_principles WHERE status='active'"
        ).fetchall()
        principles_with_flags = sum(
            1 for r in danger_rows if json.loads(r[0] or "[]")
        )
        return {
            "total": total,
            "by_type": by_type,
            "avg_quality": avg_quality,
            "avg_confidence": avg_conf,
            "applied_total": applied_total,
            "violations_total": violations_total,
            "principles_with_flags": principles_with_flags,
        }
    finally:
        con.close()
