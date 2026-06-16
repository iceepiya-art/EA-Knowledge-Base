from __future__ import annotations

import argparse
import hashlib
import json
import sys
from collections.abc import Callable
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any

from channel_manifest import ChannelManifestStore
from concept_note_writer import (
    DEFAULT_CONCEPTS_DIR,
    write_concept_notes,
)
from conflict_detector import (
    DEFAULT_CONFLICT_QUEUE_PATH,
    detect_conflicts,
)
from knowledge_merger import (
    DEFAULT_INDEX_PATH,
    DEFAULT_MERGE_LOG_PATH,
    DEFAULT_STRUCTURED_PATH,
    KnowledgeIndexStore,
    merge_structured_extractions,
)
from local_evidence_intake import DEFAULT_LOCAL_RAW_DIR, import_local_evidence
from remote_inbox import process_remote_inbox
from structured_extractor import (
    DEFAULT_EXTRACTION_PATH,
    StructuredExtractionStore,
    extract_raw_notes,
)
from youtube_channel_learning import (
    TranscriptFetchError,
    _pick_transcript,
    fetch_channel_inventory,
)


InventoryFetcher = Callable[[str], dict[str, Any]]
TranscriptFetcher = Callable[[dict[str, Any]], dict[str, str]]
PLACEHOLDER_HANDLES = {"@channel", "@yourchannel", "@example", "@test"}
TH_TZ = timezone(timedelta(hours=7))
DEFAULT_RAW_DIR = Path(__file__).parents[1] / "raw" / "youtube"


def _emit_json(data: dict[str, Any]) -> None:
    text = json.dumps(data, ensure_ascii=False, indent=2)
    try:
        sys.stdout.write(text + "\n")
    except UnicodeEncodeError:
        sys.stdout.write(json.dumps(data, ensure_ascii=True, indent=2) + "\n")


def _validate_channel_url(channel_url: str) -> None:
    lowered = channel_url.strip().lower().rstrip("/")
    if not lowered:
        raise ValueError("Please paste a real YouTube channel URL.")
    if any(lowered.endswith(handle) for handle in PLACEHOLDER_HANDLES):
        raise ValueError(
            "Please paste a real YouTube channel URL, for example "
            "https://www.youtube.com/@ActualChannelName"
        )


def scan_channel(
    channel_url: str,
    *,
    store: ChannelManifestStore | None = None,
    fetcher: InventoryFetcher = fetch_channel_inventory,
) -> dict[str, Any]:
    _validate_channel_url(channel_url)
    manifest_store = store or ChannelManifestStore()
    inventory = fetcher(channel_url)
    result = manifest_store.record_scan(
        channel_id=inventory["channel_id"],
        channel_name=inventory["channel_name"],
        channel_url=inventory["channel_url"],
        videos=inventory["videos"],
    )
    result["status_counts"] = manifest_store.count_by_status()
    return result


def fetch_video_transcript(video: dict[str, Any]) -> dict[str, str]:
    text, language = _pick_transcript(video["video_id"])
    return {"text": text, "language": language}


def _transcript_hash(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def _safe_date(value: str) -> str:
    if value and len(value) >= 10:
        return value[:10]
    return datetime.now(TH_TZ).strftime("%Y-%m-%d")


def _build_raw_evidence_note(
    *,
    video: dict[str, Any],
    transcript_text: str,
    transcript_language: str,
    transcript_digest: str,
) -> str:
    learned_at = datetime.now(TH_TZ).isoformat(timespec="seconds")
    title = video.get("title", "Untitled YouTube Video")
    url = video.get("url", "")
    video_id = video.get("video_id", "")
    channel_name = video.get("channel_name", "")
    published = video.get("published", "")

    return "\n".join(
        [
            "---",
            "tags: [youtube, raw-evidence, ea-knowledge-brain]",
            f"source: {url}",
            f"video_id: {video_id}",
            f"channel: {channel_name}",
            f"published: {published}",
            f"transcript_language: {transcript_language}",
            f"transcript_hash: {transcript_digest}",
            f"created: {learned_at}",
            "---",
            "",
            f"# {title}",
            "",
            "## Source",
            "",
            f"- Channel: {channel_name}",
            f"- Video ID: {video_id}",
            f"- URL: {url}",
            f"- Published: {published}",
            f"- Learned At: {learned_at}",
            "",
            "## Fact / Transcript Evidence",
            "",
            transcript_text.strip(),
            "",
            "## Interpretation",
            "",
            "_Pending structured extraction._",
            "",
            "## EA Rule Candidates",
            "",
            "_Pending structured extraction._",
            "",
            "## Quality Check",
            "",
            "- Transcript captured: yes",
            "- Visual check required: unknown",
            "- Ready for EA component extraction: no",
            "",
        ]
    )


def _write_raw_evidence_note(
    *,
    video: dict[str, Any],
    transcript_text: str,
    transcript_language: str,
    transcript_digest: str,
    raw_dir: Path,
) -> Path:
    raw_dir.mkdir(parents=True, exist_ok=True)
    filename = f"{_safe_date(video.get('published', ''))}_{video['video_id']}.md"
    note_path = raw_dir / filename
    if not note_path.exists():
        note_path.write_text(
            _build_raw_evidence_note(
                video=video,
                transcript_text=transcript_text,
                transcript_language=transcript_language,
                transcript_digest=transcript_digest,
            ),
            encoding="utf-8",
        )
    return note_path


def learn_new_videos(
    *,
    store: ChannelManifestStore | None = None,
    transcript_fetcher: TranscriptFetcher = fetch_video_transcript,
    raw_dir: str | Path = DEFAULT_RAW_DIR,
    limit: int | None = None,
    retry_needs_check: bool = False,
) -> dict[str, Any]:
    manifest_store = store or ChannelManifestStore()
    candidates = manifest_store.get_unlearned_videos()
    if retry_needs_check:
        retry_items = [
            video
            for video in manifest_store.load()["videos"].values()
            if video.get("status") == "needs_transcript_check"
        ]
        seen = {video["video_id"] for video in candidates}
        candidates.extend(dict(video) for video in retry_items if video["video_id"] not in seen)
    if limit is not None:
        candidates = candidates[:limit]

    result = {
        "processed": 0,
        "written": 0,
        "failed": 0,
        "skipped": 0,
        "raw_dir": str(raw_dir),
    }
    output_dir = Path(raw_dir)

    for video in candidates:
        result["processed"] += 1
        try:
            transcript = transcript_fetcher(video)
            transcript_text = transcript["text"].strip()
            transcript_language = transcript.get("language", "unknown")
            if not transcript_text:
                raise RuntimeError("empty transcript")
            digest = _transcript_hash(transcript_text)
            note_path = _write_raw_evidence_note(
                video=video,
                transcript_text=transcript_text,
                transcript_language=transcript_language,
                transcript_digest=digest,
                raw_dir=output_dir,
            )
            manifest_store.update_video_status(
                video["video_id"],
                "raw_evidence_written",
                note_paths=[str(note_path)],
                transcript_hash=digest,
            )
            result["written"] += 1
        except Exception as exc:
            reason = getattr(exc, "failure_reason", "unknown_error")
            manifest_store.update_video_status(
                video["video_id"],
                "needs_transcript_check",
                error=str(exc),
                failure_reason=reason,
            )
            result["failed"] += 1

    result["status_counts"] = manifest_store.count_by_status()
    return result


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="EA Knowledge Brain channel intake")
    subparsers = parser.add_subparsers(dest="command", required=True)

    scan_parser = subparsers.add_parser("scan", help="Scan a YouTube channel into the manifest")
    scan_parser.add_argument("channel_url", help="YouTube channel URL")
    scan_parser.add_argument(
        "--manifest",
        default=None,
        help="Optional manifest path. Defaults to learning/channel_manifest.json",
    )

    learn_parser = subparsers.add_parser("learn-new", help="Write raw evidence notes for unlearned videos")
    learn_parser.add_argument(
        "--manifest",
        default=None,
        help="Optional manifest path. Defaults to learning/channel_manifest.json",
    )
    learn_parser.add_argument(
        "--raw-dir",
        default=str(DEFAULT_RAW_DIR),
        help="Output folder for raw YouTube evidence notes",
    )
    learn_parser.add_argument(
        "--limit",
        type=int,
        default=None,
        help="Maximum videos to process in this run",
    )
    learn_parser.add_argument(
        "--retry-needs-check",
        action="store_true",
        help="Retry videos previously marked needs_transcript_check",
    )

    local_parser = subparsers.add_parser(
        "import-local",
        help="Import local video, image, or text evidence into raw evidence notes",
    )
    local_parser.add_argument("source_path", help="Local .mp4, image, or text file path")
    local_parser.add_argument(
        "--raw-dir",
        default=str(DEFAULT_LOCAL_RAW_DIR),
        help="Output folder for local evidence notes",
    )
    local_parser.add_argument(
        "--text",
        default=None,
        help="Optional manual transcript/description text for video or image files",
    )

    inbox_parser = subparsers.add_parser(
        "process-inbox",
        help="Import files from a Google Drive-synced remote inbox into local raw evidence",
    )
    inbox_parser.add_argument(
        "--inbox-root",
        required=True,
        help="Root folder containing inbox/text, inbox/images, inbox/videos, and inbox/urls",
    )
    inbox_parser.add_argument(
        "--raw-dir",
        default=str(DEFAULT_LOCAL_RAW_DIR),
        help="Output folder for imported local evidence notes",
    )

    extract_parser = subparsers.add_parser(
        "extract-raw",
        help="Extract structured knowledge from raw evidence notes",
    )
    extract_parser.add_argument(
        "--raw-dir",
        default=str(DEFAULT_RAW_DIR),
        help="Folder containing raw YouTube evidence notes",
    )
    extract_parser.add_argument(
        "--output",
        default=str(DEFAULT_EXTRACTION_PATH),
        help="Structured extraction JSON output path",
    )
    extract_parser.add_argument(
        "--manifest",
        default=None,
        help="Optional manifest path. Defaults to learning/channel_manifest.json",
    )
    extract_parser.add_argument(
        "--use-llm",
        action="store_true",
        default=False,
        help="Use Claude LLM for extraction (requires ANTHROPIC_API_KEY)",
    )

    merge_parser = subparsers.add_parser(
        "merge-knowledge",
        help="Merge structured extractions into the cumulative knowledge index",
    )
    merge_parser.add_argument(
        "--structured",
        default=str(DEFAULT_STRUCTURED_PATH),
        help="Structured extraction JSON input path",
    )
    merge_parser.add_argument(
        "--index",
        default=str(DEFAULT_INDEX_PATH),
        help="Knowledge index JSON output path",
    )
    merge_parser.add_argument(
        "--log",
        default=str(DEFAULT_MERGE_LOG_PATH),
        help="Knowledge merge log JSON output path",
    )

    write_parser = subparsers.add_parser(
        "write-concepts",
        help="Write Obsidian concept notes from knowledge_index.json",
    )
    write_parser.add_argument(
        "--index",
        default=str(DEFAULT_INDEX_PATH),
        help="Knowledge index JSON input path",
    )
    write_parser.add_argument(
        "--structured",
        default=str(DEFAULT_STRUCTURED_PATH),
        help="Structured extraction JSON for EA rule candidates (optional)",
    )
    write_parser.add_argument(
        "--output-dir",
        default=str(DEFAULT_CONCEPTS_DIR),
        help="Output folder for Obsidian concept notes",
    )

    detect_parser = subparsers.add_parser(
        "detect-conflicts",
        help="Detect knowledge conflicts and write conflict_review_queue.json",
    )
    detect_parser.add_argument(
        "--index",
        default=str(DEFAULT_INDEX_PATH),
        help="Knowledge index JSON input path",
    )
    detect_parser.add_argument(
        "--structured",
        default=str(DEFAULT_STRUCTURED_PATH),
        help="Structured extraction JSON for contradiction detection",
    )
    detect_parser.add_argument(
        "--queue",
        default=str(DEFAULT_CONFLICT_QUEUE_PATH),
        help="Output path for conflict_review_queue.json",
    )

    return parser


def main(argv: list[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)

    if args.command == "scan":
        store = ChannelManifestStore(args.manifest) if args.manifest else ChannelManifestStore()
        try:
            result = scan_channel(args.channel_url, store=store)
        except Exception as exc:
            print(f"Error: {exc}")
            return 1
        else:
            _emit_json(result)
            return 0

    if args.command == "learn-new":
        store = ChannelManifestStore(args.manifest) if args.manifest else ChannelManifestStore()
        result = learn_new_videos(
            store=store,
            raw_dir=args.raw_dir,
            limit=args.limit,
            retry_needs_check=args.retry_needs_check,
        )
        _emit_json(result)
        return 0

    if args.command == "import-local":
        try:
            result = import_local_evidence(
                args.source_path,
                raw_dir=args.raw_dir,
                text=args.text,
            )
        except Exception as exc:
            print(f"Error: {exc}")
            return 1
        result["note_path"] = str(result["note_path"])
        _emit_json(result)
        return 0

    if args.command == "process-inbox":
        try:
            result = process_remote_inbox(
                args.inbox_root,
                raw_dir=args.raw_dir,
            )
        except Exception as exc:
            print(f"Error: {exc}")
            return 1
        _emit_json(result)
        return 0

    if args.command == "extract-raw":
        store = StructuredExtractionStore(args.output)
        manifest_store = ChannelManifestStore(args.manifest) if args.manifest else ChannelManifestStore()
        llm_client = None
        if getattr(args, "use_llm", False):
            try:
                import anthropic
                llm_client = anthropic.Anthropic()
                print("LLM extraction enabled (claude-haiku)", flush=True)
            except ImportError:
                print("WARNING: anthropic package not installed — falling back to keyword extraction", flush=True)
        result = extract_raw_notes(
            raw_dir=args.raw_dir,
            store=store,
            manifest_store=manifest_store,
            llm_client=llm_client,
        )
        result["output"] = str(store.path)
        _emit_json(result)
        return 0

    if args.command == "merge-knowledge":
        index_store = KnowledgeIndexStore(args.index)
        result = merge_structured_extractions(
            structured_path=args.structured,
            index_store=index_store,
            merge_log_path=args.log,
        )
        _emit_json(result)
        return 0

    if args.command == "write-concepts":
        result = write_concept_notes(
            index_path=args.index,
            structured_path=args.structured,
            output_dir=args.output_dir,
        )
        _emit_json(result)
        return 0

    if args.command == "detect-conflicts":
        result = detect_conflicts(
            index_path=args.index,
            structured_path=args.structured,
            queue_path=args.queue,
        )
        _emit_json(result)
        return 0

    parser.error(f"Unknown command: {args.command}")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
