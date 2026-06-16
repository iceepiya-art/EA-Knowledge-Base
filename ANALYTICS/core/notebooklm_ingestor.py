"""
notebooklm_ingestor.py — NotebookLM & research link ingestion engine.

Workflow:
  1. User provides link + title + summary (pasted from NotebookLM)
  2. Auto-classify into category via keyword scoring
  3. Auto-generate: hypothesis draft, action items, test checklist, tags
  4. Write markdown note to 01_Inbox/ in the Obsidian vault
  5. Store in research_inbox DB table

NotebookLM has no public API — content is always user-provided (copy-paste).
This module organizes and enriches that content for the knowledge vault.
"""

from __future__ import annotations

import json
import re
import sqlite3
from datetime import date, datetime
from pathlib import Path

import pandas as pd

BASE_DIR   = Path(__file__).resolve().parents[2]
INBOX_DIR  = BASE_DIR / "01_Inbox"
DB_PATH    = BASE_DIR / "DATA" / "processed" / "trades.sqlite"

# ── Category constants ─────────────────────────────────────────────────────────

CATEGORIES = [
    "strategy", "regime", "psychology", "risk",
    "execution", "ai_engineering", "system_design", "uncategorized",
]

CATEGORY_LABELS = {
    "strategy":       "📈 Strategy",
    "regime":         "🌊 Regime",
    "psychology":     "🧠 Psychology",
    "risk":           "🛡 Risk",
    "execution":      "⚡ Execution",
    "ai_engineering": "🤖 AI Engineering",
    "system_design":  "⚙️ System Design",
    "uncategorized":  "📁 Uncategorized",
}

CATEGORY_COLORS = {
    "strategy":       "#26a69a",
    "regime":         "#5c6bc0",
    "psychology":     "#ab47bc",
    "risk":           "#ef5350",
    "execution":      "#ffd600",
    "ai_engineering": "#29b6f6",
    "system_design":  "#8d6e63",
    "uncategorized":  "#546e7a",
}

_CATEGORY_KEYWORDS: dict[str, list[str]] = {
    "strategy": [
        "strategy", "entry", "exit", "signal", "breakout", "reversal",
        "w pattern", "m pattern", "rsi", "ema", "sma", "smc", "ict",
        "bos", "choch", "bsl", "ssl", "fvg", "supply", "demand",
        "setup", "trade setup", "edge", "confluence", "candlestick",
        "engulfing", "pin bar", "liquidity",
    ],
    "regime": [
        "regime", "sc100", "sc₁₀₀", "trend", "trending", "reverting",
        "crash", "volatility", "market state", "market condition",
        "β₁", "beta", "sign change", "momentum", "mean revert",
        "ranging", "sideways", "breakout regime",
    ],
    "psychology": [
        "psychology", "emotion", "emotional", "fear", "fomo", "greed",
        "discipline", "mindset", "bias", "cognitive", "mistake", "error",
        "revenge", "overtrade", "impulsive", "patience", "journal",
        "mental", "stress", "anxiety", "confidence",
    ],
    "risk": [
        "risk", "drawdown", "kelly", "position size", "lot size", "stop loss",
        "rr ratio", "risk reward", "max loss", "var", "exposure", "leverage",
        "capital", "preservation", "loss limit", "daily limit", "streak",
        "ruin", "sizing", "portfolio",
    ],
    "execution": [
        "execution", "session", "london", "new york", "asian", "ny",
        "spread", "slippage", "timing", "broker", "mt5", "mt4", "latency",
        "fill", "order", "market order", "limit order", "hour", "session window",
    ],
    "ai_engineering": [
        "ai", "artificial intelligence", "machine learning", "ml", "llm",
        "language model", "gpt", "claude", "agent", "nlp", "prediction",
        "model", "training", "neural", "deep learning", "classification",
        "reinforcement", "rl",
    ],
    "system_design": [
        "system", "architecture", "infrastructure", "pipeline", "database",
        "api", "automation", "ea", "expert advisor", "mql5", "backtest",
        "optimization", "framework", "integration", "obsidian", "vault",
        "dashboard", "streamlit", "sqlite",
    ],
}

SOURCE_TYPES = ["notebooklm", "youtube", "article", "pdf", "book", "podcast",
                "manual", "other", "learning_arena"]
SOURCE_ICONS = {
    "notebooklm":     "🧠", "youtube": "▶️",  "article": "📰", "pdf": "📄",
    "book":           "📚", "podcast": "🎙",  "manual": "📋", "other": "🔗",
    "learning_arena": "🏟",
}
# 6-state research lifecycle
STATUSES = ["inbox", "reviewing", "testing", "validated", "rejected", "archived"]
STATUS_COLORS = {
    "inbox":    "#ffd600",
    "reviewing":"#fb8c00",
    "testing":  "#5c6bc0",
    "validated":"#26a69a",
    "rejected": "#ef5350",
    "archived": "#546e7a",
}

# Standard test checklists per category
_CHECKLISTS: dict[str, list[str]] = {
    "strategy": [
        "Define entry conditions precisely and unambiguously",
        "Measure WR over ≥30 live trades in QTrade OS",
        "Check WR by session (Asian / London / NY)",
        "Check WR by regime (TRENDING / REVERTING / WEAK)",
        "Calculate Profit Factor and Expectancy per trade",
        "Measure max consecutive losses and recovery time",
        "Validate on a separate out-of-sample date range",
        "Compare to QField baseline as control group",
    ],
    "regime": [
        "Define the regime detection rule in precise code terms",
        "Label at least 100 historical bars with the regime",
        "Measure WR difference across regime states",
        "Check SC₁₀₀ correlation with identified regime",
        "Validate regime changes don't cause whipsaw entries",
        "Run against 6 months of M1 XAUUSD data minimum",
        "Compare regime-filtered vs unfiltered trade stats",
    ],
    "psychology": [
        "Identify the specific mistake type (FOMO / Revenge / Oversize)",
        "Quantify cost: PnL difference when mistake present vs absent",
        "Count mistake frequency per week over last 4 weeks",
        "Define a specific pre-trade checklist to prevent it",
        "Track for 2 weeks with daily journal entry",
        "Measure improvement in error rate after intervention",
    ],
    "risk": [
        "Calculate Kelly fraction from current WR and RR",
        "Verify daily loss limit is set and enforced in EA",
        "Measure max streak length from historical data",
        "Check drawdown correlation with session / regime",
        "Simulate portfolio-level VaR with current EA mix",
        "Confirm position sizing rule is machine-executed",
    ],
    "execution": [
        "Measure avg spread during target session window",
        "Compare PnL: actual fills vs theoretical entry prices",
        "Test session filter: is this session truly better?",
        "Count trades outside session window and their PnL",
        "Verify broker server time vs expected session times",
        "Measure slippage on SL hits vs planned SL prices",
    ],
    "ai_engineering": [
        "Define the ML task clearly (classification / regression / RL)",
        "Specify input features and target variable",
        "Establish a non-ML baseline to beat",
        "Plan train/val/test split avoiding lookahead bias",
        "Define evaluation metric aligned with trading objective",
        "Spec integration point with QTrade OS / EA code",
    ],
    "system_design": [
        "Document the data flow from source to output",
        "Define API contracts between components",
        "Specify error handling and failure modes",
        "Plan schema migration strategy for DB changes",
        "Test with real data before deploying to production",
        "Document run commands and environment requirements",
    ],
    "uncategorized": [
        "Clarify the main testable claim from this research",
        "Identify which QTrade OS data is needed to test it",
        "Set a specific success criterion (WR / PF / N target)",
        "Assign to the correct category after review",
    ],
}

# Hypothesis draft templates per category
_HYP_TEMPLATES: dict[str, str] = {
    "strategy": (
        "If the **{title}** setup conditions are applied to live XAUUSD M1 trading, "
        "then Win Rate > 55% and Profit Factor > 1.5 should be achievable over ≥30 trades.\n\n"
        "**Basis from research:** {insight}\n\n"
        "**Filter conditions to test:** (fill in EA, Symbol, Session, Regime)\n"
        "**Null hypothesis:** The setup produces WR ≤ 50% — no edge."
    ),
    "regime": (
        "In the regime condition identified by **{title}**, "
        "the market exhibits statistically distinct behavior measurable by WR/PF comparison "
        "against the overall baseline across ≥30 trades per regime state.\n\n"
        "**Basis from research:** {insight}\n\n"
        "**Test approach:** Filter trades by `regime` tag in QTrade OS DB and compare KPIs."
    ),
    "psychology": (
        "Eliminating the **{title}** behavioral pattern will improve net PnL "
        "by reducing loss-generating trades, measurable over a 4-week observation window.\n\n"
        "**Basis from research:** {insight}\n\n"
        "**Test approach:** Tag trades with mistake type in QTrade OS → compare annotated vs clean trades."
    ),
    "risk": (
        "Applying the **{title}** risk framework will reduce max drawdown "
        "without materially reducing net PnL, measurable over ≥60 trades.\n\n"
        "**Basis from research:** {insight}\n\n"
        "**Test approach:** Back-apply rule to historical trades and compare equity curves."
    ),
    "execution": (
        "Restricting trading to the **{title}** conditions (session/timing) "
        "will produce higher WR and PF than unconstrained trading over ≥30 comparable trades.\n\n"
        "**Basis from research:** {insight}\n\n"
        "**Test approach:** Filter trades by session tag and compare KPIs."
    ),
    "ai_engineering": (
        "The **{title}** AI/ML approach will produce a measurable predictive signal "
        "on XAUUSD M1 that outperforms a non-ML baseline by ≥5% AUC or equivalent metric.\n\n"
        "**Basis from research:** {insight}\n\n"
        "**Test approach:** Implement model, compare to baseline on held-out test set."
    ),
    "system_design": (
        "Implementing **{title}** will improve QTrade OS system reliability / efficiency "
        "by a measurable factor, validated by integration tests and production metrics.\n\n"
        "**Basis from research:** {insight}\n\n"
        "**Test approach:** Define benchmark before/after implementation."
    ),
    "uncategorized": (
        "**{title}** contains a testable trading insight. "
        "After classifying this research, a specific hypothesis will be formulated "
        "with WR / PF / N targets.\n\n"
        "**Basis from research:** {insight}\n\n"
        "**Next step:** Assign category → generate targeted hypothesis."
    ),
}


# ══════════════════════════════════════════════════════════════════════════════
# DB UTILS
# ══════════════════════════════════════════════════════════════════════════════

def _con() -> sqlite3.Connection:
    con = sqlite3.connect(DB_PATH)
    con.row_factory = sqlite3.Row
    return con


def _split_sql(sql: str) -> list[str]:
    stmts = []
    for stmt in sql.split(";"):
        lines = [l for l in stmt.splitlines() if not l.strip().startswith("--")]
        clean = " ".join(lines).strip()
        if clean:
            stmts.append(clean)
    return stmts


def run_migration() -> None:
    """Apply migrations 007 (research_inbox) and 008 (6-state lifecycle)."""
    con = _con()
    tables = {r[0] for r in con.execute(
        "SELECT name FROM sqlite_master WHERE type='table'"
    ).fetchall()}

    # 007: create research_inbox if missing
    if "research_inbox" not in tables:
        mig = BASE_DIR / "DATA" / "migrations" / "007_research_inbox.sql"
        if mig.exists():
            for stmt in _split_sql(mig.read_text(encoding="utf-8")):
                try:
                    con.execute(stmt)
                    con.commit()
                except sqlite3.Error:
                    pass

    # 008: upgrade to 6-state lifecycle + arena columns
    # Detect by checking if 'arena_id' column exists
    cols = {r[1] for r in con.execute("PRAGMA table_info(research_inbox)").fetchall()}
    if "arena_id" not in cols:
        mig8 = BASE_DIR / "DATA" / "migrations" / "008_research_6state.sql"
        if mig8.exists():
            for stmt in _split_sql(mig8.read_text(encoding="utf-8")):
                try:
                    con.execute(stmt)
                    con.commit()
                except sqlite3.Error:
                    pass

    con.close()


def _next_id() -> str:
    con = _con()
    n = con.execute("SELECT COUNT(*) FROM research_inbox").fetchone()[0]
    con.close()
    return f"RES-{n + 1:03d}"


def ensure_inbox_folder() -> Path:
    INBOX_DIR.mkdir(parents=True, exist_ok=True)
    readme = INBOX_DIR / "README.md"
    if not readme.exists():
        readme.write_text(
            "# 01_Inbox\n\nNew research items from NotebookLM, YouTube, "
            "articles, and PDFs.\nProcessed by QTrade OS Research Inbox dashboard.\n",
            encoding="utf-8",
        )
    return INBOX_DIR


# ══════════════════════════════════════════════════════════════════════════════
# AUTO-CLASSIFICATION
# ══════════════════════════════════════════════════════════════════════════════

def auto_classify(title: str, summary: str) -> str:
    """Classify into category by keyword scoring. Returns category string."""
    text = (title + " " + summary).lower()
    scores = {cat: sum(1 for kw in kws if kw in text)
              for cat, kws in _CATEGORY_KEYWORDS.items()}
    best = max(scores, key=scores.get)
    return best if scores[best] > 0 else "uncategorized"


def generate_tags(title: str, summary: str, category: str) -> list[str]:
    """Generate relevant tags from title, summary, and category."""
    tags = [category, "research"]
    text = (title + " " + summary).lower()

    tag_map = {
        "xauusd": "xauusd", "gold": "xauusd", "qfield": "qfield",
        "london": "london", "new york": "ny-session", "asian": "asian-session",
        "trending": "trending", "reverting": "reverting", "crash": "crash",
        "mql5": "mql5", "ea": "ea", "backtest": "backtest",
        "sc100": "sc100", "sc₁₀₀": "sc100",
        "smc": "smc", "ict": "ict", "fvg": "fvg",
        "rsi": "rsi", "ema": "ema", "breakout": "breakout",
    }
    for keyword, tag in tag_map.items():
        if keyword in text and tag not in tags:
            tags.append(tag)

    return tags[:8]


# ══════════════════════════════════════════════════════════════════════════════
# CONTENT GENERATION
# ══════════════════════════════════════════════════════════════════════════════

def extract_key_insights(summary: str, max_n: int = 5) -> list[str]:
    """Extract key insight sentences from a summary block."""
    if not summary:
        return []
    sentences = re.split(r'(?<=[.!?])\s+', summary.strip())
    insights = [s.strip() for s in sentences if len(s.strip()) > 30]
    return insights[:max_n]


def extract_action_items(summary: str, max_n: int = 5) -> list[str]:
    """Extract actionable sentences from summary text."""
    if not summary:
        return []
    triggers = [
        "should", "need to", "must", "test", "verify", "check",
        "validate", "investigate", "measure", "backtest", "track",
        "consider", "implement", "try", "experiment",
    ]
    sentences = re.split(r'(?<=[.!?])\s+', summary.strip())
    actions = []
    for s in sentences:
        s = s.strip()
        if len(s) > 20 and any(t in s.lower() for t in triggers):
            # Clean up and make it action-oriented
            if not s.startswith(("Test", "Check", "Verify", "Validate", "Measure")):
                actions.append(s)
            else:
                actions.append(s)
    # Fallback: if no triggers found, take first 3 sentences as generic actions
    if not actions and sentences:
        actions = [f"Review: {s.strip()}" for s in sentences[:3] if len(s.strip()) > 20]
    return actions[:max_n]


def generate_hypothesis_draft(title: str, summary: str, category: str) -> str:
    """Generate a structured hypothesis draft from research content."""
    insights = extract_key_insights(summary, max_n=1)
    insight_text = insights[0] if insights else (
        "See full summary above for evidence basis."
    )
    template = _HYP_TEMPLATES.get(category, _HYP_TEMPLATES["uncategorized"])
    return template.format(title=title, insight=insight_text)


def generate_test_checklist(category: str) -> list[str]:
    """Return the standard test checklist for a category."""
    return _CHECKLISTS.get(category, _CHECKLISTS["uncategorized"])


# ══════════════════════════════════════════════════════════════════════════════
# CRUD — RESEARCH INBOX
# ══════════════════════════════════════════════════════════════════════════════

def ingest_research(
    title: str,
    source_url: str = "",
    source_type: str = "notebooklm",
    summary: str = "",
    raw_notes: str = "",
    category: str | None = None,
    tags: list[str] | None = None,
) -> tuple[bool, str, str]:
    """
    Ingest a research item into the inbox.
    Auto-classifies, generates content, writes note.
    Returns (ok, item_id, message).
    """
    run_migration()
    ensure_inbox_folder()

    if not title.strip():
        return False, "", "Title is required"

    # Auto-classify if not provided
    cat = category if (category and category in CATEGORIES) else auto_classify(title, summary)

    # Generate content
    insights    = extract_key_insights(summary)
    actions     = extract_action_items(summary)
    checklist   = generate_test_checklist(cat)
    hyp_draft   = generate_hypothesis_draft(title, summary, cat)
    auto_tags   = tags if tags else generate_tags(title, summary, cat)

    item_id = _next_id()

    item = {
        "item_id":         item_id,
        "title":           title.strip(),
        "source_type":     source_type,
        "source_url":      source_url.strip() or None,
        "summary":         summary.strip() or None,
        "raw_notes":       raw_notes.strip() or None,
        "category":        cat,
        "tags":            ",".join(auto_tags),
        "hypothesis_draft": hyp_draft,
        "action_items":    json.dumps(actions),
        "test_checklist":  json.dumps(checklist),
        "key_insights":    json.dumps(insights),
    }

    # Write vault note
    note_path = _write_inbox_note(item, actions, checklist, insights)
    item["note_path"] = str(note_path.relative_to(BASE_DIR))

    con = _con()
    try:
        con.execute("""
            INSERT INTO research_inbox
              (item_id, title, source_type, source_url, summary, raw_notes,
               category, tags, hypothesis_draft, action_items, test_checklist,
               key_insights, note_path)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)
        """, (
            item["item_id"], item["title"], item["source_type"], item["source_url"],
            item["summary"], item["raw_notes"], item["category"], item["tags"],
            item["hypothesis_draft"], item["action_items"], item["test_checklist"],
            item["key_insights"], item["note_path"],
        ))
        # Insert action items into research_actions table
        for action_text in actions:
            con.execute("""
                INSERT INTO research_actions (item_id, action_text, action_type)
                VALUES (?, ?, 'todo')
            """, (item_id, action_text))
        con.commit()
        return True, item_id, f"Ingested {item_id}: {title[:50]}"
    except sqlite3.Error as e:
        return False, "", str(e)
    finally:
        con.close()


def get_inbox_items(status: str | None = None, category: str | None = None) -> pd.DataFrame:
    run_migration()
    con = _con()
    sql, params = "SELECT * FROM research_inbox", []
    clauses = []
    if status:
        clauses.append("status = ?"); params.append(status)
    if category:
        clauses.append("category = ?"); params.append(category)
    if clauses:
        sql += " WHERE " + " AND ".join(clauses)
    sql += " ORDER BY created_at DESC"
    df = pd.read_sql_query(sql, con, params=params)
    con.close()
    return df


def get_item(item_id: str) -> dict | None:
    run_migration()
    con = _con()
    row = con.execute("SELECT * FROM research_inbox WHERE item_id=?", (item_id,)).fetchone()
    con.close()
    return dict(row) if row else None


def update_item_status(item_id: str, new_status: str) -> tuple[bool, str]:
    if new_status not in STATUSES:
        return False, f"Invalid status: {new_status}"
    con = _con()
    extras = ""
    if new_status in ("reviewing", "testing"):
        extras = ", processed_at=datetime('now')"
    elif new_status == "archived":
        extras = ", archived_at=datetime('now')"
    con.execute(
        f"UPDATE research_inbox SET status=?{extras} WHERE item_id=?",
        (new_status, item_id),
    )
    con.commit()
    con.close()
    return True, f"{item_id} → {new_status}"


def convert_to_hypothesis(
    item_id: str,
    ea_name: str | None = None,
    symbol: str | None = None,
    session: str | None = None,
    regime: str | None = None,
    target_wr: float | None = None,
    target_pf: float | None = None,
    min_trades: int = 30,
) -> tuple[bool, str, str]:
    """
    Create a hypothesis from a research inbox item.
    Returns (ok, hyp_id, message).
    """
    item = get_item(item_id)
    if not item:
        return False, "", f"{item_id} not found"

    # Import here to avoid circular imports
    from hypothesis_tracker import create_hypothesis
    ok, hyp_id, msg = create_hypothesis(
        title         = item["title"],
        description   = item.get("hypothesis_draft") or "",
        rationale     = (item.get("summary") or "")[:500],
        ea_name       = ea_name,
        symbol        = symbol,
        session       = session,
        regime        = regime,
        target_wr     = target_wr,
        target_pf     = target_pf,
        min_trades    = min_trades,
        notes         = f"Converted from research {item_id}",
        source_note   = item.get("note_path") or "",
    )
    if ok:
        con = _con()
        con.execute(
            "UPDATE research_inbox SET hyp_id=?, status='reviewing' WHERE item_id=?",
            (hyp_id, item_id),
        )
        con.commit()
        con.close()
    return ok, hyp_id, msg


def link_to_strategy(item_id: str, ea_name: str) -> tuple[bool, str]:
    con = _con()
    con.execute("UPDATE research_inbox SET ea_link=? WHERE item_id=?", (ea_name, item_id))
    con.commit()
    con.close()
    return True, f"{item_id} linked to {ea_name}"


# ══════════════════════════════════════════════════════════════════════════════
# CRUD — RESEARCH ACTIONS
# ══════════════════════════════════════════════════════════════════════════════

def add_action(
    item_id: str, action_text: str,
    action_type: str = "todo", priority: int = 2,
) -> tuple[bool, int, str]:
    con = _con()
    try:
        cur = con.execute("""
            INSERT INTO research_actions (item_id, action_text, action_type, priority)
            VALUES (?,?,?,?)
        """, (item_id, action_text.strip(), action_type, priority))
        con.commit()
        return True, cur.lastrowid, "Action added"
    except sqlite3.Error as e:
        return False, 0, str(e)
    finally:
        con.close()


def get_actions(item_id: str) -> pd.DataFrame:
    con = _con()
    df = pd.read_sql_query(
        "SELECT * FROM research_actions WHERE item_id=? ORDER BY priority, created_at",
        con, params=(item_id,),
    )
    con.close()
    return df


def get_all_actions(completed: bool | None = None) -> pd.DataFrame:
    con = _con()
    sql = """
        SELECT ra.*, ri.title as item_title, ri.category
        FROM research_actions ra
        JOIN research_inbox ri ON ra.item_id = ri.item_id
    """
    params = []
    if completed is not None:
        sql += " WHERE ra.completed = ?"; params.append(1 if completed else 0)
    sql += " ORDER BY ra.priority, ra.created_at"
    df = pd.read_sql_query(sql, con, params=params)
    con.close()
    return df


def complete_action(action_id: int) -> tuple[bool, str]:
    con = _con()
    con.execute("""
        UPDATE research_actions
        SET completed=1, completed_at=datetime('now')
        WHERE action_id=?
    """, (action_id,))
    con.commit()
    con.close()
    return True, f"Action {action_id} completed"


def reopen_action(action_id: int) -> tuple[bool, str]:
    con = _con()
    con.execute(
        "UPDATE research_actions SET completed=0, completed_at=NULL WHERE action_id=?",
        (action_id,),
    )
    con.commit()
    con.close()
    return True, f"Action {action_id} reopened"


# ══════════════════════════════════════════════════════════════════════════════
# VAULT NOTE WRITER
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


def _write_inbox_note(
    item: dict,
    actions: list[str],
    checklist: list[str],
    insights: list[str],
) -> Path:
    ensure_inbox_folder()
    slug = re.sub(r"[^a-zA-Z0-9_-]", "_", item["title"])[:50]
    path = INBOX_DIR / f"{item['item_id']}_{slug}.md"

    tags_list = [t.strip() for t in (item.get("tags") or "").split(",") if t.strip()]
    source_url = item.get("source_url") or ""
    today = date.today().isoformat()

    content = _fm({
        "type":        "research_inbox",
        "item_id":     item["item_id"],
        "title":       item["title"],
        "source_type": item["source_type"],
        "source_url":  source_url,
        "category":    item["category"],
        "status":      "inbox",
        "created":     today,
        "tags":        tags_list,
    })

    icon = SOURCE_ICONS.get(item["source_type"], "🔗")
    cat_label = CATEGORY_LABELS.get(item["category"], "📁 Uncategorized")

    content += f"# {item['item_id']}: {item['title']}\n\n"
    content += f"> {icon} **{item['source_type'].upper()}** · {cat_label} · {today}\n\n"

    if source_url:
        content += f"## Source\n[Open Source]({source_url})\n\n"

    if item.get("summary"):
        content += f"## Summary\n{item['summary']}\n\n"

    if insights:
        content += "## Key Insights\n"
        for ins in insights:
            content += f"- {ins}\n"
        content += "\n"

    content += "## Hypothesis Draft\n"
    content += f"{item.get('hypothesis_draft') or 'No draft generated.'}\n\n"

    content += "## Action Items\n"
    if actions:
        for a in actions:
            content += f"- [ ] {a}\n"
    else:
        content += "- [ ] Review summary and extract testable claims\n"
    content += "\n"

    content += "## Test Checklist\n"
    for c in checklist:
        content += f"- [ ] {c}\n"
    content += "\n"

    if item.get("raw_notes"):
        content += f"## Raw Notes\n{item['raw_notes']}\n\n"

    content += "## Safety Gate\n"
    content += (
        "Research is **informational only**. "
        "To act on this research, convert to a Hypothesis in QTrade OS dashboard, "
        "collect ≥30 trades of evidence, and validate before any EA change.\n"
    )

    path.write_text(content, encoding="utf-8")
    return path


# ══════════════════════════════════════════════════════════════════════════════
# ANALYTICS
# ══════════════════════════════════════════════════════════════════════════════

def inbox_summary() -> dict:
    """Return count by status and category for dashboard header."""
    run_migration()
    con = _con()
    status_counts = dict(con.execute(
        "SELECT status, COUNT(*) FROM research_inbox GROUP BY status"
    ).fetchall())
    cat_counts = dict(con.execute(
        "SELECT category, COUNT(*) FROM research_inbox GROUP BY category"
    ).fetchall())
    total_actions = con.execute("SELECT COUNT(*) FROM research_actions").fetchone()[0]
    pending_actions = con.execute(
        "SELECT COUNT(*) FROM research_actions WHERE completed=0"
    ).fetchone()[0]
    con.close()
    return {
        "by_status": status_counts,
        "by_category": cat_counts,
        "total_actions": total_actions,
        "pending_actions": pending_actions,
    }
