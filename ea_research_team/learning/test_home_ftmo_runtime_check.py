"""Static safety checks for the FTMO home-runtime preflight launcher."""
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def test_home_ftmo_preflight_is_read_only_and_never_starts_trading():
    text = (ROOT / "CHECK_HOME_FTMO_RUNTIME.bat").read_text(encoding="utf-8")

    assert "py -3.13 --version" in text
    assert 'if not exist "%ROOT%.env"' in text
    assert "terminal64.exe" in text
    assert "http://127.0.0.1:5000/dashboard" in text
    assert "1_START_TRADING_NOW.bat" not in text
    assert "START_MASTER_TRADING_CYCLE.bat" not in text
    assert "START_MASTER_MINIMAL.bat" not in text
