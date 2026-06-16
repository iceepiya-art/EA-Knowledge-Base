"""Tests for concept_note_writer.py — Obsidian Concept Note Writer.

ORCA: tests written before implementation.
"""
from __future__ import annotations

import json
from pathlib import Path

import pytest

from concept_note_writer import (
    AUTO_END_MARKER,
    AUTO_START_MARKER,
    concept_to_filename,
    build_auto_section,
    write_concept_note,
    write_concept_notes,
)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _make_concept(
    name: str = "FVG",
    confidence: int = 75,
    ea_readiness: int = 75,
    rule_completeness: int = 68,
    rule_types: list[str] | None = None,
    sources: list[str] | None = None,
    source_details: list[dict] | None = None,
) -> dict:
    video_id = (sources or ["v001"])[0]
    return {
        "concept": name,
        "confidence": confidence,
        "evidence_count": len(sources or ["v001"]),
        "related_rule_types": rule_types or ["entry", "exit"],
        "sources": sources or ["v001"],
        "source_details": source_details or [
            {
                "video_id": video_id,
                "title": "FVG Setup Video",
                "url": f"https://www.youtube.com/watch?v={video_id}",
                "ea_readiness": ea_readiness,
                "rule_completeness": rule_completeness,
                "merged_at": "2026-05-24T10:21:42+07:00",
            }
        ],
        "last_updated": "2026-05-24T10:21:42+07:00",
    }


def _make_index(concepts: dict[str, dict]) -> dict:
    return {"version": 1, "concepts": concepts}


def _make_structured(items: dict[str, dict]) -> dict:
    return {"version": 1, "items": items}


# ---------------------------------------------------------------------------
# concept_to_filename
# ---------------------------------------------------------------------------


def test_concept_to_filename_maps_spaces_to_underscores():
    assert concept_to_filename("Order Block") == "Order_Block.md"


def test_concept_to_filename_keeps_simple_names():
    assert concept_to_filename("FVG") == "FVG.md"


def test_concept_to_filename_handles_ampersand_and_special_chars():
    name = concept_to_filename("W&M Pattern")
    assert name.endswith(".md")
    assert "/" not in name and "\\" not in name


# ---------------------------------------------------------------------------
# build_auto_section
# ---------------------------------------------------------------------------


def test_build_auto_section_contains_markers():
    concept = _make_concept()
    section = build_auto_section(concept, rule_candidates={})
    assert AUTO_START_MARKER in section
    assert AUTO_END_MARKER in section


def test_build_auto_section_contains_confidence_and_readiness():
    concept = _make_concept(confidence=83, ea_readiness=83)
    section = build_auto_section(concept, rule_candidates={})
    assert "83" in section


def test_build_auto_section_contains_source_title_and_url():
    concept = _make_concept()
    section = build_auto_section(concept, rule_candidates={})
    assert "FVG Setup Video" in section


def test_build_auto_section_shows_warning_for_low_confidence():
    concept = _make_concept(confidence=45)
    section = build_auto_section(concept, rule_candidates={})
    assert "Low confidence" in section or "warning" in section.lower() or "⚠" in section


def test_build_auto_section_shows_warning_for_single_source():
    concept = _make_concept(sources=["v001"])
    section = build_auto_section(concept, rule_candidates={})
    assert "1 source" in section or "single source" in section.lower() or "⚠" in section


def test_build_auto_section_includes_rule_candidates_when_provided():
    concept = _make_concept()
    rule_candidates = {
        "entry": ["Wait for CHoCH before entry"],
        "stop_loss": ["Place SL below sweep wick"],
        "exit": [],
        "filter": [],
        "regime": [],
    }
    section = build_auto_section(concept, rule_candidates=rule_candidates)
    assert "CHoCH" in section
    assert "sweep wick" in section


def test_build_auto_section_shows_rule_types_when_no_candidates():
    concept = _make_concept(rule_types=["entry", "regime"])
    section = build_auto_section(concept, rule_candidates={})
    assert "entry" in section or "Entry" in section
    assert "regime" in section or "Regime" in section


def test_build_auto_section_includes_updated_timestamp():
    concept = _make_concept()
    section = build_auto_section(concept, rule_candidates={})
    assert "2026-05-24" in section


# ---------------------------------------------------------------------------
# write_concept_note
# ---------------------------------------------------------------------------


def test_write_concept_note_creates_file_in_output_dir(tmp_path):
    concept = _make_concept(name="FVG")
    result = write_concept_note(
        concept_name="FVG",
        concept_data=concept,
        output_dir=tmp_path,
        rule_candidates={},
    )
    assert result["action"] == "created"
    assert (tmp_path / "FVG.md").exists()


def test_write_concept_note_contains_frontmatter(tmp_path):
    concept = _make_concept(name="Order Block", confidence=83, ea_readiness=83)
    write_concept_note(
        concept_name="Order Block",
        concept_data=concept,
        output_dir=tmp_path,
        rule_candidates={},
    )
    content = (tmp_path / "Order_Block.md").read_text(encoding="utf-8")
    assert content.startswith("---")
    assert "concept:" in content
    assert "confidence:" in content
    assert "ea_readiness:" in content


def test_write_concept_note_is_idempotent(tmp_path):
    concept = _make_concept()
    first = write_concept_note("FVG", concept, tmp_path, {})
    second = write_concept_note("FVG", concept, tmp_path, {})
    assert first["action"] == "created"
    assert second["action"] == "updated"
    content_after_first = (tmp_path / "FVG.md").read_text(encoding="utf-8")
    content_after_second = (tmp_path / "FVG.md").read_text(encoding="utf-8")
    assert content_after_first == content_after_second


def test_write_concept_note_preserves_human_section_on_update(tmp_path):
    concept = _make_concept()
    write_concept_note("FVG", concept, tmp_path, {})

    note_path = tmp_path / "FVG.md"
    human_note = "\n\n## หมายเหตุส่วนตัว\n\nทดสอบ FVG แล้วดีมาก ใช้ในช่วง London session\n"
    note_path.write_text(
        note_path.read_text(encoding="utf-8") + human_note,
        encoding="utf-8",
    )

    write_concept_note("FVG", concept, tmp_path, {})

    updated = note_path.read_text(encoding="utf-8")
    assert "ทดสอบ FVG แล้วดีมาก" in updated


def test_write_concept_note_replaces_auto_section_on_update(tmp_path):
    concept_v1 = _make_concept(confidence=60)
    write_concept_note("FVG", concept_v1, tmp_path, {})

    concept_v2 = _make_concept(confidence=85)
    write_concept_note("FVG", concept_v2, tmp_path, {})

    content = (tmp_path / "FVG.md").read_text(encoding="utf-8")
    assert "85" in content
    assert content.count(AUTO_START_MARKER) == 1
    assert content.count(AUTO_END_MARKER) == 1


def test_write_concept_note_update_preserves_windows_backslashes(tmp_path):
    concept_v1 = _make_concept(sources=["local001"])
    write_concept_note("FVG", concept_v1, tmp_path, {})

    windows_path = r"C:\Users\ADMIN\Desktop\EA-Knowledge-Brain\raw\local\ex.md"
    concept_v2 = _make_concept(
        sources=["local001"],
        source_details=[
            {
                "video_id": "local001",
                "title": "Local Evidence",
                "url": windows_path,
                "channel": "local",
                "ea_readiness": 80,
                "rule_completeness": 70,
                "merged_at": "2026-05-26T13:20:00+07:00",
            }
        ],
    )

    write_concept_note("FVG", concept_v2, tmp_path, {})

    content = (tmp_path / "FVG.md").read_text(encoding="utf-8")
    assert windows_path in content
    assert content.count(AUTO_START_MARKER) == 1
    assert content.count(AUTO_END_MARKER) == 1


def test_write_concept_note_updates_legacy_non_utf8_note(tmp_path):
    note_path = tmp_path / "FVG.md"
    note_path.write_bytes(
        b"# FVG\n\nHuman note survives.\n\n<!-- EA_KNOWLEDGE_AUTO_START -->\n"
        + b"\xb9"
        + "\n<!-- EA_KNOWLEDGE_AUTO_END -->\n".encode("utf-8")
    )

    result = write_concept_note("FVG", _make_concept(), tmp_path, {})

    assert result["action"] == "updated"
    content = note_path.read_text(encoding="utf-8")
    assert "Human note survives." in content
    assert content.count(AUTO_START_MARKER) == 1
    assert content.count(AUTO_END_MARKER) == 1


def test_write_concept_note_maps_space_to_underscore_in_filename(tmp_path):
    concept = _make_concept(name="Order Block")
    write_concept_note("Order Block", concept, tmp_path, {})
    assert (tmp_path / "Order_Block.md").exists()
    assert not (tmp_path / "Order Block.md").exists()


def test_write_concept_note_creates_output_dir_if_missing(tmp_path):
    nested = tmp_path / "deep" / "concepts"
    concept = _make_concept()
    write_concept_note("FVG", concept, nested, {})
    assert (nested / "FVG.md").exists()


# ---------------------------------------------------------------------------
# write_concept_notes (batch)
# ---------------------------------------------------------------------------


def test_write_concept_notes_writes_all_concepts(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    index_path.write_text(
        json.dumps(
            _make_index(
                {
                    "FVG": _make_concept("FVG"),
                    "Order Block": _make_concept("Order Block"),
                    "CHoCH": _make_concept("CHoCH"),
                }
            )
        ),
        encoding="utf-8",
    )
    output_dir = tmp_path / "concepts"

    result = write_concept_notes(
        index_path=index_path,
        output_dir=output_dir,
    )

    assert result["total"] == 3
    assert result["created"] + result["updated"] == 3
    assert (output_dir / "FVG.md").exists()
    assert (output_dir / "Order_Block.md").exists()
    assert (output_dir / "CHoCH.md").exists()


def test_write_concept_notes_returns_zero_for_empty_index(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    index_path.write_text(json.dumps(_make_index({})), encoding="utf-8")
    output_dir = tmp_path / "concepts"

    result = write_concept_notes(index_path=index_path, output_dir=output_dir)

    assert result["total"] == 0
    assert result["created"] == 0


def test_write_concept_notes_is_idempotent_across_runs(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    index_path.write_text(
        json.dumps(_make_index({"FVG": _make_concept("FVG")})),
        encoding="utf-8",
    )
    output_dir = tmp_path / "concepts"

    first = write_concept_notes(index_path=index_path, output_dir=output_dir)
    second = write_concept_notes(index_path=index_path, output_dir=output_dir)

    assert first["created"] == 1
    assert second["created"] == 0
    assert second["updated"] == 1


def test_write_concept_notes_loads_rule_candidates_from_structured(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    structured_path = tmp_path / "structured_extractions.json"
    output_dir = tmp_path / "concepts"

    index_path.write_text(
        json.dumps(
            _make_index(
                {
                    "FVG": _make_concept(
                        "FVG",
                        sources=["v001"],
                        source_details=[
                            {
                                "video_id": "v001",
                                "title": "FVG Video",
                                "url": "https://youtu.be/v001",
                                "ea_readiness": 75,
                                "rule_completeness": 68,
                                "merged_at": "2026-05-24T10:21:42+07:00",
                            }
                        ],
                    )
                }
            )
        ),
        encoding="utf-8",
    )
    structured_path.write_text(
        json.dumps(
            _make_structured(
                {
                    "v001": {
                        "video_id": "v001",
                        "title": "FVG Video",
                        "url": "https://youtu.be/v001",
                        "concepts": ["FVG"],
                        "ea_rule_candidates": {
                            "entry": ["FVG retest after CHoCH confirmation"],
                            "stop_loss": ["SL below FVG zone low"],
                            "exit": [],
                            "filter": [],
                            "regime": [],
                        },
                        "quality": {"ea_readiness": 75, "rule_completeness": 68},
                    }
                }
            )
        ),
        encoding="utf-8",
    )

    write_concept_notes(
        index_path=index_path,
        structured_path=structured_path,
        output_dir=output_dir,
    )

    content = (output_dir / "FVG.md").read_text(encoding="utf-8")
    assert "FVG retest after CHoCH confirmation" in content
    assert "SL below FVG zone low" in content


def test_write_concept_notes_shows_warning_for_low_confidence_concept(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    low_conf = _make_concept("BOS", confidence=42, ea_readiness=42)
    index_path.write_text(
        json.dumps(_make_index({"BOS": low_conf})),
        encoding="utf-8",
    )
    output_dir = tmp_path / "concepts"

    write_concept_notes(index_path=index_path, output_dir=output_dir)

    content = (output_dir / "BOS.md").read_text(encoding="utf-8")
    assert "⚠" in content or "warning" in content.lower() or "Low confidence" in content
