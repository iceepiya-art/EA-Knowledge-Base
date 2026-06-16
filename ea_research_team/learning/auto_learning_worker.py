from __future__ import annotations

import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.request
from dataclasses import dataclass
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any, Callable

from local_video_watcher import (
    DEFAULT_INBOX_DIR as DEFAULT_LOCAL_VIDEO_INBOX_DIR,
    DEFAULT_MANIFEST_PATH as DEFAULT_LOCAL_VIDEO_MANIFEST_PATH,
    process_one_ready_video,
    scan_local_videos,
)


TH_TZ = timezone(timedelta(hours=7))
LEARNING_DIR = Path(__file__).resolve().parent
WORKSPACE_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_STATE_DIR = LEARNING_DIR / ".server_manager"
DEFAULT_API_BASE = "http://127.0.0.1:5000/api/learning"


@dataclass(frozen=True)
class WorkerConfig:
    workspace_root: Path = WORKSPACE_ROOT
    state_dir: Path = DEFAULT_STATE_DIR
    api_base: str = DEFAULT_API_BASE
    interval_seconds: int = 60
    cooldown_seconds: int = 600
    batch_limit: int = 5
    max_duration_seconds: int = 600
    transcription_engines: str = "faster_whisper"
    youtube_enabled: bool = True
    local_video_enabled: bool = False
    local_video_inbox_dir: Path = DEFAULT_LOCAL_VIDEO_INBOX_DIR
    local_video_manifest_path: Path = DEFAULT_LOCAL_VIDEO_MANIFEST_PATH
    local_video_stable_age_seconds: int = 120


class ApiClient:
    def __init__(self, api_base: str) -> None:
        self.api_base = api_base.rstrip("/")

    def get(self, path: str) -> dict[str, Any]:
        with urllib.request.urlopen(self.api_base + path, timeout=10) as resp:
            return json.loads(resp.read().decode("utf-8"))

    def post(self, path: str, body: dict[str, Any] | None = None) -> dict[str, Any]:
        payload = json.dumps(body or {}).encode("utf-8")
        req = urllib.request.Request(
            self.api_base + path,
            data=payload,
            headers={"Content-Type": "application/json"},
            method="POST",
        )
        with urllib.request.urlopen(req, timeout=15) as resp:
            return json.loads(resp.read().decode("utf-8"))


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")


def _default_runner(*, args: list[str], env: dict[str, str], cwd: Path) -> int:
    proc = subprocess.Popen(
        args,
        cwd=str(cwd),
        env=env,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    return proc.pid


class AutoLearningWorker:
    def __init__(
        self,
        config: WorkerConfig | None = None,
        *,
        api: Any | None = None,
        runner: Callable[..., int] = _default_runner,
        now: Callable[[], float] = time.time,
        local_video_scanner: Callable[..., dict[str, Any]] = scan_local_videos,
        local_video_processor: Callable[..., dict[str, Any]] = process_one_ready_video,
    ) -> None:
        self.config = config or WorkerConfig()
        self.api = api or ApiClient(self.config.api_base)
        self.runner = runner
        self.now = now
        self.local_video_scanner = local_video_scanner
        self.local_video_processor = local_video_processor
        self.config.state_dir.mkdir(parents=True, exist_ok=True)
        self.status_path = self.config.state_dir / "auto_learning_worker_status.json"
        self.last_action_at: float | None = None

    def tick(self) -> dict[str, Any]:
        try:
            result = self._tick()
        except (urllib.error.URLError, TimeoutError, OSError) as exc:
            result = {"action": "api_unavailable", "error": str(exc)}
        except Exception as exc:
            result = {"action": "error", "error": str(exc)}
        self._write_status(result)
        return result

    def _tick(self) -> dict[str, Any]:
        pipeline = self.api.get("/pipeline-status")
        if pipeline.get("running"):
            return {"action": "wait_pipeline", "reason": "pipeline_running"}

        download = self.api.get("/download-status")
        if download.get("running"):
            return {"action": "wait_download", "reason": "download_running"}

        if self._in_cooldown():
            return {"action": "cooldown", "remaining_seconds": self._cooldown_remaining()}

        if self.config.local_video_enabled:
            scan = self.local_video_scanner(
                inbox_dir=self.config.local_video_inbox_dir,
                manifest_path=self.config.local_video_manifest_path,
                stable_age_seconds=self.config.local_video_stable_age_seconds,
            )
            if int(scan.get("ready") or 0) > 0:
                self._write_status(
                    {
                        "action": "local_video",
                        "status": "transcribing",
                        "scan": scan,
                        "manifest_path": str(self.config.local_video_manifest_path),
                    }
                )
                result = self.local_video_processor(
                    manifest_path=self.config.local_video_manifest_path,
                )
                self._mark_action()
                return {
                    "action": "local_video",
                    "scan": scan,
                    **result,
                }

        inbox = self.api.get("/remote-inbox/status")
        pending = int((inbox.get("pending") or {}).get("total", 0) or 0)
        if pending > 0:
            body = {"auto_pipeline": True, "inbox_root": str(self.config.workspace_root)}
            response = self.api.post("/remote-inbox/process", body)
            self._mark_action()
            return {
                "action": "remote_inbox",
                "pending": pending,
                "imported": response.get("imported", 0),
                "failed": response.get("failed", 0),
                "pipeline": response.get("pipeline"),
            }

        youtube = self.api.get("/youtube-sources")
        needs_check = int((youtube.get("summary") or {}).get("needs_check", 0) or 0)
        if needs_check <= 0:
            return {"action": "idle", "reason": "no_pending_work"}
        if not self.config.youtube_enabled:
            return {"action": "youtube_paused", "needs_check": needs_check}

        env = os.environ.copy()
        env["ORCA_TRANSCRIPTION_ENGINES"] = self.config.transcription_engines
        env.setdefault("PYTHONUNBUFFERED", "1")
        args = [
            sys.executable,
            "download_pending_videos.py",
            "--limit",
            str(self.config.batch_limit),
            "--max-duration",
            str(self.config.max_duration_seconds),
            "--auto-pipeline",
        ]
        pid = self.runner(args=args, env=env, cwd=LEARNING_DIR)
        self._mark_action()
        return {
            "action": "youtube_batch",
            "pid": pid,
            "needs_check": needs_check,
            "limit": self.config.batch_limit,
            "max_duration": self.config.max_duration_seconds,
            "transcription_engines": self.config.transcription_engines,
        }

    def run_forever(self) -> None:
        while True:
            self.tick()
            time.sleep(self.config.interval_seconds)

    def _mark_action(self) -> None:
        self.last_action_at = self.now()

    def _in_cooldown(self) -> bool:
        return self.last_action_at is not None and self._cooldown_remaining() > 0

    def _cooldown_remaining(self) -> int:
        if self.last_action_at is None:
            return 0
        elapsed = self.now() - self.last_action_at
        return max(0, int(self.config.cooldown_seconds - elapsed))

    def _write_status(self, result: dict[str, Any]) -> None:
        payload = {
            "running": True,
            "updated_at": _now_iso(),
            **result,
        }
        tmp = self.status_path.with_suffix(".tmp")
        tmp.write_text(json.dumps(payload, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
        tmp.replace(self.status_path)


def main() -> int:
    config = WorkerConfig(
        interval_seconds=int(os.environ.get("EA_KB_AUTOPILOT_INTERVAL", "60")),
        cooldown_seconds=int(os.environ.get("EA_KB_AUTOPILOT_COOLDOWN", "600")),
        batch_limit=int(os.environ.get("EA_KB_AUTOPILOT_LIMIT", "5")),
        max_duration_seconds=int(os.environ.get("EA_KB_AUTOPILOT_MAX_DURATION", "600")),
        transcription_engines=os.environ.get("ORCA_TRANSCRIPTION_ENGINES", "faster_whisper"),
        youtube_enabled=str(os.environ.get("EA_KB_AUTOPILOT_YOUTUBE_ENABLED", "1")).strip().lower()
        not in {"0", "false", "no", "off"},
        local_video_enabled=str(os.environ.get("EA_KB_AUTOPILOT_LOCAL_VIDEO_ENABLED", "1")).strip().lower()
        not in {"0", "false", "no", "off"},
        local_video_inbox_dir=Path(os.environ.get("EA_KB_LOCAL_VIDEO_INBOX_DIR", str(DEFAULT_LOCAL_VIDEO_INBOX_DIR))),
        local_video_manifest_path=Path(
            os.environ.get("EA_KB_LOCAL_VIDEO_MANIFEST", str(DEFAULT_LOCAL_VIDEO_MANIFEST_PATH))
        ),
        local_video_stable_age_seconds=int(os.environ.get("EA_KB_LOCAL_VIDEO_STABLE_AGE_SECONDS", "120")),
    )
    AutoLearningWorker(config).run_forever()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
