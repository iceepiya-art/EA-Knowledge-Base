"""Tests for root launcher batch files.

ORCA: tests written before implementation.
"""
from __future__ import annotations

from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def test_start_launcher_exists():
    assert (ROOT / "Start_EA_Knowledge_Brain.bat").exists()


def test_start_launcher_runs_server_manager_and_opens_dashboard():
    text = (ROOT / "Start_EA_Knowledge_Brain.bat").read_text(encoding="utf-8")

    assert "server_manager.py" in text
    assert "EA_Knowledge_Brain_Dashboard.html" in text
    assert "start \"EA Knowledge Brain Manager\"" in text
    assert "LOCAL_LLM_URL=http://127.0.0.1:1234/v1" in text


def test_silent_launcher_configures_lm_studio_fallback():
    text = (ROOT / "Start_EA_Knowledge_Brain_Silent.ps1").read_text(encoding="utf-8")

    assert "$env:LOCAL_LLM_URL = \"http://127.0.0.1:1234/v1\"" in text
    assert "$env:LOCAL_LLM_MODEL = \"google/gemma-4-e4b\"" in text


def test_stop_launcher_exists():
    assert (ROOT / "Stop_EA_Knowledge_Brain.bat").exists()


def test_stop_launcher_stops_api_and_manager_port():
    text = (ROOT / "Stop_EA_Knowledge_Brain.bat").read_text(encoding="utf-8")

    assert "/api/manager/stop" in text
    assert "LocalPort 5050" in text
    assert "Stop-Process" in text


def test_dashboard_settings_loads_engine_status_panel():
    text = (ROOT / "00_Dashboard" / "EA_Knowledge_Brain_Dashboard.html").read_text(encoding="utf-8")

    assert "Engine Status" in text
    assert "/api/learning/engine-status" in text
    assert "loadEngineStatus" in text
    assert "engine-video-status" in text
    assert "engine-ocr-status" in text
