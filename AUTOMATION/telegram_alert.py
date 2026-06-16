"""
Telegram alert helper for QTrade OS automation.

This sends informational alerts only. It never sends trading commands.
"""

from __future__ import annotations

import argparse
import json
import urllib.parse
import urllib.request

from automation_common import TELEGRAM_CONFIG, automation_config, read_json


def send_telegram(message: str, force: bool = False) -> tuple[bool, str]:
    auto_cfg = automation_config()
    alert_cfg = auto_cfg.get("alerts", {})
    if not force and not alert_cfg.get("telegram_enabled", False):
        return False, "Telegram disabled in automation_config.json"

    cfg = read_json(TELEGRAM_CONFIG, {})
    token = cfg.get("bot_token")
    chat_id = cfg.get("chat_id")
    if not token or not chat_id or "YOUR_" in str(token):
        return False, "Telegram config missing or placeholder"

    safe_prefix = "[QTrade OS SAFE ALERT]\n"
    text = safe_prefix + message
    data = urllib.parse.urlencode({"chat_id": chat_id, "text": text}).encode("utf-8")
    url = f"https://api.telegram.org/bot{token}/sendMessage"
    req = urllib.request.Request(url, data=data, method="POST")
    try:
        with urllib.request.urlopen(req, timeout=15) as response:
            payload = json.loads(response.read().decode("utf-8"))
        return bool(payload.get("ok")), str(payload)
    except Exception as exc:
        return False, str(exc)


if __name__ == "__main__":
    ap = argparse.ArgumentParser(description="Send a QTrade OS Telegram alert")
    ap.add_argument("message", nargs="?", default="QTrade OS test alert")
    ap.add_argument("--force", action="store_true", help="Send even if automation telegram flag is false")
    args = ap.parse_args()
    ok, msg = send_telegram(args.message, force=args.force)
    print(f"ok={ok} {msg}")
