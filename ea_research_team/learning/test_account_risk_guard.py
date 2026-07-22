from datetime import datetime
from pathlib import Path
from account_risk_guard import evaluate_mt5_account, evaluate_topstep


def test_ftmo_blocks_at_safety_buffer(monkeypatch):
    monkeypatch.setenv("ACCOUNT_RISK_PROFILE", "FTMO_2STEP")
    monkeypatch.setenv("RISK_INITIAL_BALANCE", "100000")
    monkeypatch.setenv("FTMO_DAILY_RESET_BALANCE", "103000")
    monkeypatch.setenv("RISK_SAFETY_BUFFER_PCT", "20")
    decision = evaluate_mt5_account(balance=103000, equity=99000)
    assert not decision.allowed
    assert decision.reason == "ftmo_safety_buffer_reached"


def test_topstep_blocks_contracts_and_close_window():
    assert not evaluate_topstep(equity=100000, mll_floor=97000, requested_contracts=11, max_contracts=10).allowed
    assert not evaluate_topstep(equity=100000, mll_floor=97000, requested_contracts=1, max_contracts=10, now=datetime(2026, 7, 22, 15, 10)).allowed


def test_topstep_allows_only_before_close_with_mll_headroom():
    decision = evaluate_topstep(equity=100000, mll_floor=97000, requested_contracts=2, max_contracts=10, now=datetime(2026, 7, 22, 14, 30))
    assert decision.allowed
    assert decision.max_remaining == 3000


def test_account_locked_launcher_prompts_for_account_and_profile():
    text = (Path(__file__).resolve().parents[2] / "RUN_TRADING_WITH_ACCOUNT_LOCK.bat").read_text(encoding="utf-8")
    assert "EXPECTED_MT5_ACCOUNT" in text
    assert "ACCOUNT_RISK_PROFILE" in text
    assert "FTMO_DAILY_RESET_BALANCE" in text
    assert "TOPSTEP_MLL_FLOOR" in text
