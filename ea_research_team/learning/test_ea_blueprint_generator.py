"""Tests for ea_blueprint_generator.py — MQL5 EA code generation from ea_components.

ORCA: tests written before implementation.
"""
from __future__ import annotations

import json

import pytest

from ea_blueprint_generator import (
    BlueprintStore,
    generate_blueprint,
)


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

_COMPONENTS_FULL = {
    "version": 1,
    "generated_at": "2026-05-24T10:00:00+07:00",
    "components": {
        "entry": [
            {"rule": "Enter on FVG retest after CHoCH confirmation", "frequency": 3, "sources": ["v001", "v002"], "concepts": ["FVG", "CHoCH"]},
            {"rule": "Enter at Order Block with W pattern", "frequency": 1, "sources": ["v003"], "concepts": ["Order Block"]},
        ],
        "stop_loss": [
            {"rule": "Stop loss below order block wick", "frequency": 2, "sources": ["v001", "v002"], "concepts": ["Order Block"]},
        ],
        "exit": [
            {"rule": "Take profit at structure high", "frequency": 2, "sources": ["v001", "v002"], "concepts": []},
        ],
        "filter": [
            {"rule": "Avoid during high-impact news", "frequency": 1, "sources": ["v001"], "concepts": []},
        ],
        "regime": [
            {"rule": "Only trade in trending market structure", "frequency": 1, "sources": ["v001"], "concepts": []},
        ],
    },
    "summary": {
        "total_rules": 7,
        "components_complete": ["entry", "stop_loss", "exit", "filter", "regime"],
        "components_missing": [],
        "ea_readiness": "high",
    },
}

_COMPONENTS_SPARSE = {
    "version": 1,
    "generated_at": "2026-05-24T10:00:00+07:00",
    "components": {
        "entry": [{"rule": "Enter on FVG retest", "frequency": 1, "sources": ["v001"], "concepts": []}],
        "stop_loss": [{"rule": "SL below wick", "frequency": 1, "sources": ["v001"], "concepts": []}],
        "exit": [],
        "filter": [],
        "regime": [],
    },
    "summary": {
        "total_rules": 2,
        "components_complete": ["entry", "stop_loss"],
        "components_missing": ["exit", "filter", "regime"],
        "ea_readiness": "medium",
    },
}

_COMPONENTS_EMPTY = {
    "version": 1,
    "generated_at": "2026-05-24T10:00:00+07:00",
    "components": {"entry": [], "stop_loss": [], "exit": [], "filter": [], "regime": []},
    "summary": {
        "total_rules": 0,
        "components_complete": [],
        "components_missing": ["entry", "stop_loss", "exit", "filter", "regime"],
        "ea_readiness": "low",
    },
}


# ---------------------------------------------------------------------------
# generate_blueprint — output structure
# ---------------------------------------------------------------------------

def test_blueprint_returns_dict():
    result = generate_blueprint(_COMPONENTS_FULL)
    assert isinstance(result, dict)


def test_blueprint_has_mql5_code():
    result = generate_blueprint(_COMPONENTS_FULL)
    assert "mql5_code" in result
    assert isinstance(result["mql5_code"], str)
    assert len(result["mql5_code"]) > 100


def test_blueprint_has_version():
    result = generate_blueprint(_COMPONENTS_FULL)
    assert result.get("version") == 1


def test_blueprint_has_generated_at():
    result = generate_blueprint(_COMPONENTS_FULL)
    assert "generated_at" in result
    assert result["generated_at"]


def test_blueprint_has_summary():
    result = generate_blueprint(_COMPONENTS_FULL)
    assert "summary" in result
    s = result["summary"]
    for key in ["ea_readiness", "total_rules_used", "components_used"]:
        assert key in s, f"missing summary key: {key}"


def test_blueprint_summary_readiness_propagated():
    result = generate_blueprint(_COMPONENTS_FULL)
    assert result["summary"]["ea_readiness"] == "high"


def test_blueprint_summary_readiness_medium():
    result = generate_blueprint(_COMPONENTS_SPARSE)
    assert result["summary"]["ea_readiness"] == "medium"


def test_blueprint_summary_total_rules():
    result = generate_blueprint(_COMPONENTS_FULL)
    assert result["summary"]["total_rules_used"] == 7


# ---------------------------------------------------------------------------
# generate_blueprint — MQL5 code content
# ---------------------------------------------------------------------------

def test_blueprint_code_has_ontick():
    code = generate_blueprint(_COMPONENTS_FULL)["mql5_code"]
    assert "OnTick" in code


def test_blueprint_code_has_oninit():
    code = generate_blueprint(_COMPONENTS_FULL)["mql5_code"]
    assert "OnInit" in code


def test_blueprint_code_has_entry_section():
    code = generate_blueprint(_COMPONENTS_FULL)["mql5_code"]
    assert "ENTRY" in code.upper()


def test_blueprint_code_has_stop_loss_section():
    code = generate_blueprint(_COMPONENTS_FULL)["mql5_code"]
    assert "STOP" in code.upper()


def test_blueprint_code_has_exit_section():
    code = generate_blueprint(_COMPONENTS_FULL)["mql5_code"]
    assert "EXIT" in code.upper() or "TAKE PROFIT" in code.upper()


def test_blueprint_code_includes_top_entry_rule():
    code = generate_blueprint(_COMPONENTS_FULL)["mql5_code"]
    assert "FVG retest" in code


def test_blueprint_code_includes_stop_loss_rule():
    code = generate_blueprint(_COMPONENTS_FULL)["mql5_code"]
    assert "order block wick" in code.lower()


def test_blueprint_code_includes_frequency():
    code = generate_blueprint(_COMPONENTS_FULL)["mql5_code"]
    assert "freq:" in code or "frequency" in code.lower()


def test_blueprint_code_has_todo_markers():
    code = generate_blueprint(_COMPONENTS_FULL)["mql5_code"]
    assert "TODO" in code


def test_blueprint_code_empty_components_has_placeholder():
    code = generate_blueprint(_COMPONENTS_EMPTY)["mql5_code"]
    # missing sections should have a placeholder comment, not crash
    assert "TODO" in code or "no" in code.lower()


def test_blueprint_code_has_property_copyright():
    code = generate_blueprint(_COMPONENTS_FULL)["mql5_code"]
    assert "#property" in code


def test_blueprint_code_has_input_parameters():
    code = generate_blueprint(_COMPONENTS_FULL)["mql5_code"]
    assert "input" in code


# ---------------------------------------------------------------------------
# BlueprintStore
# ---------------------------------------------------------------------------

def test_store_saves_and_loads(tmp_path):
    store = BlueprintStore(tmp_path / "blueprint.json")
    data = {"version": 1, "mql5_code": "// test", "summary": {}, "generated_at": "x"}
    store.save(data)
    loaded = store.load()
    assert loaded["mql5_code"] == "// test"


def test_store_load_returns_empty_when_missing(tmp_path):
    store = BlueprintStore(tmp_path / "blueprint.json")
    assert store.load() == {}


def test_store_atomic_write(tmp_path):
    store = BlueprintStore(tmp_path / "blueprint.json")
    data = {"version": 1, "mql5_code": "// ok", "summary": {}, "generated_at": "x"}
    store.save(data)
    tmp_files = list(tmp_path.glob("*.tmp*.json"))
    assert len(tmp_files) == 0
