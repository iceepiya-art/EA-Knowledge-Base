"""
Weekly safe report runner.
Generates Markdown reports for REPORTS/weekly and Obsidian.
"""

from __future__ import annotations

import argparse
import traceback

from automation_common import ensure_dirs, log_action, setup_logging
from safe_monitor import evaluate_alerts
from safe_reports import write_weekly_report
from telegram_alert import send_telegram


def run(send_summary: bool = True) -> int:
    ensure_dirs()
    logger = setup_logging("weekly_report")
    log_action(logger, "weekly_safe_report", "started")
    try:
        report = write_weekly_report()
        log_action(logger, "weekly_report", "success", report)

        alerts = evaluate_alerts()
        for alert in alerts:
            log_action(logger, "weekly_alert_candidate", alert["level"], alert)
            send_telegram(alert["message"])

        if send_summary:
            stats = report.get("stats", {})
            send_telegram(
                "Weekly report generated.\n"
                f"Trades: {stats.get('trades', 0)}\n"
                f"Net PnL: {stats.get('net_pnl', 0)} USD\n"
                f"Report: {report.get('obsidian_path')}"
            )

        log_action(logger, "weekly_safe_report", "finished", {"alerts": len(alerts), "report": report})
        return 0
    except Exception as exc:
        log_action(logger, "weekly_safe_report", "error", {"error": str(exc), "traceback": traceback.format_exc()})
        send_telegram(f"Weekly automation error: {exc}")
        return 1


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description="Run QTrade OS weekly safe report")
    ap.add_argument("--no-summary", action="store_true", help="Do not send weekly summary Telegram message")
    args = ap.parse_args()
    raise SystemExit(run(send_summary=not args.no_summary))
