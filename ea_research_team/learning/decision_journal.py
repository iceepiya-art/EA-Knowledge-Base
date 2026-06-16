from __future__ import annotations

import json
import uuid
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any

from ea_registry import EARegistryStore


TH_TZ = timezone(timedelta(hours=7))
DEFAULT_JOURNAL_PATH = Path(__file__).resolve().parent / ".server_manager" / "decision_journal.json"
VALID_ACTIONS = {"buy", "sell", "hold"}


class DecisionJournalError(ValueError):
    pass


class DecisionJournalStore:
    def __init__(
        self,
        path: str | Path = DEFAULT_JOURNAL_PATH,
        registry_store: EARegistryStore | None = None,
    ) -> None:
        self.path = Path(path)
        self.registry_store = registry_store or EARegistryStore()

    def record_decision(self, payload: dict[str, Any]) -> dict[str, Any]:
        item = self._normalize(payload)
        journal = self._read()
        item["decision_id"] = f"DJ-{uuid.uuid4().hex[:12]}"
        item["created_at"] = _now_iso()
        journal["decisions"].append(item)
        journal["updated_at"] = item["created_at"]
        self._write(journal)
        return dict(item)

    def list_decisions(self, ea_id: str | None = None) -> list[dict[str, Any]]:
        decisions = self._read()["decisions"]
        if ea_id:
            decisions = [item for item in decisions if item.get("ea_id") == ea_id]
        return [dict(item) for item in decisions]

    def summarize(self, ea_id: str | None = None) -> dict[str, Any]:
        decisions = self.list_decisions(ea_id=ea_id)
        by_action = {action: 0 for action in ("buy", "sell", "hold")}
        veto_count = 0
        risk_rejected_count = 0
        for item in decisions:
            action = item.get("action")
            if action in by_action:
                by_action[action] += 1
            sage = item.get("sage") if isinstance(item.get("sage"), dict) else {}
            risk_gate = item.get("risk_gate") if isinstance(item.get("risk_gate"), dict) else {}
            if sage.get("veto") is True or sage.get("decision") == "veto":
                veto_count += 1
            if risk_gate.get("approved") is False or risk_gate.get("decision") == "reject":
                risk_rejected_count += 1
        return {
            "ea_id": ea_id,
            "total": len(decisions),
            "by_action": by_action,
            "veto_count": veto_count,
            "risk_rejected_count": risk_rejected_count,
        }

    def _normalize(self, payload: dict[str, Any]) -> dict[str, Any]:
        item = dict(payload)
        ea_id = str(item.get("ea_id") or "").strip()
        if not ea_id:
            raise DecisionJournalError("ea_id is required")
        if not self.registry_store.get_ea(ea_id):
            raise DecisionJournalError(f"Unknown ea_id: {ea_id}")
        action = str(item.get("action") or "").strip().lower()
        if action not in VALID_ACTIONS:
            raise DecisionJournalError("action must be buy, sell, or hold")
        item["ea_id"] = ea_id
        item["action"] = action
        item.setdefault("confidence", 0)
        item.setdefault("reason", "")
        item.setdefault("symbol", "")
        item.setdefault("timeframe", "")
        item.setdefault("sl", None)
        item.setdefault("tp", None)
        item.setdefault("hawk", {})
        item.setdefault("sage", {})
        item.setdefault("risk_gate", {})
        item.setdefault("blade", {"mode": "dry_run"})
        return item

    def _read(self) -> dict[str, Any]:
        if not self.path.exists():
            return {"version": 1, "updated_at": None, "decisions": []}
        data = json.loads(self.path.read_text(encoding="utf-8-sig"))
        decisions = data.get("decisions")
        if not isinstance(decisions, list):
            raise DecisionJournalError("Invalid decision journal: decisions must be a list")
        data.setdefault("version", 1)
        data.setdefault("updated_at", None)
        return data

    def _write(self, journal: dict[str, Any]) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        tmp = self.path.with_suffix(".tmp")
        tmp.write_text(json.dumps(journal, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
        tmp.replace(self.path)


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")
