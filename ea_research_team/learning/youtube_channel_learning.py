"""
YouTube channel -> relevant video learning queue.

Flow:
1. Resolve a YouTube channel URL to a channel id.
2. Read the public channel RSS feed.
3. Score recent videos for relevance to trading / AI system-building.
4. Pull transcripts for the best matches.
5. Summarize into the learning queue for review.
"""
from __future__ import annotations

import os
import re
import subprocess
import tempfile
import urllib.error
import urllib.parse
import urllib.request
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from http.cookiejar import MozillaCookieJar
from pathlib import Path

import requests
from summarizer import summarize
from queue_store import add_item, find_duplicate
from youtube_transcript_api import IpBlocked, NoTranscriptFound, TranscriptsDisabled, YouTubeTranscriptApi

COOKIES_FILE = Path(__file__).with_name("youtube_cookies.txt")


# ---------------------------------------------------------------------------
# Typed transcript-fetch exceptions — map to NEXT_TASK failure_reason codes
# ---------------------------------------------------------------------------

class TranscriptFetchError(Exception):
    """Base for all transcript-fetch failures. Subclasses carry failure_reason."""
    failure_reason: str = "unknown_error"


class RateLimitedError(TranscriptFetchError):
    failure_reason = "rate_limited"


class CookieMissingError(TranscriptFetchError):
    failure_reason = "cookie_missing"


class CookieInvalidError(TranscriptFetchError):
    failure_reason = "cookie_invalid"


class NoTranscriptAvailableError(TranscriptFetchError):
    failure_reason = "no_transcript"


YOUTUBE_HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/136.0 Safari/537.36"
}

TRADING_KEYWORDS = {
    "xauusd": 7,
    "gold": 6,
    "forex": 6,
    "trading": 6,
    "smc": 6,
    "ict": 6,
    "liquidity": 5,
    "order block": 5,
    "fvg": 5,
    "bos": 4,
    "choch": 4,
    "strategy": 4,
    "backtest": 4,
    "ea": 5,
    "mt5": 5,
    "mql5": 5,
    "algorithmic": 4,
    "quant": 4,
}

AI_KEYWORDS = {
    "ai": 5,
    "agent": 6,
    "agents": 6,
    "llm": 6,
    "notebooklm": 7,
    "claude": 5,
    "gpt": 5,
    "openai": 5,
    "prompt": 4,
    "automation": 4,
    "workflow": 4,
    "rag": 5,
    "vector": 3,
    "memory": 3,
}


@dataclass
class ChannelVideo:
    video_id: str
    title: str
    url: str
    published: str
    author: str
    score: int
    category: str


def _fetch_text(url: str, timeout: int = 30) -> str:
    req = urllib.request.Request(url, headers=YOUTUBE_HEADERS)
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        return resp.read().decode("utf-8", errors="replace")


def _resolve_channel_id(channel_url: str) -> tuple[str, str]:
    parsed = urllib.parse.urlparse(channel_url.strip())
    if parsed.netloc.lower() not in {"www.youtube.com", "youtube.com", "m.youtube.com"}:
        raise RuntimeError("Please paste a YouTube channel URL.")

    path = parsed.path.rstrip("/")
    if "/channel/" in path:
        channel_id = path.split("/channel/", 1)[1].split("/", 1)[0]
        return channel_id, channel_url

    html = _fetch_text(channel_url, timeout=30)
    match = re.search(r'"channelId":"(UC[a-zA-Z0-9_-]{22})"', html)
    if not match:
        match = re.search(r'"externalId":"(UC[a-zA-Z0-9_-]{22})"', html)
    if not match:
        raise RuntimeError("Could not resolve channel id from this URL.")
    return match.group(1), channel_url


def _score_video(title: str) -> tuple[int, str]:
    lowered = title.lower()
    trading_score = sum(weight for key, weight in TRADING_KEYWORDS.items() if key in lowered)
    ai_score = sum(weight for key, weight in AI_KEYWORDS.items() if key in lowered)
    if trading_score == 0 and ai_score == 0:
        return 0, "Trading_Learn"
    if ai_score > trading_score:
        return ai_score, "AI_Updates"
    return trading_score, "Trading_Learn"


def _extract_video_id(url: str) -> str:
    patterns = [
        r"(?:v=|/v/|youtu\.be/|/embed/|/shorts/)([a-zA-Z0-9_-]{11})",
    ]
    for pattern in patterns:
        match = re.search(pattern, url)
        if match:
            return match.group(1)
    raise RuntimeError(f"Could not extract a video id from: {url}")


def _make_cookie_session(cookies_path: Path | None = None) -> requests.Session | None:
    path = cookies_path if cookies_path is not None else COOKIES_FILE
    if not path.exists():
        return None
    session = requests.Session()
    cj = MozillaCookieJar()
    try:
        cj.load(str(path), ignore_discard=True, ignore_expires=True)
        session.cookies = cj  # type: ignore[assignment]
        return session
    except Exception as exc:
        raise CookieInvalidError(f"Failed to load cookies from {path}: {exc}") from exc


_NODE_PATH = r"C:\Program Files\nodejs"


def _ytdlp_env() -> dict:
    env = os.environ.copy()
    if _NODE_PATH not in env.get("PATH", ""):
        env["PATH"] = _NODE_PATH + os.pathsep + env.get("PATH", "")
    return env


def _pick_transcript_ytdlp(video_id: str) -> tuple[str, str]:
    """Fallback: use yt-dlp with cookies + Node.js to fetch subtitle."""
    if not COOKIES_FILE.exists():
        raise CookieMissingError(
            f"youtube_cookies.txt not found — paste cookies in Settings before retrying."
        )
    cookie_args = ["--cookies", str(COOKIES_FILE)]
    url = f"https://www.youtube.com/watch?v={video_id}"
    with tempfile.TemporaryDirectory() as tmpdir:
        out_tmpl = os.path.join(tmpdir, "%(id)s")
        proc = subprocess.run(
            ["yt-dlp", "--write-auto-subs", "--skip-download",
             "--sub-langs", "th,en",
             "--js-runtimes", "node",
             "--remote-components", "ejs:github",
             "--sleep-requests", "2",
             "--output", out_tmpl, "--quiet", *cookie_args, url],
            capture_output=True, timeout=120, env=_ytdlp_env(),
        )
        stderr = (proc.stderr or b"").decode("utf-8", errors="replace")
        if "429" in stderr or "Too Many Requests" in stderr:
            raise RateLimitedError(f"yt-dlp 429 for {video_id}: {stderr[:200]}")
        for lang in ["th", "en"]:
            for ext in [f"{lang}.vtt", f"{lang}.srt"]:
                fpath = os.path.join(tmpdir, f"{video_id}.{ext}")
                if os.path.exists(fpath):
                    text = _parse_srt(fpath) if ext.endswith(".srt") else _parse_vtt(fpath)
                    return text, lang
    raise NoTranscriptAvailableError(f"No subtitle found for {video_id} via yt-dlp")


def _parse_srt(path: str) -> str:
    text = open(path, encoding="utf-8", errors="replace").read()
    lines = [
        line.strip()
        for line in text.splitlines()
        if line.strip() and not re.match(r"^\d+$", line.strip()) and "-->" not in line
    ]
    return " ".join(lines)


def _parse_vtt(path: str) -> str:
    text = open(path, encoding="utf-8", errors="replace").read()
    lines = [
        re.sub(r"<[^>]+>", "", line).strip()
        for line in text.splitlines()
        if line.strip() and "-->" not in line and not line.startswith("WEBVTT")
        and not re.match(r"^[A-Za-z-]+:", line)
    ]
    return " ".join(l for l in lines if l)


def _pick_transcript(video_id: str) -> tuple[str, str]:
    try:
        session = _make_cookie_session()
    except CookieInvalidError:
        raise
    api = YouTubeTranscriptApi(http_client=session) if session else YouTubeTranscriptApi()
    try:
        transcript_list = api.list(video_id)
        for lang in ["th", "en", "en-US", "en-GB"]:
            try:
                transcript = transcript_list.find_transcript([lang]).fetch()
                text = _transcript_entries_to_text(transcript)
                return text, lang
            except IpBlocked:
                return _pick_transcript_ytdlp(video_id)
            except (TranscriptsDisabled, NoTranscriptFound):
                continue
            except Exception:
                continue
        try:
            transcript = transcript_list.find_generated_transcript(["th", "en"]).fetch()
            text = _transcript_entries_to_text(transcript)
            return text, "auto"
        except IpBlocked:
            return _pick_transcript_ytdlp(video_id)
        except (TranscriptsDisabled, NoTranscriptFound):
            raise NoTranscriptAvailableError(f"No transcript available for {video_id}")
    except IpBlocked:
        return _pick_transcript_ytdlp(video_id)
    except TranscriptFetchError:
        raise
    except (TranscriptsDisabled, NoTranscriptFound):
        raise NoTranscriptAvailableError(f"No transcript available for {video_id}")


def _transcript_entries_to_text(entries) -> str:
    parts = []
    for entry in entries:
        if isinstance(entry, dict):
            text = entry.get("text", "")
        else:
            text = getattr(entry, "text", "")
        if text:
            parts.append(text)
    return " ".join(parts)


def _fetch_recent_videos(channel_url: str, limit: int = 15) -> tuple[str, list[ChannelVideo]]:
    channel_id, resolved_url = _resolve_channel_id(channel_url)
    feed_url = f"https://www.youtube.com/feeds/videos.xml?channel_id={channel_id}"
    xml_text = _fetch_text(feed_url, timeout=30)

    ns = {
        "atom": "http://www.w3.org/2005/Atom",
        "yt": "http://www.youtube.com/xml/schemas/2015",
    }
    root = ET.fromstring(xml_text)
    author = root.findtext("atom:title", default="YouTube Channel", namespaces=ns)

    videos: list[ChannelVideo] = []
    for entry in root.findall("atom:entry", ns):
        title = entry.findtext("atom:title", default="", namespaces=ns).strip()
        video_id = entry.findtext("yt:videoId", default="", namespaces=ns).strip()
        published = entry.findtext("atom:published", default="", namespaces=ns).strip()
        link = entry.find("atom:link", ns)
        url = link.get("href", "") if link is not None else f"https://www.youtube.com/watch?v={video_id}"
        score, category = _score_video(title)
        videos.append(
            ChannelVideo(
                video_id=video_id,
                title=title,
                url=url,
                published=published,
                author=author,
                score=score,
                category=category,
            )
        )

    videos.sort(key=lambda item: item.score, reverse=True)
    return resolved_url, [video for video in videos[:limit] if video.video_id]


def fetch_channel_inventory(channel_url: str, limit: int | None = None) -> dict:
    """Fetch channel RSS inventory without transcripts, scoring filters, or LLM calls."""
    channel_id, resolved_url = _resolve_channel_id(channel_url)
    feed_url = f"https://www.youtube.com/feeds/videos.xml?channel_id={channel_id}"
    xml_text = _fetch_text(feed_url, timeout=30)

    ns = {
        "atom": "http://www.w3.org/2005/Atom",
        "yt": "http://www.youtube.com/xml/schemas/2015",
    }
    root = ET.fromstring(xml_text)
    author = root.findtext("atom:title", default="YouTube Channel", namespaces=ns)

    videos: list[dict] = []
    for entry in root.findall("atom:entry", ns):
        video_id = entry.findtext("yt:videoId", default="", namespaces=ns).strip()
        if not video_id:
            continue
        title = entry.findtext("atom:title", default="", namespaces=ns).strip()
        published = entry.findtext("atom:published", default="", namespaces=ns).strip()
        link = entry.find("atom:link", ns)
        url = link.get("href", "") if link is not None else f"https://www.youtube.com/watch?v={video_id}"
        videos.append(
            {
                "video_id": video_id,
                "title": title,
                "url": url,
                "published": published,
            }
        )
        if limit is not None and len(videos) >= limit:
            break

    return {
        "channel_id": channel_id,
        "channel_name": author,
        "channel_url": resolved_url,
        "videos": videos,
    }


def learn_channel(
    channel_url: str,
    *,
    max_candidates: int = 15,
    max_videos: int = 5,
    min_score: int = 4,
) -> dict:
    resolved_url, videos = _fetch_recent_videos(channel_url, limit=max_candidates)

    processed = 0
    added = 0
    skipped_duplicates = 0
    skipped_irrelevant = 0
    skipped_missing_transcript = 0
    errors: list[str] = []

    for video in videos:
        if video.score < min_score:
            skipped_irrelevant += 1
            continue
        if processed >= max_videos:
            break

        title = f"[YouTube Channel] {video.title}"
        source = f"YouTube/{video.author}"
        if find_duplicate(title, source, video.url):
            skipped_duplicates += 1
            continue

        try:
            transcript, transcript_lang = _pick_transcript(video.video_id)
        except (TranscriptsDisabled, NoTranscriptFound):
            skipped_missing_transcript += 1
            continue
        except Exception as exc:
            errors.append(f"{video.title[:60]}: {exc}")
            continue

        content = "\n".join(
            [
                f"Channel: {video.author}",
                f"Video title: {video.title}",
                f"Video URL: {video.url}",
                f"Published: {video.published}",
                f"Transcript language: {transcript_lang}",
                f"Relevance score: {video.score}",
                "",
                transcript[:5000],
            ]
        )
        item = summarize(
            {
                "title": title,
                "source": source,
                "category": video.category,
                "content": content,
                "url": video.url,
                "_score": max(video.score, 25),
            }
        )
        add_item(
            title=item["title"],
            source=item["source"],
            category=item["category"],
            content=item["content"],
            summary=item["summary"],
            draft_note=item["draft_note"],
            url=item.get("url", ""),
        )
        processed += 1
        added += 1

    return {
        "channel_url": resolved_url,
        "channel_name": videos[0].author if videos else "YouTube Channel",
        "scanned": len(videos),
        "added": added,
        "processed": processed,
        "skipped_duplicates": skipped_duplicates,
        "skipped_irrelevant": skipped_irrelevant,
        "skipped_missing_transcript": skipped_missing_transcript,
        "errors": errors,
    }
