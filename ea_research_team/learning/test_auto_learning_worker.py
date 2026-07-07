from __future__ import annotations

from pathlib import Path
from unittest.mock import Mock

from auto_learning_worker import AutoLearningWorker, WorkerConfig


class FakeApi:
    def __init__(self) -> None:
        self.posts: list[tuple[str, dict]] = []
        self.pipeline_running = False
        self.download_running = False
        self.inbox_pending = 0
        self.needs_check = 0

    def get(self, path: str) -> dict:
        if path == "/pipeline-status":
            return {"running": self.pipeline_running, "error": None}
        if path == "/download-status":
            return {"running": self.download_running, "status": "Completed"}
        if path == "/remote-inbox/status":
            return {"pending": {"total": self.inbox_pending}}
        if path == "/youtube-sources":
            return {"summary": {"needs_check": self.needs_check}}
        raise AssertionError(path)

    def post(self, path: str, body: dict | None = None) -> dict:
        self.posts.append((path, body or {}))
        return {"imported": self.inbox_pending, "pipeline": "started"}


def test_tick_processes_remote_inbox_before_youtube_download(tmp_path):
    api = FakeApi()
    api.inbox_pending = 2
    api.needs_check = 126
    runner = Mock()
    config = WorkerConfig(workspace_root=tmp_path, state_dir=tmp_path / "state", cooldown_seconds=0)
    worker = AutoLearningWorker(config, api=api, runner=runner, now=lambda: 100.0)

    result = worker.tick()

    assert result["action"] == "remote_inbox"
    assert api.posts == [
        ("/remote-inbox/process", {"auto_pipeline": True, "inbox_root": str(tmp_path)})
    ]
    runner.assert_not_called()


def test_tick_processes_local_video_before_remote_inbox_and_youtube(tmp_path):
    api = FakeApi()
    api.inbox_pending = 2
    api.needs_check = 126
    runner = Mock()
    local_scan = Mock(return_value={"ready": 1})
    status_path = tmp_path / "state" / "auto_learning_worker_status.json"

    def local_process(**kwargs):
        assert status_path.exists()
        assert "local_video" in status_path.read_text(encoding="utf-8")
        return {"status": "learned", "path": str(tmp_path / "lesson.mp4")}

    local_process_mock = Mock(side_effect=local_process)
    config = WorkerConfig(
        workspace_root=tmp_path,
        state_dir=tmp_path / "state",
        cooldown_seconds=0,
        local_video_enabled=True,
        local_video_inbox_dir=tmp_path / "YT_Downloads",
        local_video_manifest_path=tmp_path / "manifest.json",
    )
    worker = AutoLearningWorker(
        config,
        api=api,
        runner=runner,
        now=lambda: 100.0,
        local_video_scanner=local_scan,
        local_video_processor=local_process_mock,
    )

    result = worker.tick()

    assert result["action"] == "local_video"
    assert result["path"] == str(tmp_path / "lesson.mp4")
    local_scan.assert_called_once()
    local_process_mock.assert_called_once()
    assert api.posts == []
    runner.assert_not_called()


def test_tick_starts_local_only_youtube_batch_when_idle(tmp_path):
    api = FakeApi()
    api.needs_check = 126
    runner = Mock(return_value=4321)
    config = WorkerConfig(workspace_root=tmp_path, state_dir=tmp_path / "state", cooldown_seconds=0)
    worker = AutoLearningWorker(config, api=api, runner=runner, now=lambda: 100.0)

    result = worker.tick()

    assert result["action"] == "youtube_batch"
    assert result["pid"] == 4321
    call = runner.call_args.kwargs
    assert call["env"]["ORCA_TRANSCRIPTION_ENGINES"] == "faster_whisper"
    assert "--limit" in call["args"]
    assert "--max-duration" in call["args"]
    assert "--auto-pipeline" in call["args"]


def test_tick_skips_youtube_batch_when_youtube_is_disabled(tmp_path):
    api = FakeApi()
    api.needs_check = 126
    runner = Mock()
    config = WorkerConfig(
        workspace_root=tmp_path,
        state_dir=tmp_path / "state",
        cooldown_seconds=0,
        youtube_enabled=False,
    )
    worker = AutoLearningWorker(config, api=api, runner=runner, now=lambda: 100.0)

    result = worker.tick()

    assert result["action"] == "youtube_paused"
    assert result["needs_check"] == 126
    runner.assert_not_called()


def test_tick_does_not_start_work_when_pipeline_is_running(tmp_path):
    api = FakeApi()
    api.pipeline_running = True
    api.inbox_pending = 2
    runner = Mock()
    config = WorkerConfig(workspace_root=tmp_path, state_dir=tmp_path / "state", cooldown_seconds=0)
    worker = AutoLearningWorker(config, api=api, runner=runner, now=lambda: 100.0)

    result = worker.tick()

    assert result["action"] == "wait_pipeline"
    runner.assert_not_called()
    assert api.posts == []


def test_tick_respects_cooldown_between_actions(tmp_path):
    api = FakeApi()
    api.needs_check = 126
    runner = Mock(return_value=4321)
    config = WorkerConfig(workspace_root=tmp_path, state_dir=tmp_path / "state", cooldown_seconds=60)
    worker = AutoLearningWorker(config, api=api, runner=runner, now=lambda: 100.0)

    first = worker.tick()
    second = worker.tick()

    assert first["action"] == "youtube_batch"
    assert second["action"] == "cooldown"
    assert runner.call_count == 1


def test_write_status_retries_drivefs_replace_lock(tmp_path, monkeypatch):
    api = FakeApi()
    config = WorkerConfig(workspace_root=tmp_path, state_dir=tmp_path / "state", cooldown_seconds=0)
    worker = AutoLearningWorker(config, api=api, runner=Mock(), now=lambda: 100.0)
    original_replace = Path.replace
    calls = {"count": 0}

    def flaky_replace(self, target):
        calls["count"] += 1
        if calls["count"] == 1:
            raise PermissionError("DriveFS locked status file")
        return original_replace(self, target)

    monkeypatch.setattr(Path, "replace", flaky_replace)

    worker._write_status({"action": "probe"})

    assert calls["count"] == 2
    assert worker.status_path.exists()
    assert "probe" in worker.status_path.read_text(encoding="utf-8")
