"""Safety checks for the direct home Flask API restart launcher."""
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def test_restart_launcher_uses_current_runtime_and_verifies_signal_endpoint():
    text = (ROOT / "RESTART_HOME_API.bat").read_text(encoding="utf-8")

    assert 'set "LEARNING=%ROOT%ea_research_team\\learning"' in text
    assert "server.py" in text
    assert "127.0.0.1:5000/api/signals/latest?symbol=XAUUSD" in text
    assert "Get-CimInstance Win32_Process" in text
    assert "terminal64.exe" not in text
    assert "START_MASTER_TRADING_CYCLE.bat" not in text
    assert "1_START_TRADING_NOW.bat" not in text
