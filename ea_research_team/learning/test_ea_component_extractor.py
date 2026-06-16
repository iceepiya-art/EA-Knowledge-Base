"""Tests for ea_component_extractor.py — EA component grouping from knowledge index.

ORCA: tests written before implementation.
"""
from __future__ import annotations

import json

import pytest

from ea_component_extractor import (
    EAComponentStore,
    extract_ea_components,
)


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

_KNOWLEDGE_INDEX = {
    "version": 1,
    "concepts": {
        "FVG": {
            "concept": "FVG",
            "confidence": 80,
            "evidence_count": 3,
            "sources": ["v001", "v002"],
            "related_rule_types": ["entry", "stop_loss"],
            "source_details": [],
            "last_updated": "2026-05-24T10:00:00+07:00",
        },
        "Order Block": {
            "concept": "Order Block",
            "confidence": 60,
            "evidence_count": 1,
            "sources": ["v002"],
            "related_rule_types": ["entry"],
            "source_details": [],
            "last_updated": "2026-05-24T10:00:00+07:00",
        },
    },
}

_STRUCTURED = {
    "version": 1,
    "items": {
        "v001": {
            "video_id": "v001",
            "concepts": ["FVG", "Order Block"],
            "ea_rule_candidates": {
                "entry": ["Enter on FVG retest after CHoCH confirmation"],
                "stop_loss": ["Stop loss below order block wick"],
                "exit": ["Take profit at structure high"],
                "filter": ["Avoid during high-impact news"],
                "regime": ["Only trade in trending market structure"],
            },
            "quality": {"ea_readiness": 75, "rule_completeness": 90},
        },
        "v002": {
            "video_id": "v002",
            "concepts": ["FVG"],
            "ea_rule_candidates": {
                "entry": ["Enter on FVG retest after CHoCH confirmation"],
                "stop_loss": ["SL below the sweep wick"],
                "exit": [],
                "filter": [],
                "regime": [],
            },
            "quality": {"ea_readiness": 55, "rule_completeness": 45},
        },
        "v003": {
            "video_id": "v003",
            "concepts": [],
            "ea_rule_candidates": {
                "entry": [], "stop_loss": [], "exit": [], "filter": [], "regime": [],
            },
            "quality": {"ea_readiness": 10, "rule_completeness": 0},
        },
    },
}


# ---------------------------------------------------------------------------
# extract_ea_components — structure tests
# ---------------------------------------------------------------------------

def test_extract_returns_all_component_types():
    result = extract_ea_components(_KNOWLEDGE_INDEX, _STRUCTURED)
    comps = result["components"]
    for key in ["entry", "stop_loss", "exit", "filter", "regime"]:
        assert key in comps, f"missing component: {key}"


def test_extract_entry_rules_not_empty():
    result = extract_ea_components(_KNOWLEDGE_INDEX, _STRUCTURED)
    assert len(result["components"]["entry"]) > 0


def test_extract_deduplicates_identical_rules():
    result = extract_ea_components(_KNOWLEDGE_INDEX, _STRUCTURED)
    entries = result["components"]["entry"]
    rules = [e["rule"] for e in entries]
    assert len(rules) == len(set(rules)), "duplicate rules found"


def test_extract_frequency_counts_repeated_rule():
    result = extract_ea_components(_KNOWLEDGE_INDEX, _STRUCTURED)
    entries = result["components"]["entry"]
    # "Enter on FVG retest..." appears in v001 and v002
    fvg_entry = next(e for e in entries if "FVG retest" in e["rule"])
    assert fvg_entry["frequency"] == 2


def test_extract_rule_has_sources():
    result = extract_ea_components(_KNOWLEDGE_INDEX, _STRUCTURED)
    entry = result["components"]["entry"][0]
    assert "sources" in entry
    assert isinstance(entry["sources"], list)
    assert len(entry["sources"]) > 0


def test_extract_rule_has_concepts():
    result = extract_ea_components(_KNOWLEDGE_INDEX, _STRUCTURED)
    entry = result["components"]["entry"][0]
    assert "concepts" in entry
    assert isinstance(entry["concepts"], list)


def test_extract_rules_sorted_by_frequency_desc():
    result = extract_ea_components(_KNOWLEDGE_INDEX, _STRUCTURED)
    entries = result["components"]["entry"]
    freqs = [e["frequency"] for e in entries]
    assert freqs == sorted(freqs, reverse=True)


def test_extract_stop_loss_has_multiple_rules():
    result = extract_ea_components(_KNOWLEDGE_INDEX, _STRUCTURED)
    stop_rules = result["components"]["stop_loss"]
    assert len(stop_rules) >= 1


# ---------------------------------------------------------------------------
# extract_ea_components — summary tests
# ---------------------------------------------------------------------------

def test_extract_returns_summary():
    result = extract_ea_components(_KNOWLEDGE_INDEX, _STRUCTURED)
    assert "summary" in result
    s = result["summary"]
    for key in ["total_rules", "components_complete", "components_missing", "ea_readiness"]:
        assert key in s, f"missing summary key: {key}"


def test_summary_total_rules_correct():
    result = extract_ea_components(_KNOWLEDGE_INDEX, _STRUCTURED)
    comps = result["components"]
    total = sum(len(v) for v in comps.values())
    assert result["summary"]["total_rules"] == total


def test_summary_ea_readiness_high_when_all_present():
    result = extract_ea_components(_KNOWLEDGE_INDEX, _STRUCTURED)
    # v001 has all 5 components → ea_readiness should be high or medium
    assert result["summary"]["ea_readiness"] in ("high", "medium")


def test_summary_ea_readiness_low_when_entry_missing():
    sparse = {
        "version": 1,
        "items": {
            "v_sparse": {
                "video_id": "v_sparse",
                "concepts": [],
                "ea_rule_candidates": {
                    "entry": [], "stop_loss": ["SL below wick"],
                    "exit": [], "filter": [], "regime": [],
                },
                "quality": {"ea_readiness": 20, "rule_completeness": 10},
            }
        },
    }
    result = extract_ea_components(_KNOWLEDGE_INDEX, sparse)
    assert result["summary"]["ea_readiness"] == "low"


def test_extract_has_generated_at_field():
    result = extract_ea_components(_KNOWLEDGE_INDEX, _STRUCTURED)
    assert "generated_at" in result


def test_extract_has_version_field():
    result = extract_ea_components(_KNOWLEDGE_INDEX, _STRUCTURED)
    assert result.get("version") == 1


# ---------------------------------------------------------------------------
# EAComponentStore
# ---------------------------------------------------------------------------

def test_store_saves_and_loads(tmp_path):
    store = EAComponentStore(tmp_path / "ea_components.json")
    data = {"version": 1, "components": {"entry": []}, "summary": {}, "generated_at": "x"}
    store.save(data)
    loaded = store.load()
    assert loaded["version"] == 1
    assert "components" in loaded


def test_store_load_returns_empty_when_missing(tmp_path):
    store = EAComponentStore(tmp_path / "ea_components.json")
    loaded = store.load()
    assert loaded == {}


def test_store_atomic_write(tmp_path):
    store = EAComponentStore(tmp_path / "ea_components.json")
    data = {"version": 1, "components": {}, "summary": {}, "generated_at": "x"}
    store.save(data)
    # No .tmp file should remain
    tmp_files = list(tmp_path.glob("*.tmp*.json"))
    assert len(tmp_files) == 0
