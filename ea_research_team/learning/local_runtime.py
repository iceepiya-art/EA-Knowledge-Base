"""Safe verification helper for the local C: runtime launcher."""
from __future__ import annotations

import argparse
from pathlib import Path
import sys


def prepare(runtime_root: Path) -> int:
    required = (
        runtime_root / ".git",
        runtime_root / "Start_EA_Backend.bat",
        runtime_root / "ea_research_team" / "learning" / "server.py",
    )
    missing = [str(path) for path in required if not path.exists()]
    if missing:
        print("Local runtime is incomplete: " + ", ".join(missing), file=sys.stderr)
        return 1
    print(f"Local runtime verified: {runtime_root}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=("prepare",))
    parser.add_argument("--runtime-root", required=True)
    args = parser.parse_args()
    return prepare(Path(args.runtime_root))


if __name__ == "__main__":
    raise SystemExit(main())
