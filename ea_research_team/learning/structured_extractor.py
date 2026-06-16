from __future__ import annotations

import json
import re
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any

from channel_manifest import ChannelManifestStore


TH_TZ = timezone(timedelta(hours=7))
DEFAULT_EXTRACTION_PATH = Path(__file__).with_name("structured_extractions.json")
DEFAULT_RAW_DIR = Path(__file__).parents[1] / "raw" / "youtube"

_MAX_RULE_LEN = 300

CONCEPT_PATTERNS: dict[str, list[str]] = {
    "FVG": ["fvg", "fair value gap", "imbalance"],
    "Order Block": ["order block", " ob "],
    "CHoCH": ["choch", "change of character"],
    "BOS": ["bos", "break of structure"],
    "Liquidity Sweep": ["liquidity sweep", "sweep", "stop hunt", "equal lows", "equal highs"],
    "Pattern W": ["pattern w", "w setup", "double bottom", " w "],
    "Pattern M": ["pattern m", "m setup", "double top", " m "],
    "ATR Filter": ["atr", "average true range"],
    "Session Filter": ["session", "london", "new york", "asian"],
    "Risk Management": ["risk", "lot", "drawdown", "daily loss"],
}

RULE_PATTERNS: dict[str, list[str]] = {
    "entry": ["entry", "enter", "buy", "sell", "trigger", "confirm", "confirmation"],
    "exit": ["exit", "take profit", "tp", "close", "target"],
    "stop_loss": ["stop loss", "sl", "below", "above", "wick"],
    "filter": ["filter", "avoid", "no trade", "spread", "session", "news", "atr"],
    "regime": ["trend", "range", "ranging", "volatile", "sideway", "structure"],
}

_LLM_SYSTEM = (
    "You are a broad knowledge extractor for the EA Knowledge Brain. "
    "Extract structured information from the provided document or transcript. "
    "You can extract ANY trading, financial, mathematical, or psychological concept mentioned. "
    "Even if it's general theory (e.g. Annualised Probability, Risk Models), extract it. "
    "Return ONLY valid JSON with this exact structure:\n"
    '{"concepts": ["list of concepts extracted"], '
    '"ea_rule_candidates": {'
    '"entry": ["sentence describing entry condition, if any"], '
    '"exit": ["sentence describing exit/TP condition, if any"], '
    '"stop_loss": ["sentence describing stop loss placement, if any"], '
    '"filter": ["sentence describing trade filter, if any"], '
    '"regime": ["sentence describing market regime/condition, if any"]}}\n'
    "Do not hallucinate. Leave rule candidates empty if the text does not contain them, but DO extract concepts."
)


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")


def _normalize(value: str) -> str:
    return f" {' '.join(value.lower().split())} "


def _split_sentences(text: str) -> list[str]:
    parts = re.split(r"(?<=[.!?])\s+|\n+", text.strip())
    return [part.strip() for part in parts if part.strip()]


def _sanitize_rule(rule: str) -> str | None:
    stripped = rule.strip()
    if not stripped or len(stripped) > _MAX_RULE_LEN:
        return None
    return stripped


def _detect_concepts(transcript: str, title: str) -> list[str]:
    haystack = _normalize(f"{title} {transcript}")
    found: list[str] = []
    for concept, patterns in CONCEPT_PATTERNS.items():
        if any(pattern in haystack for pattern in patterns):
            found.append(concept)
    return found


def _extract_rule_candidates(sentences: list[str]) -> dict[str, list[str]]:
    candidates = {key: [] for key in RULE_PATTERNS}
    for sentence in sentences:
        rule = _sanitize_rule(sentence)
        if rule is None:
            continue
        lowered = _normalize(rule)
        for rule_type, patterns in RULE_PATTERNS.items():
            if any(pattern in lowered for pattern in patterns):
                candidates[rule_type].append(rule)
    return candidates


def _quality_score(
    *,
    transcript: str,
    concepts: list[str],
    rule_candidates: dict[str, list[str]],
) -> dict[str, Any]:
    has_entry = bool(rule_candidates.get("entry"))
    has_exit = bool(rule_candidates.get("exit"))
    has_stop = bool(rule_candidates.get("stop_loss"))
    has_filter = bool(rule_candidates.get("filter"))
    has_regime = bool(rule_candidates.get("regime"))

    transcript_quality = min(100, max(20, len(transcript.split()) * 2))
    rule_completeness = (
        (10 if has_entry else 0)
        + (10 if has_stop else 0)
        + (5 if has_exit else 0)
        + (5 if has_filter else 0)
        + (5 if has_regime else 0)
        + min(65, len(concepts) * 15)
    )
    ea_readiness = min(100, int((transcript_quality * 0.25) + (rule_completeness * 0.75)))
    visual_dependency = "medium" if has_entry and not has_stop else "low"
    if len(transcript.split()) < 30:
        visual_dependency = "high"

    return {
        "transcript_quality": transcript_quality,
        "rule_completeness": rule_completeness,
        "ea_readiness": ea_readiness,
        "visual_dependency": visual_dependency,
        "conflict_risk": "unknown",
    }


def _llm_extract(
    *,
    title: str,
    transcript: str,
    llm_client: Any,
    keyframes: list[str] = None,
) -> dict[str, Any] | None:
    """Call LLM to extract concepts and rule candidates. Returns None on any failure."""
    try:
        import os
        gemini_key = os.environ.get("GEMINI_API_KEY")
        if gemini_key and llm_client is None:
            from google import genai
            from google.genai import types
            from PIL import Image
            client = genai.Client()
            contents = [f"Title: {title}\n\nTranscript:\n{transcript[:4000]}"]
            
            if keyframes:
                for kf in keyframes:
                    if Path(kf).exists():
                        contents.append(Image.open(kf))
                        
            response = client.models.generate_content(
                model='gemini-2.5-flash',
                contents=contents,
                config=types.GenerateContentConfig(
                    system_instruction=_LLM_SYSTEM,
                    temperature=0.2,
                )
            )
            text = response.text.strip()
        else:
            prompt = f"Title: {title}\n\nTranscript:\n{transcript[:4000]}"
            if hasattr(llm_client, "chat"):
                import os
                response = llm_client.chat.completions.create(
                    model=os.environ.get("LOCAL_LLM_MODEL", "google/gemma-4-e4b"),
                    messages=[
                        {"role": "system", "content": _LLM_SYSTEM},
                        {"role": "user", "content": prompt}
                    ],
                    temperature=0.2,
                )
                text = response.choices[0].message.content.strip()
            else:
                response = llm_client.messages.create(
                    model="claude-haiku-4-5-20251001",
                    max_tokens=1024,
                    system=_LLM_SYSTEM,
                    messages=[{"role": "user", "content": prompt}],
                )
                text = response.content[0].text.strip()
            
        json_match = re.search(r"\{.*\}", text, re.DOTALL)
        if not json_match:
            return None
        return json.loads(json_match.group())
    except Exception as e:
        print(f"Extraction error: {e}")
        return None


def _empty_rule_candidates() -> dict[str, list[str]]:
    return {"entry": [], "exit": [], "stop_loss": [], "filter": [], "regime": []}


def extract_structured_knowledge(
    *,
    title: str,
    transcript: str,
    source: dict[str, str],
    llm_client: Any | None = None,
    keyframes: list[str] = None,
) -> dict[str, Any]:
    sentences = _split_sentences(transcript)

    llm_result: dict[str, Any] | None = None
    if llm_client is not None or "GEMINI_API_KEY" in __import__("os").environ:
        llm_result = _llm_extract(title=title, transcript=transcript, llm_client=llm_client, keyframes=keyframes)

    if llm_result is not None:
        concepts = llm_result.get("concepts") or []
        raw_rc = llm_result.get("ea_rule_candidates") or {}
        rule_candidates = _empty_rule_candidates()
        for key in rule_candidates:
            raw_rules = raw_rc.get(key) or []
            rule_candidates[key] = [
                r for r in (_sanitize_rule(s) for s in raw_rules) if r is not None
            ]
        extraction_method = "llm"
    else:
        concepts = _detect_concepts(transcript, title)
        rule_candidates = _extract_rule_candidates(sentences)
        extraction_method = "keyword"

    quality = _quality_score(
        transcript=transcript,
        concepts=concepts,
        rule_candidates=rule_candidates,
    )

    return {
        "video_id": source.get("video_id", ""),
        "url": source.get("url", ""),
        "title": title,
        "extracted_at": _now_iso(),
        "concepts": concepts,
        "facts": sentences[:12],
        "ea_rule_candidates": rule_candidates,
        "quality": quality,
        "extraction_method": extraction_method,
        "status": "structured_extracted",
    }


class StructuredExtractionStore:
    def __init__(self, path: str | Path = DEFAULT_EXTRACTION_PATH):
        self.path = Path(path)

    def load(self) -> dict[str, Any]:
        if not self.path.exists():
            return {"version": 1, "items": {}}
        data = json.loads(self.path.read_text(encoding="utf-8"))
        if not isinstance(data, dict):
            raise ValueError("structured_extractions.json must contain a JSON object")
        data.setdefault("version", 1)
        data.setdefault("items", {})
        return data

    def save(self, data: dict[str, Any]) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        tmp_path = self.path.with_suffix(
            f".tmp-{datetime.now().strftime('%Y%m%d%H%M%S%f')}.json"
        )
        tmp_path.write_text(
            json.dumps(data, ensure_ascii=False, indent=2, sort_keys=True),
            encoding="utf-8",
        )
        tmp_path.replace(self.path)

    def upsert(self, item: dict[str, Any]) -> dict[str, bool]:
        video_id = item["video_id"]
        data = self.load()
        created = video_id not in data["items"]
        data["items"][video_id] = item
        self.save(data)
        return {"created": created}


def _frontmatter_value(text: str, key: str) -> str:
    match = re.search(rf"^{re.escape(key)}:\s*(.+)$", text, flags=re.MULTILINE)
    return match.group(1).strip() if match else ""


def _heading_section(text: str, heading: str) -> str:
    pattern = rf"^##\s+{re.escape(heading)}\s*$\n(?P<body>.*?)(?=^##\s+|\Z)"
    match = re.search(pattern, text, flags=re.MULTILINE | re.DOTALL)
    return match.group("body").strip() if match else ""


def _title_from_note(text: str, fallback: str) -> str:
    match = re.search(r"^#\s+(.+)$", text, flags=re.MULTILINE)
    return match.group(1).strip() if match else fallback


def _parse_raw_note(path: Path) -> dict[str, Any]:
    text = path.read_text(encoding="utf-8")
    video_id = _frontmatter_value(text, "video_id") or path.stem.split("_")[-1]
    source_url = _frontmatter_value(text, "source")
    
    keyframes = re.findall(r'!\[.*?\]\((.*?)\)', text)
    
    return {
        "video_id": video_id,
        "url": source_url,
        "title": _title_from_note(text, path.stem),
        "transcript": _heading_section(text, "Fact / Transcript Evidence"),
        "keyframes": keyframes,
    }


def extract_raw_notes(
    *,
    raw_dir: str | Path = DEFAULT_RAW_DIR,
    store: StructuredExtractionStore | None = None,
    manifest_store: ChannelManifestStore | None = None,
    llm_client: Any | None = None,
) -> dict[str, Any]:
    output_store = store or StructuredExtractionStore()
    manifest = manifest_store or ChannelManifestStore()
    directory = Path(raw_dir)

    result = {"processed": 0, "written": 0, "skipped": 0, "failed": 0}
    if not directory.exists():
        return result

    existing = output_store.load().get("items", {})

    for note_path in sorted(directory.glob("*.md")):
        result["processed"] += 1
        try:
            parsed = _parse_raw_note(note_path)
            if not parsed["transcript"]:
                result["skipped"] += 1
                continue
            # skip if already extracted with LLM (avoid redundant API calls)
            vid = parsed["video_id"]
            if llm_client is not None and existing.get(vid, {}).get("extraction_method") == "llm":
                result["skipped"] += 1
                continue
            item = extract_structured_knowledge(
                title=parsed["title"],
                transcript=parsed["transcript"],
                source={"video_id": vid, "url": parsed["url"]},
                llm_client=llm_client,
                keyframes=parsed.get("keyframes", []),
            )
            output_store.upsert(item)
            try:
                manifest.update_video_status(
                    vid,
                    "structured_extracted",
                    note_paths=[str(note_path)],
                )
            except KeyError:
                pass
            result["written"] += 1
        except Exception:
            result["failed"] += 1
    return result
