from __future__ import annotations

import json

from research_state import build_research_state


def _write_json(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    return path


def test_research_state_prioritizes_high_conflict_review(tmp_path):
    manifest_path = _write_json(tmp_path / "channel_manifest.json", {
        "channels": {"c1": {"channel_name": "Ninja"}},
        "videos": {
            "v1": {"status": "raw_evidence_written"},
            "v2": {"status": "structured_extracted"},
            "v3": {"status": "needs_transcript_check"},
        },
    })
    structured_path = _write_json(tmp_path / "structured_extractions.json", {
        "items": {"v1": {"extraction_method": "llm"}, "v2": {"extraction_method": "keyword"}},
    })
    index_path = _write_json(tmp_path / "knowledge_index.json", {
        "concepts": {
            "FVG": {"confidence": 85, "evidence_count": 3, "related_rule_types": ["entry", "stop_loss"]},
            "BOS": {"confidence": 45, "evidence_count": 1, "related_rule_types": ["entry"]},
        }
    })
    conflict_path = _write_json(tmp_path / "conflict_review_queue.json", {
        "items": {
            "c-high": {"status": "pending", "severity": "high", "type": "contradiction"},
            "c-low": {"status": "accepted", "severity": "low", "type": "low_evidence"},
        }
    })
    concepts_dir = tmp_path / "concepts"
    concepts_dir.mkdir()
    (concepts_dir / "FVG.md").write_text("# FVG", encoding="utf-8")
    components_path = _write_json(tmp_path / "ea_components.json", {
        "components": {
            "entry": [{"rule": "entry"}],
            "stop_loss": [],
            "exit": [],
            "filter": [],
            "regime": [],
        },
        "summary": {
            "total_rules": 1,
            "components_complete": ["entry"],
            "components_missing": ["stop_loss", "exit", "filter", "regime"],
            "ea_readiness": "low",
        },
    })
    blueprint_path = tmp_path / "missing_blueprint.json"

    state = build_research_state(
        manifest_path=manifest_path,
        structured_path=structured_path,
        index_path=index_path,
        conflict_queue_path=conflict_path,
        concepts_dir=concepts_dir,
        components_path=components_path,
        blueprint_path=blueprint_path,
    )

    assert state["stage"]["id"] == "conflict_review"
    assert state["quality_gate"]["status"] == "blocked"
    assert state["recommended_action"]["id"] == "review_conflicts"
    assert state["metrics"]["conflicts"]["pending_high"] == 1
    assert state["metrics"]["concepts"]["low_confidence"] == 1


def test_research_state_recommends_blueprint_when_evidence_is_ready(tmp_path):
    manifest_path = _write_json(tmp_path / "channel_manifest.json", {
        "channels": {"c1": {}},
        "videos": {"v1": {"status": "structured_extracted"}},
    })
    structured_path = _write_json(tmp_path / "structured_extractions.json", {
        "items": {"v1": {"extraction_method": "llm"}},
    })
    index_path = _write_json(tmp_path / "knowledge_index.json", {
        "concepts": {
            "FVG": {"confidence": 90, "evidence_count": 4, "related_rule_types": ["entry"]},
            "Risk": {"confidence": 80, "evidence_count": 3, "related_rule_types": ["risk"]},
        }
    })
    conflict_path = _write_json(tmp_path / "conflict_review_queue.json", {"items": {}})
    concepts_dir = tmp_path / "concepts"
    concepts_dir.mkdir()
    for name in ("FVG", "Risk"):
        (concepts_dir / f"{name}.md").write_text(f"# {name}", encoding="utf-8")
    components_path = _write_json(tmp_path / "ea_components.json", {
        "components": {
            "entry": [{"rule": "entry"}],
            "stop_loss": [{"rule": "stop"}],
            "exit": [{"rule": "exit"}],
            "filter": [{"rule": "filter"}],
            "regime": [{"rule": "regime"}],
        },
        "summary": {
            "total_rules": 5,
            "components_complete": ["entry", "stop_loss", "exit", "filter", "regime"],
            "components_missing": [],
            "ea_readiness": "high",
        },
    })

    state = build_research_state(
        manifest_path=manifest_path,
        structured_path=structured_path,
        index_path=index_path,
        conflict_queue_path=conflict_path,
        concepts_dir=concepts_dir,
        components_path=components_path,
        blueprint_path=tmp_path / "ea_blueprint.json",
    )

    assert state["stage"]["id"] == "blueprint_ready"
    assert state["quality_gate"]["status"] == "pass"
    assert state["recommended_action"]["id"] == "build_blueprint"
    assert state["readiness_percent"] >= 80
