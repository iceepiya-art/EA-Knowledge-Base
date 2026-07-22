"""Contract test for the HTTP endpoint consumed by MasterEA v3."""
from __future__ import annotations

import json

from server import create_app


def test_masterea_signal_endpoint_returns_symbol_specific_signal(tmp_path):
    signal_file = tmp_path / "latest_signal.json"
    signal_file.write_text(
        json.dumps(
            {
                "XAUUSD": {
                    "symbol": "XAUUSD",
                    "action": "HOLD",
                    "signal_id": "SIG-XAU-HOLD",
                }
            }
        ),
        encoding="utf-8",
    )
    app = create_app({"TESTING": True, "SIGNAL_FILE": str(signal_file)})

    response = app.test_client().get("/api/signals/latest?symbol=XAUUSD")

    assert response.status_code == 200
    assert response.get_json() == {
        "status": "ok",
        "signal": {
            "symbol": "XAUUSD",
            "action": "HOLD",
            "signal_id": "SIG-XAU-HOLD",
        },
    }
