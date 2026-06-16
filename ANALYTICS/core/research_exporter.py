"""
research_exporter.py - Obsidian research intelligence export layer.

This module keeps research knowledge in Markdown while using the trading
database as the source of truth for measured behavior. It creates durable
Obsidian notes for strategies, symbols, sessions, regimes, mistakes, trades,
and AI-ready insight exports.
"""

from __future__ import annotations

import json
import re
import sqlite3
from collections import Counter, defaultdict
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any

import pandas as pd

BASE_DIR = Path(__file__).resolve().parents[2]
RESEARCH_DIR = BASE_DIR / "10_Research"


FOLDERS: dict[str, str] = {
    "00_Inbox": "Raw NotebookLM summaries and unprocessed research notes.",
    "01_Strategies": "One living intelligence page per strategy or EA.",
    "02_Sessions": "Session playbooks linked to measured session performance.",
    "03_Symbols": "Symbol intelligence pages linked to strategies and regimes.",
    "04_Regimes": "Market regime library with rules and measured outcomes.",
    "05_Analytics_Insights": "Point-in-time analytics exports from the dashboard.",
    "06_Trade_Links": "Trade-level notes that connect execution to research.",
    "07_Mistake_Library": "Mistake patterns, causes, fixes, and trade evidence.",
    "08_AI_Exports": "AI-ready packets for review, synthesis, and action planning.",
    "09_Source_Notes": "Cleaned research sources after inbox triage.",
    "10_Test_Ideas": "Backtest-ready hypotheses extracted from research.",
    "Templates": "Markdown templates with YAML frontmatter.",
    "_Indexes": "Maps of content and generated research indexes.",
}

SESSION_ORDER = ["Asian", "London", "Pre_NY", "London_NY", "NY", "Other"]
REGIME_ORDER = ["TRENDING", "REVERTING", "WEAK", "CRASH", "UNKNOWN"]


TEMPLATES: dict[str, str] = {
    "Research_Note_Template.md": """---
type: research_note
status: untested
created: {{date}}
source: ""
source_type: notebooklm
source_url: ""
strategies: []
symbols: []
sessions: []
regimes: []
mistakes: []
idea_status: untested
tags:
  - research
  - trading-intelligence
---

# {{title}}

## Actionable Ideas
- 

## Trading Links
- Strategies:
- Symbols:
- Sessions:
- Regimes:
- Mistakes:

## Evidence
- 

## Next Action
- 
""",
    "Research_Idea_Template.md": """---
type: research_idea
status: untested
idea_status: untested
created: {{date}}
source: ""
source_type: manual
source_url: ""
strategies: []
symbols: []
sessions: []
regimes: []
linked_ea_performance: []
tags:
  - research-idea
  - trading-intelligence
---

# Research Idea - {{title}}

## Concept
- 

## Trading Rules
- 

## Market Condition
- 

## Entry Logic
- 

## Exit Logic
- 

## Risk Logic
- 

## Strengths
- 

## Weaknesses
- 

## Testable Hypothesis
- 

## Backtest Ideas
- 

## Linked Intelligence
- Strategies:
- Sessions:
- Symbols:
- Regimes:
- EA performance:

## Review Decision
- Keep status as `untested` until backtest evidence exists.
""",
    "Strategy_Intelligence_Template.md": """---
type: strategy_intelligence
status: active
strategy: "{{strategy}}"
symbols: []
sessions: []
regimes: []
linked_research: []
tags:
  - strategy
  - trading-intelligence
---

# Strategy - {{strategy}}

## Operating Rules
- 

## Best Conditions
- 

## Avoid Conditions
- 

## Analytics Snapshot
- Trades:
- Win rate:
- Profit factor:
- Expectancy:
- Net PnL:

## Linked Knowledge
- Sessions:
- Symbols:
- Regimes:
- Mistakes:
- Research:

## Decision Updates
- 
""",
    "Analytics_Insight_Template.md": """---
type: analytics_insight
status: generated
created: {{date}}
scope: ""
strategies: []
symbols: []
sessions: []
regimes: []
tags:
  - analytics-insight
  - trading-intelligence
---

# Analytics Insight - {{date}}

## What Changed
- 

## Evidence
- 

## Action
- 

## Links
- 
""",
    "Trade_Link_Template.md": """---
type: trade_link
status: review
trade_id: "{{trade_id}}"
strategy: ""
symbol: ""
session: ""
regime: ""
outcome: ""
mistakes: []
linked_research: []
tags:
  - trade-link
  - trading-intelligence
---

# Trade - {{trade_id}}

## Execution Facts
- 

## Research Links
- 

## Lesson
- 
""",
    "Mistake_Knowledge_Template.md": """---
type: mistake_knowledge
status: active
mistake: "{{mistake}}"
linked_strategies: []
linked_symbols: []
linked_sessions: []
linked_regimes: []
tags:
  - mistake-library
  - trading-intelligence
---

# Mistake - {{mistake}}

## Pattern
- 

## Cost Evidence
- Count:
- Net PnL:
- Avg PnL:

## Prevention Rule
- 

## Trade Evidence
- 
""",
    "Regime_Knowledge_Template.md": """---
type: regime_knowledge
status: active
regime: "{{regime}}"
linked_strategies: []
linked_symbols: []
linked_sessions: []
tags:
  - regime-library
  - trading-intelligence
---

# Regime - {{regime}}

## Definition
- 

## What Works
- 

## What Fails
- 

## Analytics Evidence
- 

## Research Links
- 
""",
}


@dataclass
class ExportResult:
    written: list[Path]
    skipped: list[Path]
    updated_trade_links: int = 0

    def as_dict(self) -> dict[str, Any]:
        return {
            "written": [str(p.relative_to(BASE_DIR)) for p in self.written],
            "skipped": [str(p.relative_to(BASE_DIR)) for p in self.skipped],
            "updated_trade_links": self.updated_trade_links,
        }


def _cfg() -> dict[str, Any]:
    path = BASE_DIR / "SYSTEM" / "config" / "system_config.json"
    if not path.exists():
        return {}
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def _db_path() -> Path:
    return BASE_DIR / _cfg().get("db", {}).get("trades_db", "DATA/processed/trades.sqlite")


def _connect() -> sqlite3.Connection:
    con = sqlite3.connect(_db_path())
    con.row_factory = sqlite3.Row
    return con


def slugify(value: Any) -> str:
    text = str(value or "Unknown").strip()
    text = re.sub(r"[^\w\s.-]+", "", text, flags=re.UNICODE)
    text = re.sub(r"\s+", "_", text)
    return text.strip("._") or "Unknown"


def wikilink(folder: str, name: Any, label: str | None = None) -> str:
    note = slugify(name)
    display = label or str(name)
    return f"[[10_Research/{folder}/{note}|{display}]]"


def _yaml_value(value: Any) -> str:
    if value is None:
        return "null"
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, (int, float)):
        return str(value)
    text = str(value).replace('"', '\\"')
    return f'"{text}"'


def frontmatter(data: dict[str, Any]) -> str:
    lines = ["---"]
    for key, value in data.items():
        if isinstance(value, list):
            if value:
                lines.append(f"{key}:")
                for item in value:
                    lines.append(f"  - {_yaml_value(item)}")
            else:
                lines.append(f"{key}: []")
        else:
            lines.append(f"{key}: {_yaml_value(value)}")
    lines.append("---")
    return "\n".join(lines) + "\n\n"


def ensure_vault_structure(write_templates: bool = True) -> list[Path]:
    created: list[Path] = []
    RESEARCH_DIR.mkdir(exist_ok=True)
    for folder, description in FOLDERS.items():
        path = RESEARCH_DIR / folder
        path.mkdir(parents=True, exist_ok=True)
        readme = path / "README.md"
        if not readme.exists():
            readme.write_text(f"# {folder}\n\n{description}\n", encoding="utf-8")
            created.append(readme)

    if write_templates:
        today = datetime.now().date().isoformat()
        for name, body in TEMPLATES.items():
            path = RESEARCH_DIR / "Templates" / name
            if not path.exists():
                path.write_text(body.replace("{{date}}", today), encoding="utf-8")
                created.append(path)
    return created


def load_trades_from_db() -> pd.DataFrame:
    db = _db_path()
    if not db.exists():
        return pd.DataFrame()
    con = _connect()
    try:
        df = pd.read_sql_query("SELECT * FROM trades ORDER BY open_time", con)
    finally:
        con.close()
    if df.empty:
        return df
    for col in ("open_time", "close_time"):
        if col in df.columns:
            df[col] = pd.to_datetime(df[col], errors="coerce")
    for col in ("pnl_usd", "rr_actual", "duration_min", "execution_score", "setup_quality"):
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")
    df["is_win"] = (df["outcome"] == "WIN").astype(int)
    return df


def _split_mistakes(value: Any) -> list[str]:
    if value is None or pd.isna(value):
        return []
    return [m.strip() for m in str(value).split("|") if m.strip()]


def _safe_mean(series: pd.Series) -> float | None:
    series = pd.to_numeric(series, errors="coerce").dropna()
    if series.empty:
        return None
    return float(series.mean())


def _profit_factor(group: pd.DataFrame) -> float | None:
    wins = group.loc[group["outcome"] == "WIN", "pnl_usd"].sum()
    losses = group.loc[group["outcome"] == "LOSS", "pnl_usd"].sum()
    if losses == 0:
        return None
    return round(abs(float(wins) / float(losses)), 3)


def _group_metrics(group: pd.DataFrame) -> dict[str, Any]:
    total = int(len(group))
    wins = int((group["outcome"] == "WIN").sum())
    losses = int((group["outcome"] == "LOSS").sum())
    net = float(group["pnl_usd"].sum()) if "pnl_usd" in group else 0.0
    return {
        "trades": total,
        "wins": wins,
        "losses": losses,
        "win_rate": round(wins / total, 4) if total else None,
        "profit_factor": _profit_factor(group),
        "expectancy": round(float(group["pnl_usd"].mean()), 2) if total else None,
        "net_pnl": round(net, 2),
        "avg_rr": round(_safe_mean(group.get("rr_actual", pd.Series(dtype=float))) or 0.0, 3),
    }


def scan_research_notes() -> pd.DataFrame:
    """Return Markdown notes with inferred tags and frontmatter-ish fields."""
    rows: list[dict[str, Any]] = []
    if not RESEARCH_DIR.exists():
        return pd.DataFrame()

    for path in RESEARCH_DIR.rglob("*.md"):
        if path.name == "README.md":
            continue
        text = path.read_text(encoding="utf-8", errors="ignore")
        fm = _parse_frontmatter(text)
        tags = set()
        raw_tags = fm.get("tags", [])
        if isinstance(raw_tags, list):
            tags.update(str(t).lower() for t in raw_tags)
        for token in re.findall(r"#([A-Za-z0-9_/-]+)", text):
            tags.add(token.lower())
        rows.append({
            "path": path,
            "name": path.stem,
            "folder": str(path.parent.relative_to(RESEARCH_DIR)),
            "type": fm.get("type", "research_note"),
            "status": fm.get("status", ""),
            "tags": sorted(tags),
            "text_lc": text.lower(),
        })
    return pd.DataFrame(rows)


def _parse_frontmatter(text: str) -> dict[str, Any]:
    if not text.startswith("---"):
        return {}
    parts = text.split("---", 2)
    if len(parts) < 3:
        return {}
    data: dict[str, Any] = {}
    current_key: str | None = None
    for raw in parts[1].splitlines():
        line = raw.rstrip()
        if not line.strip():
            continue
        if line.startswith("  - ") and current_key:
            data.setdefault(current_key, []).append(line[4:].strip().strip('"'))
            continue
        if ":" in line:
            key, value = line.split(":", 1)
            key = key.strip()
            value = value.strip()
            current_key = key
            if value == "":
                data[key] = []
            elif value == "[]":
                data[key] = []
            else:
                data[key] = value.strip('"')
    return data


def _linked_research(notes: pd.DataFrame, terms: list[Any], limit: int = 8) -> list[str]:
    if notes.empty:
        return []
    scored: list[tuple[int, str]] = []
    terms_lc = [str(t).lower() for t in terms if t and str(t).lower() != "nan"]
    for _, row in notes.iterrows():
        haystack = f"{row['name'].lower()} {row.get('text_lc', '')}"
        score = sum(1 for term in terms_lc if term in haystack)
        if score:
            rel = row["path"].relative_to(BASE_DIR).with_suffix("").as_posix()
            scored.append((score, f"[[{rel}|{row['name']}]]"))
    scored.sort(key=lambda item: (-item[0], item[1]))
    return [link for _, link in scored[:limit]]


def _write(path: Path, content: str, overwrite: bool) -> tuple[bool, Path]:
    path.parent.mkdir(parents=True, exist_ok=True)
    if path.exists() and not overwrite:
        return False, path
    path.write_text(content, encoding="utf-8")
    return True, path


def export_strategy_pages(df: pd.DataFrame, notes: pd.DataFrame, overwrite: bool = True) -> ExportResult:
    result = ExportResult([], [])
    if df.empty or "strategy" not in df:
        return result

    for strategy, group in df.groupby("strategy", dropna=True):
        metrics = _group_metrics(group)
        symbols = sorted(group["symbol"].dropna().astype(str).unique().tolist()) if "symbol" in group else []
        sessions = sorted(group["session"].dropna().astype(str).unique().tolist()) if "session" in group else []
        regimes = sorted(group["regime"].dropna().astype(str).unique().tolist()) if "regime" in group else []
        mistakes = Counter(m for value in group.get("mistakes", pd.Series(dtype=str)).dropna() for m in _split_mistakes(value))
        linked = _linked_research(notes, [strategy] + symbols + sessions + regimes + list(mistakes.keys()))

        best_session = _best_dimension(group, "session")
        best_symbol = _best_dimension(group, "symbol")
        best_regime = _best_dimension(group, "regime")

        body = frontmatter({
            "type": "strategy_intelligence",
            "status": "active",
            "strategy": strategy,
            "symbols": symbols,
            "sessions": sessions,
            "regimes": regimes,
            "linked_research": linked,
            "generated_at": datetime.now().isoformat(timespec="seconds"),
            "tags": ["strategy", "trading-intelligence", f"strategy/{slugify(strategy).lower()}"],
        })
        body += f"# Strategy - {strategy}\n\n"
        body += "## Analytics Snapshot\n"
        body += _metric_bullets(metrics)
        body += "\n## Best Operating Conditions\n"
        body += f"- Session: {best_session}\n- Symbol: {best_symbol}\n- Regime: {best_regime}\n"
        body += "\n## Risk Flags\n"
        if mistakes:
            for name, count in mistakes.most_common(5):
                body += f"- {wikilink('07_Mistake_Library', name, name)}: {count} tagged trades\n"
        else:
            body += "- No tagged mistakes yet. Annotation coverage is the next bottleneck.\n"
        body += "\n## Linked Knowledge\n"
        body += _link_list("Sessions", "02_Sessions", sessions)
        body += _link_list("Symbols", "03_Symbols", symbols)
        body += _link_list("Regimes", "04_Regimes", regimes)
        body += _plain_link_list("Research", linked)
        body += "\n## Decision Updates\n- Review after each weekly export.\n"

        ok, path = _write(RESEARCH_DIR / "01_Strategies" / f"{slugify(strategy)}.md", body, overwrite)
        (result.written if ok else result.skipped).append(path)
    return result


def _best_dimension(group: pd.DataFrame, dim: str) -> str:
    if dim not in group or group[dim].dropna().empty:
        return "Unknown"
    rows = []
    for key, sub in group.groupby(dim, dropna=True):
        if len(sub) < 3:
            continue
        rows.append((float(sub["pnl_usd"].mean()), int(len(sub)), str(key)))
    if not rows:
        return "Needs more data"
    rows.sort(key=lambda x: (x[0], x[1]), reverse=True)
    return f"{rows[0][2]} ({rows[0][1]} trades, avg PnL {rows[0][0]:.2f})"


def _metric_bullets(metrics: dict[str, Any]) -> str:
    return (
        f"- Trades: {metrics.get('trades', 0)}\n"
        f"- Win rate: {_pct(metrics.get('win_rate'))}\n"
        f"- Profit factor: {metrics.get('profit_factor') or 'inf'}\n"
        f"- Expectancy: {metrics.get('expectancy')}\n"
        f"- Net PnL: {metrics.get('net_pnl')}\n"
        f"- Avg RR: {metrics.get('avg_rr')}\n"
    )


def _pct(value: Any) -> str:
    if value is None:
        return "n/a"
    return f"{float(value) * 100:.1f}%"


def _link_list(title: str, folder: str, values: list[str]) -> str:
    body = f"- {title}: "
    if not values:
        return body + "None yet\n"
    return body + ", ".join(wikilink(folder, v, v) for v in values) + "\n"


def _plain_link_list(title: str, links: list[str]) -> str:
    body = f"- {title}: "
    return body + (", ".join(links) if links else "No direct note matches yet") + "\n"


def export_dimension_pages(df: pd.DataFrame, notes: pd.DataFrame, overwrite: bool = True) -> ExportResult:
    result = ExportResult([], [])
    specs = [
        ("session", "02_Sessions", SESSION_ORDER, "session_intelligence", "session"),
        ("symbol", "03_Symbols", None, "symbol_intelligence", "symbol"),
        ("regime", "04_Regimes", REGIME_ORDER, "regime_knowledge", "regime"),
    ]
    for col, folder, order, note_type, tag in specs:
        if df.empty or col not in df:
            continue
        values = [v for v in (order or sorted(df[col].dropna().astype(str).unique().tolist())) if v in set(df[col].dropna().astype(str))]
        for value in values:
            group = df[df[col].astype(str) == str(value)]
            if group.empty:
                continue
            metrics = _group_metrics(group)
            strategies = sorted(group["strategy"].dropna().astype(str).unique().tolist()) if "strategy" in group else []
            symbols = sorted(group["symbol"].dropna().astype(str).unique().tolist()) if "symbol" in group else []
            sessions = sorted(group["session"].dropna().astype(str).unique().tolist()) if "session" in group else []
            regimes = sorted(group["regime"].dropna().astype(str).unique().tolist()) if "regime" in group else []
            linked = _linked_research(notes, [value] + strategies + symbols + sessions + regimes)

            body = frontmatter({
                "type": note_type,
                "status": "active",
                tag: value,
                "linked_strategies": strategies,
                "linked_symbols": symbols,
                "linked_sessions": sessions,
                "linked_regimes": regimes,
                "linked_research": linked,
                "generated_at": datetime.now().isoformat(timespec="seconds"),
                "tags": [tag, "trading-intelligence", f"{tag}/{slugify(value).lower()}"],
            })
            body += f"# {tag.title()} - {value}\n\n"
            body += "## Analytics Evidence\n"
            body += _metric_bullets(metrics)
            body += "\n## Strategy Links\n"
            body += "".join(f"- {wikilink('01_Strategies', s, s)}\n" for s in strategies) or "- None yet\n"
            body += "\n## Research Links\n"
            body += "".join(f"- {link}\n" for link in linked) or "- No direct note matches yet\n"
            body += "\n## Operating Guidance\n"
            if metrics.get("expectancy", 0) and metrics["expectancy"] > 0:
                body += "- Keep this condition in the active playbook; validate with new trades weekly.\n"
            else:
                body += "- Treat as caution until more evidence improves expectancy.\n"

            ok, path = _write(RESEARCH_DIR / folder / f"{slugify(value)}.md", body, overwrite)
            (result.written if ok else result.skipped).append(path)
    return result


def export_mistake_library(df: pd.DataFrame, notes: pd.DataFrame, overwrite: bool = True) -> ExportResult:
    result = ExportResult([], [])
    if df.empty or "mistakes" not in df:
        return result

    exploded = []
    for _, row in df[df["mistakes"].notna()].iterrows():
        for mistake in _split_mistakes(row.get("mistakes")):
            item = row.to_dict()
            item["mistake"] = mistake
            exploded.append(item)
    if not exploded:
        return result

    ex = pd.DataFrame(exploded)
    for mistake, group in ex.groupby("mistake", dropna=True):
        metrics = _group_metrics(group)
        strategies = sorted(group["strategy"].dropna().astype(str).unique().tolist())
        symbols = sorted(group["symbol"].dropna().astype(str).unique().tolist())
        sessions = sorted(group["session"].dropna().astype(str).unique().tolist())
        regimes = sorted(group["regime"].dropna().astype(str).unique().tolist())
        linked = _linked_research(notes, [mistake] + strategies + symbols + sessions + regimes)
        recent = group.sort_values("open_time", ascending=False).head(8)

        body = frontmatter({
            "type": "mistake_knowledge",
            "status": "active",
            "mistake": mistake,
            "linked_strategies": strategies,
            "linked_symbols": symbols,
            "linked_sessions": sessions,
            "linked_regimes": regimes,
            "generated_at": datetime.now().isoformat(timespec="seconds"),
            "tags": ["mistake-library", "trading-intelligence", f"mistake/{slugify(mistake).lower()}"],
        })
        body += f"# Mistake - {mistake}\n\n"
        body += "## Cost Evidence\n"
        body += _metric_bullets(metrics)
        body += "\n## Where It Appears\n"
        body += _link_list("Strategies", "01_Strategies", strategies)
        body += _link_list("Symbols", "03_Symbols", symbols)
        body += _link_list("Sessions", "02_Sessions", sessions)
        body += _link_list("Regimes", "04_Regimes", regimes)
        body += "\n## Prevention Rule\n- Add one concrete rule after reviewing the linked losing trades.\n"
        body += "\n## Trade Evidence\n"
        for _, trade in recent.iterrows():
            label = f"{trade.get('trade_id')} {trade.get('symbol')} {trade.get('outcome')} {trade.get('pnl_usd')}"
            body += f"- {wikilink('06_Trade_Links', trade.get('trade_id'), label)}\n"
        body += "\n## Research Links\n"
        body += "".join(f"- {link}\n" for link in linked) or "- No direct note matches yet\n"

        ok, path = _write(RESEARCH_DIR / "07_Mistake_Library" / f"{slugify(mistake)}.md", body, overwrite)
        (result.written if ok else result.skipped).append(path)
    return result


def export_trade_links(
    df: pd.DataFrame,
    notes: pd.DataFrame,
    overwrite: bool = True,
    limit: int = 100,
    annotated_only: bool = True,
) -> ExportResult:
    result = ExportResult([], [])
    if df.empty or "trade_id" not in df:
        return result

    work = df.copy()
    if annotated_only:
        mask = pd.Series(False, index=work.index)
        for col in ("emotional_state", "mistakes", "notes", "journal_entry"):
            if col in work:
                mask = mask | work[col].notna()
        work = work[mask]
    work = work.sort_values("open_time", ascending=False).head(limit)

    journal_updates: list[tuple[str, str]] = []
    for _, trade in work.iterrows():
        trade_id = trade.get("trade_id")
        if not trade_id:
            continue
        strategy = trade.get("strategy")
        symbol = trade.get("symbol")
        session = trade.get("session")
        regime = trade.get("regime")
        mistakes = _split_mistakes(trade.get("mistakes"))
        linked = _linked_research(notes, [strategy, symbol, session, regime] + mistakes)
        open_date = ""
        if pd.notna(trade.get("open_time")):
            open_date = pd.to_datetime(trade.get("open_time")).date().isoformat()

        body = frontmatter({
            "type": "trade_link",
            "status": "review",
            "trade_id": trade_id,
            "strategy": strategy,
            "symbol": symbol,
            "session": session,
            "regime": regime,
            "outcome": trade.get("outcome"),
            "pnl_usd": round(float(trade.get("pnl_usd") or 0), 2),
            "open_date": open_date,
            "mistakes": mistakes,
            "linked_research": linked,
            "tags": ["trade-link", "trading-intelligence", f"strategy/{slugify(strategy).lower()}"],
        })
        body += f"# Trade - {trade_id}\n\n"
        body += "## Execution Facts\n"
        body += f"- Strategy: {wikilink('01_Strategies', strategy, strategy)}\n"
        body += f"- Symbol: {wikilink('03_Symbols', symbol, symbol)}\n"
        body += f"- Session: {wikilink('02_Sessions', session, session)}\n"
        body += f"- Regime: {wikilink('04_Regimes', regime, regime)}\n"
        body += f"- Outcome: {trade.get('outcome')} | PnL: {trade.get('pnl_usd')}\n"
        if mistakes:
            body += "- Mistakes: " + ", ".join(wikilink("07_Mistake_Library", m, m) for m in mistakes) + "\n"
        body += "\n## Research Links\n"
        body += "".join(f"- {link}\n" for link in linked) or "- No direct note matches yet\n"
        body += "\n## Trader Notes\n"
        body += f"{trade.get('notes') or '- Add post-trade lesson here.'}\n"

        path = RESEARCH_DIR / "06_Trade_Links" / f"{slugify(trade_id)}.md"
        ok, written_path = _write(path, body, overwrite)
        (result.written if ok else result.skipped).append(written_path)
        if ok:
            journal_updates.append((str(path.relative_to(BASE_DIR)), str(trade_id)))

    if journal_updates:
        con = _connect()
        try:
            con.executemany(
                "UPDATE trades SET journal_entry=? WHERE trade_id=?",
                journal_updates,
            )
            con.commit()
            result.updated_trade_links = len(journal_updates)
        finally:
            con.close()
    return result


def export_analytics_insight(df: pd.DataFrame, notes: pd.DataFrame, overwrite: bool = True) -> ExportResult:
    result = ExportResult([], [])
    if df.empty:
        return result
    today = datetime.now().date().isoformat()
    metrics = _group_metrics(df)
    strategies = sorted(df["strategy"].dropna().astype(str).unique().tolist()) if "strategy" in df else []
    symbols = sorted(df["symbol"].dropna().astype(str).unique().tolist()) if "symbol" in df else []
    sessions = sorted(df["session"].dropna().astype(str).unique().tolist()) if "session" in df else []
    regimes = sorted(df["regime"].dropna().astype(str).unique().tolist()) if "regime" in df else []
    linked = _linked_research(notes, strategies + symbols + sessions + regimes, limit=12)

    top_strategy = _top_group(df, "strategy")
    weak_strategy = _bottom_group(df, "strategy")
    top_mistakes = _top_mistakes(df)

    body = frontmatter({
        "type": "analytics_insight",
        "status": "generated",
        "created": today,
        "scope": "all_trades",
        "strategies": strategies,
        "symbols": symbols,
        "sessions": sessions,
        "regimes": regimes,
        "tags": ["analytics-insight", "trading-intelligence"],
    })
    body += f"# Analytics Insight - {today}\n\n"
    body += "## Portfolio Snapshot\n"
    body += _metric_bullets(metrics)
    body += "\n## What To Act On\n"
    body += f"- Strongest strategy group: {top_strategy}\n"
    body += f"- Weakest strategy group: {weak_strategy}\n"
    if top_mistakes:
        body += "- Highest-friction mistakes: " + ", ".join(wikilink("07_Mistake_Library", m, m) for m in top_mistakes) + "\n"
    else:
        body += "- Highest-friction mistakes: no mistake annotations yet\n"
    body += "\n## Linked Research\n"
    body += "".join(f"- {link}\n" for link in linked) or "- No direct note matches yet\n"
    body += "\n## AI Review Prompt\n"
    body += (
        "Use this packet to produce three concrete trading system updates: "
        "one rule to keep, one rule to remove, and one annotation gap to fix. "
        "Only use the evidence linked in this note.\n"
    )

    ok, path = _write(RESEARCH_DIR / "05_Analytics_Insights" / f"{today}_Portfolio_Intelligence.md", body, overwrite)
    (result.written if ok else result.skipped).append(path)
    return result


def _top_group(df: pd.DataFrame, col: str) -> str:
    if col not in df:
        return "n/a"
    rows = []
    for key, group in df.groupby(col, dropna=True):
        if len(group) >= 3:
            rows.append((float(group["pnl_usd"].mean()), len(group), str(key)))
    if not rows:
        return "Needs more data"
    rows.sort(reverse=True)
    return f"{rows[0][2]} ({rows[0][1]} trades, avg PnL {rows[0][0]:.2f})"


def _bottom_group(df: pd.DataFrame, col: str) -> str:
    if col not in df:
        return "n/a"
    rows = []
    for key, group in df.groupby(col, dropna=True):
        if len(group) >= 3:
            rows.append((float(group["pnl_usd"].mean()), len(group), str(key)))
    if not rows:
        return "Needs more data"
    rows.sort()
    return f"{rows[0][2]} ({rows[0][1]} trades, avg PnL {rows[0][0]:.2f})"


def _top_mistakes(df: pd.DataFrame, limit: int = 5) -> list[str]:
    if "mistakes" not in df:
        return []
    counter = Counter(m for value in df["mistakes"].dropna() for m in _split_mistakes(value))
    return [name for name, _ in counter.most_common(limit)]


def export_ai_packet(df: pd.DataFrame, notes: pd.DataFrame, overwrite: bool = True) -> ExportResult:
    result = ExportResult([], [])
    if df.empty:
        return result
    today = datetime.now().date().isoformat()
    linked = _linked_research(
        notes,
        df.get("strategy", pd.Series(dtype=str)).dropna().unique().tolist()
        + df.get("symbol", pd.Series(dtype=str)).dropna().unique().tolist()
        + df.get("regime", pd.Series(dtype=str)).dropna().unique().tolist(),
        limit=20,
    )
    body = frontmatter({
        "type": "ai_export",
        "status": "ready_for_review",
        "created": today,
        "tags": ["ai-export", "trading-intelligence"],
    })
    body += f"# AI Research Packet - {today}\n\n"
    body += "## Task\n"
    body += "Turn the analytics evidence and linked research into operational trading updates.\n\n"
    body += "## Constraints\n"
    body += "- No new theory.\n- Every recommendation must point to a metric, trade link, strategy note, regime note, or source note.\n- Output must be a short action list for the next trading week.\n\n"
    body += "## Current Metrics\n"
    body += _metric_bullets(_group_metrics(df))
    body += "\n## Core Links\n"
    for strategy in sorted(df.get("strategy", pd.Series(dtype=str)).dropna().astype(str).unique().tolist()):
        body += f"- {wikilink('01_Strategies', strategy, strategy)}\n"
    for mistake in _top_mistakes(df):
        body += f"- {wikilink('07_Mistake_Library', mistake, mistake)}\n"
    body += "\n## Research Matches\n"
    body += "".join(f"- {link}\n" for link in linked) or "- No direct note matches yet\n"

    ok, path = _write(RESEARCH_DIR / "08_AI_Exports" / f"{today}_AI_Research_Packet.md", body, overwrite)
    (result.written if ok else result.skipped).append(path)
    return result


def export_research_index(notes: pd.DataFrame, overwrite: bool = True) -> ExportResult:
    result = ExportResult([], [])
    today = datetime.now().date().isoformat()
    by_type: dict[str, list[str]] = defaultdict(list)
    if not notes.empty:
        for _, row in notes.sort_values("name").iterrows():
            rel = row["path"].relative_to(BASE_DIR).with_suffix("").as_posix()
            by_type[str(row.get("type") or "research_note")].append(f"[[{rel}|{row['name']}]]")

    body = frontmatter({
        "type": "research_index",
        "status": "generated",
        "updated": today,
        "tags": ["research-index", "trading-intelligence"],
    })
    body += "# Research Intelligence Index\n\n"
    body += "## Workflow\n"
    body += "1. Drop NotebookLM summaries into [[10_Research/00_Inbox/README|Inbox]].\n"
    body += "2. Add YAML fields for strategies, symbols, sessions, regimes, and mistakes.\n"
    body += "3. Run Research Intelligence export from the dashboard.\n"
    body += "4. Review generated strategy, regime, mistake, and trade pages before changing rules.\n\n"
    body += "## Folders\n"
    for folder, description in FOLDERS.items():
        body += f"- [[10_Research/{folder}/README|{folder}]] - {description}\n"
    body += "\n## Notes By Type\n"
    if by_type:
        for note_type, links in sorted(by_type.items()):
            body += f"\n### {note_type}\n"
            for link in links[:100]:
                body += f"- {link}\n"
    else:
        body += "- No notes scanned yet.\n"

    ok, path = _write(RESEARCH_DIR / "_Indexes" / "Research_Intelligence_Index.md", body, overwrite)
    (result.written if ok else result.skipped).append(path)
    return result


def export_all(
    df: pd.DataFrame | None = None,
    overwrite: bool = True,
    trade_limit: int = 100,
    annotated_trades_only: bool = True,
) -> dict[str, Any]:
    ensure_vault_structure(write_templates=True)
    if df is None:
        df = load_trades_from_db()
    notes = scan_research_notes()

    results = {
        "structure": {"written": [], "skipped": [], "updated_trade_links": 0},
        "strategies": export_strategy_pages(df, notes, overwrite).as_dict(),
        "dimensions": export_dimension_pages(df, notes, overwrite).as_dict(),
        "mistakes": export_mistake_library(df, notes, overwrite).as_dict(),
        "trades": export_trade_links(df, notes, overwrite, trade_limit, annotated_trades_only).as_dict(),
        "analytics": export_analytics_insight(df, notes, overwrite).as_dict(),
        "ai_packet": export_ai_packet(df, notes, overwrite).as_dict(),
    }
    refreshed_notes = scan_research_notes()
    results["index"] = export_research_index(refreshed_notes, overwrite).as_dict()
    results["summary"] = {
        "markdown_notes_scanned": int(len(refreshed_notes)),
        "trades_loaded": int(len(df)),
        "generated_at": datetime.now().isoformat(timespec="seconds"),
    }
    return results


if __name__ == "__main__":
    output = export_all()
    print(json.dumps(output["summary"], indent=2))
