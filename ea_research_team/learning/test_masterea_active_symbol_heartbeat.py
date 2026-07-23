"""Regression test for MasterEA poll -> runner active-symbol registration."""
import json

from server import create_app


def test_masterea_poll_registers_symbol_for_local_runner(tmp_path):
    registry_path = tmp_path / "active_symbols.json"
    app = create_app({"TESTING": True, "ACTIVE_SYMBOLS_FILE": str(registry_path), "SIGNAL_FILE": str(tmp_path / "latest_signal.json")})

    response = app.test_client().get("/api/signals/latest?symbol=XAUUSD")

    assert response.status_code == 200
    assert response.get_json() == {"status": "ok", "signal": None}
    registry = json.loads(registry_path.read_text(encoding="utf-8"))
    assert registry["XAUUSD"]["last_seen"] > 0
