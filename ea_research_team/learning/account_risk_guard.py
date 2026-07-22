"""Hard pre-trade risk checks for personal, FTMO 2-Step, and Topstep accounts."""
from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime
import os
from zoneinfo import ZoneInfo


@dataclass(frozen=True)
class RiskDecision:
    allowed: bool
    reason: str
    daily_remaining: float | None = None
    max_remaining: float | None = None


def _float(name: str, default: float = 0.0) -> float:
    try:
        return float(os.getenv(name, default))
    except ValueError:
        return default


def evaluate_mt5_account(*, balance: float, equity: float, expected_login: str = "") -> RiskDecision:
    """Evaluate the selected MT5 profile. Inputs must include floating P/L, swaps and commissions in equity."""
    profile = os.getenv("ACCOUNT_RISK_PROFILE", "PERSONAL").strip().upper()
    initial = _float("RISK_INITIAL_BALANCE", balance)
    buffer_pct = _float("RISK_SAFETY_BUFFER_PCT", 20.0) / 100.0
    if initial <= 0 or equity <= 0:
        return RiskDecision(False, "invalid_account_snapshot")
    if profile == "FTMO_2STEP":
        reset_balance = _float("FTMO_DAILY_RESET_BALANCE", balance)
        daily_floor = reset_balance - initial * 0.05
        max_floor = initial * 0.90
        daily_remaining, max_remaining = equity - daily_floor, equity - max_floor
        hard_remaining = min(daily_remaining, max_remaining)
        buffer = initial * 0.05 * buffer_pct
        if hard_remaining <= 0:
            return RiskDecision(False, "ftmo_loss_limit_reached", daily_remaining, max_remaining)
        if hard_remaining <= buffer:
            return RiskDecision(False, "ftmo_safety_buffer_reached", daily_remaining, max_remaining)
        return RiskDecision(True, "ftmo_risk_ok", daily_remaining, max_remaining)
    if profile == "PERSONAL":
        floor = _float("PERSONAL_EQUITY_FLOOR", 0.0)
        remaining = equity - floor if floor else None
        return RiskDecision(floor <= 0 or equity > floor, "personal_risk_ok" if floor <= 0 or equity > floor else "personal_equity_floor_reached", remaining, remaining)
    return RiskDecision(False, f"unsupported_mt5_profile:{profile}")


def evaluate_topstep(*, equity: float, mll_floor: float, requested_contracts: int, max_contracts: int,
                     now: datetime | None = None) -> RiskDecision:
    """Topstep guard: hard trailing MLL, contract cap, and 15:10 CT flatten window."""
    now = now or datetime.now(ZoneInfo("America/Chicago"))
    remaining = equity - mll_floor
    if requested_contracts > max_contracts:
        return RiskDecision(False, "topstep_contract_limit", None, remaining)
    if remaining <= 0:
        return RiskDecision(False, "topstep_mll_reached", None, remaining)
    if now.hour == 15 and now.minute >= 10:
        return RiskDecision(False, "topstep_market_close_window", None, remaining)
    return RiskDecision(True, "topstep_risk_ok", None, remaining)
