"""Tests for concept_deduplicator.py — merge near-duplicate concept names.

ORCA: tests written before implementation.
"""
from __future__ import annotations

import pytest

from concept_deduplicator import (
    _are_duplicates,
    find_duplicate_groups,
    merge_concept_group,
    deduplicate_knowledge_index,
    deduplicate_structured_extractions,
)


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

_CONCEPTS = {
    "BOS": {
        "concept": "BOS",
        "confidence": 79,
        "evidence_count": 5,
        "sources": ["v001", "v002", "v003"],
        "related_rule_types": ["entry", "stop_loss"],
        "source_details": [],
        "last_updated": "2026-05-24T10:00:00+07:00",
    },
    "BOS (Break of Structure)": {
        "concept": "BOS (Break of Structure)",
        "confidence": 100,
        "evidence_count": 3,
        "sources": ["v003", "v004"],
        "related_rule_types": ["entry", "exit"],
        "source_details": [],
        "last_updated": "2026-05-24T15:00:00+07:00",
    },
    "Break of Structure (BOS)": {
        "concept": "Break of Structure (BOS)",
        "confidence": 100,
        "evidence_count": 2,
        "sources": ["v005"],
        "related_rule_types": ["regime"],
        "source_details": [],
        "last_updated": "2026-05-24T15:00:00+07:00",
    },
    "FVG": {
        "concept": "FVG",
        "confidence": 80,
        "evidence_count": 7,
        "sources": ["v001", "v002", "v006"],
        "related_rule_types": ["entry"],
        "source_details": [],
        "last_updated": "2026-05-24T10:00:00+07:00",
    },
    "FVG (Fair Value Gap)": {
        "concept": "FVG (Fair Value Gap)",
        "confidence": 100,
        "evidence_count": 1,
        "sources": ["v007"],
        "related_rule_types": ["entry", "stop_loss"],
        "source_details": [],
        "last_updated": "2026-05-24T15:00:00+07:00",
    },
    "CHoCH": {
        "concept": "CHoCH",
        "confidence": 83,
        "evidence_count": 5,
        "sources": ["v001", "v002"],
        "related_rule_types": ["entry"],
        "source_details": [],
        "last_updated": "2026-05-24T10:00:00+07:00",
    },
    "CHoCH (Change of Character)": {
        "concept": "CHoCH (Change of Character)",
        "confidence": 100,
        "evidence_count": 1,
        "sources": ["v008"],
        "related_rule_types": ["filter"],
        "source_details": [],
        "last_updated": "2026-05-24T15:00:00+07:00",
    },
    "Order Block": {
        "concept": "Order Block",
        "confidence": 75,
        "evidence_count": 4,
        "sources": ["v001", "v009"],
        "related_rule_types": ["entry", "stop_loss"],
        "source_details": [],
        "last_updated": "2026-05-24T10:00:00+07:00",
    },
    "SMC": {
        "concept": "SMC",
        "confidence": 90,
        "evidence_count": 2,
        "sources": ["v010"],
        "related_rule_types": ["regime"],
        "source_details": [],
        "last_updated": "2026-05-24T15:00:00+07:00",
    },
}

_INDEX = {"version": 1, "concepts": _CONCEPTS}

_STRUCTURED = {
    "version": 1,
    "items": {
        "v001": {
            "video_id": "v001",
            "concepts": ["BOS", "FVG", "CHoCH"],
            "ea_rule_candidates": {"entry": ["Enter at BOS"], "stop_loss": [], "exit": [], "filter": [], "regime": []},
        },
        "v004": {
            "video_id": "v004",
            "concepts": ["BOS (Break of Structure)", "FVG (Fair Value Gap)"],
            "ea_rule_candidates": {"entry": [], "stop_loss": [], "exit": ["Exit at BOS"], "filter": [], "regime": []},
        },
        "v008": {
            "video_id": "v008",
            "concepts": ["CHoCH (Change of Character)", "SMC"],
            "ea_rule_candidates": {"entry": [], "stop_loss": [], "exit": [], "filter": ["Filter by CHoCH"], "regime": []},
        },
    },
}


# ---------------------------------------------------------------------------
# _are_duplicates
# ---------------------------------------------------------------------------

def test_are_duplicates_base_and_expanded():
    assert _are_duplicates("BOS", "BOS (Break of Structure)") is True


def test_are_duplicates_reversed_parens():
    assert _are_duplicates("Break of Structure (BOS)", "BOS") is True


def test_are_duplicates_both_expanded():
    assert _are_duplicates("BOS (Break of Structure)", "Break of Structure (BOS)") is True


def test_are_duplicates_fvg():
    assert _are_duplicates("FVG", "FVG (Fair Value Gap)") is True


def test_are_not_duplicates_different_concepts():
    assert _are_duplicates("BOS", "CHoCH") is False


def test_are_not_duplicates_partial_match_not_enough():
    # "Expansion" should not match "Expansion and Retracement"
    assert _are_duplicates("Expansion", "Expansion and Retracement") is False


def test_are_not_duplicates_smc_and_smc_system():
    # "SMC" is a standalone concept, "SMC System" is different
    assert _are_duplicates("SMC", "SMC (Smart Money Concepts)") is True


def test_are_not_duplicates_order_block_and_bos():
    # "Order Block (BOS)" means an OB at a BOS level — not the same as "BOS"
    assert _are_duplicates("Order Block (BOS)", "BOS") is False


def test_are_not_duplicates_order_block_variants_and_bos():
    assert _are_duplicates("Order Block (BOS - Break of Structure)", "BOS") is False


def test_are_not_duplicates_cross_paren_different_concepts():
    # "BOS (Break of Structure)" has a_base="BOS" == b_paren="BOS" in "Order Block (BOS)"
    # but BOS is NOT an initialism of "Order Block" → should be False
    assert _are_duplicates("BOS (Break of Structure)", "Order Block (BOS)") is False


def test_are_duplicates_cross_match_legitimate():
    # "BOS (Break of Structure)" vs "Break of Structure (BOS)" IS the same concept
    assert _are_duplicates("BOS (Break of Structure)", "Break of Structure (BOS)") is True


def test_are_duplicates_partial_cross_with_abbrev():
    # "SMC (Smart Money)" vs "Smart Money Concepts (SMC)" — SMC is initialism of "Smart Money Concepts"
    assert _are_duplicates("SMC (Smart Money Concepts)", "Smart Money Concepts (SMC)") is True


# ---------------------------------------------------------------------------
# find_duplicate_groups
# ---------------------------------------------------------------------------

def test_find_duplicate_groups_bos_cluster():
    groups = find_duplicate_groups(_CONCEPTS)
    bos_group = next(
        (g for g in groups if "BOS" in g and "BOS (Break of Structure)" in g),
        None,
    )
    assert bos_group is not None
    assert "Break of Structure (BOS)" in bos_group


def test_find_duplicate_groups_fvg_cluster():
    groups = find_duplicate_groups(_CONCEPTS)
    fvg_group = next((g for g in groups if "FVG" in g), None)
    assert fvg_group is not None
    assert "FVG (Fair Value Gap)" in fvg_group


def test_find_duplicate_groups_non_duplicate_not_grouped():
    groups = find_duplicate_groups(_CONCEPTS)
    # SMC and Order Block are not duplicates
    for g in groups:
        assert not ("SMC" in g and "Order Block" in g)


def test_find_duplicate_groups_singletons_not_included():
    # single-member groups should not appear
    groups = find_duplicate_groups(_CONCEPTS)
    for g in groups:
        assert len(g) >= 2


# ---------------------------------------------------------------------------
# merge_concept_group
# ---------------------------------------------------------------------------

def test_merge_canonical_is_highest_evidence():
    group = ["BOS", "BOS (Break of Structure)", "Break of Structure (BOS)"]
    merged = merge_concept_group(_CONCEPTS, group)
    # BOS has evidence=5 (highest) → canonical
    assert merged["concept"] == "BOS"


def test_merge_canonical_shortest_when_equal_evidence():
    # synthetic: two concepts same evidence
    concepts = {
        "FVG": {**_CONCEPTS["FVG"], "evidence_count": 3},
        "FVG (Fair Value Gap)": {**_CONCEPTS["FVG (Fair Value Gap)"], "evidence_count": 3},
    }
    merged = merge_concept_group(concepts, ["FVG", "FVG (Fair Value Gap)"])
    assert merged["concept"] == "FVG"


def test_merge_sums_evidence_count():
    group = ["BOS", "BOS (Break of Structure)", "Break of Structure (BOS)"]
    merged = merge_concept_group(_CONCEPTS, group)
    assert merged["evidence_count"] == 5 + 3 + 2


def test_merge_unions_sources():
    group = ["BOS", "BOS (Break of Structure)", "Break of Structure (BOS)"]
    merged = merge_concept_group(_CONCEPTS, group)
    all_sources = {"v001", "v002", "v003", "v004", "v005"}
    assert set(merged["sources"]) == all_sources


def test_merge_unions_rule_types():
    group = ["BOS", "BOS (Break of Structure)", "Break of Structure (BOS)"]
    merged = merge_concept_group(_CONCEPTS, group)
    assert set(merged["related_rule_types"]) == {"entry", "stop_loss", "exit", "regime"}


def test_merge_takes_max_confidence():
    group = ["BOS", "BOS (Break of Structure)", "Break of Structure (BOS)"]
    merged = merge_concept_group(_CONCEPTS, group)
    # max(79, 100, 100) = 100
    assert merged["confidence"] == 100


# ---------------------------------------------------------------------------
# deduplicate_knowledge_index
# ---------------------------------------------------------------------------

def test_deduplicate_reduces_concept_count():
    result, _ = deduplicate_knowledge_index(_INDEX)
    # BOS cluster (3→1), FVG cluster (2→1), CHoCH cluster (2→1)
    assert len(result["concepts"]) < len(_CONCEPTS)


def test_deduplicate_canonical_names_preserved():
    result, _ = deduplicate_knowledge_index(_INDEX)
    assert "BOS" in result["concepts"]
    assert "FVG" in result["concepts"]
    assert "CHoCH" in result["concepts"]
    assert "Order Block" in result["concepts"]


def test_deduplicate_non_canonical_removed():
    result, _ = deduplicate_knowledge_index(_INDEX)
    assert "BOS (Break of Structure)" not in result["concepts"]
    assert "Break of Structure (BOS)" not in result["concepts"]
    assert "FVG (Fair Value Gap)" not in result["concepts"]
    assert "CHoCH (Change of Character)" not in result["concepts"]


def test_deduplicate_preserves_non_duplicate_concepts():
    result, _ = deduplicate_knowledge_index(_INDEX)
    assert "SMC" in result["concepts"]
    assert "Order Block" in result["concepts"]


def test_deduplicate_returns_name_map():
    _, name_map = deduplicate_knowledge_index(_INDEX)
    assert name_map.get("BOS (Break of Structure)") == "BOS"
    assert name_map.get("FVG (Fair Value Gap)") == "FVG"
    assert name_map.get("BOS") == "BOS"  # canonical maps to itself


# ---------------------------------------------------------------------------
# deduplicate_structured_extractions
# ---------------------------------------------------------------------------

def test_dedup_structured_maps_concepts_to_canonical():
    _, name_map = deduplicate_knowledge_index(_INDEX)
    result = deduplicate_structured_extractions(_STRUCTURED, name_map)
    v4 = result["items"]["v004"]
    assert "BOS (Break of Structure)" not in v4["concepts"]
    assert "BOS" in v4["concepts"]


def test_dedup_structured_removes_duplicate_concept_entries():
    _, name_map = deduplicate_knowledge_index(_INDEX)
    result = deduplicate_structured_extractions(_STRUCTURED, name_map)
    for vid, item in result["items"].items():
        concepts = item["concepts"]
        assert len(concepts) == len(set(concepts)), f"duplicate concepts in {vid}"


def test_dedup_structured_preserves_unaffected_items():
    _, name_map = deduplicate_knowledge_index(_INDEX)
    result = deduplicate_structured_extractions(_STRUCTURED, name_map)
    # v001 has canonical names already — should be unchanged
    assert "BOS" in result["items"]["v001"]["concepts"]
    assert "FVG" in result["items"]["v001"]["concepts"]
