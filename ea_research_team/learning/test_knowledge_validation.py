import pytest
from pathlib import Path
import os
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent.parent.parent))

try:
    from run_knowledge_validation import generate_ini_content, validate_report_trades
except ImportError:
    generate_ini_content = None
    validate_report_trades = None

def test_backtest_configuration_enforces_constraints():
    """
    Test that the backtest configuration generation enforces:
    - Symbol = XAUUSD_Hist
    - Period = M5
    - Backtest only (no live trading)
    """
    if generate_ini_content is None:
        pytest.fail("generate_ini_content is not implemented yet.")
        
    ini_content = generate_ini_content(ea_name="TestEA", risk_percent=1.0, rr_ratio=1.0)
    
    assert "Symbol=XAUUSD_Hist" in ini_content, "Must run on XAUUSD_Hist"
    assert "Period=M5" in ini_content, "Must run on M5 timeframe"
    assert "Optimization=0" in ini_content, "Optimization must be disabled for single test"
    assert "Login=121059" in ini_content, "Must use QRSGlobal Demo 121059"

def test_risk_management_constraints():
    """
    Test that RiskPercent and RR_Ratio are injected into the EA inputs for backtesting.
    """
    ini_content = generate_ini_content(ea_name="TestEA", risk_percent=1.0, rr_ratio=1.0)
    
    assert "[Inputs]" in ini_content, "Must define Inputs section for EA"
    assert "RiskPercent=1.0" in ini_content, "Risk must be 1.0%"
    assert "RR_Ratio=1.0" in ini_content, "RR must be 1.0"

def test_rule_1_validation(tmp_path):
    """
    Test that the validation logic requires >= 1000 trades per year.
    """
    if validate_report_trades is None:
        pytest.fail("validate_report_trades is not implemented yet.")
        
    report_mock = tmp_path / "Report.xml"
    report_mock.write_text("<Report><TotalTrades>1500</TotalTrades><Years>1</Years></Report>")
    
    is_valid, msg = validate_report_trades(str(report_mock))
    assert is_valid is True
    assert "1500 trades" in msg

    report_mock_fail = tmp_path / "ReportFail.xml"
    report_mock_fail.write_text("<Report><TotalTrades>500</TotalTrades><Years>1</Years></Report>")
    
    is_valid, msg = validate_report_trades(str(report_mock_fail))
    assert is_valid is False
    assert "Insufficient trades" in msg
