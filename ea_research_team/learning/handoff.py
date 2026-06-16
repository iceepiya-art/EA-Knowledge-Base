"""Multi-Agent Handoff CLI - EA Knowledge Brain.

Lets any AI agent (Claude, Codex, GPT-4) pick up work immediately
by reading the .agent_handoff/ directory at the project root.

Usage:
  python handoff.py status [--dir PATH]        # print full handoff summary
  python handoff.py log MESSAGE [--dir PATH]   # append entry to HANDOFF_LOG.md
"""
from __future__ import annotations

import argparse
import sys
from datetime import datetime, timezone, timedelta
from pathlib import Path

HANDOFF_DIR = Path(__file__).parents[2] / ".agent_handoff"
TH_TZ = timezone(timedelta(hours=7))

REQUIRED_FILES = [
    "CURRENT_STATE.md",
    "NEXT_TASK.md",
    "DECISIONS.md",
    "RUNBOOK.md",
    "TEST_STATUS.md",
    "HANDOFF_LOG.md",
]

_SEP = "-" * 62


def _read(path: Path, fallback: str = "(file not found)") -> str:
    if not path.exists():
        return fallback
    return path.read_text(encoding="utf-8")


def status(handoff_dir: Path = HANDOFF_DIR) -> str:
    """Return a formatted handoff status string for stdout."""
    sections = [
        ("CURRENT STATE",   "CURRENT_STATE.md"),
        ("NEXT TASK",       "NEXT_TASK.md"),
        ("TEST STATUS",     "TEST_STATUS.md"),
        ("RUN COMMANDS",    "RUNBOOK.md"),
    ]
    lines = [_SEP, "  EA KNOWLEDGE BRAIN - AGENT HANDOFF STATUS", _SEP]
    for title, fname in sections:
        content = _read(handoff_dir / fname)
        lines += ["", f">> {title}", _SEP, content.strip(), ""]
    lines.append(_SEP)
    return "\n".join(lines)


def log_entry(message: str, handoff_dir: Path = HANDOFF_DIR) -> None:
    """Append a timestamped entry to HANDOFF_LOG.md (never overwrites)."""
    log_path = handoff_dir / "HANDOFF_LOG.md"
    now = datetime.now(TH_TZ).isoformat(timespec="seconds")
    entry = f"\n## {now}\n{message}\n"
    if not log_path.exists():
        log_path.parent.mkdir(parents=True, exist_ok=True)
        log_path.write_text("# Handoff Log\n" + entry, encoding="utf-8")
    else:
        with log_path.open("a", encoding="utf-8") as fh:
            fh.write(entry)


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="EA Knowledge Brain - multi-agent handoff tool"
    )
    sub = parser.add_subparsers(dest="command", required=True)

    status_p = sub.add_parser("status", help="Print current handoff summary")
    status_p.add_argument(
        "--dir", default=None,
        help=f"Override handoff directory (default: {HANDOFF_DIR})",
    )

    log_p = sub.add_parser("log", help="Append timestamped entry to HANDOFF_LOG.md")
    log_p.add_argument("message", help="Message to append")
    log_p.add_argument(
        "--dir", default=None,
        help=f"Override handoff directory (default: {HANDOFF_DIR})",
    )

    return parser


def main(argv: list[str] | None = None) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    parser = _build_parser()
    args = parser.parse_args(argv)
    hdir = Path(args.dir) if getattr(args, "dir", None) else HANDOFF_DIR

    if args.command == "status":
        print(status(hdir))
        return 0

    if args.command == "log":
        log_entry(args.message, handoff_dir=hdir)
        print(f"Logged to {hdir / 'HANDOFF_LOG.md'}: {args.message}")
        return 0

    parser.error(f"Unknown command: {args.command}")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
