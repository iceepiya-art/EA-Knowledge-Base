"""
Watch/import MT5 CSV files safely.

Default mode scans once and imports stable CSV files. Use --loop for a polling
watcher. Duplicate prevention is handled by mt5_importer manifest plus trade_id
and content fingerprint logic.
"""

from __future__ import annotations

import argparse
import time
import traceback
from datetime import datetime
from pathlib import Path

from automation_common import automation_config, ensure_dirs, log_action, resolve_path, setup_logging
from telegram_alert import send_telegram

import sys

BASE_DIR = Path(__file__).resolve().parents[1]
IMPORTER_DIR = BASE_DIR / "ANALYTICS" / "importers"
if str(IMPORTER_DIR) not in sys.path:
    sys.path.insert(0, str(IMPORTER_DIR))

from mt5_importer import import_csv, print_summary  # noqa: E402


def _strategy_for_file(path: Path) -> tuple[str, str]:
    cfg = automation_config()
    imp = cfg.get("import", {})
    name = path.name.lower()
    for rule in imp.get("filename_rules", []):
        token = str(rule.get("contains", "")).lower()
        if token and token in name:
            return rule.get("strategy", imp.get("default_strategy", "Unknown")), rule.get("symbol", imp.get("default_symbol", "XAUUSD"))
    return imp.get("default_strategy", "Unknown"), imp.get("default_symbol", "XAUUSD")


def _is_stable(path: Path, stable_seconds: int) -> bool:
    try:
        age = time.time() - path.stat().st_mtime
    except FileNotFoundError:
        return False
    return age >= stable_seconds


def scan_once(force: bool = False) -> list[dict]:
    cfg = automation_config()
    ensure_dirs()
    logger = setup_logging("watch_mt5_folder")
    if not cfg.get("enabled", True):
        log_action(logger, "watch_mt5_folder", "skipped", {"reason": "automation disabled"})
        return []

    watch_folder = resolve_path(cfg.get("paths", {}).get("mt5_watch_folder", "DATA/raw/mt5_exports"))
    watch_folder.mkdir(parents=True, exist_ok=True)
    stable_seconds = int(cfg.get("import", {}).get("stable_file_seconds", 20))
    broker_tz = int(cfg.get("import", {}).get("broker_tz", 2))

    csvs = sorted(watch_folder.glob("*.csv"))
    ready = [p for p in csvs if _is_stable(p, stable_seconds)]
    skipped_unstable = len(csvs) - len(ready)
    results: list[dict] = []
    log_action(logger, "scan_mt5_folder", "started", {"folder": str(watch_folder), "csvs": len(csvs), "ready": len(ready)})

    for csv_path in ready:
        strategy, symbol = _strategy_for_file(csv_path)
        try:
            if cfg.get("dry_run", False):
                result = {"file": csv_path.name, "dry_run": True, "strategy": strategy, "symbol": symbol}
            else:
                result = import_csv(csv_path, strategy=strategy, symbol=symbol, force=force, broker_tz=broker_tz)
            results.append(result)
            log_action(logger, "import_csv", "success", {"file": csv_path.name, "strategy": strategy, "symbol": symbol, "result": result})
        except Exception as exc:
            log_action(logger, "import_csv", "error", {"file": csv_path.name, "error": str(exc), "traceback": traceback.format_exc()})
            send_telegram(f"Import error for {csv_path.name}: {exc}")

    if results and not cfg.get("dry_run", False):
        print_summary(results)

    log_action(
        logger,
        "scan_mt5_folder",
        "finished",
        {
            "imported_files": len(results),
            "skipped_unstable": skipped_unstable,
            "finished_at": datetime.now().isoformat(timespec="seconds"),
        },
    )
    return results


def run_loop(interval_seconds: int, force: bool = False) -> None:
    logger = setup_logging("watch_mt5_folder")
    log_action(logger, "watch_loop", "started", {"interval_seconds": interval_seconds})
    while True:
        scan_once(force=force)
        time.sleep(interval_seconds)


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description="Safely watch/import MT5 CSV files")
    ap.add_argument("--loop", action="store_true", help="Run continuously with polling")
    ap.add_argument("--interval", type=int, default=300, help="Polling interval in seconds")
    ap.add_argument("--force", action="store_true", help="Force importer to re-check unchanged files")
    args = ap.parse_args()
    if args.loop:
        run_loop(args.interval, force=args.force)
    else:
        scan_once(force=args.force)
