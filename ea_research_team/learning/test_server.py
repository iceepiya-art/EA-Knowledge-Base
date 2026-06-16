"""Tests for server.py — Flask API server for the Learning Pipeline.

ORCA: tests written before implementation.
Uses Flask test client + unittest.mock to avoid real network calls.
"""
from __future__ import annotations

import json
import io
from pathlib import Path
from unittest.mock import patch

import pytest

import server as server_module
from server import create_app


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

@pytest.fixture
def tmp_queue(tmp_path):
    q = tmp_path / "conflict_review_queue.json"
    q.write_text(json.dumps({
        "version": 1,
        "items": {
            "abc123def456": {
                "conflict_id": "abc123def456",
                "concept": "FVG",
                "severity": "medium",
                "type": "low_confidence",
                "summary": "Low confidence test",
                "affected_sources": ["v001"],
                "rule_a": None,
                "rule_b": None,
                "suggested_action": "manual_review",
                "status": "pending",
                "detected_at": "2026-05-24T10:00:00+07:00",
            },
            "bbb222eee555": {
                "conflict_id": "bbb222eee555",
                "concept": "BOS",
                "severity": "high",
                "type": "incomplete_rule",
                "summary": "Missing stop loss rule",
                "affected_sources": ["v002"],
                "rule_a": None,
                "rule_b": None,
                "suggested_action": "manual_review",
                "status": "pending",
                "detected_at": "2026-05-24T10:01:00+07:00",
            },
            "ccc333fff666": {
                "conflict_id": "ccc333fff666",
                "concept": "FVG",
                "severity": "low",
                "type": "low_evidence",
                "summary": "Only one source",
                "affected_sources": ["v003"],
                "rule_a": "Enter on FVG retest",
                "rule_b": "Enter on OB retest",
                "suggested_action": "merge",
                "status": "resolved",
                "detected_at": "2026-05-24T10:02:00+07:00",
            },
        },
    }), encoding="utf-8")
    return q


@pytest.fixture
def tmp_index(tmp_path):
    idx = tmp_path / "knowledge_index.json"
    idx.write_text(json.dumps({
        "version": 1,
        "concepts": {
            "FVG": {
                "concept": "FVG",
                "confidence": 75,
                "evidence_count": 2,
                "related_rule_types": ["entry", "stop_loss"],
                "sources": ["v001", "v002"],
                "source_details": [],
                "last_updated": "2026-05-24T10:00:00+07:00",
            }
        },
    }), encoding="utf-8")
    return idx


@pytest.fixture
def tmp_manifest(tmp_path):
    m = tmp_path / "channel_manifest.json"
    m.write_text(json.dumps({
        "version": 1,
        "channels": {},
        "videos": {
            "v001": {"video_id": "v001", "status": "raw_evidence_written"},
            "v002": {"video_id": "v002", "status": "discovered"},
            "v003": {"video_id": "v003", "status": "needs_transcript_check"},
            "v004": {"video_id": "v004", "status": "structured_extracted"},
        },
    }), encoding="utf-8")
    return m


def test_learning_health_endpoint_is_lightweight():
    app = create_app({"TESTING": True})

    data = app.test_client().get("/api/learning/health").get_json()

    assert data == {"status": "ok", "service": "ea-knowledge-brain"}


@pytest.fixture
def tmp_components(tmp_path):
    cp = tmp_path / "ea_components.json"
    cp.write_text(json.dumps({
        "version": 1,
        "generated_at": "2026-05-24T10:00:00+07:00",
        "components": {
            "entry": [{"rule": "Enter on FVG retest", "frequency": 2, "sources": ["v001"], "concepts": ["FVG"]}],
            "stop_loss": [{"rule": "SL below OB wick", "frequency": 1, "sources": ["v001"], "concepts": []}],
            "exit": [{"rule": "TP at structure high", "frequency": 1, "sources": ["v001"], "concepts": []}],
            "filter": [],
            "regime": [],
        },
        "summary": {
            "total_rules": 3,
            "components_complete": ["entry", "stop_loss", "exit"],
            "components_missing": ["filter", "regime"],
            "ea_readiness": "medium",
        },
    }), encoding="utf-8")
    return cp


@pytest.fixture
def app(tmp_path, tmp_queue, tmp_index, tmp_manifest, tmp_components):
    structured = tmp_path / "structured_extractions.json"
    structured.write_text(json.dumps({"version": 1, "items": {}}), encoding="utf-8")
    concepts_dir = tmp_path / "concepts"
    concepts_dir.mkdir()
    return create_app({
        "TESTING": True,
        "INDEX_PATH": str(tmp_index),
        "STRUCTURED_PATH": str(structured),
        "MANIFEST_PATH": str(tmp_manifest),
        "CONFLICT_QUEUE_PATH": str(tmp_queue),
        "CONCEPTS_DIR": str(concepts_dir),
        "RAW_DIR": str(tmp_path / "raw" / "youtube"),
        "LOCAL_RAW_DIR": str(tmp_path / "raw" / "local"),
        "REMOTE_INBOX_ROOT": str(tmp_path / "remote-inbox"),
        "MERGE_LOG_PATH": str(tmp_path / "merge_log.json"),
        "COMPONENTS_PATH": str(tmp_components),
        "BLUEPRINT_PATH": str(tmp_path / "ea_blueprint.json"),
        "COOKIES_PATH": str(tmp_path / "youtube_cookies.txt"),
        "EA_REGISTRY_PATH": str(tmp_path / "ea_registry.json"),
        "DECISION_JOURNAL_PATH": str(tmp_path / "decision_journal.json"),
        "RISK_GATE_PATH": str(tmp_path / "risk_gate.json"),
        "COMMAND_STATE_PATH": str(tmp_path / "command_state.json"),
        "BLADE_INTENTS_PATH": str(tmp_path / "blade_intents.json"),
        "TRADE_RECORDS_PATH": str(tmp_path / "trade_records.csv"),
        "OPERATOR_REPORTS_DIR": str(tmp_path / "raw" / "operator_reports"),
    })


@pytest.fixture
def client(app):
    return app.test_client()


# ---------------------------------------------------------------------------
# EA Registry API
# ---------------------------------------------------------------------------


def _ea_payload(**overrides):
    payload = {
        "ea_id": "EA_GOLD_SCALPER_01",
        "ea_name": "Gold Scalper",
        "ea_version": "1.0.0",
        "magic_number": 26060801,
        "symbol": "XAUUSD",
        "timeframe": "M15",
        "terminal_id": "MT5-LIVE-01",
        "account_id": "12345678",
        "strategy_family": "scalping",
        "status": "stopped",
    }
    payload.update(overrides)
    return payload


def test_trading_eas_list_starts_empty(client):
    resp = client.get("/api/trading/eas")

    assert resp.status_code == 200
    assert resp.get_json() == {"items": [], "total": 0}


def test_trading_eas_registers_and_returns_ea(client):
    resp = client.post("/api/trading/eas", json=_ea_payload())

    assert resp.status_code == 201
    data = resp.get_json()
    assert data["ea"]["ea_id"] == "EA_GOLD_SCALPER_01"
    assert data["ea"]["magic_number"] == 26060801
    assert data["ea"]["terminal_id"] == "MT5-LIVE-01"

    listed = client.get("/api/trading/eas").get_json()
    assert listed["total"] == 1
    assert listed["items"][0]["ea_id"] == "EA_GOLD_SCALPER_01"


def test_trading_eas_rejects_duplicate_magic_in_same_terminal_account(client):
    client.post("/api/trading/eas", json=_ea_payload())

    resp = client.post(
        "/api/trading/eas",
        json=_ea_payload(ea_id="EA_BREAKOUT_02", ea_name="Breakout 02"),
    )

    assert resp.status_code == 400
    assert "magic_number already registered" in resp.get_json()["error"]


def test_trading_eas_gets_one_registered_ea(client):
    client.post("/api/trading/eas", json=_ea_payload())

    resp = client.get("/api/trading/eas/EA_GOLD_SCALPER_01")

    assert resp.status_code == 200
    assert resp.get_json()["ea"]["ea_name"] == "Gold Scalper"


def test_trading_eas_returns_404_for_unknown_ea(client):
    resp = client.get("/api/trading/eas/UNKNOWN_EA")

    assert resp.status_code == 404
    assert resp.get_json() == {"error": "EA not found"}


# ---------------------------------------------------------------------------
# Decision Journal API
# ---------------------------------------------------------------------------


def _decision_payload(**overrides):
    payload = {
        "ea_id": "EA_GOLD_SCALPER_01",
        "action": "buy",
        "confidence": 74,
        "symbol": "XAUUSD",
        "timeframe": "M15",
        "reason": "HAWK sees momentum continuation",
        "sl": 2310.5,
        "tp": 2324.0,
        "hawk": {"signal": "buy", "confidence": 74},
        "sage": {"veto": False, "comment": "Risk acceptable"},
        "risk_gate": {"approved": True, "max_lot": 0.01},
        "blade": {"mode": "dry_run", "status": "ready"},
    }
    payload.update(overrides)
    return payload


def test_trading_decisions_reject_missing_registered_ea(client):
    resp = client.post("/api/trading/decisions", json=_decision_payload())

    assert resp.status_code == 400
    assert "Unknown ea_id" in resp.get_json()["error"]


def test_trading_decisions_records_and_lists_by_ea_id(client):
    client.post("/api/trading/eas", json=_ea_payload())

    created = client.post("/api/trading/decisions", json=_decision_payload())

    assert created.status_code == 201
    decision = created.get_json()["decision"]
    assert decision["ea_id"] == "EA_GOLD_SCALPER_01"
    assert decision["decision_id"]
    assert decision["blade"]["mode"] == "dry_run"

    listed = client.get("/api/trading/decisions?ea_id=EA_GOLD_SCALPER_01").get_json()
    assert listed["total"] == 1
    assert listed["items"][0]["decision_id"] == decision["decision_id"]


def test_trading_decision_stats_summarize_veto_and_risk_rejects(client):
    client.post("/api/trading/eas", json=_ea_payload())
    client.post("/api/trading/decisions", json=_decision_payload(action="buy"))
    client.post(
        "/api/trading/decisions",
        json=_decision_payload(action="hold", sage={"veto": True}, risk_gate={"approved": False}),
    )

    data = client.get("/api/trading/decision-stats?ea_id=EA_GOLD_SCALPER_01").get_json()

    assert data["stats"]["ea_id"] == "EA_GOLD_SCALPER_01"
    assert data["stats"]["total"] == 2
    assert data["stats"]["by_action"] == {"buy": 1, "sell": 0, "hold": 1}
    assert data["stats"]["veto_count"] == 1
    assert data["stats"]["risk_rejected_count"] == 1


def test_trading_ea_detail_returns_identity_stats_recent_decisions_and_trade_placeholders(client):
    client.post("/api/trading/eas", json=_ea_payload())
    client.post("/api/trading/eas", json=_ea_payload(ea_id="EA_BREAKOUT_02", magic_number=26060802))
    client.post("/api/trading/decisions", json=_decision_payload(action="buy"))
    client.post(
        "/api/trading/decisions",
        json=_decision_payload(action="hold", sage={"veto": True}, risk_gate={"approved": False}),
    )
    client.post(
        "/api/trading/decisions",
        json=_decision_payload(ea_id="EA_BREAKOUT_02", symbol="EURUSD", action="sell"),
    )

    resp = client.get("/api/trading/eas/EA_GOLD_SCALPER_01/detail")

    assert resp.status_code == 200
    data = resp.get_json()
    assert data["ea"]["ea_id"] == "EA_GOLD_SCALPER_01"
    assert data["decision_stats"]["total"] == 2
    assert data["decision_stats"]["by_action"] == {"buy": 1, "sell": 0, "hold": 1}
    assert data["decision_stats"]["veto_count"] == 1
    assert data["decision_stats"]["risk_rejected_count"] == 1
    assert [item["ea_id"] for item in data["recent_decisions"]] == [
        "EA_GOLD_SCALPER_01",
        "EA_GOLD_SCALPER_01",
    ]
    assert data["trade_stats"] == {
        "source": "not_connected",
        "total_trades": 0,
        "wins": 0,
        "losses": 0,
        "win_rate": None,
        "net_pnl": None,
    }


def test_trading_ea_detail_includes_connected_trade_stats_when_csv_exists(client, tmp_path):
    trade_path = tmp_path / "trade_records.csv"
    trade_path.write_text(
        "\n".join(
            [
                "time,ea_id,symbol,pnl,equity",
                "2026-06-01 10:00,EA_GOLD_SCALPER_01,XAUUSD,20.0,100020.0",
                "2026-06-01 11:00,EA_GOLD_SCALPER_01,XAUUSD,-5.0,100015.0",
                "2026-06-01 12:00,EA_BREAKOUT_02,EURUSD,100.0,100115.0",
            ]
        ),
        encoding="utf-8",
    )
    client.post("/api/trading/eas", json=_ea_payload())

    resp = client.get("/api/trading/eas/EA_GOLD_SCALPER_01/detail")

    assert resp.status_code == 200
    assert resp.get_json()["trade_stats"] == {
        "source": "csv",
        "total_trades": 2,
        "wins": 1,
        "losses": 1,
        "win_rate": 50.0,
        "net_pnl": 15.0,
    }


def test_trading_ea_detail_includes_read_only_decision_to_trade_comparison(client, tmp_path):
    trade_path = tmp_path / "trade_records.csv"
    trade_path.write_text(
        "\n".join(
            [
                "time,ea_id,symbol,pnl,equity",
                "2026-06-01 10:00,EA_GOLD_SCALPER_01,XAUUSD,20.0,100020.0",
                "2026-06-01 11:00,EA_GOLD_SCALPER_01,XAUUSD,-5.0,100015.0",
            ]
        ),
        encoding="utf-8",
    )
    client.post("/api/trading/eas", json=_ea_payload())
    client.post("/api/trading/commands", json={"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01", "command": "start"})
    client.post("/api/trading/decisions", json=_decision_payload(action="buy"))
    client.post(
        "/api/trading/decisions",
        json=_decision_payload(action="hold", sage={"veto": True}, risk_gate={"approved": False}),
    )
    client.post("/api/trading/blade/dry-run", json=_blade_payload(decision_id="DJ-approved"))
    client.post(
        "/api/trading/blade/dry-run",
        json=_blade_payload(decision_id="DJ-risk-reject", risk_gate={"approved": False}),
    )

    resp = client.get("/api/trading/eas/EA_GOLD_SCALPER_01/detail")

    assert resp.status_code == 200
    comparison = resp.get_json()["performance_comparison"]
    assert comparison == {
        "ea_id": "EA_GOLD_SCALPER_01",
        "mode": "read_only",
        "decision_total": 2,
        "trade_total": 2,
        "decision_to_trade_ratio": 1.0,
        "win_rate": 50.0,
        "net_pnl": 15.0,
        "risk_rejected_count": 1,
        "blade_intents_total": 2,
        "blade_rejected_count": 1,
        "blade_blocked_count": 0,
        "command_allowed": True,
        "command_reasons": [],
        "summary_label": "profitable_with_rejections",
    }


def test_trading_ea_detail_returns_404_for_unknown_ea(client):
    resp = client.get("/api/trading/eas/UNKNOWN_EA/detail")

    assert resp.status_code == 404
    assert resp.get_json() == {"error": "EA not found"}


def test_trading_trade_records_import_updates_only_configured_trade_path(client, tmp_path):
    trade_path = tmp_path / "trade_records.csv"
    unrelated_path = tmp_path / "unrelated_trades.csv"
    unrelated_path.write_text("time,pnl\n2026-01-01,999\n", encoding="utf-8")
    client.post("/api/trading/eas", json=_ea_payload())

    resp = client.post(
        "/api/trading/trade-records/import",
        json={
            "filename": "operator_backtest.csv",
            "content": "time,ea_id,symbol,pnl,equity\n2026-06-01,EA_GOLD_SCALPER_01,XAUUSD,12.5,100012.5\n",
        },
    )

    assert resp.status_code == 201
    data = resp.get_json()
    assert data["trade_records"]["status"] == "imported"
    assert data["trade_records"]["filename"] == "operator_backtest.csv"
    assert data["trade_records"]["rows"] == 1
    assert data["trade_records"]["path"].endswith("trade_records.csv")
    assert trade_path.read_text(encoding="utf-8").startswith("time,ea_id,symbol,pnl,equity")
    assert unrelated_path.read_text(encoding="utf-8") == "time,pnl\n2026-01-01,999\n"

    detail = client.get("/api/trading/eas/EA_GOLD_SCALPER_01/detail").get_json()
    assert detail["trade_stats"]["source"] == "csv"
    assert detail["trade_stats"]["total_trades"] == 1
    assert detail["trade_stats"]["net_pnl"] == 12.5


def test_trading_operator_readiness_reports_end_to_end_workflow(client, tmp_path):
    (tmp_path / "trade_records.csv").write_text(
        "time,ea_id,symbol,pnl,equity\n2026-06-01,EA_GOLD_SCALPER_01,XAUUSD,12.5,100012.5\n",
        encoding="utf-8",
    )
    client.post("/api/trading/eas", json=_ea_payload())
    client.post("/api/trading/commands", json={"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01", "command": "start"})
    client.post("/api/trading/decisions", json=_decision_payload(action="buy"))
    client.post("/api/trading/blade/dry-run", json=_blade_payload(decision_id="DJ-ready"))

    resp = client.get("/api/trading/operator-readiness")

    assert resp.status_code == 200
    data = resp.get_json()["operator_readiness"]
    assert data["mode"] == "dry_run_readiness"
    assert data["ready"] is True
    assert data["checks"]["api"]["ready"] is True
    assert data["checks"]["ea_registry"]["total"] == 1
    assert data["checks"]["ea_detail"]["with_comparison"] == 1
    assert data["checks"]["trade_records"]["source"] == "csv"
    assert data["checks"]["blade"]["total"] == 1
    assert data["checks"]["command_state"]["blocked_eas"] == 0
    assert data["operator_next_steps"] == [
        "Import latest MT5/backtest CSV when trade data changes.",
        "Review EA Detail comparison before creating BLADE dry-run intents.",
        "Use Command State controls for start/stop/kill while order_send remains false.",
    ]


def test_trading_operator_readiness_export_writes_durable_report_without_mutating_state(client, tmp_path):
    (tmp_path / "trade_records.csv").write_text(
        "time,ea_id,symbol,pnl,equity\n2026-06-01,EA_GOLD_SCALPER_01,XAUUSD,12.5,100012.5\n",
        encoding="utf-8",
    )
    client.post("/api/trading/eas", json=_ea_payload())
    client.post("/api/trading/commands", json={"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01", "command": "start"})
    client.post("/api/trading/decisions", json=_decision_payload(action="buy"))
    client.post("/api/trading/blade/dry-run", json=_blade_payload(decision_id="DJ-ready"))
    before = client.get("/api/trading/operator-readiness").get_json()["operator_readiness"]

    resp = client.post("/api/trading/operator-readiness/export", json={"note": "pre-session check"})

    assert resp.status_code == 201
    data = resp.get_json()["report"]
    assert data["status"] == "exported"
    assert data["path"].endswith(".md")
    assert data["filename"].startswith("operator_readiness_")
    report_path = Path(data["path"])
    assert report_path.exists()
    assert str(tmp_path / "raw" / "operator_reports") in str(report_path)
    text = report_path.read_text(encoding="utf-8")
    assert "# Operator Readiness Report" in text
    assert "ready: true" in text
    assert "ea_total: 1" in text
    assert "trade_source: csv" in text
    assert "blade_total: 1" in text
    assert "blocked_eas: 0" in text
    assert "pre-session check" in text

    after = client.get("/api/trading/operator-readiness").get_json()["operator_readiness"]
    assert after["ready"] == before["ready"]
    assert after["checks"]["blade"]["total"] == before["checks"]["blade"]["total"]
    assert after["checks"]["ea_registry"]["total"] == before["checks"]["ea_registry"]["total"]


def test_trading_pre_live_checklist_passes_only_with_snapshot_and_dry_run_safety(client, tmp_path):
    (tmp_path / "trade_records.csv").write_text(
        "time,ea_id,symbol,pnl,equity\n2026-06-01,EA_GOLD_SCALPER_01,XAUUSD,12.5,100012.5\n",
        encoding="utf-8",
    )
    client.post("/api/trading/eas", json=_ea_payload())
    client.post("/api/trading/commands", json={"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01", "command": "start"})
    client.post("/api/trading/decisions", json=_decision_payload(action="buy"))
    client.post("/api/trading/blade/dry-run", json=_blade_payload(decision_id="DJ-ready"))
    export = client.post("/api/trading/operator-readiness/export", json={"note": "pre-live snapshot"})
    report_path = export.get_json()["report"]["path"]

    resp = client.get("/api/trading/pre-live-checklist")

    assert resp.status_code == 200
    data = resp.get_json()["pre_live_checklist"]
    assert data["mode"] == "pre_live_safety_checklist"
    assert data["ready"] is True
    assert data["live_trading_enabled"] is False
    assert data["order_send_enabled"] is False
    assert data["checks"]["operator_readiness"]["ready"] is True
    assert data["checks"]["command_state"]["ready"] is True
    assert data["checks"]["operator_report_snapshot"]["ready"] is True
    assert data["checks"]["operator_report_snapshot"]["latest_path"] == report_path
    assert data["checks"]["blade_order_send_disabled"]["ready"] is True
    assert data["checks"]["blade_order_send_disabled"]["checked_intents"] == 1
    assert data["blocking_reasons"] == []


def test_trading_pre_live_checklist_fails_when_any_ea_is_command_blocked(client, tmp_path):
    (tmp_path / "trade_records.csv").write_text(
        "time,ea_id,symbol,pnl,equity\n2026-06-01,EA_GOLD_SCALPER_01,XAUUSD,12.5,100012.5\n",
        encoding="utf-8",
    )
    client.post("/api/trading/eas", json=_ea_payload())
    client.post("/api/trading/commands", json={"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01", "command": "start"})
    client.post("/api/trading/decisions", json=_decision_payload(action="buy"))
    client.post("/api/trading/blade/dry-run", json=_blade_payload(decision_id="DJ-ready"))
    client.post("/api/trading/operator-readiness/export", json={"note": "pre-live snapshot"})
    client.post("/api/trading/commands", json={"scope": "global", "command": "kill", "reason": "manual block"})

    resp = client.get("/api/trading/pre-live-checklist")

    assert resp.status_code == 200
    data = resp.get_json()["pre_live_checklist"]
    assert data["ready"] is False
    assert data["checks"]["operator_readiness"]["ready"] is False
    assert data["checks"]["command_state"]["ready"] is False
    assert "command_state_blocked" in data["blocking_reasons"]
    assert data["live_trading_enabled"] is False
    assert data["order_send_enabled"] is False


def test_trading_pre_live_checklist_ignores_non_export_feature_notes(client, tmp_path):
    (tmp_path / "trade_records.csv").write_text(
        "time,ea_id,symbol,pnl,equity\n2026-06-01,EA_GOLD_SCALPER_01,XAUUSD,12.5,100012.5\n",
        encoding="utf-8",
    )
    reports_dir = tmp_path / "raw" / "operator_reports"
    reports_dir.mkdir(parents=True)
    (reports_dir / "operator_readiness_report_export_feature_2026-06-09.md").write_text(
        "# Feature note, not an exported operator snapshot\n",
        encoding="utf-8",
    )
    client.post("/api/trading/eas", json=_ea_payload())
    client.post("/api/trading/commands", json={"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01", "command": "start"})
    client.post("/api/trading/decisions", json=_decision_payload(action="buy"))
    client.post("/api/trading/blade/dry-run", json=_blade_payload(decision_id="DJ-ready"))

    resp = client.get("/api/trading/pre-live-checklist")

    data = resp.get_json()["pre_live_checklist"]
    assert data["ready"] is False
    assert data["checks"]["operator_report_snapshot"]["ready"] is False
    assert data["checks"]["operator_report_snapshot"]["latest_path"] is None
    assert "operator_report_snapshot" in data["blocking_reasons"]


# ---------------------------------------------------------------------------
# Risk Gate API
# ---------------------------------------------------------------------------


def _risk_request(**overrides):
    payload = {
        "ea_id": "EA_GOLD_SCALPER_01",
        "requested_lot": 0.01,
        "open_positions": [],
        "daily_pnl": 0,
    }
    payload.update(overrides)
    return payload


def test_trading_risk_evaluate_approves_small_registered_ea_request(client):
    client.post("/api/trading/eas", json=_ea_payload())

    resp = client.post("/api/trading/risk/evaluate", json=_risk_request())

    assert resp.status_code == 200
    data = resp.get_json()
    assert data["risk_gate"]["approved"] is True
    assert data["risk_gate"]["decision"] == "approve"


def test_trading_risk_global_kill_blocks_then_resume_allows(client):
    client.post("/api/trading/eas", json=_ea_payload())

    killed = client.post("/api/trading/risk/kill", json={"scope": "global", "reason": "manual"})
    assert killed.status_code == 200
    blocked = client.post("/api/trading/risk/evaluate", json=_risk_request()).get_json()
    assert blocked["risk_gate"]["approved"] is False
    assert "global_kill" in blocked["risk_gate"]["reasons"]

    resumed = client.post("/api/trading/risk/resume", json={"scope": "global"})
    assert resumed.status_code == 200
    allowed = client.post("/api/trading/risk/evaluate", json=_risk_request()).get_json()
    assert allowed["risk_gate"]["approved"] is True


def test_trading_risk_per_ea_kill_blocks_only_target(client):
    client.post("/api/trading/eas", json=_ea_payload())
    client.post("/api/trading/eas", json=_ea_payload(ea_id="EA_BREAKOUT_02", magic_number=26060802))

    client.post("/api/trading/risk/kill", json={"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01"})

    blocked = client.post("/api/trading/risk/evaluate", json=_risk_request()).get_json()
    other = client.post(
        "/api/trading/risk/evaluate",
        json=_risk_request(ea_id="EA_BREAKOUT_02"),
    ).get_json()
    state = client.get("/api/trading/risk/state").get_json()

    assert blocked["risk_gate"]["approved"] is False
    assert "ea_kill" in blocked["risk_gate"]["reasons"]
    assert other["risk_gate"]["approved"] is True
    assert "EA_GOLD_SCALPER_01" in state["risk_gate"]["ea_kills"]


def test_trading_risk_rejects_unknown_ea(client):
    resp = client.post("/api/trading/risk/evaluate", json=_risk_request())

    assert resp.status_code == 400
    assert "Unknown ea_id" in resp.get_json()["error"]


# ---------------------------------------------------------------------------
# Command State API
# ---------------------------------------------------------------------------


def test_trading_commands_state_starts_idle(client):
    resp = client.get("/api/trading/commands/state")

    assert resp.status_code == 200
    data = resp.get_json()
    assert data["command_state"]["global"]["mode"] == "stopped"
    assert data["command_state"]["global"]["kill"] is False
    assert data["command_state"]["commands"] == []


def test_trading_commands_dispatches_per_ea_start(client):
    client.post("/api/trading/eas", json=_ea_payload())

    resp = client.post(
        "/api/trading/commands",
        json={"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01", "command": "start"},
    )

    assert resp.status_code == 201
    data = resp.get_json()
    assert data["command"]["accepted"] is True
    assert data["command"]["execution"] == "state_only"
    state = client.get("/api/trading/commands/state").get_json()["command_state"]
    assert state["eas"]["EA_GOLD_SCALPER_01"]["mode"] == "running"


def test_trading_commands_rejects_unknown_ea(client):
    resp = client.post(
        "/api/trading/commands",
        json={"scope": "ea", "ea_id": "UNKNOWN_EA", "command": "start"},
    )

    assert resp.status_code == 400
    assert "Unknown ea_id" in resp.get_json()["error"]


def test_trading_commands_kill_blocks_decision_gate(client):
    client.post("/api/trading/eas", json=_ea_payload())
    client.post("/api/trading/commands", json={"scope": "global", "command": "kill", "reason": "manual"})

    blocked = client.post(
        "/api/trading/commands/evaluate",
        json={"ea_id": "EA_GOLD_SCALPER_01"},
    ).get_json()
    client.post("/api/trading/commands", json={"scope": "global", "command": "resume"})
    allowed = client.post(
        "/api/trading/commands/evaluate",
        json={"ea_id": "EA_GOLD_SCALPER_01"},
    ).get_json()

    assert blocked["command_state"]["allowed"] is False
    assert "global_kill" in blocked["command_state"]["reasons"]
    assert allowed["command_state"]["allowed"] is True


# ---------------------------------------------------------------------------
# BLADE Dry-Run Executor API
# ---------------------------------------------------------------------------


def _blade_payload(**overrides):
    payload = {
        "ea_id": "EA_GOLD_SCALPER_01",
        "decision_id": "DJ-test",
        "action": "buy",
        "lot": 0.01,
        "symbol": "XAUUSD",
        "timeframe": "M15",
        "sl": 2310.5,
        "tp": 2324.0,
        "risk_gate": {"approved": True, "decision": "approve"},
    }
    payload.update(overrides)
    return payload


def test_trading_blade_dry_run_writes_intent_without_order_send(client):
    client.post("/api/trading/eas", json=_ea_payload())
    client.post("/api/trading/eas", json=_ea_payload(ea_id="EA_BREAKOUT_02", magic_number=26060802))
    client.post("/api/trading/commands", json={"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01", "command": "start"})
    client.post("/api/trading/commands", json={"scope": "ea", "ea_id": "EA_BREAKOUT_02", "command": "start"})

    resp = client.post("/api/trading/blade/dry-run", json=_blade_payload())
    client.post(
        "/api/trading/blade/dry-run",
        json=_blade_payload(ea_id="EA_BREAKOUT_02", decision_id="DJ-other", action="sell"),
    )

    assert resp.status_code == 201
    intent = resp.get_json()["intent"]
    assert intent["mode"] == "dry_run"
    assert intent["order_send"] is False
    assert intent["status"] == "intent_logged"
    listed = client.get("/api/trading/blade/intents?ea_id=EA_GOLD_SCALPER_01").get_json()
    assert listed["total"] == 1
    assert listed["items"][0]["intent_id"] == intent["intent_id"]
    assert listed["items"][0]["ea_id"] == "EA_GOLD_SCALPER_01"


def test_trading_blade_dry_run_rejects_unapproved_risk_gate(client):
    client.post("/api/trading/eas", json=_ea_payload())
    client.post("/api/trading/commands", json={"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01", "command": "start"})

    resp = client.post(
        "/api/trading/blade/dry-run",
        json=_blade_payload(risk_gate={"approved": False, "decision": "reject"}),
    )

    assert resp.status_code == 400
    assert "Risk Gate" in resp.get_json()["error"]
    listed = client.get("/api/trading/blade/intents?ea_id=EA_GOLD_SCALPER_01").get_json()
    assert listed["total"] == 1
    assert listed["items"][0]["status"] == "rejected"
    assert listed["items"][0]["rejection_reason"] == "risk_gate_not_approved"


def test_trading_blade_dry_run_rejects_command_state_kill(client):
    client.post("/api/trading/eas", json=_ea_payload())
    client.post("/api/trading/commands", json={"scope": "global", "command": "kill"})

    resp = client.post("/api/trading/blade/dry-run", json=_blade_payload())

    assert resp.status_code == 400
    assert "Command State blocked" in resp.get_json()["error"]
    listed = client.get("/api/trading/blade/intents?ea_id=EA_GOLD_SCALPER_01").get_json()
    assert listed["total"] == 1
    assert listed["items"][0]["status"] == "blocked"
    assert "global_kill" in listed["items"][0]["command_state"]["reasons"]


# ---------------------------------------------------------------------------
# GET /api/learning/status
# ---------------------------------------------------------------------------


def test_get_status_returns_200(client):
    resp = client.get("/api/learning/status")
    assert resp.status_code == 200


def test_get_status_returns_required_keys(client):
    data = client.get("/api/learning/status").get_json()
    assert "channels" in data
    assert "videos" in data
    assert "concepts" in data
    assert "conflicts" in data
    assert "concepts_written" in data


def test_get_status_videos_counts_from_manifest(client):
    data = client.get("/api/learning/status").get_json()
    vids = data["videos"]
    assert vids["discovered"] >= 0
    assert vids["learned"] >= 0
    assert "needs_check" in vids


def test_get_status_counts_structured_extracted_as_learned(client):
    data = client.get("/api/learning/status").get_json()

    assert data["videos"]["learned"] == 2


def test_get_status_concepts_count_from_index(client):
    data = client.get("/api/learning/status").get_json()
    assert data["concepts"]["total"] == 1


def test_get_status_conflicts_count_from_queue(client):
    data = client.get("/api/learning/status").get_json()
    assert data["conflicts"]["total"] == 3
    assert data["conflicts"]["pending"] == 2


def test_get_status_has_cors_header(client):
    resp = client.get("/api/learning/status")
    assert "Access-Control-Allow-Origin" in resp.headers


def test_download_status_accepts_utf8_bom(tmp_path):
    status_path = tmp_path / "download_status.json"
    status_path.write_bytes(b"\xef\xbb\xbf" + json.dumps({
        "running": True,
        "status": "Transcribing",
        "percent": 12,
    }).encode("utf-8"))
    app = create_app({
        "TESTING": True,
        "DOWNLOAD_STATUS_PATH": str(status_path),
    })

    data = app.test_client().get("/api/learning/download-status").get_json()

    assert data["running"] is True
    assert data["status"] == "Transcribing"
    assert data["percent"] == 12


def test_parallel_agent_status_reads_status_and_reports(tmp_path):
    status_path = tmp_path / "parallel_agent_supervisor_status.json"
    reports_dir = tmp_path / "agent_reports"
    reports_dir.mkdir()
    status_path.write_text(json.dumps({
        "running": True,
        "updated_at": "2026-06-04T11:14:18+07:00",
        "action": "agent_reports",
        "total": 2,
    }), encoding="utf-8")
    (reports_dir / "nova_source_audit.json").write_text(json.dumps({
        "job": "nova_source_audit",
        "agent": "Nova",
        "status": "ok",
        "summary": "Found 1178 MQL/source candidates.",
        "recommendation": "Queue a controlled source-first MQL batch when idle.",
        "updated_at": "2026-06-04T11:14:22+07:00",
        "data": {"candidate_count": 1178, "preview": ["a.mq5"]},
    }), encoding="utf-8")
    (reports_dir / "diag_runtime_health.json").write_text(json.dumps({
        "job": "diag_runtime_health",
        "agent": "Diag",
        "status": "ok",
        "summary": "download_running=True",
        "recommendation": "Pause write-heavy jobs.",
        "updated_at": "2026-06-04T11:14:18+07:00",
        "data": {"pipeline": {"running": False}, "download": {"running": True}},
    }), encoding="utf-8")
    app = create_app({
        "TESTING": True,
        "PARALLEL_SUPERVISOR_STATUS_PATH": str(status_path),
        "PARALLEL_AGENT_REPORTS_DIR": str(reports_dir),
        "DOWNLOAD_STATUS_PATH": str(tmp_path / "missing_download_status.json"),
    })

    resp = app.test_client().get("/api/learning/parallel-agent-status")

    assert resp.status_code == 200
    data = resp.get_json()
    assert data["running"] is True
    assert data["total"] == 2
    assert data["safe_to_execute"] is False
    assert data["blocking_reason"] == "download_running"
    assert [report["job"] for report in data["reports"]] == ["diag_runtime_health", "nova_source_audit"]
    assert data["reports"][1]["data"]["candidate_count"] == 1178


def test_parallel_agent_status_missing_files_is_safe(tmp_path):
    app = create_app({
        "TESTING": True,
        "PARALLEL_SUPERVISOR_STATUS_PATH": str(tmp_path / "missing_status.json"),
        "PARALLEL_AGENT_REPORTS_DIR": str(tmp_path / "missing_reports"),
    })

    data = app.test_client().get("/api/learning/parallel-agent-status").get_json()

    assert data["running"] is False
    assert data["status"] == "not_started"
    assert data["reports"] == []
    assert data["safe_to_execute"] is False


def test_parallel_agent_status_marks_safe_when_diag_reports_idle(tmp_path):
    status_path = tmp_path / "status.json"
    reports_dir = tmp_path / "reports"
    reports_dir.mkdir()
    status_path.write_text(json.dumps({"running": True, "action": "agent_reports"}), encoding="utf-8")
    (reports_dir / "diag_runtime_health.json").write_text(json.dumps({
        "job": "diag_runtime_health",
        "agent": "Diag",
        "status": "ok",
        "data": {"pipeline": {"running": False}, "download": {"running": False}},
    }), encoding="utf-8")
    app = create_app({
        "TESTING": True,
        "PARALLEL_SUPERVISOR_STATUS_PATH": str(status_path),
        "PARALLEL_AGENT_REPORTS_DIR": str(reports_dir),
        "DOWNLOAD_STATUS_PATH": str(tmp_path / "missing_download_status.json"),
    })

    data = app.test_client().get("/api/learning/parallel-agent-status").get_json()

    assert data["safe_to_execute"] is True
    assert data["blocking_reason"] is None


def test_parallel_agent_status_uses_live_download_state_over_stale_diag(tmp_path, monkeypatch):
    status_path = tmp_path / "status.json"
    reports_dir = tmp_path / "reports"
    download_status_path = tmp_path / "download_status.json"
    reports_dir.mkdir()
    status_path.write_text(json.dumps({"running": True, "action": "agent_reports"}), encoding="utf-8")
    (reports_dir / "diag_runtime_health.json").write_text(json.dumps({
        "job": "diag_runtime_health",
        "agent": "Diag",
        "status": "ok",
        "data": {"pipeline": {"running": False}, "download": {"running": False}},
    }), encoding="utf-8")
    download_status_path.write_text(json.dumps({
        "running": True,
        "status": "Transcribing",
    }), encoding="utf-8")
    monkeypatch.setattr(server_module, "_task_state", {"running": False, "result": None, "error": None})
    app = create_app({
        "TESTING": True,
        "PARALLEL_SUPERVISOR_STATUS_PATH": str(status_path),
        "PARALLEL_AGENT_REPORTS_DIR": str(reports_dir),
        "DOWNLOAD_STATUS_PATH": str(download_status_path),
    })

    data = app.test_client().get("/api/learning/parallel-agent-status").get_json()

    assert data["safe_to_execute"] is False
    assert data["blocking_reason"] == "download_running"


def test_get_research_state_returns_stage_quality_and_action(client):
    data = client.get("/api/learning/research-state").get_json()

    assert data["stage"]["id"] == "conflict_review"
    assert data["quality_gate"]["status"] == "blocked"
    assert data["recommended_action"]["id"] == "review_conflicts"
    assert data["metrics"]["conflicts"]["pending"] == 2


# ---------------------------------------------------------------------------
# GET /api/learning/youtube-sources
# ---------------------------------------------------------------------------

@pytest.fixture
def youtube_sources_app(tmp_path):
    manifest = tmp_path / "channel_manifest.json"
    manifest.write_text(json.dumps({
        "version": 1,
        "channels": {
            "chan-a": {
                "channel_id": "chan-a",
                "channel_name": "Ninja Trading",
                "channel_url": "https://www.youtube.com/@ninja",
            },
            "chan-b": {
                "channel_id": "chan-b",
                "channel_name": "ICT Hub",
                "channel_url": "https://www.youtube.com/@ict",
            },
        },
        "videos": {
            "a1": {
                "video_id": "a1",
                "channel_id": "chan-a",
                "channel_name": "Ninja Trading",
                "title": "Pattern W",
                "url": "https://youtu.be/a1",
                "status": "raw_evidence_written",
            },
            "a2": {
                "video_id": "a2",
                "channel_id": "chan-a",
                "channel_name": "Ninja Trading",
                "title": "FVG Setup",
                "url": "https://youtu.be/a2",
                "status": "needs_transcript_check",
                "failure_reason": "rate_limited",
            },
            "a3": {
                "video_id": "a3",
                "channel_id": "chan-a",
                "channel_name": "Ninja Trading",
                "title": "OB Setup",
                "url": "https://youtu.be/a3",
                "status": "failed",
                "failure_reason": "cookie_invalid",
            },
            "b1": {
                "video_id": "b1",
                "channel_id": "chan-b",
                "channel_name": "ICT Hub",
                "title": "BOS Basics",
                "url": "https://youtu.be/b1",
                "status": "needs_transcript_check",
            },
        },
    }), encoding="utf-8")

    structured = tmp_path / "structured_extractions.json"
    structured.write_text(json.dumps({
        "version": 1,
        "items": {"a1": {"video_id": "a1"}, "b1": {"video_id": "b1"}},
    }), encoding="utf-8")

    index = tmp_path / "knowledge_index.json"
    index.write_text(json.dumps({
        "version": 1,
        "concepts": {"FVG": {"confidence": 80}, "BOS": {"confidence": 70}},
    }), encoding="utf-8")

    concepts_dir = tmp_path / "concepts"
    concepts_dir.mkdir()
    (concepts_dir / "FVG.md").write_text("# FVG\n", encoding="utf-8")

    components = tmp_path / "ea_components.json"
    components.write_text(json.dumps({
        "version": 1,
        "summary": {"total_rules": 5},
    }), encoding="utf-8")

    blueprint = tmp_path / "ea_blueprint.json"
    blueprint.write_text(json.dumps({"mql5_code": "// scaffold"}), encoding="utf-8")

    return create_app({
        "TESTING": True,
        "MANIFEST_PATH": str(manifest),
        "STRUCTURED_PATH": str(structured),
        "INDEX_PATH": str(index),
        "CONFLICT_QUEUE_PATH": str(tmp_path / "missing_queue.json"),
        "CONCEPTS_DIR": str(concepts_dir),
        "COMPONENTS_PATH": str(components),
        "BLUEPRINT_PATH": str(blueprint),
        "COOKIES_PATH": str(tmp_path / "youtube_cookies.txt"),
    })


@pytest.fixture
def youtube_sources_client(youtube_sources_app):
    return youtube_sources_app.test_client()


def test_get_youtube_sources_returns_summary(youtube_sources_client):
    resp = youtube_sources_client.get("/api/learning/youtube-sources")

    assert resp.status_code == 200
    data = resp.get_json()
    assert data["summary"]["channels_tracked"] == 2
    assert data["summary"]["videos_total"] == 4
    assert data["summary"]["learned"] == 1
    assert data["summary"]["remaining"] == 3
    assert data["summary"]["needs_check"] == 2
    assert data["summary"]["failed"] == 1


def test_get_youtube_sources_progress_zero_when_no_learned(tmp_path):
    manifest = tmp_path / "channel_manifest.json"
    manifest.write_text(json.dumps({
        "version": 1,
        "channels": {"chan-a": {"channel_name": "A"}},
        "videos": {
            "a1": {"video_id": "a1", "channel_id": "chan-a", "status": "needs_transcript_check"},
            "a2": {"video_id": "a2", "channel_id": "chan-a", "status": "discovered"},
        },
    }), encoding="utf-8")
    app = create_app({"TESTING": True, "MANIFEST_PATH": str(manifest)})

    data = app.test_client().get("/api/learning/youtube-sources").get_json()

    assert data["summary"]["learning_progress_pct"] == 0
    assert data["channels"][0]["learning_progress_pct"] == 0


def test_get_youtube_sources_progress_rounded(youtube_sources_client):
    data = youtube_sources_client.get("/api/learning/youtube-sources").get_json()

    assert data["summary"]["learning_progress_pct"] == 25
    ninja = next(ch for ch in data["channels"] if ch["channel_id"] == "chan-a")
    assert ninja["learning_progress_pct"] == 33


def test_get_youtube_sources_groups_by_channel(youtube_sources_client):
    data = youtube_sources_client.get("/api/learning/youtube-sources").get_json()

    channels = {ch["channel_id"]: ch for ch in data["channels"]}
    assert channels["chan-a"]["channel_name"] == "Ninja Trading"
    assert channels["chan-a"]["videos_total"] == 3
    assert channels["chan-b"]["videos_total"] == 1


def test_get_youtube_sources_counts_failure_reasons(youtube_sources_client):
    data = youtube_sources_client.get("/api/learning/youtube-sources").get_json()

    ninja = next(ch for ch in data["channels"] if ch["channel_id"] == "chan-a")
    assert ninja["failure_reasons"] == {
        "cookie_invalid": 1,
        "rate_limited": 1,
    }


def test_get_youtube_sources_returns_next_retry_video(youtube_sources_client):
    data = youtube_sources_client.get("/api/learning/youtube-sources").get_json()

    ninja = next(ch for ch in data["channels"] if ch["channel_id"] == "chan-a")
    assert ninja["next_retry_video"] == {
        "video_id": "a2",
        "title": "FVG Setup",
        "url": "https://youtu.be/a2",
    }


def test_get_youtube_sources_pipeline_progress(youtube_sources_client):
    data = youtube_sources_client.get("/api/learning/youtube-sources").get_json()

    assert data["pipeline"] == {
        "discovered": 4,
        "transcript_done": 1,
        "raw_evidence": 1,
        "structured_extractions": 2,
        "concepts": 2,
        "notes_written": 1,
        "ea_rules": 5,
        "blueprint_ready": True,
    }
    assert data["summary"]["pipeline_progress_pct"] == 100


def test_get_youtube_sources_current_bottleneck_transcript(youtube_sources_client):
    data = youtube_sources_client.get("/api/learning/youtube-sources").get_json()

    assert data["summary"]["current_bottleneck"] == "transcript_intake"


def test_get_youtube_sources_empty_manifest_safe(tmp_path):
    app = create_app({
        "TESTING": True,
        "MANIFEST_PATH": str(tmp_path / "missing_manifest.json"),
        "STRUCTURED_PATH": str(tmp_path / "missing_structured.json"),
        "INDEX_PATH": str(tmp_path / "missing_index.json"),
        "CONCEPTS_DIR": str(tmp_path / "missing_concepts"),
        "COMPONENTS_PATH": str(tmp_path / "missing_components.json"),
        "BLUEPRINT_PATH": str(tmp_path / "missing_blueprint.json"),
    })

    resp = app.test_client().get("/api/learning/youtube-sources")

    assert resp.status_code == 200
    data = resp.get_json()
    assert data["summary"]["videos_total"] == 0
    assert data["summary"]["learning_progress_pct"] == 0
    assert data["summary"]["pipeline_progress_pct"] == 0
    assert data["channels"] == []


# ---------------------------------------------------------------------------
# POST /api/learning/scan-channel
# ---------------------------------------------------------------------------


def test_scan_channel_missing_url_returns_400(client):
    resp = client.post("/api/learning/scan-channel", json={})
    assert resp.status_code == 400


def test_scan_channel_placeholder_url_returns_400(client):
    resp = client.post(
        "/api/learning/scan-channel",
        json={"channel_url": "https://www.youtube.com/@channel"},
    )
    assert resp.status_code == 400
    data = resp.get_json()
    assert "error" in data


def test_scan_channel_calls_scan_function(client):
    with patch("server.scan_channel") as mock_scan:
        mock_scan.return_value = {"new": 5, "duplicates": 0, "scanned": 5}
        resp = client.post(
            "/api/learning/scan-channel",
            json={"channel_url": "https://www.youtube.com/@RealChannel"},
        )
    assert resp.status_code == 200
    assert mock_scan.called


def test_scan_channel_passes_limit_to_function(client):
    with patch("server.scan_channel") as mock_scan:
        mock_scan.return_value = {"new": 2, "scanned": 2}
        client.post(
            "/api/learning/scan-channel",
            json={"channel_url": "https://www.youtube.com/@RealChannel", "limit": 10},
        )
    assert mock_scan.called


def test_scan_channel_returns_result_json(client):
    with patch("server.scan_channel") as mock_scan:
        mock_scan.return_value = {"new": 3, "scanned": 3}
        resp = client.post(
            "/api/learning/scan-channel",
            json={"channel_url": "https://www.youtube.com/@RealChannel"},
        )
    data = resp.get_json()
    assert "new" in data or "result" in data


# ---------------------------------------------------------------------------
# POST /api/learning/learn-new
# ---------------------------------------------------------------------------


def test_learn_new_accepts_empty_body(client):
    with patch("server.learn_new_videos") as mock_learn:
        mock_learn.return_value = {"processed": 0, "written": 0, "failed": 0}
        resp = client.post("/api/learning/learn-new", json={})
    assert resp.status_code == 200


def test_learn_new_accepts_limit_param(client):
    with patch("server.learn_new_videos") as mock_learn:
        mock_learn.return_value = {"processed": 2, "written": 2, "failed": 0}
        resp = client.post("/api/learning/learn-new", json={"limit": 2, "auto_pipeline": False})
    assert resp.status_code == 200
    call_kwargs = mock_learn.call_args[1]
    assert call_kwargs.get("limit") == 2


def test_learn_new_accepts_retry_flag(client):
    with patch("server.learn_new_videos") as mock_learn:
        mock_learn.return_value = {"processed": 1, "written": 1, "failed": 0}
        resp = client.post("/api/learning/learn-new", json={"retry_needs_check": True, "auto_pipeline": False})
    call_kwargs = mock_learn.call_args[1]
    assert call_kwargs.get("retry_needs_check") is True


# ---------------------------------------------------------------------------
# POST /api/learning/import-local
# ---------------------------------------------------------------------------


def test_universal_upload_imports_multiple_files_and_starts_pipeline(client):
    uploaded = [
        (io.BytesIO(b"entry rule text"), "rules.txt"),
        (io.BytesIO(b"fake image bytes"), "chart.png"),
    ]
    import_results = [
        {
            "status": "raw_evidence_written",
            "source_type": "local_text",
            "note_path": "raw/local/rules.md",
            "text_captured": True,
            "local_evidence_id": "rules123",
        },
        {
            "status": "raw_evidence_written",
            "source_type": "local_image",
            "note_path": "raw/local/chart.md",
            "text_captured": True,
            "local_evidence_id": "chart123",
        },
    ]

    class ImmediateThread:
        def __init__(self, target, args=(), daemon=None):
            self.target = target
            self.args = args

        def start(self):
            self.target(*self.args)

    with patch("server.import_local_evidence", side_effect=import_results) as mock_import, \
            patch("server._run_full_pipeline", return_value={"done": True}), \
            patch("server.threading.Thread", ImmediateThread):
        resp = client.post(
            "/api/learning/universal-upload",
            data={"auto_pipeline": "true", "files": uploaded},
            content_type="multipart/form-data",
        )

    assert resp.status_code == 200
    data = resp.get_json()
    assert data["status"] == "completed"
    assert data["imported"] == 2
    assert data["failed"] == 0
    assert data["pipeline"] == "started"
    assert [item["filename"] for item in data["files"]] == ["rules.txt", "chart.png"]
    assert mock_import.call_count == 2


def test_universal_upload_routes_csv_diagnosis_into_local_evidence(client):
    diagnosis = {
        "summary": "CSV shows scalping edge.",
        "rules": ["Use mandatory stop loss", "Trade only active sessions"],
    }
    import_result = {
        "status": "raw_evidence_written",
        "source_type": "local_text",
        "note_path": "raw/local/diagnosis.md",
        "text_captured": True,
        "local_evidence_id": "diag123",
    }

    with patch("server.generate_csv_diagnosis", return_value=diagnosis) as mock_diag, \
            patch("server.import_local_evidence", return_value=import_result) as mock_import:
        resp = client.post(
            "/api/learning/universal-upload",
            data={
                "auto_pipeline": "false",
                "files": [(io.BytesIO(b"time,pnl\n2026-05-31,10\n"), "trades.csv")],
            },
            content_type="multipart/form-data",
        )

    assert resp.status_code == 200
    data = resp.get_json()
    assert data["imported"] == 1
    assert data["pipeline"] is None
    assert data["files"][0]["filename"] == "trades.csv"
    assert data["files"][0]["route"] == "csv_diagnosis"
    assert mock_diag.call_count == 1
    assert mock_import.call_count == 1
    assert "text" in mock_import.call_args.kwargs
    assert "CSV Diagnosis Report" in mock_import.call_args.kwargs["text"]


def test_universal_upload_real_text_import_returns_json(app, client):
    resp = client.post(
        "/api/learning/universal-upload",
        data={
            "auto_pipeline": "false",
            "files": [(io.BytesIO(b"Enter on CHoCH confirmation."), "upload_note.txt")],
        },
        content_type="multipart/form-data",
    )

    assert resp.status_code == 200
    data = resp.get_json()
    assert data["imported"] == 1
    assert data["files"][0]["filename"] == "upload_note.txt"
    assert isinstance(data["files"][0]["note_path"], str)
    assert str(app.config["LOCAL_RAW_DIR"]) in data["files"][0]["note_path"]


def test_import_local_missing_path_returns_400(client):
    resp = client.post("/api/learning/import-local", json={})
    assert resp.status_code == 400


def test_import_local_text_file_returns_note_path(app, client, tmp_path):
    source = tmp_path / "manual_trade_note.txt"
    source.write_text("Enter after CHoCH and FVG retest.", encoding="utf-8")

    resp = client.post("/api/learning/import-local", json={"source_path": str(source)})

    data = resp.get_json()
    assert resp.status_code == 200
    assert data["status"] == "raw_evidence_written"
    assert data["source_type"] == "local_text"
    assert Path(data["note_path"]).exists()
    assert str(app.config["LOCAL_RAW_DIR"]) in data["note_path"]


def test_import_local_video_auto_transcribes_through_api(app, client, tmp_path):
    source = tmp_path / "SMC.mp4"
    source.write_bytes(b"fake video bytes")

    with patch(
        "local_evidence_intake.transcribe_video_audio",
        return_value="Auto API transcript with CHoCH and FVG retest.",
    ):
        resp = client.post("/api/learning/import-local", json={"source_path": str(source)})

    data = resp.get_json()
    note_path = Path(data["note_path"])
    content = note_path.read_text(encoding="utf-8")
    assert resp.status_code == 200
    assert data["status"] == "raw_evidence_written"
    assert data["source_type"] == "local_video"
    assert data["text_source"] == "auto_transcription"
    assert data["text_captured"] is True
    assert str(app.config["LOCAL_RAW_DIR"]) in data["note_path"]
    assert "Auto API transcript" in content


def test_import_local_video_auto_pipeline_starts_after_transcription(app, client, tmp_path):
    import threading

    source = tmp_path / "SMC.mp4"
    source.write_bytes(b"fake video bytes")
    started = threading.Event()

    def fake_pipeline(app):
        started.set()
        return {"extract": {"written": 1}}

    with patch(
        "local_evidence_intake.transcribe_video_audio",
        return_value="Auto transcript ready for existing pipeline.",
    ), patch("server._run_full_pipeline", side_effect=fake_pipeline):
        resp = client.post(
            "/api/learning/import-local",
            json={"source_path": str(source), "auto_pipeline": True},
        )

    data = resp.get_json()
    assert resp.status_code == 200
    assert data["status"] == "raw_evidence_written"
    assert data["source_type"] == "local_video"
    assert data["text_source"] == "auto_transcription"
    assert data["pipeline"] == "started"
    assert started.wait(timeout=2)


def test_import_local_image_auto_extracts_text_through_api(app, client, tmp_path):
    source = tmp_path / "chart.png"
    source.write_bytes(b"fake image bytes")

    with patch(
        "local_evidence_intake.extract_image_text",
        return_value="API image OCR with liquidity sweep and order block.",
    ):
        resp = client.post("/api/learning/import-local", json={"source_path": str(source)})

    data = resp.get_json()
    note_path = Path(data["note_path"])
    content = note_path.read_text(encoding="utf-8")
    assert resp.status_code == 200
    assert data["status"] == "raw_evidence_written"
    assert data["source_type"] == "local_image"
    assert data["text_source"] == "auto_image_text"
    assert data["text_captured"] is True
    assert str(app.config["LOCAL_RAW_DIR"]) in data["note_path"]
    assert "API image OCR" in content


# ---------------------------------------------------------------------------
# GET/POST /api/learning/remote-inbox
# ---------------------------------------------------------------------------


def test_remote_inbox_status_empty_state_is_safe(app, client):
    data = client.get("/api/learning/remote-inbox/status").get_json()

    assert data["root"] == str(app.config["REMOTE_INBOX_ROOT"])
    assert data["raw_dir"] == str(app.config["LOCAL_RAW_DIR"])
    assert data["exists"] is True
    assert data["pending"]["total"] == 0
    assert data["pending"]["text"] == 0
    assert data["pending"]["images"] == 0
    assert data["pending"]["videos"] == 0
    assert data["pending"]["urls"] == 0
    assert Path(data["folders"]["text"]).exists()


def test_remote_inbox_status_counts_pending_files(app, client):
    inbox_root = Path(app.config["REMOTE_INBOX_ROOT"])
    (inbox_root / "inbox" / "text").mkdir(parents=True)
    (inbox_root / "inbox" / "images").mkdir(parents=True)
    (inbox_root / "inbox" / "text" / "note.txt").write_text("FVG retest note", encoding="utf-8")
    (inbox_root / "inbox" / "images" / "chart.png").write_bytes(b"fake chart")

    data = client.get("/api/learning/remote-inbox/status").get_json()

    assert data["pending"]["total"] == 2
    assert data["pending"]["text"] == 1
    assert data["pending"]["images"] == 1
    assert data["pending"]["videos"] == 0
    assert data["pending"]["urls"] == 0


def test_remote_inbox_process_imports_text_into_local_raw(app, client):
    inbox_root = Path(app.config["REMOTE_INBOX_ROOT"])
    source = inbox_root / "inbox" / "text" / "market_note.txt"
    source.parent.mkdir(parents=True)
    source.write_text("Remote note: liquidity sweep then CHoCH.", encoding="utf-8")

    resp = client.post("/api/learning/remote-inbox/process", json={})
    data = resp.get_json()

    assert resp.status_code == 200
    assert data["processed"] == 1
    assert data["imported"] == 1
    assert data["failed"] == 0
    assert data["skipped"] == 0
    assert str(app.config["LOCAL_RAW_DIR"]) in data["items"][0]["note_path"]
    assert Path(data["items"][0]["note_path"]).exists()
    assert not source.exists()
    assert (inbox_root / "processed" / "text" / "market_note.txt").exists()


def test_remote_inbox_process_uses_configured_paths(app, client):
    inbox_root = Path(app.config["REMOTE_INBOX_ROOT"])
    raw_dir = Path(app.config["LOCAL_RAW_DIR"])
    inbox_root.mkdir(parents=True)

    with patch("server.process_remote_inbox", return_value={
        "processed": 0,
        "imported": 0,
        "failed": 0,
        "skipped": 0,
        "manifest_path": str(inbox_root / "remote_inbox_manifest.json"),
        "raw_dir": str(raw_dir),
        "items": [],
    }) as mock_process:
        resp = client.post("/api/learning/remote-inbox/process", json={})

    assert resp.status_code == 200
    assert mock_process.call_args.kwargs["raw_dir"] == raw_dir
    assert mock_process.call_args.args[0] == inbox_root


def test_remote_inbox_process_without_auto_pipeline_only_imports(client):
    with patch("server.process_remote_inbox", return_value={
        "processed": 1,
        "imported": 1,
        "failed": 0,
        "skipped": 0,
        "manifest_path": "manifest.json",
        "raw_dir": "raw/local",
        "items": [],
    }), patch("server._run_full_pipeline") as mock_pipeline:
        data = client.post("/api/learning/remote-inbox/process", json={}).get_json()

    assert data["imported"] == 1
    assert data["pipeline"] is None
    mock_pipeline.assert_not_called()


def test_remote_inbox_process_auto_pipeline_starts_when_imported(client):
    import threading

    started = threading.Event()

    def fake_pipeline(app):
        started.set()
        return {"done": True}

    with patch("server.process_remote_inbox", return_value={
        "processed": 1,
        "imported": 1,
        "failed": 0,
        "skipped": 0,
        "manifest_path": "manifest.json",
        "raw_dir": "raw/local",
        "items": [],
    }), patch("server._run_full_pipeline", side_effect=fake_pipeline):
        data = client.post(
            "/api/learning/remote-inbox/process",
            json={"auto_pipeline": True},
        ).get_json()

    assert data["pipeline"] == "started"
    assert started.wait(timeout=2)


def test_remote_inbox_process_auto_pipeline_skips_when_nothing_imported(client):
    with patch("server.process_remote_inbox", return_value={
        "processed": 0,
        "imported": 0,
        "failed": 0,
        "skipped": 0,
        "manifest_path": "manifest.json",
        "raw_dir": "raw/local",
        "items": [],
    }), patch("server._run_full_pipeline") as mock_pipeline:
        data = client.post(
            "/api/learning/remote-inbox/process",
            json={"auto_pipeline": True},
        ).get_json()

    assert data["pipeline"] is None
    mock_pipeline.assert_not_called()


# ---------------------------------------------------------------------------
# POST /api/learning/extract-raw
# ---------------------------------------------------------------------------


def test_extract_raw_returns_200(client):
    with patch("server.extract_raw_notes") as mock_ex:
        mock_ex.return_value = {"processed": 0, "written": 0}
        resp = client.post("/api/learning/extract-raw", json={})
    assert resp.status_code == 200


def test_extract_raw_calls_extract_function(client):
    with patch("server.extract_raw_notes") as mock_ex:
        mock_ex.return_value = {"processed": 1, "written": 1}
        client.post("/api/learning/extract-raw", json={})
    assert mock_ex.called


def test_extract_raw_includes_local_raw_dir(app, client):
    local_raw = Path(app.config["LOCAL_RAW_DIR"])
    local_raw.mkdir(parents=True)
    note = local_raw / "2026-05-25_local.md"
    note.write_text(
        "\n".join([
            "---",
            "video_id: local123",
            "source: C:/local/video.mp4",
            "source_type: local_video",
            "---",
            "",
            "# Local SMC Note",
            "",
            "## Fact / Transcript Evidence",
            "",
            "Enter after FVG retest and CHoCH confirmation.",
        ]),
        encoding="utf-8",
    )

    data = client.post("/api/learning/extract-raw", json={}).get_json()
    structured = json.loads(Path(app.config["STRUCTURED_PATH"]).read_text(encoding="utf-8"))

    assert data["processed"] == 1
    assert data["written"] == 1
    assert "local123" in structured["items"]


# ---------------------------------------------------------------------------
# POST /api/learning/merge-knowledge
# ---------------------------------------------------------------------------


def test_merge_knowledge_returns_200(client):
    with patch("server.merge_structured_extractions") as mock_merge:
        mock_merge.return_value = {"new": 0, "reinforce": 0}
        resp = client.post("/api/learning/merge-knowledge", json={})
    assert resp.status_code == 200


# ---------------------------------------------------------------------------
# POST /api/learning/write-concepts
# ---------------------------------------------------------------------------


def test_write_concepts_returns_200(client):
    with patch("server.write_concept_notes") as mock_write:
        mock_write.return_value = {"total": 1, "created": 1, "updated": 0}
        resp = client.post("/api/learning/write-concepts", json={})
    assert resp.status_code == 200


# ---------------------------------------------------------------------------
# POST /api/learning/detect-conflicts
# ---------------------------------------------------------------------------


def test_detect_conflicts_returns_200(client):
    with patch("server.detect_conflicts") as mock_det:
        mock_det.return_value = {"total": 0, "new": 0, "existing": 0}
        resp = client.post("/api/learning/detect-conflicts", json={})
    assert resp.status_code == 200


# ---------------------------------------------------------------------------
# GET /api/learning/conflicts
# ---------------------------------------------------------------------------


def test_get_conflicts_returns_200(client):
    resp = client.get("/api/learning/conflicts")
    assert resp.status_code == 200


def test_get_conflicts_returns_items_list(client):
    data = client.get("/api/learning/conflicts").get_json()
    assert "items" in data
    assert isinstance(data["items"], list)


def test_get_conflicts_items_have_required_fields(client):
    data = client.get("/api/learning/conflicts").get_json()
    assert len(data["items"]) == 3
    item = data["items"][0]
    assert "conflict_id" in item
    assert "concept" in item
    assert "severity" in item
    assert "type" in item
    assert "status" in item
    assert "summary" in item


def test_get_conflicts_supports_status_filter(client):
    resp = client.get("/api/learning/conflicts?status=pending")
    assert resp.status_code == 200
    data = resp.get_json()
    assert all(i["status"] == "pending" for i in data["items"])


def test_get_conflicts_empty_when_resolved_filter(client):
    resp = client.get("/api/learning/conflicts?status=resolved")
    data = resp.get_json()
    assert len(data["items"]) == 1
    assert data["items"][0]["status"] == "resolved"


# ---------------------------------------------------------------------------
# PATCH /api/learning/conflicts/{conflict_id}
# ---------------------------------------------------------------------------


def test_patch_conflict_updates_status(client):
    resp = client.patch(
        "/api/learning/conflicts/abc123def456",
        json={"status": "resolved"},
    )
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["status"] == "resolved"


def test_patch_conflict_returns_updated_item(client):
    resp = client.patch(
        "/api/learning/conflicts/abc123def456",
        json={"status": "accepted"},
    )
    data = resp.get_json()
    assert data["conflict_id"] == "abc123def456"
    assert data["status"] == "accepted"


def test_patch_conflict_not_found_returns_404(client):
    resp = client.patch(
        "/api/learning/conflicts/nonexistent000",
        json={"status": "resolved"},
    )
    assert resp.status_code == 404


def test_patch_conflict_invalid_status_returns_400(client):
    resp = client.patch(
        "/api/learning/conflicts/abc123def456",
        json={"status": "invalid_status"},
    )
    assert resp.status_code == 400


def test_patch_conflict_missing_status_returns_400(client):
    resp = client.patch(
        "/api/learning/conflicts/abc123def456",
        json={},
    )
    assert resp.status_code == 400


def test_patch_conflict_persists_to_file(client, tmp_queue):
    client.patch(
        "/api/learning/conflicts/abc123def456",
        json={"status": "resolved"},
    )
    data = json.loads(tmp_queue.read_text(encoding="utf-8"))
    assert data["items"]["abc123def456"]["status"] == "resolved"


def test_patch_resolved_item_not_overwritten_by_detect(client, app):
    client.patch(
        "/api/learning/conflicts/abc123def456",
        json={"status": "resolved"},
    )
    with patch("server.detect_conflicts") as mock_det:
        mock_det.return_value = {"total": 0, "new": 0, "existing": 1}
        client.post("/api/learning/detect-conflicts", json={})
    resp = client.get("/api/learning/conflicts")
    items = resp.get_json()["items"]
    resolved = [i for i in items if i["conflict_id"] == "abc123def456"]
    if resolved:
        assert resolved[0]["status"] == "resolved"


# ---------------------------------------------------------------------------
# Pipeline endpoint — POST /api/learning/run-pipeline
# ---------------------------------------------------------------------------


def test_run_pipeline_calls_all_steps_in_order(client):
    """run-pipeline now returns {status: started} immediately; steps run in bg thread."""
    call_order = []
    import threading as _th
    done = _th.Event()

    def mock_extract(*a, **kw):    call_order.append("extract");    return {"processed": 0}
    def mock_merge(*a, **kw):      call_order.append("merge");      return {"new": 0}
    def mock_dedup(*a, **kw):      call_order.append("dedup");      return {"removed": 0}
    def mock_write(*a, **kw):      call_order.append("write");      return {"created": 0}
    def mock_detect(*a, **kw):     call_order.append("detect");     return {"total": 0}
    def mock_resolve(*a, **kw):    call_order.append("resolve");    return {"auto_resolved": 0}
    def mock_components(*a, **kw): call_order.append("components"); return {"total_rules": 0}
    def mock_blueprint(*a, **kw):  call_order.append("blueprint");  done.set(); return {"ea_readiness": "low"}

    with patch("server.extract_raw_notes", mock_extract), \
         patch("server.merge_structured_extractions", mock_merge), \
         patch("server._run_dedup", mock_dedup), \
         patch("server.write_concept_notes", mock_write), \
         patch("server.detect_conflicts", mock_detect), \
         patch("server._auto_resolve_conflicts", mock_resolve), \
         patch("server.extract_ea_components_from_files", mock_components), \
         patch("server.generate_blueprint_from_files", mock_blueprint):
        resp = client.post("/api/learning/run-pipeline", json={})
        assert resp.status_code == 200
        assert resp.get_json()["status"] == "started"
        done.wait(timeout=3)

    assert call_order == ["extract", "extract", "merge", "dedup", "write", "detect", "resolve", "components", "blueprint"]


def test_run_pipeline_returns_all_step_results(client):
    """Results available via /pipeline-status after background task completes."""
    import threading as _th
    done = _th.Event()

    def mock_bp(*a, **kw):
        done.set()
        return {"ea_readiness": "high"}

    with patch("server.extract_raw_notes", return_value={"processed": 1}), \
         patch("server.merge_structured_extractions", return_value={"new": 1}), \
         patch("server._run_dedup", return_value={"removed": 2, "merged": 2}), \
         patch("server.write_concept_notes", return_value={"created": 1}), \
         patch("server.detect_conflicts", return_value={"total": 0}), \
         patch("server._auto_resolve_conflicts", return_value={"auto_resolved": 0, "still_pending": 0}), \
         patch("server.extract_ea_components_from_files", return_value={"total_rules": 5}), \
         patch("server.generate_blueprint_from_files", mock_bp):
        client.post("/api/learning/run-pipeline", json={})
        done.wait(timeout=3)
        import time; time.sleep(0.05)

    data = client.get("/api/learning/pipeline-status").get_json()
    result = data.get("result", {})
    assert "extract" in result
    assert "merge" in result
    assert "dedup" in result
    assert "write_concepts" in result
    assert "conflicts" in result
    assert "auto_resolve" in result
    assert "ea_components" in result
    assert "blueprint" in result


def test_run_pipeline_dedup_removed_count_in_response(client):
    import threading as _th
    done = _th.Event()

    def mock_bp(*a, **kw): done.set(); return {"ea_readiness": "high"}

    with patch("server.extract_raw_notes", return_value={"written": 0}), \
         patch("server.merge_structured_extractions", return_value={"new": 0}), \
         patch("server._run_dedup", return_value={"removed": 3, "merged": 3}), \
         patch("server.write_concept_notes", return_value={"created": 0}), \
         patch("server.detect_conflicts", return_value={"total": 0}), \
         patch("server._auto_resolve_conflicts", return_value={"auto_resolved": 2, "still_pending": 1}), \
         patch("server.extract_ea_components_from_files", return_value={"total_rules": 10}), \
         patch("server.generate_blueprint_from_files", mock_bp):
        client.post("/api/learning/run-pipeline", json={})
        done.wait(timeout=3)
        import time; time.sleep(0.05)

    result = client.get("/api/learning/pipeline-status").get_json().get("result", {})
    assert result["dedup"]["removed"] == 3
    assert result["auto_resolve"]["auto_resolved"] == 2
    assert result["auto_resolve"]["still_pending"] == 1


def test_run_pipeline_without_llm_preserves_high_readiness_outputs(tmp_path):
    from server import _run_full_pipeline

    structured = tmp_path / "structured_extractions.json"
    structured.write_text(json.dumps({"version": 1, "items": {}}), encoding="utf-8")
    manifest = tmp_path / "channel_manifest.json"
    manifest.write_text(json.dumps({"version": 1, "videos": {}}), encoding="utf-8")
    index = tmp_path / "knowledge_index.json"
    index.write_text(json.dumps({"version": 1, "concepts": {}}), encoding="utf-8")
    concepts_dir = tmp_path / "concepts"
    concepts_dir.mkdir()
    components = tmp_path / "ea_components.json"
    original_components = {
        "version": 1,
        "components": {},
        "summary": {
            "ea_readiness": "high",
            "total_rules": 197,
            "components_complete": ["entry", "stop_loss", "exit", "filter", "regime"],
            "components_missing": [],
        },
    }
    components.write_text(json.dumps(original_components), encoding="utf-8")
    blueprint = tmp_path / "ea_blueprint.json"
    original_blueprint = {
        "version": 1,
        "mql5_code": "// rich blueprint",
        "summary": {"ea_readiness": "high", "total_rules_used": 197},
    }
    blueprint.write_text(json.dumps(original_blueprint), encoding="utf-8")

    app = create_app({
        "TESTING": True,
        "RAW_DIR": str(tmp_path / "raw" / "youtube"),
        "LOCAL_RAW_DIR": str(tmp_path / "raw" / "local"),
        "STRUCTURED_PATH": str(structured),
        "MANIFEST_PATH": str(manifest),
        "INDEX_PATH": str(index),
        "MERGE_LOG_PATH": str(tmp_path / "merge_log.json"),
        "CONCEPTS_DIR": str(concepts_dir),
        "CONFLICT_QUEUE_PATH": str(tmp_path / "queue.json"),
        "COMPONENTS_PATH": str(components),
        "BLUEPRINT_PATH": str(blueprint),
    })

    def low_components(index_path, structured_path, output_path):
        downgraded = {
            "version": 1,
            "components": {},
            "summary": {
                "ea_readiness": "medium",
                "total_rules": 3,
                "components_complete": ["entry", "stop_loss", "regime"],
                "components_missing": ["exit", "filter"],
            },
        }
        Path(output_path).write_text(json.dumps(downgraded), encoding="utf-8")
        return downgraded

    def low_blueprint(components_path, output_path, mq5_path=None):
        downgraded = {
            "version": 1,
            "mql5_code": "// downgraded blueprint",
            "summary": {"ea_readiness": "medium", "total_rules_used": 3},
        }
        Path(output_path).write_text(json.dumps(downgraded), encoding="utf-8")
        return downgraded

    with patch("server._make_llm_client", return_value=None), \
         patch("server.extract_raw_notes", return_value={"processed": 1, "written": 1}), \
         patch("server.merge_structured_extractions", return_value={"new": 0}), \
         patch("server._run_dedup", return_value={"removed": 0, "merged": 0}), \
         patch("server.write_concept_notes", return_value={"created": 0}), \
         patch("server.detect_conflicts", return_value={"total": 0}), \
         patch("server._auto_resolve_conflicts", return_value={"auto_resolved": 0, "still_pending": 0}), \
         patch("server.extract_ea_components_from_files", side_effect=low_components), \
         patch("server.generate_blueprint_from_files", side_effect=low_blueprint):
        result = _run_full_pipeline(app)

    assert result["quality_guard"]["action"] == "restored_previous_outputs"
    assert json.loads(components.read_text(encoding="utf-8")) == original_components
    assert json.loads(blueprint.read_text(encoding="utf-8")) == original_blueprint


def test_learn_new_auto_triggers_pipeline_when_videos_written(client):
    with patch("server.learn_new_videos", return_value={"written": 2, "failed": 0}), \
         patch("server._run_full_pipeline", return_value={"extract": {}, "blueprint": {}}) as mock_pipe:
        resp = client.post("/api/learning/learn-new", json={})
    assert resp.status_code == 200
    assert mock_pipe.called
    data = resp.get_json()
    assert "pipeline" in data
    assert data["pipeline"] is not None


def test_learn_new_no_pipeline_when_nothing_written(client):
    with patch("server.learn_new_videos", return_value={"written": 0, "failed": 0}), \
         patch("server._run_full_pipeline") as mock_pipe:
        resp = client.post("/api/learning/learn-new", json={})
    mock_pipe.assert_not_called()
    data = resp.get_json()
    assert data.get("pipeline") is None


def test_learn_new_pipeline_disabled_by_flag(client):
    with patch("server.learn_new_videos", return_value={"written": 3, "failed": 0}), \
         patch("server._run_full_pipeline") as mock_pipe:
        resp = client.post("/api/learning/learn-new", json={"auto_pipeline": False})
    assert not mock_pipe.called
    assert resp.get_json().get("pipeline") is None


def test_get_status_has_ea_rules(client):
    data = client.get("/api/learning/status").get_json()
    assert "ea_rules" in data


def test_auto_resolve_conflicts_resolves_low_evidence(tmp_path):
    from server import _auto_resolve_conflicts
    q_path = tmp_path / "queue.json"
    q_path.write_text(json.dumps({"version": 1, "items": {
        "id1": {"conflict_id": "id1", "status": "pending", "type": "low_evidence",
                "concept": "X", "severity": "low", "affected_sources": [],
                "rule_a": None, "rule_b": None, "suggested_action": "manual_review",
                "summary": "", "detected_at": "2026-05-24T10:00:00+07:00"},
        "id2": {"conflict_id": "id2", "status": "pending", "type": "incomplete_rule",
                "concept": "Y", "severity": "low", "affected_sources": [],
                "rule_a": None, "rule_b": None, "suggested_action": "manual_review",
                "summary": "", "detected_at": "2026-05-24T10:00:00+07:00"},
    }}), encoding="utf-8")
    result = _auto_resolve_conflicts(q_path)
    assert result["auto_resolved"] == 2
    assert result["still_pending"] == 0


def test_auto_resolve_conflicts_keeps_contradiction_pending(tmp_path):
    from server import _auto_resolve_conflicts
    q_path = tmp_path / "queue.json"
    q_path.write_text(json.dumps({"version": 1, "items": {
        "id1": {"conflict_id": "id1", "status": "pending", "type": "contradiction",
                "concept": "BOS", "severity": "high", "affected_sources": [],
                "rule_a": "Enter long", "rule_b": "Enter short",
                "suggested_action": "manual_review",
                "summary": "Contradiction", "detected_at": "2026-05-24T10:00:00+07:00"},
    }}), encoding="utf-8")
    result = _auto_resolve_conflicts(q_path)
    assert result["auto_resolved"] == 0
    assert result["still_pending"] == 1


# ---------------------------------------------------------------------------
# GET /api/learning/conflicts — filter + pagination (ORCA: tests first)
# ---------------------------------------------------------------------------


def test_get_conflicts_supports_concept_filter(client):
    data = client.get("/api/learning/conflicts?concept=FVG").get_json()
    assert all(i["concept"] == "FVG" for i in data["items"])


def test_get_conflicts_concept_filter_excludes_others(client):
    data = client.get("/api/learning/conflicts?concept=BOS").get_json()
    concepts = [i["concept"] for i in data["items"]]
    assert "FVG" not in concepts
    assert "BOS" in concepts


def test_get_conflicts_supports_type_filter(client):
    data = client.get("/api/learning/conflicts?type=incomplete_rule").get_json()
    assert all(i["type"] == "incomplete_rule" for i in data["items"])
    assert len(data["items"]) == 1


def test_get_conflicts_supports_severity_filter(client):
    data = client.get("/api/learning/conflicts?severity=high").get_json()
    assert all(i["severity"] == "high" for i in data["items"])
    assert len(data["items"]) == 1


def test_get_conflicts_combined_concept_and_type_filter(client):
    data = client.get("/api/learning/conflicts?concept=FVG&type=low_confidence").get_json()
    assert len(data["items"]) == 1
    assert data["items"][0]["conflict_id"] == "abc123def456"


def test_get_conflicts_returns_total_count(client):
    data = client.get("/api/learning/conflicts").get_json()
    assert "total" in data
    assert data["total"] == 3


def test_get_conflicts_pagination_page1(client):
    data = client.get("/api/learning/conflicts?per_page=2&page=1").get_json()
    assert len(data["items"]) == 2
    assert data["total"] == 3
    assert data["page"] == 1
    assert data["pages"] == 2


def test_get_conflicts_pagination_page2(client):
    data = client.get("/api/learning/conflicts?per_page=2&page=2").get_json()
    assert len(data["items"]) == 1
    assert data["page"] == 2


def test_get_conflicts_pagination_defaults_to_page1(client):
    data = client.get("/api/learning/conflicts?per_page=2").get_json()
    assert data["page"] == 1


def test_get_conflicts_filter_and_pagination_combined(client):
    data = client.get("/api/learning/conflicts?status=pending&per_page=1&page=1").get_json()
    assert len(data["items"]) == 1
    assert data["total"] == 2
    assert data["pages"] == 2


# ---------------------------------------------------------------------------
# GET /api/learning/knowledge-index
# ---------------------------------------------------------------------------


def test_get_knowledge_index_returns_200(client):
    resp = client.get("/api/learning/knowledge-index")
    assert resp.status_code == 200


def test_get_knowledge_index_has_concepts(client):
    data = client.get("/api/learning/knowledge-index").get_json()
    assert "concepts" in data


def test_get_knowledge_index_concept_has_confidence(client):
    data = client.get("/api/learning/knowledge-index").get_json()
    fvg = data["concepts"].get("FVG")
    assert fvg is not None
    assert fvg["confidence"] == 75


def test_get_knowledge_index_missing_returns_empty(tmp_path):
    app = create_app({
        "TESTING": True,
        "INDEX_PATH": str(tmp_path / "nonexistent.json"),
        "MANIFEST_PATH": str(tmp_path / "manifest.json"),
        "CONFLICT_QUEUE_PATH": str(tmp_path / "queue.json"),
        "CONCEPTS_DIR": str(tmp_path / "concepts"),
    })
    c = app.test_client()
    data = c.get("/api/learning/knowledge-index").get_json()
    assert data == {"version": 1, "concepts": {}}


# ---------------------------------------------------------------------------
# GET /api/learning/manifest
# ---------------------------------------------------------------------------


def test_get_manifest_returns_200(client):
    resp = client.get("/api/learning/manifest")
    assert resp.status_code == 200


def test_get_manifest_has_videos(client):
    data = client.get("/api/learning/manifest").get_json()
    assert "videos" in data


def test_get_manifest_video_count(client):
    data = client.get("/api/learning/manifest").get_json()
    assert len(data["videos"]) == 4


def test_get_manifest_missing_returns_empty(tmp_path):
    app = create_app({
        "TESTING": True,
        "INDEX_PATH": str(tmp_path / "nonexistent.json"),
        "MANIFEST_PATH": str(tmp_path / "manifest.json"),
        "CONFLICT_QUEUE_PATH": str(tmp_path / "queue.json"),
        "CONCEPTS_DIR": str(tmp_path / "concepts"),
    })
    c = app.test_client()
    data = c.get("/api/learning/manifest").get_json()
    assert data == {"channels": {}, "videos": {}}


# ---------------------------------------------------------------------------
# GET /api/learning/blueprint
# POST /api/learning/blueprint
# ---------------------------------------------------------------------------


def test_get_blueprint_returns_200(client):
    resp = client.get("/api/learning/blueprint")
    assert resp.status_code == 200


def test_get_blueprint_missing_returns_null_code(client):
    data = client.get("/api/learning/blueprint").get_json()
    # no blueprint generated yet — mql5_code is None
    assert "mql5_code" in data


def test_post_blueprint_returns_200(client):
    resp = client.post("/api/learning/blueprint", json={})
    assert resp.status_code == 200


def test_post_blueprint_returns_mql5_code(client):
    data = client.post("/api/learning/blueprint", json={}).get_json()
    assert "mql5_code" in data
    assert data["mql5_code"] is not None
    assert len(data["mql5_code"]) > 100


def test_post_blueprint_code_has_ontick(client):
    data = client.post("/api/learning/blueprint", json={}).get_json()
    assert "OnTick" in data["mql5_code"]


def test_post_blueprint_summary_has_readiness(client):
    data = client.post("/api/learning/blueprint", json={}).get_json()
    assert data["summary"]["ea_readiness"] == "medium"


def test_post_blueprint_persists_so_get_returns_it(client):
    client.post("/api/learning/blueprint", json={})
    data = client.get("/api/learning/blueprint").get_json()
    assert data.get("mql5_code") is not None


# ---------------------------------------------------------------------------
# GET  /api/learning/settings/cookies
# POST /api/learning/settings/cookies
# DELETE /api/learning/settings/cookies
# POST /api/learning/settings/test-youtube
# ORCA: tests written before implementation
# ---------------------------------------------------------------------------

_NETSCAPE_COOKIES = """\
# Netscape HTTP Cookie File
.youtube.com\tTRUE\t/\tFALSE\t9999999999\tSAPISID\tABCDEFG_test
.youtube.com\tTRUE\t/\tTRUE\t9999999999\t__Secure-1PSID\ttest_psid_value
"""


def test_get_cookies_status_no_file(client):
    data = client.get("/api/learning/settings/cookies").get_json()
    assert data["exists"] is False
    assert data["size_bytes"] == 0


def test_get_cookies_status_with_file(app, client, tmp_path):
    cookies_path = Path(app.config["COOKIES_PATH"])
    cookies_path.write_text(_NETSCAPE_COOKIES, encoding="utf-8")
    data = client.get("/api/learning/settings/cookies").get_json()
    assert data["exists"] is True
    assert data["size_bytes"] > 0


def test_save_cookies_creates_file(app, client):
    resp = client.post("/api/learning/settings/cookies",
                       json={"content": _NETSCAPE_COOKIES})
    assert resp.status_code == 200
    cookies_path = Path(app.config["COOKIES_PATH"])
    assert cookies_path.exists()
    assert "SAPISID" in cookies_path.read_text(encoding="utf-8")


def test_save_cookies_returns_saved_true(client):
    data = client.post("/api/learning/settings/cookies",
                       json={"content": _NETSCAPE_COOKIES}).get_json()
    assert data["saved"] is True
    assert data["lines"] > 0


def test_save_cookies_empty_content_returns_400(client):
    resp = client.post("/api/learning/settings/cookies", json={"content": "   "})
    assert resp.status_code == 400


def test_save_cookies_missing_content_returns_400(client):
    resp = client.post("/api/learning/settings/cookies", json={})
    assert resp.status_code == 400


def test_delete_cookies_removes_file(app, client):
    Path(app.config["COOKIES_PATH"]).write_text(_NETSCAPE_COOKIES, encoding="utf-8")
    resp = client.delete("/api/learning/settings/cookies")
    assert resp.status_code == 200
    data = resp.get_json()
    assert data["deleted"] is True
    assert not Path(app.config["COOKIES_PATH"]).exists()


def test_delete_cookies_no_file_returns_deleted_false(client):
    resp = client.delete("/api/learning/settings/cookies")
    assert resp.status_code == 200
    assert resp.get_json()["deleted"] is False


def test_test_youtube_no_cookies_returns_blocked(client):
    data = client.post("/api/learning/settings/test-youtube").get_json()
    assert data["status"] in ("blocked", "no_cookies")


def test_test_youtube_with_cookies_calls_transcript_api(app, client):
    Path(app.config["COOKIES_PATH"]).write_text(_NETSCAPE_COOKIES, encoding="utf-8")
    with patch("server._test_youtube_connection") as mock_test:
        mock_test.return_value = {"status": "ok", "video_id": "dQw4w9WgXcQ", "language": "en"}
        data = client.post("/api/learning/settings/test-youtube").get_json()
    assert data["status"] == "ok"


def test_test_youtube_api_error_returns_error_status(app, client):
    Path(app.config["COOKIES_PATH"]).write_text(_NETSCAPE_COOKIES, encoding="utf-8")
    with patch("server._test_youtube_connection") as mock_test:
        mock_test.return_value = {"status": "error", "error": "IpBlocked"}
        data = client.post("/api/learning/settings/test-youtube").get_json()
    assert data["status"] == "error"
    assert "error" in data


def test_youtube_status_uses_same_connection_helper(app, client):
    Path(app.config["COOKIES_PATH"]).write_text(_NETSCAPE_COOKIES, encoding="utf-8")
    with patch("server._test_youtube_connection") as mock_test:
        mock_test.return_value = {
            "status": "ok",
            "message": "YouTube accessible",
            "words": 42,
            "language": "en",
        }
        data = client.get("/api/learning/youtube-status").get_json()
    assert data["status"] == "ok"
    assert data["message"] == "YouTube accessible"
    assert data["words"] == 42
    mock_test.assert_called_once_with(Path(app.config["COOKIES_PATH"]))


def test_youtube_status_without_cookies_is_explicit(client):
    data = client.get("/api/learning/youtube-status").get_json()
    assert data["status"] == "no_cookies"
    assert data["has_cookies"] is False


# ---------------------------------------------------------------------------
# GET /api/learning/engine-status
# ---------------------------------------------------------------------------


def test_engine_status_empty_state_is_safe(client):
    with patch("server.importlib.util.find_spec", return_value=None), \
            patch("server.shutil.which", return_value=None):
        resp = client.get("/api/learning/engine-status")

    assert resp.status_code == 200
    data = resp.get_json()
    assert data["generated_at"]
    assert data["video_transcription"]["status"] == "unavailable"
    assert data["video_transcription"]["providers"] == {
        "faster_whisper": False,
        "openai_whisper": False,
        "whisper_cli": False,
    }
    assert data["image_ocr"]["status"] == "unavailable"
    assert data["image_ocr"]["providers"] == {
        "pillow": False,
        "pytesseract": False,
        "tesseract_cli": False,
    }
    assert data["youtube"]["status"] == "cookies_missing"
    assert data["youtube"]["has_cookies"] is False
    assert data["local_raw"]["notes_count"] == 0


def test_engine_status_reports_available_engines_and_local_raw(app, client):
    cookies_path = Path(app.config["COOKIES_PATH"])
    cookies_path.write_text(_NETSCAPE_COOKIES, encoding="utf-8")
    local_raw = Path(app.config["LOCAL_RAW_DIR"])
    local_raw.mkdir(parents=True)
    (local_raw / "2026-05-26_chart.md").write_text("# chart", encoding="utf-8")

    def fake_find_spec(name):
        return object() if name in {"faster_whisper", "PIL", "pytesseract"} else None

    with patch("server.importlib.util.find_spec", side_effect=fake_find_spec), \
            patch("server.shutil.which", return_value=None):
        data = client.get("/api/learning/engine-status").get_json()

    assert data["video_transcription"]["status"] == "available"
    assert data["video_transcription"]["providers"]["faster_whisper"] is True
    assert data["image_ocr"]["status"] == "available"
    assert data["image_ocr"]["providers"]["pillow"] is True
    assert data["image_ocr"]["providers"]["pytesseract"] is True
    assert data["youtube"]["status"] == "cookies_configured"
    assert data["youtube"]["has_cookies"] is True
    assert data["local_raw"]["notes_count"] == 1


# ---------------------------------------------------------------------------
# GET /api/learning/ai-budget
# ---------------------------------------------------------------------------


def test_ai_budget_status_uses_configured_daily_budget(app, client, monkeypatch):
    monkeypatch.setenv("EA_KB_AI_DAILY_BUDGET_UNITS", "100")
    monkeypatch.setenv("EA_KB_AI_USED_UNITS", "43")
    monkeypatch.setenv("ANTHROPIC_API_KEY", "test-anthropic")
    monkeypatch.setenv("GEMINI_API_KEY", "test-gemini")
    monkeypatch.setenv("OPENROUTER_API_KEY", "test-openrouter")

    data = client.get("/api/learning/ai-budget").get_json()

    assert data["status"] == "continue"
    assert data["used_percent"] == 43
    assert data["left_percent"] == 57
    assert data["recommendation"] == "Continue"
    assert data["guard"]["no_llm_downgrade_protected"] is True
    providers = {p["id"]: p for p in data["providers"]}
    assert providers["anthropic"]["configured"] is True
    assert providers["gemini"]["configured"] is True
    assert providers["openrouter"]["configured"] is True


def test_ai_budget_status_warns_when_usage_is_high(client, monkeypatch):
    monkeypatch.setenv("EA_KB_AI_DAILY_BUDGET_UNITS", "100")
    monkeypatch.setenv("EA_KB_AI_USED_UNITS", "92")

    data = client.get("/api/learning/ai-budget").get_json()

    assert data["status"] == "stop_heavy"
    assert data["used_percent"] == 92
    assert data["left_percent"] == 8
    assert data["recommendation"] == "Stop heavy tasks"


def test_ai_budget_status_reads_usage_log(client, tmp_path, monkeypatch):
    usage_log = tmp_path / "ai_usage.jsonl"
    usage_log.write_text(
        '{"provider":"anthropic","units":25}\n'
        '{"provider":"gemini","units":15}\n',
        encoding="utf-8",
    )
    monkeypatch.setenv("EA_KB_AI_USAGE_LOG", str(usage_log))
    monkeypatch.setenv("EA_KB_AI_DAILY_BUDGET_UNITS", "100")
    monkeypatch.delenv("EA_KB_AI_USED_UNITS", raising=False)

    data = client.get("/api/learning/ai-budget").get_json()

    assert data["used_units"] == 40
    assert data["used_percent"] == 40
    providers = {p["id"]: p for p in data["providers"]}
    assert providers["anthropic"]["used_percent"] == 25
    assert providers["gemini"]["used_percent"] == 15


def test_ai_budget_status_shows_local_llm_when_configured(client, monkeypatch):
    monkeypatch.setenv("LOCAL_LLM_URL", "http://127.0.0.1:1234/v1")
    monkeypatch.setenv("LOCAL_LLM_MODEL", "google/gemma-4-e4b")
    monkeypatch.delenv("ANTHROPIC_API_KEY", raising=False)
    monkeypatch.delenv("OPENAI_API_KEY", raising=False)
    monkeypatch.delenv("GEMINI_API_KEY", raising=False)
    monkeypatch.delenv("OPENROUTER_API_KEY", raising=False)

    data = client.get("/api/learning/ai-budget").get_json()
    providers = {p["id"]: p for p in data["providers"]}

    assert data["mode"] == "Local LLM Ready"
    assert providers["local_llm"]["configured"] is True
    assert providers["local_llm"]["label"] == "LM Studio"


def test_make_llm_client_prefers_local_when_cloud_unavailable(monkeypatch):
    import sys
    import server

    created = {}

    class FakeOpenAI:
        def __init__(self, base_url=None, api_key=None):
            created["base_url"] = base_url
            created["api_key"] = api_key

    monkeypatch.setenv("LOCAL_LLM_URL", "http://127.0.0.1:1234/v1")
    monkeypatch.delenv("OPENAI_API_KEY", raising=False)
    monkeypatch.delenv("ANTHROPIC_API_KEY", raising=False)
    monkeypatch.setitem(sys.modules, "openai", type("FakeOpenAIModule", (), {"OpenAI": FakeOpenAI}))

    client = server._make_llm_client()

    assert client is not None
    assert created["base_url"] == "http://127.0.0.1:1234/v1"
    assert created["api_key"] == "lm-studio"


def test_make_llm_client_uses_local_when_cloud_budget_is_high(monkeypatch):
    import sys
    import server

    created = {}

    class FakeOpenAI:
        def __init__(self, base_url=None, api_key=None):
            created["base_url"] = base_url
            created["api_key"] = api_key

    monkeypatch.setenv("LOCAL_LLM_URL", "http://127.0.0.1:1234/v1")
    monkeypatch.setenv("ANTHROPIC_API_KEY", "test-anthropic")
    monkeypatch.setenv("EA_KB_AI_DAILY_BUDGET_UNITS", "100")
    monkeypatch.setenv("EA_KB_AI_USED_UNITS", "72")
    monkeypatch.setitem(sys.modules, "openai", type("FakeOpenAIModule", (), {"OpenAI": FakeOpenAI}))

    client = server._make_llm_client()

    assert client is not None
    assert created["base_url"] == "http://127.0.0.1:1234/v1"


# ---------------------------------------------------------------------------
# Background pipeline task
# GET  /api/learning/pipeline-status
# POST /api/learning/run-pipeline   → returns {"status": "started"} immediately
# POST /api/learning/learn-new      → returns immediately, pipeline in background
# ORCA: tests written before implementation
# ---------------------------------------------------------------------------


def test_pipeline_status_not_running(client):
    data = client.get("/api/learning/pipeline-status").get_json()
    assert data["running"] is False
    assert "result" in data


def test_run_pipeline_returns_started_immediately(client):
    with patch("server._run_full_pipeline") as mock_pipe:
        mock_pipe.return_value = {"extract": {}, "merge": {}}
        data = client.post("/api/learning/run-pipeline").get_json()
    assert data.get("status") == "started"


def test_run_pipeline_does_not_block_request(client):
    import time
    with patch("server._run_full_pipeline") as mock_pipe:
        mock_pipe.side_effect = lambda app: time.sleep(5)
        start = time.time()
        client.post("/api/learning/run-pipeline")
        elapsed = time.time() - start
    assert elapsed < 2.0  # must return well before the 5s sleep finishes


def test_learn_new_returns_immediately_when_pipeline_starts(client):
    with patch("server.learn_new_videos") as mock_learn, \
         patch("server._run_full_pipeline"):
        mock_learn.return_value = {"written": 1, "failed": 0}
        start = __import__("time").time()
        data = client.post("/api/learning/learn-new",
                           json={"auto_pipeline": True}).get_json()
        elapsed = __import__("time").time() - start
    assert elapsed < 2.0
    assert data.get("pipeline") == "started"


def test_pipeline_status_result_available_after_completion(client):
    import threading, time

    completed = threading.Event()
    with patch("server._run_full_pipeline") as mock_pipe:
        def slow_pipe(app):
            time.sleep(0.05)
            completed.set()
            return {"done": True}
        mock_pipe.side_effect = slow_pipe
        client.post("/api/learning/run-pipeline")
        completed.wait(timeout=2)
        time.sleep(0.05)  # let state update
    data = client.get("/api/learning/pipeline-status").get_json()
    assert data["running"] is False


def test_post_blueprint_missing_components_returns_404(tmp_path):
    app = create_app({
        "TESTING": True,
        "COMPONENTS_PATH": str(tmp_path / "missing.json"),
        "BLUEPRINT_PATH": str(tmp_path / "bp.json"),
        "INDEX_PATH": str(tmp_path / "idx.json"),
        "MANIFEST_PATH": str(tmp_path / "mf.json"),
        "CONFLICT_QUEUE_PATH": str(tmp_path / "q.json"),
        "CONCEPTS_DIR": str(tmp_path / "c"),
    })
    resp = app.test_client().post("/api/learning/blueprint", json={})
    assert resp.status_code == 404
