from __future__ import annotations

import json
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any


TH_TZ = timezone(timedelta(hours=7))
DEFAULT_MANIFEST_PATH = Path(__file__).with_name("channel_manifest.json")
LEARNED_STATUSES = {
    "learned",
    "written",
    "raw_evidence_written",
    "conflict",
    "skipped_no_transcript",
    "needs_transcript_check",
}


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")


def _empty_manifest() -> dict[str, Any]:
    return {"version": 1, "channels": {}, "videos": {}}


class ChannelManifestStore:
    """Persistent YouTube channel inventory keyed by video_id."""

    def __init__(self, path: str | Path = DEFAULT_MANIFEST_PATH):
        self.path = Path(path)

    def load(self) -> dict[str, Any]:
        if not self.path.exists():
            return _empty_manifest()
        data = json.loads(self.path.read_text(encoding="utf-8"))
        if not isinstance(data, dict):
            raise ValueError("channel_manifest.json must contain a JSON object")
        data.setdefault("version", 1)
        data.setdefault("channels", {})
        data.setdefault("videos", {})
        return data

    def save(self, manifest: dict[str, Any]) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        tmp_path = self.path.with_suffix(f".tmp-{datetime.now().strftime('%Y%m%d%H%M%S%f')}.json")
        tmp_path.write_text(
            json.dumps(manifest, ensure_ascii=False, indent=2, sort_keys=True),
            encoding="utf-8",
        )
        tmp_path.replace(self.path)

    def record_scan(
        self,
        *,
        channel_id: str,
        channel_name: str,
        channel_url: str,
        videos: list[dict[str, Any]],
    ) -> dict[str, int | str]:
        manifest = self.load()
        scanned_at = _now_iso()
        manifest["channels"][channel_id] = {
            "channel_id": channel_id,
            "channel_name": channel_name,
            "url": channel_url,
            "last_scanned_at": scanned_at,
        }

        new_count = 0
        duplicate_count = 0
        for video in videos:
            video_id = str(video.get("video_id", "")).strip()
            if not video_id:
                continue
            if video_id in manifest["videos"]:
                duplicate_count += 1
                existing = manifest["videos"][video_id]
                existing["title"] = video.get("title") or existing.get("title", "")
                existing["url"] = video.get("url") or existing.get("url", "")
                existing["published"] = video.get("published") or existing.get("published", "")
                if "duration" in video:
                    existing["duration"] = video.get("duration")
                existing["last_seen_at"] = scanned_at
                continue

            record = {
                "video_id": video_id,
                "channel_id": channel_id,
                "channel_name": channel_name,
                "title": video.get("title", ""),
                "url": video.get("url", ""),
                "published": video.get("published", ""),
                "status": "discovered",
                "transcript_hash": "",
                "note_paths": [],
                "first_seen_at": scanned_at,
                "last_seen_at": scanned_at,
                "last_processed_at": "",
                "error": "",
            }
            if "duration" in video:
                record["duration"] = video.get("duration")
            manifest["videos"][video_id] = record
            new_count += 1

        self.save(manifest)
        return {
            "channel_id": channel_id,
            "channel_name": channel_name,
            "scanned": len(videos),
            "new": new_count,
            "duplicates": duplicate_count,
            "manifest_path": str(self.path),
        }

    def count_by_status(self) -> dict[str, int]:
        counts: dict[str, int] = {}
        for video in self.load()["videos"].values():
            status = video.get("status", "discovered")
            counts[status] = counts.get(status, 0) + 1
        return counts

    def get_unlearned_videos(self) -> list[dict[str, Any]]:
        videos = self.load()["videos"].values()
        return [
            dict(video)
            for video in videos
            if video.get("status", "discovered") not in LEARNED_STATUSES
        ]

    def update_video_status(
        self,
        video_id: str,
        status: str,
        *,
        note_paths: list[str] | None = None,
        transcript_hash: str | None = None,
        error: str = "",
        failure_reason: str = "",
    ) -> None:
        manifest = self.load()
        if video_id not in manifest["videos"]:
            raise KeyError(f"Unknown video_id: {video_id}")
        video = manifest["videos"][video_id]
        video["status"] = status
        video["last_processed_at"] = _now_iso()
        if note_paths is not None:
            video["note_paths"] = note_paths
        if transcript_hash is not None:
            video["transcript_hash"] = transcript_hash
        video["error"] = error
        video["failure_reason"] = failure_reason
        self.save(manifest)
