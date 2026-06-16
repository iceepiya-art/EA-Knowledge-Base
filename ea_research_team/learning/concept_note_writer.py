"""Obsidian Concept Note Writer.

Reads knowledge_index.json and writes one Obsidian Markdown note per concept
into the output directory (default: concepts/).

Idempotency guarantee:
- Auto-generated content is fenced between AUTO_START_MARKER / AUTO_END_MARKER.
- On re-runs, only the fenced block is replaced; human-written content is untouched.
- Running this twice on the same index + concepts dir produces identical files.
"""
from __future__ import annotations

import json
import re
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any

from knowledge_merger import DEFAULT_INDEX_PATH
from structured_extractor import DEFAULT_EXTRACTION_PATH


TH_TZ = timezone(timedelta(hours=7))
DEFAULT_CONCEPTS_DIR = Path(__file__).parents[2] / "concepts"

AUTO_START_MARKER = "<!-- EA_KNOWLEDGE_AUTO_START -->"
AUTO_END_MARKER = "<!-- EA_KNOWLEDGE_AUTO_END -->"

LOW_CONFIDENCE_THRESHOLD = 60
SINGLE_SOURCE_THRESHOLD = 2

_THAI_SUMMARY: dict[str, str] = {
    "FVG": (
        "FVG (Fair Value Gap) คือช่องว่างราคาที่เกิดขึ้นระหว่าง 3 แท่งเทียน "
        "ใช้เป็นโซน retest ก่อนเข้า trade ในทิศทางเดิม"
    ),
    "Order Block": (
        "Order Block คือโซนที่สถาบันเคยส่งคำสั่งซื้อขายขนาดใหญ่ "
        "ราคามักกลับมา retest โซนนี้ก่อนเคลื่อนตัวต่อ"
    ),
    "CHoCH": (
        "CHoCH (Change of Character) คือสัญญาณเปลี่ยนทิศทางราคา "
        "เกิดเมื่อราคาทำลาย swing high/low ในทิศตรงข้ามกับ trend เดิม"
    ),
    "BOS": (
        "BOS (Break of Structure) คือการที่ราคาทลาย swing สูงสุดหรือต่ำสุดก่อนหน้า "
        "ยืนยันว่า trend กำลังดำเนินอยู่"
    ),
    "Liquidity Sweep": (
        "Liquidity Sweep คือการที่ราคากวาด stop loss ของผู้เทรด "
        "โดยทะลุเหนือ equal highs หรือต่ำกว่า equal lows ก่อนกลับทิศ"
    ),
    "Pattern W": (
        "Pattern W คือรูปแบบ double bottom ในกรอบ SMC "
        "มีจุดต่ำ 2 จุด (W2, W3) ใช้ยืนยันจุดกลับทิศขาขึ้น"
    ),
    "Pattern M": (
        "Pattern M คือรูปแบบ double top ในกรอบ SMC "
        "มีจุดสูง 2 จุด (M2, M3) ใช้ยืนยันจุดกลับทิศขาลง"
    ),
    "ATR Filter": (
        "ATR Filter ใช้ Average True Range กรอง trade "
        "เมื่อ ATR สูงเกินไป (volatility สูง) หรือต่ำเกินไป (ตลาดนิ่ง)"
    ),
    "Session Filter": (
        "Session Filter กรอง trade ให้เฉพาะช่วงเวลาที่ตลาดมี volume สูง "
        "เช่น London Open, New York Open"
    ),
    "Risk Management": (
        "Risk Management ครอบคลุมการกำหนด lot size, stop loss, "
        "daily loss limit และ drawdown เพื่อรักษาทุน"
    ),
}


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")


def concept_to_filename(concept_name: str) -> str:
    safe = re.sub(r'[\\/:*?"<>|]', "_", concept_name)
    safe = safe.replace(" ", "_")
    return f"{safe}.md"


def _thai_summary(concept_name: str, rule_types: list[str]) -> str:
    if concept_name in _THAI_SUMMARY:
        return _THAI_SUMMARY[concept_name]
    types_str = ", ".join(rule_types) if rule_types else "ยังไม่ระบุ"
    return (
        f"{concept_name} เป็น concept ที่เกี่ยวข้องกับ {types_str} "
        "กรุณาเพิ่มคำอธิบายภาษาไทยด้วยมือในส่วน Notes ด้านล่าง"
    )


def _format_rule_section(rule_type: str, rules: list[str]) -> str:
    label = {
        "entry": "Entry (เงื่อนไขเข้า)",
        "exit": "Exit (เงื่อนไขออก)",
        "stop_loss": "Stop Loss",
        "filter": "Filter (กรอง)",
        "regime": "Regime (สภาวะตลาด)",
    }.get(rule_type, rule_type.title())

    if not rules:
        return f"#### {label}\n_ยังไม่มีข้อมูล_\n"
    lines = [f"#### {label}"]
    for rule in rules:
        lines.append(f"- {rule}")
    return "\n".join(lines) + "\n"


def _build_warnings(concept: dict[str, Any]) -> list[str]:
    warnings: list[str] = []
    if concept.get("confidence", 100) < LOW_CONFIDENCE_THRESHOLD:
        warnings.append(
            f"⚠️ **Low confidence** ({concept['confidence']}/100) — "
            "ยังต้องการหลักฐานจาก source เพิ่มเติม"
        )
    if concept.get("evidence_count", 0) < SINGLE_SOURCE_THRESHOLD:
        warnings.append(
            "⚠️ **1 source only** — ควรตรวจสอบกับแหล่งข้อมูลอื่นก่อนนำไปใช้ใน EA"
        )
    return warnings


def build_auto_section(concept: dict[str, Any], rule_candidates: dict[str, list[str]]) -> str:
    concept_name = concept.get("concept", "Unknown")
    confidence = concept.get("confidence", 0)
    rule_types = concept.get("related_rule_types", [])
    source_details = concept.get("source_details", [])
    last_updated = concept.get("last_updated", _now_iso())
    evidence_count = concept.get("evidence_count", len(source_details))

    # Determine effective ea_readiness (average from source_details)
    if source_details:
        ea_readiness = int(round(sum(s.get("ea_readiness", 0) for s in source_details) / len(source_details)))
    else:
        ea_readiness = confidence

    warnings = _build_warnings(concept)

    rule_type_order = ["entry", "exit", "stop_loss", "filter", "regime"]
    all_rule_types = sorted(set(rule_types) | set(rule_candidates.keys()))

    lines: list[str] = [AUTO_START_MARKER]
    lines.append("")
    lines.append("## ข้อมูลอัตโนมัติ (Auto-Generated — ห้ามแก้ไขส่วนนี้ด้วยมือ)")
    lines.append("")

    # Warnings at top
    if warnings:
        for w in warnings:
            lines.append(w)
        lines.append("")

    # Scores table
    lines.append("### Confidence & EA Readiness")
    lines.append("")
    lines.append("| ตัวชี้วัด | ค่า |")
    lines.append("|----------|-----|")
    lines.append(f"| Confidence | **{confidence}/100** |")
    lines.append(f"| EA Readiness | **{ea_readiness}/100** |")
    lines.append(f"| Evidence Count | {evidence_count} source(s) |")
    if rule_types:
        lines.append(f"| Rule Types | {', '.join(sorted(rule_types))} |")
    lines.append("")

    # Thai summary
    lines.append("### สรุปภาษาไทย")
    lines.append("")
    lines.append(_thai_summary(concept_name, rule_types))
    lines.append("")

    # EA Rule Candidates
    lines.append("### EA Rule Candidates")
    lines.append("")
    ordered = [rt for rt in rule_type_order if rt in all_rule_types]
    extras = [rt for rt in sorted(all_rule_types) if rt not in rule_type_order]
    for rt in ordered + extras:
        rules = rule_candidates.get(rt, [])
        lines.append(_format_rule_section(rt, rules))

    # Sources table
    lines.append("### แหล่งข้อมูล (Sources)")
    lines.append("")
    lines.append("| Video | Channel | EA Readiness | Rule Completeness |")
    lines.append("|-------|---------|-------------|-------------------|")
    for sd in source_details:
        title = sd.get("title", "Untitled")
        url = sd.get("url", "")
        channel = sd.get("channel", "")
        er = sd.get("ea_readiness", 0)
        rc = sd.get("rule_completeness", 0)
        link = f"[{title}]({url})" if url else title
        lines.append(f"| {link} | {channel} | {er}/100 | {rc}/100 |")
    lines.append("")

    lines.append(f"_Updated: {last_updated}_")
    lines.append("")
    lines.append(AUTO_END_MARKER)

    return "\n".join(lines)


def _build_full_note(concept_name: str, concept: dict[str, Any], auto_section: str) -> str:
    safe_name = concept_name.replace("_", " ")
    confidence = concept.get("confidence", 0)
    rule_types = concept.get("related_rule_types", [])
    if concept.get("source_details"):
        ea_readiness = int(round(
            sum(s.get("ea_readiness", 0) for s in concept["source_details"])
            / len(concept["source_details"])
        ))
    else:
        ea_readiness = confidence
    last_updated = concept.get("last_updated", _now_iso())

    aliases_parts = [safe_name]
    frontmatter_lines = [
        "---",
        "tags: [ea-concept, ea-knowledge-brain, youtube-learned]",
        f"aliases: [{', '.join(aliases_parts)}]",
        f"concept: {safe_name}",
        f"confidence: {confidence}",
        f"ea_readiness: {ea_readiness}",
        f"last_updated: {last_updated}",
        "---",
        "",
        f"# {safe_name}",
        "",
        auto_section,
        "",
        "---",
        "",
        "## Notes (ส่วนนี้เขียนด้วยมือ — ระบบจะไม่แก้ไข)",
        "",
        "_เพิ่มหมายเหตุ, ประสบการณ์ใช้งาน, หรือ backtest ผลลัพธ์ที่นี่_",
        "",
    ]
    return "\n".join(frontmatter_lines)


def _replace_auto_section(existing: str, new_auto_section: str) -> str:
    pattern = re.compile(
        re.escape(AUTO_START_MARKER) + r".*?" + re.escape(AUTO_END_MARKER),
        re.DOTALL,
    )
    if pattern.search(existing):
        return pattern.sub(lambda _match: new_auto_section, existing)
    # Markers missing — append auto section before the last human section separator
    return existing + "\n\n" + new_auto_section


def _read_legacy_note_text(path: Path) -> str:
    try:
        return path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return path.read_text(encoding="utf-8", errors="replace")


_MAX_RULE_LEN = 300


def _sanitize_rule(rule: str) -> str | None:
    stripped = rule.strip()
    if not stripped:
        return None
    if len(stripped) > _MAX_RULE_LEN:
        return None
    return stripped


def _gather_rule_candidates(
    concept_name: str,
    source_video_ids: list[str],
    structured: dict[str, Any],
) -> dict[str, list[str]]:
    merged: dict[str, list[str]] = {}
    for vid in source_video_ids:
        item = structured.get("items", {}).get(vid, {})
        if concept_name not in item.get("concepts", []):
            continue
        for rule_type, rules in item.get("ea_rule_candidates", {}).items():
            bucket = merged.setdefault(rule_type, [])
            for rule in rules:
                clean = _sanitize_rule(rule)
                if clean and clean not in bucket:
                    bucket.append(clean)
    return merged


def write_concept_note(
    concept_name: str,
    concept_data: dict[str, Any],
    output_dir: Path,
    rule_candidates: dict[str, list[str]],
) -> dict[str, Any]:
    output_dir.mkdir(parents=True, exist_ok=True)
    filename = concept_to_filename(concept_name)
    note_path = output_dir / filename
    auto_section = build_auto_section(concept_data, rule_candidates)

    if note_path.exists():
        existing = _read_legacy_note_text(note_path)
        updated = _replace_auto_section(existing, auto_section)
        note_path.write_text(updated, encoding="utf-8")
        return {"action": "updated", "path": str(note_path)}

    full_note = _build_full_note(concept_name, concept_data, auto_section)
    note_path.write_text(full_note, encoding="utf-8")
    return {"action": "created", "path": str(note_path)}


def write_concept_notes(
    *,
    index_path: str | Path = DEFAULT_INDEX_PATH,
    structured_path: str | Path | None = None,
    output_dir: str | Path = DEFAULT_CONCEPTS_DIR,
) -> dict[str, Any]:
    index_path = Path(index_path)
    output_dir = Path(output_dir)

    if not index_path.exists():
        return {"total": 0, "created": 0, "updated": 0, "output_dir": str(output_dir)}

    index = json.loads(index_path.read_text(encoding="utf-8"))
    concepts = index.get("concepts", {})

    structured: dict[str, Any] = {"items": {}}
    if structured_path is not None:
        sp = Path(structured_path)
        if sp.exists():
            structured = json.loads(sp.read_text(encoding="utf-8"))
    elif DEFAULT_EXTRACTION_PATH.exists():
        structured = json.loads(DEFAULT_EXTRACTION_PATH.read_text(encoding="utf-8"))

    result: dict[str, Any] = {
        "total": len(concepts),
        "created": 0,
        "updated": 0,
        "output_dir": str(output_dir),
        "notes": [],
    }

    for concept_name, concept_data in concepts.items():
        source_ids = concept_data.get("sources", [])
        rule_candidates = _gather_rule_candidates(concept_name, source_ids, structured)
        note_result = write_concept_note(concept_name, concept_data, output_dir, rule_candidates)
        result[note_result["action"]] += 1
        result["notes"].append(note_result)

    return result
