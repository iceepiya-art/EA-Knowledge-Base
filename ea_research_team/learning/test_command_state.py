from __future__ import annotations

import pytest

from command_state import CommandStateError, CommandStateStore
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
        "status": "stopped",
    }
    payload.update(overrides)
    return payload


def test_default_state_is_safe_and_idle(tmp_path):
    store = CommandStateStore(tmp_path / "command_state.json")

    state = store.state()

    assert state["global"]["mode"] == "stopped"
    assert state["global"]["kill"] is False
    assert state["groups"] == {}
    assert state["eas"] == {}
    assert state["commands"] == []


def test_dispatches_per_ea_start_command_and_records_history(tmp_path):
    registry = EARegistryStore(tmp_path / "ea_registry.json")
    registry.register_ea(_ea_payload())
    store = CommandStateStore(tmp_path / "command_state.json", registry)

    result = store.dispatch({"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01", "command": "start"})

    assert result["accepted"] is True
    assert result["target"] == {"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01"}
    state = store.state()
    assert state["eas"]["EA_GOLD_SCALPER_01"]["mode"] == "running"
    assert state["eas"]["EA_GOLD_SCALPER_01"]["last_command"] == "start"
    assert state["commands"][0]["command"] == "start"


def test_global_kill_blocks_all_dry_run_decisions_until_resume(tmp_path):
    store = CommandStateStore(tmp_path / "command_state.json")

    store.dispatch({"scope": "global", "command": "kill", "reason": "operator"})
    blocked = store.evaluate_decision({"ea_id": "EA_GOLD_SCALPER_01"})
    store.dispatch({"scope": "global", "command": "resume"})
    allowed = store.evaluate_decision({"ea_id": "EA_GOLD_SCALPER_01"})

    assert blocked["allowed"] is False
    assert "global_kill" in blocked["reasons"]
    assert allowed["allowed"] is True


def test_group_stop_blocks_only_members_of_that_group(tmp_path):
    registry = EARegistryStore(tmp_path / "ea_registry.json")
    registry.register_ea(_ea_payload(ea_id="EA_GOLD_SCALPER_01", magic_number=26060801, strategy_family="gold"))
    registry.register_ea(_ea_payload(ea_id="EA_BTC_SCALPER_02", magic_number=26060802, symbol="BTCUSD", strategy_family="crypto"))
    store = CommandStateStore(tmp_path / "command_state.json", registry)

    store.dispatch({"scope": "group", "group_id": "gold", "command": "stop"})

    blocked = store.evaluate_decision({"ea_id": "EA_GOLD_SCALPER_01", "group_id": "gold"})
    allowed = store.evaluate_decision({"ea_id": "EA_BTC_SCALPER_02", "group_id": "crypto"})
    assert blocked["allowed"] is False
    assert "group_stopped" in blocked["reasons"]
    assert allowed["allowed"] is True


def test_rejects_unknown_registered_ea_target(tmp_path):
    registry = EARegistryStore(tmp_path / "ea_registry.json")
    store = CommandStateStore(tmp_path / "command_state.json", registry)

    with pytest.raises(CommandStateError, match="Unknown ea_id"):
        store.dispatch({"scope": "ea", "ea_id": "UNKNOWN_EA", "command": "start"})


def test_close_command_sets_close_requested_without_live_execution(tmp_path):
    registry = EARegistryStore(tmp_path / "ea_registry.json")
    registry.register_ea(_ea_payload())
    store = CommandStateStore(tmp_path / "command_state.json", registry)

    result = store.dispatch({"scope": "ea", "ea_id": "EA_GOLD_SCALPER_01", "command": "close"})

    ea_state = store.state()["eas"]["EA_GOLD_SCALPER_01"]
    assert result["execution"] == "state_only"
    assert ea_state["close_requested"] is True
    assert ea_state["mode"] == "closing"
