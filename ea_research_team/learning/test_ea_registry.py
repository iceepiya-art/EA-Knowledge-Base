from __future__ import annotations

import pytest

from ea_registry import EARegistryError, EARegistryStore


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
        "status": "stopped",
    }
    payload.update(overrides)
    return payload


def test_registers_and_reads_ea_by_id(tmp_path):
    store = EARegistryStore(tmp_path / "ea_registry.json")

    registered = store.register_ea(_ea_payload())

    assert registered["ea_id"] == "EA_001"
    assert registered["magic_number"] == 10001
    assert store.get_ea("EA_001")["ea_name"] == "Scalper XAU M1"


def test_lists_eas_sorted_by_id(tmp_path):
    store = EARegistryStore(tmp_path / "ea_registry.json")
    store.register_ea(_ea_payload(ea_id="EA_002", magic_number=10002))
    store.register_ea(_ea_payload(ea_id="EA_001", magic_number=10001))

    assert [item["ea_id"] for item in store.list_eas()] == ["EA_001", "EA_002"]


def test_finds_ea_by_terminal_account_and_magic_number(tmp_path):
    store = EARegistryStore(tmp_path / "ea_registry.json")
    store.register_ea(_ea_payload(ea_id="EA_001", magic_number=10001, account_id="account_a"))
    store.register_ea(_ea_payload(ea_id="EA_002", magic_number=10001, account_id="account_b"))

    found = store.find_by_magic_number(
        terminal_id="terminal_01",
        account_id="account_b",
        magic_number=10001,
    )

    assert found["ea_id"] == "EA_002"


def test_rejects_missing_required_identity_fields(tmp_path):
    store = EARegistryStore(tmp_path / "ea_registry.json")
    payload = _ea_payload()
    del payload["ea_id"]

    with pytest.raises(EARegistryError, match="ea_id"):
        store.register_ea(payload)


def test_rejects_duplicate_ea_id(tmp_path):
    store = EARegistryStore(tmp_path / "ea_registry.json")
    store.register_ea(_ea_payload())

    with pytest.raises(EARegistryError, match="already exists"):
        store.register_ea(_ea_payload(ea_name="Duplicate"))


def test_rejects_duplicate_magic_number_within_same_terminal_account(tmp_path):
    store = EARegistryStore(tmp_path / "ea_registry.json")
    store.register_ea(_ea_payload(ea_id="EA_001", magic_number=10001))

    with pytest.raises(EARegistryError, match="magic_number"):
        store.register_ea(_ea_payload(ea_id="EA_002", magic_number=10001))


def test_allows_same_magic_number_on_different_account(tmp_path):
    store = EARegistryStore(tmp_path / "ea_registry.json")
    store.register_ea(_ea_payload(ea_id="EA_001", magic_number=10001, account_id="account_a"))
    store.register_ea(_ea_payload(ea_id="EA_002", magic_number=10001, account_id="account_b"))

    assert len(store.list_eas()) == 2

