from __future__ import annotations

import json
from pathlib import Path

from rule_usefulness_auditor import (
    classify_concern,
    main,
    run_audit,
    score_rule,
)


def test_score_rule_rewards_executable_sourced_safe_rule():
    rule = {
        "rule": "Enter buy when price breaks above BOS and retests demand zone",
        "sources": ["s1", "s2"],
        "canonical_concepts": ["BOS", "Demand Zone"],
        "category": "Entry Components",
    }
    conflicts_by_concept = {}

    scored = score_rule(rule, conflicts_by_concept)

    assert scored["score"] >= 75
    assert scored["bucket"] == "backtest_ready"
    assert scored["flags"] == []


def test_score_rule_penalizes_unbounded_martingale_no_sl():
    rule = {
        "rule": "Use martingale averaging with no stop loss until basket recovers",
        "sources": ["s1"],
        "canonical_concepts": ["Risk Management"],
        "category": "Risk Components",
    }
    conflicts_by_concept = {}

    scored = score_rule(rule, conflicts_by_concept)

    assert scored["score"] < 50
    assert scored["bucket"] == "dangerous"
    assert "unbounded_risk_language" in scored["flags"]


def test_score_rule_pairs_pending_conflict_by_concept():
    rule = {
        "rule": "Risk 2 percent per trade with hard stop loss",
        "sources": ["s1", "s2"],
        "canonical_concepts": ["Risk Management"],
        "category": "Risk Components",
    }
    conflicts_by_concept = {
        "Risk Management": [
            {
                "conflict_id": "abc123",
                "severity": "high",
                "type": "contradiction",
                "status": "pending",
            }
        ]
    }

    scored = score_rule(rule, conflicts_by_concept)

    assert scored["bucket"] == "review_first"
    assert scored["blocked_by_conflicts"] == ["abc123"]
    assert "pending_high_conflict" in scored["flags"]


def test_score_rule_rejects_non_trading_contract_language():
    rule = {
        "rule": "Contractor does not have authority to enter into agreements on behalf of Client",
        "sources": ["s1", "s2"],
        "canonical_concepts": [],
        "category": "Entry Components",
    }
    conflicts_by_concept = {}

    scored = score_rule(rule, conflicts_by_concept)

    assert scored["bucket"] == "reject_candidate"
    assert scored["score"] < 40
    assert "non_trading_language" in scored["flags"]


def test_score_rule_rejects_notes_distribution_language_with_sell_word():
    rule = {
        "rule": "Please do not sell or copy or spread this notes",
        "sources": ["s1"],
        "canonical_concepts": [],
        "category": "Entry Components",
    }
    conflicts_by_concept = {}

    scored = score_rule(rule, conflicts_by_concept)

    assert scored["bucket"] == "reject_candidate"
    assert "non_trading_language" in scored["flags"]


def test_score_rule_without_concepts_is_not_backtest_ready():
    rule = {
        "rule": "Enter buy after CHoCH confirmation and FVG retest",
        "sources": ["s1"],
        "canonical_concepts": [],
        "category": "Entry Components",
    }
    conflicts_by_concept = {}

    scored = score_rule(rule, conflicts_by_concept)

    assert scored["bucket"] == "review_first"
    assert "missing_concepts" in scored["flags"]


def test_classify_concern_groups_risk_and_entry_terms():
    assert classify_concern("Risk Management", "no stop loss martingale lot") == "risk_management"
    assert classify_concern("BOS", "buy when price breaks structure") == "entry_logic"


def _write_json(path: Path, data: dict):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")
    return path


def test_run_audit_writes_json_and_markdown_reports(tmp_path):
    components_path = _write_json(tmp_path / "ea_components.json", {
        "components": {
            "Entry Components": [
                {
                    "rule": "Enter buy when price breaks above BOS and retests demand zone",
                    "sources": ["s1", "s2"],
                    "canonical_concepts": ["BOS"],
                    "frequency": 2,
                }
            ],
            "Risk Components": [
                {
                    "rule": "Use martingale averaging with no stop loss until basket recovers",
                    "sources": ["s3"],
                    "canonical_concepts": ["Risk Management"],
                    "frequency": 1,
                }
            ],
        }
    })
    conflict_path = _write_json(tmp_path / "conflict_review_queue.json", {
        "items": {
            "c1": {
                "conflict_id": "c1",
                "concept": "Risk Management",
                "severity": "high",
                "type": "contradiction",
                "status": "pending",
                "summary": "Risk rule contradiction",
                "rule_a": "Use hard SL",
                "rule_b": "Use no SL",
            }
        }
    })

    result = run_audit(
        components_path=components_path,
        conflict_path=conflict_path,
        output_dir=tmp_path,
        report_date="2026-06-07",
    )

    assert result["summary"]["total_rules"] == 2
    assert result["summary"]["buckets"]["backtest_ready"] == 1
    assert result["summary"]["buckets"]["dangerous"] == 1
    assert (tmp_path / "rule_usefulness_audit_2026-06-07.json").exists()
    assert (tmp_path / "rule_usefulness_audit_2026-06-07.md").exists()
    assert (tmp_path / "conflict_evidence_audit_2026-06-07.json").exists()
    assert (tmp_path / "conflict_evidence_audit_2026-06-07.md").exists()
    rule_md = (tmp_path / "rule_usefulness_audit_2026-06-07.md").read_text(encoding="utf-8")
    assert "Top Backtest-Ready Rules" in rule_md


def test_main_cli_generates_reports(tmp_path):
    components_path = _write_json(tmp_path / "ea_components.json", {
        "components": {
            "Entry Components": [
                {
                    "rule": "Enter sell when price breaks below support",
                    "sources": ["s1", "s2"],
                    "canonical_concepts": ["Breakdown"],
                }
            ]
        }
    })
    conflict_path = _write_json(tmp_path / "conflict_review_queue.json", {"items": {}})

    code = main([
        "--components", str(components_path),
        "--conflicts", str(conflict_path),
        "--output-dir", str(tmp_path),
        "--date", "2026-06-07",
    ])

    assert code == 0
    assert (tmp_path / "rule_usefulness_audit_2026-06-07.json").exists()
