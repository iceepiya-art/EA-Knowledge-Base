"""JSON store for prop trading business accounts and costs."""
from __future__ import annotations

from datetime import datetime
import json
import os
from uuid import uuid4


DATA_FILE = os.path.join(os.path.dirname(__file__), "prop_business_accounts.json")


def _load() -> list[dict]:
    if not os.path.exists(DATA_FILE):
        return []
    try:
        with open(DATA_FILE, "r", encoding="utf-8") as fh:
            data = json.load(fh)
        return data if isinstance(data, list) else []
    except (json.JSONDecodeError, OSError):
        return []


def _save(accounts: list[dict]) -> None:
    with open(DATA_FILE, "w", encoding="utf-8") as fh:
        json.dump(accounts, fh, ensure_ascii=False, indent=2)


def _to_float(value: str) -> float:
    try:
        return float(str(value or "0").replace(",", ""))
    except ValueError:
        return 0.0


def add_account(form: dict) -> dict:
    monthly_cost = _to_float(form.get("monthly_cost", ""))
    payouts = _to_float(form.get("payouts", ""))
    other_costs = _to_float(form.get("other_costs", ""))
    net_profit = payouts - monthly_cost - other_costs
    invested = monthly_cost + other_costs
    roi = round((net_profit / invested) * 100, 1) if invested else 0.0

    account = {
        "id": uuid4().hex[:10],
        "created_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "platform": (form.get("platform") or "").strip(),
        "account_name": (form.get("account_name") or "").strip(),
        "account_size": (form.get("account_size") or "").strip(),
        "phase": (form.get("phase") or "").strip(),
        "status": (form.get("status") or "").strip(),
        "monthly_cost": monthly_cost,
        "other_costs": other_costs,
        "payouts": payouts,
        "net_profit": round(net_profit, 2),
        "roi": roi,
        "daily_loss_rule": (form.get("daily_loss_rule") or "").strip(),
        "max_loss_rule": (form.get("max_loss_rule") or "").strip(),
        "consistency_rule": (form.get("consistency_rule") or "").strip(),
        "copy_trade_plan": (form.get("copy_trade_plan") or "").strip(),
        "single_point_risk": (form.get("single_point_risk") or "").strip(),
        "platform_risk": (form.get("platform_risk") or "").strip(),
        "discipline_rule": (form.get("discipline_rule") or "").strip(),
        "notes": (form.get("notes") or "").strip(),
    }
    if not account["account_name"]:
        account["account_name"] = f"{account['platform'] or 'Prop'} {account['account_size'] or 'Account'}"

    accounts = _load()
    accounts.insert(0, account)
    _save(accounts)
    return account


def recent_accounts(limit: int = 6) -> list[dict]:
    return _load()[:limit]


def stats() -> dict:
    accounts = _load()
    total = len(accounts)
    active = sum(1 for account in accounts if account.get("status") in ("ACTIVE", "EVALUATION", "FUNDED"))
    funded = sum(1 for account in accounts if account.get("status") == "FUNDED")
    total_cost = round(sum(account.get("monthly_cost", 0) + account.get("other_costs", 0) for account in accounts), 2)
    total_payouts = round(sum(account.get("payouts", 0) for account in accounts), 2)
    net_profit = round(sum(account.get("net_profit", 0) for account in accounts), 2)
    roi = round((net_profit / total_cost) * 100, 1) if total_cost else 0.0
    return {
        "total": total,
        "active": active,
        "funded": funded,
        "total_cost": total_cost,
        "total_payouts": total_payouts,
        "net_profit": net_profit,
        "roi": roi,
    }
