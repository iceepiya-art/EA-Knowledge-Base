import os
import json
import pytest
from pathlib import Path
from unittest.mock import MagicMock, patch

import download_pending_videos
from channel_manifest import ChannelManifestStore
from download_pending_videos import select_pending_videos, sort_pending_videos, run_download_and_transcribe


@pytest.fixture(autouse=True)
def isolate_download_status_file(tmp_path, monkeypatch):
    monkeypatch.setattr(download_pending_videos, "STATUS_FILE", tmp_path / "download_status.json")


def test_sort_pending_videos_prioritizes_known_short_duration():
    videos = [
        {"video_id": "long", "title": "Long Setup", "duration": 3700},
        {"video_id": "medium", "title": "Medium Setup", "duration": 2552},
        {"video_id": "missing", "title": "Unknown Duration"},
        {"video_id": "short", "title": "Short Setup", "duration": 454},
        {"video_id": "live", "title": "Live Market Replay", "duration": 120},
    ]

    sorted_ids = [video["video_id"] for video in sort_pending_videos(videos)]

    assert sorted_ids == ["short", "medium", "missing", "long", "live"]


def test_select_pending_videos_max_duration_keeps_only_known_short_videos():
    videos = [
        {"video_id": "short", "title": "Short Setup", "duration": 300},
        {"video_id": "too_long", "title": "Long Setup", "duration": 700},
        {"video_id": "missing", "title": "Unknown Duration"},
    ]

    selected_ids = [
        video["video_id"]
        for video in select_pending_videos(videos, limit=5, max_duration=600)
    ]

    assert selected_ids == ["short"]


def test_select_pending_videos_deprioritizes_recent_transcription_failures():
    videos = [
        {
            "video_id": "failed_short",
            "title": "Failed Short Setup",
            "duration": 37,
            "failure_reason": "transcription_failed",
        },
        {"video_id": "clean_short", "title": "Clean Short Setup", "duration": 120},
    ]

    selected_ids = [
        video["video_id"]
        for video in select_pending_videos(videos, limit=1, max_duration=600)
    ]

    assert selected_ids == ["clean_short"]


def test_select_pending_videos_retries_rate_limited_before_empty_transcript_failures():
    videos = [
        {
            "video_id": "empty_transcript",
            "title": "Empty Transcript",
            "duration": 37,
            "failure_reason": "transcription_failed",
        },
        {
            "video_id": "rate_limited",
            "title": "Rate Limited",
            "duration": 125,
            "failure_reason": "rate_limited",
        },
        {
            "video_id": "no_transcript",
            "title": "No Transcript",
            "duration": 81,
            "failure_reason": "no_transcript",
        },
    ]

    selected_ids = [
        video["video_id"]
        for video in select_pending_videos(videos, limit=1, max_duration=600)
    ]

    assert selected_ids == ["rate_limited"]

def test_download_pending_videos_calls_ytdlp_and_whisper(tmp_path):
    # Set up temp manifest
    manifest_path = tmp_path / "channel_manifest.json"
    store = ChannelManifestStore(manifest_path)
    
    # Record a scan with a video needing check
    store.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@test",
        videos=[
            {
                "video_id": "v001",
                "title": "SMC Entry Strategy",
                "url": "https://www.youtube.com/watch?v=v001",
                "published": "2026-01-01"
            }
        ]
    )
    # Set status to needs_transcript_check
    store.update_video_status("v001", "needs_transcript_check")
    
    # Mock subprocess.run for yt-dlp
    mock_proc = MagicMock()
    mock_proc.returncode = 0
    mock_proc.stdout = b""
    mock_proc.stderr = b""
    
    # Mock import_local_evidence
    mock_import_result = {
        "status": "raw_evidence_written",
        "source_type": "local_video",
        "source_path": "fake_path",
        "text_source": "auto_transcription",
        "note_path": tmp_path / "note_v001.md",
        "text_captured": True,
        "local_evidence_id": "v001_id"
    }
    
    # Write a fake note so rename/replace/file read does not crash
    note_file = tmp_path / "note_v001.md"
    note_file.write_text(
        "---\ntags: [local-evidence, raw-evidence, ea-knowledge-brain]\nsource: fake_path\nsource_type: local_video\nvideo_id: v001_id\n---\n## Fact / Transcript Evidence\nSome text captured.",
        encoding="utf-8"
    )
    
    # Custom patch for os.path.exists and glob to simulate file being created by yt-dlp
    original_exists = os.path.exists
    def mock_exists(p):
        if str(p).endswith("v001.mp4"):
            return True
        return original_exists(p)
    
    with patch("subprocess.run", return_value=mock_proc) as mock_run, \
         patch("download_pending_videos.import_local_evidence", return_value=mock_import_result) as mock_import, \
         patch("os.path.exists", mock_exists), \
         patch("time.sleep") as mock_sleep:
         
        # Run download script
        run_download_and_transcribe(manifest_path=manifest_path, limit=1)
        
        # Verify subprocess.run arguments
        assert mock_run.call_count == 1
        args = mock_run.call_args[0][0]
        assert "yt-dlp" in args
        assert "-f" in args
        assert "best[ext=mp4]/best" in args
        assert any(str(arg).endswith("v001.mp4") for arg in args)
        
        # Verify import_local_evidence call
        assert mock_import.call_count == 1
        
        # Verify manifest update
        manifest = store.load()
        video = manifest["videos"]["v001"]
        assert video["status"] == "raw_evidence_written"
        assert video["transcript_hash"] == "v001_id"
        
        # Verify file content updates
        note_content = note_file.read_text(encoding="utf-8")
        assert "source_type: youtube" in note_content
        assert "tags: [youtube" in note_content
        assert "source: https://www.youtube.com/watch?v=v001" in note_content
        assert "video_id: v001" in note_content

def test_download_pending_videos_auto_pipeline_trigger(tmp_path):
    manifest_path = tmp_path / "channel_manifest.json"
    store = ChannelManifestStore(manifest_path)
    store.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@test",
        videos=[{"video_id": "v002", "title": "B", "url": "https://youtu.be/v002"}]
    )
    store.update_video_status("v002", "needs_transcript_check")
    
    mock_proc = MagicMock()
    mock_proc.returncode = 0
    
    mock_import_result = {
        "status": "raw_evidence_written",
        "source_type": "local_video",
        "note_path": tmp_path / "note_v002.md",
        "text_captured": True,
        "local_evidence_id": "v002_id"
    }
    
    note_file = tmp_path / "note_v002.md"
    note_file.write_text(
        "---\ntags: [local-evidence]\nsource: p\nsource_type: local_video\nvideo_id: id\n---\n## Fact / Transcript Evidence\nSome text.",
        encoding="utf-8"
    )
    
    original_exists = os.path.exists
    def mock_exists(p):
        if str(p).endswith("v002.mp4"):
            return True
        return original_exists(p)
    
    # Mock requests post/get for pipeline trigger
    mock_response_post = MagicMock()
    mock_response_post.status_code = 200
    
    mock_response_get = MagicMock()
    mock_response_get.status_code = 200
    mock_response_get.json.return_value = {"running": False, "error": None}
    
    with patch("subprocess.run", return_value=mock_proc), \
         patch("download_pending_videos.import_local_evidence", return_value=mock_import_result) as mock_import, \
         patch("os.path.exists", mock_exists), \
         patch("time.sleep"), \
         patch("requests.post", return_value=mock_response_post) as mock_post, \
         patch("requests.get", return_value=mock_response_get) as mock_get:
         
        run_download_and_transcribe(manifest_path=manifest_path, limit=1, auto_pipeline=True)
        
        # Verify requests triggered API
        assert mock_post.call_count == 1
        assert "run-pipeline" in mock_post.call_args[0][0]
        assert mock_get.call_count == 1
        assert "pipeline-status" in mock_get.call_args[0][0]


def test_download_pending_videos_records_empty_transcript_error_and_skips_pipeline(tmp_path):
    manifest_path = tmp_path / "channel_manifest.json"
    store = ChannelManifestStore(manifest_path)
    store.record_scan(
        channel_id="UC123",
        channel_name="Test Channel",
        channel_url="https://www.youtube.com/@test",
        videos=[{"video_id": "v003", "title": "C", "url": "https://youtu.be/v003"}],
    )
    store.update_video_status("v003", "needs_transcript_check")

    mock_proc = MagicMock()
    mock_proc.returncode = 0
    mock_proc.stdout = b""
    mock_proc.stderr = b""

    mock_import_result = {
        "status": "needs_text",
        "source_type": "local_video",
        "note_path": str(tmp_path / "note_v003.md"),
        "text_captured": False,
        "local_evidence_id": "v003_id",
        "transcription_error": "Automatic video transcription unavailable: _transcribe_with_gemini: API key not valid",
    }

    original_exists = os.path.exists

    def mock_exists(p):
        if str(p).endswith("v003.mp4"):
            return True
        return original_exists(p)

    with patch("subprocess.run", return_value=mock_proc), \
         patch("download_pending_videos.import_local_evidence", return_value=mock_import_result), \
         patch("os.path.exists", mock_exists), \
         patch("requests.post") as mock_post, \
         patch("download_pending_videos._run_pipeline_locally") as mock_local_pipeline, \
         patch("time.sleep"):
        run_download_and_transcribe(manifest_path=manifest_path, limit=1, auto_pipeline=True)

    video = store.load()["videos"]["v003"]
    assert video["status"] == "needs_transcript_check"
    assert video["failure_reason"] == "transcription_failed"
    assert "API key not valid" in video["error"]
    assert mock_post.call_count == 0
    assert mock_local_pipeline.call_count == 0
