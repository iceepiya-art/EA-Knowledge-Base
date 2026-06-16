"""Concept Deduplicator — merges near-duplicate concept names in knowledge_index.

Problem: LLM extraction creates variants like:
  "BOS" / "BOS (Break of Structure)" / "Break of Structure (BOS)"
  "FVG" / "FVG (Fair Value Gap)"
  "CHoCH" / "CHoCH (Change of Character)"

Strategy:
  1. Detect pairs where one name is a parenthetical expansion of another
  2. Group into clusters via union-find
  3. Pick canonical = highest evidence_count (shortest name if tied)
  4. Merge cluster into canonical: sum evidence, union sources/rule_types, max confidence
  5. Return updated knowledge_index + name_map {old_name: canonical}

Also updates structured_extractions so concept arrays use canonical names.
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any

TH_TZ = timezone(timedelta(hours=7))

DEFAULT_INDEX_PATH      = Path(__file__).with_name("knowledge_index.json")
DEFAULT_STRUCTURED_PATH = Path(__file__).with_name("structured_extractions.json")


def _now_iso() -> str:
    return datetime.now(TH_TZ).isoformat(timespec="seconds")


def _normalize(s: str) -> str:
    return s.strip().lower()


def _is_abbrev_of(short: str, phrase: str) -> bool:
    """True if short is an initialism of the words in phrase.

    E.g. 'BOS' is an initialism of 'Break of Structure' (B-o-S).
    'BOS' is NOT an initialism of 'Order Block' (O-B → 2 letters, not 3).
    """
    words = [w for w in phrase.strip().split() if w]
    initials = [w[0].lower() for w in words]
    chars = list(short.strip().lower())
    return chars == initials


def _base_and_paren(name: str) -> tuple[str, str | None]:
    """Split 'FVG (Fair Value Gap)' → ('FVG', 'Fair Value Gap')."""
    m = re.match(r"^(.+?)\s*\((.+?)\)\s*$", name.strip())
    if m:
        return m.group(1).strip(), m.group(2).strip()
    return name.strip(), None


def _are_duplicates(a: str, b: str) -> bool:
    """True if a and b are the same concept written differently.

    Detects:
      'X' vs 'X (expansion)'
      'X (expansion)' vs 'expansion (X)'
    Does NOT match partial-word overlaps like 'Expansion' vs 'Expansion and Retracement'.
    Does NOT match 'Order Block (BOS)' vs 'BOS' because BOS is not an initialism of 'Order Block'.
    """
    a_base, a_paren = _base_and_paren(a)
    b_base, b_paren = _base_and_paren(b)

    an = _normalize(a_base)
    bn = _normalize(b_base)
    apn = _normalize(a_paren) if a_paren else None
    bpn = _normalize(b_paren) if b_paren else None

    # "X" vs "X (Y)"  →  base of expanded == plain name
    if an == bn:
        return True
    # "X" vs "X (Y)"  →  plain name matches base of expanded
    if apn is None and bpn is not None and an == bn:
        return True
    if bpn is None and apn is not None and an == bn:
        return True
    # "X (Y)" vs "X"  →  base of expanded == plain name
    if apn is None and _normalize(a) == bn:
        return True
    if bpn is None and _normalize(b) == an:
        return True
    # "Full Name (ABBREV)" vs "ABBREV"  →  parenthetical matches plain name
    # Guard: the paren must actually be an abbreviation of the base (e.g. BOS IS
    # an initialism of "Break of Structure", but NOT of "Order Block").
    if apn is not None and bpn is None and apn == _normalize(b):
        if _is_abbrev_of(b, a_base) or _is_abbrev_of(a_base, b):
            return True
    if bpn is not None and apn is None and bpn == _normalize(a):
        if _is_abbrev_of(a, b_base) or _is_abbrev_of(b_base, a):
            return True
    # "X (Y)" vs "Y (X)"  →  cross match
    if apn is not None and bpn is not None:
        # Perfect symmetric swap: "BOS (Break of Structure)" vs "Break of Structure (BOS)"
        if an == bpn and bn == apn:
            return True
        # Partial cross: "ABBREV (Full)" vs "Full (something)" — guard with abbreviation check
        # to avoid "BOS (Break of Structure)" vs "Order Block (BOS)" false positive.
        if an == bpn and _is_abbrev_of(a_base, b_base):
            return True
        if bn == apn and _is_abbrev_of(b_base, a_base):
            return True
    # "X" vs "X (Y)"  →  a equals b_base
    if apn is None and bpn is not None and _normalize(a) == bn:
        return True
    if bpn is None and apn is not None and _normalize(b) == an:
        return True

    return False


# ---------------------------------------------------------------------------
# Union-Find
# ---------------------------------------------------------------------------

def _find(parent: dict[str, str], x: str) -> str:
    while parent[x] != x:
        parent[x] = parent[parent[x]]
        x = parent[x]
    return x


def _union(parent: dict[str, str], x: str, y: str) -> None:
    rx, ry = _find(parent, x), _find(parent, y)
    if rx != ry:
        parent[ry] = rx


def find_duplicate_groups(concepts: dict[str, Any]) -> list[list[str]]:
    """Return list of groups (each ≥2 names) that are duplicates of each other."""
    names = list(concepts.keys())
    parent = {n: n for n in names}

    for i, a in enumerate(names):
        for b in names[i + 1:]:
            if _are_duplicates(a, b):
                _union(parent, a, b)

    clusters: dict[str, list[str]] = {}
    for n in names:
        root = _find(parent, n)
        clusters.setdefault(root, []).append(n)

    return [g for g in clusters.values() if len(g) >= 2]


# ---------------------------------------------------------------------------
# Merge
# ---------------------------------------------------------------------------

def _pick_canonical(concepts: dict[str, Any], group: list[str]) -> str:
    """Pick the best name: highest evidence_count, then shortest name."""
    return max(
        group,
        key=lambda n: (concepts[n].get("evidence_count", 0), -len(n)),
    )


def merge_concept_group(concepts: dict[str, Any], group: list[str]) -> dict[str, Any]:
    """Merge a group of duplicate concepts into one canonical entry."""
    canonical_name = _pick_canonical(concepts, group)
    entries = [concepts[n] for n in group]

    merged_sources = list({s for e in entries for s in e.get("sources", [])})
    merged_rule_types = list({rt for e in entries for rt in e.get("related_rule_types", [])})
    merged_evidence = sum(e.get("evidence_count", 0) for e in entries)
    merged_confidence = max(e.get("confidence", 0) for e in entries)

    return {
        "concept": canonical_name,
        "confidence": merged_confidence,
        "evidence_count": merged_evidence,
        "sources": merged_sources,
        "related_rule_types": merged_rule_types,
        "source_details": [],
        "last_updated": _now_iso(),
    }


# ---------------------------------------------------------------------------
# Public API
# ---------------------------------------------------------------------------

def deduplicate_knowledge_index(
    knowledge_index: dict[str, Any],
) -> tuple[dict[str, Any], dict[str, str]]:
    """Return (new_index, name_map) where name_map maps every old name → canonical.

    Concepts that are not part of any duplicate group map to themselves.
    """
    concepts = knowledge_index.get("concepts", {})
    groups = find_duplicate_groups(concepts)

    # Build name_map: old_name → canonical
    name_map: dict[str, str] = {n: n for n in concepts}
    new_concepts: dict[str, Any] = dict(concepts)

    for group in groups:
        merged = merge_concept_group(concepts, group)
        canonical = merged["concept"]
        for n in group:
            name_map[n] = canonical
            if n != canonical:
                del new_concepts[n]
        new_concepts[canonical] = merged

    new_index = {**knowledge_index, "concepts": new_concepts}
    return new_index, name_map


def deduplicate_structured_extractions(
    structured: dict[str, Any],
    name_map: dict[str, str],
) -> dict[str, Any]:
    """Replace non-canonical concept names in all structured extraction items."""
    new_items: dict[str, Any] = {}
    for vid, item in structured.get("items", {}).items():
        old_concepts = item.get("concepts") or []
        # map and deduplicate
        seen: list[str] = []
        for c in old_concepts:
            canonical = name_map.get(c, c)
            if canonical not in seen:
                seen.append(canonical)
        new_items[vid] = {**item, "concepts": seen}
    return {**structured, "items": new_items}


def run_deduplication(
    index_path: str | Path = DEFAULT_INDEX_PATH,
    structured_path: str | Path = DEFAULT_STRUCTURED_PATH,
) -> dict[str, Any]:
    """Run deduplication in-place on both files. Returns summary."""
    index_path = Path(index_path)
    structured_path = Path(structured_path)

    knowledge_index = json.loads(index_path.read_text(encoding="utf-8"))
    structured = json.loads(structured_path.read_text(encoding="utf-8"))

    before_count = len(knowledge_index.get("concepts", {}))
    new_index, name_map = deduplicate_knowledge_index(knowledge_index)
    new_structured = deduplicate_structured_extractions(structured, name_map)
    after_count = len(new_index.get("concepts", {}))

    merged_pairs = {k: v for k, v in name_map.items() if k != v}

    # atomic writes
    def _write(path: Path, data: dict) -> None:
        tmp = path.with_suffix(f".tmp-{datetime.now().strftime('%Y%m%d%H%M%S%f')}.json")
        tmp.write_text(json.dumps(data, ensure_ascii=False, indent=2, sort_keys=True), encoding="utf-8")
        tmp.replace(path)

    _write(index_path, new_index)
    _write(structured_path, new_structured)

    return {
        "concepts_before": before_count,
        "concepts_after": after_count,
        "merged": merged_pairs,
        "removed": before_count - after_count,
    }


def main(argv: list[str] | None = None) -> int:
    if hasattr(sys.stdout, "reconfigure"):
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
    parser = argparse.ArgumentParser(description="Concept Deduplicator")
    parser.add_argument("--index",      default=str(DEFAULT_INDEX_PATH))
    parser.add_argument("--structured", default=str(DEFAULT_STRUCTURED_PATH))
    parser.add_argument("--dry-run",    action="store_true",
                        help="Print what would be merged without writing files")
    args = parser.parse_args(argv)

    index = json.loads(Path(args.index).read_text(encoding="utf-8"))
    groups = find_duplicate_groups(index.get("concepts", {}))

    if args.dry_run:
        print(json.dumps([sorted(g) for g in groups], ensure_ascii=False, indent=2))
        return 0

    result = run_deduplication(args.index, args.structured)
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    sys.exit(main())
