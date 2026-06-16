"""
EA data layer — JSON stores, CRUD helpers, folder scanner, decision board.
No Flask imports.
"""
from datetime import datetime
import json
import os
import re
import subprocess
import zipfile

import job_log
from ea_parsers import _read_file_autoenc

EA_REGISTRY_PATH = os.path.join(os.path.dirname(__file__), "ea_registry.json")
EA_BACKTEST_PATH = os.path.join(os.path.dirname(__file__), "ea_backtests.json")
EA_BACKTEST_UPLOAD_DIR = os.path.join(os.path.dirname(__file__), "ea_backtest_uploads")
EA_CHECKLIST_PATH = os.path.join(os.path.dirname(__file__), "ea_checklists.json")
EA_NOTES_PATH = os.path.join(os.path.dirname(__file__), "ea_notes.json")
EA_CUSTOMERS_PATH = os.path.join(os.path.dirname(__file__), "ea_customers.json")
EA_CUSTOMER_PACKAGE_DIR = os.path.join(os.path.dirname(__file__), "ea_customer_packages")
METAEDITOR_CANDIDATES = [
    r"C:\Program Files\MetaTrader 5\metaeditor64.exe",
    r"C:\Program Files (x86)\MetaTrader 5\metaeditor64.exe",
]
EA_LOCK_TYPE_LABELS = {
    "monthly_account_locked": ("LOCK + EXPIRY", "#4dd0ff", "Lock account number + set expiry date"),
    "lifetime_one_account":   ("LOCK LIFETIME", "#7bffb2", "Lock account number + no expiry"),
    "lifetime_unlimited":     ("NO LOCK",        "#ffd166", "No account lock, runs on any account"),
    "developer_source_package": ("SOURCE PKG",  "#c084fc", "Full source code delivery, no lock"),
}
EA_NOTE_FIELDS = [
    ("strategy_thesis", "Strategy Thesis", "What edge is this EA/indicator trying to exploit?"),
    ("best_market", "Best Market", "Best symbol, timeframe, session, regime, or volatility condition."),
    ("no_trade_conditions", "No-Trade Conditions", "When should this system not be used?"),
    ("risk_model", "Risk Model", "Recommended risk, max exposure, SL/TP logic, and account rules."),
    ("customer_promise", "Customer Promise", "What can be honestly promised to customers?"),
    ("support_rules", "Support Rules", "Setup call, update policy, troubleshooting, and refund boundaries."),
]
EA_MANUAL_CHECKLIST = [
    ("compile_checked", "Compile checked", "EA/Pine compiles without errors on the target platform."),
    ("default_settings_checked", "Default settings checked", "Inputs/settings are safe enough for first customer use."),
    ("risk_limits_checked", "Risk limits checked", "Lot sizing, max DD, stop conditions, and no-go conditions are defined."),
    ("license_checked", "License checked", "Key/account-lock/invite-only access is prepared for delivery."),
    ("package_created", "Package created", "Customer ZIP or delivery folder is ready."),
    ("guide_created", "Guide created", "Install guide, setup steps, and usage rules are written."),
    ("setup_call_ready", "Setup call ready", "You can onboard a buyer without improvising every step."),
    ("proof_ready", "Proof ready", "Backtest/forward-test proof is ready to show honestly."),
]
EA_PACKAGE_TYPES = [
    ("monthly_account_locked", "Monthly account-locked"),
    ("lifetime_one_account", "Lifetime 1 account"),
    ("lifetime_unlimited", "Lifetime unlimited"),
    ("developer_source_package", "Developer source package"),
]
EA_PRICE_PRESETS = [
    {
        "id": "monthly",
        "title": "Monthly",
        "subtitle": "1 port / 1 month",
        "package_type": "monthly_account_locked",
        "amount": "3900",
        "duration_days": 30,
        "badge": "STARTER",
        "note": "Account-locked monthly access. Good for first paid use.",
    },
    {
        "id": "three_months",
        "title": "3 Months Promo",
        "subtitle": "1 port / 3 months",
        "package_type": "monthly_account_locked",
        "amount": "7900",
        "duration_days": 90,
        "badge": "PROMO",
        "note": "Better value than monthly while still keeping expiry control.",
    },
    {
        "id": "lifetime_one_port",
        "title": "Lifetime 1 Port",
        "subtitle": "Best seller",
        "package_type": "lifetime_one_account",
        "amount": "14900",
        "duration_days": 0,
        "badge": "BEST SELLER",
        "note": "Lifetime access locked to one account/port.",
    },
    {
        "id": "unlimited",
        "title": "Unlimited Version",
        "subtitle": "No account limit",
        "package_type": "lifetime_unlimited",
        "amount": "29900",
        "duration_days": 0,
        "badge": "BEST VALUE",
        "note": "Lifetime access without account lock for serious users.",
    },
    {
        "id": "developer_mql",
        "title": "MQL Source Code",
        "subtitle": "Developer package",
        "package_type": "developer_source_package",
        "amount": "79000",
        "duration_days": 0,
        "badge": "SOURCE",
        "note": "Source-code package for developers who want to customize.",
    },
]
EA_CUSTOMER_STATUSES = [
    "Lead",
    "Pending Payment",
    "Paid",
    "Setup Done",
    "Support",
    "Expired",
]

EA_CATALOG = [
    {
        "id": "gold_breakout",
        "name": "Gold Breakout 100Bar Survivor",
        "icon": "XAU",
        "kind": "MT5 EA",
        "market": "XAUUSD",
        "stage": "Forward / product candidate",
        "path": r"C:\Users\ADMIN\Desktop\11.Gold_Breakout_100Bar_Survivor\Gold_Breakout_100Bar_Survivor_fix5",
        "focus": "Breakout logic for gold, survivor/risk-control style.",
        "next": "Check backtest, forward results, risk rules, and customer readiness.",
        "accent": "#f7c948",
    },
    {
        "id": "hedgegrid",
        "name": "HedgeGrid Manual V23",
        "icon": "GRID",
        "kind": "MT5 EA",
        "market": "Manual / grid hedge",
        "stage": "Research / risk review",
        "path": r"C:\Users\ADMIN\Desktop\9.1 HedgeGrid_Manual_V16_Final_AUTO_DEMO\HedgeGrid_V23_fix12",
        "focus": "Manual hedge/grid workflow, needs strict drawdown and exposure controls.",
        "next": "Document safe use cases, max exposure, and no-go market conditions.",
        "accent": "#8b5cf6",
    },
    {
        "id": "smc_universal",
        "name": "SMC Universal EA",
        "icon": "SMC",
        "kind": "MT5 EA",
        "market": "Multi-symbol SMC",
        "stage": "Strategy development",
        "path": r"C:\Users\ADMIN\Desktop\12.SMC_System\SMC_Universal_EA_v3_0_fix17",
        "focus": "Smart Money Concepts logic, structure/FVG/OB candidate.",
        "next": "Compare with backend SMC analyzer and Ninja/CME confluence.",
        "accent": "#22d3ee",
    },
    {
        "id": "mmf",
        "name": "MakeMoneyFarmed MMF v316",
        "icon": "MMF",
        "kind": "MT5 EA",
        "market": "Portfolio / farming",
        "stage": "Ready-to-run review",
        "path": r"C:\Users\ADMIN\Desktop\13.MakeMoneyFarmed_v3\MMF_v316_fix18_ReadyToRun",
        "focus": "Ready-to-run EA package, needs product QA and user safety limits.",
        "next": "Verify defaults, account protection, installer/package notes.",
        "accent": "#7bffb2",
    },
    {
        "id": "fibo_engulfing",
        "name": "Fibo Engulfing EA",
        "icon": "FIB",
        "kind": "MT5 EA",
        "market": "Pattern strategy",
        "stage": "Research / backtest",
        "path": r"C:\Users\ADMIN\Desktop\Fibo_Engulfing_EA",
        "focus": "Fibonacci + engulfing setup engine.",
        "next": "Run structured backtest and classify best sessions/regimes.",
        "accent": "#fb7185",
    },
    {
        "id": "cme_alphaedge",
        "name": "CME / AlphaEdge SMC Pro",
        "icon": "CME",
        "kind": "TradingView Indicator",
        "market": "GC / NQ / Prop futures",
        "stage": "Customer package ready",
        "path": r"C:\Users\ADMIN\Desktop\CME",
        "focus": "CME option levels + SMC + risk panel + customer package.",
        "next": "Compile Pine in TradingView, then test customer delivery flow.",
        "accent": "#4dd0ff",
    },
]


def _safe_ea_catalog() -> dict[str, dict]:
    return {ea["id"]: ea for ea in _get_ea_catalog()}


def _ea_slug(value: str) -> str:
    cleaned = []
    for ch in (value or "").strip().lower():
        if ch.isalnum():
            cleaned.append(ch)
        elif ch in [" ", "-", "_", ".", "/"]:
            cleaned.append("_")
    slug = "".join(cleaned).strip("_")
    while "__" in slug:
        slug = slug.replace("__", "_")
    return slug or "ea_project"


def _normalize_ea_record(raw: dict, existing_ids: set[str] | None = None) -> dict:
    existing_ids = existing_ids or set()
    name = (raw.get("name") or "Untitled EA").strip()
    base_id = _ea_slug(raw.get("id") or name)
    ea_id = base_id
    idx = 2
    while ea_id in existing_ids:
        ea_id = f"{base_id}_{idx}"
        idx += 1
    return {
        "id": ea_id,
        "name": name,
        "icon": (raw.get("icon") or "EA").strip()[:8],
        "kind": (raw.get("kind") or "MT5 EA").strip(),
        "market": (raw.get("market") or "XAUUSD").strip(),
        "stage": (raw.get("stage") or "Research").strip(),
        "path": (raw.get("path") or "").strip(),
        "focus": (raw.get("focus") or "Describe what this EA/indicator is designed to do.").strip(),
        "next": (raw.get("next") or "Add source, backtest, forward test, package, and sales notes.").strip(),
        "accent": (raw.get("accent") or "#4dd0ff").strip(),
    }


def _write_ea_catalog(items: list[dict]) -> None:
    with open(EA_REGISTRY_PATH, "w", encoding="utf-8") as f:
        json.dump(items, f, ensure_ascii=False, indent=2)


def _read_json_file(path: str, default):
    if not os.path.exists(path):
        return default
    try:
        with open(path, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return default


def _write_json_file(path: str, data) -> None:
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)


def _get_ea_catalog() -> list[dict]:
    if not os.path.exists(EA_REGISTRY_PATH):
        _write_ea_catalog(EA_CATALOG)
        return list(EA_CATALOG)
    try:
        with open(EA_REGISTRY_PATH, "r", encoding="utf-8") as f:
            raw = json.load(f)
    except Exception as exc:
        job_log.append("ea_registry_error", f"Using defaults: {exc}", "error")
        return list(EA_CATALOG)
    if not isinstance(raw, list):
        return list(EA_CATALOG)
    items = []
    seen = set()
    for rec in raw:
        if not isinstance(rec, dict):
            continue
        if rec.get("archived"):
            continue
        normalized = _normalize_ea_record(rec, seen)
        seen.add(normalized["id"])
        items.append(normalized)
    return items or list(EA_CATALOG)


def _get_ea_backtests(ea_id: str) -> list[dict]:
    data = _read_json_file(EA_BACKTEST_PATH, {})
    if not isinstance(data, dict):
        return []
    rows = data.get(ea_id, [])
    return rows if isinstance(rows, list) else []


def _save_ea_backtest(ea_id: str, report: dict) -> None:
    data = _read_json_file(EA_BACKTEST_PATH, {})
    if not isinstance(data, dict):
        data = {}
    rows = data.get(ea_id, [])
    if not isinstance(rows, list):
        rows = []
    rows.insert(0, report)
    data[ea_id] = rows[:30]
    _write_json_file(EA_BACKTEST_PATH, data)


def _get_ea_checklist(ea_id: str) -> dict:
    data = _read_json_file(EA_CHECKLIST_PATH, {})
    if not isinstance(data, dict):
        data = {}
    raw = data.get(ea_id, {})
    if not isinstance(raw, dict):
        raw = {}
    checks = raw.get("checks", {})
    if not isinstance(checks, dict):
        checks = {}
    normalized = {key: bool(checks.get(key)) for key, _label, _note in EA_MANUAL_CHECKLIST}
    return {
        "checks": normalized,
        "notes": raw.get("notes", "") if isinstance(raw.get("notes", ""), str) else "",
        "updated_at": raw.get("updated_at", "") if isinstance(raw.get("updated_at", ""), str) else "",
    }


def _save_ea_checklist(ea_id: str, form_data) -> dict:
    data = _read_json_file(EA_CHECKLIST_PATH, {})
    if not isinstance(data, dict):
        data = {}
    checks = {key: (form_data.get(key) == "on") for key, _label, _note in EA_MANUAL_CHECKLIST}
    record = {
        "checks": checks,
        "notes": (form_data.get("notes") or "").strip(),
        "updated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    }
    data[ea_id] = record
    _write_json_file(EA_CHECKLIST_PATH, data)
    return record


def _get_ea_notes(ea_id: str) -> dict:
    data = _read_json_file(EA_NOTES_PATH, {})
    if not isinstance(data, dict):
        data = {}
    raw = data.get(ea_id, {})
    if not isinstance(raw, dict):
        raw = {}
    notes = {key: raw.get(key, "") if isinstance(raw.get(key, ""), str) else "" for key, _label, _hint in EA_NOTE_FIELDS}
    notes["updated_at"] = raw.get("updated_at", "") if isinstance(raw.get("updated_at", ""), str) else ""
    return notes


def _save_ea_notes(ea_id: str, form_data) -> dict:
    data = _read_json_file(EA_NOTES_PATH, {})
    if not isinstance(data, dict):
        data = {}
    record = {key: (form_data.get(key) or "").strip() for key, _label, _hint in EA_NOTE_FIELDS}
    record["updated_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    data[ea_id] = record
    _write_json_file(EA_NOTES_PATH, data)
    return record


def _get_ea_customers(ea_id: str) -> list[dict]:
    data = _read_json_file(EA_CUSTOMERS_PATH, {})
    if not isinstance(data, dict):
        return []
    rows = data.get(ea_id, [])
    if not isinstance(rows, list):
        return []
    return [row for row in rows if isinstance(row, dict) and not row.get("archived")]


def _ea_customer_pipeline(catalog: list[dict]) -> dict:
    rows = []
    status_counts = {status: 0 for status in EA_CUSTOMER_STATUSES}
    package_counts = {key: 0 for key, _label in EA_PACKAGE_TYPES}
    totals = {
        "leads": 0,
        "paid": 0,
        "packages": 0,
        "zips": 0,
        "file_sent": 0,
        "key_sent": 0,
        "ready_delivery": 0,
        "amount": 0.0,
    }
    for ea in catalog:
        customers = _get_ea_customers(ea["id"])
        if not customers:
            continue
        ea_total = {
            "ea": ea,
            "customers": len(customers),
            "paid": 0,
            "packages": 0,
            "zips": 0,
            "delivery_done": 0,
            "amount": 0.0,
        }
        for customer in customers:
            status = customer.get("payment_status") or "Lead"
            if status in status_counts:
                status_counts[status] += 1
            package_type = customer.get("package_type") or EA_PACKAGE_TYPES[0][0]
            if package_type in package_counts:
                package_counts[package_type] += 1
            totals["leads"] += 1
            if status == "Paid":
                totals["paid"] += 1
                ea_total["paid"] += 1
            if customer.get("package_path"):
                totals["packages"] += 1
                ea_total["packages"] += 1
            if customer.get("zip_path"):
                totals["zips"] += 1
                ea_total["zips"] += 1
            checks = customer.get("delivery_checks", {})
            file_sent = bool(checks.get("file_sent"))
            key_sent = bool(checks.get("key_sent"))
            if file_sent:
                totals["file_sent"] += 1
            if key_sent:
                totals["key_sent"] += 1
            if file_sent and key_sent:
                totals["ready_delivery"] += 1
                ea_total["delivery_done"] += 1
            try:
                amount = float(str(customer.get("amount") or "0").replace(",", "").strip() or 0)
            except ValueError:
                amount = 0.0
            totals["amount"] += amount
            ea_total["amount"] += amount
        rows.append(ea_total)
    rows.sort(key=lambda item: (item["paid"], item["customers"], item["amount"]), reverse=True)
    return {
        "totals": totals,
        "status_counts": status_counts,
        "package_counts": package_counts,
        "rows": rows,
    }


def _generate_license_key(ea_id: str, buyer_name: str = "") -> str:
    prefix = re.sub(r"[^A-Z0-9]+", "", (ea_id or "EA").upper())[:10] or "EA"
    buyer = re.sub(r"[^A-Z0-9]+", "", (buyer_name or "CLIENT").upper())[:6] or "CLIENT"
    stamp = datetime.now().strftime("%y%m%d%H%M%S")
    return f"{prefix}-{buyer}-{stamp}"


def _save_ea_customer(ea_id: str, form_data) -> dict:
    data = _read_json_file(EA_CUSTOMERS_PATH, {})
    if not isinstance(data, dict):
        data = {}
    rows = data.get(ea_id, [])
    if not isinstance(rows, list):
        rows = []

    buyer_name = (form_data.get("buyer_name") or "").strip()
    package_type = (form_data.get("package_type") or EA_PACKAGE_TYPES[0][0]).strip()
    valid_package_types = {key for key, _label in EA_PACKAGE_TYPES}
    if package_type not in valid_package_types:
        package_type = EA_PACKAGE_TYPES[0][0]

    payment_status = (form_data.get("payment_status") or "Lead").strip()
    if payment_status not in EA_CUSTOMER_STATUSES:
        payment_status = "Lead"

    record = {
        "id": datetime.now().strftime("%Y%m%d%H%M%S%f"),
        "buyer_name": buyer_name or "Unnamed lead",
        "contact": (form_data.get("contact") or "").strip(),
        "package_type": package_type,
        "account_number": (form_data.get("account_number") or "").strip(),
        "license_key": (form_data.get("license_key") or "").strip() or _generate_license_key(ea_id, buyer_name),
        "payment_status": payment_status,
        "amount": (form_data.get("amount") or "").strip(),
        "expires_at": (form_data.get("expires_at") or "").strip(),
        "notes": (form_data.get("notes") or "").strip(),
        "created_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "updated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    }
    rows.insert(0, record)
    data[ea_id] = rows[:200]
    _write_json_file(EA_CUSTOMERS_PATH, data)
    return record


def _update_ea_customer(ea_id: str, customer_id: str, form_data) -> dict | None:
    data = _read_json_file(EA_CUSTOMERS_PATH, {})
    if not isinstance(data, dict):
        return None
    rows = data.get(ea_id, [])
    if not isinstance(rows, list):
        return None

    valid_package_types = {key for key, _label in EA_PACKAGE_TYPES}
    action = (form_data.get("action") or "update").strip()
    for row in rows:
        if not isinstance(row, dict) or row.get("id") != customer_id:
            continue
        if action == "archive":
            row["archived"] = True
            row["archived_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        else:
            row["buyer_name"] = (form_data.get("buyer_name") or row.get("buyer_name") or "Unnamed lead").strip()
            row["contact"] = (form_data.get("contact") or "").strip()
            package_type = (form_data.get("package_type") or row.get("package_type") or EA_PACKAGE_TYPES[0][0]).strip()
            row["package_type"] = package_type if package_type in valid_package_types else EA_PACKAGE_TYPES[0][0]
            payment_status = (form_data.get("payment_status") or row.get("payment_status") or "Lead").strip()
            row["payment_status"] = payment_status if payment_status in EA_CUSTOMER_STATUSES else "Lead"
            row["account_number"] = (form_data.get("account_number") or "").strip()
            row["license_key"] = (form_data.get("license_key") or row.get("license_key") or "").strip() or _generate_license_key(ea_id, row["buyer_name"])
            row["amount"] = (form_data.get("amount") or "").strip()
            row["expires_at"] = (form_data.get("expires_at") or "").strip()
            row["notes"] = (form_data.get("notes") or "").strip()
        row["updated_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        _write_json_file(EA_CUSTOMERS_PATH, data)
        return row
    return None


def _find_ea_customer(ea_id: str, customer_id: str) -> dict | None:
    data = _read_json_file(EA_CUSTOMERS_PATH, {})
    if not isinstance(data, dict):
        return None
    rows = data.get(ea_id, [])
    if not isinstance(rows, list):
        return None
    for row in rows:
        if isinstance(row, dict) and row.get("id") == customer_id:
            return row
    return None


def _mark_customer_package(ea_id: str, customer_id: str, package_path: str) -> None:
    data = _read_json_file(EA_CUSTOMERS_PATH, {})
    if not isinstance(data, dict):
        return
    rows = data.get(ea_id, [])
    if not isinstance(rows, list):
        return
    for row in rows:
        if isinstance(row, dict) and row.get("id") == customer_id:
            row["package_path"] = package_path
            row["package_generated_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            row["updated_at"] = row["package_generated_at"]
            _write_json_file(EA_CUSTOMERS_PATH, data)
            return


def _update_customer_delivery(ea_id: str, customer_id: str, form_data) -> dict | None:
    data = _read_json_file(EA_CUSTOMERS_PATH, {})
    if not isinstance(data, dict):
        return None
    rows = data.get(ea_id, [])
    if not isinstance(rows, list):
        return None
    for row in rows:
        if not isinstance(row, dict) or row.get("id") != customer_id:
            continue
        row["delivery_checks"] = {
            "file_sent": form_data.get("file_sent") == "on",
            "key_sent": form_data.get("key_sent") == "on",
        }
        row["updated_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        _write_json_file(EA_CUSTOMERS_PATH, data)
        return row
    return None


def _write_text_file(path: str, content: str) -> None:
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="\n") as f:
        f.write(content.strip() + "\n")


def _generate_customer_package(ea: dict, customer: dict) -> str:
    package_labels = dict(EA_PACKAGE_TYPES)
    safe_ea = _ea_slug(ea.get("id") or ea.get("name") or "ea")
    safe_customer = _ea_slug(customer.get("buyer_name") or customer.get("id") or "customer")
    stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    out_dir = os.path.join(EA_CUSTOMER_PACKAGE_DIR, safe_ea, f"{stamp}_{safe_customer}")
    os.makedirs(out_dir, exist_ok=True)

    package_label = package_labels.get(customer.get("package_type", ""), customer.get("package_type", ""))
    created_at = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    license_key = customer.get("license_key", "") or _generate_license_key(ea["id"], customer.get("buyer_name", ""))

    license_doc = f"""
# License Delivery

Created: {created_at}

## Customer

- Name: {customer.get("buyer_name", "")}
- Contact: {customer.get("contact", "")}
- Product: {ea.get("name", "")}
- Package: {package_label}
- Payment status: {customer.get("payment_status", "")}
- Amount: {customer.get("amount", "")}
- Account lock: {customer.get("account_number", "") or "Not locked / not set"}
- Expiry: {customer.get("expires_at", "") or "No expiry set"}

## License Key

```text
{license_key}
```

## Admin Notes

{customer.get("notes", "") or "-"}
"""
    guide_doc = f"""
# Customer Setup Guide

Product: {ea.get("name", "")}

## Before Installing

1. Confirm platform version and broker account.
2. Confirm account number if this package is account-locked.
3. Confirm customer understands risk and no-profit-guarantee boundaries.
4. Send only the correct file for this package type.

## Suggested Setup Call Script

1. Ask customer to open MT5 or TradingView.
2. Install the EA/indicator together.
3. Apply recommended default settings.
4. Explain risk settings and what not to change.
5. Show how to remove/disable the system.
6. Confirm customer can see the signal/status panel.

## Product Notes

- Focus: {ea.get("focus", "")}
- Best market/stage: {ea.get("market", "")} / {ea.get("stage", "")}
- Next internal action: {ea.get("next", "")}
"""
    support_doc = f"""
# Support And Delivery Message

## Message To Customer

สวัสดีครับ คุณ {customer.get("buyer_name", "")}

ผมเตรียมแพ็กเกจ {ea.get("name", "")} ให้แล้วครับ

ข้อมูลสำคัญ:
- Package: {package_label}
- License Key: {license_key}
- Account Lock: {customer.get("account_number", "") or "ไม่ล็อค / ยังไม่ได้ระบุ"}
- Expiry: {customer.get("expires_at", "") or "ไม่จำกัด / ยังไม่ได้ระบุ"}

ก่อนใช้งานจริง แนะนำให้ติดตั้งและทดสอบในบัญชี demo หรือ lot ต่ำก่อนทุกครั้งนะครับ
ระบบนี้เป็นเครื่องมือช่วยเทรด/ช่วยตัดสินใจ ไม่ใช่การการันตีกำไร

## Support Checklist

- [ ] Customer received file/package
- [ ] Customer received license key
- [ ] Setup call scheduled
- [ ] Installation completed
- [ ] Default settings explained
- [ ] Risk settings explained
- [ ] Customer confirmed system is visible/running
"""

    _write_text_file(os.path.join(out_dir, "LICENSE_DELIVERY.md"), license_doc)
    _write_text_file(os.path.join(out_dir, "CUSTOMER_SETUP_GUIDE.md"), guide_doc)
    _write_text_file(os.path.join(out_dir, "SUPPORT_MESSAGE.md"), support_doc)
    _mark_customer_package(ea["id"], customer["id"], out_dir)
    return out_dir


def _create_customer_zip(ea: dict, customer: dict) -> str:
    package_path = customer.get("package_path") or ""
    if not package_path or not os.path.isdir(package_path):
        package_path = _generate_customer_package(ea, customer)
        customer = _find_ea_customer(ea["id"], customer["id"]) or customer

    zip_path = f"{package_path}.zip"
    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for root, _dirs, files in os.walk(package_path):
            for filename in files:
                full_path = os.path.join(root, filename)
                rel_path = os.path.relpath(full_path, package_path)
                zf.write(full_path, rel_path)
        build_mq5 = customer.get("build_mq5_path") or ""
        if build_mq5:
            build_dir = os.path.dirname(build_mq5)
            for fname in os.listdir(build_dir) if os.path.isdir(build_dir) else []:
                if fname.lower().endswith((".ex5", ".mq5")):
                    zf.write(os.path.join(build_dir, fname), fname)

    data = _read_json_file(EA_CUSTOMERS_PATH, {})
    if isinstance(data, dict):
        rows = data.get(ea["id"], [])
        if isinstance(rows, list):
            for row in rows:
                if isinstance(row, dict) and row.get("id") == customer.get("id"):
                    row["zip_path"] = zip_path
                    row["zip_created_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                    row["updated_at"] = row["zip_created_at"]
                    _write_json_file(EA_CUSTOMERS_PATH, data)
                    break
    return zip_path


def _find_metaeditor() -> str:
    for p in METAEDITOR_CANDIDATES:
        if os.path.exists(p):
            return p
    return ""


def _find_ea_main_mq5(ea: dict) -> str:
    folder = ea.get("path", "")
    if not folder or not os.path.isdir(folder):
        return ""
    lockable, others = [], []
    for fname in os.listdir(folder):
        if not fname.lower().endswith(".mq5"):
            continue
        fpath = os.path.join(folder, fname)
        try:
            if "INTERNAL_ACCOUNT_LOCK" in _read_file_autoenc(fpath):
                lockable.append(fpath)
            else:
                others.append(fpath)
        except Exception:
            others.append(fpath)
    return (lockable + others)[0] if (lockable or others) else ""


def _patch_mq5_for_customer(source_path: str, customer: dict, dest_path: str) -> None:
    content = _read_file_autoenc(source_path)
    package_type = customer.get("package_type", "")
    account_num = (customer.get("account_number") or "0").strip() or "0"
    expires_raw = (customer.get("expires_at") or "").strip()

    if package_type == "lifetime_unlimited":
        account_num = "0"
        expiry_mql = "D'2126.12.31 23:59'"
    elif package_type == "lifetime_one_account":
        expiry_mql = "D'2126.12.31 23:59'"
    else:
        if expires_raw and re.match(r"\d{4}-\d{2}-\d{2}", expires_raw):
            expiry_mql = f"D'{expires_raw.replace('-', '.')} 23:59'"
        else:
            expiry_mql = "D'2126.12.31 23:59'"

    patched = re.sub(
        r"((?:(?:const|input)\s+)?(?:int|long)\s+INTERNAL_ACCOUNT_LOCK\s*=\s*)\d+",
        lambda m: f"{m.group(1)}{account_num}",
        content,
    )
    patched = re.sub(
        r"((?:(?:const|input)\s+)?datetime\s+INTERNAL_EXPIRY\s*=\s*)D'[^']*'",
        lambda m: f"{m.group(1)}{expiry_mql}",
        patched,
    )
    if package_type in ("monthly_account_locked", "lifetime_one_account"):
        patched = re.sub(
            r"((?:(?:const|input)\s+)?bool\s+INTERNAL_LOCK_DEMO\s*=\s*)(?:true|false)",
            lambda m: f"{m.group(1)}false",
            patched,
        )

    os.makedirs(os.path.dirname(dest_path), exist_ok=True)
    with open(dest_path, "w", encoding="utf-8", newline="\n") as f:
        f.write(patched)


def _mark_customer_build(ea_id: str, customer_id: str, build_path: str, build_status: str) -> None:
    data = _read_json_file(EA_CUSTOMERS_PATH, {})
    if not isinstance(data, dict):
        return
    rows = data.get(ea_id, [])
    if not isinstance(rows, list):
        return
    for row in rows:
        if isinstance(row, dict) and row.get("id") == customer_id:
            row["build_mq5_path"] = build_path
            row["build_status"] = build_status
            row["build_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            row["updated_at"] = row["build_at"]
            _write_json_file(EA_CUSTOMERS_PATH, data)
            return


def _scan_ea_folder(path: str) -> dict:
    stats = {
        "exists": os.path.exists(path),
        "files": 0,
        "mq": 0,
        "ex": 0,
        "pine": 0,
        "pdf": 0,
        "md": 0,
        "zip": 0,
        "last_file": "",
        "last_modified": "",
        "size_mb": 0.0,
    }
    if not stats["exists"]:
        return stats
    latest_ts = 0.0
    total_size = 0
    for root, _dirs, files in os.walk(path):
        for filename in files:
            full = os.path.join(root, filename)
            try:
                ext = os.path.splitext(filename)[1].lower()
                mtime = os.path.getmtime(full)
                size = os.path.getsize(full)
            except OSError:
                continue
            stats["files"] += 1
            total_size += size
            if ext in [".mq4", ".mq5", ".mqh"]:
                stats["mq"] += 1
            elif ext in [".ex4", ".ex5"]:
                stats["ex"] += 1
            elif ext == ".pine":
                stats["pine"] += 1
            elif ext == ".pdf":
                stats["pdf"] += 1
            elif ext == ".md":
                stats["md"] += 1
            elif ext == ".zip":
                stats["zip"] += 1
            if mtime > latest_ts:
                latest_ts = mtime
                stats["last_file"] = filename
    stats["size_mb"] = round(total_size / (1024 * 1024), 2)
    if latest_ts:
        stats["last_modified"] = datetime.fromtimestamp(latest_ts).strftime("%Y-%m-%d %H:%M")
    return stats


def _ea_file_inventory(path: str, limit: int = 18) -> list[dict]:
    if not os.path.exists(path):
        return []
    interesting = {".mq4", ".mq5", ".mqh", ".ex4", ".ex5", ".pine", ".set", ".ini", ".html", ".htm", ".csv", ".pdf", ".md", ".txt", ".zip"}
    files = []
    for root, _dirs, names in os.walk(path):
        for name in names:
            full = os.path.join(root, name)
            ext = os.path.splitext(name)[1].lower()
            if ext not in interesting:
                continue
            try:
                mtime = os.path.getmtime(full)
                size = os.path.getsize(full)
            except OSError:
                continue
            rel = os.path.relpath(full, path)
            files.append({
                "name": name,
                "rel": rel,
                "ext": ext or "file",
                "size_kb": round(size / 1024, 1),
                "modified": datetime.fromtimestamp(mtime).strftime("%Y-%m-%d %H:%M"),
                "mtime": mtime,
            })
    files.sort(key=lambda item: item["mtime"], reverse=True)
    return files[:limit]


def _ea_health(stats: dict) -> tuple[str, str, str]:
    if not stats["exists"]:
        return "MISSING", "#ff8e7f", "Folder not found"
    if stats["mq"] or stats["pine"]:
        return "SOURCE OK", "#7bffb2", "Source files detected"
    if stats["ex"]:
        return "COMPILED ONLY", "#ffd166", "Compiled files detected, source not found"
    return "NEEDS REVIEW", "#ffb86b", "No EA/indicator source detected"


def _pct(value: int, total: int) -> int:
    if total <= 0:
        return 0
    return int(round((value / total) * 100))


def _ea_decision_snapshot(ea: dict, stats: dict) -> dict:
    checklist = _get_ea_checklist(ea["id"])
    checks = checklist.get("checks", {}) if isinstance(checklist, dict) else {}
    done_checks = sum(1 for value in checks.values() if value)
    total_checks = max(len(EA_MANUAL_CHECKLIST), 1)
    checklist_pct = _pct(done_checks, total_checks)
    backtests = _get_ea_backtests(ea["id"])
    customers = _get_ea_customers(ea["id"])
    packages = sum(1 for customer in customers if customer.get("package_path") or customer.get("zip_path"))
    paid_customers = sum(1 for customer in customers if customer.get("payment_status") == "Paid")
    source_ready = stats["exists"] and (stats["mq"] or stats["pine"])
    compiled_ready = stats["exists"] and bool(stats["ex"])
    package_ready = bool(stats["zip"] or packages or checks.get("package_created"))
    proof_ready = bool(backtests or checks.get("proof_ready"))

    score = 0
    if source_ready:
        score += 24
    elif compiled_ready:
        score += 14
    if proof_ready:
        score += 22
    if package_ready:
        score += 18
    score += min(22, int(checklist_pct * 0.22))
    if paid_customers:
        score += 8
    elif customers:
        score += 4
    if stats["md"] or checks.get("guide_created"):
        score += 6
    score = min(score, 100)

    if not stats["exists"] or not (source_ready or compiled_ready):
        bucket = "needs_review"
        action = "ซ่อม path / ตรวจไฟล์ต้นฉบับก่อน"
        reason = "ยังไม่เจอไฟล์ EA/indicator ที่ใช้ต่อได้"
    elif score >= 72 and package_ready and proof_ready:
        bucket = "sell_ready"
        action = "พร้อมคุยลูกค้า / ส่ง demo หรือ package"
        reason = "มีหลักฐานทดสอบและ package พร้อมใช้งาน"
    elif proof_ready and not package_ready:
        bucket = "package_next"
        action = "ทำ ZIP + คู่มือ + key delivery"
        reason = "มี proof แล้ว แต่ยังต้องแพ็กให้ลูกค้าใช้ง่าย"
    elif source_ready and not proof_ready:
        bucket = "test_next"
        action = "นำเข้า backtest / forward test เพิ่ม"
        reason = "มี source แล้ว แต่ยังขาดหลักฐานผลทดสอบ"
    elif compiled_ready:
        bucket = "package_next"
        action = "ตรวจ license และทำ package แบบ compiled"
        reason = "มีไฟล์ compiled แต่ต้องเช็กสิทธิ์/คู่มือ"
    else:
        bucket = "needs_review"
        action = "ตรวจโครงสร้างโปรเจกต์"
        reason = "ข้อมูลยังไม่พอสำหรับขายหรือทดสอบ"

    return {
        "ea": ea,
        "bucket": bucket,
        "score": score,
        "checklist_pct": checklist_pct,
        "backtests": len(backtests),
        "customers": len(customers),
        "packages": packages,
        "action": action,
        "reason": reason,
        "source_ready": source_ready,
        "package_ready": package_ready,
        "proof_ready": proof_ready,
    }


def _ea_decision_board(catalog: list[dict], ea_scans: dict) -> dict:
    buckets = {
        "sell_ready": [],
        "test_next": [],
        "package_next": [],
        "needs_review": [],
    }
    for ea in catalog:
        snapshot = _ea_decision_snapshot(ea, ea_scans.get(ea["id"], {}))
        buckets[snapshot["bucket"]].append(snapshot)
    for rows in buckets.values():
        rows.sort(key=lambda item: item["score"], reverse=True)
    return buckets
