from __future__ import annotations

import json
from pathlib import Path

import channel_intake
from remote_inbox import (
    ensure_inbox_folders,
    process_remote_inbox,
)


def test_ensure_inbox_folders_creates_expected_layout(tmp_path):
    root = tmp_path / "EA-Knowledge-Brain"

    folders = ensure_inbox_folders(root)

    expected = {
        root / "inbox" / "text",
        root / "inbox" / "images",
        root / "inbox" / "videos",
        root / "inbox" / "urls",
        root / "processing",
        root / "processed",
        root / "failed",
    }
    assert expected.issubset(set(folders.values()))
    for folder in expected:
        assert folder.is_dir()


def test_process_remote_inbox_empty_state_is_safe(tmp_path):
    root = tmp_path / "drive"
    raw_dir = tmp_path / "raw"

    result = process_remote_inbox(root, raw_dir=raw_dir)

    assert result["processed"] == 0
    assert result["imported"] == 0
    assert result["failed"] == 0
    assert result["skipped"] == 0
    assert Path(result["manifest_path"]).exists()


def test_process_remote_inbox_imports_text_file_into_local_raw(tmp_path):
    root = tmp_path / "drive"
    raw_dir = tmp_path / "raw"
    ensure_inbox_folders(root)
    source = root / "inbox" / "text" / "market_note.txt"
    source.write_text("London session liquidity sweep rule", encoding="utf-8")

    result = process_remote_inbox(root, raw_dir=raw_dir)

    assert result["processed"] == 1
    assert result["imported"] == 1
    assert result["failed"] == 0
    notes = list(raw_dir.glob("*.md"))
    assert len(notes) == 1
    assert "London session liquidity sweep rule" in notes[0].read_text(encoding="utf-8")
    assert not source.exists()
    assert (root / "processed" / "text" / "market_note.txt").exists()


def test_process_remote_inbox_passes_video_to_local_importer(tmp_path):
    root = tmp_path / "drive"
    raw_dir = tmp_path / "raw"
    ensure_inbox_folders(root)
    source = root / "inbox" / "videos" / "setup.mp4"
    source.write_bytes(b"fake mp4")
    calls: list[Path] = []

    def fake_importer(source_path, **kwargs):
        calls.append(Path(source_path))
        note = Path(kwargs["raw_dir"]) / "video_note.md"
        note.parent.mkdir(parents=True, exist_ok=True)
        note.write_text("video note", encoding="utf-8")
        return {
            "status": "raw_evidence_written",
            "note_path": note,
            "text_captured": True,
            "local_evidence_id": "vid123",
            "source_type": "local_video",
        }

    result = process_remote_inbox(root, raw_dir=raw_dir, importer=fake_importer)

    assert result["processed"] == 1
    assert result["imported"] == 1
    assert calls == [source]
    assert (root / "processed" / "videos" / "setup.mp4").exists()


def test_process_remote_inbox_records_url_file_as_local_raw_note(tmp_path):
    root = tmp_path / "drive"
    raw_dir = tmp_path / "raw"
    ensure_inbox_folders(root)
    source = root / "inbox" / "urls" / "video.url"
    source.write_text("https://www.youtube.com/watch?v=abc123\n", encoding="utf-8")

    result = process_remote_inbox(root, raw_dir=raw_dir)

    assert result["processed"] == 1
    assert result["imported"] == 1
    notes = list(raw_dir.glob("*.md"))
    assert len(notes) == 1
    content = notes[0].read_text(encoding="utf-8")
    assert "remote_url" in content
    assert "https://www.youtube.com/watch?v=abc123" in content
    assert (root / "processed" / "urls" / "video.url").exists()


def test_process_remote_inbox_does_not_duplicate_same_file_on_rerun(tmp_path):
    root = tmp_path / "drive"
    raw_dir = tmp_path / "raw"
    ensure_inbox_folders(root)
    source = root / "inbox" / "text" / "same.txt"
    source.write_text("same evidence", encoding="utf-8")

    first = process_remote_inbox(root, raw_dir=raw_dir)
    ensure_inbox_folders(root)
    source.write_text("same evidence", encoding="utf-8")
    second = process_remote_inbox(root, raw_dir=raw_dir)

    assert first["imported"] == 1
    assert second["processed"] == 1
    assert second["skipped"] == 1
    assert len(list(raw_dir.glob("*.md"))) == 1


def test_process_remote_inbox_moves_failed_file_with_reason(tmp_path):
    root = tmp_path / "drive"
    raw_dir = tmp_path / "raw"
    ensure_inbox_folders(root)
    source = root / "inbox" / "text" / "bad.txt"
    source.write_text("bad evidence", encoding="utf-8")

    def failing_importer(source_path, **kwargs):
        raise RuntimeError("import failed")

    result = process_remote_inbox(root, raw_dir=raw_dir, importer=failing_importer)

    assert result["processed"] == 1
    assert result["failed"] == 1
    failed_file = root / "failed" / "text" / "bad.txt"
    assert failed_file.exists()
    manifest = json.loads(Path(result["manifest_path"]).read_text(encoding="utf-8"))
    record = next(iter(manifest["items"].values()))
    assert record["status"] == "failed"
    assert record["error"] == "import failed"


def test_process_inbox_cli_emits_json(monkeypatch, tmp_path, capsys):
    root = tmp_path / "drive"
    raw_dir = tmp_path / "raw"

    def fake_process(inbox_root, **kwargs):
        assert Path(inbox_root) == root
        assert Path(kwargs["raw_dir"]) == raw_dir
        return {
            "processed": 1,
            "imported": 1,
            "failed": 0,
            "skipped": 0,
            "manifest_path": str(root / "remote_inbox_manifest.json"),
        }

    monkeypatch.setattr(channel_intake, "process_remote_inbox", fake_process)

    exit_code = channel_intake.main(
        [
            "process-inbox",
            "--inbox-root",
            str(root),
            "--raw-dir",
            str(raw_dir),
        ]
    )

    assert exit_code == 0
    payload = json.loads(capsys.readouterr().out)
    assert payload["processed"] == 1
    assert payload["imported"] == 1
