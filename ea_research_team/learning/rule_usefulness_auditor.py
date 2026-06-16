from __future__ import annotations

import argparse
import json
from collections import Counter, defaultdict
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any


TH_TZ = timezone(timedelta(hours=7))

DEFAULT_LEARNING_DIR = Path(__file__).resolve().parent
DEFAULT_INDEX_PATH = DEFAULT_LEARNING_DIR / "knowledge_index.json"
DEFAULT_COMPONENTS_PATH = DEFAULT_LEARNING_DIR / "ea_components.json"
DEFAULT_STRUCTURED_PATH = DEFAULT_LEARNING_DIR / "structured_extractions.json"
DEFAULT_CONFLICT_PATH = DEFAULT_LEARNING_DIR / "conflict_review_queue.json"
DEFAULT_OUTPUT_DIR = DEFAULT_LEARNING_DIR.parents[1] / ".agent_handoff"


RISK_TERMS = {
    "risk",
    "stop loss",
    "stoploss",
    "sl",
    "drawdown",
    "lot",
    "exposure",
    "position sizing",
    "martingale",
    "grid",
    "hedge",
    "averaging",
    "basket",
}
ENTRY_TERMS = {
    "entry",
    "buy",
    "sell",
    "long",
    "short",
    "bos",
    "choch",
    "order block",
    "fvg",
    "demand",
    "supply",
    "break",
    "retest",
    "zone",
}
EXIT_TERMS = {"exit", "close", "take profit", "tp", "trailing", "partial"}
FILTER_TERMS = {"session", "timeframe", "news", "trend", "regime", "confirm", "filter"}
DANGEROUS_TERMS = {"martingale", "grid", "averaging", "no stop loss", "no sl", "unlimited"}
NON_TRADING_TERMS = {
    "agreement",
    "agreements",
    "contract",
    "contractor",
    "client",
    "party",
    "consent",
    "authority",
    "behalf",
    "notice",
    "copy",
    "notes",
    "please do not",
}
TRADING_CONTEXT_TERMS = (
    RISK_TERMS
    | ENTRY_TERMS
    | EXIT_TERMS
    | FILTER_TERMS
    | {"price", "trade", "order", "market", "candle", "spread", "profit", "loss"}
)
EXECUTABLE_TERMS = {
    "when",
    "if",
    "enter",
    "close",
    "buy",
    "sell",
    "above",
    "below",
    "break",
    "retest",
    "stop",
    "risk",
    "lot",
    "session",
    "timeframe",
    "confirm",
}


def now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")


def text_has_any(text: str, terms: set[str]) -> bool:
    low = text.lower()
    return any(term in low for term in terms)


def classify_concern(concept: str, text: str) -> str:
    combined = f"{concept} {text}".lower()
    if text_has_any(combined, RISK_TERMS):
        return "risk_management"
    if text_has_any(combined, EXIT_TERMS):
        return "exit_logic"
    if text_has_any(combined, ENTRY_TERMS):
        return "entry_logic"
    if text_has_any(combined, FILTER_TERMS):
        return "filter_logic"
    return "evidence_quality"


def _pending_conflicts_for_rule(
    rule: dict[str, Any],
    conflicts_by_concept: dict[str, list[dict[str, Any]]],
) -> list[dict[str, Any]]:
    found: list[dict[str, Any]] = []
    for concept in rule.get("canonical_concepts", []):
        found.extend(conflicts_by_concept.get(concept, []))
    return [item for item in found if item.get("status", "pending") == "pending"]


def score_rule(
    rule: dict[str, Any],
    conflicts_by_concept: dict[str, list[dict[str, Any]]],
) -> dict[str, Any]:
    text = str(rule.get("rule") or "")
    sources = list(rule.get("sources") or [])
    concepts = list(rule.get("canonical_concepts") or [])
    category = str(rule.get("category") or "")
    pending = _pending_conflicts_for_rule(rule, conflicts_by_concept)
    flags: list[str] = []
    low_text = text.lower()
    has_trading_context = text_has_any(text, TRADING_CONTEXT_TERMS) or bool(concepts)
    has_distribution_noise = (
        ("copy" in low_text or "notes" in low_text or "please do not" in low_text)
        and "order" not in low_text
        and "price" not in low_text
        and "trade" not in low_text
    )
    if (text_has_any(text, NON_TRADING_TERMS) and not has_trading_context) or has_distribution_noise:
        flags.append("non_trading_language")
    if not concepts and has_trading_context:
        flags.append("missing_concepts")

    evidence_score = min(25, 8 + len(set(sources)) * 7)
    executable_score = 25 if text_has_any(text, EXECUTABLE_TERMS) and len(text.split()) >= 6 else 10
    risk_score = 20
    if text_has_any(text, DANGEROUS_TERMS):
        risk_score = 3
        flags.append("unbounded_risk_language")

    conflict_score = 20
    high_pending = [item for item in pending if item.get("severity") == "high"]
    if high_pending:
        conflict_score = 2
        flags.append("pending_high_conflict")
    elif pending:
        conflict_score = 8
        flags.append("pending_conflict")

    backtest_score = (
        10
        if category in {"Entry Components", "Exit Components", "Filter Components", "Risk Components"}
        and text_has_any(text, EXECUTABLE_TERMS)
        else 3
    )

    score = evidence_score + executable_score + risk_score + conflict_score + backtest_score
    if "unbounded_risk_language" in flags:
        score -= 40
    if "non_trading_language" in flags:
        score -= 70
    if "missing_concepts" in flags:
        score -= 25
    blocked_ids = [str(item.get("conflict_id")) for item in pending if item.get("conflict_id")]
    concern = classify_concern(" ".join(concepts), text)

    if "non_trading_language" in flags:
        bucket = "reject_candidate"
    elif "unbounded_risk_language" in flags:
        bucket = "dangerous"
    elif "missing_concepts" in flags:
        bucket = "review_first"
    elif pending:
        bucket = "review_first"
    elif score >= 75:
        bucket = "backtest_ready"
    elif executable_score < 20:
        bucket = "reference_only"
    else:
        bucket = "review_first"

    return {
        "rule": text,
        "category": category,
        "canonical_concepts": concepts,
        "sources": sources,
        "source_count": len(set(sources)),
        "score": max(0, min(100, score)),
        "bucket": bucket,
        "concern": concern,
        "flags": flags,
        "blocked_by_conflicts": blocked_ids,
    }


def load_json(path: str | Path, default: dict[str, Any]) -> dict[str, Any]:
    path = Path(path)
    if not path.exists():
        return default
    return json.loads(path.read_text(encoding="utf-8"))


def build_conflicts_by_concept(conflict_queue: dict[str, Any]) -> dict[str, list[dict[str, Any]]]:
    grouped: dict[str, list[dict[str, Any]]] = defaultdict(list)
    for item in (conflict_queue.get("items") or {}).values():
        concept = str(item.get("concept") or "Unknown")
        grouped[concept].append(item)
    return dict(grouped)


def iter_component_rules(components: dict[str, Any]) -> list[dict[str, Any]]:
    rules: list[dict[str, Any]] = []
    for category, entries in (components.get("components") or {}).items():
        for entry in entries or []:
            item = dict(entry)
            item["category"] = category
            rules.append(item)
    return rules


def summarize_conflicts(conflict_queue: dict[str, Any]) -> dict[str, Any]:
    pending = [
        item
        for item in (conflict_queue.get("items") or {}).values()
        if item.get("status", "pending") == "pending"
    ]
    by_concern = Counter()
    by_type = Counter()
    by_severity = Counter()
    examples: list[dict[str, Any]] = []
    for item in pending:
        concern = classify_concern(
            str(item.get("concept") or ""),
            " ".join([
                str(item.get("summary") or ""),
                str(item.get("rule_a") or ""),
                str(item.get("rule_b") or ""),
            ]),
        )
        by_concern[concern] += 1
        by_type[str(item.get("type") or "unknown")] += 1
        by_severity[str(item.get("severity") or "unknown")] += 1
        if len(examples) < 15:
            examples.append({
                "conflict_id": item.get("conflict_id"),
                "concept": item.get("concept"),
                "severity": item.get("severity"),
                "type": item.get("type"),
                "concern": concern,
                "summary": item.get("summary"),
                "rule_a": item.get("rule_a"),
                "rule_b": item.get("rule_b"),
            })
    return {
        "pending_total": len(pending),
        "by_concern": dict(by_concern),
        "by_type": dict(by_type),
        "by_severity": dict(by_severity),
        "examples": examples,
    }


def render_rule_markdown(report: dict[str, Any]) -> str:
    lines = [
        "# Rule Usefulness Audit",
        "",
        f"Generated at: {report['generated_at']}",
        "",
        "## Summary",
        "",
    ]
    for key, value in report["summary"].items():
        lines.append(f"- {key}: {value}")
    lines.extend(["", "## Top Backtest-Ready Rules", ""])
    for item in report["top_backtest_ready"]:
        lines.append(f"- score {item['score']} | {item['category']} | {item['rule']}")
    lines.extend(["", "## Dangerous Rules", ""])
    for item in report["dangerous_rules"]:
        lines.append(f"- score {item['score']} | {item['rule']} | flags={','.join(item['flags'])}")
    lines.extend(["", "## Review First Rules", ""])
    for item in report["review_first"][:20]:
        lines.append(
            f"- score {item['score']} | conflicts={','.join(item['blocked_by_conflicts'])} | {item['rule']}"
        )
    return "\n".join(lines) + "\n"


def render_conflict_markdown(report: dict[str, Any]) -> str:
    lines = [
        "# Conflict Evidence Audit",
        "",
        f"Generated at: {report['generated_at']}",
        "",
        "## Summary",
        "",
        f"- pending_total: {report['pending_total']}",
        f"- by_concern: {report['by_concern']}",
        f"- by_type: {report['by_type']}",
        f"- by_severity: {report['by_severity']}",
        "",
        "## Evidence Examples",
        "",
    ]
    for item in report["examples"]:
        lines.append(f"### {item['conflict_id']} | {item['concept']} | {item['severity']} | {item['concern']}")
        lines.append(f"- summary: {item.get('summary')}")
        if item.get("rule_a"):
            lines.append(f"- rule_a: {item.get('rule_a')}")
        if item.get("rule_b"):
            lines.append(f"- rule_b: {item.get('rule_b')}")
        lines.append("")
    return "\n".join(lines)


def run_audit(
    *,
    components_path: str | Path = DEFAULT_COMPONENTS_PATH,
    conflict_path: str | Path = DEFAULT_CONFLICT_PATH,
    output_dir: str | Path = DEFAULT_OUTPUT_DIR,
    report_date: str | None = None,
) -> dict[str, Any]:
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    report_date = report_date or datetime.now(TH_TZ).strftime("%Y-%m-%d")

    components = load_json(components_path, {"components": {}})
    conflict_queue = load_json(conflict_path, {"items": {}})
    conflicts_by_concept = build_conflicts_by_concept(conflict_queue)

    scored = [score_rule(rule, conflicts_by_concept) for rule in iter_component_rules(components)]
    scored.sort(key=lambda item: item["score"], reverse=True)

    buckets = Counter(item["bucket"] for item in scored)
    concerns = Counter(item["concern"] for item in scored)
    rule_report = {
        "generated_at": now_iso(),
        "summary": {
            "total_rules": len(scored),
            "buckets": dict(buckets),
            "concerns": dict(concerns),
        },
        "top_backtest_ready": [item for item in scored if item["bucket"] == "backtest_ready"][:25],
        "dangerous_rules": [item for item in scored if item["bucket"] == "dangerous"][:25],
        "review_first": [item for item in scored if item["bucket"] == "review_first"][:50],
        "all_rules": scored,
    }
    conflict_report = {
        "generated_at": now_iso(),
        **summarize_conflicts(conflict_queue),
    }

    rule_json = output_dir / f"rule_usefulness_audit_{report_date}.json"
    rule_md = output_dir / f"rule_usefulness_audit_{report_date}.md"
    conflict_json = output_dir / f"conflict_evidence_audit_{report_date}.json"
    conflict_md = output_dir / f"conflict_evidence_audit_{report_date}.md"

    rule_json.write_text(json.dumps(rule_report, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
    rule_md.write_text(render_rule_markdown(rule_report), encoding="utf-8")
    conflict_json.write_text(
        json.dumps(conflict_report, ensure_ascii=False, indent=2, sort_keys=True),
        encoding="utf-8",
    )
    conflict_md.write_text(render_conflict_markdown(conflict_report), encoding="utf-8")

    return rule_report


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Audit learned EA rule usefulness and conflict evidence without mutating queues."
    )
    parser.add_argument("--components", default=str(DEFAULT_COMPONENTS_PATH))
    parser.add_argument("--conflicts", default=str(DEFAULT_CONFLICT_PATH))
    parser.add_argument("--output-dir", default=str(DEFAULT_OUTPUT_DIR))
    parser.add_argument("--date", default=None)
    args = parser.parse_args(argv)

    report = run_audit(
        components_path=args.components,
        conflict_path=args.conflicts,
        output_dir=args.output_dir,
        report_date=args.date,
    )
    print(json.dumps({
        "total_rules": report["summary"]["total_rules"],
        "buckets": report["summary"]["buckets"],
        "output_dir": args.output_dir,
    }, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
