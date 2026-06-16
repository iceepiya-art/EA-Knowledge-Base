from __future__ import annotations

import argparse
import json
import os
import sys
import time
import hashlib
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any, Callable

from local_evidence_intake import DEFAULT_LOCAL_RAW_DIR, VIDEO_EXTENSIONS, import_local_evidence


TH_TZ = timezone(timedelta(hours=7))
WORKSPACE_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_INBOX_DIR = Path(r"G:\My Drive\YT_Downloads")
DEFAULT_MANIFEST_PATH = WORKSPACE_ROOT / ".agent_handoff" / "local_video_intake_manifest.json"
TEMP_SUFFIXES = {".tmp", ".part", ".crdownload", ".download", ".aria2", ".idmdownload"}
Importer = Callable[..., dict[str, Any]]


def now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")


def empty_manifest() -> dict[str, Any]:
    return {"version": 1, "updated_at": now_iso(), "files": {}}


def load_manifest(path: str | Path = DEFAULT_MANIFEST_PATH) -> dict[str, Any]:
    manifest_path = Path(path)
    if not manifest_path.exists():
        return empty_manifest()
    data = json.loads(manifest_path.read_text(encoding="utf-8-sig"))
    if not isinstance(data, dict):
        raise ValueError("local video manifest must contain a JSON object")
    data.setdefault("version", 1)
    data.setdefault("files", {})
    return data


def save_manifest(manifest: dict[str, Any], path: str | Path = DEFAULT_MANIFEST_PATH) -> None:
    manifest["updated_at"] = now_iso()
    manifest_path = Path(path)
    manifest_path.parent.mkdir(parents=True, exist_ok=True)
    tmp = manifest_path.with_suffix(manifest_path.suffix + ".tmp")
    tmp.write_text(json.dumps(manifest, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
    tmp.replace(manifest_path)


def sha256_file(path: str | Path) -> str:
    digest = hashlib.sha256()
    with Path(path).open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _file_key(path: Path) -> str:
    return hashlib.sha256(str(path.resolve()).lower().encode("utf-8")).hexdigest()[:16]


def _existing_key_for_path(manifest: dict[str, Any], path: Path) -> str | None:
    target = str(path)
    for key, record in manifest.get("files", {}).items():
        if record.get("path") == target:
            return key
    return None


def _is_video(path: Path) -> bool:
    return path.is_file() and path.suffix.lower() in VIDEO_EXTENSIONS


def _has_temp_companion(path: Path) -> bool:
    candidates = [path.with_suffix(path.suffix + suffix) for suffix in TEMP_SUFFIXES]
    candidates.extend(path.with_suffix(suffix) for suffix in TEMP_SUFFIXES)
    return any(candidate.exists() for candidate in candidates)


def _status_for_file(path: Path, *, stable_age_seconds: int) -> tuple[str, str]:
    if _has_temp_companion(path):
        return "downloading", "temporary download file exists"
    age = time.time() - path.stat().st_mtime
    if age < stable_age_seconds:
        return "downloading", f"modified {int(age)}s ago; waiting for stable age {stable_age_seconds}s"
    return "ready", "stable video file"


def _learned_hashes(manifest: dict[str, Any], current_key: str) -> dict[str, dict[str, Any]]:
    found: dict[str, dict[str, Any]] = {}
    for key, record in manifest.get("files", {}).items():
        if key == current_key:
            continue
        status = record.get("status")
        digest = record.get("sha256")
        if digest and status in {"learned", "transcribed", "raw_evidence_written", "duplicate"}:
            found.setdefault(digest, record)
    return found


def scan_local_videos(
    *,
    inbox_dir: str | Path = DEFAULT_INBOX_DIR,
    manifest_path: str | Path = DEFAULT_MANIFEST_PATH,
    stable_age_seconds: int = 120,
) -> dict[str, Any]:
    inbox = Path(inbox_dir)
    manifest = load_manifest(manifest_path)
    counts = {"seen": 0, "ready": 0, "downloading": 0, "duplicate": 0, "missing": 0}

    if not inbox.exists():
        manifest["last_scan_error"] = f"inbox folder not found: {inbox}"
        save_manifest(manifest, manifest_path)
        return {"status": "missing_inbox", "inbox_dir": str(inbox), **counts}

    current_paths = set()
    for path in sorted(inbox.rglob("*")):
        if not _is_video(path):
            continue
        current_paths.add(str(path))
        key = _existing_key_for_path(manifest, path) or _file_key(path)
        status, reason = _status_for_file(path, stable_age_seconds=stable_age_seconds)
        stat = path.stat()
        digest = sha256_file(path)
        duplicate_of = None
        if status == "ready":
            duplicate = _learned_hashes(manifest, key).get(digest)
            if duplicate:
                status = "duplicate"
                reason = "same sha256 already learned or recorded"
                duplicate_of = duplicate.get("path")
        record = manifest["files"].get(key, {})
        preserve_learned = record.get("status") == "learned" and record.get("sha256") == digest
        if preserve_learned:
            status = "learned"
            reason = record.get("reason") or "already learned"
        record.update(
            {
                "path": str(path),
                "filename": path.name,
                "size": stat.st_size,
                "mtime": stat.st_mtime,
                "sha256": digest,
                "status": status,
                "reason": reason,
                "updated_at": now_iso(),
            }
        )
        if duplicate_of:
            record["duplicate_of"] = duplicate_of
        manifest["files"][key] = record
        counts["seen"] += 1
        counts[status] = counts.get(status, 0) + 1

    for record in manifest["files"].values():
        if record.get("path") and record["path"] not in current_paths and record.get("status") not in {"learned", "duplicate"}:
            record["status"] = "missing"
            record["reason"] = "file no longer exists in inbox"
            record["updated_at"] = now_iso()
            counts["missing"] += 1

    manifest.pop("last_scan_error", None)
    save_manifest(manifest, manifest_path)
    return {"status": "scanned", "inbox_dir": str(inbox), "manifest_path": str(manifest_path), **counts}


def _ready_records(manifest: dict[str, Any]) -> list[tuple[str, dict[str, Any]]]:
    records = [
        (key, record)
        for key, record in manifest.get("files", {}).items()
        if record.get("status") == "ready" and record.get("path")
    ]
    return sorted(records, key=lambda item: (item[1].get("mtime", 0), item[1].get("path", "")))


def process_one_ready_video(
    *,
    manifest_path: str | Path = DEFAULT_MANIFEST_PATH,
    raw_dir: str | Path = DEFAULT_LOCAL_RAW_DIR,
    importer: Importer = import_local_evidence,
    auto_pipeline: bool = False,
) -> dict[str, Any]:
    manifest = load_manifest(manifest_path)
    ready = _ready_records(manifest)
    if not ready:
        return {"status": "idle", "reason": "no_ready_videos"}

    key, record = ready[0]
    path = Path(record["path"])
    if not path.exists():
        record["status"] = "missing"
        record["reason"] = "file missing before processing"
        record["updated_at"] = now_iso()
        save_manifest(manifest, manifest_path)
        return {"status": "missing", "path": str(path)}

    record["status"] = "transcribing"
    record["started_at"] = now_iso()
    save_manifest(manifest, manifest_path)

    old_engines = os.environ.get("ORCA_TRANSCRIPTION_ENGINES")
    os.environ.setdefault("ORCA_TRANSCRIPTION_ENGINES", "faster_whisper")
    try:
        result = importer(path, raw_dir=raw_dir)
        record.update(
            {
                "status": "learned" if result.get("status") == "raw_evidence_written" else "failed",
                "import_status": result.get("status"),
                "note_path": result.get("note_path"),
                "local_evidence_id": result.get("local_evidence_id"),
                "text_captured": result.get("text_captured"),
                "transcription_error": result.get("transcription_error"),
                "processed_at": now_iso(),
                "reason": "local evidence imported",
            }
        )
        if auto_pipeline:
            record["auto_pipeline_requested"] = True
    except Exception as exc:
        record.update(
            {
                "status": "failed",
                "error": str(exc),
                "retry_count": int(record.get("retry_count") or 0) + 1,
                "processed_at": now_iso(),
                "reason": "local evidence import failed",
            }
        )
        result = {"status": "failed", "error": str(exc)}
    finally:
        if old_engines is None:
            os.environ.pop("ORCA_TRANSCRIPTION_ENGINES", None)
        else:
            os.environ["ORCA_TRANSCRIPTION_ENGINES"] = old_engines
        save_manifest(manifest, manifest_path)

    return {"path": str(path), **result, "status": record["status"]}


def manifest_status(*, manifest_path: str | Path = DEFAULT_MANIFEST_PATH) -> dict[str, Any]:
    manifest = load_manifest(manifest_path)
    counts: dict[str, int] = {}
    for record in manifest.get("files", {}).values():
        status = str(record.get("status") or "unknown")
        counts[status] = counts.get(status, 0) + 1
    return {
        "status": "ok",
        "manifest_path": str(manifest_path),
        "counts": counts,
        "total": sum(counts.values()),
        "updated_at": manifest.get("updated_at"),
    }


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Watch local IDM-downloaded videos for EA Knowledge Brain intake.")
    sub = parser.add_subparsers(dest="command", required=True)
    for name in ("scan", "process-one", "status"):
        cmd = sub.add_parser(name)
        cmd.add_argument("--inbox-dir", default=str(DEFAULT_INBOX_DIR))
        cmd.add_argument("--manifest", default=str(DEFAULT_MANIFEST_PATH))
        cmd.add_argument("--stable-age-seconds", type=int, default=120)
        cmd.add_argument("--raw-dir", default=str(DEFAULT_LOCAL_RAW_DIR))
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    if args.command == "scan":
        result = scan_local_videos(
            inbox_dir=args.inbox_dir,
            manifest_path=args.manifest,
            stable_age_seconds=args.stable_age_seconds,
        )
    elif args.command == "process-one":
        scan_local_videos(
            inbox_dir=args.inbox_dir,
            manifest_path=args.manifest,
            stable_age_seconds=args.stable_age_seconds,
        )
        result = process_one_ready_video(manifest_path=args.manifest, raw_dir=args.raw_dir)
    else:
        result = manifest_status(manifest_path=args.manifest)
    sys.stdout.write(json.dumps(result, ensure_ascii=False, indent=2) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
