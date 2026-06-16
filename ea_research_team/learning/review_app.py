"""
Review App - Flask web UI for reviewing learning items.
Run: python run.py review -> http://localhost:5055
"""
from datetime import datetime
import html
import json
import os
import re
import subprocess
import sys
import threading
import zipfile

from flask import Flask, jsonify, redirect, request, send_file, url_for

sys.path.insert(0, os.path.dirname(__file__))
import queue_store as qs
import prop_store as ps
import cme_store as cs
import prop_business_store as pbs
import ninja_store as ns
import alphaedge_store as aes
import job_log
import job_queue as jq

app = Flask(__name__)
NOTEBOOK_STORAGE = os.path.join(os.path.expanduser("~"), ".notebooklm", "storage_state.json")
STORE_MAP = {
    "prop":  ps.DATA_FILE,
    "cme":   cs.DATA_FILE,
    "biz":   pbs.DATA_FILE,
    "ninja": ns.DATA_FILE,
    "alphaedge": aes.DATA_FILE,
}
from ea_parsers import (
    _read_file_autoenc, _text_from_report,
    _parse_mt5_trade_history, _first_number_near,
    _parse_csv_backtest, _parse_backtest_report,
)
from ea_data import (
    EA_REGISTRY_PATH, EA_BACKTEST_PATH, EA_BACKTEST_UPLOAD_DIR,
    EA_CHECKLIST_PATH, EA_NOTES_PATH, EA_CUSTOMERS_PATH,
    EA_CUSTOMER_PACKAGE_DIR, METAEDITOR_CANDIDATES, EA_LOCK_TYPE_LABELS,
    EA_NOTE_FIELDS, EA_MANUAL_CHECKLIST, EA_PACKAGE_TYPES, EA_PRICE_PRESETS,
    EA_CUSTOMER_STATUSES, EA_CATALOG,
    _safe_ea_catalog, _ea_slug, _normalize_ea_record, _write_ea_catalog,
    _read_json_file, _write_json_file, _get_ea_catalog,
    _get_ea_backtests, _save_ea_backtest,
    _get_ea_checklist, _save_ea_checklist,
    _get_ea_notes, _save_ea_notes,
    _get_ea_customers, _ea_customer_pipeline,
    _generate_license_key, _save_ea_customer, _update_ea_customer,
    _find_ea_customer, _mark_customer_package, _update_customer_delivery,
    _mark_customer_build, _write_text_file,
    _generate_customer_package, _create_customer_zip,
    _find_metaeditor, _find_ea_main_mq5, _patch_mq5_for_customer,
    _scan_ea_folder, _ea_file_inventory, _ea_health, _pct,
    _ea_decision_snapshot, _ea_decision_board,
)

COLLECT_STATE = {
    "running": False,
    "last_started_at": "",
    "last_finished_at": "",
    "last_result": "",
    "last_error": "",
}

NOTEBOOK_STATE = {
    "running": False,
    "last_started_at": "",
    "last_finished_at": "",
    "last_result": "",
    "last_error": "",
    "last_notebook_id": "",
}

AUTH_STATE = {
    "running": False,
    "last_started_at": "",
    "last_finished_at": "",
    "last_result": "",
    "last_error": "",
}

WRITE_STATE = {
    "running": False,
    "last_started_at": "",
    "last_finished_at": "",
    "last_result": "",
    "last_error": "",
    "last_file": "",
}

QUALITY_STATE = {
    "running": False,
    "last_started_at": "",
    "last_finished_at": "",
    "last_result": "",
    "last_error": "",
    "last_notebook_id": "",
    "last_file": "",
}

BATCH_STATE = {
    "running": False,
    "last_started_at": "",
    "last_finished_at": "",
    "last_result": "",
    "last_error": "",
    "total": 0,
    "processed": 0,
    "learned": 0,
    "skipped": 0,
    "failed": 0,
    "current": "",
    "log": [],
    "remaining": "",
    "auto_login_started": False,
}


CATEGORY_ICON = {
    "AI_Updates": "AI",
    "Macro_News": "Macro",
    "Trading_Learn": "Trading",
}


def _auto_write(item_id: str):
    from writer import update_moc, write_atoms, write_note
    from queue_store import mark_written

    WRITE_STATE["running"] = True
    WRITE_STATE["last_started_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    WRITE_STATE["last_finished_at"] = ""
    WRITE_STATE["last_result"] = ""
    WRITE_STATE["last_error"] = ""
    WRITE_STATE["last_file"] = ""

    item = qs.get_item(item_id)
    try:
        if not item:
            WRITE_STATE["last_error"] = f"Item not found: {item_id}"
            return None

        path = write_note(item)
        if path:
            update_moc(item, path)
            write_atoms(item)
            mark_written(item_id)
            WRITE_STATE["last_file"] = str(path)
            WRITE_STATE["last_result"] = f"Wrote to Obsidian: {item.get('title', item_id)}"
            job_log.append("approve_write", item.get("title", item_id)[:80], "ok")
        else:
            WRITE_STATE["last_error"] = f"Writer returned no path for: {item.get('title', item_id)}"
            job_log.append("write_warn", f"No path: {item.get('title', item_id)[:60]}", "warn")
        return path
    except Exception as exc:
        WRITE_STATE["last_error"] = str(exc)
        job_log.append("write_error", str(exc)[:120], "error")
        raise
    finally:
        WRITE_STATE["last_finished_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        WRITE_STATE["running"] = False


def _set_write_result(message: str, file_path: str = ""):
    WRITE_STATE["running"] = False
    WRITE_STATE["last_started_at"] = WRITE_STATE["last_started_at"] or datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    WRITE_STATE["last_finished_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    WRITE_STATE["last_result"] = message
    WRITE_STATE["last_error"] = ""
    WRITE_STATE["last_file"] = file_path


def _set_write_error(message: str):
    WRITE_STATE["running"] = False
    WRITE_STATE["last_started_at"] = WRITE_STATE["last_started_at"] or datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    WRITE_STATE["last_finished_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    WRITE_STATE["last_result"] = ""
    WRITE_STATE["last_error"] = message


def _extract_notebook_id(raw_value: str) -> str:
    value = (raw_value or "").strip()
    marker = "/notebook/"
    if marker in value:
        value = value.split(marker, 1)[1]
    value = value.split("?", 1)[0]
    value = value.split("#", 1)[0]
    return value.strip().strip("/")


def _extract_notebook_ids(raw_value: str) -> list[str]:
    seen = set()
    notebook_ids = []
    for raw_line in (raw_value or "").replace(",", "\n").splitlines():
        notebook_id = _extract_notebook_id(raw_line)
        if notebook_id and notebook_id not in seen:
            seen.add(notebook_id)
            notebook_ids.append(notebook_id)
    return notebook_ids


def _start_collect_job() -> bool:
    def _fn():
        from run import cmd_collect
        COLLECT_STATE["running"] = True
        COLLECT_STATE["last_started_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        COLLECT_STATE["last_result"] = ""
        COLLECT_STATE["last_error"] = ""
        try:
            job_log.append("collect_start", "Daily collect started")
            cmd_collect()
            pending_count = qs.count_by_status().get("pending", 0)
            COLLECT_STATE["last_result"] = f"Collect completed. Pending: {pending_count}"
            job_log.append("collect_done", f"Pending +{pending_count}", "ok")
            return f"Pending +{pending_count}"
        except Exception as exc:
            COLLECT_STATE["last_error"] = str(exc)
            job_log.append("collect_error", str(exc), "error")
            raise
        finally:
            COLLECT_STATE["last_finished_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            COLLECT_STATE["running"] = False

    jq.submit_collect("Get New Knowledge", _fn)
    return True


def _start_notebook_job(notebook_input: str) -> tuple[bool, str]:
    notebook_id = _extract_notebook_id(notebook_input)
    if not notebook_id:
        return False, "Please enter a NotebookLM URL or notebook ID."

    def _fn():
        from run import cmd_learn_nb
        if not os.path.exists(NOTEBOOK_STORAGE):
            raise RuntimeError("NotebookLM auth missing. Press Reconnect Login first.")
        before = qs.count_by_status().get("pending", 0)
        job_log.append("notebook_start", f"Learn: {notebook_id[:8]}")
        cmd_learn_nb(notebook_id)
        added = max(qs.count_by_status().get("pending", 0) - before, 0)
        job_log.append("notebook_done", f"{notebook_id[:8]} +{added}", "ok" if added else "warn")
        NOTEBOOK_STATE["last_result"] = f"Notebook done. Pending +{added}"
        NOTEBOOK_STATE["last_notebook_id"] = notebook_id
        NOTEBOOK_STATE["last_finished_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        return f"+{added} items"

    q_size = jq.queue_size()
    jq.submit_notebook(f"Learn {notebook_id[:8]}", _fn)
    msg = f"Queued (position {q_size + 1})" if q_size > 0 else "Started"
    NOTEBOOK_STATE["last_notebook_id"] = notebook_id
    NOTEBOOK_STATE["last_started_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return True, msg


def _start_quality_job(notebook_input: str, learn_after: bool = False) -> tuple[bool, str]:
    notebook_id = _extract_notebook_id(notebook_input)
    if not notebook_id:
        return False, "Please enter a NotebookLM URL or notebook ID for Quality Check."

    label = f"Check+Learn {notebook_id[:8]}" if learn_after else f"Quality {notebook_id[:8]}"

    def _fn():
        from run import cmd_learn_nb, cmd_quality_nb
        if not os.path.exists(NOTEBOOK_STORAGE):
            raise RuntimeError("NotebookLM auth missing. Press Reconnect Login first.")
        report_path = cmd_quality_nb(notebook_id)
        QUALITY_STATE["last_file"] = report_path
        report_text = ""
        try:
            with open(report_path, "r", encoding="utf-8") as fh:
                report_text = fh.read()
        except OSError:
            pass
        if learn_after:
            if "READY_TO_LEARN" not in report_text:
                verdict = next((v for v in ["NEED_MORE_SOURCES", "REIMPORT_REQUIRED"] if v in report_text), "NOT_READY")
                return f"Skipped learn — verdict: {verdict}"
            before = qs.count_by_status().get("pending", 0)
            cmd_learn_nb(notebook_id)
            added = max(qs.count_by_status().get("pending", 0) - before, 0)
            return f"Check+Learn done. Pending +{added}"
        return f"Quality done: {os.path.basename(report_path)}"

    q_size = jq.queue_size()
    jq.submit_notebook(label, _fn)
    return True, f"Queued (position {q_size + 1})" if q_size > 0 else ""


def _start_batch_check_learn_job(notebook_input: str) -> tuple[bool, str]:
    notebook_ids = _extract_notebook_ids(notebook_input)
    if not notebook_ids:
        return False, "Please paste one or more NotebookLM URLs or notebook IDs."
    if len(notebook_ids) > 30:
        return False, "Batch limit is 30 notebooks at a time for stability."

    def _push_log(message: str):
        BATCH_STATE["log"].insert(0, f"{datetime.now().strftime('%H:%M:%S')} - {message}")
        BATCH_STATE["log"] = BATCH_STATE["log"][:12]

    def _fn():
        from run import cmd_learn_nb, cmd_quality_nb
        if not os.path.exists(NOTEBOOK_STORAGE):
            raise RuntimeError("NotebookLM auth missing. Press Reconnect Login first.")

        BATCH_STATE["running"] = True
        BATCH_STATE["last_started_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        BATCH_STATE["total"] = len(notebook_ids)
        BATCH_STATE["processed"] = BATCH_STATE["learned"] = BATCH_STATE["skipped"] = BATCH_STATE["failed"] = 0
        BATCH_STATE["log"] = []
        BATCH_STATE["remaining"] = ""

        for index, nb_id in enumerate(notebook_ids, 1):
            BATCH_STATE["current"] = nb_id
            _push_log(f"[{index}/{len(notebook_ids)}] Quality Check {nb_id[:8]}...")
            try:
                report_path = cmd_quality_nb(nb_id)
                report_text = ""
                try:
                    with open(report_path, "r", encoding="utf-8") as fh:
                        report_text = fh.read()
                except OSError:
                    pass
                if "READY_TO_LEARN" not in report_text:
                    verdict = next((v for v in ["NEED_MORE_SOURCES", "REIMPORT_REQUIRED"] if v in report_text), "NOT_READY")
                    BATCH_STATE["skipped"] += 1
                    _push_log(f"Skipped {nb_id[:8]} — {verdict}")
                    continue
                before = qs.count_by_status().get("pending", 0)
                _push_log(f"Learning {nb_id[:8]}...")
                cmd_learn_nb(nb_id)
                added = max(qs.count_by_status().get("pending", 0) - before, 0)
                BATCH_STATE["learned"] += added
                _push_log(f"Learned {nb_id[:8]} +{added}")
            except Exception as exc:
                BATCH_STATE["failed"] += 1
                _push_log(f"Failed {nb_id[:8]} — {exc}")
                if any(k in str(exc).lower() for k in ["authentication", "notebooklm login", "accounts.google.com"]):
                    BATCH_STATE["remaining"] = "\n".join(notebook_ids[index - 1:])
                    try:
                        login_bat = os.path.join(os.path.dirname(__file__), "notebooklm_login.bat")
                        if hasattr(os, "startfile"):
                            os.startfile(login_bat)
                    except Exception:
                        pass
                    raise RuntimeError("Login expired — batch stopped. Reconnect and rerun remaining.")
            finally:
                BATCH_STATE["processed"] += 1

        BATCH_STATE["running"] = False
        BATCH_STATE["last_finished_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        return f"Batch done: {BATCH_STATE['learned']} learned, {BATCH_STATE['skipped']} skipped, {BATCH_STATE['failed']} failed"

    q_size = jq.queue_size()
    jq.submit_notebook(f"Batch {len(notebook_ids)} notebooks", _fn)
    return True, f"Batch queued ({len(notebook_ids)} notebooks, position {q_size + 1})" if q_size > 0 else f"Batch started ({len(notebook_ids)} notebooks)"


def _start_notebook_login_job() -> tuple[bool, str]:
    if AUTH_STATE["running"]:
        return False, "NotebookLM reconnect is already running."

    def _worker():
        AUTH_STATE["running"] = True
        AUTH_STATE["last_started_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        AUTH_STATE["last_finished_at"] = ""
        AUTH_STATE["last_result"] = ""
        AUTH_STATE["last_error"] = ""

        try:
            login_bat = os.path.join(os.path.dirname(__file__), "notebooklm_login.bat")
            if hasattr(os, "startfile"):
                os.startfile(login_bat)
            else:
                subprocess.Popen(
                    [login_bat],
                    cwd=os.path.dirname(__file__),
                    shell=True,
                )
            AUTH_STATE["last_result"] = "Login helper opened. Finish login in the browser, then press ENTER in the black login window to save auth."
        except Exception as exc:
            AUTH_STATE["last_error"] = str(exc)
        finally:
            AUTH_STATE["last_finished_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            AUTH_STATE["running"] = False

    threading.Thread(target=_worker, daemon=True).start()
    return True, ""



def _tools_panel(message: str = "", level: str = "ok") -> str:
    lines = []
    active_jobs = jq.get_active()
    recent_jobs = jq.get_recent(8)
    auth_running = AUTH_STATE["running"]
    write_running = WRITE_STATE["running"]
    any_active = bool(active_jobs) or auth_running or write_running

    # AUTH status
    if auth_running:
        lines.append('<div class="status-line status-live"><span class="live-dot"></span>NotebookLM reconnect is running in the background.</div>')
    elif AUTH_STATE["last_error"]:
        lines.append(f'<div class="status-line status-warn">NotebookLM reconnect failed: {AUTH_STATE["last_error"]}</div>')
    elif AUTH_STATE["last_result"]:
        lines.append(f'<div class="status-line status-ok">{AUTH_STATE["last_result"]}</div>')

    # WRITE status
    if write_running:
        lines.append('<div class="status-line status-live"><span class="live-dot"></span>Writing approved knowledge to Obsidian...</div>')
    elif WRITE_STATE["last_error"]:
        lines.append(f'<div class="status-line status-warn">Write failed: {WRITE_STATE["last_error"]}</div>')
    elif WRITE_STATE["last_result"]:
        lines.append(f'<div class="status-line status-ok">{WRITE_STATE["last_result"]}</div>')
    if WRITE_STATE["last_file"]:
        lines.append(f'<div class="status-line">Latest note: {WRITE_STATE["last_file"]}</div>')

    # Remaining batch (saved after login expiry)
    if BATCH_STATE["remaining"]:
        remaining_count = len(_extract_notebook_ids(BATCH_STATE["remaining"]))
        lines.append(f'<div class="status-line status-warn">Remaining notebooks saved: {remaining_count}. After login, rerun the remaining list below.</div>')
    if BATCH_STATE["auto_login_started"]:
        lines.append('<div class="status-line status-ok">Login helper opened automatically. Finish Google login, then press ENTER in the black login window to save auth.</div>')

    # Flash message
    if message:
        css_class = "status-warn" if level == "warn" else "status-ok"
        lines.append(f'<div class="status-line {css_class}">{message}</div>')

    # Job queue table (recent + active)
    job_table = ""
    if recent_jobs:
        status_icons = {"running": "&#9654;", "queued": "&#8987;", "done": "&#10003;", "error": "&#10007;"}
        status_css = {"running": "status-live", "queued": "", "done": "status-ok", "error": "status-warn"}
        rows = ""
        for job in recent_jobs:
            icon = status_icons.get(job["status"], "")
            css = status_css.get(job["status"], "")
            result_text = html.escape((job.get("result") or job.get("error") or "")[:60])
            time_col = job.get("started_at") or job.get("queued_at", "")
            rows += f'<tr class="{css}"><td>{icon} {job["id"]}</td><td>{html.escape(job["desc"])}</td><td>{job["status"]}</td><td>{time_col}</td><td>{result_text}</td></tr>'
        job_table = f"""
        <div class="job-queue-widget">
          <div class="track-label">Job Queue ({len(active_jobs)} active)</div>
          <table class="job-table">
            <thead><tr><th>ID</th><th>Task</th><th>Status</th><th>Time</th><th>Result</th></tr></thead>
            <tbody>{rows}</tbody>
          </table>
        </div>"""

    # Animated tracks for active jobs
    track_colors = {"collect": ("Collect Stream", "track-bar", "track-runner"),
                    "notebook": ("Notebook Worker", "track-bar-alt", "track-runner")}
    animated_tracks = ""
    seen_types: set = set()
    for job in active_jobs:
        jtype = job["type"]
        if jtype not in seen_types:
            label, bar_cls, runner_cls = track_colors.get(jtype, (job["desc"][:30], "track-bar", "track-runner"))
            animated_tracks += f"""
        <div class="status-track">
          <div class="track-label">{label}: {html.escape(job["desc"])}</div>
          <div class="track-bar {bar_cls}"><div class="track-runner {runner_cls}"></div></div>
        </div>"""
            seen_types.add(jtype)
    if auth_running:
        animated_tracks += """
        <div class="status-track">
          <div class="track-label">Auth Reconnect</div>
          <div class="track-bar track-bar-warn"><div class="track-runner track-runner-warn"></div></div>
        </div>"""
    if write_running:
        animated_tracks += """
        <div class="status-track">
          <div class="track-label">Obsidian Write</div>
          <div class="track-bar track-bar-ok"><div class="track-runner track-runner-ok"></div></div>
        </div>"""

    auth_disabled = "disabled" if auth_running else ""

    remaining_batch = ""
    if BATCH_STATE["remaining"]:
        remaining_batch = f"""
        <div class="remaining-box">
          <div class="track-label">Remaining Batch After Login</div>
          <textarea class="tool-textarea" rows="5" readonly>{html.escape(BATCH_STATE["remaining"])}</textarea>
        </div>"""

    return """
    <div class="status-panel {panel_live}">
      <div class="quick-guide">
        <span class="guide-step">1. Reconnect NotebookLM if login expired</span>
        <span class="guide-step">2. Paste Notebook URL or ID</span>
        <span class="guide-step">3. Press Check + Learn — jobs queue up, no waiting</span>
      </div>
      {lines}
      {job_table}
      {animated_tracks}
      <div class="tool-row">
        <form method="POST" action="/collect" class="tool-form tool-form-inline">
          <button class="btn btn-collect-nav">Get New Knowledge</button>
        </form>
        <form method="POST" action="/learn-notebook" class="tool-form tool-form-wide">
          <input class="tool-input" type="text" name="notebook_input" placeholder="Paste NotebookLM URL or notebook ID here">
          <button class="btn btn-notebook">Learn Notebook</button>
        </form>
        <form method="POST" action="/quality-notebook" class="tool-form tool-form-wide">
          <input class="tool-input" type="text" name="notebook_input" placeholder="Paste NotebookLM URL or ID to quality check">
          <button class="btn btn-quality">Quality Check</button>
        </form>
        <form method="POST" action="/check-learn-notebook" class="tool-form tool-form-wide">
          <input class="tool-input" type="text" name="notebook_input" placeholder="Paste NotebookLM URL or ID for Check + Learn">
          <button class="btn btn-check-learn">Check + Learn</button>
        </form>
        <form method="POST" action="/notebook-login" class="tool-form tool-form-inline">
          <button class="btn btn-reconnect" {auth_disabled}>Reconnect Login</button>
        </form>
      </div>
      <form method="POST" action="/batch-check-learn" class="batch-form">
        <textarea class="tool-textarea" name="notebook_input" rows="5" placeholder="Batch NotebookLM URLs or IDs - one per line. Max 30 per run."></textarea>
        <button class="btn btn-batch">Batch Check + Learn</button>
      </form>
      {remaining_batch}
    </div>
    """.format(
        panel_live="panel-live" if any_active else "",
        lines="".join(lines),
        job_table=job_table,
        animated_tracks=animated_tracks,
        auth_disabled=auth_disabled,
        remaining_batch=remaining_batch,
    )


def _ea_command_center() -> str:
    return """
    <section class="command-center">
      <div class="command-head">
        <div>
          <div class="hero-kicker">EA Business OS</div>
          <h2>One Page Control Room</h2>
          <p>ทำงาน EA ทั้งเส้นทางจากความรู้ → พัฒนา → ทดสอบ → นำเสนอ → สมาชิก ในหน้าเดียว</p>
        </div>
        <span class="command-status">Blueprint Mode</span>
      </div>
      <div class="system-grid">
        <div class="system-card system-live">
          <span class="system-id">01</span>
          <h3>Knowledge Intake</h3>
          <p>NotebookLM, courses, YouTube, BabyPips, AI/news sources. ใช้ Check + Learn เป็นปุ่มหลัก.</p>
          <b>Active</b>
        </div>
        <div class="system-card">
          <span class="system-id">02</span>
          <h3>EA Development Lab</h3>
          <p>เก็บ EA, version, parameter, changelog, bug, logic, source/protected package.</p>
          <b>Next Build</b>
        </div>
        <div class="system-card">
          <span class="system-id">03</span>
          <h3>Backtest / Forward Test</h3>
          <p>นำเข้า report, trade history, PF/WR/DD, session, regime, symbol performance.</p>
          <b>Next Build</b>
        </div>
        <div class="system-card">
          <span class="system-id">04</span>
          <h3>Client Showcase</h3>
          <p>หน้าแสดงผล EA ให้ลูกค้า: จุดเด่น, ผลทดสอบ, risk, install guide, FAQ.</p>
          <b>Planned</b>
        </div>
        <div class="system-card">
          <span class="system-id">05</span>
          <h3>Membership / Licensing</h3>
          <p>รายเดือนล็อคพอร์ต, ซื้อขาดล็อคพอร์ต, ไม่ล็อคพอร์ต, source-code package.</p>
          <b>Planned</b>
        </div>
      </div>
      <div class="package-row">
        <span>Member Types</span>
        <strong>Monthly + Account Lock</strong>
        <strong>Lifetime + 1 Account</strong>
        <strong>Lifetime Unlimited</strong>
        <strong>Developer Source Code</strong>
      </div>
    </section>
    """


def _prop_case_panel() -> str:
    stats = ps.stats()
    cases = ps.recent_cases(6)
    rows = []
    for case in cases:
        rows.append(f"""
        <div class="prop-case">
          <div>
            <strong>{case.get('symbol') or '-'}</strong>
            <span>{case.get('bias') or '-'} / {case.get('verdict') or '-'}</span>
          </div>
          <div>
            <b>{case.get('score_total', 0)}/100</b>
            <span>{case.get('result') or 'OPEN'} · RR {case.get('rr') or '-'}</span>
          </div>
          <p>{case.get('cme_reason') or 'No CME reason yet'}</p>
        </div>
        """)
    if not rows:
        rows.append('<div class="prop-empty">ยังไม่มีเคส เริ่มบันทึกจาก trade plan แรกได้เลย</div>')

    return f"""
    <section class="prop-panel" id="prop-trading-section">
      <div class="command-head">
        <div>
          <div class="hero-kicker">Prop Trading Lab</div>
          <h2>CME + RR + SMC Case Collector</h2>
          <p>เก็บเคสจริงก่อนเขียน indicator: บันทึก bias, RR zone, SMC trigger, risk และผลลัพธ์ เพื่อหา pattern ที่ชนะจริง</p>
        </div>
        <span class="command-status">Cases {stats['total']} / 50</span>
      </div>
      <div class="prop-stats">
        <div><span>Total</span><strong>{stats['total']}</strong></div>
        <div><span>Win Rate</span><strong>{stats['win_rate']}%</strong></div>
        <div><span>Avg Score</span><strong>{stats['avg_score']}</strong></div>
        <div><span>Skipped</span><strong>{stats['skipped']}</strong></div>
      </div>
      <form method="POST" action="/prop-case" class="prop-form">
        <input name="symbol" placeholder="Symbol เช่น MGC1!, NQ1!, XAUUSD" required>
        <input name="account" placeholder="Account / Prop firm เช่น Topstep, Lucid">
        <select name="session">
          <option value="">Session</option>
          <option>Asia</option>
          <option>London</option>
          <option>New York</option>
          <option>Overlap</option>
        </select>
        <select name="bias">
          <option value="">Bias</option>
          <option>LONG</option>
          <option>SHORT</option>
          <option>NEUTRAL</option>
          <option>NO_TRADE</option>
        </select>
        <select name="verdict">
          <option value="">Verdict</option>
          <option>ALLOWED</option>
          <option>WAIT</option>
          <option>REDUCED_SIZE</option>
          <option>SKIP</option>
        </select>
        <select name="result">
          <option value="">Result</option>
          <option>OPEN</option>
          <option>WIN</option>
          <option>LOSS</option>
          <option>BE</option>
          <option>MANUAL_EXIT</option>
          <option>SKIPPED</option>
        </select>
        <input name="entry" placeholder="Entry">
        <input name="stop_loss" placeholder="SL">
        <input name="take_profit" placeholder="TP">
        <input name="rr" placeholder="RR เช่น 2.5">
        <input name="risk_percent" placeholder="Risk % เช่น 0.5">
        <input name="contracts" placeholder="Contracts / Lots">
        <textarea name="cme_reason" rows="2" placeholder="CME reason: bias, wall, SD level, target"></textarea>
        <textarea name="rr_reason" rows="2" placeholder="RR zone reason: ทำไมจุดนี้คุ้มเสี่ยง"></textarea>
        <textarea name="smc_trigger" rows="2" placeholder="SMC trigger: BOS, CHoCH, FVG, sweep, HL/LH"></textarea>
        <textarea name="mistake" rows="2" placeholder="Mistake / emotion / rule break"></textarea>
        <textarea name="lesson" rows="2" placeholder="Lesson / should become indicator logic?"></textarea>
        <input name="screenshot_path" placeholder="Screenshot path หรือ note link">
        <div class="score-grid">
          <label>CME <input name="score_cme" type="number" min="0" max="25" value="0"></label>
          <label>RR <input name="score_rr" type="number" min="0" max="25" value="0"></label>
          <label>SMC <input name="score_smc" type="number" min="0" max="25" value="0"></label>
          <label>Risk <input name="score_risk" type="number" min="0" max="25" value="0"></label>
        </div>
        <button class="btn btn-check-learn" type="submit">Save Prop Case</button>
      </form>
      <div class="prop-list">
        <div class="case-toolbar">
          <h3 style="margin:0">Recent Cases</h3>
          <input type="text" class="case-search-input" placeholder="Search..." oninput="filterCards('prop-case', this.value)">
          <a href="/export/prop" class="btn btn-small-export">Export</a>
          <form method="POST" action="/import/prop" enctype="multipart/form-data" style="display:inline">
            <label class="btn btn-small-import">Import<input type="file" name="file" accept=".json" style="display:none" onchange="this.form.submit()"></label>
          </form>
        </div>
        {''.join(rows)}
      </div>
    </section>
    """


def _cme_reading_panel() -> str:
    stats = cs.stats()
    cases = cs.recent_cases(5)
    rows = []
    for case in cases:
        rows.append(f"""
        <div class="cme-case">
          <div>
            <strong>{case.get('title') or '-'}</strong>
            <span>{case.get('product') or '-'} {case.get('expiration') or ''} · {case.get('bias') or '-'}</span>
          </div>
          <p>{case.get('trade_plan') or case.get('expert_text') or 'No reading text yet'}</p>
          <small>Support: {case.get('support') or '-'} · Resistance: {case.get('resistance') or '-'} · Pivot: {case.get('pivot') or '-'}</small>
        </div>
        """)
    if not rows:
        rows.append('<div class="prop-empty">ยังไม่มี Expert CME Reading Case</div>')

    return f"""
    <section class="cme-panel" id="cme-reading-section">
      <div class="command-head">
        <div>
          <div class="hero-kicker">Expert CME Reading</div>
          <h2>CME Reading Case Library</h2>
          <p>เก็บตัวอย่างการอ่าน CME จากผู้เชี่ยวชาญ เพื่อสกัดเป็นกฎ bias, support/resistance, skew, target และ no-trade condition</p>
        </div>
        <span class="command-status">Reading Cases {stats['total']}</span>
      </div>
      <div class="prop-stats">
        <div><span>Total</span><strong>{stats['total']}</strong></div>
        <div><span>Bullish</span><strong>{stats['bullish']}</strong></div>
        <div><span>Bearish</span><strong>{stats['bearish']}</strong></div>
        <div><span>Cautious</span><strong>{stats['cautious']}</strong></div>
      </div>
      <form method="POST" action="/cme-reading-case" class="cme-form">
        <input name="title" placeholder="Title เช่น Gold 17:00 Intraday Volume">
        <input name="analyst" placeholder="Expert / source name">
        <input name="product" placeholder="Product เช่น Gold, MGC, NQ">
        <input name="expiration" placeholder="Expiration เช่น G4MZ5">
        <select name="chart_type">
          <option value="">Chart Type</option>
          <option>Intraday Volume</option>
          <option>Open Interest</option>
          <option>OI Change</option>
          <option>Volatility / Skew</option>
          <option>SD / Walls</option>
        </select>
        <input name="reading_time" placeholder="Reading time เช่น 17:00">
        <input name="future_price" placeholder="Future price">
        <input name="future_change" placeholder="Future change">
        <input name="put_volume" placeholder="Put volume">
        <input name="call_volume" placeholder="Call volume">
        <input name="volatility" placeholder="Volatility">
        <input name="vol_change" placeholder="Vol change">
        <select name="bias">
          <option value="">Bias</option>
          <option>BULLISH</option>
          <option>BEARISH</option>
          <option>CAUTIOUS_BULL</option>
          <option>CAUTIOUS_BEAR</option>
          <option>RANGE</option>
          <option>NO_TRADE</option>
        </select>
        <input name="support" placeholder="Support / floor">
        <input name="resistance" placeholder="Resistance / gate">
        <input name="pivot" placeholder="Pivot">
        <input name="target" placeholder="Targets">
        <input name="invalidation" placeholder="Invalidation">
        <input name="image_path" placeholder="Image path / screenshot path">
        <textarea name="skew_reading" rows="2" placeholder="Skew / volatility interpretation"></textarea>
        <textarea name="trade_plan" rows="2" placeholder="Trade plan from expert reading"></textarea>
        <textarea name="risk_note" rows="2" placeholder="Risk note / caution / no-trade condition"></textarea>
        <textarea name="rules_learned" rows="2" placeholder="Rules learned: what should the system remember?"></textarea>
        <textarea name="expert_text" rows="5" placeholder="Paste full expert analysis text here"></textarea>
        <button class="btn btn-cme" type="submit">Save CME Reading</button>
      </form>
      <div class="prop-list">
        <div class="case-toolbar">
          <h3 style="margin:0">Recent CME Readings</h3>
          <input type="text" class="case-search-input" placeholder="Search..." oninput="filterCards('cme-case', this.value)">
          <a href="/export/cme" class="btn btn-small-export">Export</a>
          <form method="POST" action="/import/cme" enctype="multipart/form-data" style="display:inline">
            <label class="btn btn-small-import">Import<input type="file" name="file" accept=".json" style="display:none" onchange="this.form.submit()"></label>
          </form>
        </div>
        {''.join(rows)}
      </div>
    </section>
    """


def _prop_business_panel() -> str:
    stats = pbs.stats()
    accounts = pbs.recent_accounts(5)
    rows = []
    for account in accounts:
        rows.append(f"""
        <div class="business-account">
          <div>
            <strong>{account.get('account_name') or '-'}</strong>
            <span>{account.get('platform') or '-'} · {account.get('account_size') or '-'} · {account.get('status') or '-'}</span>
          </div>
          <div>
            <b>{account.get('net_profit', 0):,.2f}</b>
            <span>ROI {account.get('roi', 0)}%</span>
          </div>
          <p>{account.get('discipline_rule') or account.get('notes') or 'No business rule note yet'}</p>
        </div>
        """)
    if not rows:
        rows.append('<div class="prop-empty">ยังไม่มีบัญชี prop business เพิ่มบัญชีแรกเพื่อเริ่มวัดต้นทุน/ROI</div>')

    return f"""
    <section class="business-panel" id="prop-business-section">
      <div class="command-head">
        <div>
          <div class="hero-kicker">Prop Business</div>
          <h2>Funded Trading Business Tracker</h2>
          <p>มองการสอบพอร์ตเป็น SME: คุมต้นทุน, platform risk, payout, ROI, วินัย และแผน scale/copy trade</p>
        </div>
        <span class="command-status">Net {stats['net_profit']:,.2f}</span>
      </div>
      <div class="prop-stats">
        <div><span>Accounts</span><strong>{stats['total']}</strong></div>
        <div><span>Funded</span><strong>{stats['funded']}</strong></div>
        <div><span>Payouts</span><strong>{stats['total_payouts']:,.0f}</strong></div>
        <div><span>ROI</span><strong>{stats['roi']}%</strong></div>
      </div>
      <form method="POST" action="/prop-business-account" class="business-form">
        <input name="platform" placeholder="Platform เช่น Topstep, Lucid, Apex">
        <input name="account_name" placeholder="Account name">
        <input name="account_size" placeholder="Account size เช่น 50K, 150K">
        <select name="phase">
          <option value="">Phase</option>
          <option>Practice</option>
          <option>Evaluation</option>
          <option>Funded</option>
          <option>Payout</option>
        </select>
        <select name="status">
          <option value="">Status</option>
          <option>ACTIVE</option>
          <option>EVALUATION</option>
          <option>FUNDED</option>
          <option>PAUSED</option>
          <option>BLOWN</option>
          <option>CLOSED</option>
        </select>
        <input name="monthly_cost" placeholder="Monthly cost / fee">
        <input name="other_costs" placeholder="Other costs">
        <input name="payouts" placeholder="Payouts received">
        <input name="daily_loss_rule" placeholder="Daily loss rule">
        <input name="max_loss_rule" placeholder="Max loss / trailing drawdown">
        <input name="consistency_rule" placeholder="Consistency rule">
        <input name="copy_trade_plan" placeholder="Copy trade / scale plan">
        <textarea name="discipline_rule" rows="2" placeholder="Discipline rule: daily stop, tilt control, max trades/day"></textarea>
        <textarea name="single_point_risk" rows="2" placeholder="Single point of failure risk: illness, tilt, overtrade"></textarea>
        <textarea name="platform_risk" rows="2" placeholder="Platform risk: rule change, payout delay, firm risk"></textarea>
        <textarea name="notes" rows="2" placeholder="Business notes / next action"></textarea>
        <button class="btn btn-business" type="submit">Save Prop Business</button>
      </form>
      <div class="prop-list">
        <div class="case-toolbar">
          <h3 style="margin:0">Recent Business Accounts</h3>
          <input type="text" class="case-search-input" placeholder="Search..." oninput="filterCards('business-account', this.value)">
          <a href="/export/biz" class="btn btn-small-export">Export</a>
          <form method="POST" action="/import/biz" enctype="multipart/form-data" style="display:inline">
            <label class="btn btn-small-import">Import<input type="file" name="file" accept=".json" style="display:none" onchange="this.form.submit()"></label>
          </form>
        </div>
        {''.join(rows)}
      </div>
    </section>
    """


def _ninja_strategy_panel() -> str:
    stats = ns.stats()
    cases = ns.recent_cases(5)
    rows = []
    for case in cases:
        rows.append(f"""
        <div class="ninja-case">
          <div>
            <strong>{case.get('title') or '-'}</strong>
            <span>{case.get('setup_type') or '-'} · {case.get('asset') or '-'} · {case.get('htf') or '-'}->{case.get('ltf') or '-'}</span>
          </div>
          <p>{case.get('rules_learned') or case.get('entry_model') or 'No rule extracted yet'}</p>
          <small>Confirm: {case.get('confirmation') or '-'} · RR: {case.get('rr_logic') or '-'}</small>
        </div>
        """)
    if not rows:
        rows.append('<div class="prop-empty">ยังไม่มี Ninja Strategy Case</div>')

    return f"""
    <section class="ninja-panel" id="ninja-section">
      <div class="command-head">
        <div>
          <div class="hero-kicker">Ninja Strategy</div>
          <h2>Strategy Case Library</h2>
          <p>เก็บบทเรียนจากหลายคลิป Ninja เพื่อจับ pattern ซ้ำ: setup, HTF/LTF, entry, confirmation, SL/TP, RR และกฎที่ใช้ร่วมกับ CME</p>
        </div>
        <span class="command-status">Cases {stats['total']}</span>
      </div>
      <div class="prop-stats">
        <div><span>Total</span><strong>{stats['total']}</strong></div>
        <div><span>Setup Types</span><strong>{stats['setup_types']}</strong></div>
        <div><span>Top Setup</span><strong>{stats['top_type']}</strong></div>
        <div><span>Goal</span><strong>50</strong></div>
      </div>
      <form method="POST" action="/ninja-strategy-case" class="ninja-form">
        <input name="title" placeholder="Title / clip name">
        <input name="source_url" placeholder="YouTube / source URL">
        <select name="setup_type">
          <option value="">Setup Type</option>
          <option>Break Block</option>
          <option>CPB</option>
          <option>FIB RE</option>
          <option>Supply Demand</option>
          <option>Imbalance</option>
          <option>Liquidity Sweep</option>
          <option>HTF to LTF</option>
          <option>Pattern Setup</option>
          <option>Other</option>
        </select>
        <input name="asset" placeholder="Asset เช่น US30, XAUUSD, AUDUSD">
        <input name="htf" placeholder="HTF เช่น H1, H4">
        <input name="ltf" placeholder="LTF เช่น M5, M15">
        <input name="screenshot_path" placeholder="Screenshot path">
        <textarea name="market_context" rows="2" placeholder="Market context: trend/range, HTF structure, zone"></textarea>
        <textarea name="entry_model" rows="2" placeholder="Entry model: เข้าเพราะอะไร ตรงไหน"></textarea>
        <textarea name="confirmation" rows="2" placeholder="Confirmation: BOS, CHoCH, HL/LH, sweep, FVG, retest"></textarea>
        <textarea name="sl_logic" rows="2" placeholder="SL logic: วางหลังอะไร"></textarea>
        <textarea name="tp_logic" rows="2" placeholder="TP logic: เอาเป้าไปที่ไหน"></textarea>
        <textarea name="rr_logic" rows="2" placeholder="RR logic: ทำไม RR คุ้ม"></textarea>
        <textarea name="no_trade" rows="2" placeholder="No-trade condition"></textarea>
        <textarea name="cme_connection" rows="2" placeholder="เชื่อมกับ CME ยังไง: bias/level/target/wall"></textarea>
        <textarea name="rules_learned" rows="3" placeholder="Rules learned: กฎที่ระบบควรจำจากเคสนี้"></textarea>
        <textarea name="notes" rows="3" placeholder="Notes / transcript summary"></textarea>
        <button class="btn btn-ninja" type="submit">Save Ninja Case</button>
      </form>
      <div class="prop-list">
        <div class="case-toolbar">
          <h3 style="margin:0">Recent Ninja Cases</h3>
          <input type="text" class="case-search-input" placeholder="Search..." oninput="filterCards('ninja-case', this.value)">
          <a href="/export/ninja" class="btn btn-small-export">Export</a>
          <form method="POST" action="/import/ninja" enctype="multipart/form-data" style="display:inline">
            <label class="btn btn-small-import">Import<input type="file" name="file" accept=".json" style="display:none" onchange="this.form.submit()"></label>
          </form>
        </div>
        {''.join(rows)}
      </div>
    </section>
    """


def _alphaedge_journal_panel() -> str:
    stats = aes.stats()
    cases = aes.recent_cases(8)
    outcome_color = {
        "WIN": "#7bffb2",
        "LOSS": "#ff8e7f",
        "BE": "#ffd166",
        "OPEN": "#4dd0ff",
        "AVOID": "#ffb86b",
        "UNCLEAR": "#8fb2d9",
    }
    rows = []
    for case in cases:
        outcome = (case.get("outcome") or "OPEN").upper()
        color = outcome_color.get(outcome, "#8fb2d9")
        title = f"{case.get('trade_date') or '-'} | {case.get('symbol') or '-'} {case.get('timeframe') or '-'} {case.get('direction') or '-'}"
        rule = case.get("rule_learned") or case.get("setup") or case.get("notes") or "No rule captured yet"
        meta = (
            f"Grade {case.get('setup_grade') or '-'} | CME {case.get('cme_bias') or '-'} | "
            f"EMA {case.get('ema_bias') or '-'} | Structure {case.get('structure_bias') or '-'} | "
            f"RR {case.get('planned_rr') or '-'} | R {case.get('result_r') or '-'}"
        )
        rows.append(f"""
        <div class="ninja-case alphaedge-case" style="border-left:3px solid {color}">
          <div>
            <strong>{html.escape(title)}</strong>
            <span style="color:{color};font-weight:900">{html.escape(outcome)}</span>
          </div>
          <p>{html.escape(rule)}</p>
          <small>{html.escape(meta)} | PnL pts {html.escape(case.get('pnl_points') or '-')} | ${html.escape(case.get('pnl_money') or '-')}</small>
        </div>
        """)
    if not rows:
        rows.append('<div class="prop-empty">No AlphaEdge cases yet. Start by recording one forward-test screenshot case.</div>')

    return f"""
    <section class="ninja-panel" id="alphaedge-journal-section" style="border-color:rgba(123,255,178,.22)">
      <div class="command-head">
        <div>
          <div class="hero-kicker">AlphaEdge Journal</div>
          <h2>SMC + CME Forward Case Journal</h2>
          <p>บันทึกเคสจาก TradingView screenshot / forward test เพื่อแปลงภาพหลักฐานให้กลายเป็นสถิติจริง: WR, Avg R, bias, CME level และ rule ที่ควรจำ</p>
        </div>
        <span class="command-status">Cases {stats['total']}</span>
      </div>
      <div class="prop-stats">
        <div><span>Total</span><strong>{stats['total']}</strong></div>
        <div><span>Win Rate</span><strong>{stats['win_rate']}%</strong></div>
        <div><span>Avg R</span><strong>{stats['avg_r']}</strong></div>
        <div><span>Top Symbol</span><strong>{stats['top_symbol']}</strong></div>
      </div>
      <form method="POST" action="/alphaedge-case" class="ninja-form">
        <input name="trade_date" placeholder="Trade date เช่น 2026-05-06">
        <input name="symbol" placeholder="Symbol เช่น MGC, GC, MNQ, NQ">
        <input name="timeframe" placeholder="TF เช่น M1, M3, M5">
        <select name="direction">
          <option>BUY</option>
          <option>SELL</option>
          <option>WAIT</option>
        </select>
        <select name="setup_grade">
          <option>A+</option>
          <option>A</option>
          <option>B</option>
          <option>C</option>
          <option>Avoid</option>
        </select>
        <select name="outcome">
          <option>WIN</option>
          <option>LOSS</option>
          <option>BE</option>
          <option>OPEN</option>
          <option>UNCLEAR</option>
          <option>AVOID</option>
        </select>
        <select name="cme_bias">
          <option value="">CME Bias</option>
          <option>BULL</option>
          <option>BEAR</option>
          <option>RANGE</option>
          <option>MIXED</option>
        </select>
        <select name="ema_bias">
          <option value="">EMA Bias</option>
          <option>BULL</option>
          <option>BEAR</option>
          <option>RANGE</option>
          <option>MIXED</option>
        </select>
        <select name="structure_bias">
          <option value="">Structure Bias</option>
          <option>BULL</option>
          <option>BEAR</option>
          <option>RANGE</option>
          <option>MIXED</option>
        </select>
        <input name="cme_level" placeholder="CME level เช่น CALL 4630 / PUT 4600 / SETTLE">
        <input name="entry" placeholder="Entry">
        <input name="sl" placeholder="SL">
        <input name="tp" placeholder="TP">
        <input name="planned_rr" placeholder="Planned RR เช่น 2.5 หรือ 10.7">
        <input name="result_r" placeholder="Result R เช่น 1.5, -1, 6.3">
        <input name="pnl_points" placeholder="PnL points เช่น 69.8">
        <input name="pnl_money" placeholder="PnL money">
        <input name="risk_money" placeholder="Risk money">
        <input name="screenshot_path" placeholder="Screenshot path / evidence note">
        <textarea name="setup" rows="2" placeholder="Setup: sweep, BOS/CHoCH, FVG, OB, pullback, continuation"></textarea>
        <textarea name="confirmation" rows="2" placeholder="Confirmation: CME bias + SMC structure + EMA / session context"></textarea>
        <textarea name="mistake" rows="2" placeholder="Mistake / risk warning ถ้ามี"></textarea>
        <textarea name="rule_learned" rows="3" placeholder="Rule learned: กฎที่ระบบควรจำจากเคสนี้"></textarea>
        <textarea name="notes" rows="2" placeholder="Notes"></textarea>
        <button class="btn btn-quality" type="submit">Save AlphaEdge Case</button>
      </form>
      <div class="prop-list">
        <div class="case-toolbar">
          <h3 style="margin:0">Recent AlphaEdge Cases</h3>
          <input type="text" class="case-search-input" placeholder="Search..." oninput="filterCards('alphaedge-case', this.value)">
          <a href="/export/alphaedge" class="btn btn-small-export">Export</a>
          <form method="POST" action="/import/alphaedge" enctype="multipart/form-data" style="display:inline">
            <label class="btn btn-small-import">Import<input type="file" name="file" accept=".json" style="display:none" onchange="this.form.submit()"></label>
          </form>
        </div>
        {''.join(rows)}
      </div>
    </section>
    """


def _render_page(body: str, title: str = "Learning Review", show_hero: bool = True) -> str:
    counts = qs.count_by_status()
    auto_refresh = "true" if jq.get_active() or AUTH_STATE["running"] or WRITE_STATE["running"] else "false"
    cur_path = request.path
    _ah = "active" if cur_path == "/hub" or cur_path.startswith("/ea/") else ""
    _ar = "active" if cur_path in ("/", "/all", "/approved", "/written") else ""
    _al = "active" if cur_path == "/job-history" else ""
    hero = f"""
<div class="hero-shell">
  <div class="hero-panel">
    <div class="hero-copy">
      <div class="hero-kicker">Knowledge Ops</div>
      <h1>Learning Review Arena</h1>
      <p>Collect fresh intel, absorb NotebookLM knowledge, and clear pending review missions from one control room.</p>
    </div>
    <div class="hero-stats">
      <div class="hero-stat hero-stat-pending">
        <span class="hero-stat-label">Pending</span>
        <strong>{counts['pending']}</strong>
      </div>
      <div class="hero-stat hero-stat-approved">
        <span class="hero-stat-label">Approved</span>
        <strong>{counts['approved']}</strong>
      </div>
      <div class="hero-stat hero-stat-written">
        <span class="hero-stat-label">Written</span>
        <strong>{counts['written']}</strong>
      </div>
    </div>
  </div>
</div>
""" if show_hero else ""
    return f"""<!DOCTYPE html>
<html><head>
<meta charset="utf-8">
<title>{title}</title>
<style>
  :root {{
    --bg-0:#0d0d0d;
    --bg-1:#111111;
    --bg-2:#161616;
    --panel:#1a1a1a;
    --panel-2:#222222;
    --line:#282828;
    --line-bright:#383838;
    --text:#e8e8e6;
    --muted:#8a8784;
    --ok:#23d97e;
    --warn:#f6993f;
    --gold:#f0b429;
    --cyan:#4dd0ff;
    --teal:#22d3ee;
    --blue:#6366f1;
    --shadow:0 1px 4px rgba(0,0,0,.5),0 8px 32px rgba(0,0,0,.3);
    --sidebar-w:220px;
  }}
  * {{ box-sizing: border-box; margin: 0; padding: 0; }}
  body {{
    font-family: Inter, "Segoe UI", system-ui, -apple-system, sans-serif;
    background: var(--bg-0);
    color: var(--text);
    min-height: 100vh;
    letter-spacing: .01em;
  }}
  /* ── Sidebar ── */
  .sidebar {{
    position:fixed;
    top:0; left:0;
    width:var(--sidebar-w);
    height:100vh;
    background:var(--bg-1);
    border-right:1px solid var(--line);
    display:flex;
    flex-direction:column;
    z-index:200;
    overflow-y:auto;
  }}
  .sidebar-logo {{
    padding:18px 14px 14px;
    display:flex;
    align-items:center;
    gap:10px;
    border-bottom:1px solid var(--line);
    text-decoration:none;
  }}
  .sidebar-logo-icon {{
    width:30px; height:30px;
    background:var(--cyan);
    border-radius:7px;
    display:flex;
    align-items:center;
    justify-content:center;
    font-size:11px;
    font-weight:900;
    color:#000;
    letter-spacing:.04em;
    flex-shrink:0;
  }}
  .sidebar-logo-text {{
    font-size:13px;
    font-weight:700;
    color:var(--text);
    letter-spacing:.04em;
  }}
  .sidebar-logo-sub {{
    font-size:10px;
    color:var(--muted);
    letter-spacing:.04em;
  }}
  .sidebar-section {{
    padding:14px 10px 6px;
  }}
  .sidebar-section-label {{
    font-size:10px;
    font-weight:600;
    color:var(--muted);
    text-transform:uppercase;
    letter-spacing:.12em;
    padding:0 8px;
    margin-bottom:5px;
    display:block;
  }}
  .sidebar-link {{
    display:flex;
    align-items:center;
    gap:8px;
    padding:7px 10px;
    border-radius:6px;
    color:var(--muted);
    text-decoration:none;
    font-size:13px;
    font-weight:500;
    transition:background .12s,color .12s;
    margin-bottom:1px;
    white-space:nowrap;
    overflow:hidden;
  }}
  .sidebar-link:hover {{
    background:var(--bg-2);
    color:var(--text);
  }}
  .sidebar-link.active {{
    background:var(--bg-2);
    color:var(--text);
    font-weight:600;
  }}
  .sidebar-badge {{
    margin-left:auto;
    font-size:10px;
    background:rgba(77,208,255,.12);
    color:var(--cyan);
    border-radius:999px;
    padding:1px 7px;
    font-weight:700;
    flex-shrink:0;
  }}
  .sidebar-icon {{
    width:16px;
    text-align:center;
    font-size:13px;
    flex-shrink:0;
  }}
  .sidebar-footer {{
    margin-top:auto;
    padding:12px 10px;
    border-top:1px solid var(--line);
    font-size:10px;
    color:var(--muted);
    letter-spacing:.04em;
  }}
  /* ── Main content ── */
  .main-content {{
    margin-left:var(--sidebar-w);
    min-height:100vh;
  }}
  .container {{
    max-width:1040px;
    margin:0 auto;
    padding:28px 24px 48px;
    position:relative;
    z-index:1;
  }}
  .hero-shell {{
    margin-bottom:18px;
  }}
  .hero-panel {{
    display:grid;
    grid-template-columns: 1.35fr .95fr;
    gap:16px;
    background: var(--panel);
    border:1px solid var(--line-bright);
    border-radius:16px;
    padding:24px;
    box-shadow: var(--shadow);
    overflow:hidden;
    position:relative;
  }}
  .hero-kicker {{
    color:var(--cyan);
    text-transform:uppercase;
    letter-spacing:.18em;
    font-size:10px;
    margin-bottom:10px;
    font-weight:700;
  }}
  .hero-copy h1 {{
    font-size:28px;
    line-height:1.1;
    margin-bottom:10px;
    color:var(--text);
    font-weight:700;
    letter-spacing:-.01em;
  }}
  .hero-copy p {{
    color:var(--muted);
    max-width:620px;
    line-height:1.65;
    font-size:13px;
  }}
  .hero-stats {{
    display:grid;
    grid-template-columns: repeat(3, 1fr);
    gap:12px;
    align-self:end;
  }}
  .hero-stat {{
    min-height:110px;
    border-radius:18px;
    padding:16px 14px;
    border:1px solid rgba(255,255,255,.08);
    display:flex;
    flex-direction:column;
    justify-content:space-between;
    box-shadow: inset 0 1px 0 rgba(255,255,255,.03);
  }}
  .hero-stat-label {{
    font-size:10px;
    text-transform:uppercase;
    letter-spacing:.14em;
    color:var(--muted);
  }}
  .hero-stat strong {{
    font-size:32px;
    line-height:1;
    color:var(--text);
    font-weight:700;
  }}
  .hero-stat-pending {{
    background: rgba(77,208,255,.06);
    border-color:rgba(77,208,255,.15);
  }}
  .hero-stat-approved {{
    background: rgba(35,217,126,.06);
    border-color:rgba(35,217,126,.15);
  }}
  .hero-stat-written {{
    background: rgba(240,180,41,.06);
    border-color:rgba(240,180,41,.15);
  }}
  .section-title {{
    margin-bottom:14px;
    color:var(--text);
    font-size:13px;
    font-weight:600;
    letter-spacing:.04em;
    text-transform:uppercase;
  }}
  .bulk-bar {{
    background: var(--panel);
    border:1px solid var(--line);
    border-radius:10px;
    padding:12px 16px;
    margin-bottom:16px;
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    align-items:center;
    box-shadow: var(--shadow);
  }}
  .bulk-bar span {{
    color:var(--muted);
    font-size:12px;
    text-transform:uppercase;
    letter-spacing:.12em;
    margin-right:6px;
  }}
  .status-panel {{
    background: var(--panel);
    border:1px solid var(--line-bright);
    border-radius:12px;
    padding:18px 18px 16px;
    margin-bottom:18px;
    box-shadow: var(--shadow);
    position:relative;
    overflow:hidden;
  }}
  .quick-guide {{
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    margin:0 0 12px 0;
  }}
  .guide-step {{
    color:#cceaff;
    background:rgba(77,208,255,.09);
    border:1px solid rgba(77,208,255,.14);
    border-radius:999px;
    padding:6px 10px;
    font-size:11px;
    text-transform:uppercase;
    letter-spacing:.08em;
  }}
  .panel-live::after {{
    content:"";
    position:absolute;
    left:-20%;
    right:-20%;
    top:0;
    height:2px;
    background: linear-gradient(90deg, transparent, rgba(77,208,255,.15), rgba(77,208,255,.95), rgba(123,255,178,.5), transparent);
    animation: panelSweep 2.4s linear infinite;
  }}
  .status-panel::before {{
    content:"SYSTEM CONSOLE";
    position:absolute;
    top:10px;
    right:16px;
    color:rgba(191,230,255,.35);
    font-size:10px;
    letter-spacing:.18em;
  }}
  .status-line {{
    color:var(--muted);
    font-size:13px;
    line-height:1.75;
  }}
  .status-live {{
    color:#d9f7ff;
    text-shadow: 0 0 12px rgba(77,208,255,.18);
  }}
  .status-ok {{
    color:var(--ok);
    text-shadow: 0 0 12px rgba(123,255,178,.16);
  }}
  .status-warn {{
    color:var(--warn);
    text-shadow: 0 0 12px rgba(255,142,127,.14);
  }}
  .live-dot {{
    width:10px;
    height:10px;
    display:inline-block;
    border-radius:999px;
    margin-right:10px;
    background: radial-gradient(circle, #b9fff1 0%, #3de7df 45%, #0fa7c0 100%);
    box-shadow: 0 0 0 0 rgba(61,231,223,.55);
    animation: pulseDot 1.35s ease-out infinite;
    vertical-align:middle;
  }}
  .status-track {{
    margin-top:10px;
  }}
  .track-label {{
    color:#8fc4e8;
    font-size:11px;
    text-transform:uppercase;
    letter-spacing:.14em;
    margin-bottom:6px;
  }}
  .track-bar {{
    height:12px;
    border-radius:999px;
    overflow:hidden;
    background:
      linear-gradient(90deg, rgba(77,208,255,.05), rgba(77,208,255,.12), rgba(77,208,255,.05));
    border:1px solid rgba(77,208,255,.12);
    position:relative;
  }}
  .track-bar-alt {{
    background:
      linear-gradient(90deg, rgba(34,211,238,.05), rgba(123,255,178,.16), rgba(34,211,238,.05));
  }}
  .track-bar-warn {{
    background:
      linear-gradient(90deg, rgba(255,209,102,.06), rgba(255,142,127,.18), rgba(255,209,102,.06));
  }}
  .track-bar-ok {{
    background:
      linear-gradient(90deg, rgba(31,229,143,.06), rgba(123,255,178,.18), rgba(31,229,143,.06));
  }}
  .track-bar-gold {{
    background:
      linear-gradient(90deg, rgba(255,209,102,.05), rgba(255,209,102,.18), rgba(255,209,102,.05));
  }}
  .track-runner {{
    position:absolute;
    inset:1px auto 1px -30%;
    width:30%;
    border-radius:999px;
    background: linear-gradient(90deg, rgba(77,208,255,0), rgba(77,208,255,.45), rgba(77,208,255,1), rgba(123,255,178,.8), rgba(77,208,255,0));
    box-shadow: 0 0 20px rgba(77,208,255,.32);
    animation: trackRun 1.75s linear infinite;
  }}
  .track-runner-warn {{
    background: linear-gradient(90deg, rgba(255,142,127,0), rgba(255,142,127,.45), rgba(255,209,102,.95), rgba(255,142,127,.92), rgba(255,142,127,0));
    box-shadow: 0 0 20px rgba(255,142,127,.24);
  }}
  .track-runner-ok {{
    background: linear-gradient(90deg, rgba(31,229,143,0), rgba(31,229,143,.5), rgba(123,255,178,1), rgba(31,229,143,.75), rgba(31,229,143,0));
    box-shadow: 0 0 20px rgba(31,229,143,.28);
  }}
  .track-runner-gold {{
    background: linear-gradient(90deg, rgba(255,209,102,0), rgba(255,209,102,.45), rgba(255,209,102,1), rgba(255,238,184,.75), rgba(255,209,102,0));
    box-shadow: 0 0 20px rgba(255,209,102,.28);
  }}
  .tool-row {{
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    margin-top:14px;
  }}
  .tool-form {{ display:flex; gap:8px; align-items:center; }}
  .tool-form-inline {{ flex:0 0 auto; }}
  .tool-form-wide {{ flex:1 1 420px; }}
  .tool-input {{
    width:100%;
    min-width:260px;
    background: rgba(9,18,33,.92);
    color:var(--text);
    border:1px solid rgba(77,208,255,.16);
    border-radius:14px;
    padding:12px 14px;
    font-size:13px;
    outline:none;
    box-shadow: inset 0 0 0 1px rgba(255,255,255,.03);
  }}
  .tool-input:focus {{
    border-color:rgba(77,208,255,.45);
    box-shadow: 0 0 0 4px rgba(77,208,255,.08);
  }}
  .batch-form {{
    display:grid;
    grid-template-columns:1fr auto;
    gap:10px;
    align-items:stretch;
    margin-top:12px;
  }}
  .tool-textarea {{
    width:100%;
    min-height:92px;
    background: rgba(9,18,33,.92);
    color:var(--text);
    border:1px solid rgba(77,208,255,.16);
    border-radius:14px;
    padding:12px 14px;
    font-size:12px;
    font-family:Consolas, monospace;
    outline:none;
    resize:vertical;
  }}
  .tool-textarea:focus {{
    border-color:rgba(255,209,102,.45);
    box-shadow:0 0 0 4px rgba(255,209,102,.08);
  }}
  .remaining-box {{
    margin-top:12px;
    padding:12px;
    border-radius:16px;
    border:1px solid rgba(255,209,102,.18);
    background:rgba(255,209,102,.06);
  }}
  .command-center {{
    background:
      radial-gradient(circle at top left, rgba(255,209,102,.12), transparent 26%),
      linear-gradient(180deg, rgba(18,32,54,.98), rgba(10,20,34,.98));
    border:1px solid rgba(77,208,255,.18);
    border-radius:24px;
    padding:20px;
    margin:18px 0;
    box-shadow: var(--shadow);
  }}
  .command-head {{
    display:flex;
    justify-content:space-between;
    gap:14px;
    align-items:flex-start;
    margin-bottom:16px;
  }}
  .command-head h2 {{
    font-size:24px;
    text-transform:uppercase;
    letter-spacing:.06em;
    margin-bottom:8px;
  }}
  .command-head p {{
    color:#a8c7e7;
    font-size:13px;
    line-height:1.6;
  }}
  .command-status {{
    color:#ffd166;
    background:rgba(255,209,102,.1);
    border:1px solid rgba(255,209,102,.28);
    padding:8px 12px;
    border-radius:999px;
    font-size:11px;
    text-transform:uppercase;
    letter-spacing:.12em;
    white-space:nowrap;
  }}
  .system-grid {{
    display:grid;
    grid-template-columns: repeat(5, minmax(0, 1fr));
    gap:12px;
  }}
  .system-card {{
    min-height:178px;
    background:rgba(9,18,33,.72);
    border:1px solid rgba(77,208,255,.14);
    border-top:3px solid rgba(77,208,255,.65);
    border-radius:16px;
    padding:15px;
    display:flex;
    flex-direction:column;
    gap:8px;
  }}
  .system-live {{
    border-color:rgba(123,255,178,.26);
    border-top-color:#7bffb2;
    box-shadow:0 0 24px rgba(31,229,143,.1);
  }}
  .system-id {{
    color:#ffd166;
    font-size:11px;
    letter-spacing:.14em;
    font-weight:800;
  }}
  .system-card h3 {{
    font-size:14px;
    color:#f6fbff;
    line-height:1.35;
  }}
  .system-card p {{
    color:#91b5da;
    font-size:12px;
    line-height:1.55;
    flex:1;
  }}
  .system-card b {{
    color:#7bffb2;
    font-size:11px;
    text-transform:uppercase;
    letter-spacing:.1em;
  }}
  .package-row {{
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    align-items:center;
    margin-top:14px;
    padding-top:14px;
    border-top:1px solid rgba(77,208,255,.14);
  }}
  .package-row span {{
    color:#8fb2d9;
    font-size:11px;
    text-transform:uppercase;
    letter-spacing:.12em;
  }}
  .package-row strong {{
    color:#dff4ff;
    background:rgba(77,208,255,.08);
    border:1px solid rgba(77,208,255,.16);
    border-radius:999px;
    padding:7px 10px;
    font-size:11px;
  }}
  .prop-panel {{
    background:
      radial-gradient(circle at top right, rgba(31,229,143,.12), transparent 26%),
      linear-gradient(180deg, rgba(17,31,52,.98), rgba(8,17,31,.98));
    border:1px solid rgba(123,255,178,.18);
    border-radius:24px;
    padding:20px;
    margin:18px 0;
    box-shadow: var(--shadow);
  }}
  .prop-stats {{
    display:grid;
    grid-template-columns:repeat(4, 1fr);
    gap:10px;
    margin-bottom:16px;
  }}
  .prop-stats div {{
    background:rgba(9,18,33,.78);
    border:1px solid rgba(77,208,255,.14);
    border-radius:14px;
    padding:12px;
  }}
  .prop-stats span {{
    color:#8fb2d9;
    display:block;
    font-size:10px;
    text-transform:uppercase;
    letter-spacing:.14em;
    margin-bottom:7px;
  }}
  .prop-stats strong {{
    color:#fff;
    font-size:24px;
  }}
  .prop-form {{
    display:grid;
    grid-template-columns:repeat(4, 1fr);
    gap:10px;
    margin-bottom:18px;
  }}
  .prop-form input,
  .prop-form select,
  .prop-form textarea {{
    width:100%;
    background: rgba(8,15,28,.92);
    color:#e2f1ff;
    border:1px solid rgba(77,208,255,.16);
    border-radius:12px;
    padding:10px 11px;
    font-size:12px;
    font-family:Consolas, "Segoe UI", sans-serif;
    outline:none;
  }}
  .prop-form textarea {{
    grid-column:span 2;
    resize:vertical;
  }}
  .prop-form input:focus,
  .prop-form select:focus,
  .prop-form textarea:focus {{
    border-color:rgba(123,255,178,.45);
    box-shadow:0 0 0 3px rgba(123,255,178,.08);
  }}
  .score-grid {{
    grid-column:span 3;
    display:grid;
    grid-template-columns:repeat(4, 1fr);
    gap:8px;
  }}
  .score-grid label {{
    color:#8fb2d9;
    font-size:11px;
    text-transform:uppercase;
    letter-spacing:.1em;
  }}
  .score-grid input {{
    margin-top:5px;
  }}
  .prop-list {{
    border-top:1px solid rgba(77,208,255,.14);
    padding-top:14px;
  }}
  .prop-list h3 {{
    color:#bfe6ff;
    text-transform:uppercase;
    letter-spacing:.12em;
    font-size:13px;
    margin-bottom:10px;
  }}
  .case-toolbar {{
    display:flex;
    align-items:center;
    gap:8px;
    flex-wrap:wrap;
    margin-bottom:12px;
  }}
  .case-search-input {{
    flex:1;
    min-width:140px;
    padding:7px 12px;
    border-radius:10px;
    border:1px solid rgba(77,208,255,.22);
    background:#081524;
    color:#e8f3ff;
    font-size:12px;
  }}
  .btn-small-export, .btn-small-import {{
    padding:6px 12px;
    border-radius:8px;
    font-size:11px;
    font-weight:700;
    letter-spacing:.06em;
    cursor:pointer;
    text-decoration:none;
    white-space:nowrap;
  }}
  .btn-small-export {{
    background:rgba(77,208,255,.14);
    color:#4dd0ff;
    border:1px solid rgba(77,208,255,.3);
  }}
  .btn-small-import {{
    background:rgba(123,255,178,.12);
    color:#7bffb2;
    border:1px solid rgba(123,255,178,.28);
  }}
  .prop-case {{
    display:grid;
    grid-template-columns:1fr auto;
    gap:10px;
    background:rgba(9,18,33,.72);
    border:1px solid rgba(77,208,255,.12);
    border-radius:14px;
    padding:12px;
    margin-bottom:9px;
  }}
  .prop-case strong {{
    color:#fff;
    font-size:15px;
  }}
  .prop-case b {{
    color:#ffd166;
    font-size:16px;
  }}
  .prop-case span {{
    color:#8fb2d9;
    display:block;
    font-size:11px;
    margin-top:3px;
  }}
  .prop-case p {{
    grid-column:1 / -1;
    color:#a9c6e6;
    font-size:12px;
    line-height:1.55;
  }}
  .prop-empty {{
    color:#8fb2d9;
    background:rgba(9,18,33,.72);
    border:1px dashed rgba(77,208,255,.2);
    border-radius:14px;
    padding:18px;
    text-align:center;
  }}
  .cme-panel {{
    background:
      radial-gradient(circle at top left, rgba(77,208,255,.12), transparent 26%),
      linear-gradient(180deg, rgba(18,34,58,.98), rgba(8,17,31,.98));
    border:1px solid rgba(77,208,255,.22);
    border-radius:24px;
    padding:20px;
    margin:18px 0;
    box-shadow: var(--shadow);
  }}
  .cme-form {{
    display:grid;
    grid-template-columns:repeat(4, 1fr);
    gap:10px;
    margin-bottom:18px;
  }}
  .cme-form input,
  .cme-form select,
  .cme-form textarea {{
    width:100%;
    background: rgba(8,15,28,.92);
    color:#e2f1ff;
    border:1px solid rgba(77,208,255,.16);
    border-radius:12px;
    padding:10px 11px;
    font-size:12px;
    font-family:Consolas, "Segoe UI", sans-serif;
    outline:none;
  }}
  .cme-form textarea {{
    grid-column:span 2;
    resize:vertical;
  }}
  .cme-form textarea[name="expert_text"] {{
    grid-column:span 4;
  }}
  .btn-cme {{
    background:linear-gradient(180deg, #4dd0ff, #2f7df6);
    color:#03152e;
    box-shadow:0 10px 22px rgba(77,208,255,.24);
  }}
  .cme-case {{
    background:rgba(9,18,33,.72);
    border:1px solid rgba(77,208,255,.12);
    border-left:3px solid var(--cyan);
    border-radius:14px;
    padding:12px;
    margin-bottom:9px;
  }}
  .cme-case strong {{
    color:#fff;
    font-size:15px;
  }}
  .cme-case span,
  .cme-case small {{
    color:#8fb2d9;
    display:block;
    font-size:11px;
    margin-top:4px;
  }}
  .cme-case p {{
    color:#a9c6e6;
    font-size:12px;
    line-height:1.55;
    margin:8px 0;
  }}
  .business-panel {{
    background:
      radial-gradient(circle at top right, rgba(255,209,102,.14), transparent 26%),
      linear-gradient(180deg, rgba(31,29,45,.98), rgba(11,18,31,.98));
    border:1px solid rgba(255,209,102,.22);
    border-radius:24px;
    padding:20px;
    margin:18px 0;
    box-shadow: var(--shadow);
  }}
  .business-form {{
    display:grid;
    grid-template-columns:repeat(4, 1fr);
    gap:10px;
    margin-bottom:18px;
  }}
  .business-form input,
  .business-form select,
  .business-form textarea {{
    width:100%;
    background: rgba(8,15,28,.92);
    color:#e2f1ff;
    border:1px solid rgba(255,209,102,.16);
    border-radius:12px;
    padding:10px 11px;
    font-size:12px;
    font-family:Consolas, "Segoe UI", sans-serif;
    outline:none;
  }}
  .business-form textarea {{
    grid-column:span 2;
    resize:vertical;
  }}
  .btn-business {{
    background:linear-gradient(180deg, #ffd166, #f59e0b);
    color:#321d00;
    box-shadow:0 10px 22px rgba(255,209,102,.24);
  }}
  .business-account {{
    display:grid;
    grid-template-columns:1fr auto;
    gap:10px;
    background:rgba(9,18,33,.72);
    border:1px solid rgba(255,209,102,.12);
    border-left:3px solid var(--gold);
    border-radius:14px;
    padding:12px;
    margin-bottom:9px;
  }}
  .business-account strong {{
    color:#fff;
    font-size:15px;
  }}
  .business-account b {{
    color:#ffd166;
    font-size:16px;
  }}
  .business-account span {{
    color:#8fb2d9;
    display:block;
    font-size:11px;
    margin-top:4px;
  }}
  .business-account p {{
    grid-column:1 / -1;
    color:#a9c6e6;
    font-size:12px;
    line-height:1.55;
  }}
  .ninja-panel {{
    background:
      radial-gradient(circle at top left, rgba(255,120,120,.12), transparent 26%),
      linear-gradient(180deg, rgba(28,30,45,.98), rgba(8,17,31,.98));
    border:1px solid rgba(255,142,127,.2);
    border-radius:24px;
    padding:20px;
    margin:18px 0;
    box-shadow: var(--shadow);
  }}
  .ninja-form {{
    display:grid;
    grid-template-columns:repeat(4, 1fr);
    gap:10px;
    margin-bottom:18px;
  }}
  .ninja-form input,
  .ninja-form select,
  .ninja-form textarea {{
    width:100%;
    background: rgba(8,15,28,.92);
    color:#e2f1ff;
    border:1px solid rgba(255,142,127,.16);
    border-radius:12px;
    padding:10px 11px;
    font-size:12px;
    font-family:Consolas, "Segoe UI", sans-serif;
    outline:none;
  }}
  .ninja-form textarea {{
    grid-column:span 2;
    resize:vertical;
  }}
  .btn-ninja {{
    background:linear-gradient(180deg, #ff8e7f, #ef4444);
    color:#320b08;
    box-shadow:0 10px 22px rgba(255,142,127,.24);
  }}
  .ninja-case {{
    background:rgba(9,18,33,.72);
    border:1px solid rgba(255,142,127,.12);
    border-left:3px solid var(--warn);
    border-radius:14px;
    padding:12px;
    margin-bottom:9px;
  }}
  .ninja-case strong {{
    color:#fff;
    font-size:15px;
  }}
  .ninja-case span,
  .ninja-case small {{
    color:#8fb2d9;
    display:block;
    font-size:11px;
    margin-top:4px;
  }}
  .ninja-case p {{
    color:#a9c6e6;
    font-size:12px;
    line-height:1.55;
    margin:8px 0;
  }}
  .card {{
    background: var(--panel);
    border:1px solid var(--line);
    border-radius:10px;
    padding:18px;
    margin-bottom:10px;
    display:flex;
    gap:14px;
    box-shadow: var(--shadow);
    transition: border-color .15s ease;
  }}
  .card:hover {{
    border-color: var(--line-bright);
  }}
  .card.selected {{ border-color: var(--gold); background: rgba(240,180,41,.04); }}
  .card-check {{ padding-top:3px; }}
  .card-check input {{ width:16px; height:16px; cursor:pointer; accent-color:var(--cyan); }}
  .card-body {{ flex:1; }}
  .card-header {{ display:flex; align-items:center; gap:8px; margin-bottom:8px; flex-wrap:wrap; }}
  .badge {{
    padding:2px 8px;
    border-radius:4px;
    font-size:10px;
    font-weight:700;
    text-transform:uppercase;
    letter-spacing:.08em;
    border:1px solid var(--line-bright);
  }}
  .badge-ai {{ background:rgba(99,102,241,.12); color:#a5b4fc; border-color:rgba(99,102,241,.25); }}
  .badge-macro {{ background:rgba(35,217,126,.08); color:#6ee7b7; border-color:rgba(35,217,126,.2); }}
  .badge-trading {{ background:rgba(240,180,41,.08); color:#fcd34d; border-color:rgba(240,180,41,.2); }}
  .card h3 {{ font-size:15px; color:var(--text); margin-bottom:7px; font-weight:600; }}
  .meta {{ font-size:11px; color:var(--muted); margin-bottom:7px; }}
  .summary {{ font-size:13px; color:#b0b0ae; line-height:1.65; margin-bottom:12px; }}
  .draft {{
    background: var(--bg-2);
    border:1px solid var(--line);
    border-radius:8px;
    padding:12px;
    font-size:12px;
    color:var(--muted);
    margin-bottom:12px;
    white-space:pre-wrap;
    max-height:200px;
    overflow-y:auto;
    display:none;
  }}
  .draft.show {{ display:block; }}
  .actions {{ display:flex; gap:8px; flex-wrap:wrap; }}
  .btn {{
    padding:9px 16px;
    border:none;
    border-radius:12px;
    cursor:pointer;
    font-size:12px;
    font-weight:800;
    text-decoration:none;
    display:inline-block;
    text-transform:uppercase;
    letter-spacing:.08em;
    transition: transform .16s ease, box-shadow .16s ease, opacity .16s ease;
  }}
  .btn:hover {{ transform: translateY(-1px); }}
  .btn-approve {{ background:linear-gradient(180deg, #1fe58f, #0ea76b); color:#07231b; box-shadow:0 10px 24px rgba(31,229,143,.22); }}
  .btn-reject {{ background:linear-gradient(180deg, #ff857a, #e55353); color:#350908; box-shadow:0 10px 24px rgba(229,83,83,.18); }}
  .btn-edit {{ background:linear-gradient(180deg, #ffd166, #ffb703); color:#402b00; box-shadow:0 10px 24px rgba(255,209,102,.18); }}
  .btn-toggle {{ background:linear-gradient(180deg, #27466d, #1b3555); color:#bfe2ff; }}
  .btn-bulk-approve {{ background:linear-gradient(180deg, #1fe58f, #0ea76b); color:#07231b; }}
  .btn-bulk-reject {{ background:linear-gradient(180deg, #ff857a, #e55353); color:#350908; }}
  .btn-collect-nav {{ background:linear-gradient(180deg, #6aa6ff, #3665ff); color:#eef5ff; box-shadow:0 10px 22px rgba(54,101,255,.22); }}
  .btn-notebook {{ background:linear-gradient(180deg, #3de7df, #0fa7c0); color:#03242a; box-shadow:0 10px 22px rgba(34,211,238,.2); }}
  .btn-quality {{ background:linear-gradient(180deg, #9bffcb, #19c983); color:#052414; box-shadow:0 10px 22px rgba(31,229,143,.2); }}
  .btn-check-learn {{ background:linear-gradient(180deg, #ffe66d, #ff9f1c); color:#321d00; box-shadow:0 10px 22px rgba(255,209,102,.24); }}
  .btn-batch {{ background:linear-gradient(180deg, #c9f27f, #61d394); color:#10240c; box-shadow:0 10px 22px rgba(123,255,178,.22); min-width:190px; }}
  .btn-reconnect {{ background:linear-gradient(180deg, #ffd166, #ff8f5a); color:#321600; box-shadow:0 10px 22px rgba(255,142,127,.2); }}
  .btn-channel {{ background:linear-gradient(180deg, #ffd166, #ff9f1c); color:#382100; box-shadow:0 10px 22px rgba(255,209,102,.24); }}
  .btn:disabled {{ opacity:0.7; cursor:default; }}
  .btn-sel-all {{ background:linear-gradient(180deg, #35527e, #213a60); color:#e8f3ff; }}
  .btn-sel-none {{ background:rgba(16,29,49,.9); color:#8fb2d9; border:1px solid rgba(77,208,255,.14); }}
  .btn-cat {{ background:rgba(17,31,52,.95); color:#9ed6ff; border:1px solid rgba(77,208,255,.24); font-size:11px; padding:7px 12px; }}
  .empty {{
    text-align:center;
    color:#7ea4cb;
    padding:82px 26px;
    font-size:18px;
    background: linear-gradient(180deg, rgba(21,38,63,.92), rgba(15,27,46,.96));
    border:1px solid rgba(77,208,255,.16);
    border-radius:22px;
    box-shadow: var(--shadow);
  }}
  textarea {{
    width:100%;
    background: rgba(8,15,28,.92);
    color:#e2f1ff;
    border:1px solid rgba(77,208,255,.16);
    border-radius:12px;
    padding:12px;
    font-size:12px;
    font-family:Consolas, monospace;
    resize:vertical;
  }}
  .counter {{
    background:linear-gradient(180deg, #6aa6ff, #3665ff);
    color:#fff;
    border-radius:999px;
    padding:3px 10px;
    font-size:11px;
    font-weight:800;
    margin-left:6px;
    display:none;
    text-transform:uppercase;
    letter-spacing:.08em;
  }}
  .toast {{ position:fixed; bottom:24px; right:24px; background:linear-gradient(180deg, #1fe58f, #0ea76b); color:#062418; padding:12px 24px; border-radius:12px; font-weight:800; opacity:0; transition:opacity .3s; pointer-events:none; box-shadow:0 18px 34px rgba(31,229,143,.22); }}
  .toast.show {{ opacity:1; }}
  @keyframes pulseDot {{
    0% {{ box-shadow: 0 0 0 0 rgba(61,231,223,.5); transform: scale(1); }}
    70% {{ box-shadow: 0 0 0 10px rgba(61,231,223,0); transform: scale(1.06); }}
    100% {{ box-shadow: 0 0 0 0 rgba(61,231,223,0); transform: scale(1); }}
  }}
  @keyframes trackRun {{
    0% {{ left:-30%; }}
    100% {{ left:100%; }}
  }}
  @keyframes panelSweep {{
    0% {{ transform: translateX(-18%); opacity:.45; }}
    50% {{ opacity:1; }}
    100% {{ transform: translateX(18%); opacity:.45; }}
  }}
  @media (max-width: 900px) {{
    .sidebar {{ display:none; }}
    .main-content {{ margin-left:0; }}
    .hero-panel {{ grid-template-columns: 1fr; padding:18px; }}
    .hero-copy h1 {{ font-size:26px; }}
    .hero-stats {{ grid-template-columns: 1fr 1fr 1fr; }}
    .command-head {{ flex-direction:column; }}
    .system-grid {{ grid-template-columns:1fr; }}
    .prop-stats {{ grid-template-columns:1fr 1fr; }}
    .prop-form {{ grid-template-columns:1fr; }}
    .prop-form textarea, .score-grid {{ grid-column:span 1; }}
    .score-grid {{ grid-template-columns:1fr 1fr; }}
    .cme-form {{ grid-template-columns:1fr; }}
    .cme-form textarea, .cme-form textarea[name="expert_text"] {{ grid-column:span 1; }}
    .business-form {{ grid-template-columns:1fr; }}
    .business-form textarea {{ grid-column:span 1; }}
    .ninja-form {{ grid-template-columns:1fr; }}
    .ninja-form textarea {{ grid-column:span 1; }}
    .tool-form-wide {{ flex-basis:100%; }}
    .batch-form {{ grid-template-columns:1fr; }}
    .tool-row {{ flex-direction:column; }}
    .tool-form {{ width:100%; }}
    .btn-collect-nav, .btn-notebook, .btn-quality, .btn-check-learn, .btn-batch {{ width:100%; }}
    .container {{ padding:20px 16px 40px; }}
  }}
</style>
</head><body>
<aside class="sidebar">
  <a href="/hub" class="sidebar-logo">
    <div class="sidebar-logo-icon">EA</div>
    <div>
      <div class="sidebar-logo-text">EA OS</div>
      <div class="sidebar-logo-sub">Business OS</div>
    </div>
  </a>
  <div class="sidebar-section">
    <span class="sidebar-section-label">Workspace</span>
    <a href="/hub" class="sidebar-link {_ah}">
      <span class="sidebar-icon">⬡</span>Hub
    </a>
    <a href="/job-history" class="sidebar-link {_al}">
      <span class="sidebar-icon">▤</span>Log
    </a>
  </div>
  <div class="sidebar-section">
    <span class="sidebar-section-label">Learning</span>
    <a href="/" class="sidebar-link {_ar}">
      <span class="sidebar-icon">◈</span>Review
      <span class="sidebar-badge">{counts['pending']}</span>
    </a>
    <a href="/#cme-reading-section" class="sidebar-link">
      <span class="sidebar-icon">◉</span>CME
    </a>
    <a href="/hub#alphaedge-journal-section" class="sidebar-link">
      <span class="sidebar-icon">A</span>AlphaEdge
    </a>
    <a href="/#ninja-section" class="sidebar-link">
      <span class="sidebar-icon">◈</span>Ninja
    </a>
    <a href="/#prop-trading-section" class="sidebar-link">
      <span class="sidebar-icon">◎</span>Prop
    </a>
    <a href="/#prop-business-section" class="sidebar-link">
      <span class="sidebar-icon">⬠</span>Business
    </a>
  </div>
  <div class="sidebar-footer">EA OS v2.0</div>
</aside>
<div class="main-content">
<div class="container">{hero}{body}</div>
</div>
<div class="toast" id="toast"></div>
<script>
function toggleDraft(id) {{
  document.getElementById('draft-' + id).classList.toggle('show');
}}
function showToast(msg) {{
  const t = document.getElementById('toast');
  t.textContent = msg;
  t.classList.add('show');
  setTimeout(() => t.classList.remove('show'), 2500);
}}
function updateCounter() {{
  const checked = document.querySelectorAll('.item-check:checked').length;
  const c = document.getElementById('sel-count');
  if (!c) return;
  c.textContent = checked + ' selected';
  c.style.display = checked > 0 ? 'inline' : 'none';
}}
function selectAll() {{
  document.querySelectorAll('.item-check').forEach(cb => {{ cb.checked = true; cb.closest('.card').classList.add('selected'); }});
  updateCounter();
}}
function selectNone() {{
  document.querySelectorAll('.item-check').forEach(cb => {{ cb.checked = false; cb.closest('.card').classList.remove('selected'); }});
  updateCounter();
}}
function selectByCategory(cat) {{
  document.querySelectorAll('.item-check').forEach(cb => {{
    const match = cb.dataset.cat === cat;
    cb.checked = match;
    cb.closest('.card').classList.toggle('selected', match);
  }});
  updateCounter();
}}
function bulkAction(action) {{
  const ids = Array.from(document.querySelectorAll('.item-check:checked')).map(cb => cb.value);
  if (!ids.length) {{ showToast('Select at least one item first'); return; }}
  showToast('Processing ' + ids.length + ' item(s)...');
  fetch('/bulk/' + action, {{
    method: 'POST',
    headers: {{'Content-Type':'application/json'}},
    body: JSON.stringify({{ids}})
  }}).then(r => r.json()).then(d => {{
    showToast(d.message);
    setTimeout(() => location.reload(), 800);
  }});
}}
document.addEventListener('change', e => {{
  if (e.target.classList.contains('item-check')) {{
    e.target.closest('.card').classList.toggle('selected', e.target.checked);
    updateCounter();
  }}
}});
if ({auto_refresh}) {{
  setTimeout(() => location.reload(), 5000);
}}
function filterCards(cssClass, q) {{
  q = q.toLowerCase();
  document.querySelectorAll('.' + cssClass).forEach(el => {{
    el.style.display = el.textContent.toLowerCase().includes(q) ? '' : 'none';
  }});
}}
</script>
</body></html>"""


def _bulk_bar() -> str:
    return """
    <div class="bulk-bar">
      <span>Select:</span>
      <button class="btn btn-sel-all" onclick="selectAll()">All</button>
      <button class="btn btn-sel-none" onclick="selectNone()">None</button>
      <button class="btn btn-cat" onclick="selectByCategory('AI_Updates')">AI</button>
      <button class="btn btn-cat" onclick="selectByCategory('Trading_Learn')">Trading</button>
      <button class="btn btn-cat" onclick="selectByCategory('Macro_News')">Macro</button>
      <span id="sel-count" class="counter"></span>
      <div style="margin-left:auto;display:flex;gap:8px;">
        <button class="btn btn-bulk-approve" onclick="bulkAction('approve')">Approve Selected</button>
        <button class="btn btn-bulk-reject" onclick="bulkAction('reject')">Reject Selected</button>
      </div>
    </div>"""


def _card(item: dict, show_actions: bool = True) -> str:
    category = item.get("category", "")
    icon = CATEGORY_ICON.get(category, "Item")
    badge_class = {
        "AI_Updates": "badge-ai",
        "Macro_News": "badge-macro",
        "Trading_Learn": "badge-trading",
    }.get(category, "")
    item_id = item["id"]
    url = item.get("url", "")
    url_tag = f'<a href="{url}" target="_blank" style="color:#6366f1;font-size:12px;">Source</a>' if url else ""

    checkbox = f'<div class="card-check"><input type="checkbox" class="item-check" value="{item_id}" data-cat="{category}"></div>' if show_actions else ""

    if show_actions:
        actions = f"""
        <div class="actions">
          <form method="POST" action="/approve/{item_id}" style="display:inline">
            <button class="btn btn-approve">Approve</button>
          </form>
          <form method="POST" action="/reject/{item_id}" style="display:inline">
            <button class="btn btn-reject">Reject</button>
          </form>
          <button class="btn btn-toggle" onclick="toggleDraft('{item_id}')">Draft</button>
          {url_tag}
        </div>
        <div class="draft" id="draft-{item_id}">
          <form method="POST" action="/edit/{item_id}">
            <textarea name="note" rows="10">{item.get('draft_note', '')}</textarea>
            <br><br>
            <button class="btn btn-edit" type="submit">Save Edit</button>
          </form>
        </div>"""
    else:
        actions = f'<div class="meta">{url_tag}</div>'

    return f"""
    <div class="card">
      {checkbox}
      <div class="card-body">
        <div class="card-header">
          <span>{icon}</span>
          <span class="badge {badge_class}">{category}</span>
          <span class="meta">{item.get('source', '')} · {item.get('created_at', '')}</span>
        </div>
        <h3>{item.get('title', '')}</h3>
        <p class="summary">{item.get('summary', '')}</p>
        {actions}
      </div>
    </div>"""


def _page_body(heading: str, items: list[dict], show_actions: bool = False, message: str = "", level: str = "ok") -> str:
    body = _tools_panel(message=message, level=level)
    if not items:
        body += '<div class="empty">No items in this view right now.</div>'
        return body

    body += f"<h2 class='section-title'>{heading} ({len(items)})</h2>"
    if show_actions:
        body += _bulk_bar()
    body += "".join(_card(item, show_actions=show_actions) for item in items)
    return body


@app.route("/")
def index():
    items = qs.get_pending()
    body = _tools_panel()
    body += _ea_command_center()
    body += _prop_case_panel()
    body += _cme_reading_panel()
    body += _ninja_strategy_panel()
    body += _prop_business_panel()
    if not items:
        body += '<div class="empty">No pending items. Use Collect New or Learn Notebook above.</div>'
    else:
        body += f"<h2 class='section-title'>Pending Review ({len(items)})</h2>"
        body += _bulk_bar()
        body += "".join(_card(item) for item in items)
    return _render_page(body, "Pending Review")


@app.route("/approved")
def approved_page():
    items = qs.get_approved()
    return _render_page(_page_body("Approved", items, show_actions=False), "Approved")


@app.route("/written")
def written_page():
    items = [item for item in qs.get_all() if item["status"] == "written"]
    return _render_page(_page_body("Written", items, show_actions=False), "Written")


@app.route("/all")
def all_items():
    items = qs.get_all()
    body = _tools_panel()
    if not items:
        body += '<div class="empty">No items yet.</div>'
    else:
        body += f"<h2 class='section-title'>All Items ({len(items)})</h2>"
        body += "".join(_card(item, show_actions=(item["status"] == "pending")) for item in items)
    return _render_page(body, "All Items")


@app.route("/collect", methods=["POST"])
def collect_route():
    _start_collect_job()
    return redirect(url_for("index"))


@app.route("/learn-notebook", methods=["POST"])
def learn_notebook_route():
    notebook_input = request.form.get("notebook_input", "")
    started, message = _start_notebook_job(notebook_input)
    if not started and message:
        NOTEBOOK_STATE["last_error"] = message
    return redirect(url_for("index"))


@app.route("/quality-notebook", methods=["POST"])
def quality_notebook_route():
    notebook_input = request.form.get("notebook_input", "")
    started, message = _start_quality_job(notebook_input)
    if not started and message:
        QUALITY_STATE["last_error"] = message
    return redirect(url_for("index"))


@app.route("/check-learn-notebook", methods=["POST"])
def check_learn_notebook_route():
    notebook_input = request.form.get("notebook_input", "")
    started, message = _start_quality_job(notebook_input, learn_after=True)
    if not started and message:
        QUALITY_STATE["last_error"] = message
    return redirect(url_for("index"))


@app.route("/batch-check-learn", methods=["POST"])
def batch_check_learn_route():
    notebook_input = request.form.get("notebook_input", "")
    started, message = _start_batch_check_learn_job(notebook_input)
    if not started and message:
        BATCH_STATE["last_error"] = message
    return redirect(url_for("index"))


@app.route("/notebook-login", methods=["POST"])
def notebook_login_route():
    _start_notebook_login_job()
    return redirect(url_for("index"))


@app.route("/prop-case", methods=["POST"])
def prop_case_route():
    ps.add_case(request.form)
    return redirect(url_for("index"))


@app.route("/cme-reading-case", methods=["POST"])
def cme_reading_case_route():
    cs.add_case(request.form)
    return redirect(url_for("index"))


@app.route("/prop-business-account", methods=["POST"])
def prop_business_account_route():
    pbs.add_account(request.form)
    return redirect(url_for("index"))


@app.route("/ninja-strategy-case", methods=["POST"])
def ninja_strategy_case_route():
    ns.add_case(request.form)
    return redirect(url_for("index"))


@app.route("/alphaedge-case", methods=["POST"])
def alphaedge_case_route():
    aes.add_case(request.form)
    return redirect(url_for("hub_page") + "#alphaedge-journal-section")



@app.route("/export/<store>")
def export_store_route(store):
    path = STORE_MAP.get(store)
    if not path or not os.path.exists(path):
        return "Store not found", 404
    return send_file(path, as_attachment=True, download_name=os.path.basename(path))


@app.route("/import/<store>", methods=["POST"])
def import_store_route(store):
    path = STORE_MAP.get(store)
    if not path:
        return "Store not found", 404
    f = request.files.get("file")
    if not f:
        return redirect(request.referrer or url_for("index"))
    try:
        data = json.loads(f.read().decode("utf-8"))
        if not isinstance(data, list):
            raise ValueError("Expected JSON array")
        with open(path, "w", encoding="utf-8") as fh:
            json.dump(data, fh, ensure_ascii=False, indent=2)
        job_log.append("import", f"Imported {len(data)} records into {store}", "ok")
    except Exception as exc:
        job_log.append("import_error", f"{store}: {exc}", "error")
    return redirect(request.referrer or url_for("index"))


@app.route("/approve/<item_id>", methods=["POST"])
def approve(item_id):
    qs.approve_item(item_id)
    path = _auto_write(item_id)
    if path:
        _set_write_result(f"Approve complete. Wrote 1 item to Obsidian.", str(path))
    return redirect(url_for("index"))


@app.route("/reject/<item_id>", methods=["POST"])
def reject(item_id):
    qs.reject_item(item_id)
    _set_write_result(f"Rejected 1 item. Nothing was written.")
    return redirect(url_for("index"))


@app.route("/edit/<item_id>", methods=["POST"])
def edit(item_id):
    note = request.form.get("note", "")
    qs.approve_item(item_id, edited_note=note)
    path = _auto_write(item_id)
    if path:
        _set_write_result(f"Edit approved. Wrote 1 updated item to Obsidian.", str(path))
    return redirect(url_for("index"))


@app.route("/bulk/<action>", methods=["POST"])
def bulk_action(action):
    data = request.get_json()
    ids = data.get("ids", [])
    count = 0
    written_paths = []
    WRITE_STATE["running"] = True
    WRITE_STATE["last_started_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    WRITE_STATE["last_finished_at"] = ""
    WRITE_STATE["last_result"] = ""
    WRITE_STATE["last_error"] = ""
    WRITE_STATE["last_file"] = ""
    for item_id in ids:
        if action == "approve":
            qs.approve_item(item_id)
            path = _auto_write(item_id)
            if path:
                written_paths.append(str(path))
            count += 1
        elif action == "reject":
            qs.reject_item(item_id)
            count += 1

    if action == "approve":
        message = f"Approved {count} item(s) and wrote them to Obsidian."
        _set_write_result(message, written_paths[-1] if written_paths else "")
    else:
        message = f"Rejected {count} item(s)."
        _set_write_result(message)
    return jsonify({"message": message, "count": count})


@app.route("/write")
def write_route():
    from writer import write_all_approved

    WRITE_STATE["running"] = True
    WRITE_STATE["last_started_at"] = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    WRITE_STATE["last_finished_at"] = ""
    WRITE_STATE["last_result"] = ""
    WRITE_STATE["last_error"] = ""
    WRITE_STATE["last_file"] = ""
    count = write_all_approved()
    _set_write_result(f"Wrote {count} approved item(s) to Obsidian.")
    body = _tools_panel(message=f"Wrote {count} approved item(s) to Obsidian.")
    body += '<div class="empty"><a href="/" class="btn btn-approve" style="margin-top:0;display:inline-block;">Back to Review</a></div>'
    return _render_page(body, "Write Complete")


@app.route("/ea-open/<ea_id>", methods=["POST"])
def ea_open_route(ea_id):
    ea = _safe_ea_catalog().get(ea_id)
    if not ea:
        return redirect(url_for("hub_page"))
    path = ea["path"]
    if os.path.exists(path) and hasattr(os, "startfile"):
        try:
            os.startfile(path)
            job_log.append("ea_open", ea["name"], "ok")
        except Exception as exc:
            job_log.append("ea_open_error", f"{ea['name']}: {exc}", "error")
    next_url = request.form.get("next") or url_for("hub_page")
    return redirect(next_url)


@app.route("/ea-add", methods=["POST"])
def ea_add_route():
    catalog = _get_ea_catalog()
    existing = {ea["id"] for ea in catalog}
    record = _normalize_ea_record(request.form.to_dict(), existing)
    catalog.append(record)
    _write_ea_catalog(catalog)
    job_log.append("ea_add", record["name"], "ok")
    return redirect(url_for("ea_detail_route", ea_id=record["id"]))


@app.route("/ea-update/<ea_id>", methods=["POST"])
def ea_update_route(ea_id):
    catalog = _get_ea_catalog()
    updated = None
    for i, ea in enumerate(catalog):
        if ea["id"] != ea_id:
            continue
        new_record = dict(ea)
        for key in ["name", "icon", "kind", "market", "stage", "path", "focus", "next", "accent"]:
            new_record[key] = request.form.get(key, ea.get(key, ""))
        new_record["id"] = ea_id
        catalog[i] = _normalize_ea_record(new_record, set())
        catalog[i]["id"] = ea_id
        updated = catalog[i]
        break
    if updated:
        _write_ea_catalog(catalog)
        job_log.append("ea_update", updated["name"], "ok")
        return redirect(url_for("ea_detail_route", ea_id=ea_id))
    return redirect(url_for("hub_page"))


@app.route("/ea-archive/<ea_id>", methods=["POST"])
def ea_archive_route(ea_id):
    try:
        with open(EA_REGISTRY_PATH, "r", encoding="utf-8") as f:
            raw = json.load(f)
    except Exception:
        raw = []
    name = ea_id
    changed = False
    for rec in raw if isinstance(raw, list) else []:
        if isinstance(rec, dict) and rec.get("id") == ea_id:
            rec["archived"] = True
            name = rec.get("name", ea_id)
            changed = True
            break
    if changed:
        with open(EA_REGISTRY_PATH, "w", encoding="utf-8") as f:
            json.dump(raw, f, ensure_ascii=False, indent=2)
        job_log.append("ea_archive", name, "ok")
    return redirect(url_for("hub_page"))


@app.route("/ea-backtest-import/<ea_id>", methods=["POST"])
def ea_backtest_import_route(ea_id):
    ea = _safe_ea_catalog().get(ea_id)
    if not ea:
        return redirect(url_for("hub_page"))
    report_path = (request.form.get("report_path") or "").strip().strip('"')
    uploaded = request.files.get("report_file")
    content = ""
    source_path = report_path
    try:
        if uploaded and uploaded.filename:
            os.makedirs(EA_BACKTEST_UPLOAD_DIR, exist_ok=True)
            safe_name = re.sub(r"[^A-Za-z0-9._ -]+", "_", uploaded.filename).strip() or "backtest_report.html"
            source_path = os.path.join(EA_BACKTEST_UPLOAD_DIR, f"{ea_id}_{datetime.now().strftime('%Y%m%d_%H%M%S')}_{safe_name}")
            uploaded.save(source_path)
        if not source_path or not os.path.exists(source_path):
            job_log.append("ea_backtest_error", f"{ea['name']}: report not found", "error")
            return redirect(url_for("ea_detail_route", ea_id=ea_id))
        content = _read_file_autoenc(source_path)
        report = _parse_backtest_report(source_path, content)
        report["notes"] = (request.form.get("notes") or "").strip()
        _save_ea_backtest(ea_id, report)
        job_log.append("ea_backtest_import", f"{ea['name']}: {report['file']}", "ok")
    except Exception as exc:
        job_log.append("ea_backtest_error", f"{ea['name']}: {exc}", "error")
    return redirect(url_for("ea_detail_route", ea_id=ea_id))


@app.route("/ea-checklist/<ea_id>", methods=["POST"])
def ea_checklist_route(ea_id):
    ea = _safe_ea_catalog().get(ea_id)
    if not ea:
        return redirect(url_for("hub_page"))
    record = _save_ea_checklist(ea_id, request.form)
    done = sum(1 for ok in record["checks"].values() if ok)
    job_log.append("ea_checklist", f"{ea['name']}: {done}/{len(EA_MANUAL_CHECKLIST)}", "ok")
    return redirect(url_for("ea_detail_route", ea_id=ea_id))


@app.route("/ea-notes/<ea_id>", methods=["POST"])
def ea_notes_route(ea_id):
    ea = _safe_ea_catalog().get(ea_id)
    if not ea:
        return redirect(url_for("hub_page"))
    _save_ea_notes(ea_id, request.form)
    job_log.append("ea_notes", ea["name"], "ok")
    return redirect(url_for("ea_detail_route", ea_id=ea_id))


@app.route("/ea-customer-add/<ea_id>", methods=["POST"])
def ea_customer_add_route(ea_id):
    ea = _safe_ea_catalog().get(ea_id)
    if not ea:
        return redirect(url_for("hub_page"))
    customer = _save_ea_customer(ea_id, request.form)
    job_log.append("ea_customer", f"{ea['name']} -> {customer['buyer_name']}", "ok")
    return redirect(url_for("ea_detail_route", ea_id=ea_id))


@app.route("/ea-customer-update/<ea_id>/<customer_id>", methods=["POST"])
def ea_customer_update_route(ea_id, customer_id):
    ea = _safe_ea_catalog().get(ea_id)
    if not ea:
        return redirect(url_for("hub_page"))
    customer = _update_ea_customer(ea_id, customer_id, request.form)
    if customer:
        action = request.form.get("action") or "update"
        job_log.append("ea_customer_update", f"{ea['name']} -> {customer.get('buyer_name', customer_id)} ({action})", "ok")
    else:
        job_log.append("ea_customer_missing", f"{ea['name']} -> {customer_id}", "warn")
    return redirect(url_for("ea_detail_route", ea_id=ea_id))


@app.route("/ea-customer-package/<ea_id>/<customer_id>", methods=["POST"])
def ea_customer_package_route(ea_id, customer_id):
    ea = _safe_ea_catalog().get(ea_id)
    if not ea:
        return redirect(url_for("hub_page"))
    customer = _find_ea_customer(ea_id, customer_id)
    if not customer:
        job_log.append("ea_package_missing", f"{ea['name']} -> {customer_id}", "warn")
        return redirect(url_for("ea_detail_route", ea_id=ea_id))
    try:
        package_path = _generate_customer_package(ea, customer)
        job_log.append("ea_package", f"{ea['name']} -> {customer.get('buyer_name', customer_id)}", "ok")
        if request.form.get("open") == "1" and hasattr(os, "startfile"):
            os.startfile(package_path)
    except Exception as exc:
        job_log.append("ea_package_error", f"{ea['name']}: {exc}", "error")
    return redirect(url_for("ea_detail_route", ea_id=ea_id))


@app.route("/ea-customer-zip/<ea_id>/<customer_id>", methods=["POST"])
def ea_customer_zip_route(ea_id, customer_id):
    ea = _safe_ea_catalog().get(ea_id)
    if not ea:
        return redirect(url_for("hub_page"))
    customer = _find_ea_customer(ea_id, customer_id)
    if not customer:
        job_log.append("ea_zip_missing", f"{ea['name']} -> {customer_id}", "warn")
        return redirect(url_for("ea_detail_route", ea_id=ea_id))
    try:
        zip_path = _create_customer_zip(ea, customer)
        job_log.append("ea_zip", f"{ea['name']} -> {os.path.basename(zip_path)}", "ok")
        if request.form.get("open") == "1" and hasattr(os, "startfile"):
            os.startfile(os.path.dirname(zip_path))
    except Exception as exc:
        job_log.append("ea_zip_error", f"{ea['name']}: {exc}", "error")
    return redirect(url_for("ea_detail_route", ea_id=ea_id))


@app.route("/ea-customer-delivery/<ea_id>/<customer_id>", methods=["POST"])
def ea_customer_delivery_route(ea_id, customer_id):
    ea = _safe_ea_catalog().get(ea_id)
    if not ea:
        return redirect(url_for("hub_page"))
    customer = _update_customer_delivery(ea_id, customer_id, request.form)
    if customer:
        checks = customer.get("delivery_checks", {})
        done = sum(1 for ok in checks.values() if ok)
        job_log.append("ea_delivery", f"{ea['name']} -> {customer.get('buyer_name', customer_id)} {done}/2", "ok")
    return redirect(url_for("ea_detail_route", ea_id=ea_id))


@app.route("/ea-build-locked/<ea_id>/<customer_id>", methods=["POST"])
def ea_build_locked_route(ea_id, customer_id):
    ea = _safe_ea_catalog().get(ea_id)
    if not ea:
        return redirect(url_for("hub_page"))
    customer = _find_ea_customer(ea_id, customer_id)
    if not customer:
        job_log.append("ea_build_missing", f"{ea_id} -> {customer_id}", "warn")
        return redirect(url_for("ea_detail_route", ea_id=ea_id))
    try:
        source_mq5 = _find_ea_main_mq5(ea)
        if not source_mq5:
            job_log.append("ea_build_no_source", f"{ea['name']}: no .mq5 found in {ea.get('path','')}", "error")
            return redirect(url_for("ea_detail_route", ea_id=ea_id))
        safe_ea = _ea_slug(ea.get("id") or ea["name"])
        safe_customer = _ea_slug(customer.get("buyer_name") or customer_id)
        stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        build_dir = os.path.join(EA_CUSTOMER_PACKAGE_DIR, safe_ea, f"{stamp}_{safe_customer}_build")
        os.makedirs(build_dir, exist_ok=True)
        dest_mq5 = os.path.join(build_dir, os.path.basename(source_mq5))
        _patch_mq5_for_customer(source_mq5, customer, dest_mq5)
        build_status = "patched_source_only"
        metaeditor = _find_metaeditor()
        if metaeditor:
            try:
                subprocess.run(
                    [metaeditor, f"/compile:{dest_mq5}", f"/log:{dest_mq5}.log"],
                    capture_output=True, text=True, timeout=90,
                )
                ex5_candidate = dest_mq5.replace(".mq5", ".ex5")
                build_status = "compiled_ok" if os.path.exists(ex5_candidate) else "compile_failed_check_log"
            except Exception as exc:
                build_status = f"compile_error"
                job_log.append("ea_build_compile_err", str(exc), "warn")
        _mark_customer_build(ea_id, customer_id, dest_mq5, build_status)
        label = customer.get("buyer_name", customer_id)
        log_level = "ok" if build_status in ("patched_source_only", "compiled_ok") else "warn"
        job_log.append("ea_build_locked", f"{ea['name']} -> {label}: {build_status}", log_level)
        if request.form.get("open") == "1" and hasattr(os, "startfile"):
            os.startfile(build_dir)
    except Exception as exc:
        job_log.append("ea_build_error", f"{ea['name']}: {exc}", "error")
    return redirect(url_for("ea_detail_route", ea_id=ea_id))


def _ea_customer_message_kit(ea: dict, ea_notes: dict, backtests: list[dict], customers: list[dict]) -> str:
    latest_bt = backtests[0] if backtests else {}
    latest_customer = customers[0] if customers else {}
    package_labels = dict(EA_PACKAGE_TYPES)
    product_name = ea.get("name", "EA Product")
    market = ea.get("market", "")
    strategy = ea_notes.get("strategy_thesis") or ea.get("focus", "")
    best_market = ea_notes.get("best_market") or market
    risk_model = ea_notes.get("risk_model") or "เริ่มจาก lot ต่ำหรือบัญชี demo ก่อนเสมอ และตั้งค่าความเสี่ยงตามขนาดพอร์ต"
    promise = ea_notes.get("customer_promise") or "ระบบช่วยให้มีกรอบการเทรดและการจัดการความเสี่ยงชัดขึ้น แต่ไม่รับประกันกำไร"
    support = ea_notes.get("support_rules") or "มีคู่มือติดตั้ง/ช่วย setup เบื้องต้น และแนะนำให้ทดสอบก่อนใช้เงินจริง"
    no_trade = ea_notes.get("no_trade_conditions") or "หลีกเลี่ยงช่วงข่าวแรง spread ผิดปกติ หรือสภาพตลาดที่ไม่ตรงกับกลยุทธ์"

    proof_lines = []
    for key, label in [
        ("profit_factor", "PF"),
        ("win_rate", "WR"),
        ("drawdown", "DD"),
        ("net_profit", "Net"),
    ]:
        if latest_bt.get(key):
            proof_lines.append(f"{label}: {latest_bt.get(key)}")
    proof_text = " | ".join(proof_lines) if proof_lines else "ยังต้องแนบผล backtest/forward test เพิ่มก่อนปิดการขาย"

    buyer = latest_customer.get("buyer_name") or "[ชื่อลูกค้า]"
    license_key = latest_customer.get("license_key") or "[LICENSE_KEY]"
    account_number = latest_customer.get("account_number") or "[เลขบัญชี MT5 / TradingView username]"
    amount = latest_customer.get("amount") or "[ราคา]"
    package_type = package_labels.get(latest_customer.get("package_type", ""), "[แพ็กเกจ]")
    expiry = latest_customer.get("expires_at") or "ไม่จำกัด / ตามแพ็กเกจ"

    price_menu = "\n".join(
        f"- {p['title']}: {int(p['amount']):,} THB ({p['subtitle']})"
        for p in EA_PRICE_PRESETS
    )

    templates = [
        ("Sales Pitch", "ใช้ตอบลูกค้าที่ถามว่า EA/indicator ตัวนี้คืออะไร", f"""สวัสดีครับ {buyer}

ตัวนี้คือ {product_name} สำหรับ {market}

แนวคิดหลัก:
{strategy}

เหมาะกับ:
{best_market}

หลักฐานล่าสุด:
{proof_text}

สิ่งที่ต้องเข้าใจก่อนใช้:
{promise}

ความเสี่ยง/ช่วงที่ควรเลี่ยง:
{no_trade}

ถ้าสนใจ ผมแนะนำให้เริ่มจากแพ็กเกจที่ล็อคบัญชีหรือทดลอง setup ก่อน เพื่อให้ใช้ถูกตลาดและถูกความเสี่ยงครับ"""),
        ("Follow Up", "ใช้ทักตามลูกค้าที่สนใจแต่ยังไม่จ่าย", f"""สวัสดีครับ {buyer}

ผมสรุป {product_name} ให้สั้นๆ อีกครั้งนะครับ

ระบบนี้เน้น:
- ใช้งานกับ {market}
- มีกรอบกลยุทธ์ชัดเจน
- มี risk model เพื่อไม่ให้ใช้ lot เกินจำเป็น
- มีคู่มือ/ช่วย setup เบื้องต้น

จุดสำคัญคือควรใช้ตามเงื่อนไขนี้:
{risk_model}

ถ้าต้องการ ผมออก key และเตรียม package ให้ได้หลังยืนยันแพ็กเกจครับ"""),
        ("Payment Instruction", "ใช้ส่งตอนลูกค้าพร้อมชำระเงิน", f"""แพ็กเกจที่เลือก: {package_type}
ยอดชำระ: {amount}
สินค้า: {product_name}

หลังชำระแล้ว รบกวนส่งข้อมูลนี้ให้ผมนะครับ:
1. สลิปโอน
2. ชื่อที่ใช้ติดต่อ
3. เลขบัญชี MT5 หรือ TradingView username ที่ต้องการผูกสิทธิ์: {account_number}

หลังตรวจสอบแล้วผมจะส่งไฟล์, license key, และขั้นตอนติดตั้งให้ครับ"""),
        ("License Delivery", "ใช้ส่ง key + เงื่อนไขให้ลูกค้าหลังจ่ายแล้ว", f"""ส่งมอบ {product_name} เรียบร้อยครับ

Package: {package_type}
License Key: {license_key}
Account Lock: {account_number}
Expiry: {expiry}

ขั้นตอนใช้งาน:
1. แตกไฟล์ package
2. อ่าน CUSTOMER_SETUP_GUIDE ก่อนติดตั้ง
3. ใส่ license key ตามคู่มือ
4. เริ่มทดสอบด้วย demo หรือ lot ต่ำก่อน

ข้อควรระวัง:
{risk_model}

ถ้าติดตั้งแล้วมี error ให้ส่งรูปหน้าจอ + broker + account type + symbol/timeframe มาให้ผมดูได้เลยครับ"""),
        ("Setup Call", "ใช้เชิญลูกค้านัด setup สั้นๆ", f"""เพื่อให้ใช้งาน {product_name} ได้ถูกต้อง ผมแนะนำ setup call สั้นๆ 10-20 นาทีครับ

ก่อนเริ่มเตรียม:
1. เปิด MT5 / TradingView ให้พร้อม
2. เตรียมไฟล์ที่ได้รับ
3. เตรียม account number หรือ username ที่จะผูกสิทธิ์
4. เปิดหน้าจอ settings/input ของระบบ

ใน call ผมจะช่วยเช็กการติดตั้ง, ค่า risk, และอธิบายว่าเมื่อไหร่ควรเปิด/ควรหยุดใช้ครับ"""),
        ("Update Broadcast", "ใช้แจ้งลูกค้าเมื่อมีเวอร์ชันใหม่", f"""แจ้งอัปเดต {product_name}

มีการปรับปรุงระบบ/ไฟล์ package ใหม่เพื่อให้ใช้งานเสถียรขึ้น

สิ่งที่ควรทำ:
1. สำรองไฟล์เดิมก่อน
2. ปิด EA/indicator เดิม
3. ติดตั้งไฟล์ใหม่ตามคู่มือ
4. ทดสอบ demo หรือ lot ต่ำก่อนกลับไปใช้จริง

ถ้าต้องการให้ผมช่วยเช็กหลังอัปเดต ส่งรูปหน้าจอ settings มาได้ครับ"""),
    ]

    cards = ""
    safe_id = re.sub(r"[^a-zA-Z0-9_]+", "_", ea.get("id", "ea"))
    for idx, (title, note, text) in enumerate(templates, start=1):
        dom_id = f"line_msg_{safe_id}_{idx}"
        cards += f'''
          <div style="background:rgba(0,0,0,.20);border:1px solid rgba(77,208,255,.13);border-radius:16px;padding:14px">
            <div style="display:flex;justify-content:space-between;gap:10px;align-items:flex-start;margin-bottom:8px">
              <div>
                <div style="color:#f1f7ff;font-weight:900;font-size:14px">{html.escape(title)}</div>
                <div style="color:#8fb2d9;font-size:11px;line-height:1.55;margin-top:3px">{html.escape(note)}</div>
              </div>
              <button type="button" onclick="copyLineMessage('{dom_id}', this)" class="btn btn-quality" style="padding:8px 12px;white-space:nowrap">Copy</button>
            </div>
            <textarea id="{dom_id}" readonly style="width:100%;min-height:210px;padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.16);background:#081524;color:#e8f3ff;line-height:1.6;font-size:12px">{html.escape(text.strip())}</textarea>
          </div>'''

    return f'''
      <div style="background:rgba(10,20,36,.92);border:1px solid rgba(77,208,255,.15);border-radius:20px;padding:18px;margin-bottom:18px">
        <div style="display:flex;justify-content:space-between;gap:12px;align-items:flex-start;margin-bottom:14px">
          <div>
            <h2 class="section-title" style="margin:0 0 6px">Customer Message Kit</h2>
            <div style="color:#8fb2d9;font-size:12px;line-height:1.7">Copy-ready sales, payment, license, setup, and update messages for any chat/inbox. This does not send automatically.</div>
          </div>
          <span style="border:1px solid #22d3ee;color:#22d3ee;border-radius:999px;padding:6px 10px;font-size:11px;font-weight:900">COPY KIT</span>
        </div>
        <div style="display:grid;grid-template-columns:repeat(2,1fr);gap:12px">
          {cards}
        </div>
        <script>
          function copyLineMessage(id, btn) {{
            const el = document.getElementById(id);
            if (!el) return;
            el.focus();
            el.select();
            const done = () => {{
              if (btn) {{
                const old = btn.textContent;
                btn.textContent = 'Copied';
                setTimeout(() => btn.textContent = old, 1200);
              }}
            }};
            if (navigator.clipboard && navigator.clipboard.writeText) {{
              navigator.clipboard.writeText(el.value).then(done).catch(() => {{
                document.execCommand('copy');
                done();
              }});
            }} else {{
              document.execCommand('copy');
              done();
            }}
          }}
        </script>
      </div>'''


def _ea_detail_body(ea: dict, stats: dict, files: list[dict]) -> str:
    status, status_color, status_note = _ea_health(stats)
    exists = stats["exists"]
    package_ready = bool(stats["zip"])
    source_ready = bool(stats["mq"] or stats["pine"])
    compiled_ready = bool(stats["ex"] or stats["pine"])
    docs_ready = bool(stats["md"] or stats["pdf"])
    backtests = _get_ea_backtests(ea["id"])
    manual_checklist = _get_ea_checklist(ea["id"])
    ea_notes = _get_ea_notes(ea["id"])
    customers = _get_ea_customers(ea["id"])
    manual_done = sum(1 for ok in manual_checklist["checks"].values() if ok)
    manual_total = len(EA_MANUAL_CHECKLIST)
    backtest_ready = bool(backtests) or any(f["ext"] in [".html", ".htm", ".csv"] for f in files)
    checklist = [
        ("Folder found", exists, "Project path is reachable."),
        ("Source available", source_ready, "MQL/Pine source exists for review and development."),
        ("Build / Pine ready", compiled_ready, "Compiled MT5 build or Pine script is present."),
        ("Docs ready", docs_ready, "Customer/dev notes, PDFs, or markdown files are present."),
        ("Backtest evidence", backtest_ready, "HTML/CSV reports detected. Later we will import metrics here."),
        ("Customer package", package_ready, "ZIP package detected in this project folder."),
    ]
    if ea["id"] == "cme_alphaedge":
        package_ready = os.path.exists(r"C:\Users\ADMIN\Desktop\CME\AlphaEdge_SMC_Pro_V2_CUSTOMER_PACKAGE.zip")
        checklist[-1] = ("Customer package", package_ready, "AlphaEdge customer ZIP package is ready.")
    done_count = sum(1 for _label, ok, _note in checklist if ok)
    auto_readiness = round((done_count / len(checklist)) * 100)
    manual_readiness = round((manual_done / manual_total) * 100) if manual_total else 0
    readiness = round((auto_readiness * 0.55) + (manual_readiness * 0.45))

    def pill(text, color="#4dd0ff"):
        return f'<span style="display:inline-flex;align-items:center;border:1px solid {color};color:{color};background:rgba(255,255,255,.04);border-radius:999px;padding:6px 10px;font-size:11px;font-weight:900;letter-spacing:.08em">{text}</span>'

    def metric(title, value, sub="", color="#4dd0ff"):
        return f'''<div style="background:linear-gradient(180deg,rgba(22,39,66,.96),rgba(16,29,49,.96));border:1px solid rgba(77,208,255,.16);border-radius:18px;padding:16px">
          <div style="color:#8fb2d9;font-size:11px;text-transform:uppercase;letter-spacing:.14em">{title}</div>
          <div style="color:{color};font-size:28px;font-weight:900;margin-top:8px">{value}</div>
          <div style="color:#6f9bc8;font-size:11px;margin-top:5px">{sub}</div>
        </div>'''

    checklist_rows = ""
    for label, ok, note in checklist:
        color = "#7bffb2" if ok else "#ffb86b"
        mark = "READY" if ok else "TODO"
        checklist_rows += f'''
          <div style="display:grid;grid-template-columns:92px 1fr;gap:12px;align-items:start;padding:12px;border-bottom:1px solid rgba(77,208,255,.09)">
            <div style="color:{color};font-weight:900;font-size:12px;font-family:Consolas,monospace">{mark}</div>
            <div>
              <div style="color:#f1f7ff;font-weight:900;font-size:14px">{html.escape(label)}</div>
              <div style="color:#8fb2d9;font-size:12px;line-height:1.55;margin-top:3px">{html.escape(note)}</div>
            </div>
          </div>'''
    manual_rows = ""
    for key, label, note in EA_MANUAL_CHECKLIST:
        checked = "checked" if manual_checklist["checks"].get(key) else ""
        state_color = "#7bffb2" if checked else "#8fb2d9"
        manual_rows += f'''
          <label style="display:grid;grid-template-columns:34px 1fr;gap:10px;align-items:start;padding:12px;border-bottom:1px solid rgba(77,208,255,.08);cursor:pointer">
            <input type="checkbox" name="{key}" {checked} style="width:18px;height:18px;accent-color:#1fe58f;margin-top:2px">
            <span>
              <span style="display:block;color:{state_color};font-weight:900;font-size:13px">{html.escape(label)}</span>
              <span style="display:block;color:#8fb2d9;font-size:12px;line-height:1.5;margin-top:3px">{html.escape(note)}</span>
            </span>
          </label>'''
    manual_form = f'''
      <form method="POST" action="/ea-checklist/{ea['id']}">
        {manual_rows}
        <div style="padding:12px">
          <textarea name="notes" placeholder="Checklist notes เช่น สิ่งที่ต้องตรวจเพิ่มก่อนส่งลูกค้า" style="width:100%;min-height:76px;padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">{html.escape(manual_checklist["notes"])}</textarea>
          <div style="display:flex;justify-content:space-between;align-items:center;gap:10px;margin-top:10px">
            <span style="color:#6f9bc8;font-size:11px">Updated: {html.escape(manual_checklist["updated_at"] or "-")}</span>
            <button class="btn btn-quality" style="padding:10px 16px">Save Checklist</button>
          </div>
        </div>
      </form>'''
    note_blocks = ""
    for key, label, hint in EA_NOTE_FIELDS:
        note_blocks += f'''
          <label style="display:block">
            <div style="color:#ffd166;font-size:12px;font-weight:900;letter-spacing:.08em;margin:0 0 6px">{html.escape(label)}</div>
            <textarea name="{key}" placeholder="{html.escape(hint)}" style="width:100%;min-height:86px;padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff;line-height:1.55">{html.escape(ea_notes.get(key, ""))}</textarea>
          </label>'''
    notes_form = f'''
      <form method="POST" action="/ea-notes/{ea['id']}" style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
        {note_blocks}
        <div style="grid-column:1/-1;display:flex;justify-content:space-between;align-items:center;gap:10px">
          <span style="color:#6f9bc8;font-size:11px">Updated: {html.escape(ea_notes.get("updated_at", "") or "-")}</span>
          <button class="btn btn-cme" style="padding:11px 18px">Save Product Notes</button>
        </div>
      </form>'''

    file_rows = ""
    for f in files:
        file_rows += f'''
          <div style="display:grid;grid-template-columns:70px 1fr 88px 120px;gap:10px;align-items:center;padding:10px 12px;border-bottom:1px solid rgba(77,208,255,.08);font-family:Consolas,monospace;font-size:12px">
            <span style="color:{ea['accent']};font-weight:900">{html.escape(f['ext'])}</span>
            <span style="color:#d9ecff;overflow:hidden;text-overflow:ellipsis;white-space:nowrap" title="{html.escape(f['rel'])}">{html.escape(f['rel'])}</span>
            <span style="color:#8fb2d9;text-align:right">{f['size_kb']} KB</span>
            <span style="color:#6f9bc8;text-align:right">{f['modified']}</span>
          </div>'''
    if not file_rows:
        file_rows = '<div style="color:#6f9bc8;padding:18px;font-size:13px">No tracked files found yet.</div>'

    open_form = ""
    if exists:
        open_form = f'''
          <form method="POST" action="/ea-open/{ea['id']}" style="display:inline">
            <input type="hidden" name="next" value="/ea/{ea['id']}">
            <button class="btn btn-quality" style="padding:11px 18px">Open Folder</button>
          </form>'''

    product_actions = [
        ("1. Development", "Review source, confirm default settings, and write strategy notes."),
        ("2. Backtest", "Import MT5 HTML/CSV report, then track WR / PF / DD / net profit."),
        ("3. Forward Test", "Attach live account screenshots, journal mistakes, and market regime notes."),
        ("4. Package", "Prepare customer ZIP, license key, install guide, and setup-call checklist."),
        ("5. Sales", "Build offer page, proof screenshots, pricing tier, and support rules."),
    ]
    action_rows = "".join(
        f'<div style="padding:12px;border-bottom:1px solid rgba(77,208,255,.08)"><b style="color:#ffd166">{title}</b><div style="color:#9fc5ef;font-size:12px;line-height:1.6;margin-top:3px">{text}</div></div>'
        for title, text in product_actions
    )
    backtest_cards = ""
    for bt in backtests[:5]:
        is_fwd = bt.get("report_type") in ("trade_history", "forward_test")
        period_line = ""
        if is_fwd and (bt.get("period_start") or bt.get("period_end")):
            period_line = f'<div style="color:#8fb2d9;font-size:11px;margin-bottom:6px">{html.escape(bt.get("account_name",""))} · {html.escape(bt.get("broker",""))} · {html.escape(bt.get("symbol",""))} &nbsp;|&nbsp; {html.escape(bt.get("period_start",""))} → {html.escape(bt.get("period_end",""))}</div>'
        rtype_badge = '<span style="font-size:10px;padding:2px 7px;border-radius:999px;background:rgba(123,255,178,.14);color:#7bffb2;border:1px solid rgba(123,255,178,.3)">FORWARD TEST</span>' if is_fwd else '<span style="font-size:10px;padding:2px 7px;border-radius:999px;background:rgba(77,208,255,.12);color:#4dd0ff;border:1px solid rgba(77,208,255,.25)">BACKTEST</span>'
        extra_row = ""
        if is_fwd:
            gp = bt.get("gross_profit","") or "-"
            gl = bt.get("gross_loss","") or "-"
            swl = (bt.get("short_win_rate","") or "-") + " S / " + (bt.get("long_win_rate","") or "-") + " L"
            sh  = bt.get("sharpe_ratio","") or "-"
            rf  = bt.get("recovery_factor","") or "-"
            extra_row = f'''
            <div style="display:grid;grid-template-columns:repeat(5,1fr);gap:8px;font-family:Consolas,monospace;font-size:11px;margin-top:6px;padding-top:6px;border-top:1px solid rgba(77,208,255,.08)">
              <div><span style="color:#6f9bc8">GROSS+</span><br><b style="color:#7bffb2">{html.escape(gp)}</b></div>
              <div><span style="color:#6f9bc8">GROSS-</span><br><b style="color:#ff8a8a">{html.escape(gl)}</b></div>
              <div><span style="color:#6f9bc8">S/L WR</span><br><b style="color:#4dd0ff">{html.escape(swl)}</b></div>
              <div><span style="color:#6f9bc8">SHARPE</span><br><b style="color:#d9ecff">{html.escape(sh)}</b></div>
              <div><span style="color:#6f9bc8">RECOV</span><br><b style="color:#ffd166">{html.escape(rf)}</b></div>
            </div>'''
        backtest_cards += f'''
          <div style="background:rgba(0,0,0,.18);border:1px solid rgba(77,208,255,.12);border-radius:14px;padding:12px;margin-top:10px">
            <div style="display:flex;justify-content:space-between;align-items:flex-start;gap:10px;margin-bottom:6px">
              <b style="color:#f1f7ff;font-size:13px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">{html.escape(bt.get("file",""))}</b>
              <div style="display:flex;gap:6px;align-items:center;flex-shrink:0">{rtype_badge}<span style="color:#6f9bc8;font-size:11px">{html.escape(bt.get("imported_at",""))}</span></div>
            </div>
            {period_line}
            <div style="display:grid;grid-template-columns:repeat(5,1fr);gap:8px;font-family:Consolas,monospace;font-size:11px">
              <div><span style="color:#6f9bc8">NET</span><br><b style="color:#7bffb2">{html.escape(bt.get("net_profit","") or "-")}</b></div>
              <div><span style="color:#6f9bc8">PF</span><br><b style="color:#ffd166">{html.escape(bt.get("profit_factor","") or "-")}</b></div>
              <div><span style="color:#6f9bc8">DD</span><br><b style="color:#ffb86b">{html.escape(bt.get("drawdown","") or "-")}</b></div>
              <div><span style="color:#6f9bc8">TRADES</span><br><b style="color:#d9ecff">{html.escape(bt.get("total_trades","") or "-")}</b></div>
              <div><span style="color:#6f9bc8">WR</span><br><b style="color:#4dd0ff">{html.escape(bt.get("win_rate","") or "-")}</b></div>
            </div>
            {extra_row}
            {f'<div style="color:#9fc5ef;font-size:12px;line-height:1.6;margin-top:8px">{html.escape(bt.get("notes",""))}</div>' if bt.get("notes") else ""}
          </div>'''
    if not backtest_cards:
        backtest_cards = '<div style="color:#6f9bc8;font-size:12px;line-height:1.7;margin-top:10px">ยังไม่มีผล backtest ที่ import เข้าระบบ</div>'
    backtest_form = f'''
      <form method="POST" action="/ea-backtest-import/{ea['id']}" enctype="multipart/form-data" style="display:grid;gap:10px;margin-top:12px">
        <input name="report_path" placeholder="Paste report path: C:\\Users\\ADMIN\\Desktop\\...\\report.html" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <input name="report_file" type="file" accept=".html,.htm,.csv,.txt" style="padding:10px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#8fb2d9">
        <textarea name="notes" placeholder="Notes เช่น setting, symbol, timeframe, spread, date range" style="min-height:72px;padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff"></textarea>
        <button class="btn btn-cme" style="padding:12px 18px">Import Backtest Report</button>
      </form>'''
    package_options = "".join(
        f'<option value="{key}">{html.escape(label)}</option>'
        for key, label in EA_PACKAGE_TYPES
    )
    status_options = "".join(
        f'<option value="{html.escape(status_name)}">{html.escape(status_name)}</option>'
        for status_name in EA_CUSTOMER_STATUSES
    )
    customer_cards = ""
    package_labels = dict(EA_PACKAGE_TYPES)
    for customer in customers[:8]:
        status_name = customer.get("payment_status", "Lead")
        status_color = {
            "Lead": "#8fb2d9",
            "Pending Payment": "#ffd166",
            "Paid": "#7bffb2",
            "Setup Done": "#4dd0ff",
            "Support": "#c084fc",
            "Expired": "#ff6b6b",
        }.get(status_name, "#8fb2d9")
        row_package_options = "".join(
            f'<option value="{key}" {"selected" if customer.get("package_type") == key else ""}>{html.escape(label)}</option>'
            for key, label in EA_PACKAGE_TYPES
        )
        row_status_options = "".join(
            f'<option value="{html.escape(status_value)}" {"selected" if status_name == status_value else ""}>{html.escape(status_value)}</option>'
            for status_value in EA_CUSTOMER_STATUSES
        )
        delivery_checks = customer.get("delivery_checks", {})
        if not isinstance(delivery_checks, dict):
            delivery_checks = {}
        file_sent_checked = "checked" if delivery_checks.get("file_sent") else ""
        key_sent_checked = "checked" if delivery_checks.get("key_sent") else ""
        lock_label, lock_color, lock_desc = EA_LOCK_TYPE_LABELS.get(
            customer.get("package_type", ""), ("?", "#8fb2d9", "Package type not set")
        )
        build_mq5 = customer.get("build_mq5_path", "")
        build_status = customer.get("build_status", "")
        build_status_color = "#7bffb2" if build_status == "compiled_ok" else ("#ffd166" if build_status == "patched_source_only" else "#ff6b6b")
        customer_cards += f'''
          <div style="background:rgba(0,0,0,.18);border:1px solid rgba(77,208,255,.12);border-radius:16px;padding:14px">
            <div style="display:flex;justify-content:space-between;gap:10px;align-items:flex-start">
              <div>
                <div style="color:#f1f7ff;font-weight:900;font-size:15px">{html.escape(customer.get("buyer_name", ""))}</div>
                <div style="color:#8fb2d9;font-size:12px;margin-top:4px">{html.escape(customer.get("contact", "") or "No contact yet")}</div>
              </div>
              <span style="border:1px solid {status_color};color:{status_color};border-radius:999px;padding:5px 9px;font-size:10px;font-weight:900;white-space:nowrap">{html.escape(status_name)}</span>
            </div>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-top:12px;font-family:Consolas,monospace;font-size:11px;color:#9fc5ef">
              <div><span style="color:#6f9bc8">PACKAGE</span><br><b style="color:#ffd166">{html.escape(package_labels.get(customer.get("package_type", ""), customer.get("package_type", "")))}</b></div>
              <div><span style="color:#6f9bc8">ACCOUNT</span><br><b style="color:#d9ecff">{html.escape(customer.get("account_number", "") or "-")}</b></div>
              <div><span style="color:#6f9bc8">AMOUNT</span><br><b style="color:#7bffb2">{html.escape(customer.get("amount", "") or "-")}</b></div>
              <div><span style="color:#6f9bc8">EXPIRES</span><br><b style="color:#ffb86b">{html.escape(customer.get("expires_at", "") or "-")}</b></div>
            </div>
            <div style="display:flex;align-items:center;gap:8px;margin-top:10px;padding:8px 10px;border-radius:10px;background:rgba(0,0,0,.22);border:1px solid {lock_color}44">
              <span style="border:1px solid {lock_color};color:{lock_color};border-radius:999px;padding:3px 8px;font-size:10px;font-weight:900;font-family:Consolas,monospace;white-space:nowrap">{lock_label}</span>
              <span style="color:#8fb2d9;font-size:11px">{lock_desc}</span>
            </div>
            <div style="margin-top:8px;padding:9px 10px;border-radius:10px;background:#081524;border:1px solid rgba(77,208,255,.10);color:#4dd0ff;font-family:Consolas,monospace;font-size:11px;word-break:break-all">{html.escape(customer.get("license_key", "") or "-")}</div>
            {f'<div style="margin-top:8px;color:#7bffb2;font-family:Consolas,monospace;font-size:10px;word-break:break-all">PACKAGE: {html.escape(customer.get("package_path",""))}</div>' if customer.get("package_path") else ""}
            {f'<div style="margin-top:8px;color:#ffd166;font-family:Consolas,monospace;font-size:10px;word-break:break-all">ZIP: {html.escape(customer.get("zip_path",""))}</div>' if customer.get("zip_path") else ""}
            {f'<div style="margin-top:8px;font-family:Consolas,monospace;font-size:10px;word-break:break-all"><span style="color:{build_status_color};font-weight:900">BUILD: {html.escape(build_status)}</span>  <span style="color:#6f9bc8">{html.escape(build_mq5)}</span></div>' if build_mq5 else ""}
            {f'<div style="color:#9fc5ef;font-size:12px;line-height:1.6;margin-top:8px">{html.escape(customer.get("notes",""))}</div>' if customer.get("notes") else ""}
            <form method="POST" action="/ea-customer-package/{ea['id']}/{html.escape(customer.get('id', ''))}" style="display:flex;gap:8px;margin-top:10px;flex-wrap:wrap">
              <button class="btn btn-check-learn" style="padding:10px 12px">Generate Package</button>
              <button name="open" value="1" class="btn btn-quality" style="padding:10px 12px">Generate + Open</button>
            </form>
            <form method="POST" action="/ea-customer-zip/{ea['id']}/{html.escape(customer.get('id', ''))}" style="display:flex;gap:8px;margin-top:8px;flex-wrap:wrap">
              <button class="btn btn-cme" style="padding:10px 12px">Create ZIP</button>
              <button name="open" value="1" class="btn btn-quality" style="padding:10px 12px">ZIP + Open Folder</button>
            </form>
            <form method="POST" action="/ea-build-locked/{ea['id']}/{html.escape(customer.get('id', ''))}" style="display:flex;gap:8px;margin-top:8px;flex-wrap:wrap;align-items:center;padding:10px;border-radius:12px;background:rgba(139,92,246,.08);border:1px solid rgba(139,92,246,.28)">
              <span style="color:#c084fc;font-size:11px;font-weight:900;letter-spacing:.06em">BUILD LOCKED EA</span>
              <button class="btn" style="padding:8px 14px;background:#5b21b6;border:1px solid #7c3aed;color:#f1f7ff;border-radius:10px">Patch + Compile</button>
              <button name="open" value="1" class="btn" style="padding:8px 14px;background:rgba(124,58,237,.4);border:1px solid #7c3aed;color:#f1f7ff;border-radius:10px">Patch + Open Folder</button>
            </form>
            <form method="POST" action="/ea-customer-delivery/{ea['id']}/{html.escape(customer.get('id', ''))}" style="display:flex;align-items:center;gap:12px;margin-top:10px;padding:10px;border-radius:12px;background:rgba(8,21,36,.72);border:1px solid rgba(77,208,255,.10);flex-wrap:wrap">
              <label style="display:flex;align-items:center;gap:6px;color:#d9ecff;font-size:12px;font-weight:900"><input type="checkbox" name="file_sent" {file_sent_checked} style="accent-color:#1fe58f"> ส่งไฟล์แล้ว</label>
              <label style="display:flex;align-items:center;gap:6px;color:#d9ecff;font-size:12px;font-weight:900"><input type="checkbox" name="key_sent" {key_sent_checked} style="accent-color:#1fe58f"> ส่ง key แล้ว</label>
              <button class="btn btn-toggle" style="padding:8px 12px">Save Delivery</button>
            </form>
            <details style="margin-top:12px">
              <summary style="cursor:pointer;color:#ffd166;font-weight:900;font-size:12px;letter-spacing:.08em">EDIT CUSTOMER</summary>
              <form method="POST" action="/ea-customer-update/{ea['id']}/{html.escape(customer.get('id', ''))}" style="display:grid;grid-template-columns:1fr 1fr;gap:8px;margin-top:10px">
                <input name="buyer_name" value="{html.escape(customer.get("buyer_name", ""))}" placeholder="Buyer name" style="padding:10px;border-radius:10px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
                <input name="contact" value="{html.escape(customer.get("contact", ""))}" placeholder="Contact" style="padding:10px;border-radius:10px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
                <select name="payment_status" style="padding:10px;border-radius:10px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">{row_status_options}</select>
                <select name="package_type" style="padding:10px;border-radius:10px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">{row_package_options}</select>
                <input name="account_number" value="{html.escape(customer.get("account_number", ""))}" placeholder="Account lock" style="padding:10px;border-radius:10px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
                <input name="amount" value="{html.escape(customer.get("amount", ""))}" placeholder="Amount" style="padding:10px;border-radius:10px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
                <input name="license_key" value="{html.escape(customer.get("license_key", ""))}" placeholder="License key" style="grid-column:1/-1;padding:10px;border-radius:10px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
                <input name="expires_at" value="{html.escape(customer.get("expires_at", ""))}" placeholder="Expire date" style="grid-column:1/-1;padding:10px;border-radius:10px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
                <textarea name="notes" placeholder="Customer notes" style="grid-column:1/-1;min-height:58px;padding:10px;border-radius:10px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">{html.escape(customer.get("notes", ""))}</textarea>
                <button name="action" value="update" class="btn btn-quality" style="padding:10px 12px">Save</button>
                <button name="action" value="archive" class="btn btn-danger" style="padding:10px 12px">Archive</button>
              </form>
            </details>
          </div>'''
    if not customer_cards:
        customer_cards = '<div style="color:#6f9bc8;font-size:12px;line-height:1.7">No customer/license records yet. Add the first lead when someone asks for price or setup.</div>'
    price_preset_cards = ""
    for preset in EA_PRICE_PRESETS:
        amount_label = f"{int(preset['amount']):,} THB"
        price_preset_cards += f'''
          <button type="button" onclick="applyEaPricePreset('{html.escape(preset['package_type'])}', '{html.escape(preset['amount'])}', {int(preset['duration_days'])})" style="text-align:left;background:linear-gradient(180deg,rgba(22,39,66,.94),rgba(8,21,36,.94));border:1px solid rgba(77,208,255,.18);border-radius:14px;padding:12px;cursor:pointer">
            <div style="display:flex;justify-content:space-between;gap:8px;align-items:flex-start">
              <b style="color:#f1f7ff;font-size:13px">{html.escape(preset['title'])}</b>
              <span style="color:#ffd166;border:1px solid rgba(255,209,102,.35);border-radius:999px;padding:3px 7px;font-size:9px;font-weight:900;white-space:nowrap">{html.escape(preset['badge'])}</span>
            </div>
            <div style="color:#7bffb2;font-size:20px;font-weight:900;margin-top:6px">{amount_label}</div>
            <div style="color:#8fb2d9;font-size:11px;line-height:1.5;margin-top:3px">{html.escape(preset['subtitle'])}</div>
          </button>'''

    price_preset_panel = f'''
      <div style="margin:0 0 14px;padding:14px;border-radius:16px;border:1px solid rgba(255,209,102,.20);background:linear-gradient(135deg,rgba(247,201,72,.10),rgba(77,208,255,.06))">
        <div style="display:flex;justify-content:space-between;gap:12px;align-items:center;margin-bottom:10px">
          <div>
            <div style="color:#ffd166;font-weight:900;font-size:13px;letter-spacing:.12em">PRICE PRESETS</div>
            <div style="color:#8fb2d9;font-size:11px;line-height:1.6">Click a package to fill lock type, amount, and expiry date correctly. Customer delivery stays manual.</div>
          </div>
          <span style="color:#7bffb2;font-size:11px;font-weight:900">POSTER PRICING</span>
        </div>
        <div style="display:grid;grid-template-columns:repeat(5,1fr);gap:10px">{price_preset_cards}</div>
      </div>
      <script>
        function applyEaPricePreset(packageType, amount, durationDays) {{
          const form = document.getElementById('ea_customer_add_form');
          if (!form) return;
          const pkg = form.querySelector('[name="package_type"]');
          const amt = form.querySelector('[name="amount"]');
          const exp = form.querySelector('[name="expires_at"]');
          if (pkg) pkg.value = packageType;
          if (amt) amt.value = amount;
          if (exp) {{
            if (durationDays > 0) {{
              const d = new Date();
              d.setDate(d.getDate() + durationDays);
              exp.value = d.toISOString().slice(0, 10);
            }} else {{
              exp.value = '';
            }}
          }}
        }}
      </script>'''

    customer_form = f'''
      {price_preset_panel}
      <form id="ea_customer_add_form" method="POST" action="/ea-customer-add/{ea['id']}" style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:10px">
        <input name="buyer_name" placeholder="Buyer / lead name" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <input name="contact" placeholder="Contact: LINE / Facebook / phone" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <select name="payment_status" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">{status_options}</select>
        <select name="package_type" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">{package_options}</select>
        <input name="account_number" placeholder="MT5 account lock, if any" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <input name="amount" placeholder="Amount / price" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <input name="license_key" placeholder="License key (blank = auto)" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <input name="expires_at" placeholder="Expire date, e.g. 2026-06-05" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <button class="btn btn-quality" style="padding:12px 18px">Add Customer / Key</button>
        <textarea name="notes" placeholder="Sales notes: paid proof, setup call time, customer risk profile, delivery status" style="grid-column:1/-1;min-height:74px;padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff"></textarea>
      </form>'''
    edit_form = f'''
      <form method="POST" action="/ea-update/{ea['id']}" style="display:grid;grid-template-columns:1fr 1fr;gap:10px">
        <input name="name" value="{html.escape(ea['name'])}" placeholder="EA name" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <input name="path" value="{html.escape(ea['path'])}" placeholder="Folder path" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <input name="icon" value="{html.escape(ea['icon'])}" placeholder="Icon" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <input name="kind" value="{html.escape(ea['kind'])}" placeholder="Kind" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <input name="market" value="{html.escape(ea['market'])}" placeholder="Market" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <input name="stage" value="{html.escape(ea['stage'])}" placeholder="Stage" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <input name="accent" value="{html.escape(ea['accent'])}" placeholder="#4dd0ff" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <input name="next" value="{html.escape(ea['next'])}" placeholder="Next action" style="padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">
        <textarea name="focus" placeholder="Focus / strategy thesis" style="grid-column:1/-1;min-height:86px;padding:12px;border-radius:12px;border:1px solid rgba(77,208,255,.18);background:#081524;color:#e8f3ff">{html.escape(ea['focus'])}</textarea>
        <button class="btn btn-check-learn" style="grid-column:1/-1;padding:12px 18px">Save EA Info</button>
      </form>'''

    return f'''
    <div style="margin-bottom:18px;display:flex;justify-content:space-between;align-items:center;gap:12px">
      <a href="/hub" class="btn btn-toggle" style="padding:10px 16px;text-decoration:none">Back to Hub</a>
      <div style="display:flex;gap:8px;flex-wrap:wrap">{pill(ea['kind'], ea['accent'])}{pill(ea['market'], "#8fb2d9")}{pill(status, status_color)}</div>
    </div>

    <div style="position:relative;overflow:hidden;border:1px solid rgba(77,208,255,.22);border-left:5px solid {ea['accent']};border-radius:28px;padding:28px;margin-bottom:22px;background:
      radial-gradient(circle at 8% 10%,rgba(77,208,255,.16),transparent 30%),
      radial-gradient(circle at 92% 16%,rgba(247,201,72,.12),transparent 28%),
      linear-gradient(135deg,rgba(18,41,74,.98),rgba(8,16,30,.98));box-shadow:0 26px 70px rgba(0,0,0,.32)">
      <div style="display:grid;grid-template-columns:1fr 340px;gap:20px;align-items:center">
        <div>
          <div style="color:{ea['accent']};font-weight:900;letter-spacing:.18em;text-transform:uppercase;font-size:12px;margin-bottom:10px">EA DETAIL COMMAND ROOM</div>
          <h1 style="margin:0;color:#fff;font-size:40px;letter-spacing:.04em;line-height:1.1">{html.escape(ea['name'])}</h1>
          <p style="color:#b8d0ee;font-size:15px;line-height:1.8;max-width:820px;margin:14px 0 0">{html.escape(ea['focus'])}</p>
          <div style="color:#ffd166;font-size:13px;line-height:1.7;margin-top:12px"><b>Next:</b> {html.escape(ea['next'])}</div>
        </div>
        <div style="background:rgba(0,0,0,.18);border:1px solid rgba(255,255,255,.12);border-radius:22px;padding:18px">
          <div style="display:flex;justify-content:space-between;align-items:end;margin-bottom:10px">
            <div>
              <div style="color:#8fb2d9;font-size:11px;text-transform:uppercase;letter-spacing:.16em">Product Readiness</div>
              <div style="color:#fff;font-size:42px;font-weight:900;line-height:1;margin-top:8px">{readiness}%</div>
            </div>
            <div style="color:{ea['accent']};font-size:28px;font-weight:900;font-family:Consolas,monospace">{ea['icon']}</div>
          </div>
          <div style="height:12px;background:rgba(255,255,255,.08);border-radius:999px;overflow:hidden">
            <div style="width:{readiness}%;height:100%;background:linear-gradient(90deg,{ea['accent']},#7bffb2);border-radius:999px"></div>
          </div>
          <div style="display:flex;justify-content:space-between;color:#8fb2d9;font-size:11px;margin-top:8px">
            <span>Auto {auto_readiness}%</span><span>Sales {manual_readiness}%</span>
          </div>
          <div style="color:{status_color};font-size:12px;margin-top:10px;font-weight:900">{status_note}</div>
        </div>
      </div>
    </div>

    <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:18px">
      {metric("Files", stats["files"], f'{stats["size_mb"]} MB total', "#f1f7ff")}
      {metric("Source", stats["mq"] + stats["pine"], f'MQ: {stats["mq"]} | Pine: {stats["pine"]}', "#7bffb2" if source_ready else "#ffb86b")}
      {metric("Builds", stats["ex"], f'EX files detected', "#4dd0ff" if stats["ex"] else "#8fb2d9")}
      {metric("Docs / Package", stats["md"] + stats["pdf"] + stats["zip"], f'MD/PDF/ZIP', "#ffd166")}
    </div>

    <div style="display:grid;grid-template-columns:1.05fr .95fr;gap:16px;margin-bottom:18px">
      <div style="background:rgba(10,20,36,.92);border:1px solid rgba(77,208,255,.15);border-radius:20px;overflow:hidden">
        <div style="padding:16px;border-bottom:1px solid rgba(77,208,255,.12);display:flex;justify-content:space-between;align-items:center">
          <h2 class="section-title" style="margin:0">Auto Readiness Checklist</h2>
          <span style="color:#8fb2d9;font-size:12px">{done_count}/{len(checklist)} ready</span>
        </div>
        {checklist_rows}
      </div>
      <div style="background:rgba(10,20,36,.92);border:1px solid rgba(77,208,255,.15);border-radius:20px;overflow:hidden">
        <div style="padding:16px;border-bottom:1px solid rgba(77,208,255,.12)">
          <h2 class="section-title" style="margin:0">Product Action Plan</h2>
        </div>
        {action_rows}
      </div>
    </div>

    <div style="background:rgba(10,20,36,.92);border:1px solid rgba(77,208,255,.15);border-radius:20px;overflow:hidden;margin-bottom:18px">
      <div style="padding:16px;border-bottom:1px solid rgba(77,208,255,.12);display:flex;justify-content:space-between;align-items:center">
        <h2 class="section-title" style="margin:0">Manual Sales Checklist</h2>
        <span style="color:#7bffb2;font-size:12px;font-weight:900">{manual_done}/{manual_total} ready</span>
      </div>
      {manual_form}
    </div>

    <div style="background:rgba(10,20,36,.92);border:1px solid rgba(77,208,255,.15);border-radius:20px;padding:18px;margin-bottom:18px">
      <div style="display:flex;justify-content:space-between;gap:12px;align-items:flex-start;margin-bottom:14px">
        <div>
          <h2 class="section-title" style="margin:0 0 6px">EA Product Notes</h2>
          <div style="color:#8fb2d9;font-size:12px">บันทึกแก่นกลยุทธ์และแผนขายของ EA ตัวนี้ ใช้ส่งต่อ Claude/Codex หรือใช้คุยกับลูกค้าได้เร็วขึ้น</div>
        </div>
        <span style="border:1px solid #4dd0ff;color:#4dd0ff;border-radius:999px;padding:6px 10px;font-size:11px;font-weight:900">PRODUCT THESIS</span>
      </div>
      {notes_form}
    </div>

    <div style="background:rgba(10,20,36,.92);border:1px solid rgba(77,208,255,.15);border-radius:20px;padding:18px;margin-bottom:18px">
      <div style="display:flex;justify-content:space-between;gap:12px;align-items:flex-start;margin-bottom:14px">
        <div>
          <h2 class="section-title" style="margin:0 0 6px">Customer / License Manager</h2>
          <div style="color:#8fb2d9;font-size:12px;line-height:1.7">Select the correct package lock, account number, payment status, amount, expiry date, and delivery key. Sending files/messages is handled manually outside this page.</div>
        </div>
        <span style="border:1px solid #7bffb2;color:#7bffb2;border-radius:999px;padding:6px 10px;font-size:11px;font-weight:900">{len(customers)} RECORDS</span>
      </div>
      {customer_form}
      <div style="display:grid;grid-template-columns:repeat(2,1fr);gap:12px;margin-top:14px">
        {customer_cards}
      </div>
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:18px">
      <div style="background:rgba(10,20,36,.92);border:1px solid rgba(77,208,255,.15);border-radius:20px;padding:18px">
        <h2 class="section-title" style="margin-bottom:12px">Folder Control</h2>
        <div style="color:#8fb2d9;font-size:12px;line-height:1.8;margin-bottom:14px;word-break:break-all">{html.escape(ea['path'])}</div>
        {open_form}
      </div>
      <div style="background:rgba(10,20,36,.92);border:1px solid rgba(77,208,255,.15);border-radius:20px;padding:18px">
        <h2 class="section-title" style="margin-bottom:12px">Backtest / Forward Test Slot</h2>
        <div style="color:#b8d0ee;font-size:13px;line-height:1.8">
          Import MT5 Strategy Tester HTML or CSV here. The system will extract Net Profit, PF, DD, Trades, and Win Rate when those labels are available.
        </div>
        {backtest_form}
        {backtest_cards}
      </div>
    </div>

    <div style="background:rgba(10,20,36,.92);border:1px solid rgba(77,208,255,.15);border-radius:20px;padding:18px;margin-bottom:18px">
      <h2 class="section-title" style="margin-bottom:12px">Edit EA Registry</h2>
      <div style="color:#8fb2d9;font-size:12px;line-height:1.6;margin-bottom:12px">แก้ชื่อ, path, stage, focus และ next action ได้จากตรงนี้ ระบบจะบันทึกลง `ea_registry.json` ทันที</div>
      {edit_form}
      <div style="margin-top:14px;padding-top:14px;border-top:1px solid rgba(77,208,255,.10)">
        <form method="POST" action="/ea-archive/{ea["id"]}" onsubmit="return confirm('Archive {html.escape(ea["name"])}? มันจะหายจาก Hub แต่ไม่มีการลบไฟล์จริง')">
          <button class="btn btn-reject" style="padding:10px 20px;font-size:12px">Archive EA (ซ่อนจาก Hub)</button>
        </form>
      </div>
    </div>

    <div style="background:rgba(10,20,36,.92);border:1px solid rgba(77,208,255,.15);border-radius:20px;overflow:hidden;margin-bottom:18px">
      <div style="padding:16px;border-bottom:1px solid rgba(77,208,255,.12);display:flex;justify-content:space-between;align-items:center">
        <h2 class="section-title" style="margin:0">Latest Important Files</h2>
        <span style="color:#6f9bc8;font-size:12px">source / build / docs / reports / package</span>
      </div>
      {file_rows}
    </div>
    '''


@app.route("/ea/<ea_id>")
def ea_detail_route(ea_id):
    ea = _safe_ea_catalog().get(ea_id)
    if not ea:
        return redirect(url_for("hub_page"))
    stats = _scan_ea_folder(ea["path"])
    files = _ea_file_inventory(ea["path"])
    return _render_page(_ea_detail_body(ea, stats, files), f"EA Detail - {ea['name']}", show_hero=False)


def _ea_management_hub_body(q, atoms, prop, cme, biz, ninja, alphaedge, recent_jobs) -> str:
    catalog = _get_ea_catalog()
    ea_scans = {ea["id"]: _scan_ea_folder(ea["path"]) for ea in catalog}
    decision_board = _ea_decision_board(catalog, ea_scans)
    customer_pipeline = _ea_customer_pipeline(catalog)
    ea_ready_count = sum(1 for s in ea_scans.values() if s["exists"] and (s["mq"] or s["pine"]))
    ea_missing_count = sum(1 for s in ea_scans.values() if not s["exists"])
    customer_zip = r"C:\Users\ADMIN\Desktop\CME\AlphaEdge_SMC_Pro_V2_CUSTOMER_PACKAGE.zip"
    customer_zip_ready = os.path.exists(customer_zip)

    level_color = {"ok": "var(--ok)", "warn": "var(--warn)", "error": "var(--warn)", "info": "var(--muted)"}
    job_rows = ""
    for e in recent_jobs:
        color = level_color.get(e.get("level", "info"), "var(--muted)")
        job_rows += f'<div style="display:flex;gap:10px;font-size:12px;padding:5px 0;border-bottom:1px solid var(--line)"><span style="color:var(--muted);white-space:nowrap">{e["ts"]}</span><span style="color:{color}">{e["type"]}</span><span style="color:var(--text);flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">{html.escape(e.get("detail",""))}</span></div>'
    if not job_rows:
        job_rows = '<div style="color:var(--muted);font-size:13px;padding:8px 0">No events yet</div>'

    def stat_card(title, val, sub="", color="#4dd0ff"):
        return f'''<div style="background:var(--panel);border:1px solid var(--line);border-radius:12px;padding:18px 16px;min-height:96px">
          <div style="font-size:11px;color:var(--muted);text-transform:uppercase;letter-spacing:.14em;margin-bottom:10px">{title}</div>
          <div style="font-size:30px;font-weight:900;color:{color};line-height:1">{val}</div>
          {f'<div style="font-size:11px;color:var(--muted);margin-top:7px">{sub}</div>' if sub else ""}
        </div>'''

    def module_card(title, icon, stats_html, href, badge=""):
        badge_html = f'<span style="background:rgba(77,208,255,.1);color:var(--cyan);border-radius:999px;padding:2px 8px;font-size:10px;font-weight:900;letter-spacing:.1em">{badge}</span>' if badge else ""
        return f'''<a href="{href}" style="text-decoration:none">
          <div style="background:var(--panel);border:1px solid var(--line);border-radius:12px;padding:16px;cursor:pointer;transition:border-color .18s ease, background .18s ease" onmouseover="this.style.borderColor='var(--line-bright)';this.style.background='var(--panel-2)'" onmouseout="this.style.borderColor='var(--line)';this.style.background='var(--panel)'">
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:10px"><span style="color:var(--cyan);font-weight:900;font-family:Consolas,monospace">{icon}</span><span style="font-size:14px;font-weight:900;color:var(--text)">{title}</span>{badge_html}</div>
            <div style="font-size:12px;color:var(--muted);line-height:1.7">{stats_html}</div>
          </div>
        </a>'''

    def decision_bucket(title, key, color, subtitle):
        rows = decision_board.get(key, [])
        if not rows:
            items = '<div style="color:var(--muted);font-size:12px;line-height:1.6;padding:12px;border:1px dashed var(--line);border-radius:12px">ยังไม่มีรายการในกลุ่มนี้</div>'
        else:
            items = ""
            for item in rows[:4]:
                ea = item["ea"]
                flags = []
                if item["proof_ready"]:
                    flags.append("Proof")
                if item["package_ready"]:
                    flags.append("Package")
                if item["customers"]:
                    flags.append(f"Lead {item['customers']}")
                flag_html = "".join(f'<span style="border:1px solid var(--line);background:var(--bg-2);border-radius:999px;padding:3px 7px;color:var(--text);font-size:10px">{html.escape(flag)}</span>' for flag in flags) or '<span style="color:var(--muted);font-size:10px">No proof yet</span>'
                items += f'''
                <div style="background:var(--bg-1);border:1px solid var(--line);border-left:3px solid {color};border-radius:12px;padding:12px;margin-top:10px">
                  <div style="display:flex;justify-content:space-between;gap:10px;align-items:flex-start">
                    <div style="min-width:0">
                      <div style="color:var(--text);font-weight:900;font-size:13px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{html.escape(ea['name'])}</div>
                      <div style="color:var(--muted);font-size:11px;line-height:1.5;margin-top:4px">{html.escape(item['reason'])}</div>
                    </div>
                    <div style="color:{color};font-size:22px;font-weight:900;font-family:Consolas,monospace">{item['score']}</div>
                  </div>
                  <div style="height:7px;border-radius:999px;background:var(--bg-2);overflow:hidden;margin:10px 0 9px">
                    <div style="height:100%;width:{item['score']}%;background:linear-gradient(90deg,{color},var(--text));box-shadow:0 0 12px {color}44"></div>
                  </div>
                  <div style="color:var(--text);font-size:11px;line-height:1.45;margin-bottom:9px"><b style="color:{color}">Next:</b> {html.escape(item['action'])}</div>
                  <div style="display:flex;justify-content:space-between;gap:8px;align-items:center">
                    <div style="display:flex;gap:5px;flex-wrap:wrap">{flag_html}</div>
                    <a href="/ea/{ea['id']}" class="btn btn-toggle" style="padding:7px 10px;text-decoration:none;font-size:10px">Details</a>
                  </div>
                </div>'''
        return f'''
        <div style="background:var(--panel);border:1px solid var(--line);border-top:3px solid {color};border-radius:12px;padding:15px;min-height:250px">
          <div style="display:flex;justify-content:space-between;gap:10px;align-items:flex-start;margin-bottom:8px">
            <div>
              <div style="color:{color};font-size:11px;font-weight:900;letter-spacing:.14em;text-transform:uppercase">{title}</div>
              <div style="color:var(--muted);font-size:11px;margin-top:5px">{subtitle}</div>
            </div>
            <span style="background:var(--bg-2);border:1px solid {color};color:{color};border-radius:999px;padding:4px 9px;font-size:11px;font-weight:900">{len(rows)}</span>
          </div>
          {items}
        </div>'''

    def sales_pipeline_panel():
        totals = customer_pipeline["totals"]
        status_counts = customer_pipeline["status_counts"]
        rows = customer_pipeline["rows"]
        delivery_pct = _pct(totals["ready_delivery"], totals["leads"])
        paid_pct = _pct(totals["paid"], totals["leads"])
        amount_text = f"{totals['amount']:,.0f}"
        status_html = ""
        for status in EA_CUSTOMER_STATUSES:
            count = status_counts.get(status, 0)
            if not count:
                continue
            status_html += f'''
            <div style="display:flex;justify-content:space-between;gap:10px;border-bottom:1px solid var(--line);padding:7px 0">
              <span style="color:var(--muted)">{html.escape(status)}</span>
              <b style="color:var(--text)">{count}</b>
            </div>'''
        if not status_html:
            status_html = '<div style="color:var(--muted);font-size:13px;line-height:1.6">No customer records yet. Add a lead from any EA detail page.</div>'

        product_rows = ""
        for row in rows[:5]:
            ea = row["ea"]
            product_rows += f'''
            <div style="background:var(--bg-2);border:1px solid var(--line);border-left:3px solid {ea['accent']};border-radius:12px;padding:11px;margin-top:9px">
              <div style="display:flex;justify-content:space-between;gap:10px;align-items:flex-start">
                <div style="min-width:0">
                  <div style="color:var(--text);font-weight:900;font-size:13px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">{html.escape(ea['name'])}</div>
                  <div style="color:var(--muted);font-size:11px;margin-top:4px">Customers {row['customers']} | Paid {row['paid']} | ZIP {row['zips']} | Delivered {row['delivery_done']}</div>
                </div>
                <a href="/ea/{ea['id']}" class="btn btn-toggle" style="padding:7px 10px;text-decoration:none;font-size:10px">Open</a>
              </div>
            </div>'''
        if not product_rows:
            product_rows = '<div style="color:var(--muted);font-size:13px;line-height:1.6;padding:12px;border:1px dashed var(--line);border-radius:12px">No EA has customer pipeline yet.</div>'

        return f'''
        <h2 class="section-title" style="margin-bottom:14px">Sales / Delivery Pipeline</h2>
        <div style="background:var(--panel);border:1px solid var(--line);border-radius:16px;padding:16px;margin-bottom:24px">
          <div style="display:grid;grid-template-columns:1.2fr .8fr 1fr;gap:14px;align-items:stretch">
            <div>
              <div style="color:var(--gold);font-size:11px;font-weight:900;letter-spacing:.16em;text-transform:uppercase;margin-bottom:8px">Customer Ops</div>
              <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:9px">
                {stat_card("Leads", totals["leads"], f"Paid {paid_pct}%", "var(--cyan)")}
                {stat_card("Paid", totals["paid"], f"Value {amount_text}", "var(--ok)")}
                {stat_card("ZIP Ready", totals["zips"], f"Packages {totals['packages']}", "var(--gold)")}
                {stat_card("Delivered", totals["ready_delivery"], f"{delivery_pct}% complete", "var(--warn)")}
              </div>
              <div style="margin-top:12px;background:var(--bg-2);border:1px solid var(--line);border-radius:12px;padding:12px">
                <div style="display:flex;justify-content:space-between;color:var(--muted);font-size:11px;text-transform:uppercase;letter-spacing:.12em;margin-bottom:7px"><span>Delivery Progress</span><span>{delivery_pct}%</span></div>
                <div style="height:10px;background:var(--bg-1);border-radius:999px;overflow:hidden">
                  <div style="height:100%;width:{delivery_pct}%;background:linear-gradient(90deg,var(--cyan),var(--ok));box-shadow:0 0 12px rgba(35,217,126,.2)"></div>
                </div>
              </div>
            </div>
            <div style="background:var(--bg-2);border:1px solid var(--line);border-radius:12px;padding:14px">
              <div style="color:var(--cyan);font-size:11px;font-weight:900;letter-spacing:.14em;text-transform:uppercase;margin-bottom:8px">Status Mix</div>
              {status_html}
            </div>
            <div style="background:var(--bg-2);border:1px solid var(--line);border-radius:12px;padding:14px">
              <div style="color:var(--ok);font-size:11px;font-weight:900;letter-spacing:.14em;text-transform:uppercase;margin-bottom:8px">Top EA Pipeline</div>
              {product_rows}
            </div>
          </div>
        </div>'''

    def ea_card(ea):
        stats = ea_scans[ea["id"]]
        status, status_color, status_note = _ea_health(stats)
        path_short = html.escape(ea["path"])
        open_btn = f'''
          <form method="POST" action="/ea-open/{ea['id']}" style="display:inline">
            <input type="hidden" name="next" value="/hub">
            <button class="btn btn-quality" style="padding:9px 14px">Open Folder</button>
          </form>''' if stats["exists"] else '<button class="btn btn-reject" style="padding:9px 14px;opacity:.65" disabled>Missing</button>'
        tech_line = f"MQ: {stats['mq']} | EX: {stats['ex']} | Pine: {stats['pine']} | MD: {stats['md']} | ZIP: {stats['zip']}"
        last_line = f"{stats['last_modified']} · {html.escape(stats['last_file'])}" if stats["last_modified"] else "No file activity"
        return f'''
        <div style="position:relative;overflow:hidden;background:var(--panel);border:1px solid var(--line);border-left:4px solid {ea['accent']};border-radius:16px;padding:18px;min-height:245px;box-shadow:var(--shadow)">
          <div style="position:absolute;right:-34px;top:-34px;width:110px;height:110px;border-radius:999px;background:{ea['accent']};opacity:.05;filter:blur(2px)"></div>
          <div style="display:flex;justify-content:space-between;gap:12px;align-items:flex-start;margin-bottom:12px">
            <div>
              <div style="font-size:11px;color:{ea['accent']};font-weight:900;letter-spacing:.16em;text-transform:uppercase">{ea['kind']}</div>
              <h3 style="margin:7px 0 6px;color:var(--text);font-size:20px;line-height:1.2">{html.escape(ea['name'])}</h3>
              <div style="color:var(--muted);font-size:12px;font-family:Consolas,monospace">{html.escape(ea['market'])}</div>
            </div>
            <div style="border:1px solid var(--line);border-radius:12px;padding:10px 12px;color:{ea['accent']};font-weight:900;background:var(--bg-2);font-family:Consolas,monospace">{ea['icon']}</div>
          </div>
          <div style="display:flex;gap:8px;flex-wrap:wrap;margin-bottom:12px">
            <span style="background:var(--bg-2);border:1px solid var(--line);color:var(--text);border-radius:999px;padding:5px 9px;font-size:11px">{html.escape(ea['stage'])}</span>
            <span style="background:var(--bg-2);border:1px solid {status_color};color:{status_color};border-radius:999px;padding:5px 9px;font-size:11px;font-weight:900">{status}</span>
          </div>
          <p style="color:var(--text);font-size:13px;line-height:1.65;margin:0 0 12px">{html.escape(ea['focus'])}</p>
          <div style="background:var(--bg-2);border:1px solid var(--line);border-radius:12px;padding:10px;margin-bottom:12px">
            <div style="font-size:11px;color:var(--muted);text-transform:uppercase;letter-spacing:.13em;margin-bottom:4px">Folder Scan</div>
            <div style="font-size:12px;color:var(--text);font-family:Consolas,monospace">{tech_line}</div>
            <div style="font-size:11px;color:var(--muted);margin-top:4px">Latest: {last_line}</div>
            <div style="font-size:11px;color:{status_color};margin-top:4px">{status_note}</div>
          </div>
          <div style="font-size:12px;color:var(--text);margin-bottom:14px"><b style="color:var(--gold)">Next:</b> {html.escape(ea['next'])}</div>
          <div style="display:flex;justify-content:space-between;align-items:center;gap:10px">
            <div style="display:flex;gap:8px;align-items:center">
              <a href="/ea/{ea['id']}" class="btn btn-toggle" style="padding:9px 14px;text-decoration:none">Details</a>
              {open_btn}
            </div>
            <span title="{path_short}" style="font-size:11px;color:var(--muted);max-width:62%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">{path_short}</span>
          </div>
        </div>'''

    ea_cards = "".join(ea_card(ea) for ea in catalog)
    decision_board_html = f'''
    <h2 class="section-title" style="margin-bottom:14px">EA Decision Board</h2>
    <div style="background:var(--panel);border:1px solid var(--line);border-radius:16px;padding:16px;margin-bottom:24px">
      <div style="display:flex;justify-content:space-between;gap:12px;align-items:flex-start;margin-bottom:14px">
        <div>
          <div style="color:var(--gold);font-size:11px;font-weight:900;letter-spacing:.16em;text-transform:uppercase">Hybrid Shortlist</div>
          <div style="color:var(--text);font-size:13px;line-height:1.65;margin-top:5px">ระบบจัดลำดับ EA แบบเร็ว: ดูจากไฟล์จริง, checklist, backtest/proof, package และ lead/customer เพื่อบอกว่าควรทำอะไรก่อน</div>
        </div>
        <span style="border:1px solid var(--ok);background:rgba(35,217,126,.05);color:var(--ok);border-radius:999px;padding:7px 11px;font-size:11px;font-weight:900;white-space:nowrap">NO TOKEN USED</span>
      </div>
      <div style="display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:12px">
        {decision_bucket("Sell Ready", "sell_ready", "var(--ok)", "พร้อมนำเสนอ/ปิดการขาย")}
        {decision_bucket("Test Next", "test_next", "var(--cyan)", "ควรทดสอบก่อนขาย")}
        {decision_bucket("Package Next", "package_next", "var(--gold)", "ทำ ZIP/key/คู่มือ")}
        {decision_bucket("Needs Review", "needs_review", "var(--warn)", "ไฟล์หรือข้อมูลยังไม่พร้อม")}
      </div>
    </div>
    '''
    zip_badge = "READY" if customer_zip_ready else "MISSING"
    zip_color = "var(--ok)" if customer_zip_ready else "var(--warn)"
    add_ea_form = '''
    <div style="background:var(--panel);border:1px solid var(--line);border-radius:16px;padding:18px;margin-bottom:24px">
      <div style="display:flex;justify-content:space-between;gap:12px;align-items:flex-start;margin-bottom:12px">
        <div>
          <h2 class="section-title" style="margin:0 0 6px">Add EA / Indicator</h2>
          <div style="color:var(--muted);font-size:12px">เพิ่มระบบใหม่จากหน้าเว็บได้เลย ใส่ชื่อกับ path ก่อนก็พอ รายละเอียดอื่นแก้ทีหลังในหน้า Details ได้</div>
        </div>
        <span style="border:1px solid var(--ok);color:var(--ok);border-radius:999px;padding:6px 10px;font-size:11px;font-weight:900">JSON REGISTRY</span>
      </div>
      <form method="POST" action="/ea-add" style="display:grid;grid-template-columns:1.2fr 1.6fr .8fr .8fr .8fr auto;gap:10px;align-items:center">
        <input name="name" required placeholder="EA name เช่น My Gold EA" style="padding:12px;border-radius:8px;border:1px solid var(--line);background:var(--bg-2);color:var(--text)">
        <input name="path" required placeholder="C:\\Users\\ADMIN\\Desktop\\..." style="padding:12px;border-radius:8px;border:1px solid var(--line);background:var(--bg-2);color:var(--text)">
        <select name="kind" style="padding:12px;border-radius:8px;border:1px solid var(--line);background:var(--bg-2);color:var(--text)">
          <option>MT5 EA</option>
          <option>TradingView Indicator</option>
          <option>Python Tool</option>
          <option>Research System</option>
        </select>
        <input name="market" placeholder="XAUUSD" style="padding:12px;border-radius:8px;border:1px solid var(--line);background:var(--bg-2);color:var(--text)">
        <select name="stage" style="padding:12px;border-radius:8px;border:1px solid var(--line);background:var(--bg-2);color:var(--text)">
          <option>Research</option>
          <option>Backtest</option>
          <option>Forward Test</option>
          <option>Product candidate</option>
          <option>Customer ready</option>
        </select>
        <button class="btn btn-batch" style="padding:12px 18px;min-width:128px">Add</button>
      </form>
    </div>
    '''

    # --- Daily Briefing ---
    bucket_meta = [
        ("sell_ready",   "SELL READY",   "var(--ok)"),
        ("package_next", "PACKAGE NEXT", "var(--gold)"),
        ("test_next",    "TEST NEXT",    "var(--cyan)"),
        ("needs_review", "NEEDS REVIEW", "var(--warn)"),
    ]
    focus_items = []
    for bucket, blabel, bcolor in bucket_meta:
        for snap in decision_board.get(bucket, []):
            focus_items.append((blabel, bcolor, snap["ea"]["name"], snap["action"]))
            if len(focus_items) >= 3:
                break
        if len(focus_items) >= 3:
            break
    focus_cards = "".join(f'''
        <div style="flex:1;min-width:190px;background:var(--bg-2);border:1px solid {bc}44;border-radius:12px;padding:12px 14px">
          <span style="border:1px solid {bc};color:{bc};border-radius:999px;padding:2px 7px;font-size:10px;font-weight:900;display:inline-block;margin-bottom:6px">{bl}</span>
          <div style="color:var(--text);font-weight:900;font-size:13px;margin-bottom:3px">{html.escape(en)}</div>
          <div style="color:var(--muted);font-size:11px">{html.escape(ac)}</div>
        </div>''' for bl, bc, en, ac in focus_items) or '<div style="color:var(--muted);font-size:12px;padding:8px 0">ยังไม่มี EA ในระบบ</div>'
    queue_color = "var(--warn)" if q["pending"] > 100 else "var(--gold)" if q["pending"] > 20 else "var(--ok)"
    briefing_html = f'''
    <div style="background:var(--panel);border:1px solid var(--line);border-radius:16px;padding:16px 18px;margin-bottom:18px">
      <div style="display:flex;align-items:center;justify-content:space-between;margin-bottom:12px">
        <span style="color:var(--gold);font-size:11px;font-weight:900;letter-spacing:.16em;text-transform:uppercase">TODAY\'S FOCUS</span>
        <span style="color:var(--muted);font-size:11px">{datetime.now().strftime("%Y-%m-%d %H:%M")}</span>
      </div>
      <div style="display:flex;gap:10px;flex-wrap:wrap;margin-bottom:12px">{focus_cards}</div>
      <div style="display:flex;gap:18px;flex-wrap:wrap;border-top:1px solid var(--line);padding-top:10px;font-family:Consolas,monospace;font-size:11px;color:var(--muted)">
        <span>QUEUE <b style="color:{queue_color}">{q["pending"]}</b> pending</span>
        <span>CME <b style="color:var(--cyan)">{cme["total"]}</b> cases</span>
        <span>ALPHA <b style="color:var(--ok)">{alphaedge["total"]}</b> cases</span>
        <span>NINJA <b style="color:var(--blue)">{ninja["total"]}</b> cases</span>
        <span>PROP <b style="color:var(--ok)">{prop["total"]}</b> trades</span>
        <span>BIZ <b style="color:var(--gold)">{biz["total"]}</b> accounts</span>
        <a href="/job-history" style="color:var(--cyan);text-decoration:none;margin-left:auto">job log →</a>
      </div>
    </div>'''

    return f"""{briefing_html}
    <div style="position:relative;overflow:hidden;border:1px solid var(--line-bright);border-radius:16px;padding:26px;margin-bottom:22px;background:var(--panel);box-shadow:var(--shadow)">
      <div style="display:grid;grid-template-columns:1.35fr .65fr;gap:18px;align-items:center">
        <div>
          <div style="color:var(--gold);font-weight:900;letter-spacing:.18em;text-transform:uppercase;font-size:12px;margin-bottom:10px">EA COMMAND CENTER</div>
          <h1 style="margin:0;color:var(--text);font-size:42px;letter-spacing:.06em;line-height:1">EA MANAGEMENT HUB</h1>
          <p style="color:var(--muted);font-size:15px;line-height:1.8;max-width:780px;margin:14px 0 0">
            ศูนย์จัดการ EA / Indicator / CME Package / Learning System ในหน้าเดียว ใช้ดูสถานะไฟล์ เปิดโฟลเดอร์งาน และวางแผนต่อยอดขายกับทดสอบระบบ
          </p>
        </div>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px">
          {stat_card("EA Systems", len(catalog), "registered projects", "var(--cyan)")}
          {stat_card("Source Ready", ea_ready_count, f"Missing: {ea_missing_count}", "var(--ok)")}
          {stat_card("Knowledge Notes", q['written'], f"Atoms: {atoms}", "var(--gold)")}
          {stat_card("Customer ZIP", zip_badge, "AlphaEdge package", zip_color)}
        </div>
      </div>
    </div>

    <h2 class="section-title" style="margin-bottom:14px">EA Fleet</h2>
    {decision_board_html}
    {sales_pipeline_panel()}
    {add_ea_form}
    {_alphaedge_journal_panel()}
    <div style="display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:14px;margin-bottom:24px">
      {ea_cards}
    </div>

    <h2 class="section-title" style="margin-bottom:14px">Trading Intelligence Modules</h2>
    <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:24px">
      {module_card("Learning Review", "AI", f"Written: {q['written']} &nbsp;|&nbsp; Atoms: {atoms}<br>Pending: {q['pending']}", "/", "ACTIVE")}
      {module_card("CME Reading Library", "CME", f"Readings: {cme['total']}<br>Bullish: {cme['bullish']} &nbsp;|&nbsp; Bearish: {cme['bearish']}", "/#cme-reading-section")}
      {module_card("SMC Research Analyzer", "SMC", "CSV OHLCV -> BOS / CHoCH / FVG / OB report<br>File: CME/smc_research_analyzer.py", "#", "NEW")}
      {module_card("AlphaEdge Journal", "AEX", f"Cases: {alphaedge['total']} &nbsp;|&nbsp; WR: {alphaedge['win_rate']}%<br>Avg R: {alphaedge['avg_r']} &nbsp;|&nbsp; Top: {alphaedge['top_symbol']}", "/hub#alphaedge-journal-section", "NEW")}
      {module_card("Ninja Strategy Cases", "NIN", f"Cases: {ninja['total']}<br>Setup types: {ninja['setup_types']} &nbsp;|&nbsp; Top: {ninja['top_type']}", "/#ninja-section")}
      {module_card("Prop Trading Lab", "PROP", f"Cases: {prop['total']} &nbsp;|&nbsp; WR: {prop['win_rate']}%<br>Wins: {prop['wins']} &nbsp;|&nbsp; Losses: {prop['losses']}", "/#prop-trading-section")}
      {module_card("Prop Business", "BIZ", f"Accounts: {biz['total']} &nbsp;|&nbsp; Funded: {biz['funded']}<br>Net Profit: ${biz['net_profit']}", "/#prop-business-section")}
    </div>

    <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px;margin-bottom:24px">
      <div style="background:var(--panel);border:1px solid var(--line);border-radius:16px;padding:18px">
        <h2 class="section-title" style="margin-bottom:12px">Product Workflow</h2>
        <div style="display:grid;gap:10px;font-size:13px;color:var(--text)">
          <div><b style="color:var(--ok)">1. Research</b> - collect knowledge, NotebookLM, SMC/CME/Ninja cases</div>
          <div><b style="color:var(--cyan)">2. Build</b> - EA / Pine / analyzer / risk rules</div>
          <div><b style="color:var(--gold)">3. Test</b> - backtest, forward test, session/regime stats</div>
          <div><b style="color:var(--warn)">4. Package</b> - customer zip, license key, install guide</div>
          <div><b style="color:var(--blue)">5. Sell + Support</b> - member package, setup call, changelog</div>
        </div>
      </div>
      <div style="background:var(--panel);border:1px solid var(--line);border-radius:16px;padding:18px;font-family:Consolas,monospace">
        <h2 class="section-title" style="margin-bottom:12px">Recent Events</h2>
        {job_rows}
        <div style="margin-top:10px"><a href="/job-history" style="color:var(--cyan);font-size:12px">View all -></a></div>
      </div>
    </div>

    <h2 class="section-title" style="margin-bottom:14px;margin-top:24px">Quick Links</h2>
    <div style="display:flex;gap:10px;flex-wrap:wrap">
      <a href="/" class="btn btn-collect-nav" style="padding:10px 18px">Review Queue</a>
      <a href="/written" class="btn btn-toggle" style="padding:10px 18px">Written Notes</a>
      <a href="/job-history" class="btn btn-toggle" style="padding:10px 18px">Job Log</a>
      <a href="/all" class="btn btn-toggle" style="padding:10px 18px">All Items</a>
    </div>
    """



@app.route("/hub")
def hub_page():
    import glob as _glob
    import atom_store

    q = qs.count_by_status()
    atoms = atom_store.count_atoms()
    prop = ps.stats()
    cme = cs.stats()
    biz = pbs.stats()
    ninja = ns.stats()
    alphaedge = aes.stats()
    recent_jobs = job_log.get_recent(6)
    return _render_page(_ea_management_hub_body(q, atoms, prop, cme, biz, ninja, alphaedge, recent_jobs), "EA Management Hub", show_hero=False)

    ea_path = os.path.join(os.path.dirname(__file__), "..", "EA-Knowledge-Base", "EAs")
    ea_count = len(_glob.glob(ea_path + "/**/*.md", recursive=True)) if os.path.exists(ea_path) else 0

    level_color = {"ok": "#7bffb2", "warn": "#ff8e7f", "error": "#ff8e7f", "info": "#8fb2d9"}

    job_rows = ""
    for e in recent_jobs:
        color = level_color.get(e.get("level", "info"), "#8fb2d9")
        job_rows += f'<div style="display:flex;gap:10px;font-size:12px;padding:4px 0;border-bottom:1px solid rgba(77,208,255,.07)"><span style="color:#6f9bc8;white-space:nowrap">{e["ts"]}</span><span style="color:{color}">{e["type"]}</span><span style="color:#a9c6e6;flex:1;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">{html.escape(e.get("detail",""))}</span></div>'
    if not job_rows:
        job_rows = '<div style="color:#6f9bc8;font-size:13px;padding:8px 0">No events yet</div>'

    def stat_card(title, val, sub="", color="#4dd0ff"):
        return f'''<div style="background:linear-gradient(180deg,rgba(22,39,66,.96),rgba(16,29,49,.96));border:1px solid rgba(77,208,255,.15);border-radius:16px;padding:18px 16px;min-height:90px">
          <div style="font-size:11px;color:#8fb2d9;text-transform:uppercase;letter-spacing:.14em;margin-bottom:8px">{title}</div>
          <div style="font-size:30px;font-weight:800;color:{color};line-height:1">{val}</div>
          {f'<div style="font-size:11px;color:#6f9bc8;margin-top:6px">{sub}</div>' if sub else ""}
        </div>'''

    def module_card(title, icon, stats_html, href, badge=""):
        badge_html = f'<span style="background:rgba(77,208,255,.15);color:#4dd0ff;border-radius:999px;padding:2px 8px;font-size:10px;font-weight:800;letter-spacing:.1em">{badge}</span>' if badge else ""
        return f'''<a href="{href}" style="text-decoration:none">
          <div style="background:linear-gradient(180deg,rgba(22,39,66,.96),rgba(16,29,49,.96));border:1px solid rgba(77,208,255,.15);border-radius:16px;padding:16px;cursor:pointer;transition:border-color .18s ease" onmouseover="this.style.borderColor='rgba(77,208,255,.4)'" onmouseout="this.style.borderColor='rgba(77,208,255,.15)'">
            <div style="display:flex;align-items:center;gap:8px;margin-bottom:10px">{icon}<span style="font-size:14px;font-weight:800;color:#f1f7ff">{title}</span>{badge_html}</div>
            <div style="font-size:12px;color:#8fb2d9;line-height:1.7">{stats_html}</div>
          </div>
        </a>'''

    body = f"""
    <div style="margin-bottom:20px">
      <div style="display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:12px">
        {stat_card("Notes Written", q['written'], "in Obsidian vault")}
        {stat_card("Atoms", atoms, "insights extracted", "#7bffb2")}
        {stat_card("EA Blueprints", ea_count, "in EA library", "#ffd166")}
        {stat_card("Pending Review", q['pending'], "waiting to approve")}
      </div>
    </div>

    <h2 class="section-title" style="margin-bottom:14px">Knowledge Modules</h2>
    <div style="display:grid;grid-template-columns:repeat(3,1fr);gap:12px;margin-bottom:24px">
      {module_card("Learning Review", "📚", f"Written: {q['written']} &nbsp;|&nbsp; Atoms: {atoms}<br>Pending: {q['pending']}", "/", "ACTIVE")}
      {module_card("Prop Trading Lab", "📊", f"Cases: {prop['total']} &nbsp;|&nbsp; WR: {prop['win_rate']}%<br>Wins: {prop['wins']} &nbsp;|&nbsp; Losses: {prop['losses']}", "/#prop-trading-section")}
      {module_card("CME Reading Library", "📈", f"Readings: {cme['total']}<br>Bullish: {cme['bullish']} &nbsp;|&nbsp; Bearish: {cme['bearish']}", "/#cme-reading-section")}
      {module_card("Ninja Strategy Cases", "🥷", f"Cases: {ninja['total']}<br>Setup types: {ninja['setup_types']} &nbsp;|&nbsp; Top: {ninja['top_type']}", "/#ninja-section")}
      {module_card("Prop Business", "💼", f"Accounts: {biz['total']} &nbsp;|&nbsp; Funded: {biz['funded']}<br>Net Profit: ${biz['net_profit']}", "/#prop-business-section")}
      {module_card("Job History", "📋", "Persistent event log<br>Survives server restarts", "/job-history")}
    </div>

    <h2 class="section-title" style="margin-bottom:14px">Recent Events</h2>
    <div style="background:rgba(10,20,36,.92);border:1px solid rgba(77,208,255,.15);border-radius:16px;padding:16px;font-family:Consolas,monospace">
      {job_rows}
      <div style="margin-top:10px"><a href="/job-history" style="color:#4dd0ff;font-size:12px">View all →</a></div>
    </div>

    <h2 class="section-title" style="margin-bottom:14px;margin-top:24px">Quick Links</h2>
    <div style="display:flex;gap:10px;flex-wrap:wrap">
      <a href="/" class="btn btn-collect-nav" style="padding:10px 18px">Review Queue</a>
      <a href="/written" class="btn btn-toggle" style="padding:10px 18px">Written Notes</a>
      <a href="/job-history" class="btn btn-toggle" style="padding:10px 18px">Job Log</a>
      <a href="/all" class="btn btn-toggle" style="padding:10px 18px">All Items</a>
    </div>
    """
    return _render_page(body, "EA Codex Hub", show_hero=False)


@app.route("/job-history")
def job_history_page():
    events = job_log.get_recent(100)
    level_color = {"ok": "var(--ok)", "warn": "var(--warn)", "error": "var(--warn)", "info": "var(--muted)"}
    rows = ""
    for e in events:
        color = level_color.get(e.get("level", "info"), "var(--muted)")
        rows += f'<tr><td style="color:var(--muted);white-space:nowrap">{e["ts"]}</td><td style="color:{color};padding:0 12px">{e["type"]}</td><td style="color:var(--text)">{html.escape(e.get("detail",""))}</td></tr>'
    if not rows:
        rows = '<tr><td colspan="3" style="text-align:center;color:var(--muted);padding:32px">No events yet</td></tr>'
    body = f"""
    <h2 class='section-title'>Job History (last 100)</h2>
    <div style="background:rgba(10,20,36,.92);border:1px solid rgba(77,208,255,.18);border-radius:16px;overflow:auto;padding:16px">
      <table style="width:100%;border-collapse:collapse;font-size:13px;font-family:Consolas,monospace">
        <thead><tr>
          <th style="text-align:left;color:var(--muted);padding-bottom:10px;white-space:nowrap">Time</th>
          <th style="text-align:left;color:var(--muted);padding:0 12px 10px">Type</th>
          <th style="text-align:left;color:var(--muted);padding-bottom:10px">Detail</th>
        </tr></thead>
        <tbody>{rows}</tbody>
      </table>
    </div>"""
    return _render_page(body, "Job History", show_hero=False)


if __name__ == "__main__":
    print("Review App running at http://localhost:5055")
    app.run(host="0.0.0.0", port=5055, debug=False)
