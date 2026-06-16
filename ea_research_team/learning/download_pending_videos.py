import argparse
import os
import sys
import subprocess
import tempfile
import time
import random
import re
from pathlib import Path

try:
    from dotenv import load_dotenv
    env_path = Path(__file__).parents[2] / ".env"
    load_dotenv(env_path, override=True)
except ImportError:
    pass

# Fix Windows console Unicode print errors
try:
    sys.stdout.reconfigure(encoding='utf-8')
except AttributeError:
    pass

from channel_manifest import ChannelManifestStore
from local_evidence_intake import import_local_evidence
from channel_intake import DEFAULT_RAW_DIR
import json

COOKIES_FILE = Path(__file__).parent / "youtube_cookies.txt"
STATUS_FILE = Path(__file__).parent / ".server_manager" / "download_status.json"


def duration_seconds(video: dict):
    duration = video.get("duration")
    if isinstance(duration, bool) or not isinstance(duration, (int, float)) or duration < 0:
        return None
    return duration


def _pending_video_sort_key(video: dict):
    title = video.get("title", "")
    duration = duration_seconds(video)
    is_live = "\u0e40\u0e17\u0e23\u0e14\u0e2a\u0e14" in title or "live" in title.lower()
    is_long = duration is not None and duration > 3600
    failure_reason = video.get("failure_reason") or ""
    failure_rank = {
        "": 0,
        "rate_limited": 1,
        "download_failed": 2,
        "no_transcript": 3,
        "transcription_failed": 4,
    }.get(failure_reason, 2 if video.get("error") else 0)
    bucket = 3 if is_live else 2 if is_long else 1 if duration is None else 0
    return (
        failure_rank,
        bucket,
        duration if duration is not None else 999999999,
        video.get("video_id", ""),
    )


def sort_pending_videos(videos):
    return sorted(videos, key=_pending_video_sort_key)


def select_pending_videos(videos, limit=None, max_duration=None):
    selected = sort_pending_videos(videos)
    if max_duration is not None:
        selected = [
            video for video in selected
            if (duration_seconds(video) is not None and duration_seconds(video) <= max_duration)
        ]
    if limit:
        selected = selected[:limit]
    return selected


def _write_status(state: dict):
    try:
        STATUS_FILE.parent.mkdir(parents=True, exist_ok=True)
        STATUS_FILE.write_text(json.dumps(state, ensure_ascii=False, indent=2), encoding="utf-8")
    except Exception as e:
        print(f"Error writing status: {e}")


def _run_pipeline_locally():
    try:
        current_dir = Path(__file__).parent
        if str(current_dir) not in sys.path:
            sys.path.insert(0, str(current_dir))
        
        from server import _run_full_pipeline, create_app
        print("  Initializing local pipeline runner...")
        app = create_app()
        res = _run_full_pipeline(app)
        print("  Local pipeline execution completed!")
        
        extract_res = res.get('extract', {})
        merge_res = res.get('merge', {})
        dedup_res = res.get('dedup', {})
        write_res = res.get('write_concepts', {})
        conflict_res = res.get('conflicts', {})
        resolve_res = res.get('auto_resolve', {})
        comp_res = res.get('ea_components', {})
        bp_res = res.get('blueprint', {})
        
        print(f"  - Extracted: processed={extract_res.get('processed', 0)}, written={extract_res.get('written', 0)}, failed={extract_res.get('failed', 0)}")
        print(f"  - Merged: new={merge_res.get('new_concepts', 0)}, reinforced={merge_res.get('reinforced_concepts', 0)}")
        print(f"  - Deduplicated: before={dedup_res.get('concepts_before', 0)}, after={dedup_res.get('concepts_after', 0)}, removed={dedup_res.get('removed', 0)}")
        print(f"  - Obsidian Notes: total={write_res.get('total_notes', 0)}, written={write_res.get('written', 0)}")
        print(f"  - Conflicts: detected={conflict_res.get('detected', 0)}, contradictions={conflict_res.get('contradictions', 0)}")
        print(f"  - Auto-Resolved Conflicts: {resolve_res.get('auto_resolved', 0)}")
        print(f"  - Components extracted: {comp_res.get('summary', {}).get('total_rules', 0) if isinstance(comp_res, dict) else comp_res}")
        print(f"  - Blueprint readiness: {bp_res.get('summary', {}).get('ea_readiness', 'low') if isinstance(bp_res, dict) else bp_res}")
    except Exception as e:
        print(f"  Local pipeline execution failed: {e}")

def run_download_and_transcribe(manifest_path=None, limit=None, auto_pipeline=False, url=None, channel_filter=None, max_duration=None):
    store = ChannelManifestStore(manifest_path) if manifest_path else ChannelManifestStore()
    
    if url:
        import urllib.parse
        video_id = "unknown"
        if "youtu.be/" in url:
            video_id = url.split("youtu.be/")[-1].split("?")[0]
        elif "v=" in url:
            video_id = urllib.parse.parse_qs(urllib.parse.urlparse(url).query).get("v", ["unknown"])[0]
            
        pending_videos = [{
            "video_id": video_id,
            "title": "Single Video Intake",
            "channel_name": "Direct URL",
            "url": url,
            "status": "needs_transcript_check"
        }]
        manifest = store.load()
        if video_id not in manifest.get("videos", {}):
            if "videos" not in manifest:
                manifest["videos"] = {}
            manifest["videos"][video_id] = pending_videos[0]
            store.save(manifest)
        store.update_video_status(video_id, "needs_transcript_check")
    else:
        manifest = store.load()
        pending_videos = [
            v for v in manifest.get("videos", {}).values() 
            if v.get("status") == "needs_transcript_check"
        ]
        
        if channel_filter:
            pending_videos = [
                v for v in pending_videos 
                if v.get("channel_name") and channel_filter.lower() in v.get("channel_name").lower()
            ]
            
        pending_videos = select_pending_videos(pending_videos, limit=limit, max_duration=max_duration)

        def _sort_key(v):
            title = v.get("title", "")
            duration = v.get("duration", 0)
            is_live = "เทรดสด" in title or "live" in title.lower()
            is_long = (duration is not None and duration > 3600)
            return 1 if (is_live or is_long) else 0
            
        pending_videos.sort(key=_sort_key)
        
    print(f"Found {len(pending_videos)} videos needing transcript check.")
    
    total = len(pending_videos)
    success = 0
    failed = 0
    
    _write_status({
        "running": True,
        "total": total,
        "current_index": 0,
        "success": 0,
        "failed": 0,
        "current_video_id": None,
        "current_title": None,
        "current_channel": None,
        "status": "Starting...",
        "percent": 0
    })
    
    for i, video in enumerate(pending_videos, 1):
        video_id = video["video_id"]
        title = video.get("title", "")
        channel = video.get("channel_name", "")
        url = video.get("url") or f"https://www.youtube.com/watch?v={video_id}"
        
        _write_status({
            "running": True,
            "total": total,
            "current_index": i,
            "success": success,
            "failed": failed,
            "current_video_id": video_id,
            "current_title": title,
            "current_channel": channel,
            "status": "Downloading",
            "percent": int(((i - 1) / total) * 100) if total > 0 else 0
        })
        print(f"\n[{i}/{total}] Processing {video_id} - {title}")
        
        existing_notes = list(DEFAULT_RAW_DIR.glob(f"*{video_id}.md"))
        if existing_notes:
            print(f"  Skipping download, raw transcript already exists for {video_id}")
            note_path = str(existing_notes[0])
            store.update_video_status(
                video_id, 
                "raw_evidence_written", 
                note_paths=[note_path]
            )
            success += 1
            if auto_pipeline:
                print(f"  Triggering learning auto-pipeline for {video_id}...")
                _run_pipeline_locally()
                time.sleep(2)
            continue
        
        with tempfile.TemporaryDirectory() as tmpdir:
            out_path = os.path.join(tmpdir, f"{video_id}.mp4")
            video_succeeded = False
            
            # Download video instead of just audio for Vision pipeline
            base_cmd = [
                "yt-dlp",
                "-f", "best[ext=mp4]/best",
                "-o", out_path,
                "--quiet",
                "--no-warnings"
            ]
            
            cmds_to_try = []
            
            # First try Android client (often bypasses bot checks without cookies)
            cmds_to_try.append(base_cmd + ["--extractor-args", "youtube:player_client=android", url])

            # Then try cookies if Android client fails
            if COOKIES_FILE.exists():
                cmds_to_try.append(base_cmd + ["--cookies", str(COOKIES_FILE), url])
            
            cmds_to_try.append(base_cmd + ["--cookies-from-browser", "chrome", url])
            cmds_to_try.append(base_cmd + ["--cookies-from-browser", "edge", url])
            
            print(f"  Downloading with yt-dlp...")
            start_dl = time.time()
            proc = None
            for cmd in cmds_to_try:
                proc = subprocess.run(cmd, capture_output=True)
                if proc.returncode == 0:
                    break
                
                error_msg = proc.stderr.decode('utf-8', errors='replace').strip()
                last_line = error_msg.split('\n')[-1] if error_msg else "Unknown error"
                print(f"  -> Attempt failed ({cmd[-2]}): {last_line}")
                
            dl_duration = time.time() - start_dl
            
            if proc.returncode != 0:
                print(f"  yt-dlp failed: {proc.stderr.decode('utf-8', errors='replace')[:200]}")
                store.update_video_status(video_id, "needs_transcript_check", error="yt-dlp download failed", failure_reason="download_failed")
                failed += 1
                continue
                
            if not os.path.exists(out_path):
                # Maybe it saved with a different extension? Let's check
                files = list(Path(tmpdir).glob(f"{video_id}.*"))
                if not files:
                    print("  yt-dlp did not produce a file.")
                    failed += 1
                    continue
                downloaded_file = files[0]
                # rename to .mp4 so it's treated as local_video by import_local_evidence
                os.rename(str(downloaded_file), out_path)
                
            print(f"  Downloaded in {dl_duration:.1f}s. Transcribing...")
            _write_status({
                "running": True,
                "total": total,
                "current_index": i,
                "success": success,
                "failed": failed,
                "current_video_id": video_id,
                "current_title": title,
                "current_channel": channel,
                "status": "Transcribing",
                "percent": int(((i - 1) / total) * 100) if total > 0 else 0
            })
            
            try:
                start_tr = time.time()
                result = import_local_evidence(
                    out_path,
                    raw_dir=DEFAULT_RAW_DIR
                )
                tr_duration = time.time() - start_tr
                
                if result.get("text_captured"):
                    note_path = result["note_path"]
                    
                    # Fix the note to appear as youtube source instead of local_video
                    note_content = Path(note_path).read_text(encoding="utf-8")
                    note_content = note_content.replace("source_type: local_video", "source_type: youtube")
                    note_content = note_content.replace("tags: [local-evidence, raw-evidence, ea-knowledge-brain]", "tags: [youtube, raw-evidence, ea-knowledge-brain]")
                    
                    # Robust regex replacements for source and video_id fields
                    note_content = re.sub(r"^source: .*$", f"source: {url}", note_content, flags=re.MULTILINE)
                    note_content = re.sub(r"^video_id: .*$", f"video_id: {video_id}", note_content, flags=re.MULTILINE)
                    
                    Path(note_path).write_text(note_content, encoding="utf-8")
                    
                    print(f"  Transcribed in {tr_duration:.1f}s. Written to {Path(note_path).name}")
                    
                    # Update manifest
                    store.update_video_status(
                        video_id, 
                        "raw_evidence_written", 
                        note_paths=[str(note_path)],
                        transcript_hash=result.get("local_evidence_id") # using evidence_id as proxy
                    )
                    success += 1
                    video_succeeded = True
                else:
                    transcription_error = (
                        result.get("transcription_error")
                        or result.get("image_text_error")
                        or "Transcription produced empty text."
                    )
                    print(f"  Transcription produced empty text.")
                    store.update_video_status(
                        video_id,
                        "needs_transcript_check",
                        error=str(transcription_error),
                        failure_reason="transcription_failed",
                    )
                    failed += 1
            except Exception as exc:
                print(f"  Transcription failed: {exc}")
                store.update_video_status(video_id, "needs_transcript_check", error=str(exc), failure_reason="transcription_failed")
                failed += 1
                
            # Trigger pipeline sequentially for THIS video!
            if auto_pipeline and video_succeeded:
                print(f"\nTriggering learning auto-pipeline for {video_id}...")
                import requests
                try:
                    resp = requests.post("http://127.0.0.1:5000/api/learning/run-pipeline", timeout=5)
                    if resp.status_code == 200:
                        print("  Pipeline started via Flask API. Monitoring progress...")
                        while True:
                            status_resp = requests.get("http://127.0.0.1:5000/api/learning/pipeline-status", timeout=5)
                            if status_resp.status_code == 200:
                                state = status_resp.json()
                                if not state.get("running"):
                                    if state.get("error"):
                                        print(f"  Pipeline failed: {state.get('error')}")
                                    else:
                                        print("  Pipeline completed successfully!")
                                    break
                            time.sleep(2)
                    elif resp.status_code == 409:
                        print("  Pipeline already running.")
                    else:
                        print(f"  Failed to start pipeline (HTTP {resp.status_code}). Falling back to local execution.")
                        _run_pipeline_locally()
                except Exception as req_e:
                    print(f"  Flask API error: {req_e}. Running locally...")
                    _run_pipeline_locally()

        # Optional delay to avoid ratelimits if needed
        if i < len(pending_videos):
            delay = random.uniform(5, 15)
            print(f"  Waiting for {delay:.1f} seconds to respect YouTube rate limits...")
            _write_status({
                "running": True,
                "total": total,
                "current_index": i,
                "success": success,
                "failed": failed,
                "current_video_id": video_id,
                "current_title": title,
                "current_channel": channel,
                "status": f"Waiting {int(delay)}s (Rate limit)",
                "percent": int((i / total) * 100) if total > 0 else 0
            })
            time.sleep(delay)
        
    print(f"\nDone. Success: {success}, Failed: {failed}")
    _write_status({
        "running": False,
        "total": total,
        "current_index": total,
        "success": success,
        "failed": failed,
        "current_video_id": None,
        "current_title": None,
        "current_channel": None,
        "status": "Completed",
        "percent": 100
    })

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--limit", type=int, default=None, help="Limit number of videos to process")
    parser.add_argument("--auto-pipeline", action="store_true", help="Automatically trigger full learning pipeline after downloads")
    parser.add_argument("--url", type=str, default=None, help="Process a single video URL")
    parser.add_argument("--channel", type=str, default=None, help="Filter by channel name")
    parser.add_argument("--max-duration", type=float, default=None, help="Only process videos with known duration at or below this many seconds")
    args = parser.parse_args()
    
    run_download_and_transcribe(limit=args.limit, auto_pipeline=args.auto_pipeline, url=args.url, channel_filter=args.channel, max_duration=args.max_duration)
