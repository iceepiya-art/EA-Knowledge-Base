"""Tests for handoff.py — Multi-Agent Handoff CLI.

ORCA: tests written before implementation.
Covers: file existence, status() output, log_entry() append behavior, CLI exit codes.
"""
from __future__ import annotations

import subprocess
import sys
from datetime import datetime
from pathlib import Path

import pytest

from handoff import HANDOFF_DIR, log_entry, status

REQUIRED_FILES = [
    "CURRENT_STATE.md",
    "NEXT_TASK.md",
    "DECISIONS.md",
    "RUNBOOK.md",
    "TEST_STATUS.md",
    "HANDOFF_LOG.md",
]

_HANDOFF_PY = Path(__file__).with_name("handoff.py")


# ---------------------------------------------------------------------------
# Fixtures
# ---------------------------------------------------------------------------

@pytest.fixture
def tmp_handoff(tmp_path):
    hd = tmp_path / ".agent_handoff"
    hd.mkdir()
    (hd / "CURRENT_STATE.md").write_text(
        "# Current State\n## Status\nAll systems operational.\n", encoding="utf-8"
    )
    (hd / "NEXT_TASK.md").write_text(
        "# Next Task\n## Task\nExample task description.\n", encoding="utf-8"
    )
    (hd / "DECISIONS.md").write_text(
        "# Decisions\n## D1\nUse atomic writes for all JSON stores.\n", encoding="utf-8"
    )
    (hd / "RUNBOOK.md").write_text(
        "# Runbook\n## Run API\n```\npython server.py\n```\n", encoding="utf-8"
    )
    (hd / "TEST_STATUS.md").write_text(
        "# Test Status\n## Last Run\n98 passed in 4.20s\n", encoding="utf-8"
    )
    (hd / "HANDOFF_LOG.md").write_text("# Handoff Log\n\n", encoding="utf-8")
    return hd


# ---------------------------------------------------------------------------
# Real project file existence tests
# ---------------------------------------------------------------------------

def test_handoff_dir_exists():
    assert HANDOFF_DIR.exists(), f"Expected {HANDOFF_DIR} to exist"


def test_all_required_files_exist():
    for fname in REQUIRED_FILES:
        path = HANDOFF_DIR / fname
        assert path.exists(), f"Missing required handoff file: {fname}"


def test_current_state_has_status_section():
    text = (HANDOFF_DIR / "CURRENT_STATE.md").read_text(encoding="utf-8")
    assert "Status" in text


def test_current_state_mentions_latest_pipeline_components():
    text = (HANDOFF_DIR / "CURRENT_STATE.md").read_text(encoding="utf-8")
    assert "auto-pipeline" in text.lower()
    assert "EA Component" in text
    assert "EA Blueprint" in text
    assert "Concept deduplicator" in text


def test_next_task_has_task_section():
    text = (HANDOFF_DIR / "NEXT_TASK.md").read_text(encoding="utf-8")
    assert "Task" in text


def test_next_task_is_actionable_not_awaiting_direction():
    text = (HANDOFF_DIR / "NEXT_TASK.md").read_text(encoding="utf-8")
    assert "Awaiting User Direction" not in text
    assert "Acceptance Criteria" in text
    assert "Files to change" in text


def test_runbook_has_python_command():
    text = (HANDOFF_DIR / "RUNBOOK.md").read_text(encoding="utf-8")
    assert "python" in text.lower()


def test_test_status_has_pass_info():
    text = (HANDOFF_DIR / "TEST_STATUS.md").read_text(encoding="utf-8")
    assert "pass" in text.lower()


def test_decisions_has_content():
    text = (HANDOFF_DIR / "DECISIONS.md").read_text(encoding="utf-8")
    assert len(text.strip()) > 50


def test_handoff_log_is_readable():
    text = (HANDOFF_DIR / "HANDOFF_LOG.md").read_text(encoding="utf-8")
    assert isinstance(text, str)


# ---------------------------------------------------------------------------
# status() function (uses tmp_handoff for isolation)
# ---------------------------------------------------------------------------

def test_status_returns_string(tmp_handoff):
    result = status(tmp_handoff)
    assert isinstance(result, str)


def test_status_includes_current_state_content(tmp_handoff):
    result = status(tmp_handoff)
    assert "All systems operational" in result


def test_status_includes_next_task_content(tmp_handoff):
    result = status(tmp_handoff)
    assert "Example task description" in result


def test_status_includes_test_status_content(tmp_handoff):
    result = status(tmp_handoff)
    assert "98 passed" in result


def test_status_includes_runbook_command(tmp_handoff):
    result = status(tmp_handoff)
    assert "python" in result.lower()


def test_status_graceful_when_file_missing(tmp_path):
    hd = tmp_path / ".agent_handoff"
    hd.mkdir()
    result = status(hd)
    assert isinstance(result, str)
    assert len(result) > 0


# ---------------------------------------------------------------------------
# status CLI (subprocess)
# ---------------------------------------------------------------------------

def test_status_cli_exits_zero(tmp_handoff):
    result = subprocess.run(
        [sys.executable, str(_HANDOFF_PY), "status", "--dir", str(tmp_handoff)],
        capture_output=True, text=True,
    )
    assert result.returncode == 0


def test_status_cli_prints_to_stdout(tmp_handoff):
    result = subprocess.run(
        [sys.executable, str(_HANDOFF_PY), "status", "--dir", str(tmp_handoff)],
        capture_output=True, text=True,
    )
    assert "All systems operational" in result.stdout


# ---------------------------------------------------------------------------
# log_entry() function
# ---------------------------------------------------------------------------

def test_log_entry_appends_to_file(tmp_handoff):
    log_file = tmp_handoff / "HANDOFF_LOG.md"
    before = len(log_file.read_text(encoding="utf-8"))
    log_entry("Test entry message", handoff_dir=tmp_handoff)
    after = len(log_file.read_text(encoding="utf-8"))
    assert after > before


def test_log_entry_contains_message(tmp_handoff):
    log_entry("my specific log message", handoff_dir=tmp_handoff)
    text = (tmp_handoff / "HANDOFF_LOG.md").read_text(encoding="utf-8")
    assert "my specific log message" in text


def test_log_entry_contains_timestamp(tmp_handoff):
    log_entry("timestamped entry", handoff_dir=tmp_handoff)
    text = (tmp_handoff / "HANDOFF_LOG.md").read_text(encoding="utf-8")
    assert str(datetime.now().year) in text


def test_log_entry_preserves_existing_content(tmp_handoff):
    log_file = tmp_handoff / "HANDOFF_LOG.md"
    log_file.write_text("# Handoff Log\n\n## Old Entry\nOld content here.\n", encoding="utf-8")
    log_entry("New entry", handoff_dir=tmp_handoff)
    text = log_file.read_text(encoding="utf-8")
    assert "Old content here" in text
    assert "New entry" in text


def test_log_entry_two_calls_both_present(tmp_handoff):
    log_entry("First message", handoff_dir=tmp_handoff)
    log_entry("Second message", handoff_dir=tmp_handoff)
    text = (tmp_handoff / "HANDOFF_LOG.md").read_text(encoding="utf-8")
    assert "First message" in text
    assert "Second message" in text


def test_log_entry_creates_file_if_missing(tmp_path):
    hd = tmp_path / ".agent_handoff"
    hd.mkdir()
    log_file = hd / "HANDOFF_LOG.md"
    assert not log_file.exists()
    log_entry("Bootstrap entry", handoff_dir=hd)
    assert log_file.exists()
    assert "Bootstrap entry" in log_file.read_text(encoding="utf-8")


# ---------------------------------------------------------------------------
# log CLI (subprocess)
# ---------------------------------------------------------------------------

def test_log_cli_exits_zero(tmp_handoff):
    result = subprocess.run(
        [sys.executable, str(_HANDOFF_PY), "log", "cli log test message",
         "--dir", str(tmp_handoff)],
        capture_output=True, text=True,
    )
    assert result.returncode == 0


def test_log_cli_writes_message_to_file(tmp_handoff):
    subprocess.run(
        [sys.executable, str(_HANDOFF_PY), "log", "cli written message",
         "--dir", str(tmp_handoff)],
        capture_output=True, text=True,
    )
    text = (tmp_handoff / "HANDOFF_LOG.md").read_text(encoding="utf-8")
    assert "cli written message" in text
