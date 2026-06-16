"""
Persistent job history — survives server restarts.
Stores last 300 events in learning/job_history.json
"""
import json
import os
import threading
from datetime import datetime

_PATH = os.path.join(os.path.dirname(__file__), "job_history.json")
_MAX = 300
_lock = threading.Lock()


def _load() -> list:
    try:
        with open(_PATH, encoding="utf-8") as f:
            data = json.load(f)
            return data if isinstance(data, list) else []
    except Exception:
        return []


def _save(events: list):
    tmp = _PATH + ".tmp"
    with open(tmp, "w", encoding="utf-8") as f:
        json.dump(events, f, ensure_ascii=False, indent=2)
    os.replace(tmp, _PATH)


def append(event_type: str, detail: str = "", level: str = "info"):
    """level: info | ok | warn | error"""
    with _lock:
        events = _load()
        events.append({
            "ts": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
            "type": event_type,
            "detail": detail,
            "level": level,
        })
        if len(events) > _MAX:
            events = events[-_MAX:]
        _save(events)


def get_recent(n: int = 50) -> list:
    with _lock:
        events = _load()
        return list(reversed(events[-n:]))
