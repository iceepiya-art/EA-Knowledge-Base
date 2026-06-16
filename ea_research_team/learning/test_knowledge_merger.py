import json

from knowledge_merger import KnowledgeIndexStore, merge_structured_extractions


def test_merge_structured_extractions_creates_new_concepts(tmp_path):
    structured_path = tmp_path / "structured_extractions.json"
    index_path = tmp_path / "knowledge_index.json"
    log_path = tmp_path / "knowledge_merge_log.json"
    structured_path.write_text(
        json.dumps(
            {
                "version": 1,
                "items": {
                    "v001": {
                        "video_id": "v001",
                        "url": "https://youtu.be/v001",
                        "title": "Pattern W Setup",
                        "concepts": ["Pattern W", "Liquidity Sweep"],
                        "quality": {"ea_readiness": 72, "rule_completeness": 68},
                        "ea_rule_candidates": {"entry": ["Wait for CHoCH before entry"]},
                    }
                },
            }
        ),
        encoding="utf-8",
    )

    result = merge_structured_extractions(
        structured_path=structured_path,
        index_store=KnowledgeIndexStore(index_path),
        merge_log_path=log_path,
    )

    index = json.loads(index_path.read_text(encoding="utf-8"))
    log = json.loads(log_path.read_text(encoding="utf-8"))
    assert result["new"] == 2
    assert result["reinforce"] == 0
    assert index["concepts"]["Pattern W"]["confidence"] == 72
    assert index["concepts"]["Pattern W"]["sources"] == ["v001"]
    assert log["events"][0]["merge_type"] == "new"


def test_merge_structured_extractions_reinforces_existing_concept_without_duplicate_sources(tmp_path):
    structured_path = tmp_path / "structured_extractions.json"
    index_path = tmp_path / "knowledge_index.json"
    log_path = tmp_path / "knowledge_merge_log.json"
    structured_path.write_text(
        json.dumps(
            {
                "version": 1,
                "items": {
                    "v001": {
                        "video_id": "v001",
                        "url": "https://youtu.be/v001",
                        "title": "FVG Setup A",
                        "concepts": ["FVG"],
                        "quality": {"ea_readiness": 60, "rule_completeness": 58},
                        "ea_rule_candidates": {"entry": ["FVG retest entry"]},
                    },
                    "v002": {
                        "video_id": "v002",
                        "url": "https://youtu.be/v002",
                        "title": "FVG Setup B",
                        "concepts": ["FVG"],
                        "quality": {"ea_readiness": 80, "rule_completeness": 75},
                        "ea_rule_candidates": {"entry": ["FVG with CHoCH confirmation"]},
                    },
                },
            }
        ),
        encoding="utf-8",
    )

    store = KnowledgeIndexStore(index_path)
    first = merge_structured_extractions(
        structured_path=structured_path,
        index_store=store,
        merge_log_path=log_path,
    )
    second = merge_structured_extractions(
        structured_path=structured_path,
        index_store=store,
        merge_log_path=log_path,
    )

    index = json.loads(index_path.read_text(encoding="utf-8"))
    assert first["new"] == 1
    assert first["reinforce"] == 1
    assert second["new"] == 0
    assert second["reinforce"] == 0
    assert index["concepts"]["FVG"]["sources"] == ["v001", "v002"]
    assert index["concepts"]["FVG"]["evidence_count"] == 2
    assert index["concepts"]["FVG"]["confidence"] == 70


def test_knowledge_index_store_loads_empty_shape(tmp_path):
    store = KnowledgeIndexStore(tmp_path / "knowledge_index.json")

    assert store.load() == {"version": 1, "concepts": {}}
