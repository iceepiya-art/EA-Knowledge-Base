"""
Daily safe automation runner.

Does:
1. Scan/import MT5 CSV files
2. Refresh generated daily report
3. Export report to Obsidian
4. Evaluate risk/data alerts
5. Log every action

Does not trade or change EA/risk settings.
"""

from __future__ import annotations

import argparse
import traceback

from automation_common import ensure_dirs, log_action, setup_logging
from safe_monitor import evaluate_alerts
from safe_reports import write_daily_report
from telegram_alert import send_telegram
from watch_mt5_folder import scan_once


def run(send_summary: bool = True) -> int:
    ensure_dirs()
    logger = setup_logging("daily_import")
    log_action(logger, "daily_safe_run", "started")
    try:
        import_results = scan_once(force=False)
        report = write_daily_report()
        log_action(logger, "daily_report", "success", report)

        alerts = evaluate_alerts()
        for alert in alerts:
            log_action(logger, "telegram_alert_candidate", alert["level"], alert)
            send_telegram(alert["message"])

        if send_summary:
            stats = report.get("stats", {})
            send_telegram(
                "Daily report generated.\n"
                f"Trades: {stats.get('trades', 0)}\n"
                f"Net PnL: {stats.get('net_pnl', 0)} USD\n"
                f"Report: {report.get('obsidian_path')}"
            )

        log_action(
            logger,
            "daily_safe_run",
            "finished",
            {"import_files": len(import_results), "alerts": len(alerts), "report": report},
        )
        return 0
    except Exception as exc:
        log_action(logger, "daily_safe_run", "error", {"error": str(exc), "traceback": traceback.format_exc()})
        send_telegram(f"Daily automation error: {exc}")
        return 1


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description="Run QTrade OS daily safe automation")
    ap.add_argument("--no-summary", action="store_true", help="Do not send daily summary Telegram message")
    args = ap.parse_args()
    raise SystemExit(run(send_summary=not args.no_summary))
