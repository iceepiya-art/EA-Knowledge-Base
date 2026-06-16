"""
research_ingestor.py - convert raw research into structured QTrade OS notes.

Research is never promoted to trading rules automatically. Every idea is marked
as one of: untested, testing, validated, rejected.
"""

from __future__ import annotations

import json
import re
import shutil
from dataclasses import dataclass
from datetime import datetime
from pathlib import Path
from typing import Any

import pandas as pd

try:
    from research_exporter import BASE_DIR, RESEARCH_DIR, ensure_vault_structure, frontmatter, slugify, wikilink
except ImportError:
    from .research_exporter import BASE_DIR, RESEARCH_DIR, ensure_vault_structure, frontmatter, slugify, wikilink


IDEA_STATUSES = ["untested", "testing", "validated", "rejected"]
SOURCE_TYPES = ["youtube", "article", "pdf", "strategy_idea", "ea_document", "market_research", "manual", "notebooklm"]
INBOX_DIR = RESEARCH_DIR / "00_Inbox"
SOURCE_DIR = RESEARCH_DIR / "09_Source_Notes"
TEST_IDEA_DIR = RESEARCH_DIR / "10_Test_Ideas"
INGESTED_RAW_DIR = RESEARCH_DIR / "00_Inbox" / "_processed"

SECTION_ALIASES = {
    "concept": ["concept", "idea", "summary", "core idea", "main idea"],
    "trading_rules": ["trading rules", "rules", "setup rules", "playbook"],
    "market_condition": ["market condition", "condition", "regime", "environment", "when it works"],
    "entry_logic": ["entry logic", "entry", "entry rules", "trigger"],
    "exit_logic": ["exit logic", "exit", "take profit", "stop loss", "close logic"],
    "risk_logic": ["risk logic", "risk", "position sizing", "money management"],
    "strengths": ["strengths", "pros", "advantages", "edge"],
    "weaknesses": ["weaknesses", "cons", "risks", "failure modes"],
    "testable_hypothesis": ["testable hypothesis", "hypothesis", "what to test"],
}

KEYWORD_MAP = {
    "sessions": {
        "Asian": ["asian", "asia"],
        "London": ["london"],
        "Pre_NY": ["pre ny", "pre-ny", "pre new york"],
        "London_NY": ["london ny", "london-new york", "overlap"],
        "NY": ["new york", "ny session", "us session"],
    },
    "regimes": {
        "TRENDING": ["trend", "trending", "momentum", "breakout"],
        "REVERTING": ["revert", "mean reversion", "range", "pullback"],
        "WEAK": ["weak", "chop", "sideway", "sideways"],
        "CRASH": ["crash", "panic", "capitulation", "volatility spike"],
    },
    "symbols": {
        "XAUUSD": ["gold", "xau", "xauusd"],
        "NQ": ["nasdaq", "nq", "ustec", "nas100"],
        "EURUSD": ["eurusd", "euro"],
        "BTCUSD": ["bitcoin", "btc"],
        "USOIL": ["oil", "wti", "usoil"],
    },
}


@dataclass
class IngestResult:
    raw_path: Path
    structured_path: Path | None
    test_idea_path: Path | None
    status: str
    message: str

    def as_dict(self) -> dict[str, Any]:
        return {
            "raw_path": str(self.raw_path.relative_to(BASE_DIR)) if self.raw_path.exists() else str(self.raw_path),
            "structured_path": str(self.structured_path.relative_to(BASE_DIR)) if self.structured_path else None,
            "test_idea_path": str(self.test_idea_path.relative_to(BASE_DIR)) if self.test_idea_path else None,
            "status": self.status,
            "message": self.message,
        }


def ensure_research_ingestion_structure() -> list[Path]:
    created = ensure_vault_structure(write_templates=True)
    for folder in (INBOX_DIR, SOURCE_DIR, TEST_IDEA_DIR, INGESTED_RAW_DIR):
        folder.mkdir(parents=True, exist_ok=True)
    workflow = RESEARCH_DIR / "_Indexes" / "Research_Ingestion_Workflow.md"
    if not workflow.exists():
        workflow.write_text(_workflow_note(), encoding="utf-8")
        created.append(workflow)
    return created


def save_raw_research(
    title: str,
    body: str,
    source_type: str = "manual",
    source_url: str = "",
    idea_status: str = "untested",
) -> Path:
    ensure_research_ingestion_structure()
    source_type = source_type if source_type in SOURCE_TYPES else "manual"
    idea_status = _normalize_status(idea_status)
    date_key = datetime.now().strftime("%Y-%m-%d")
    path = INBOX_DIR / f"{date_key}_{slugify(title)}.md"
    content = frontmatter({
        "type": "raw_research",
        "status": idea_status,
        "idea_status": idea_status,
        "created": datetime.now().isoformat(timespec="seconds"),
        "source": title,
        "source_type": source_type,
        "source_url": source_url,
        "tags": ["raw-research", "research-inbox", "trading-intelligence"],
    })
    content += f"# {title}\n\n"
    content += body.strip() + "\n"
    path.write_text(content, encoding="utf-8")
    return path


def ingest_inbox(default_status: str = "untested", move_raw: bool = False) -> list[dict[str, Any]]:
    ensure_research_ingestion_structure()
    results = []
    files = sorted([
        p for p in INBOX_DIR.glob("*")
        if p.suffix.lower() in {".md", ".txt", ".pdf"}
        and p.is_file()
        and p.name.lower() != "readme.md"
        and not p.name.startswith("_")
    ])
    for path in files:
        results.append(ingest_file(path, default_status=default_status, move_raw=move_raw).as_dict())
    return results


def ingest_file(path: str | Path, default_status: str = "untested", move_raw: bool = False) -> IngestResult:
    ensure_research_ingestion_structure()
    raw_path = Path(path)
    if not raw_path.is_absolute():
        raw_path = BASE_DIR / raw_path
    if not raw_path.exists():
        return IngestResult(raw_path, None, None, "error", "File not found")

    if raw_path.suffix.lower() == ".pdf":
        text = _pdf_stub(raw_path)
        source_type = "pdf"
    else:
        text = raw_path.read_text(encoding="utf-8", errors="ignore")
        source_type = _infer_source_type(text, raw_path)

    fm, body_text = _split_frontmatter(text)
    title = _title_from_text(body_text, raw_path)
    idea_status = _normalize_status(str(fm.get("idea_status") or fm.get("status") or default_status))
    extracted = extract_research_fields(body_text)
    links = infer_links(body_text + " " + title)
    source_url = str(fm.get("source_url") or _first_url(body_text) or "")
    source_name = str(fm.get("source") or title)

    structured_path = write_structured_note(
        title=title,
        source_name=source_name,
        source_type=source_type,
        source_url=source_url,
        idea_status=idea_status,
        extracted=extracted,
        links=links,
        raw_path=raw_path,
    )
    test_path = write_test_idea_note(
        title=title,
        source_name=source_name,
        source_type=source_type,
        source_url=source_url,
        idea_status=idea_status,
        extracted=extracted,
        links=links,
        structured_path=structured_path,
    )

    if move_raw:
        dest = INGESTED_RAW_DIR / raw_path.name
        if raw_path.resolve() != dest.resolve():
            shutil.move(str(raw_path), str(dest))

    return IngestResult(raw_path, structured_path, test_path, idea_status, "ingested")


def extract_research_fields(text: str) -> dict[str, str]:
    sections = _markdown_sections(text)
    result: dict[str, str] = {}
    for field, aliases in SECTION_ALIASES.items():
        result[field] = _find_section(sections, aliases)

    clean = _clean_text(text)
    if not result["concept"]:
        result["concept"] = _first_sentences(clean, 3)
    if not result["trading_rules"]:
        result["trading_rules"] = _sentences_with(clean, ["rule", "must", "should", "filter", "confirm"])
    if not result["market_condition"]:
        result["market_condition"] = _sentences_with(clean, ["trend", "range", "session", "volatility", "regime", "news"])
    if not result["entry_logic"]:
        result["entry_logic"] = _sentences_with(clean, ["entry", "enter", "trigger", "break", "pullback", "signal"])
    if not result["exit_logic"]:
        result["exit_logic"] = _sentences_with(clean, ["exit", "take profit", "tp", "stop", "sl", "trail", "close"])
    if not result["risk_logic"]:
        result["risk_logic"] = _sentences_with(clean, ["risk", "drawdown", "position", "lot", "kelly", "loss"])
    if not result["strengths"]:
        result["strengths"] = _sentences_with(clean, ["strength", "works", "advantage", "edge"])
    if not result["weaknesses"]:
        result["weaknesses"] = _sentences_with(clean, ["weakness", "fails", "avoid", "risk", "problem"])
    if not result["testable_hypothesis"]:
        result["testable_hypothesis"] = _build_hypothesis(result)
    return {k: (v.strip() or "- Needs manual extraction") for k, v in result.items()}


def infer_links(text: str) -> dict[str, list[str]]:
    text_lc = text.lower()
    links = {"strategies": [], "symbols": [], "sessions": [], "regimes": [], "linked_ea_performance": []}
    strategies = _known_strategies()
    for strategy in strategies:
        if str(strategy).lower() in text_lc:
            links["strategies"].append(strategy)
            links["linked_ea_performance"].append(strategy)

    for group, mapping in KEYWORD_MAP.items():
        for value, needles in mapping.items():
            if any(n in text_lc for n in needles):
                links[group].append(value)
    return {k: sorted(set(v)) for k, v in links.items()}


def write_structured_note(
    title: str,
    source_name: str,
    source_type: str,
    source_url: str,
    idea_status: str,
    extracted: dict[str, str],
    links: dict[str, list[str]],
    raw_path: Path,
) -> Path:
    date_key = datetime.now().strftime("%Y-%m-%d")
    path = SOURCE_DIR / f"{date_key}_{slugify(title)}.md"
    content = frontmatter({
        "type": "research_note",
        "status": idea_status,
        "idea_status": idea_status,
        "created": datetime.now().isoformat(timespec="seconds"),
        "source": source_name,
        "source_type": source_type,
        "source_url": source_url,
        "raw_source": str(raw_path.relative_to(BASE_DIR)) if raw_path.is_relative_to(BASE_DIR) else str(raw_path),
        "strategies": links.get("strategies", []),
        "symbols": links.get("symbols", []),
        "sessions": links.get("sessions", []),
        "regimes": links.get("regimes", []),
        "linked_ea_performance": links.get("linked_ea_performance", []),
        "tags": ["research-note", "trading-intelligence", f"idea-status/{idea_status}"],
    })
    content += f"# {title}\n\n"
    content += _status_notice(idea_status)
    for heading, key in [
        ("Concept", "concept"),
        ("Trading Rules", "trading_rules"),
        ("Market Condition", "market_condition"),
        ("Entry Logic", "entry_logic"),
        ("Exit Logic", "exit_logic"),
        ("Risk Logic", "risk_logic"),
        ("Strengths", "strengths"),
        ("Weaknesses", "weaknesses"),
        ("Testable Hypothesis", "testable_hypothesis"),
    ]:
        content += f"\n## {heading}\n{_as_bullets(extracted.get(key, ''))}\n"
    content += "\n## Backtest Ideas\n"
    content += _backtest_ideas(extracted, links)
    content += "\n## Linked Intelligence\n"
    content += _linked_intelligence(links)
    content += "\n## Promotion Rule\n"
    content += "- This idea can become a trading rule only after manual review plus backtest or live journal evidence.\n"
    path.write_text(content, encoding="utf-8")
    return path


def write_test_idea_note(
    title: str,
    source_name: str,
    source_type: str,
    source_url: str,
    idea_status: str,
    extracted: dict[str, str],
    links: dict[str, list[str]],
    structured_path: Path,
) -> Path:
    date_key = datetime.now().strftime("%Y-%m-%d")
    path = TEST_IDEA_DIR / f"{date_key}_{slugify(title)}_Test.md"
    structured_link = f"[[{structured_path.relative_to(BASE_DIR).with_suffix('').as_posix()}|Structured research note]]"
    content = frontmatter({
        "type": "test_idea",
        "status": idea_status,
        "idea_status": idea_status,
        "created": datetime.now().isoformat(timespec="seconds"),
        "source": source_name,
        "source_type": source_type,
        "source_url": source_url,
        "linked_research": [structured_link],
        "strategies": links.get("strategies", []),
        "symbols": links.get("symbols", []),
        "sessions": links.get("sessions", []),
        "regimes": links.get("regimes", []),
        "tags": ["test-idea", "backtest-candidate", f"idea-status/{idea_status}"],
    })
    content += f"# Test Idea - {title}\n\n"
    content += _status_notice(idea_status)
    content += f"\n## Source\n- {structured_link}\n"
    content += "\n## Hypothesis\n"
    content += _as_bullets(extracted.get("testable_hypothesis", ""))
    content += "\n## Test Setup\n"
    content += "- Dataset:\n- Strategy/EA:\n- Symbol:\n- Session:\n- Regime filter:\n- Date range:\n- Timeframe:\n"
    content += "\n## Rules To Test\n"
    content += f"### Entry\n{_as_bullets(extracted.get('entry_logic', ''))}\n"
    content += f"### Exit\n{_as_bullets(extracted.get('exit_logic', ''))}\n"
    content += f"### Risk\n{_as_bullets(extracted.get('risk_logic', ''))}\n"
    content += "\n## Pass / Fail Criteria\n"
    content += "- Minimum trades:\n- Minimum profit factor:\n- Maximum drawdown:\n- Regime/session condition:\n"
    content += "\n## Decision\n"
    content += "- Keep as `untested` until a backtest result is attached.\n"
    path.write_text(content, encoding="utf-8")
    return path


def list_research_ideas() -> pd.DataFrame:
    ensure_research_ingestion_structure()
    rows = []
    for folder in (SOURCE_DIR, TEST_IDEA_DIR):
        for path in folder.glob("*.md"):
            text = path.read_text(encoding="utf-8", errors="ignore")
            fm, _ = _split_frontmatter(text)
            note_type = fm.get("type", "")
            if note_type not in {"research_note", "test_idea", "research_idea"}:
                continue
            rows.append({
                "title": path.stem,
                "type": note_type,
                "status": fm.get("idea_status") or fm.get("status") or "",
                "source_type": fm.get("source_type", ""),
                "path": str(path.relative_to(BASE_DIR)),
                "updated": datetime.fromtimestamp(path.stat().st_mtime),
            })
    return pd.DataFrame(rows).sort_values("updated", ascending=False) if rows else pd.DataFrame()


def update_idea_status(path: str | Path, new_status: str) -> tuple[bool, str]:
    new_status = _normalize_status(new_status)
    p = Path(path)
    if not p.is_absolute():
        p = BASE_DIR / p
    if not p.exists():
        return False, "File not found"
    text = p.read_text(encoding="utf-8")
    fm, body = _split_frontmatter(text)
    if not fm:
        return False, "No YAML frontmatter found"
    fm["status"] = new_status
    fm["idea_status"] = new_status
    tags = fm.get("tags", [])
    if not isinstance(tags, list):
        tags = []
    tags = [t for t in tags if not str(t).startswith("idea-status/")]
    tags.append(f"idea-status/{new_status}")
    fm["tags"] = tags
    p.write_text(frontmatter(fm) + body.lstrip(), encoding="utf-8")
    return True, f"Updated status to {new_status}"


def _normalize_status(status: str) -> str:
    status = str(status or "untested").strip().lower()
    return status if status in IDEA_STATUSES else "untested"


def _split_frontmatter(text: str) -> tuple[dict[str, Any], str]:
    if not text.startswith("---"):
        return {}, text
    parts = text.split("---", 2)
    if len(parts) < 3:
        return {}, text
    data: dict[str, Any] = {}
    current_key = None
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
            if value in ("", "[]"):
                data[key] = [] if value == "[]" or value == "" else value
            elif value.startswith("[") and value.endswith("]"):
                inner = value[1:-1].strip()
                data[key] = [x.strip().strip('"') for x in inner.split(",") if x.strip()] if inner else []
            else:
                data[key] = value.strip('"')
    return data, parts[2]


def _markdown_sections(text: str) -> dict[str, str]:
    sections: dict[str, list[str]] = {}
    current = "body"
    sections[current] = []
    for line in text.splitlines():
        match = re.match(r"^\s{0,3}#{1,4}\s+(.+?)\s*$", line)
        if match:
            current = _norm_heading(match.group(1))
            sections.setdefault(current, [])
        else:
            sections.setdefault(current, []).append(line)
    return {k: "\n".join(v).strip() for k, v in sections.items()}


def _norm_heading(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", " ", value.lower()).strip()


def _find_section(sections: dict[str, str], aliases: list[str]) -> str:
    for alias in aliases:
        target = _norm_heading(alias)
        for heading, body in sections.items():
            if target == heading or target in heading:
                return body
    return ""


def _clean_text(text: str) -> str:
    text = re.sub(r"---.*?---", "", text, flags=re.S)
    text = re.sub(r"```.*?```", "", text, flags=re.S)
    text = re.sub(r"\s+", " ", text)
    return text.strip()


def _first_sentences(text: str, count: int) -> str:
    sentences = re.split(r"(?<=[.!?])\s+", text)
    return " ".join(sentences[:count]).strip()


def _sentences_with(text: str, needles: list[str], limit: int = 4) -> str:
    sentences = re.split(r"(?<=[.!?])\s+", text)
    found = []
    for sentence in sentences:
        s = sentence.lower()
        if any(n in s for n in needles):
            found.append(sentence.strip())
        if len(found) >= limit:
            break
    return "\n".join(f"- {x}" for x in found)


def _build_hypothesis(fields: dict[str, str]) -> str:
    condition = fields.get("market_condition", "").replace("\n", " ")[:160]
    entry = fields.get("entry_logic", "").replace("\n", " ")[:160]
    exit_logic = fields.get("exit_logic", "").replace("\n", " ")[:120]
    return (
        "If the market condition is applied as a filter and the entry logic is tested "
        f"({entry or 'entry rule needs extraction'}), then performance should improve versus baseline. "
        f"Condition: {condition or 'condition needs extraction'}. Exit: {exit_logic or 'exit rule needs extraction'}."
    )


def _as_bullets(value: str) -> str:
    value = (value or "").strip()
    if not value:
        return "- Needs manual extraction\n"
    lines = [line.strip() for line in value.splitlines() if line.strip()]
    if not lines:
        return "- Needs manual extraction\n"
    out = ""
    for line in lines:
        out += line if line.startswith("-") else f"- {line}"
        out += "\n"
    return out


def _backtest_ideas(fields: dict[str, str], links: dict[str, list[str]]) -> str:
    symbols = links.get("symbols") or ["selected symbol"]
    sessions = links.get("sessions") or ["all sessions"]
    regimes = links.get("regimes") or ["all regimes"]
    out = ""
    for symbol in symbols[:3]:
        out += f"- Test on {symbol} with session filter {', '.join(sessions[:3])} and regime filter {', '.join(regimes[:3])}.\n"
    out += "- Compare baseline strategy vs baseline plus this research filter.\n"
    out += "- Measure win rate, profit factor, expectancy, max drawdown, and trade count.\n"
    return out


def _linked_intelligence(links: dict[str, list[str]]) -> str:
    rows = ""
    rows += "- Strategies: " + _links("01_Strategies", links.get("strategies", [])) + "\n"
    rows += "- Sessions: " + _links("02_Sessions", links.get("sessions", [])) + "\n"
    rows += "- Symbols: " + _links("03_Symbols", links.get("symbols", [])) + "\n"
    rows += "- Regimes: " + _links("04_Regimes", links.get("regimes", [])) + "\n"
    rows += "- EA performance: " + _links("01_Strategies", links.get("linked_ea_performance", [])) + "\n"
    return rows


def _links(folder: str, values: list[str]) -> str:
    if not values:
        return "None inferred"
    return ", ".join(wikilink(folder, v, v) for v in values)


def _known_strategies() -> list[str]:
    db = BASE_DIR / "DATA" / "processed" / "trades.sqlite"
    if not db.exists():
        return []
    try:
        import sqlite3
        con = sqlite3.connect(db)
        rows = con.execute("SELECT DISTINCT strategy FROM trades WHERE strategy IS NOT NULL").fetchall()
        con.close()
        return [r[0] for r in rows if r[0]]
    except Exception:
        return []


def _title_from_text(text: str, path: Path) -> str:
    for line in text.splitlines():
        match = re.match(r"^\s*#\s+(.+)", line)
        if match:
            return match.group(1).strip()
    return path.stem


def _infer_source_type(text: str, path: Path) -> str:
    hay = f"{path.name} {text[:500]}".lower()
    if "youtube" in hay or "youtu.be" in hay:
        return "youtube"
    if path.suffix.lower() == ".pdf":
        return "pdf"
    if "expert advisor" in hay or " ea " in hay:
        return "ea_document"
    if "market research" in hay or "macro" in hay:
        return "market_research"
    if "strategy" in hay or "setup" in hay:
        return "strategy_idea"
    if "http" in hay:
        return "article"
    return "manual"


def _first_url(text: str) -> str | None:
    match = re.search(r"https?://\S+", text)
    return match.group(0).rstrip(").,") if match else None


def _pdf_stub(path: Path) -> str:
    return (
        f"# {path.stem}\n\n"
        "PDF detected. Paste the PDF summary or extracted text into a Markdown note "
        "in `10_Research/00_Inbox` for full extraction.\n"
    )


def _status_notice(status: str) -> str:
    return (
        f"> Idea status: `{status}`. This is research knowledge, not a live trading rule. "
        "Promotion requires human review plus test evidence.\n"
    )


def _workflow_note() -> str:
    return """---
type: workflow
status: active
tags:
  - research-ingestion
  - trading-intelligence
---

# Research Ingestion Workflow

## Flow
1. Save raw YouTube notes, article summaries, PDF summaries, EA docs, strategy ideas, or market research into `10_Research/00_Inbox`.
2. Keep the idea status as `untested` unless test evidence exists.
3. Run the Research Ideas dashboard page or `research_ingestor.py`.
4. Review generated structured notes in `09_Source_Notes`.
5. Review generated backtest candidates in `10_Test_Ideas`.
6. Move status manually through `untested`, `testing`, `validated`, or `rejected`.

## Rule
Research does not become a trading rule automatically. Every idea needs human review and test evidence.
"""


if __name__ == "__main__":
    import argparse

    ap = argparse.ArgumentParser(description="Ingest QTrade OS research markdown from Inbox")
    ap.add_argument("--file", help="Specific raw research file to ingest")
    ap.add_argument("--inbox", action="store_true", help="Ingest every raw file in 10_Research/00_Inbox")
    ap.add_argument("--status", default="untested", choices=IDEA_STATUSES)
    ap.add_argument("--move-raw", action="store_true")
    args = ap.parse_args()

    if args.file:
        print(json.dumps(ingest_file(args.file, args.status, args.move_raw).as_dict(), indent=2, ensure_ascii=False))
    else:
        print(json.dumps(ingest_inbox(args.status, args.move_raw), indent=2, ensure_ascii=False))
