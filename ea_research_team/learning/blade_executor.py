from __future__ import annotations

import json
import uuid
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any

from command_state import CommandStateStore
from ea_registry import EARegistryStore


TH_TZ = timezone(timedelta(hours=7))
DEFAULT_BLADE_INTENTS_PATH = Path(__file__).resolve().parent / ".server_manager" / "blade_execution_intents.json"
VALID_ACTIONS = {"buy", "sell"}


class BladeExecutionError(ValueError):
    pass


class BladeDryRunExecutor:
    def __init__(
        self,
        path: str | Path = DEFAULT_BLADE_INTENTS_PATH,
        registry_store: EARegistryStore | None = None,
        command_state_store: CommandStateStore | None = None,
    ) -> None:
        self.path = Path(path)
        self.registry_store = registry_store or EARegistryStore()
        self.command_state_store = command_state_store or CommandStateStore(
            registry_store=self.registry_store,
        )

    def create_intent(self, payload: dict[str, Any]) -> dict[str, Any]:
        item = self._normalize(payload)
        return self._append_intent(item)

    def _append_intent(self, item: dict[str, Any]) -> dict[str, Any]:
        state = self._read()
        item["intent_id"] = f"BLADE-{uuid.uuid4().hex[:12]}"
        item["created_at"] = _now_iso()
        state["intents"].append(item)
        state["updated_at"] = item["created_at"]
        self._write(state)
        return dict(item)

    def list_intents(self, ea_id: str | None = None) -> list[dict[str, Any]]:
        intents = self._read()["intents"]
        if ea_id:
            intents = [item for item in intents if item.get("ea_id") == ea_id]
        return [dict(item) for item in intents]

    def _normalize(self, payload: dict[str, Any]) -> dict[str, Any]:
        ea_id = str(payload.get("ea_id") or "").strip()
        if not ea_id:
            raise BladeExecutionError("ea_id is required")
        ea = self.registry_store.get_ea(ea_id)
        if not ea:
            raise BladeExecutionError(f"Unknown ea_id: {ea_id}")

        action = str(payload.get("action") or "").strip().lower()
        if action not in VALID_ACTIONS:
            raise BladeExecutionError("action must be buy or sell for BLADE dry-run execution")

        risk_gate = payload.get("risk_gate") if isinstance(payload.get("risk_gate"), dict) else {}
        if risk_gate.get("approved") is not True:
            self._append_intent(
                self._intent_payload(
                    payload,
                    ea,
                    action=action,
                    risk_gate=risk_gate,
                    status="rejected",
                    rejection_reason="risk_gate_not_approved",
                    command_state=None,
                )
            )
            raise BladeExecutionError("Risk Gate approval is required before BLADE dry-run")

        command_check = self.command_state_store.evaluate_decision({"ea_id": ea_id})
        if command_check.get("allowed") is not True:
            self._append_intent(
                self._intent_payload(
                    payload,
                    ea,
                    action=action,
                    risk_gate=risk_gate,
                    status="blocked",
                    rejection_reason="command_state_blocked",
                    command_state=command_check,
                )
            )
            reasons = ", ".join(command_check.get("reasons") or [])
            raise BladeExecutionError(f"Command State blocked BLADE dry-run: {reasons}")

        return self._intent_payload(
            payload,
            ea,
            action=action,
            risk_gate=risk_gate,
            status="intent_logged",
            rejection_reason=None,
            command_state=command_check,
        )

    def _intent_payload(
        self,
        payload: dict[str, Any],
        ea: dict[str, Any],
        *,
        action: str,
        risk_gate: dict[str, Any],
        status: str,
        rejection_reason: str | None,
        command_state: dict[str, Any] | None,
    ) -> dict[str, Any]:
        ea_id = str(payload.get("ea_id") or "").strip()
        item = {
            "mode": "dry_run",
            "status": status,
            "order_send": False,
            "ea_id": ea_id,
            "decision_id": str(payload.get("decision_id") or ""),
            "action": action,
            "lot": _float(payload.get("lot", 0), "lot"),
            "symbol": str(payload.get("symbol") or ea.get("symbol") or ""),
            "timeframe": str(payload.get("timeframe") or ea.get("timeframe") or ""),
            "sl": payload.get("sl"),
            "tp": payload.get("tp"),
            "risk_gate": dict(risk_gate),
            "command_state": command_state,
            "execution_note": "Dry-run intent only. No MT5 order_send was called.",
        }
        if rejection_reason:
            item["rejection_reason"] = rejection_reason
        return item

    def _read(self) -> dict[str, Any]:
        if not self.path.exists():
            return {"version": 1, "updated_at": None, "intents": []}
        data = json.loads(self.path.read_text(encoding="utf-8-sig"))
        intents = data.get("intents")
        if not isinstance(intents, list):
            raise BladeExecutionError("Invalid BLADE intent log: intents must be a list")
        data.setdefault("version", 1)
        data.setdefault("updated_at", None)
        return data

    def _write(self, state: dict[str, Any]) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        tmp = self.path.with_suffix(".tmp")
        tmp.write_text(json.dumps(state, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
        tmp.replace(self.path)


def _float(value: Any, field: str) -> float:
    try:
        return float(value)
    except (TypeError, ValueError) as exc:
        raise BladeExecutionError(f"{field} must be numeric") from exc


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")
