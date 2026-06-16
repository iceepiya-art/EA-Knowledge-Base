from pathlib import Path
import re


SOURCE = Path(__file__).with_name("Ouroboros_Inventory_EA.mq5")


def source_text() -> str:
    return SOURCE.read_text(encoding="utf-8")


def test_source_declares_safe_operating_modes_and_auto_default():
    text = source_text()
    assert "enum ENUM_OUROBOROS_MODE" in text
    assert "MODE_AUTO" in text
    assert "MODE_TESTER" in text
    assert "MODE_MONITOR" in text
    assert "MODE_TRADE" in text
    assert "InpMode = MODE_AUTO" in text
    assert "ENUM_OUROBOROS_MODE ActiveMode()" in text
    assert "MQLInfoInteger(MQL_TESTER) ? MODE_TESTER : MODE_MONITOR" in text
    assert "InpEnableTrading" in text and "false" in text
    assert "ACCOUNT_MARGIN_MODE_RETAIL_HEDGING" in text


def test_source_contains_inventory_harvest_and_debt_engine():
    text = source_text()
    required = [
        "struct PositionSnapshot",
        "CLASS_CORE_ASSET",
        "CLASS_HARVESTABLE",
        "CLASS_DEBT",
        "ClassifyPosition",
        "NormalizeVolume",
        "CanPairDebt",
        "SelectHarvestCandidate",
        "SelectDebtCandidate",
        "PositionClosePartial",
        "g_harvestCredit",
        "OnTradeTransaction",
    ]
    for token in required:
        assert token in text


def test_source_contains_fixed_lot_grid_and_risk_limits():
    text = source_text()
    required = [
        "InpFixedLot",
        "InpMaxPositionsPerSide",
        "InpMaxTotalLots",
        "InpPauseDrawdownPct",
        "InpEmergencyDrawdownPct",
        "InpMinMarginLevelPct",
        "InpEmergencyMarginLevelPct",
        "InpMaxSpreadPoints",
        "CalculateGridPoints",
        "EvaluateSafetyState",
        "EmergencyCloseAll",
        "g_emergencyLatched",
        "IsNewBar",
    ]
    for token in required:
        assert token in text


def test_monitor_mode_blocks_all_trade_mutations():
    text = source_text()
    assert "bool CanMutateTrades()" in text
    assert "ActiveMode() == MODE_MONITOR" in text
    assert "if(!CanMutateTrades())" in text


def test_source_has_dashboard_and_common_csv_audit():
    text = source_text()
    assert "UpdateDashboard" in text
    assert "Comment(" in text
    assert "FILE_COMMON" in text
    assert "ouroboros_inventory_audit.csv" in text
    assert "WriteAudit" in text


def test_source_prohibits_unbounded_or_remote_features():
    text = source_text().lower()
    assert "webrequest" not in text
    assert "#import" not in text
    assert "socket" not in text
    assert "martingale" not in text
    assert "lotmultiplier" not in text


def test_zero_or_subminimum_volume_is_not_rounded_up():
    text = source_text()
    normalize = re.search(
        r"double NormalizeVolume\(.*?\n\}", text, flags=re.DOTALL
    ).group(0)
    assert "if(requested < minimum) return 0.0;" in normalize


def test_emergency_close_is_not_blocked_by_its_own_latch():
    text = source_text()
    assert "bool CanExecuteEmergency()" in text
    emergency = re.search(
        r"bool EmergencyCloseAll\(\).*?\n\}", text, flags=re.DOTALL
    ).group(0)
    permission_check = emergency.index("CanExecuteEmergency()")
    latch_assignment = emergency.index("g_emergencyLatched = true")
    assert permission_check < latch_assignment
    assert "CanMutateTrades()" not in emergency
