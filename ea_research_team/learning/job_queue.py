"""
Async-safe job queue — submit tasks without waiting.
Worker thread processes jobs sequentially; collect runs independently.
"""
import queue
import threading
from datetime import datetime
from uuid import uuid4

import job_log

_nb_queue: queue.Queue = queue.Queue()
_collect_queue: queue.Queue = queue.Queue()

# id -> {id, type, desc, status, queued_at, started_at, finished_at, result, error}
JOBS: dict = {}
_lock = threading.Lock()


def _now():
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")


def _make_job(job_type: str, desc: str) -> str:
    jid = str(uuid4())[:8]
    with _lock:
        JOBS[jid] = {
            "id": jid,
            "type": job_type,
            "desc": desc,
            "status": "queued",
            "queued_at": _now(),
            "started_at": "",
            "finished_at": "",
            "result": "",
            "error": "",
        }
    return jid


def submit_notebook(desc: str, fn) -> str:
    """Queue a NotebookLM job (learn / quality / batch). Returns job id."""
    jid = _make_job("notebook", desc)
    job_log.append("job_queued", f"[{jid}] {desc[:60]}")
    _nb_queue.put((jid, fn))
    return jid


def submit_collect(desc: str, fn) -> str:
    """Queue a collect job (runs in its own thread, independent)."""
    jid = _make_job("collect", desc)
    job_log.append("job_queued", f"[{jid}] {desc[:60]}")
    _collect_queue.put((jid, fn))
    return jid


def get_active() -> list:
    """Jobs that are queued or running, newest first."""
    with _lock:
        active = [j for j in JOBS.values() if j["status"] in ("queued", "running")]
    return sorted(active, key=lambda j: j["queued_at"], reverse=True)


def get_recent(n: int = 20) -> list:
    """All jobs, newest first."""
    with _lock:
        jobs = list(JOBS.values())
    return sorted(jobs, key=lambda j: j["queued_at"], reverse=True)[:n]


def queue_size() -> int:
    return _nb_queue.qsize()


def _run_job(jid: str, fn):
    with _lock:
        if jid in JOBS:
            JOBS[jid]["status"] = "running"
            JOBS[jid]["started_at"] = _now()
    try:
        result = fn() or ""
        with _lock:
            if jid in JOBS:
                JOBS[jid]["status"] = "done"
                JOBS[jid]["result"] = str(result)[:200]
                JOBS[jid]["finished_at"] = _now()
        job_log.append("job_done", f"[{jid}] {result}"[:80] if result else f"[{jid}] done", "ok")
    except Exception as exc:
        with _lock:
            if jid in JOBS:
                JOBS[jid]["status"] = "error"
                JOBS[jid]["error"] = str(exc)[:200]
                JOBS[jid]["finished_at"] = _now()
        job_log.append("job_error", f"[{jid}] {str(exc)[:80]}", "error")


def _nb_worker():
    while True:
        jid, fn = _nb_queue.get()
        _run_job(jid, fn)
        _nb_queue.task_done()


def _collect_worker():
    while True:
        jid, fn = _collect_queue.get()
        _run_job(jid, fn)
        _collect_queue.task_done()


threading.Thread(target=_nb_worker, daemon=True, name="nb-worker").start()
threading.Thread(target=_collect_worker, daemon=True, name="collect-worker").start()
