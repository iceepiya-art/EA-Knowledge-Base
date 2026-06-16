from __future__ import annotations

import json
from pathlib import Path

import pytest

import generate_mql5_report
import mql5_code_intake as intake
import merge_code_insights


def test_normalize_concepts_stamps_source_metadata(tmp_path):
    source = tmp_path / "EA One.mq5"
    source.write_text("void OnTick() {}", encoding="utf-8")
    file_hash = intake.get_file_hash(str(source))

    concepts = intake.normalize_concepts(
        [
            {
                "topic": "Grid Recovery",
                "description": "Adds recovery entries.",
                "category": "Recovery Logic",
                "confidence": 88,
                "code_snippet": "OpenBuy();",
            }
        ],
        source,
        file_hash,
    )

    assert concepts == [
        {
            "topic": "Grid Recovery",
            "description": "Adds recovery entries.",
            "category": "Recovery Logic",
            "confidence": 88,
            "code_snippet": "OpenBuy();",
            "source_file": str(source),
            "source_hash": file_hash,
        }
    ]


def test_discover_mql_files_skips_manifest_processed_hashes_and_honors_limit(tmp_path):
    root = tmp_path / "jobot"
    root.mkdir()
    first = root / "first.mq5"
    second = root / "second.mq4"
    third = root / "third.mqh"
    first.write_text("first", encoding="utf-8")
    second.write_text("second", encoding="utf-8")
    third.write_text("third", encoding="utf-8")
    manifest = {
        "processed_hashes": {
            intake.get_file_hash(str(first)): {"source_file": str(first)}
        }
    }

    found = intake.discover_mql_files([root], manifest=manifest, limit=1)

    assert found == [second]


def test_discover_mql_files_retries_error_manifest_records(tmp_path):
    root = tmp_path / "jobot"
    root.mkdir()
    source = root / "retry_me.mq5"
    source.write_text("void OnTick() {}", encoding="utf-8")
    manifest = {
        "processed_hashes": {
            intake.get_file_hash(str(source)): {
                "source_file": str(source),
                "status": "error",
            }
        }
    }

    found = intake.discover_mql_files([root], manifest=manifest, limit=1)

    assert found == [source]


def test_save_manifest_records_processed_files(tmp_path):
    manifest_path = tmp_path / "manifest.json"
    source = tmp_path / "source.mq5"
    source.write_text("void OnTick() {}", encoding="utf-8")
    file_hash = intake.get_file_hash(str(source))
    manifest = intake.load_manifest(manifest_path)

    intake.mark_processed(
        manifest,
        source,
        file_hash,
        concept_count=3,
        status="processed",
    )
    intake.save_manifest(manifest_path, manifest)

    saved = json.loads(manifest_path.read_text(encoding="utf-8"))
    record = saved["processed_hashes"][file_hash]
    assert record["source_file"] == str(source)
    assert record["concept_count"] == 3
    assert record["status"] == "processed"


def test_parse_json_response_tolerates_preface_and_trailing_text():
    data = intake._parse_json_response(
        'Here is the JSON:\n{"concepts": [{"topic": "Risk"}]}\nDone.'
    )

    assert data["concepts"] == [{"topic": "Risk"}]


def test_merge_code_insights_backfills_existing_concept_schema(tmp_path, monkeypatch):
    insights_path = tmp_path / "mql5_code_insights.json"
    index_path = tmp_path / "knowledge_index.json"
    source = tmp_path / "legacy.mq5"
    source.write_text("void OnTick() {}", encoding="utf-8")
    insights_path.write_text(
        json.dumps(
            [
                {
                    "topic": "Account Locking / License System",
                    "category": "Risk Management",
                    "description": "Blocks trading when account checks fail.",
                    "code_snippet": "",
                    "confidence": 90,
                    "source_file": str(source),
                }
            ]
        ),
        encoding="utf-8",
    )
    index_path.write_text(
        json.dumps(
            {
                "concepts": {
                    "MQL5 Code: Account Locking / License System": {
                        "concept": "MQL5 Code: Account Locking / License System",
                        "confidence": 80,
                        "evidence_count": 0,
                        "last_updated": "old",
                        "related_rule_types": ["execution_logic"],
                        "source_details": [],
                        "sources": [],
                    }
                }
            }
        ),
        encoding="utf-8",
    )
    monkeypatch.setattr(merge_code_insights, "CODE_INSIGHTS_PATH", insights_path)
    monkeypatch.setattr(merge_code_insights, "INDEX_PATH", index_path)

    merge_code_insights.main()

    merged = json.loads(index_path.read_text(encoding="utf-8"))
    concept = merged["concepts"]["MQL5 Code: Account Locking / License System"]
    variants = concept["rule_variants"]["execution_logic"]
    assert len(variants) == 1
    assert variants[0]["sources"]
    assert concept["evidence_count"] == 1


def test_merge_code_insights_help_does_not_write_files(tmp_path, monkeypatch):
    insights_path = tmp_path / "mql5_code_insights.json"
    index_path = tmp_path / "knowledge_index.json"
    insights_path.write_text("[]", encoding="utf-8")
    index_path.write_text('{"concepts": {}}', encoding="utf-8")
    monkeypatch.setattr(merge_code_insights, "CODE_INSIGHTS_PATH", insights_path)
    monkeypatch.setattr(merge_code_insights, "INDEX_PATH", index_path)

    with pytest.raises(SystemExit) as exc:
        merge_code_insights.main(["--help"])

    assert exc.value.code == 0
    assert index_path.read_text(encoding="utf-8") == '{"concepts": {}}'


def test_generate_mql5_report_help_does_not_write_report(tmp_path, monkeypatch):
    insights_path = tmp_path / "mql5_code_insights.json"
    report_path = tmp_path / "mql5_learning_report.md"
    insights_path.write_text("[]", encoding="utf-8")
    monkeypatch.setattr(generate_mql5_report, "CODE_INSIGHTS_PATH", insights_path)
    monkeypatch.setattr(generate_mql5_report, "REPORT_PATH", report_path, raising=False)

    with pytest.raises(SystemExit) as exc:
        generate_mql5_report.main(["--help"])

    assert exc.value.code == 0
    assert not report_path.exists()
