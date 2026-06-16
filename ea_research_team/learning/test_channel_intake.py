import pytest
import json
import io
import sys

from channel_intake import _emit_json, learn_new_videos, main, scan_channel
from channel_manifest import ChannelManifestStore
from youtube_channel_learning import (
    CookieInvalidError,
    CookieMissingError,
    NoTranscriptAvailableError,
    RateLimitedError,
)


def test_scan_channel_records_inventory_and_skips_seen_videos(tmp_path):
    store = ChannelManifestStore(tmp_path / "channel_manifest.json")

    def fake_fetcher(channel_url):
        assert channel_url == "https://www.youtube.com/@RealTradingChannel"
        return {
            "channel_id": "UC123",
            "channel_name": "Test Channel",
            "channel_url": channel_url,
            "videos": [
                {
                    "video_id": "v001",
                    "title": "First",
                    "url": "https://www.youtube.com/watch?v=v001",
                    "published": "2026-01-01",
                },
                {
                    "video_id": "v002",
                    "title": "Second",
                    "url": "https://www.youtube.com/watch?v=v002",
                    "published": "2026-01-02",
                },
            ],
        }

    first = scan_channel("https://www.youtube.com/@RealTradingChannel", store=store, fetcher=fake_fetcher)
    second = scan_channel("https://www.youtube.com/@RealTradingChannel", store=store, fetcher=fake_fetcher)

    assert first["new"] == 2
    assert first["duplicates"] == 0
    assert second["new"] == 0
    assert second["duplicates"] == 2
    assert second["status_counts"] == {"discovered": 2}


def test_scan_channel_reports_manifest_path(tmp_path):
    manifest_path = tmp_path / "custom_manifest.json"
    store = ChannelManifestStore(manifest_path)

    def fake_fetcher(channel_url):
        return {
            "channel_id": "UC999",
            "channel_name": "Empty Channel",
            "channel_url": channel_url,
            "videos": [],
        }

    result = scan_channel("https://www.youtube.com/@empty", store=store, fetcher=fake_fetcher)

    assert result["manifest_path"] == str(manifest_path)
    assert result["scanned"] == 0


def test_scan_channel_rejects_placeholder_channel_url(tmp_path):
    store = ChannelManifestStore(tmp_path / "channel_manifest.json")

    with pytest.raises(ValueError, match="real YouTube channel URL"):
        scan_channel("https://www.youtube.com/@CHANNEL", store=store)


def test_learn_new_videos_writes_raw_evidence_and_updates_manifest(tmp_path):
    store = ChannelManifestStore(tmp_path / "channel_manifest.json")
    store.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@RealTradingChannel",
        videos=[
            {
                "video_id": "v001",
                "title": "Pattern W Setup",
                "url": "https://www.youtube.com/watch?v=v001",
                "published": "2026-01-01",
            }
        ],
    )

    def fake_transcript_fetcher(video):
        assert video["video_id"] == "v001"
        return {
            "text": "Wait for liquidity sweep, confirm CHoCH, then enter Pattern W setup.",
            "language": "en",
        }

    result = learn_new_videos(
        store=store,
        transcript_fetcher=fake_transcript_fetcher,
        raw_dir=tmp_path / "raw" / "youtube",
    )

    manifest = store.load()
    video = manifest["videos"]["v001"]
    note_path = tmp_path / "raw" / "youtube" / "2026-01-01_v001.md"

    assert result["processed"] == 1
    assert result["written"] == 1
    assert result["skipped"] == 0
    assert video["status"] == "raw_evidence_written"
    assert video["transcript_hash"]
    assert video["note_paths"] == [str(note_path)]
    assert note_path.exists()
    assert "Pattern W Setup" in note_path.read_text(encoding="utf-8")
    assert "Fact / Transcript Evidence" in note_path.read_text(encoding="utf-8")


def test_learn_new_videos_skips_written_videos_on_second_run(tmp_path):
    store = ChannelManifestStore(tmp_path / "channel_manifest.json")
    store.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@RealTradingChannel",
        videos=[
            {
                "video_id": "v001",
                "title": "Pattern W Setup",
                "url": "https://www.youtube.com/watch?v=v001",
                "published": "2026-01-01",
            }
        ],
    )

    calls = {"count": 0}

    def fake_transcript_fetcher(video):
        calls["count"] += 1
        return {"text": "Transcript text", "language": "en"}

    first = learn_new_videos(
        store=store,
        transcript_fetcher=fake_transcript_fetcher,
        raw_dir=tmp_path / "raw" / "youtube",
    )
    second = learn_new_videos(
        store=store,
        transcript_fetcher=fake_transcript_fetcher,
        raw_dir=tmp_path / "raw" / "youtube",
    )

    assert first["written"] == 1
    assert second["processed"] == 0
    assert second["skipped"] == 0
    assert calls["count"] == 1


def test_learn_new_videos_marks_missing_transcript_without_stopping(tmp_path):
    store = ChannelManifestStore(tmp_path / "channel_manifest.json")
    store.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@RealTradingChannel",
        videos=[
            {"video_id": "v001", "title": "No Transcript", "url": "https://youtu.be/v001"},
            {"video_id": "v002", "title": "Has Transcript", "url": "https://youtu.be/v002"},
        ],
    )

    def fake_transcript_fetcher(video):
        if video["video_id"] == "v001":
            raise RuntimeError("transcript unavailable")
        return {"text": "Good transcript", "language": "en"}

    result = learn_new_videos(
        store=store,
        transcript_fetcher=fake_transcript_fetcher,
        raw_dir=tmp_path / "raw" / "youtube",
    )

    manifest = store.load()
    assert result["processed"] == 2
    assert result["written"] == 1
    assert result["failed"] == 1
    assert manifest["videos"]["v001"]["status"] == "needs_transcript_check"
    assert "transcript unavailable" in manifest["videos"]["v001"]["error"]
    assert manifest["videos"]["v002"]["status"] == "raw_evidence_written"


def test_learn_new_videos_can_retry_needs_transcript_check(tmp_path):
    store = ChannelManifestStore(tmp_path / "channel_manifest.json")
    store.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@RealTradingChannel",
        videos=[
            {"video_id": "v001", "title": "Retry Me", "url": "https://youtu.be/v001"},
        ],
    )
    store.update_video_status("v001", "needs_transcript_check", error="old error")

    result = learn_new_videos(
        store=store,
        transcript_fetcher=lambda video: {"text": "CHoCH entry with stop loss below wick.", "language": "en"},
        raw_dir=tmp_path / "raw" / "youtube",
        retry_needs_check=True,
    )

    assert result["processed"] == 1
    assert result["written"] == 1
    assert store.load()["videos"]["v001"]["status"] == "raw_evidence_written"


def test_extract_raw_cli_writes_structured_output(tmp_path):
    raw_dir = tmp_path / "raw" / "youtube"
    raw_dir.mkdir(parents=True)
    raw_note = raw_dir / "2026-01-01_v001.md"
    raw_note.write_text(
        "\n".join(
            [
                "---",
                "video_id: v001",
                "source: https://youtu.be/v001",
                "---",
                "",
                "# FVG Entry Model",
                "",
                "## Fact / Transcript Evidence",
                "",
                "Use FVG retest with CHoCH confirmation for entry.",
            ]
        ),
        encoding="utf-8",
    )
    output_path = tmp_path / "structured_extractions.json"

    exit_code = main(
        [
            "extract-raw",
            "--raw-dir",
            str(raw_dir),
            "--output",
            str(output_path),
        ]
    )

    assert exit_code == 0
    assert output_path.exists()


def test_merge_knowledge_cli_writes_index_and_log(tmp_path):
    structured_path = tmp_path / "structured_extractions.json"
    index_path = tmp_path / "knowledge_index.json"
    log_path = tmp_path / "knowledge_merge_log.json"
    structured_path.write_text(
        json.dumps(
            {
                "version": 1,
                "items": {
                    "v001": {
                        "video_id": "v001",
                        "url": "https://youtu.be/v001",
                        "title": "FVG Setup",
                        "concepts": ["FVG"],
                        "quality": {"ea_readiness": 80, "rule_completeness": 75},
                        "ea_rule_candidates": {"entry": ["FVG retest"]},
                    }
                },
            }
        ),
        encoding="utf-8",
    )

    exit_code = main(
        [
            "merge-knowledge",
            "--structured",
            str(structured_path),
            "--index",
            str(index_path),
            "--log",
            str(log_path),
        ]
    )

    assert exit_code == 0
    assert index_path.exists()
    assert log_path.exists()


def test_write_concepts_cli_creates_obsidian_notes(tmp_path):
    index_path = tmp_path / "knowledge_index.json"
    output_dir = tmp_path / "concepts"
    index_path.write_text(
        json.dumps(
            {
                "version": 1,
                "concepts": {
                    "FVG": {
                        "concept": "FVG",
                        "confidence": 75,
                        "evidence_count": 1,
                        "related_rule_types": ["entry", "exit"],
                        "sources": ["v001"],
                        "source_details": [
                            {
                                "video_id": "v001",
                                "title": "FVG Setup",
                                "url": "https://youtu.be/v001",
                                "ea_readiness": 75,
                                "rule_completeness": 68,
                                "merged_at": "2026-05-24T10:21:42+07:00",
                            }
                        ],
                        "last_updated": "2026-05-24T10:21:42+07:00",
                    }
                },
            }
        ),
        encoding="utf-8",
    )

    exit_code = main(
        [
            "write-concepts",
            "--index",
            str(index_path),
            "--output-dir",
            str(output_dir),
        ]
    )

    assert exit_code == 0
    assert (output_dir / "FVG.md").exists()
    content = (output_dir / "FVG.md").read_text(encoding="utf-8")
    assert "FVG" in content


def test_emit_json_falls_back_to_ascii_when_stdout_encoding_cannot_print_thai(monkeypatch):
    buffer = io.BytesIO()
    stdout = io.TextIOWrapper(buffer, encoding="cp1252")
    monkeypatch.setattr(sys, "stdout", stdout)

    _emit_json({"path": "C:\\Users\\ADMIN\\Downloads\\รูปภาพ.png"})
    stdout.flush()

    output = buffer.getvalue().decode("cp1252")
    assert "\\u0e23\\u0e39\\u0e1b" in output


# ---------------------------------------------------------------------------
# Reason-coded transcript failure tests (ORCA — tests written before impl)
# ---------------------------------------------------------------------------


def _make_store_with_videos(tmp_path, video_ids):
    store = ChannelManifestStore(tmp_path / "channel_manifest.json")
    store.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@RealTradingChannel",
        videos=[
            {"video_id": vid, "title": f"Video {vid}", "url": f"https://youtu.be/{vid}"}
            for vid in video_ids
        ],
    )
    return store


def test_learn_new_videos_stores_rate_limited_reason(tmp_path):
    store = _make_store_with_videos(tmp_path, ["v001"])

    def fetcher(video):
        raise RateLimitedError("YouTube IP block")

    learn_new_videos(
        store=store,
        transcript_fetcher=fetcher,
        raw_dir=tmp_path / "raw",
    )

    video = store.load()["videos"]["v001"]
    assert video["status"] == "needs_transcript_check"
    assert video.get("failure_reason") == "rate_limited"


def test_learn_new_videos_stores_cookie_missing_reason(tmp_path):
    store = _make_store_with_videos(tmp_path, ["v001"])

    def fetcher(video):
        raise CookieMissingError("no cookies file")

    learn_new_videos(
        store=store,
        transcript_fetcher=fetcher,
        raw_dir=tmp_path / "raw",
    )

    video = store.load()["videos"]["v001"]
    assert video["status"] == "needs_transcript_check"
    assert video.get("failure_reason") == "cookie_missing"


def test_learn_new_videos_stores_cookie_invalid_reason(tmp_path):
    store = _make_store_with_videos(tmp_path, ["v001"])

    def fetcher(video):
        raise CookieInvalidError("cookie load error")

    learn_new_videos(
        store=store,
        transcript_fetcher=fetcher,
        raw_dir=tmp_path / "raw",
    )

    video = store.load()["videos"]["v001"]
    assert video["status"] == "needs_transcript_check"
    assert video.get("failure_reason") == "cookie_invalid"


def test_learn_new_videos_stores_no_transcript_reason(tmp_path):
    store = _make_store_with_videos(tmp_path, ["v001"])

    def fetcher(video):
        raise NoTranscriptAvailableError("no subtitles")

    learn_new_videos(
        store=store,
        transcript_fetcher=fetcher,
        raw_dir=tmp_path / "raw",
    )

    video = store.load()["videos"]["v001"]
    assert video["status"] == "needs_transcript_check"
    assert video.get("failure_reason") == "no_transcript"


def test_learn_new_videos_stores_unknown_error_reason(tmp_path):
    store = _make_store_with_videos(tmp_path, ["v001"])

    def fetcher(video):
        raise RuntimeError("unexpected network failure")

    learn_new_videos(
        store=store,
        transcript_fetcher=fetcher,
        raw_dir=tmp_path / "raw",
    )

    video = store.load()["videos"]["v001"]
    assert video["status"] == "needs_transcript_check"
    assert video.get("failure_reason") == "unknown_error"


def test_learn_new_videos_retry_does_not_duplicate_raw_note(tmp_path):
    """Re-running retry on a video that succeeds second time must not create two notes."""
    store = _make_store_with_videos(tmp_path, ["v001"])
    store.update_video_status("v001", "needs_transcript_check", error="old error")

    call_count = {"n": 0}

    def fetcher(video):
        call_count["n"] += 1
        return {"text": "Transcript text here.", "language": "en"}

    learn_new_videos(
        store=store,
        transcript_fetcher=fetcher,
        raw_dir=tmp_path / "raw" / "youtube",
        retry_needs_check=True,
    )
    # Second retry — note already written, file must not be duplicated
    learn_new_videos(
        store=store,
        transcript_fetcher=fetcher,
        raw_dir=tmp_path / "raw" / "youtube",
        retry_needs_check=True,
    )

    notes = list((tmp_path / "raw" / "youtube").glob("*.md"))
    assert len(notes) == 1
    # fetcher called exactly once (second run: video is raw_evidence_written, not retried again)
    assert call_count["n"] == 1
