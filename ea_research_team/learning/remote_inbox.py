from __future__ import annotations

import hashlib
import json
import re
import shutil
from collections import Counter
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any, Callable

from local_evidence_intake import DEFAULT_LOCAL_RAW_DIR, import_local_evidence


TH_TZ = timezone(timedelta(hours=7))
INBOX_CATEGORIES = {
    "text": "text",
    "images": "images",
    "videos": "videos",
    "urls": "urls",
}
MANIFEST_NAME = "remote_inbox_manifest.json"
Importer = Callable[..., dict[str, Any]]


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")


def _safe_slug(value: str) -> str:
    slug = re.sub(r"[^A-Za-z0-9à¸-à¹™_-]+", "_", value.strip())
    slug = re.sub(r"_+", "_", slug).strip("_")
    return slug[:80] or "remote_evidence"


def ensure_inbox_folders(inbox_root: str | Path) -> dict[str, Path]:
    root = Path(inbox_root)
    folders = {
        "root": root,
        "inbox": root / "inbox",
        "text": root / "inbox" / "text",
        "images": root / "inbox" / "images",
        "videos": root / "inbox" / "videos",
        "urls": root / "inbox" / "urls",
        "processing": root / "processing",
        "processed": root / "processed",
        "failed": root / "failed",
    }
    for folder in folders.values():
        folder.mkdir(parents=True, exist_ok=True)
    return folders


def _manifest_path(inbox_root: Path) -> Path:
    return inbox_root / MANIFEST_NAME


def _load_manifest(path: Path) -> dict[str, Any]:
    if not path.exists():
        return {"version": 1, "items": {}}
    return json.loads(path.read_text(encoding="utf-8"))


def _save_manifest(path: Path, manifest: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(path.suffix + ".tmp")
    tmp.write_text(json.dumps(manifest, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
    tmp.replace(path)


def _file_fingerprint(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def _iter_inbox_files(root: Path) -> list[tuple[str, Path]]:
    files: list[tuple[str, Path]] = []
    for category in sorted(INBOX_CATEGORIES):
        folder = root / "inbox" / category
        if folder.exists():
            files.extend((category, path) for path in sorted(folder.iterdir()) if path.is_file())
    return files


def _count_files_by_category(root: Path, base_name: str) -> dict[str, int]:
    counts = {category: 0 for category in INBOX_CATEGORIES}
    total = 0
    for category in sorted(INBOX_CATEGORIES):
        folder = root / base_name / category
        if not folder.exists():
            continue
        count = len([path for path in folder.iterdir() if path.is_file()])
        counts[category] = count
        total += count
    return {"total": total, **counts}


def get_remote_inbox_status(
    inbox_root: str | Path,
    *,
    raw_dir: str | Path = DEFAULT_LOCAL_RAW_DIR,
) -> dict[str, Any]:
    root = Path(inbox_root)
    folders = ensure_inbox_folders(root)
    manifest_path = _manifest_path(root)
    manifest = _load_manifest(manifest_path)
    manifest_statuses = Counter(
        str(item.get("status", "unknown"))
        for item in manifest.get("items", {}).values()
    )

    return {
        "root": str(root),
        "exists": root.exists(),
        "raw_dir": str(Path(raw_dir)),
        "manifest_path": str(manifest_path),
        "manifest_exists": manifest_path.exists(),
        "folders": {key: str(path) for key, path in folders.items()},
        "pending": _count_files_by_category(root, "inbox"),
        "processed": _count_files_by_category(root, "processed"),
        "failed": _count_files_by_category(root, "failed"),
        "manifest": {
            "total": len(manifest.get("items", {})),
            "imported": manifest_statuses.get("imported", 0),
            "failed": manifest_statuses.get("failed", 0),
            "skipped": manifest_statuses.get("skipped", 0),
        },
    }


def _unique_destination(base_dir: Path, category: str, source: Path) -> Path:
    target_dir = base_dir / category
    target_dir.mkdir(parents=True, exist_ok=True)
    candidate = target_dir / source.name
    if not candidate.exists():
        return candidate
    stem = source.stem
    suffix = source.suffix
    for index in range(2, 10_000):
        candidate = target_dir / f"{stem}_{index}{suffix}"
        if not candidate.exists():
            return candidate
    raise RuntimeError(f"Could not find unique destination for {source.name}")


def _move_to(base_dir: Path, category: str, source: Path) -> Path:
    destination = _unique_destination(base_dir, category, source)
    return Path(shutil.move(str(source), str(destination)))


def _read_url(path: Path) -> str:
    for line in path.read_text(encoding="utf-8").splitlines():
        stripped = line.strip()
        if stripped and not stripped.startswith("#"):
            return stripped
    raise ValueError("URL inbox file is empty")


def _write_url_note(path: Path, *, raw_dir: str | Path) -> dict[str, Any]:
    url = _read_url(path)
    url_id = hashlib.sha256(url.encode("utf-8")).hexdigest()[:12]
    output_dir = Path(raw_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    note_path = output_dir / f"{datetime.now(TH_TZ).strftime('%Y-%m-%d')}_{_safe_slug(path.stem)}_{url_id}.md"
    created = _now_iso()
    if not note_path.exists():
        note_path.write_text(
            "\n".join(
                [
                    "---",
                    "tags: [remote-inbox, raw-evidence, ea-knowledge-brain]",
                    f"source: {url}",
                    "source_type: remote_url",
                    f"video_id: {url_id}",
                    f"remote_evidence_id: {url_id}",
                    f"created: {created}",
                    "---",
                    "",
                    f"# {path.stem}",
                    "",
                    "## Source",
                    "",
                    f"- Remote URL: {url}",
                    f"- Inbox file: {path}",
                    f"- Imported At: {created}",
                    "",
                    "## Fact / Transcript Evidence",
                    "",
                    f"Remote URL queued for later learning: {url}",
                    "",
                    "## Interpretation",
                    "",
                    "_Pending structured extraction or URL-specific intake._",
                    "",
                    "## EA Rule Candidates",
                    "",
                    "_Pending structured extraction._",
                    "",
                    "## Quality Check",
                    "",
                    "- Text captured: yes",
                    "- Visual check required: unknown",
                    "- Ready for EA component extraction: no",
                    "",
                ]
            ),
            encoding="utf-8",
        )
    return {
        "status": "raw_evidence_written",
        "source_type": "remote_url",
        "source_path": str(path),
        "note_path": note_path,
        "raw_dir": str(output_dir),
        "text_captured": True,
        "remote_evidence_id": url_id,
    }


def _record_item(
    manifest: dict[str, Any],
    fingerprint: str,
    *,
    category: str,
    source_path: Path,
    status: str,
    result: dict[str, Any] | None = None,
    error: str | None = None,
    destination: Path | None = None,
) -> None:
    manifest["items"][fingerprint] = {
        "category": category,
        "source_path": str(source_path),
        "status": status,
        "destination": str(destination) if destination else None,
        "note_path": str(result.get("note_path")) if result and result.get("note_path") else None,
        "text_captured": bool(result.get("text_captured")) if result else False,
        "error": error,
        "updated_at": _now_iso(),
    }


def process_remote_inbox(
    inbox_root: str | Path,
    *,
    raw_dir: str | Path = DEFAULT_LOCAL_RAW_DIR,
    importer: Importer = import_local_evidence,
) -> dict[str, Any]:
    root = Path(inbox_root)
    ensure_inbox_folders(root)
    manifest_path = _manifest_path(root)
    manifest = _load_manifest(manifest_path)
    items = manifest.setdefault("items", {})

    result: dict[str, Any] = {
        "processed": 0,
        "imported": 0,
        "failed": 0,
        "skipped": 0,
        "manifest_path": str(manifest_path),
        "raw_dir": str(raw_dir),
        "items": [],
    }

    for category, source in _iter_inbox_files(root):
        result["processed"] += 1
        fingerprint = _file_fingerprint(source)
        existing = items.get(fingerprint)
        if existing and existing.get("status") in {"imported", "skipped"}:
            destination = _move_to(root / "processed", category, source)
            _record_item(
                manifest,
                fingerprint,
                category=category,
                source_path=source,
                status="skipped",
                destination=destination,
            )
            result["skipped"] += 1
            result["items"].append({"source_path": str(source), "status": "skipped"})
            continue

        try:
            if category == "urls":
                import_result = _write_url_note(source, raw_dir=raw_dir)
            else:
                import_result = importer(source, raw_dir=raw_dir)
            destination = _move_to(root / "processed", category, source)
            _record_item(
                manifest,
                fingerprint,
                category=category,
                source_path=source,
                status="imported",
                result=import_result,
                destination=destination,
            )
            result["imported"] += 1
            result["items"].append(
                {
                    "source_path": str(source),
                    "status": "imported",
                    "note_path": str(import_result.get("note_path")) if import_result.get("note_path") else None,
                }
            )
        except Exception as exc:
            destination = _move_to(root / "failed", category, source)
            _record_item(
                manifest,
                fingerprint,
                category=category,
                source_path=source,
                status="failed",
                error=str(exc),
                destination=destination,
            )
            result["failed"] += 1
            result["items"].append({"source_path": str(source), "status": "failed", "error": str(exc)})

    _save_manifest(manifest_path, manifest)
    return result
