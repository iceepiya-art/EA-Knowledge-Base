from __future__ import annotations

import pytest

from blade_executor import BladeExecutionError, BladeDryRunExecutor
from command_state import CommandStateStore
from ea_registry import EARegistryStore


def _ea_payload(**overrides):
    payload = {
        "ea_id": "EA_GOLD_SCALPER_01",
        "ea_name": "Gold Scalper",
        "magic_number": 26060801,
        "symbol": "XAUUSD",
        "timeframe": "M15",
        "terminal_id": "MT5-LIVE-01",
        "account_id": "12345678",
        "strategy_family": "scalping",
        "status": "testing",
    }
    payload.update(overrides)
    return payload


def _intent_payload(**overrides):
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


def test_dry_run_executor_writes_state_only_execution_intent(tmp_path):
    registry = EARegistryStore(tmp_path / "ea_registry.json")
    registry.register_ea(_ea_payload())
    commands = CommandStateStore(tmp_path / "command_state.json", registry)
    commands.dispatch({"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01", "command": "start"})
    executor = BladeDryRunExecutor(tmp_path / "blade_intents.json", registry, commands)

    intent = executor.create_intent(_intent_payload())

    assert intent["intent_id"].startswith("BLADE-")
    assert intent["mode"] == "dry_run"
    assert intent["order_send"] is False
    assert intent["status"] == "intent_logged"
    assert intent["ea_id"] == "EA_GOLD_SCALPER_01"
    assert executor.list_intents("EA_GOLD_SCALPER_01")[0]["intent_id"] == intent["intent_id"]


def test_dry_run_executor_rejects_unregistered_ea(tmp_path):
    registry = EARegistryStore(tmp_path / "ea_registry.json")
    commands = CommandStateStore(tmp_path / "command_state.json", registry)
    executor = BladeDryRunExecutor(tmp_path / "blade_intents.json", registry, commands)

    with pytest.raises(BladeExecutionError, match="Unknown ea_id"):
        executor.create_intent(_intent_payload())


def test_dry_run_executor_rejects_unapproved_risk_gate(tmp_path):
    registry = EARegistryStore(tmp_path / "ea_registry.json")
    registry.register_ea(_ea_payload())
    commands = CommandStateStore(tmp_path / "command_state.json", registry)
    commands.dispatch({"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01", "command": "start"})
    executor = BladeDryRunExecutor(tmp_path / "blade_intents.json", registry, commands)

    with pytest.raises(BladeExecutionError, match="Risk Gate"):
        executor.create_intent(_intent_payload(risk_gate={"approved": False, "decision": "reject"}))

    attempts = executor.list_intents("EA_GOLD_SCALPER_01")
    assert len(attempts) == 1
    assert attempts[0]["status"] == "rejected"
    assert attempts[0]["order_send"] is False
    assert attempts[0]["rejection_reason"] == "risk_gate_not_approved"


def test_dry_run_executor_rejects_killed_command_state(tmp_path):
    registry = EARegistryStore(tmp_path / "ea_registry.json")
    registry.register_ea(_ea_payload())
    commands = CommandStateStore(tmp_path / "command_state.json", registry)
    commands.dispatch({"scope": "global", "command": "kill"})
    executor = BladeDryRunExecutor(tmp_path / "blade_intents.json", registry, commands)

    with pytest.raises(BladeExecutionError, match="Command State blocked"):
        executor.create_intent(_intent_payload())

    attempts = executor.list_intents("EA_GOLD_SCALPER_01")
    assert len(attempts) == 1
    assert attempts[0]["status"] == "blocked"
    assert attempts[0]["order_send"] is False
    assert attempts[0]["command_state"]["allowed"] is False
    assert "global_kill" in attempts[0]["command_state"]["reasons"]
