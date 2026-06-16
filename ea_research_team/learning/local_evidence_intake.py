from __future__ import annotations

import hashlib
import os
import re
import shutil
import subprocess
import tempfile
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any, Callable

TH_TZ = timezone(timedelta(hours=7))
DEFAULT_LOCAL_RAW_DIR = Path(__file__).parents[1] / "raw" / "local"

VIDEO_EXTENSIONS = {".mp4", ".mov", ".mkv", ".avi", ".webm", ".m4v"}
IMAGE_EXTENSIONS = {".png", ".jpg", ".jpeg", ".webp", ".bmp"}
TEXT_EXTENSIONS = {".txt", ".md", ".srt", ".vtt"}
DOCUMENT_EXTENSIONS = {".pdf"}
SIDECAR_EXTENSIONS = [".txt", ".md", ".srt", ".vtt"]
VideoTranscriber = Callable[[Path], str | dict[str, Any]]
ImageTextExtractor = Callable[[Path], str | dict[str, Any]]


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")


def _safe_slug(value: str) -> str:
    slug = re.sub(r"[^A-Za-z0-9ก-๙_-]+", "_", value.strip())
    slug = re.sub(r"_+", "_", slug).strip("_")
    return slug[:80] or "local_evidence"


def _source_type(path: Path) -> str:
    ext = path.suffix.lower()
    if ext in VIDEO_EXTENSIONS:
        return "local_video"
    if ext in IMAGE_EXTENSIONS:
        return "local_image"
    if ext in TEXT_EXTENSIONS:
        return "local_text"
    if ext in DOCUMENT_EXTENSIONS:
        return "local_pdf"
    return "local_file"


def _strip_caption_noise(text: str) -> str:
    lines: list[str] = []
    for line in text.splitlines():
        stripped = line.strip()
        if not stripped:
            continue
        if stripped.upper() == "WEBVTT":
            continue
        if stripped.isdigit():
            continue
        if "-->" in stripped:
            continue
        lines.append(stripped)
    return "\n".join(lines).strip()


def _read_text(path: Path) -> str:
    text = path.read_text(encoding="utf-8").lstrip("\ufeff")
    if path.suffix.lower() in {".srt", ".vtt"}:
        return _strip_caption_noise(text)
    return text.strip()


def _coerce_transcription_text(result: str | dict[str, Any]) -> str:
    if isinstance(result, str):
        return result.strip()
    return str(result.get("text") or "").strip()


def _transcribe_with_faster_whisper(path: Path) -> str:
    from faster_whisper import WhisperModel

    model_name = os.environ.get("ORCA_WHISPER_MODEL", "base")
    model = WhisperModel(model_name, device="auto", compute_type="auto")
    segments, _info = model.transcribe(str(path), beam_size=5)
    return " ".join(segment.text.strip() for segment in segments if segment.text.strip()).strip()


def _transcribe_with_openai_whisper(path: Path) -> str:
    import whisper

    model_name = os.environ.get("ORCA_WHISPER_MODEL", "base")
    model = whisper.load_model(model_name)
    result = model.transcribe(str(path))
    return str(result.get("text") or "").strip()


def _transcribe_with_whisper_cli(path: Path) -> str:
    whisper_bin = shutil.which("whisper")
    if not whisper_bin:
        return ""
    model_name = os.environ.get("ORCA_WHISPER_MODEL", "base")
    with tempfile.TemporaryDirectory() as tmp:
        completed = subprocess.run(
            [
                whisper_bin,
                str(path),
                "--model",
                model_name,
                "--output_format",
                "txt",
                "--output_dir",
                tmp,
            ],
            capture_output=True,
            text=True,
            timeout=int(os.environ.get("ORCA_WHISPER_TIMEOUT_SECONDS", "1800")),
            check=False,
        )
        if completed.returncode != 0:
            stderr = completed.stderr.strip() or completed.stdout.strip()
            raise RuntimeError(f"whisper CLI failed: {stderr[:500]}")
        transcript_path = Path(tmp) / f"{path.stem}.txt"
        if not transcript_path.exists():
            matches = sorted(Path(tmp).glob("*.txt"))
            transcript_path = matches[0] if matches else transcript_path
        return transcript_path.read_text(encoding="utf-8").strip() if transcript_path.exists() else ""


def _transcribe_with_gemini(path: Path) -> str:
    try:
        import google.generativeai as genai
    except ImportError:
        import subprocess
        import sys
        print("  [Auto-installing google-generativeai...]")
        subprocess.check_call([sys.executable, "-m", "pip", "install", "google-generativeai", "-q"])
        import google.generativeai as genai
        
    import time
    
    api_key = os.environ.get("GEMINI_API_KEY")
    if not api_key:
        raise RuntimeError("GEMINI_API_KEY environment variable not set. Please set it to a valid Gemini API Key.")
        
    try:
        genai.configure(api_key=api_key)
        print(f"  Uploading {path.name} to Gemini API for fast transcription...")
        video_file = genai.upload_file(path=str(path))
    except Exception as e:
        print(f"  [Gemini Error during upload]: {e}")
        raise
    
    print("  Processing", end="", flush=True)
    while video_file.state.name == "PROCESSING":
        print(".", end="", flush=True)
        time.sleep(2)
        video_file = genai.get_file(video_file.name)
        
    if video_file.state.name == "FAILED":
        raise RuntimeError("Gemini processing failed")
        
    print(" Ready!")
    print("  Extracting transcript with Gemini 1.5 Flash...")
    model = genai.GenerativeModel(model_name="gemini-2.5-flash")
    prompt = "Please provide a complete and accurate transcript of the audio in this video. Do not summarize, just provide the exact words spoken. Output only the transcript text in Thai language (or the language spoken)."
    
    response = model.generate_content([video_file, prompt])
    
    # Clean up the file from Google servers
    try:
        genai.delete_file(video_file.name)
    except Exception:
        pass
        
    return response.text.strip()


TRANSCRIPTION_ENGINES: dict[str, str] = {
    "faster_whisper": "_transcribe_with_faster_whisper",
    "gemini": "_transcribe_with_gemini",
    "openai_whisper": "_transcribe_with_openai_whisper",
    "whisper_cli": "_transcribe_with_whisper_cli",
}


def _configured_video_transcribers() -> list[tuple[str, VideoTranscriber]]:
    configured = os.environ.get("ORCA_TRANSCRIPTION_ENGINES", "")
    if configured.strip():
        names = [name.strip() for name in configured.split(",") if name.strip()]
    else:
        names = ["faster_whisper", "gemini", "openai_whisper", "whisper_cli"]

    transcribers: list[tuple[str, VideoTranscriber]] = []
    for name in names:
        function_name = TRANSCRIPTION_ENGINES.get(name)
        transcriber = globals().get(function_name or "")
        if callable(transcriber):
            transcribers.append((name, transcriber))
    return transcribers


def transcribe_video_audio(path: Path) -> str:
    """Transcribe local video audio using an installed Whisper-compatible engine."""
    errors: list[str] = []
    transcribers = _configured_video_transcribers()
    for name, transcriber in transcribers:
        try:
            text = transcriber(path)
            if text:
                return text
        except Exception as exc:
            errors.append(f"{name}: {exc}")
    if errors:
        detail = "; ".join(errors)
    elif transcribers:
        detail = "configured engines returned empty transcript"
    else:
        detail = "no engine found"
    raise RuntimeError(f"Automatic video transcription unavailable: {detail}")



def _extract_with_pytesseract(path: Path) -> str:
    from PIL import Image
    import pytesseract

    with Image.open(path) as image:
        return pytesseract.image_to_string(image).strip()


def _extract_with_tesseract_cli(path: Path) -> str:
    tesseract_bin = shutil.which("tesseract")
    if not tesseract_bin:
        return ""
    completed = subprocess.run(
        [tesseract_bin, str(path), "stdout"],
        capture_output=True,
        text=True,
        timeout=int(os.environ.get("ORCA_TESSERACT_TIMEOUT_SECONDS", "300")),
        check=False,
    )
    if completed.returncode != 0:
        stderr = completed.stderr.strip() or completed.stdout.strip()
        raise RuntimeError(f"tesseract CLI failed: {stderr[:500]}")
    return completed.stdout.strip()


def extract_image_text(path: Path) -> str:
    """Extract text from a local image using an installed OCR engine."""
    errors: list[str] = []
    for extractor in (_extract_with_pytesseract, _extract_with_tesseract_cli):
        try:
            text = extractor(path)
            if text:
                return text
        except Exception as exc:
            errors.append(f"{extractor.__name__}: {exc}")
    detail = "; ".join(errors) if errors else "no OCR engine found on PATH or in Python"
    raise RuntimeError(f"Automatic image text extraction unavailable: {detail}")


def _find_sidecar(path: Path) -> Path | None:
    for suffix in SIDECAR_EXTENSIONS:
        candidate = path.with_suffix(suffix)
        if candidate.exists() and candidate != path:
            return candidate
    return None


def _evidence_id(path: Path) -> str:
    resolved = str(path.resolve()).lower()
    stat = path.stat()
    payload = f"{resolved}|{stat.st_size}|{int(stat.st_mtime)}"
    return hashlib.sha256(payload.encode("utf-8")).hexdigest()[:12]


def _build_note(
    *,
    source_path: Path,
    source_type: str,
    evidence_id: str,
    evidence_text: str,
    text_source: Path | str | None,
    keyframes: list[str] = None,
) -> str:
    created = _now_iso()
    title = source_path.stem
    text_captured = "yes" if evidence_text.strip() else "no"
    text_source_value = str(text_source) if text_source else ""
    digest = hashlib.sha256(evidence_text.encode("utf-8")).hexdigest() if evidence_text else ""
    fact_lines = ["## Fact / Transcript Evidence", ""]
    if evidence_text.strip():
        fact_lines.extend([evidence_text.strip(), ""])

    return "\n".join(
        [
            "---",
            "tags: [local-evidence, raw-evidence, ea-knowledge-brain]",
            f"source: {source_path}",
            f"source_type: {source_type}",
            f"video_id: {evidence_id}",
            f"local_evidence_id: {evidence_id}",
            f"text_source: {text_source_value}",
            f"transcript_hash: {digest}",
            f"created: {created}",
            "---",
            "",
            f"# {title}",
            "",
            "## Source",
            "",
            f"- Local file: {source_path}",
            f"- Source type: {source_type}",
            f"- Evidence ID: {evidence_id}",
            f"- Text source: {text_source_value or 'none'}",
            f"- Imported At: {created}",
            "",
            "## Keyframes",
            "",
            *(f"![Frame {i}]({kf})" for i, kf in enumerate(keyframes or [])),
            "",
            *fact_lines,
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
            f"- Text captured: {text_captured}",
            f"- Visual check required: {'yes' if source_type in {'local_video', 'local_image'} else 'no'}",
            "- Ready for EA component extraction: no",
            "",
        ]
    )


def _note_needs_text(note_path: Path) -> bool:
    if not note_path.exists():
        return True
    content = note_path.read_text(encoding="utf-8")
    if "- Text captured: no" in content:
        return True
    match = re.search(
        r"^## Fact / Transcript Evidence\s*$(?P<body>.*?)(?=^##\s+|\Z)",
        content,
        flags=re.MULTILINE | re.DOTALL,
    )
    return not match or not match.group("body").strip()


def import_local_evidence(
    source_path: str | Path,
    *,
    raw_dir: str | Path = DEFAULT_LOCAL_RAW_DIR,
    text: str | None = None,
    video_transcriber: VideoTranscriber | None = None,
    image_text_extractor: ImageTextExtractor | None = None,
) -> dict[str, Any]:
    path = Path(source_path)
    if not path.exists():
        raise FileNotFoundError(f"Local evidence file not found: {path}")
    if not path.is_file():
        raise ValueError(f"Local evidence path must be a file: {path}")

    source_type = _source_type(path)
    text_source: Path | str | None = None
    evidence_text = (text or "").strip()
    transcription_error: str | None = None
    image_text_error: str | None = None

    if not evidence_text:
        if source_type == "local_text":
            evidence_text = _read_text(path)
            text_source = path
        else:
            sidecar = _find_sidecar(path)
            if sidecar:
                evidence_text = _read_text(sidecar)
                text_source = sidecar
            elif source_type == "local_video":
                transcriber = video_transcriber or transcribe_video_audio
                try:
                    evidence_text = _coerce_transcription_text(transcriber(path))
                    if evidence_text:
                        text_source = "auto_transcription"
                except Exception as exc:
                    transcription_error = str(exc)
            elif source_type == "local_pdf":
                try:
                    import pypdf
                    with open(path, "rb") as f:
                        reader = pypdf.PdfReader(f)
                        text_pages = []
                        for page in reader.pages:
                            text_pages.append(page.extract_text() or "")
                        evidence_text = "\n\n".join(text_pages).strip()
                    if evidence_text:
                        text_source = "auto_pdf_extraction"
                except Exception as exc:
                    transcription_error = str(exc)
            elif source_type == "local_image":
                extractor = image_text_extractor or extract_image_text
                try:
                    evidence_text = _coerce_transcription_text(extractor(path))
                    if evidence_text:
                        text_source = "auto_image_text"
                except Exception as exc:
                    image_text_error = str(exc)

    evidence_id = _evidence_id(path)
    output_dir = Path(raw_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    note_path = output_dir / f"{evidence_id}.md"
    
    keyframes = []

    if not note_path.exists() or (evidence_text and _note_needs_text(note_path)):
        note_path.write_text(
            _build_note(
                source_path=path,
                source_type=source_type,
                evidence_id=evidence_id,
                evidence_text=evidence_text,
                text_source=text_source,
                keyframes=keyframes,
            ),
            encoding="utf-8",
        )

    return {
        "status": "raw_evidence_written" if evidence_text else "needs_text",
        "source_type": source_type,
        "source_path": str(path),
        "text_source": str(text_source) if text_source else None,
        "note_path": str(note_path),
        "raw_dir": str(output_dir),
        "text_captured": bool(evidence_text),
        "local_evidence_id": evidence_id,
        "transcription_error": transcription_error,
        "image_text_error": image_text_error,
    }
