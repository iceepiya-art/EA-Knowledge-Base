"""Safe Git-based update/deploy helper for the single Home execution host."""
from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path


def read_env_file(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip().strip('"').strip("'")
    return values


def ensure_home_runtime(root: Path, config: dict[str, str]) -> None:
    root_text = str(root.resolve()).replace("/", "\\").lower()
    if "\\my drive\\" in root_text or root_text.startswith("g:\\my drive"):
        raise ValueError("Home runtime must be on a local drive, never Google Drive.")
    if config.get("EA_KB_EXECUTION_HOST", "").lower() != "home":
        raise ValueError("Refusing deployment: EA_KB_EXECUTION_HOST must be 'home'.")


def run(command: list[str], cwd: Path, dry_run: bool) -> dict[str, object]:
    if dry_run:
        return {"command": command, "returncode": 0, "dry_run": True, "stdout": ""}
    completed = subprocess.run(command, cwd=cwd, text=True, capture_output=True, check=False, encoding="utf-8", errors="replace")
    result = {"command": command, "returncode": completed.returncode, "stdout": completed.stdout[-4000:], "stderr": completed.stderr[-4000:]}
    if completed.returncode:
        raise RuntimeError(json.dumps(result, ensure_ascii=False))
    return result


def backup_and_deploy(artifact: Path, experts_dir: Path, dry_run: bool) -> dict[str, str]:
    if not artifact.exists():
        raise FileNotFoundError(f"Compiled EA artifact missing: {artifact}")
    target = experts_dir / artifact.name
    stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    backup = experts_dir / f"{artifact.stem}_before_home_deploy_{stamp}{artifact.suffix}"
    if dry_run:
        return {"artifact": str(artifact), "target": str(target), "backup": str(backup), "dry_run": "true"}
    experts_dir.mkdir(parents=True, exist_ok=True)
    if target.exists():
        shutil.copy2(target, backup)
    shutil.copy2(artifact, target)
    if artifact.read_bytes() != target.read_bytes():
        raise RuntimeError("EA deploy verification failed: installed EX5 differs from compiled artifact.")
    return {"artifact": str(artifact), "target": str(target), "backup": str(backup)}


def update_home_runtime(root: Path, config_path: Path, *, dry_run: bool = False, skip_pull: bool = False, skip_tests: bool = False, skip_compile: bool = False) -> dict[str, object]:
    config = read_env_file(config_path)
    ensure_home_runtime(root, config)
    report: dict[str, object] = {"started_at": datetime.now(timezone.utc).isoformat(), "root": str(root.resolve()), "dry_run": dry_run, "steps": []}
    steps: list[dict[str, object]] = report["steps"]  # type: ignore[assignment]

    if not skip_pull:
        steps.append(run(["git", "pull", "--ff-only"], root, dry_run))
    if not skip_tests:
        steps.append(run([sys.executable, "-m", "pytest", "-q", "test_run_trading_cycle_cme.py", "test_mql_cme_signal_fields.py"], root, dry_run))
    artifact = root / "artifacts" / "generated_ea" / "MasterEA_v3.ex5"
    if not skip_compile:
        steps.append(run([sys.executable, "ea_research_team/learning/compile_ea.py", "--file", "artifacts/generated_ea/MasterEA_v3.mq5"], root, dry_run))
    experts_dir_text = config.get("EA_KB_MT5_EXPERTS_DIR", "")
    if not experts_dir_text:
        raise ValueError("EA_KB_MT5_EXPERTS_DIR is required in the home config.")
    report["deployment"] = backup_and_deploy(artifact, Path(experts_dir_text), dry_run)
    report["finished_at"] = datetime.now(timezone.utc).isoformat()
    return report


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description="Pull, test, compile, and deploy the Home-only MasterEA runtime.")
    parser.add_argument("--root", type=Path, default=Path.cwd())
    parser.add_argument("--config", type=Path, required=True)
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--skip-pull", action="store_true")
    parser.add_argument("--skip-tests", action="store_true")
    parser.add_argument("--skip-compile", action="store_true")
    parser.add_argument("--report", type=Path)
    args = parser.parse_args(argv)
    try:
        report = update_home_runtime(args.root, args.config, dry_run=args.dry_run, skip_pull=args.skip_pull, skip_tests=args.skip_tests, skip_compile=args.skip_compile)
    except Exception as exc:
        print(f"HOME DEPLOY FAILED: {exc}", file=sys.stderr)
        return 1
    text = json.dumps(report, ensure_ascii=False, indent=2)
    if args.report:
        args.report.parent.mkdir(parents=True, exist_ok=True)
        args.report.write_text(text + "\n", encoding="utf-8")
    print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
