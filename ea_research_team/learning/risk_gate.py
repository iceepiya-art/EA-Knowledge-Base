from __future__ import annotations

import json
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any

from ea_registry import EARegistryStore


TH_TZ = timezone(timedelta(hours=7))
DEFAULT_RISK_GATE_PATH = Path(__file__).resolve().parent / ".server_manager" / "risk_gate.json"
DEFAULT_LIMITS = {
    "max_lot": 0.01,
    "max_positions_per_ea": 3,
    "max_total_exposure": 0.10,
    "daily_loss_limit": 100.0,
}


class RiskGateError(ValueError):
    pass


class RiskGateStore:
    def __init__(
        self,
        path: str | Path = DEFAULT_RISK_GATE_PATH,
        registry_store: EARegistryStore | None = None,
    ) -> None:
        self.path = Path(path)
        self.registry_store = registry_store

    def state(self) -> dict[str, Any]:
        return self._read()

    def evaluate(self, payload: dict[str, Any]) -> dict[str, Any]:
        state = self._read()
        limits = state["limits"]
        ea_id = str(payload.get("ea_id") or "").strip()
        if not ea_id:
            raise RiskGateError("ea_id is required")
        if self.registry_store and not self.registry_store.get_ea(ea_id):
            raise RiskGateError(f"Unknown ea_id: {ea_id}")

        requested_lot = _float(payload.get("requested_lot"), "requested_lot")
        open_positions = payload.get("open_positions") or []
        if not isinstance(open_positions, list):
            raise RiskGateError("open_positions must be a list")
        daily_pnl = _float(payload.get("daily_pnl", 0), "daily_pnl")

        reasons: list[str] = []
        if state["global_kill"]["enabled"]:
            reasons.append("global_kill")
        if ea_id in state["ea_kills"]:
            reasons.append("ea_kill")
        if requested_lot > float(limits["max_lot"]):
            reasons.append("lot_cap")

        ea_positions = [pos for pos in open_positions if pos.get("ea_id") == ea_id]
        if len(ea_positions) >= int(limits["max_positions_per_ea"]):
            reasons.append("max_positions_per_ea")

        current_exposure = sum(_float(pos.get("lot", 0), "position.lot") for pos in open_positions)
        projected_exposure = current_exposure + requested_lot
        if projected_exposure > float(limits["max_total_exposure"]):
            reasons.append("max_total_exposure")

        if daily_pnl <= -float(limits["daily_loss_limit"]):
            reasons.append("daily_loss_limit")

        approved = not reasons
        return {
            "approved": approved,
            "decision": "approve" if approved else "reject",
            "ea_id": ea_id,
            "requested_lot": requested_lot,
            "current_exposure": current_exposure,
            "projected_exposure": projected_exposure,
            "reasons": reasons,
            "limits": dict(limits),
            "evaluated_at": _now_iso(),
        }

    def kill_global(self, reason: str = "") -> dict[str, Any]:
        state = self._read()
        state["global_kill"] = {"enabled": True, "reason": reason, "updated_at": _now_iso()}
        self._write(state)
        return state

    def resume_global(self) -> dict[str, Any]:
        state = self._read()
        state["global_kill"] = {"enabled": False, "reason": "", "updated_at": _now_iso()}
        self._write(state)
        return state

    def kill_ea(self, ea_id: str, reason: str = "") -> dict[str, Any]:
        if not ea_id:
            raise RiskGateError("ea_id is required")
        state = self._read()
        state["ea_kills"][ea_id] = {"reason": reason, "updated_at": _now_iso()}
        self._write(state)
        return state

    def resume_ea(self, ea_id: str) -> dict[str, Any]:
        if not ea_id:
            raise RiskGateError("ea_id is required")
        state = self._read()
        state["ea_kills"].pop(ea_id, None)
        self._write(state)
        return state

    def _read(self) -> dict[str, Any]:
        if not self.path.exists():
            return _default_state()
        data = json.loads(self.path.read_text(encoding="utf-8-sig"))
        data.setdefault("version", 1)
        data.setdefault("limits", dict(DEFAULT_LIMITS))
        data.setdefault("global_kill", {"enabled": False, "reason": "", "updated_at": None})
        data.setdefault("ea_kills", {})
        data["limits"] = {**DEFAULT_LIMITS, **data["limits"]}
        return data

    def _write(self, state: dict[str, Any]) -> None:
        state["updated_at"] = _now_iso()
        self.path.parent.mkdir(parents=True, exist_ok=True)
        tmp = self.path.with_suffix(".tmp")
        tmp.write_text(json.dumps(state, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
        tmp.replace(self.path)


def _default_state() -> dict[str, Any]:
    return {
        "version": 1,
        "updated_at": None,
        "limits": dict(DEFAULT_LIMITS),
        "global_kill": {"enabled": False, "reason": "", "updated_at": None},
        "ea_kills": {},
    }


def _float(value: Any, field: str) -> float:
    try:
        return float(value)
    except (TypeError, ValueError) as exc:
        raise RiskGateError(f"{field} must be numeric") from exc


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")
