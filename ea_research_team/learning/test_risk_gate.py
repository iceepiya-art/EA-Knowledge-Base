from __future__ import annotations

from risk_gate import RiskGateStore


def _request(**overrides):
    payload = {
        "ea_id": "EA_001",
        "requested_lot": 0.01,
        "open_positions": [],
        "daily_pnl": 0.0,
    }
    payload.update(overrides)
    return payload


def test_approves_small_request_by_default(tmp_path):
    gate = RiskGateStore(tmp_path / "risk_gate.json")

    result = gate.evaluate(_request())

    assert result["approved"] is True
    assert result["decision"] == "approve"
    assert result["reasons"] == []


def test_global_kill_rejects_all_requests(tmp_path):
    gate = RiskGateStore(tmp_path / "risk_gate.json")
    gate.kill_global("manual stop")

    result = gate.evaluate(_request())

    assert result["approved"] is False
    assert result["decision"] == "reject"
    assert "global_kill" in result["reasons"]


def test_per_ea_kill_rejects_only_target_ea(tmp_path):
    gate = RiskGateStore(tmp_path / "risk_gate.json")
    gate.kill_ea("EA_001", "bad behavior")

    blocked = gate.evaluate(_request(ea_id="EA_001"))
    allowed = gate.evaluate(_request(ea_id="EA_002"))

    assert blocked["approved"] is False
    assert "ea_kill" in blocked["reasons"]
    assert allowed["approved"] is True


def test_lot_cap_rejects_oversized_request(tmp_path):
    gate = RiskGateStore(tmp_path / "risk_gate.json")

    result = gate.evaluate(_request(requested_lot=0.02))

    assert result["approved"] is False
    assert "lot_cap" in result["reasons"]
    assert result["limits"]["max_lot"] == 0.01


def test_position_limit_rejects_too_many_positions_for_same_ea(tmp_path):
    gate = RiskGateStore(tmp_path / "risk_gate.json")
    positions = [
        {"ea_id": "EA_001", "lot": 0.01},
        {"ea_id": "EA_001", "lot": 0.01},
        {"ea_id": "EA_001", "lot": 0.01},
    ]

    result = gate.evaluate(_request(open_positions=positions))

    assert result["approved"] is False
    assert "max_positions_per_ea" in result["reasons"]


def test_total_exposure_limit_rejects_many_eas_combined(tmp_path):
    gate = RiskGateStore(tmp_path / "risk_gate.json")
    positions = [
        {"ea_id": "EA_001", "lot": 0.03},
        {"ea_id": "EA_002", "lot": 0.03},
        {"ea_id": "EA_003", "lot": 0.03},
    ]

    result = gate.evaluate(_request(requested_lot=0.02, open_positions=positions))

    assert result["approved"] is False
    assert "max_total_exposure" in result["reasons"]


def test_daily_loss_limit_rejects_when_loss_exceeds_limit(tmp_path):
    gate = RiskGateStore(tmp_path / "risk_gate.json")

    result = gate.evaluate(_request(daily_pnl=-101.0))

    assert result["approved"] is False
    assert "daily_loss_limit" in result["reasons"]


def test_resume_clears_global_and_per_ea_kill(tmp_path):
    gate = RiskGateStore(tmp_path / "risk_gate.json")
    gate.kill_global()
    gate.kill_ea("EA_001")

    gate.resume_global()
    gate.resume_ea("EA_001")

    assert gate.evaluate(_request())["approved"] is True
    assert gate.state()["global_kill"]["enabled"] is False
    assert "EA_001" not in gate.state()["ea_kills"]
