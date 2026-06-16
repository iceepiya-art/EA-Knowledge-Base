from __future__ import annotations

import csv
from pathlib import Path
from typing import Any


DEFAULT_TRADE_RECORDS_PATH = Path(__file__).resolve().parents[2] / "trades_log.csv"

EA_ID_FIELDS = ("ea_id", "ea", "agent_id", "strategy_id")
MAGIC_FIELDS = ("magic", "magic_number", "magicnumber", "expert_id")
PNL_FIELDS = ("pnl", "profit", "net_profit", "netpnl", "pl")


class TradeRecordReader:
    def __init__(self, path: str | Path = DEFAULT_TRADE_RECORDS_PATH) -> None:
        self.path = Path(path)

    def list_records(
        self,
        *,
        ea_id: str | None = None,
        magic_number: int | str | None = None,
    ) -> list[dict[str, Any]]:
        if not self.path.exists():
            return []
        rows = self._read_rows()
        return [row for row in rows if self._matches(row, ea_id=ea_id, magic_number=magic_number)]

    def summarize(
        self,
        *,
        ea_id: str | None = None,
        magic_number: int | str | None = None,
    ) -> dict[str, Any]:
        if not self.path.exists():
            return _empty_summary(source="not_connected")

        records = self.list_records(ea_id=ea_id, magic_number=magic_number)
        pnls = [_to_float(row.get("pnl")) for row in records]
        pnls = [value for value in pnls if value is not None]
        wins = sum(1 for value in pnls if value > 0)
        losses = sum(1 for value in pnls if value < 0)
        total = len(pnls)
        return {
            "source": "csv",
            "total_trades": total,
            "wins": wins,
            "losses": losses,
            "win_rate": round((wins / total) * 100, 2) if total else None,
            "net_pnl": round(sum(pnls), 2) if total else None,
        }

    def _read_rows(self) -> list[dict[str, Any]]:
        with self.path.open("r", encoding="utf-8-sig", newline="") as handle:
            reader = csv.DictReader(handle)
            rows = []
            for raw in reader:
                row = {_normalize_key(key): value for key, value in raw.items() if key is not None}
                rows.append(_canonicalize(row))
            return rows

    def _matches(
        self,
        row: dict[str, Any],
        *,
        ea_id: str | None,
        magic_number: int | str | None,
    ) -> bool:
        row_ea_id = str(row.get("ea_id") or "").strip()
        if ea_id and row_ea_id and row_ea_id != str(ea_id):
            return False

        row_magic = str(row.get("magic_number") or "").strip()
        requested_magic = str(magic_number or "").strip()
        if requested_magic and row_magic and row_magic != requested_magic:
            return False

        return True


def _canonicalize(row: dict[str, Any]) -> dict[str, Any]:
    canonical = dict(row)
    canonical["ea_id"] = _first_value(row, EA_ID_FIELDS)
    canonical["magic_number"] = _first_value(row, MAGIC_FIELDS)
    canonical["pnl"] = _first_value(row, PNL_FIELDS)
    return canonical


def _first_value(row: dict[str, Any], keys: tuple[str, ...]) -> Any:
    for key in keys:
        value = row.get(key)
        if value not in (None, ""):
            return value
    return None


def _normalize_key(value: str) -> str:
    return value.strip().lower().replace(" ", "_").replace("-", "_")


def _to_float(value: Any) -> float | None:
    if value in (None, ""):
        return None
    try:
        return float(str(value).replace(",", "").strip())
    except ValueError:
        return None


def _empty_summary(*, source: str) -> dict[str, Any]:
    return {
        "source": source,
        "total_trades": 0,
        "wins": 0,
        "losses": 0,
        "win_rate": None,
        "net_pnl": None,
    }
