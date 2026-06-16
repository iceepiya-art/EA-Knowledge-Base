"""
Atom Store — เก็บ atomic insights ใน atoms.json
+ ตรวจ contradiction กับ atoms เดิม
"""
import json
import os
import re
from datetime import datetime

ATOM_FILE = os.path.join(os.path.dirname(__file__), "atoms.json")


def _load() -> list[dict]:
    if not os.path.exists(ATOM_FILE):
        return []
    with open(ATOM_FILE, "r", encoding="utf-8") as f:
        return json.load(f)


def _save(atoms: list[dict]):
    with open(ATOM_FILE, "w", encoding="utf-8") as f:
        json.dump(atoms, f, ensure_ascii=False, indent=2)


def add_atoms(new_atoms: list[dict]) -> tuple[int, list[str]]:
    """
    เพิ่ม atoms ใหม่
    คืน (จำนวนที่เพิ่ม, รายการที่อาจ contradict)
    """
    atoms    = _load()
    warnings = []
    added    = 0
    date     = datetime.now().strftime("%Y-%m-%d")

    for atom in new_atoms:
        atom["id"]         = f"atom_{len(atoms)+1:04d}"
        atom["created_at"] = date

        # เช็ค contradiction แบบง่าย (keyword overlap)
        conflict = _find_conflict(atom, atoms)
        if conflict:
            atom["contradicts"] = conflict["id"]
            warnings.append(
                f"⚠️ '{atom['insight'][:50]}' อาจขัดแย้งกับ [{conflict['id']}] '{conflict['insight'][:50]}'"
            )

        atoms.append(atom)
        added += 1

    _save(atoms)
    return added, warnings


def _find_conflict(new_atom: dict, existing: list[dict]) -> dict | None:
    """หา atom เดิมที่อาจขัดแย้ง (same topic + opposite keywords)"""
    OPPOSITE_PAIRS = [
        ("increase", "decrease"), ("higher", "lower"),
        ("bullish", "bearish"), ("buy", "sell"),
        ("เพิ่ม", "ลด"), ("ดี", "แย่"), ("ควร", "ไม่ควร"),
    ]
    new_text  = new_atom.get("insight", "").lower()
    new_topic = new_atom.get("topic", "").lower()

    for atom in existing[-50:]:  # ตรวจแค่ 50 atoms ล่าสุด
        if atom.get("topic", "").lower() != new_topic:
            continue
        old_text = atom.get("insight", "").lower()
        for w1, w2 in OPPOSITE_PAIRS:
            if (w1 in new_text and w2 in old_text) or (w2 in new_text and w1 in old_text):
                return atom
    return None


def get_atoms_by_topic(topic: str) -> list[dict]:
    atoms = _load()
    return [a for a in atoms if topic.lower() in a.get("topic", "").lower()]


def get_atoms_by_applies(target: str) -> list[dict]:
    atoms = _load()
    return [a for a in atoms if target in a.get("applies_to", [])]


def count_atoms() -> int:
    return len(_load())


def get_recent_atoms(n: int = 10) -> list[dict]:
    return _load()[-n:]
