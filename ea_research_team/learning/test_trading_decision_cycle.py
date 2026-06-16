import pytest
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parent))

from trading_decision_cycle import run_sample_decision_cycle
from ea_registry import EARegistryStore
from decision_journal import DecisionJournalStore

def test_deterministic_sample_cycle(tmp_path):
    registry = EARegistryStore(tmp_path / "ea_registry.json")
    registry.register_ea({
        "ea_id": "EA_001",
        "ea_name": "Test EA",
        "magic_number": 12345
    })
    
    journal = DecisionJournalStore(tmp_path / "decision_journal.json", registry)
    
    # Run the cycle
    final_action = run_sample_decision_cycle(journal)
    
    # Assert final action is logged and dry-run executed
    assert final_action == "dry_run_executed"
    
    # Assert journal entry was created properly
    decisions = journal.list_decisions(ea_id="EA_001")
    assert len(decisions) == 1
    
    decision = decisions[0]
    assert decision["action"] == "buy"
    assert decision["hawk"]["signal"] == "buy"
    assert decision["sage"]["veto"] is False
    assert decision["risk_gate"]["approved"] is True
    assert decision["blade"]["mode"] == "dry_run"
    assert decision["status"] == "completed"
