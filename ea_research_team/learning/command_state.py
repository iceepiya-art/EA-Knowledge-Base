from __future__ import annotations

import json
import uuid
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any

from ea_registry import EARegistryStore


TH_TZ = timezone(timedelta(hours=7))
DEFAULT_COMMAND_STATE_PATH = Path(__file__).resolve().parent / ".server_manager" / "command_state.json"
VALID_SCOPES = {"global", "group", "ea"}
VALID_COMMANDS = {"start", "stop", "step", "close", "kill", "resume"}


class CommandStateError(ValueError):
    pass


class CommandStateStore:
    def __init__(
        self,
        path: str | Path = DEFAULT_COMMAND_STATE_PATH,
        registry_store: EARegistryStore | None = None,
    ) -> None:
        self.path = Path(path)
        self.registry_store = registry_store

    def state(self) -> dict[str, Any]:
        return self._read()

    def dispatch(self, payload: dict[str, Any]) -> dict[str, Any]:
        state = self._read()
        scope = str(payload.get("scope") or "").strip().lower()
        command = str(payload.get("command") or "").strip().lower()
        reason = str(payload.get("reason") or "").strip()

        if scope not in VALID_SCOPES:
            raise CommandStateError("scope must be global, group, or ea")
        if command not in VALID_COMMANDS:
            raise CommandStateError("command must be start, stop, step, close, kill, or resume")

        target = self._target(scope, payload)
        entry = self._target_state(state, target)
        self._apply_command(entry, command, reason)

        command_record = {
            "command_id": f"CMD-{uuid.uuid4().hex[:12]}",
            "scope": scope,
            "command": command,
            "reason": reason,
            "target": target,
            "execution": "state_only",
            "created_at": _now_iso(),
        }
        state["commands"].insert(0, command_record)
        state["commands"] = state["commands"][:100]
        self._write(state)
        return {"accepted": True, **command_record}

    def evaluate_decision(self, payload: dict[str, Any]) -> dict[str, Any]:
        state = self._read()
        ea_id = str(payload.get("ea_id") or "").strip()
        if not ea_id:
            raise CommandStateError("ea_id is required")
        if self.registry_store and not self.registry_store.get_ea(ea_id):
            raise CommandStateError(f"Unknown ea_id: {ea_id}")
        group_id = str(payload.get("group_id") or "").strip()
        if not group_id and self.registry_store:
            ea = self.registry_store.get_ea(ea_id) or {}
            group_id = str(ea.get("strategy_family") or "").strip()

        reasons: list[str] = []
        global_state = state["global"]
        ea_state = state["eas"].get(ea_id, {})
        group_state = state["groups"].get(group_id, {}) if group_id else {}

        if global_state.get("kill") is True:
            reasons.append("global_kill")
        if global_state.get("mode") == "stopped" and global_state.get("last_command") == "stop":
            reasons.append("global_stopped")
        if group_state.get("kill") is True:
            reasons.append("group_kill")
        if group_state.get("mode") == "stopped" and group_state.get("last_command") == "stop":
            reasons.append("group_stopped")
        if ea_state.get("kill") is True:
            reasons.append("ea_kill")
        if ea_state.get("mode") == "stopped" and ea_state.get("last_command") == "stop":
            reasons.append("ea_stopped")
        if ea_state.get("close_requested") is True:
            reasons.append("close_requested")

        return {
            "allowed": not reasons,
            "decision": "allow" if not reasons else "block",
            "ea_id": ea_id,
            "group_id": group_id,
            "reasons": reasons,
            "evaluated_at": _now_iso(),
        }

    def _target(self, scope: str, payload: dict[str, Any]) -> dict[str, str]:
        if scope == "global":
            return {"scope": "global"}
        if scope == "group":
            group_id = str(payload.get("group_id") or payload.get("group") or "").strip()
            if not group_id:
                raise CommandStateError("group_id is required")
            return {"scope": "group", "group_id": group_id}
        ea_id = str(payload.get("ea_id") or "").strip()
        if not ea_id:
            raise CommandStateError("ea_id is required")
        if self.registry_store and not self.registry_store.get_ea(ea_id):
            raise CommandStateError(f"Unknown ea_id: {ea_id}")
        return {"scope": "ea", "ea_id": ea_id}

    def _target_state(self, state: dict[str, Any], target: dict[str, str]) -> dict[str, Any]:
        scope = target["scope"]
        if scope == "global":
            return state["global"]
        if scope == "group":
            return state["groups"].setdefault(target["group_id"], _default_target_state())
        return state["eas"].setdefault(target["ea_id"], _default_target_state())

    def _apply_command(self, entry: dict[str, Any], command: str, reason: str) -> None:
        if command == "start":
            entry["mode"] = "running"
            entry["kill"] = False
            entry["close_requested"] = False
        elif command == "stop":
            entry["mode"] = "stopped"
        elif command == "step":
            entry["mode"] = "step"
            entry["kill"] = False
            entry["close_requested"] = False
        elif command == "close":
            entry["mode"] = "closing"
            entry["close_requested"] = True
        elif command == "kill":
            entry["mode"] = "stopped"
            entry["kill"] = True
        elif command == "resume":
            entry["mode"] = "running"
            entry["kill"] = False
            entry["close_requested"] = False
        entry["reason"] = reason
        entry["last_command"] = command
        entry["updated_at"] = _now_iso()

    def _read(self) -> dict[str, Any]:
        if not self.path.exists():
            return _default_state()
        data = json.loads(self.path.read_text(encoding="utf-8-sig"))
        data.setdefault("version", 1)
        data.setdefault("updated_at", None)
        data.setdefault("global", _default_global_state())
        data.setdefault("groups", {})
        data.setdefault("eas", {})
        data.setdefault("commands", [])
        data["global"] = {**_default_global_state(), **data["global"]}
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
        "global": _default_global_state(),
        "groups": {},
        "eas": {},
        "commands": [],
    }


def _default_global_state() -> dict[str, Any]:
    return {"mode": "stopped", "kill": False, "reason": "", "last_command": None, "updated_at": None}


def _default_target_state() -> dict[str, Any]:
    return {
        "mode": "running",
        "kill": False,
        "close_requested": False,
        "reason": "",
        "last_command": None,
        "updated_at": None,
    }


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")
