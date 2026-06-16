from __future__ import annotations

import json
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Any


TH_TZ = timezone(timedelta(hours=7))
DEFAULT_REGISTRY_PATH = Path(__file__).resolve().parent / ".server_manager" / "ea_registry.json"

REQUIRED_FIELDS = (
    "ea_id",
    "ea_name",
    "magic_number",
    "symbol",
    "timeframe",
    "terminal_id",
    "account_id",
)


class EARegistryError(ValueError):
    pass


class EARegistryStore:
    def __init__(self, path: str | Path = DEFAULT_REGISTRY_PATH) -> None:
        self.path = Path(path)

    def register_ea(self, payload: dict[str, Any]) -> dict[str, Any]:
        item = self._normalize(payload)
        registry = self._read()
        eas = registry["eas"]
        ea_id = item["ea_id"]
        if ea_id in eas:
            raise EARegistryError(f"ea_id already exists: {ea_id}")
        duplicate = self.find_by_magic_number(
            terminal_id=item["terminal_id"],
            account_id=item["account_id"],
            magic_number=item["magic_number"],
            registry=registry,
        )
        if duplicate:
            raise EARegistryError(
                "magic_number already registered for this terminal/account: "
                f"{item['magic_number']}"
            )
        now = _now_iso()
        item.setdefault("ea_version", "")
        item.setdefault("strategy_family", "")
        item.setdefault("status", "stopped")
        item["created_at"] = now
        item["updated_at"] = now
        eas[ea_id] = item
        registry["updated_at"] = now
        self._write(registry)
        return dict(item)

    def get_ea(self, ea_id: str) -> dict[str, Any] | None:
        item = self._read()["eas"].get(ea_id)
        return dict(item) if item else None

    def list_eas(self) -> list[dict[str, Any]]:
        eas = self._read()["eas"]
        return [dict(eas[key]) for key in sorted(eas)]

    def find_by_magic_number(
        self,
        *,
        terminal_id: str,
        account_id: str,
        magic_number: int,
        registry: dict[str, Any] | None = None,
    ) -> dict[str, Any] | None:
        registry = registry or self._read()
        magic_number = _normalize_magic(magic_number)
        for item in registry["eas"].values():
            if (
                item.get("terminal_id") == terminal_id
                and item.get("account_id") == account_id
                and item.get("magic_number") == magic_number
            ):
                return dict(item)
        return None

    def _normalize(self, payload: dict[str, Any]) -> dict[str, Any]:
        item = dict(payload)
        missing = [field for field in REQUIRED_FIELDS if item.get(field) in (None, "")]
        if missing:
            raise EARegistryError(f"Missing required EA identity field: {missing[0]}")
        item["ea_id"] = str(item["ea_id"])
        item["ea_name"] = str(item["ea_name"])
        item["magic_number"] = _normalize_magic(item["magic_number"])
        item["symbol"] = str(item["symbol"])
        item["timeframe"] = str(item["timeframe"])
        item["terminal_id"] = str(item["terminal_id"])
        item["account_id"] = str(item["account_id"])
        return item

    def _read(self) -> dict[str, Any]:
        if not self.path.exists():
            return {"version": 1, "updated_at": None, "eas": {}}
        data = json.loads(self.path.read_text(encoding="utf-8-sig"))
        eas = data.get("eas")
        if not isinstance(eas, dict):
            raise EARegistryError("Invalid EA registry: eas must be an object")
        data.setdefault("version", 1)
        data.setdefault("updated_at", None)
        return data

    def _write(self, registry: dict[str, Any]) -> None:
        self.path.parent.mkdir(parents=True, exist_ok=True)
        tmp = self.path.with_suffix(".tmp")
        tmp.write_text(json.dumps(registry, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
        tmp.replace(self.path)


def _normalize_magic(value: Any) -> int:
    try:
        return int(value)
    except (TypeError, ValueError) as exc:
        raise EARegistryError("magic_number must be an integer") from exc


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")

