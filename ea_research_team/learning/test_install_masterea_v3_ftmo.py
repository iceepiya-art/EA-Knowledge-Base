"""Static safety checks for the one-click FTMO MasterEA v3 installer."""
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]


def test_installer_compiles_only_and_never_starts_trading():
    text = (ROOT / "INSTALL_MASTER_EA_V3_FTMO.bat").read_text(encoding="utf-8")

    assert "MasterEA_v3.mq5" in text
    assert "metaeditor64.exe" in text
    assert "/compile:" in text
    assert "MasterEA_v3.ex5" in text
    assert "origin.txt" in text
    assert "terminal64.exe" not in text
    assert "START_MASTER_TRADING_CYCLE.bat" not in text
    assert "1_START_TRADING_NOW.bat" not in text
