"""Regression checks for MasterEA's fail-closed FTMO guardrails.

These tests deliberately mirror the deterministic parts of the MQL5 logic so
they run in CI without connecting to MT5 or placing an order.
"""
from datetime import datetime, timedelta, timezone
from pathlib import Path
import sys

import pytest

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / "ea_research_team" / "learning"))
from server import create_app  # noqa: E402

SOURCE = Path(__file__).with_name("MasterEA_v3.mq5").read_text(encoding="utf-8")


def central_europe_offset_hours(utc: datetime) -> int:
    """EU DST: 01:00 UTC, last Sunday of March to last Sunday of October."""
    year = utc.year
    def last_sunday(month: int) -> int:
        first_next = datetime(year + (month == 12), month % 12 + 1, 1, tzinfo=timezone.utc)
        last_day = first_next - timedelta(days=1)
        return last_day.day - (last_day.weekday() + 1) % 7
    start = datetime(year, 3, last_sunday(3), 1, tzinfo=timezone.utc)
    end = datetime(year, 10, last_sunday(10), 1, tzinfo=timezone.utc)
    return 2 if start <= utc < end else 1


@pytest.mark.parametrize("utc,expected", [
    (datetime(2026, 3, 29, 0, 59, tzinfo=timezone.utc), 1),
    (datetime(2026, 3, 29, 1, 0, tzinfo=timezone.utc), 2),
    (datetime(2026, 10, 25, 0, 59, tzinfo=timezone.utc), 2),
    (datetime(2026, 10, 25, 1, 0, tzinfo=timezone.utc), 1),
])
def test_cest_dst_boundaries(utc, expected):
    assert central_europe_offset_hours(utc) == expected


def test_risk_ladder_and_tp_reset_are_encoded():
    for step in ("FTMORiskStep1", "FTMORiskStep2", "FTMORiskStep3", "FTMORiskStep4"):
        assert step in SOURCE
    assert "if(reason == DEAL_REASON_TP) break;" in SOURCE
    assert "if(losses >= FTMOMaxConsecutiveSL) return 0.0;" in SOURCE


def test_preflight_enforces_daily_and_maximum_loss_fail_closed():
    assert "account_risk_profile_must_be_ftmo_2step" in SOURCE
    assert "ftmo_internal_daily_loss_4pct_reached" in SOURCE
    assert "ftmo_maximum_loss_10pct_reached" in SOURCE
    assert "ftmo_risk_ladder_12_consecutive_sl_reached" in SOURCE
    assert "GlobalVariableSet(balance_key,balance)==0" in SOURCE


def test_signal_endpoint_is_200_with_no_signal_and_unknown_path_is_404(tmp_path):
    app = create_app({"TESTING": True, "SIGNAL_FILE": str(tmp_path / "no_signal.json")})
    client = app.test_client()
    response = client.get("/api/signals/latest?symbol=XAUUSD")
    assert response.status_code == 200
    assert response.get_json() == {"status": "ok", "signal": None}
    assert client.get("/api/signals/not-found").status_code == 404


def test_mql_preflight_treats_non_200_and_transport_failure_as_blocked():
    assert "if(res == 200)" in SOURCE
    assert "WebRequest error: latest signal API request failed" in SOURCE
    assert "WebRequestTimeoutMs" in SOURCE
