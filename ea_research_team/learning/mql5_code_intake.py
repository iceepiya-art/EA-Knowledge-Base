from __future__ import annotations

import argparse
import concurrent.futures
import hashlib
import json
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

import anthropic
try:
    from google import genai
    from google.genai import types
except ImportError:
    genai = None

try:
    from openai import OpenAI
except ImportError:
    OpenAI = None

MQL5_DIRS = [Path(r"G:\My Drive\jobot")]
OUTPUT_FILE = Path(
    r"g:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\data\raw\mql5_code_insights.json"
)
MANIFEST_FILE = Path(
    r"g:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\data\raw\mql5_code_manifest.json"
)
API_KEY = os.environ.get("GEMINI_API_KEY") or os.environ.get("ANTHROPIC_API_KEY") or os.environ.get("OPENAI_API_KEY")
DEFAULT_MODEL = "gemini-2.5-flash" if os.environ.get("GEMINI_API_KEY") else ("local-model" if os.environ.get("OPENAI_API_BASE") else os.environ.get("MQL5_LLM_MODEL", "claude-haiku-4-5-20251001"))



LLM_SYSTEM_PROMPT = """
You are an expert MQL4/MQL5 algorithmic trading developer and reverse engineer.
Analyze raw MQL source code (.mq4 / .mq5 / .mqh) and extract practical trading logic, rules, and best practices.
Return ONLY valid JSON. Do not include markdown code fences.
Return at most 8 highest-value concepts per file.

Extract these domains when present:
1. Account Locking / License System
2. Time Limits / Trading Sessions
3. Portfolio Limits / Drawdown Protection / Equity Management
4. Order Placement Styles / Entry Zones
5. Recovery Logic / Grid / Martingale / Hedging
6. Risk Management / Lot Sizing

FORMAT:
{
  "concepts": [
    {
      "topic": "Grid Recovery Logic",
      "description": "Explains how this EA handles recovery...",
      "category": "Recovery Logic",
      "confidence": 95,
      "code_snippet": ""
    }
  ]
}
Always set code_snippet to an empty string. Put the useful implementation detail in description instead.
If no useful trading logic is present, return {"concepts": []}.
"""


def _utc_now() -> str:
    return datetime.now(timezone.utc).isoformat()


def get_file_hash(file_path: str) -> str:
    hasher = hashlib.md5()
    try:
        with open(file_path, "rb") as f:
            for chunk in iter(lambda: f.read(1024 * 1024), b""):
                hasher.update(chunk)
        return hasher.hexdigest()
    except OSError:
        return ""


def load_manifest(path: Path = MANIFEST_FILE) -> dict[str, Any]:
    if not path.exists():
        return {"version": 1, "processed_hashes": {}}
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return {"version": 1, "processed_hashes": {}}
    if not isinstance(data, dict):
        return {"version": 1, "processed_hashes": {}}
    data.setdefault("version", 1)
    data.setdefault("processed_hashes", {})
    return data


def save_manifest(path: Path, manifest: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")


def mark_processed(
    manifest: dict[str, Any],
    source_file: Path,
    file_hash: str,
    *,
    concept_count: int,
    status: str,
    error: str | None = None,
) -> None:
    manifest.setdefault("processed_hashes", {})[file_hash] = {
        "source_file": str(source_file),
        "concept_count": concept_count,
        "status": status,
        "error": error,
        "processed_at": _utc_now(),
    }


def load_existing_insights(path: Path = OUTPUT_FILE) -> list[dict[str, Any]]:
    if not path.exists():
        return []
    try:
        data = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError):
        return []
    if not isinstance(data, list):
        return []
    return [item for item in data if isinstance(item, dict)]


def _insight_key(item: dict[str, Any]) -> tuple[str, str]:
    topic = str(item.get("topic") or "").strip()
    source_hash = str(item.get("source_hash") or "").strip()
    source_file = str(item.get("source_file") or "").strip()
    return (topic.casefold(), source_hash or source_file.casefold())


def save_insights(path: Path, insights: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    ordered = sorted(
        insights,
        key=lambda item: (
            str(item.get("source_file") or ""),
            str(item.get("category") or ""),
            str(item.get("topic") or ""),
        ),
    )
    path.write_text(json.dumps(ordered, indent=4, ensure_ascii=False), encoding="utf-8")


def backfill_manifest_from_existing(
    manifest: dict[str, Any], insights: list[dict[str, Any]]
) -> int:
    added = 0
    processed = manifest.setdefault("processed_hashes", {})
    counts: dict[str, int] = {}
    paths: dict[str, Path] = {}
    for item in insights:
        source = item.get("source_file")
        if not source:
            continue
        path = Path(str(source))
        if not path.exists():
            continue
        file_hash = str(item.get("source_hash") or get_file_hash(str(path)))
        if not file_hash:
            continue
        counts[file_hash] = counts.get(file_hash, 0) + 1
        paths[file_hash] = path
    for file_hash, count in counts.items():
        if file_hash in processed:
            continue
        mark_processed(
            manifest,
            paths[file_hash],
            file_hash,
            concept_count=count,
            status="processed_existing",
        )
        added += 1
    return added


def discover_mql_files(
    roots: list[Path],
    *,
    manifest: dict[str, Any],
    limit: int | None = None,
    max_size: int = 300_000,
) -> list[Path]:
    processed_hashes = {
        file_hash
        for file_hash, record in manifest.get("processed_hashes", {}).items()
        if not isinstance(record, dict)
        or record.get("status", "processed") in {"processed", "processed_existing", "no_concepts"}
    }
    found: list[Path] = []
    seen_hashes: set[str] = set()
    for root in roots:
        if not root.exists():
            continue
        candidates: list[Path] = []
        for ext in ("*.mq4", "*.mq5", "*.mqh"):
            candidates.extend(root.rglob(ext))
        for path in sorted(candidates, key=lambda p: str(p).casefold()):
            path_text = str(path).casefold()
            if "bak" in path_text:
                continue
            try:
                if path.stat().st_size > max_size:
                    continue
            except OSError:
                continue
            file_hash = get_file_hash(str(path))
            if not file_hash:
                continue
            if file_hash in processed_hashes or file_hash in seen_hashes:
                continue
            seen_hashes.add(file_hash)
            found.append(path)
            if limit is not None and len(found) >= limit:
                return found
    return found


def _read_code(file_path: Path) -> str:
    for encoding in ("utf-8", "utf-8-sig", "windows-1252", "cp874"):
        try:
            return file_path.read_text(encoding=encoding)
        except UnicodeDecodeError:
            continue
        except OSError:
            return ""
    return ""


def _parse_json_response(response_text: str) -> dict[str, Any]:
    text = response_text.strip()
    if text.startswith("```json"):
        text = text.removeprefix("```json").strip()
    if text.startswith("```"):
        text = text.removeprefix("```").strip()
    if text.endswith("```"):
        text = text.removesuffix("```").strip()
    try:
        data = json.loads(text)
    except json.JSONDecodeError:
        start = text.find("{")
        if start < 0:
            raise
        data, _ = json.JSONDecoder().raw_decode(text[start:])
    return data if isinstance(data, dict) else {"concepts": []}


def normalize_concepts(
    concepts: list[dict[str, Any]], source_file: Path, source_hash: str
) -> list[dict[str, Any]]:
    normalized: list[dict[str, Any]] = []
    for item in concepts:
        if not isinstance(item, dict):
            continue
        topic = str(item.get("topic") or "").strip()
        if not topic:
            continue
        confidence = item.get("confidence", 90)
        try:
            confidence = int(confidence)
        except (TypeError, ValueError):
            confidence = 90
        normalized.append(
            {
                "topic": topic,
                "description": str(item.get("description") or "").strip(),
                "category": str(item.get("category") or "General").strip() or "General",
                "confidence": max(0, min(100, confidence)),
                "code_snippet": str(item.get("code_snippet") or "").strip(),
                "source_file": str(source_file),
                "source_hash": source_hash,
            }
        )
    return normalized


def process_file(
    file_path: Path, client: Any, *, model: str = DEFAULT_MODEL
) -> list[dict[str, Any]]:
    code = _read_code(file_path)
    if not code:
        return []
    if len(code) > 80_000:
        code = code[:80_000]

    prompt = (
        "Analyze this MQL file and extract insights.\n\n"
        f"FileName: {file_path.name}\n\n{code}"
    )
    
    if hasattr(client, "models") and hasattr(client.models, "generate_content"):
        # Gemini Client
        response = client.models.generate_content(
            model=model,
            contents=prompt,
            config=types.GenerateContentConfig(
                system_instruction=LLM_SYSTEM_PROMPT,
                temperature=0.1,
            )
        )
        response_text = response.text.strip()
    elif hasattr(client, "chat") and hasattr(client.chat, "completions"):
        # OpenAI / LM Studio Client
        completion = client.chat.completions.create(
            model=model,
            messages=[
                {"role": "system", "content": LLM_SYSTEM_PROMPT},
                {"role": "user", "content": prompt}
            ],
            temperature=0.1,
        )
        response_text = completion.choices[0].message.content.strip()
    else:
        # Anthropic Client
        msg = client.messages.create(
            model=model,
            max_tokens=3072,
            temperature=0.1,
            system=LLM_SYSTEM_PROMPT,
            messages=[{"role": "user", "content": prompt}],
        )
        response_text = msg.content[0].text.strip()
        
    data = _parse_json_response(response_text)
    concepts = data.get("concepts", [])
    return concepts if isinstance(concepts, list) else []


def merge_insights(
    existing: list[dict[str, Any]], new_items: list[dict[str, Any]]
) -> list[dict[str, Any]]:
    by_key = {_insight_key(item): dict(item) for item in existing if _insight_key(item)[0]}
    for item in new_items:
        key = _insight_key(item)
        if not key[0]:
            continue
        by_key[key] = item
    return list(by_key.values())


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Extract MQL4/MQL5 trading logic insights.")
    parser.add_argument("--root", action="append", help="Root folder to scan. Can be repeated.")
    parser.add_argument("--limit", type=int, default=int(os.environ.get("MQL5_BATCH_LIMIT", "50")))
    parser.add_argument("--max-size", type=int, default=300_000)
    parser.add_argument("--workers", type=int, default=2)
    parser.add_argument("--model", default=DEFAULT_MODEL)
    parser.add_argument("--output", type=Path, default=OUTPUT_FILE)
    parser.add_argument("--manifest", type=Path, default=MANIFEST_FILE)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    if not API_KEY and not os.environ.get("OPENAI_API_BASE"):
        print("API Key required. Set GEMINI_API_KEY, ANTHROPIC_API_KEY, or OPENAI_API_BASE for Local LLM.")
        return

    roots = [Path(p) for p in args.root] if args.root else MQL5_DIRS
    existing = load_existing_insights(args.output)
    manifest = load_manifest(args.manifest)
    backfilled = backfill_manifest_from_existing(manifest, existing)
    files_to_process = discover_mql_files(
        roots,
        manifest=manifest,
        limit=args.limit,
        max_size=args.max_size,
    )
    save_manifest(args.manifest, manifest)
    print(
        f"Backfilled {backfilled} source files. "
        f"Found {len(files_to_process)} new MQL files to process."
    )
    if not files_to_process:
        return

    if os.environ.get("OPENAI_API_BASE") and OpenAI:
        client = OpenAI(
            base_url=os.environ.get("OPENAI_API_BASE"),
            api_key=os.environ.get("OPENAI_API_KEY", "lm-studio")
        )
        if args.model == "claude-haiku-4-5-20251001" or args.model == "gemini-2.5-flash":
             args.model = "local-model"
    elif os.environ.get("GEMINI_API_KEY") and genai:
        client = genai.Client()
        args.model = "gemini-2.5-flash"
    else:
        client = anthropic.Anthropic(api_key=API_KEY)
    new_insights: list[dict[str, Any]] = []

    def worker(path: Path) -> tuple[Path, str, list[dict[str, Any]], str | None]:
        file_hash = get_file_hash(str(path))
        try:
            raw_concepts = process_file(path, client, model=args.model)
            return path, file_hash, normalize_concepts(raw_concepts, path, file_hash), None
        except Exception as exc:
            return path, file_hash, [], str(exc)

    max_workers = max(1, args.workers)
    with concurrent.futures.ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = {executor.submit(worker, path): path for path in files_to_process}
        for count, future in enumerate(concurrent.futures.as_completed(futures), start=1):
            path, file_hash, concepts, error = future.result()
            if error:
                print(f"[{count}/{len(files_to_process)}] Error: {path.name}: {error}")
                mark_processed(
                    manifest,
                    path,
                    file_hash,
                    concept_count=0,
                    status="error",
                    error=error,
                )
            else:
                print(
                    f"[{count}/{len(files_to_process)}] "
                    f"Extracted {len(concepts)} concepts from {path.name}"
                )
                new_insights.extend(concepts)
                mark_processed(
                    manifest,
                    path,
                    file_hash,
                    concept_count=len(concepts),
                    status="processed",
                )
            if count % 10 == 0:
                save_insights(args.output, merge_insights(existing, new_insights))
                save_manifest(args.manifest, manifest)

    merged = merge_insights(existing, new_insights)
    save_insights(args.output, merged)
    save_manifest(args.manifest, manifest)
    print(f"Done. Added {len(new_insights)} insights. Total insights: {len(merged)}.")


if __name__ == "__main__":
    main()
