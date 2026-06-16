"""
screenshot_sorter.py — Auto-sort chart screenshots into JOURNAL/screenshots/

Drop mode:  python screenshot_sorter.py --sort-inbox    (one-shot sort)
Watch mode: python screenshot_sorter.py --watch          (continuous watcher)

Naming convention for source files (in the inbox folder):
  {SYMBOL}_{TF}_{YYYYMMDD}_{HHMM}_{DIRECTION}[_{TAG}].png
  Example: XAUUSD_M15_20260510_1432_BUY.png
           XAUUSD_M15_20260510_1432_BUY_exit.png

Files that don't match the pattern are moved to JOURNAL/screenshots/unsorted/.
"""

import re
import shutil
import json
import logging
import time
import sys
from pathlib import Path
from datetime import datetime

# ── Paths ──────────────────────────────────────────────────────────────────────
BASE_DIR = Path(__file__).resolve().parents[2]
CFG_PATH = BASE_DIR / "SYSTEM" / "config" / "system_config.json"

with open(CFG_PATH) as f:
    CFG = json.load(f)

INBOX_DIR   = Path(CFG["paths"]["screenshot_inbox"])
DEST_ROOT   = BASE_DIR / CFG["paths"]["screenshot_dest"]
UNSORTED    = DEST_ROOT / "unsorted"

LOG_DIR = BASE_DIR / "AUTOMATION" / "logs"
LOG_DIR.mkdir(parents=True, exist_ok=True)

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=[
        logging.FileHandler(LOG_DIR / f"screenshot_sorter_{datetime.now():%Y-%m-%d}.log"),
        logging.StreamHandler(sys.stdout),
    ]
)
log = logging.getLogger(__name__)

# ── Pattern: XAUUSD_M15_20260510_1432_BUY[_tag].png ──────────────────────────
PATTERN = re.compile(
    r"^([A-Z]+)"          # symbol
    r"_([A-Z0-9]+)"       # timeframe
    r"_(\d{8})"           # date YYYYMMDD
    r"_(\d{4})"           # time HHMM
    r"_(BUY|SELL)"        # direction
    r"(?:_([a-z]+))?"     # optional tag (entry|exit|context|sl|tp)
    r"\.(png|jpg|jpeg)$",
    re.IGNORECASE
)

VALID_EXTENSIONS = {".png", ".jpg", ".jpeg"}


def sort_file(src: Path) -> bool:
    """Move one screenshot to its correct destination. Returns True on success."""
    if src.suffix.lower() not in VALID_EXTENSIONS:
        return False

    m = PATTERN.match(src.name)
    if not m:
        dest = UNSORTED / src.name
        UNSORTED.mkdir(parents=True, exist_ok=True)
        shutil.move(str(src), dest)
        log.warning(f"No pattern match — moved to unsorted: {src.name}")
        return False

    symbol, tf, date_str, time_str, direction, tag, ext = m.groups()

    # Build destination path: YYYY/MM/DD/
    year  = date_str[:4]
    month = date_str[4:6]
    day   = date_str[6:8]
    dest_dir = DEST_ROOT / year / month / day
    dest_dir.mkdir(parents=True, exist_ok=True)
    dest = dest_dir / src.name

    # Avoid overwrite
    if dest.exists():
        stem = src.stem
        dest = dest_dir / f"{stem}_{int(time.time())}{src.suffix}"

    shutil.move(str(src), dest)
    rel = dest.relative_to(BASE_DIR)
    log.info(f"Sorted: {src.name} → {rel}")
    return True


def sort_inbox() -> tuple[int, int]:
    """One-shot: sort everything currently in the inbox folder."""
    if not INBOX_DIR.exists():
        log.error(f"Inbox folder not found: {INBOX_DIR}")
        return 0, 0

    files = [p for p in INBOX_DIR.iterdir() if p.is_file()]
    log.info(f"Found {len(files)} files in inbox.")
    ok = fail = 0
    for f in files:
        if sort_file(f):
            ok += 1
        else:
            fail += 1
    log.info(f"Done — sorted: {ok} | skipped/unsorted: {fail}")
    return ok, fail


def watch_inbox(interval: int = 5):
    """Continuously watch inbox folder and sort new files."""
    log.info(f"Watching {INBOX_DIR} every {interval}s. Press Ctrl+C to stop.")
    INBOX_DIR.mkdir(parents=True, exist_ok=True)
    seen = set()
    try:
        while True:
            for p in INBOX_DIR.iterdir():
                if p.is_file() and p not in seen:
                    seen.add(p)
                    sort_file(p)
            time.sleep(interval)
    except KeyboardInterrupt:
        log.info("Watcher stopped.")


# ── Screenshot path builder (for journal_manager.py) ─────────────────────────
def build_screenshot_path(symbol: str, tf: str, dt: datetime,
                           direction: str, tag: str = "") -> str:
    """
    Returns the relative path where a screenshot SHOULD be saved.
    Use this when linking a screenshot to a trade in the journal.
    """
    date_str = dt.strftime("%Y%m%d")
    time_str = dt.strftime("%H%M")
    tag_part = f"_{tag.lower()}" if tag else ""
    filename = f"{symbol.upper()}_{tf.upper()}_{date_str}_{time_str}_{direction.upper()}{tag_part}.png"
    rel = f"JOURNAL/screenshots/{dt.year}/{dt.month:02d}/{dt.day:02d}/{filename}"
    return rel


if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Screenshot Sorter")
    parser.add_argument("--sort-inbox", action="store_true", help="One-shot sort of inbox folder")
    parser.add_argument("--watch",      action="store_true", help="Watch inbox continuously")
    parser.add_argument("--interval",   type=int, default=5, help="Watch interval in seconds")
    args = parser.parse_args()

    if args.sort_inbox:
        sort_inbox()
    elif args.watch:
        watch_inbox(interval=args.interval)
    else:
        print("Usage: python screenshot_sorter.py --sort-inbox")
        print("       python screenshot_sorter.py --watch [--interval 5]")
