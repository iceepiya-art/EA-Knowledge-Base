"""Static contract tests for the MasterEA account-profile safety inputs."""
from pathlib import Path


SOURCE = Path(__file__).resolve().parents[2] / "artifacts" / "generated_ea" / "MasterEA_v3.mq5"


def test_masterea_has_account_lock_and_profiles():
    text = SOURCE.read_text(encoding="utf-8")
    assert "ENUM_ACCOUNT_RISK_PROFILE" in text
    assert "ExpectedAccountLogin" in text
    assert "ACCOUNT_PROFILE_FTMO_2STEP" in text
    assert "ACCOUNT_PROFILE_TOPSTEP" in text
    assert "CanOpenNewTrade" in text


def test_masterea_fails_closed_for_unconfigured_ftmo_and_topstep_mt5_routing():
    text = SOURCE.read_text(encoding="utf-8")
    assert "ftmo_profile_not_configured" in text
    assert "topstep_profile_requires_topstepx_api_guard" in text
    assert "Signal rejected: account risk guard" in text
