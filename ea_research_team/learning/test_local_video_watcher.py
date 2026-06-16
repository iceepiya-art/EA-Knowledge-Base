import json
from datetime import datetime, timezone
from pathlib import Path

import local_video_watcher as watcher


def _write_video(path: Path, content: bytes = b"video") -> Path:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(content)
    return path


def test_scan_marks_old_stable_video_ready(tmp_path):
    inbox = tmp_path / "YT_Downloads"
    video = _write_video(inbox / "lesson.mp4", b"abc")
    manifest_path = tmp_path / "manifest.json"

    result = watcher.scan_local_videos(
        inbox_dir=inbox,
        manifest_path=manifest_path,
        stable_age_seconds=0,
    )

    assert result["ready"] == 1
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    record = next(iter(manifest["files"].values()))
    assert record["status"] == "ready"
    assert record["path"] == str(video)
    assert record["sha256"]


def test_scan_marks_video_downloading_when_temp_file_exists(tmp_path):
    inbox = tmp_path / "YT_Downloads"
    _write_video(inbox / "lesson.mp4", b"abc")
    (inbox / "lesson.mp4.tmp").write_bytes(b"partial")
    manifest_path = tmp_path / "manifest.json"

    result = watcher.scan_local_videos(
        inbox_dir=inbox,
        manifest_path=manifest_path,
        stable_age_seconds=0,
    )

    assert result["downloading"] == 1
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    record = next(iter(manifest["files"].values()))
    assert record["status"] == "downloading"
    assert "temporary download file" in record["reason"]


def test_scan_marks_duplicate_by_hash_without_relearning(tmp_path):
    inbox = tmp_path / "YT_Downloads"
    first = _write_video(inbox / "a.mp4", b"same")
    second = _write_video(inbox / "b.mp4", b"same")
    manifest_path = tmp_path / "manifest.json"
    first_hash = watcher.sha256_file(first)
    manifest_path.write_text(
        json.dumps(
            {
                "version": 1,
                "files": {
                    "old": {
                        "path": str(first),
                        "sha256": first_hash,
                        "status": "learned",
                        "updated_at": datetime.now(timezone.utc).isoformat(),
                    }
                },
            }
        ),
        encoding="utf-8",
    )

    result = watcher.scan_local_videos(
        inbox_dir=inbox,
        manifest_path=manifest_path,
        stable_age_seconds=0,
    )

    assert result["duplicate"] == 1
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    duplicate = [item for item in manifest["files"].values() if item["path"] == str(second)][0]
    assert duplicate["status"] == "duplicate"
    assert duplicate["duplicate_of"] == str(first)


def test_process_one_imports_single_ready_video_and_marks_learned(tmp_path):
    inbox = tmp_path / "YT_Downloads"
    video = _write_video(inbox / "lesson.mp4", b"abc")
    other = _write_video(inbox / "other.mp4", b"def")
    manifest_path = tmp_path / "manifest.json"
    calls = []

    def importer(path, **kwargs):
        calls.append((Path(path), kwargs))
        return {
            "status": "raw_evidence_written",
            "note_path": str(tmp_path / "raw" / "note.md"),
            "local_evidence_id": "abc123",
            "text_captured": True,
        }

    watcher.scan_local_videos(
        inbox_dir=inbox,
        manifest_path=manifest_path,
        stable_age_seconds=0,
    )
    result = watcher.process_one_ready_video(
        manifest_path=manifest_path,
        importer=importer,
    )

    assert result["status"] == "learned"
    assert len(calls) == 1
    assert calls[0][0] in {video, other}
    assert calls[0][1]["raw_dir"] == watcher.DEFAULT_LOCAL_RAW_DIR
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    learned = [item for item in manifest["files"].values() if item["status"] == "learned"]
    ready = [item for item in manifest["files"].values() if item["status"] == "ready"]
    assert len(learned) == 1
    assert len(ready) == 1
