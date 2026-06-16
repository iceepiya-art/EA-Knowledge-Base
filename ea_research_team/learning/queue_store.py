"""
Queue Store — เก็บ pending items ใน JSON file
"""
import json
import shutil
import uuid
from datetime import datetime
from pathlib import Path

QUEUE_FILE = Path(__file__).parent / "queue.json"
QUEUE_BACKUP_DIR = Path(__file__).parent / "queue_backups"


def _timestamp() -> str:
    return datetime.now().strftime("%Y%m%d-%H%M%S")


def _backup_corrupt_file() -> Path:
    QUEUE_BACKUP_DIR.mkdir(exist_ok=True)
    backup = QUEUE_BACKUP_DIR / f"queue.corrupt-{_timestamp()}.json"
    shutil.copy2(QUEUE_FILE, backup)
    return backup


def _decode_first_json_array(raw: str) -> list[dict]:
    decoder = json.JSONDecoder()
    value, _ = decoder.raw_decode(raw.lstrip("\ufeff \t\r\n"))
    if not isinstance(value, list):
        raise ValueError("queue.json must contain a JSON list")
    return value


def _load() -> list[dict]:
    if not QUEUE_FILE.exists():
        return []
    raw = QUEUE_FILE.read_text(encoding="utf-8")
    try:
        data = json.loads(raw)
    except json.JSONDecodeError as exc:
        backup = _backup_corrupt_file()
        data = _decode_first_json_array(raw)
        _save(data)
        print(f"[queue_store] Repaired queue.json after JSON error: {exc}. Backup: {backup}")
    if not isinstance(data, list):
        raise ValueError("queue.json must contain a JSON list")
    return data


def _save(items: list[dict]):
    tmp_file = QUEUE_FILE.with_suffix(f".tmp-{_timestamp()}.json")
    with open(tmp_file, "w", encoding="utf-8") as f:
        json.dump(items, f, ensure_ascii=False, indent=2)
    tmp_file.replace(QUEUE_FILE)


def _normalize_text(value: str) -> str:
    return " ".join((value or "").strip().lower().split())


def _find_duplicate(items: list[dict], title: str, source: str, url: str = "") -> dict | None:
    normalized_title = _normalize_text(title)
    normalized_source = _normalize_text(source)
    normalized_url = _normalize_text(url)

    for item in items:
        if normalized_url and _normalize_text(item.get("url", "")) == normalized_url:
            return item
        if (
            _normalize_text(item.get("title", "")) == normalized_title
            and _normalize_text(item.get("source", "")) == normalized_source
        ):
            return item
    return None


def find_duplicate(title: str, source: str, url: str = "") -> dict | None:
    return _find_duplicate(_load(), title, source, url)


def add_item(title: str, source: str, category: str,
             content: str, summary: str, draft_note: str,
             url: str = "") -> str:
    items = _load()
    existing = _find_duplicate(items, title, source, url)
    if existing:
        return existing["id"]

    item_id = str(uuid.uuid4())[:8]
    items.append({
        "id": item_id,
        "title": title,
        "source": source,
        "category": category,
        "url": url,
        "content": content,
        "summary": summary,
        "draft_note": draft_note,
        "status": "pending",
        "created_at": datetime.now().strftime("%Y-%m-%d %H:%M"),
    })
    _save(items)
    return item_id


def get_item(item_id: str) -> dict | None:
    return next((i for i in _load() if i["id"] == item_id), None)


def get_pending() -> list[dict]:
    return [i for i in _load() if i["status"] == "pending"]


def get_approved() -> list[dict]:
    return [i for i in _load() if i["status"] == "approved"]


def get_all() -> list[dict]:
    return _load()


def approve_item(item_id: str, edited_note: str | None = None):
    items = _load()
    for item in items:
        if item["id"] == item_id:
            item["status"] = "approved"
            if edited_note is not None:
                item["draft_note"] = edited_note
            item["approved_at"] = datetime.now().strftime("%Y-%m-%d %H:%M")
    _save(items)


def reject_item(item_id: str):
    items = _load()
    for item in items:
        if item["id"] == item_id:
            item["status"] = "rejected"
    _save(items)


def mark_written(item_id: str):
    items = _load()
    for item in items:
        if item["id"] == item_id:
            item["status"] = "written"
    _save(items)


def count_by_status() -> dict:
    items = _load()
    result = {"pending": 0, "approved": 0, "rejected": 0, "written": 0}
    for item in items:
        s = item.get("status", "pending")
        result[s] = result.get(s, 0) + 1
    return result
