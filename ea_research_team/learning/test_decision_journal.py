from __future__ import annotations

import pytest

from decision_journal import DecisionJournalError, DecisionJournalStore
from ea_registry import EARegistryStore


def _ea_payload(**overrides):
    payload = {
        "ea_id": "EA_001",
        "ea_name": "Scalper XAU M1",
        "ea_version": "1.0.0",
        "magic_number": 10001,
        "symbol": "XAUUSD",
        "timeframe": "M1",
        "terminal_id": "terminal_01",
        "account_id": "account_a",
        "strategy_family": "scalper",
        "status": "testing",
    }
    payload.update(overrides)
    return payload


def _decision_payload(**overrides):
    payload = {
        "ea_id": "EA_001",
        "action": "buy",
        "confidence": 72,
        "symbol": "XAUUSD",
        "timeframe": "M1",
        "reason": "Momentum continuation after pullback",
        "sl": 2310.50,
        "tp": 2322.25,
        "hawk": {"signal": "buy", "confidence": 72},
        "sage": {"veto": False, "comment": "Risk acceptable"},
        "risk_gate": {"approved": True, "max_lot": 0.01},
        "blade": {"mode": "dry_run", "status": "ready"},
    }
    payload.update(overrides)
    return payload


def _stores(tmp_path):
    registry = EARegistryStore(tmp_path / "ea_registry.json")
    registry.register_ea(_ea_payload())
    journal = DecisionJournalStore(tmp_path / "decision_journal.json", registry)
    return registry, journal


def test_records_decision_for_registered_ea(tmp_path):
    _, journal = _stores(tmp_path)

    recorded = journal.record_decision(_decision_payload())

    assert recorded["decision_id"]
    assert recorded["ea_id"] == "EA_001"
    assert recorded["action"] == "buy"
    assert recorded["blade"]["mode"] == "dry_run"
    assert recorded["created_at"]


def test_rejects_missing_ea_id(tmp_path):
    _, journal = _stores(tmp_path)
    payload = _decision_payload()
    del payload["ea_id"]

    with pytest.raises(DecisionJournalError, match="ea_id"):
        journal.record_decision(payload)


def test_rejects_unknown_ea_id(tmp_path):
    _, journal = _stores(tmp_path)

    with pytest.raises(DecisionJournalError, match="Unknown ea_id"):
        journal.record_decision(_decision_payload(ea_id="EA_UNKNOWN"))


def test_lists_decisions_filtered_by_ea_id(tmp_path):
    registry, journal = _stores(tmp_path)
    registry.register_ea(_ea_payload(ea_id="EA_002", magic_number=10002))
    journal.record_decision(_decision_payload(ea_id="EA_001", action="buy"))
    journal.record_decision(_decision_payload(ea_id="EA_002", action="hold"))

    items = journal.list_decisions(ea_id="EA_002")

    assert len(items) == 1
    assert items[0]["ea_id"] == "EA_002"
    assert items[0]["action"] == "hold"


def test_summarizes_decisions_by_ea(tmp_path):
    _, journal = _stores(tmp_path)
    journal.record_decision(_decision_payload(action="buy"))
    journal.record_decision(_decision_payload(action="hold", sage={"veto": True}, risk_gate={"approved": False}))

    summary = journal.summarize(ea_id="EA_001")

    assert summary["ea_id"] == "EA_001"
    assert summary["total"] == 2
    assert summary["by_action"] == {"buy": 1, "sell": 0, "hold": 1}
    assert summary["veto_count"] == 1
    assert summary["risk_rejected_count"] == 1
