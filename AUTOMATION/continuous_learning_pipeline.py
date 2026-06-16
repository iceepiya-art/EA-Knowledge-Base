"""
QTrade OS continuous auto-learning pipeline.

Human-decided, AI-assisted, statistics-driven, continuous learning.

This pipeline automates data import, analytics refresh markers, reports,
Obsidian exports, alerts, logs, and audit records only. It never opens orders,
closes orders, changes lots, changes EA configs, deploys live systems, or
overrides risk.
"""

from __future__ import annotations

import argparse
import json
import sys
import time
import traceback
from datetime import datetime
from pathlib import Path
from typing import Any

from automation_common import (
    BASE_DIR,
    automation_config,
    ensure_dirs,
    load_trades,
    log_action,
    resolve_path,
    setup_logging,
)
from safe_monitor import evaluate_alerts
from safe_reports import write_daily_report, write_learning_report_pack, write_weekly_report
from telegram_alert import send_telegram
from watch_mt5_folder import scan_once

CORE_DIR = BASE_DIR / "ANALYTICS" / "core"
if str(CORE_DIR) not in sys.path:
    sys.path.insert(0, str(CORE_DIR))

try:
    from research_exporter import export_all as export_research_intelligence
except Exception:
    export_research_intelligence = None


def _state_path() -> Path:
    cfg = automation_config()
    state_dir = resolve_path(cfg.get("paths", {}).get("automation_state", "AUTOMATION/state"))
    state_dir.mkdir(parents=True, exist_ok=True)
    return state_dir / "continuous_learning_state.json"


def _load_state() -> dict[str, Any]:
    path = _state_path()
    if not path.exists():
        return {"alerts": {}, "reports": {}, "last_run": None}
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except Exception:
        return {"alerts": {}, "reports": {}, "last_run": None}


def _save_state(state: dict[str, Any]) -> None:
    path = _state_path()
    path.write_text(json.dumps(state, indent=2, ensure_ascii=False), encoding="utf-8")


def _today_key() -> str:
    return datetime.now().date().isoformat()


def _week_key() -> str:
    return datetime.now().strftime("%G-W%V")


def _should_run_daily(state: dict[str, Any]) -> bool:
    cfg = automation_config()
    hour = int(cfg.get("reports", {}).get("daily_review_hour", 23))
    if datetime.now().hour < hour:
        return False
    return state.get("reports", {}).get("daily") != _today_key()


def _should_run_weekly(state: dict[str, Any]) -> bool:
    cfg = automation_config()
    reports = cfg.get("reports", {})
    day_name = reports.get("weekly_review_day", "Sunday").lower()
    hour = int(reports.get("weekly_review_hour", 18))
    if datetime.now().strftime("%A").lower() != day_name:
        return False
    if datetime.now().hour < hour:
        return False
    return state.get("reports", {}).get("weekly") != _week_key()


def _alert_key(alert: dict[str, Any]) -> str:
    return f"{alert.get('type')}::{alert.get('message')}"


def _cooldown_passed(state: dict[str, Any], key: str) -> bool:
    cfg = automation_config()
    cooldown = int(cfg.get("alerts", {}).get("alert_cooldown_minutes", 240))
    raw = state.get("alerts", {}).get(key)
    if not raw:
        return True
    try:
        last = datetime.fromisoformat(raw)
    except Exception:
        return True
    return (datetime.now() - last).total_seconds() >= cooldown * 60


def _send_alerts(alerts: list[dict[str, Any]], state: dict[str, Any], logger) -> int:
    sent = 0
    state.setdefault("alerts", {})
    for alert in alerts:
        key = _alert_key(alert)
        if not _cooldown_passed(state, key):
            log_action(logger, "alert_suppressed_cooldown", "skipped", alert)
            continue
        log_action(logger, "telegram_alert_candidate", alert.get("level", "info"), alert)
        ok, msg = send_telegram(alert.get("message", ""))
        log_action(logger, "telegram_alert_send", "sent" if ok else "skipped", {"ok": ok, "result": msg, "alert": alert})
        state["alerts"][key] = datetime.now().isoformat(timespec="seconds")
        sent += 1
    return sent


def _refresh_dashboard_marker(logger) -> dict[str, Any]:
    marker = BASE_DIR / "DATA" / "processed" / "analytics_refresh.json"
    df = load_trades()
    payload = {
        "refreshed_at": datetime.now().isoformat(timespec="seconds"),
        "trades": int(len(df)),
        "note": "Streamlit load_trades uses a 5-minute cache. This marker records pipeline refresh time.",
    }
    marker.parent.mkdir(parents=True, exist_ok=True)
    marker.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    log_action(logger, "analytics_refresh_marker", "success", payload)
    return payload


def run_once(force_reports: bool = False) -> dict[str, Any]:
    ensure_dirs()
    cfg = automation_config()
    logger = setup_logging("continuous_learning")
    state = _load_state()
    result: dict[str, Any] = {
        "started_at": datetime.now().isoformat(timespec="seconds"),
        "imports": [],
        "reports": {},
        "alerts": 0,
        "research_export": None,
    }

    if not cfg.get("enabled", True):
        log_action(logger, "continuous_learning", "skipped", {"reason": "automation disabled"})
        return result

    log_action(logger, "continuous_learning", "started")
    try:
        result["imports"] = scan_once(force=False)
        result["refresh"] = _refresh_dashboard_marker(logger)

        reports_cfg = cfg.get("reports", {})
        if force_reports or _should_run_daily(state):
            daily = write_daily_report()
            result["reports"]["daily"] = daily
            state.setdefault("reports", {})["daily"] = _today_key()
            log_action(logger, "daily_review_generated", "success", daily)

        if force_reports or _should_run_weekly(state):
            weekly = write_weekly_report()
            result["reports"]["weekly"] = weekly
            state.setdefault("reports", {})["weekly"] = _week_key()
            log_action(logger, "weekly_review_generated", "success", weekly)

        learning_pack = write_learning_report_pack()
        result["reports"]["learning_pack"] = learning_pack
        log_action(logger, "learning_report_pack", "success", learning_pack)

        if reports_cfg.get("export_research_intelligence", True) and export_research_intelligence is not None:
            df = load_trades()
            research = export_research_intelligence(df=df, overwrite=True, trade_limit=100, annotated_trades_only=True)
            result["research_export"] = research.get("summary", research)
            log_action(logger, "obsidian_research_export", "success", result["research_export"])

        alerts = evaluate_alerts()
        result["alerts"] = _send_alerts(alerts, state, logger)

        state["last_run"] = datetime.now().isoformat(timespec="seconds")
        _save_state(state)
        result["finished_at"] = state["last_run"]
        log_action(logger, "continuous_learning", "finished", result)
        return result
    except Exception as exc:
        log_action(logger, "continuous_learning", "error", {"error": str(exc), "traceback": traceback.format_exc()})
        send_telegram(f"Continuous learning pipeline error: {exc}")
        state["last_error"] = {"at": datetime.now().isoformat(timespec="seconds"), "error": str(exc)}
        _save_state(state)
        raise


def run_loop(interval_seconds: int | None = None, force_reports: bool = False) -> None:
    cfg = automation_config()
    interval = interval_seconds or int(cfg.get("reports", {}).get("continuous_interval_seconds", 300))
    logger = setup_logging("continuous_learning")
    log_action(logger, "continuous_learning_loop", "started", {"interval_seconds": interval})
    while True:
        run_once(force_reports=force_reports)
        time.sleep(interval)


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description="Run QTrade OS continuous auto-learning pipeline")
    ap.add_argument("--loop", action="store_true", help="Run forever with a safe polling interval")
    ap.add_argument("--interval", type=int, default=None, help="Loop interval in seconds")
    ap.add_argument("--force-reports", action="store_true", help="Generate daily/weekly reports even if already done")
    args = ap.parse_args()
    if args.loop:
        run_loop(args.interval, force_reports=args.force_reports)
    else:
        print(json.dumps(run_once(force_reports=args.force_reports), indent=2, ensure_ascii=False))
