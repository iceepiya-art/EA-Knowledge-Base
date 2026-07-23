"""Static safety checks for the home-runtime bootstrap launcher."""
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def test_home_runtime_setup_is_safe_and_preserves_machine_configuration():
    text = (ROOT / "SETUP_HOME_RUNTIME.bat").read_text(encoding="utf-8")

    assert "EA_KB_HOME_RUNTIME_ROOT" in text
    assert "https://github.com/iceepiya-art/EA-Knowledge-Base.git" in text
    assert "git clone" in text
    assert "git -C \"%EA_KB_HOME_RUNTIME_ROOT%\" pull --ff-only" in text
    assert ".env.example" in text
    assert "Existing .env was preserved." in text
    assert "test_launcher_scripts.py" in text
    assert "START_MASTER_FULL_RESEARCH.bat" in text
    assert "call \"%EA_KB_HOME_RUNTIME_ROOT%\\1_START_TRADING_NOW.bat\"" not in text


def test_homepc_installer_bootstraps_only_the_local_runtime():
    text = (ROOT / "INSTALL_HOMEPC_RUNTIME.bat").read_text(encoding="utf-8")

    assert "EA_KB_HOME_RUNTIME_ROOT" in text
    assert "https://github.com/iceepiya-art/EA-Knowledge-Base.git" in text
    assert "git clone" in text
    assert 'call "%EA_KB_HOME_RUNTIME_ROOT%\\SETUP_HOME_RUNTIME.bat"' in text
    assert 'call "%EA_KB_HOME_RUNTIME_ROOT%\\1_START_TRADING_NOW.bat"' not in text
    assert "Start_EA_Backend.bat" not in text
