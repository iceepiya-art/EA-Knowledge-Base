"""Tests for conflict_detector.py — Conflict Detection + Review Queue.

ORCA: tests written before implementation.
"""
from __future__ import annotations

import json
from pathlib import Path

import pytest

from conflict_detector import (
    DEFAULT_CONFLICT_QUEUE_PATH,
    ConflictReviewStore,
    detect_conflicts,
    make_conflict_id,
)


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def _make_index(concepts: dict) -> dict:
    return {"version": 1, "concepts": concepts}


def _concept(
    name: str,
    confidence: int = 75,
    evidence_count: int = 2,
    rule_types: list[str] | None = None,
    sources: list[str] | None = None,
    source_details: list[dict] | None = None,
) -> dict:
    src = sources or ["v001", "v002"]
    return {
        "concept": name,
        "confidence": confidence,
        "evidence_count": evidence_count,
        "related_rule_types": rule_types or ["entry", "stop_loss"],
        "sources": src,
        "source_details": source_details or [
            {
                "video_id": vid,
                "title": f"Video {vid}",
                "url": f"https://youtu.be/{vid}",
                "ea_readiness": confidence,
                "rule_completeness": 60,
                "merged_at": "2026-05-24T10:00:00+07:00",
            }
            for vid in src
        ],
        "last_updated": "2026-05-24T10:00:00+07:00",
    }


def _structured(items: dict) -> dict:
    return {"version": 1, "items": items}


def _item(video_id: str, concepts: list[str], entry: list[str] | None = None,
          stop_loss: list[str] | None = None, **kwargs) -> dict:
    return {
        "video_id": video_id,
        "title": f"Video {video_id}",
        "url": f"https://youtu.be/{video_id}",
        "concepts": concepts,
        "ea_rule_candidates": {
            "entry": entry or [],
            "stop_loss": stop_loss or [],
            "exit": [],
            "filter": [],
            "regime": [],
            **kwargs,
        },
        "quality": {"ea_readiness": 70, "rule_completeness": 65},
    }


def _write_index(path: Path, concepts: dict) -> None:
    path.write_text(json.dumps(_make_index(concepts)), encoding="utf-8")


def _write_structured(path: Path, items: dict) -> None:
    path.write_text(json.dumps(_structured(items)), encoding="utf-8")


# ---------------------------------------------------------------------------
# make_conflict_id
# ---------------------------------------------------------------------------


def test_make_conflict_id_is_deterministic():
    id1 = make_conflict_id("FVG", "low_confidence", ["v001"])
    id2 = make_conflict_id("FVG", "low_confidence", ["v001"])
    assert id1 == id2


def test_make_conflict_id_differs_by_concept():
    id1 = make_conflict_id("FVG", "low_confidence", ["v001"])
    id2 = make_conflict_id("CHoCH", "low_confidence", ["v001"])
    assert id1 != id2


def test_make_conflict_id_differs_by_type():
    id1 = make_conflict_id("FVG", "low_confidence", ["v001"])
    id2 = make_conflict_id("FVG", "low_evidence", ["v001"])
    assert id1 != id2


def test_make_conflict_id_order_independent_for_sources():
    id1 = make_conflict_id("FVG", "contradiction", ["v001", "v002"])
    id2 = make_conflict_id("FVG", "contradiction", ["v002", "v001"])
    assert id1 == id2


def test_make_conflict_id_is_12_chars_hex():
    cid = make_conflict_id("FVG", "low_confidence", ["v001"])
    assert len(cid) == 12
    assert all(c in "0123456789abcdef" for c in cid)


# ---------------------------------------------------------------------------
# ConflictReviewStore
# ---------------------------------------------------------------------------


def test_conflict_review_store_loads_empty_when_missing(tmp_path):
    store = ConflictReviewStore(tmp_path / "queue.json")
    data = store.load()
    assert data["version"] == 1
    assert data["items"] == {}


def test_conflict_review_store_saves_and_loads_roundtrip(tmp_path):
    store = ConflictReviewStore(tmp_path / "queue.json")
    data = store.load()
    data["items"]["abc"] = {"conflict_id": "abc", "status": "pending"}
    store.save(data)

    loaded = store.load()
    assert "abc" in loaded["items"]
    assert loaded["items"]["abc"]["status"] == "pending"


def test_conflict_review_store_uses_atomic_write(tmp_path):
    store = ConflictReviewStore(tmp_path / "queue.json")
    data = store.load()
    store.save(data)
    assert (tmp_path / "queue.json").exists()
    # No leftover .tmp files
    tmps = list(tmp_path.glob("*.tmp*"))
    assert len(tmps) == 0


# ---------------------------------------------------------------------------
# detect_conflicts — low_confidence
# ---------------------------------------------------------------------------


def test_detect_conflicts_flags_low_confidence(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {
        "FVG": _concept("FVG", confidence=45, evidence_count=2, rule_types=["entry", "stop_loss"]),
    })

    result = detect_conflicts(
        index_path=index_path,
        queue_path=queue_path,
    )

    queue = json.loads(queue_path.read_text(encoding="utf-8"))
    low_conf_items = [
        v for v in queue["items"].values()
        if v["type"] == "low_confidence" and v["concept"] == "FVG"
    ]
    assert len(low_conf_items) == 1
    item = low_conf_items[0]
    assert item["status"] == "pending"
    assert item["severity"] in ("medium", "high")
    assert "45" in item["summary"] or "confidence" in item["summary"].lower()
    assert result["low_confidence"] >= 1


def test_detect_conflicts_low_confidence_high_severity_below_40(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {
        "BOS": _concept("BOS", confidence=35, evidence_count=1, rule_types=["entry"]),
    })

    detect_conflicts(index_path=index_path, queue_path=queue_path)

    queue = json.loads(queue_path.read_text(encoding="utf-8"))
    items = [v for v in queue["items"].values() if v["type"] == "low_confidence"]
    assert any(v["severity"] == "high" for v in items)


def test_detect_conflicts_skips_high_confidence(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {
        "Order Block": _concept("Order Block", confidence=85),
    })

    detect_conflicts(index_path=index_path, queue_path=queue_path)

    queue = json.loads(queue_path.read_text(encoding="utf-8"))
    conf_items = [
        v for v in queue["items"].values()
        if v["type"] == "low_confidence" and v["concept"] == "Order Block"
    ]
    assert len(conf_items) == 0


# ---------------------------------------------------------------------------
# detect_conflicts — low_evidence
# ---------------------------------------------------------------------------


def test_detect_conflicts_flags_single_source(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {
        "CHoCH": _concept("CHoCH", confidence=70, evidence_count=1, sources=["v001"]),
    })

    result = detect_conflicts(index_path=index_path, queue_path=queue_path)

    queue = json.loads(queue_path.read_text(encoding="utf-8"))
    low_ev = [v for v in queue["items"].values() if v["type"] == "low_evidence"]
    assert len(low_ev) >= 1
    assert low_ev[0]["severity"] == "low"
    assert result["low_evidence"] >= 1


def test_detect_conflicts_skips_multi_source_for_low_evidence(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {
        "FVG": _concept("FVG", confidence=70, evidence_count=3, sources=["v001", "v002", "v003"]),
    })

    detect_conflicts(index_path=index_path, queue_path=queue_path)

    queue = json.loads(queue_path.read_text(encoding="utf-8"))
    low_ev = [v for v in queue["items"].values() if v["type"] == "low_evidence"]
    assert len(low_ev) == 0


# ---------------------------------------------------------------------------
# detect_conflicts — incomplete_rule
# ---------------------------------------------------------------------------


def test_detect_conflicts_flags_missing_entry_rule(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {
        "BOS": _concept("BOS", confidence=70, rule_types=["exit", "regime"]),
    })

    result = detect_conflicts(index_path=index_path, queue_path=queue_path)

    queue = json.loads(queue_path.read_text(encoding="utf-8"))
    incomplete = [v for v in queue["items"].values() if v["type"] == "incomplete_rule"]
    assert len(incomplete) >= 1
    assert any("entry" in v["summary"].lower() or "entry" in str(v) for v in incomplete)
    assert result["incomplete_rule"] >= 1


def test_detect_conflicts_flags_missing_stop_loss_rule(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {
        "FVG": _concept("FVG", confidence=70, rule_types=["entry", "exit"]),
    })

    detect_conflicts(index_path=index_path, queue_path=queue_path)

    queue = json.loads(queue_path.read_text(encoding="utf-8"))
    incomplete = [v for v in queue["items"].values() if v["type"] == "incomplete_rule"]
    assert len(incomplete) >= 1
    assert any("stop_loss" in v["summary"].lower() or "stop" in v["summary"].lower() for v in incomplete)


def test_detect_conflicts_no_incomplete_when_entry_and_stop_loss_present(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {
        "Order Block": _concept("Order Block", confidence=80, rule_types=["entry", "stop_loss", "exit"]),
    })

    detect_conflicts(index_path=index_path, queue_path=queue_path)

    queue = json.loads(queue_path.read_text(encoding="utf-8"))
    incomplete = [
        v for v in queue["items"].values()
        if v["type"] == "incomplete_rule" and v["concept"] == "Order Block"
    ]
    assert len(incomplete) == 0


# ---------------------------------------------------------------------------
# detect_conflicts — contradiction
# ---------------------------------------------------------------------------


def test_detect_conflicts_flags_contradicting_entry_rules(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    structured_path = tmp_path / "structured_extractions.json"
    queue_path = tmp_path / "queue.json"

    _write_index(index_path, {
        "FVG": _concept(
            "FVG", confidence=70, evidence_count=2, sources=["v001", "v002"],
            rule_types=["entry", "stop_loss"],
        ),
    })
    _write_structured(structured_path, {
        "v001": _item("v001", ["FVG"], entry=["Buy on FVG retest above midpoint"]),
        "v002": _item("v002", ["FVG"], entry=["Sell on FVG rejection at top"]),
    })

    result = detect_conflicts(
        index_path=index_path,
        structured_path=structured_path,
        queue_path=queue_path,
    )

    queue = json.loads(queue_path.read_text(encoding="utf-8"))
    contradictions = [v for v in queue["items"].values() if v["type"] == "contradiction"]
    assert len(contradictions) >= 1
    item = contradictions[0]
    assert item["concept"] == "FVG"
    assert item["severity"] == "high"
    assert item["rule_a"] is not None
    assert item["rule_b"] is not None
    assert item["suggested_action"] in ("manual_review", "merge_as_condition", "accept_new", "keep_old")
    assert result["contradiction"] >= 1


def test_detect_conflicts_flags_contradicting_stop_loss_direction(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    structured_path = tmp_path / "structured_extractions.json"
    queue_path = tmp_path / "queue.json"

    _write_index(index_path, {
        "Order Block": _concept(
            "Order Block", confidence=75, evidence_count=2, sources=["v001", "v002"],
            rule_types=["entry", "stop_loss"],
        ),
    })
    _write_structured(structured_path, {
        "v001": _item("v001", ["Order Block"], stop_loss=["SL below the OB low"]),
        "v002": _item("v002", ["Order Block"], stop_loss=["SL above the previous high"]),
    })

    detect_conflicts(
        index_path=index_path,
        structured_path=structured_path,
        queue_path=queue_path,
    )

    queue = json.loads(queue_path.read_text(encoding="utf-8"))
    contradictions = [
        v for v in queue["items"].values()
        if v["type"] == "contradiction" and v["concept"] == "Order Block"
    ]
    assert len(contradictions) >= 1


def test_detect_conflicts_no_contradiction_when_rules_agree(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    structured_path = tmp_path / "structured_extractions.json"
    queue_path = tmp_path / "queue.json"

    _write_index(index_path, {
        "FVG": _concept("FVG", confidence=70, evidence_count=2, sources=["v001", "v002"],
                        rule_types=["entry", "stop_loss"]),
    })
    _write_structured(structured_path, {
        "v001": _item("v001", ["FVG"], entry=["Buy on FVG retest"]),
        "v002": _item("v002", ["FVG"], entry=["Buy on FVG retest with CHoCH"]),
    })

    detect_conflicts(
        index_path=index_path,
        structured_path=structured_path,
        queue_path=queue_path,
    )

    queue = json.loads(queue_path.read_text(encoding="utf-8"))
    contradictions = [
        v for v in queue["items"].values()
        if v["type"] == "contradiction" and v["concept"] == "FVG"
    ]
    assert len(contradictions) == 0


# ---------------------------------------------------------------------------
# Idempotency
# ---------------------------------------------------------------------------


def test_detect_conflicts_is_idempotent(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {
        "FVG": _concept("FVG", confidence=45, evidence_count=1, sources=["v001"]),
    })

    result1 = detect_conflicts(index_path=index_path, queue_path=queue_path)
    queue_after_first = json.loads(queue_path.read_text(encoding="utf-8"))
    count_after_first = len(queue_after_first["items"])

    result2 = detect_conflicts(index_path=index_path, queue_path=queue_path)
    queue_after_second = json.loads(queue_path.read_text(encoding="utf-8"))
    count_after_second = len(queue_after_second["items"])

    assert count_after_first == count_after_second
    assert result2["new"] == 0
    assert result2["existing"] == count_after_first


def test_detect_conflicts_preserves_manually_resolved_items(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {
        "FVG": _concept("FVG", confidence=45, evidence_count=1, sources=["v001"]),
    })

    detect_conflicts(index_path=index_path, queue_path=queue_path)

    queue = json.loads(queue_path.read_text(encoding="utf-8"))
    first_id = next(iter(queue["items"]))
    queue["items"][first_id]["status"] = "resolved"
    queue_path.write_text(json.dumps(queue), encoding="utf-8")

    detect_conflicts(index_path=index_path, queue_path=queue_path)

    queue2 = json.loads(queue_path.read_text(encoding="utf-8"))
    assert queue2["items"][first_id]["status"] == "resolved"


def test_detect_conflicts_new_concept_adds_to_existing_queue(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"

    _write_index(index_path, {
        "FVG": _concept("FVG", confidence=45, evidence_count=1, sources=["v001"]),
    })
    detect_conflicts(index_path=index_path, queue_path=queue_path)
    first_count = len(json.loads(queue_path.read_text(encoding="utf-8"))["items"])

    _write_index(index_path, {
        "FVG": _concept("FVG", confidence=45, evidence_count=1, sources=["v001"]),
        "CHoCH": _concept("CHoCH", confidence=30, evidence_count=1, sources=["v002"]),
    })
    detect_conflicts(index_path=index_path, queue_path=queue_path)
    second_count = len(json.loads(queue_path.read_text(encoding="utf-8"))["items"])

    assert second_count > first_count


# ---------------------------------------------------------------------------
# Result stats
# ---------------------------------------------------------------------------


def test_detect_conflicts_returns_correct_stats(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {
        "FVG": _concept("FVG", confidence=45, evidence_count=1,
                        sources=["v001"], rule_types=["exit"]),
        "Order Block": _concept("Order Block", confidence=80, evidence_count=3,
                                sources=["v001", "v002", "v003"],
                                rule_types=["entry", "stop_loss"]),
    })

    result = detect_conflicts(index_path=index_path, queue_path=queue_path)

    assert "total" in result
    assert "new" in result
    assert "existing" in result
    assert "low_confidence" in result
    assert "low_evidence" in result
    assert "incomplete_rule" in result
    assert "contradiction" in result
    assert result["total"] == result["new"] + result["existing"]


def test_detect_conflicts_returns_queue_path_in_result(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {})

    result = detect_conflicts(index_path=index_path, queue_path=queue_path)

    assert "queue_path" in result
    assert str(queue_path) == result["queue_path"]


# ---------------------------------------------------------------------------
# CLI — detect-conflicts
# ---------------------------------------------------------------------------


def test_detect_conflicts_cli_creates_queue_file(tmp_path):
    from channel_intake import main

    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {
        "FVG": _concept("FVG", confidence=45, evidence_count=1,
                        sources=["v001"], rule_types=["exit"]),
    })

    exit_code = main([
        "detect-conflicts",
        "--index", str(index_path),
        "--queue", str(queue_path),
    ])

    assert exit_code == 0
    assert queue_path.exists()
    data = json.loads(queue_path.read_text(encoding="utf-8"))
    assert "items" in data
    assert len(data["items"]) >= 1


def test_detect_conflicts_cli_exits_zero_on_empty_index(tmp_path):
    from channel_intake import main

    index_path = tmp_path / "knowledge_index.json"
    queue_path = tmp_path / "queue.json"
    _write_index(index_path, {})

    exit_code = main([
        "detect-conflicts",
        "--index", str(index_path),
        "--queue", str(queue_path),
    ])

    assert exit_code == 0
