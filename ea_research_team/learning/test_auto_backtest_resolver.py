import json
from pathlib import Path
import pytest
from unittest.mock import patch, MagicMock

import auto_backtest_resolver
from auto_backtest_resolver import resolve_single_conflict, parse_report_metrics

@pytest.fixture
def mock_conflict_queue(tmp_path):
    queue_path = tmp_path / "conflict_review_queue.json"
    data = {
        "items": {
            "test_cid_1": {
                "conflict_id": "test_cid_1",
                "concept": "EMA_Cross",
                "type": "contradiction",
                "status": "pending",
                "rule_a": "buy if EMA 20 crosses above EMA 50",
                "rule_b": "buy if EMA 20 crosses above EMA 200"
            }
        }
    }
    queue_path.write_text(json.dumps(data), encoding="utf-8")
    return queue_path

def test_parse_report_metrics(tmp_path):
    report_file = tmp_path / "Report.htm"
    report_file.write_text(
        "<div>Total Net Profit: 1500.50</div>"
        "<div>Maximal Drawdown: 15.2%</div>"
        "<div>Profit Factor: 1.45</div>",
        encoding="utf-8"
    )
    metrics = parse_report_metrics(report_file)
    assert metrics["profit"] == 1500.5
    assert metrics["drawdown"] == 15.2
    assert metrics["profit_factor"] == 1.45

@patch("auto_backtest_resolver.resolve_conflict")
@patch("mt5_cli.run_backtest")
@patch("mt5_cli.compile_ea")
@patch("auto_backtest_resolver.generate_ea")
@patch("os.getenv")
def test_resolve_single_conflict_winner_b(mock_getenv, mock_gen_ea, mock_compile, mock_run, mock_resolve, tmp_path):
    mock_getenv.return_value = "fake_api_key"
    mock_gen_ea.return_value = "void OnTick() {}"
    mock_compile.return_value = True
    
    # We need mt5_cli.run_backtest to fake the Report_A.htm and Report_B.htm
    def fake_run_backtest(ea_path, symbol, from_date, to_date, report_name, period):
        report_file = ea_path.parent / report_name
        if "_A_" in report_name:
            # Variant A: PF 1.2, DD 20, Profit 500
            report_file.write_text("Total Net Profit: 500\nMaximal Drawdown: 20%\nProfit Factor: 1.2", encoding="utf-8")
        else:
            # Variant B: PF 1.5, DD 10, Profit 1000
            report_file.write_text("Total Net Profit: 1000\nMaximal Drawdown: 10%\nProfit Factor: 1.5", encoding="utf-8")
        return True
        
    mock_run.side_effect = fake_run_backtest
    
    conflict = {
        "conflict_id": "test_cid_1",
        "concept": "EMA_Cross",
        "type": "contradiction",
        "rule_a": "rule a",
        "rule_b": "rule b"
    }
    
    result = resolve_single_conflict(conflict)
    
    assert result is True
    # Variant B gets 1000 * 12 tests = 12000 total profit. Variant A gets 500 * 12 = 6000 total profit.
    # Variant B wins.
    mock_resolve.assert_called_once_with("test_cid_1", "accepted_rule_b", "Variant B won empirically across 1m, 1y, 2y, 3y (H1, M30, M15). Score 12000.0 vs 6000.0.")
