"""
Manual safety check runner.
Use this before trusting Task Scheduler jobs.
"""

from automation_common import ensure_dirs, log_action, setup_logging
from safe_monitor import evaluate_alerts
from safe_reports import write_daily_report, write_weekly_report


def main() -> int:
    ensure_dirs()
    logger = setup_logging("safety_check")
    log_action(logger, "safety_check", "started")
    daily = write_daily_report()
    weekly = write_weekly_report()
    alerts = evaluate_alerts()
    log_action(logger, "safety_check", "finished", {"daily": daily, "weekly": weekly, "alerts": alerts})
    print("QTrade OS safety check complete.")
    print(f"Daily report: {daily['report_path']}")
    print(f"Weekly report: {weekly['report_path']}")
    print(f"Alerts detected: {len(alerts)}")
    for alert in alerts:
        print(f"- {alert['type']}: {alert['message']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
