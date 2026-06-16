from __future__ import annotations

import argparse
import hashlib
import json
import re
import sqlite3
import sys
from pathlib import Path
from typing import Any

from knowledge_merger import DEFAULT_INDEX_PATH
from local_evidence_intake import DEFAULT_LOCAL_RAW_DIR


PROJECT_ROOT = Path(__file__).parents[2]
DEFAULT_DB_PATH = PROJECT_ROOT / "DATA" / "processed" / "trades.sqlite"
STATUS_TABLES = (
    "research_inbox",
    "research_actions",
    "knowledge_nodes",
    "knowledge_relationships",
    "evidence_links",
    "reasoning_paths",
)
REQUIRED_KNOWLEDGE_NODE_COLUMNS = {
    "node_id",
    "node_type",
    "title",
    "description",
    "source_id",
    "source_table",
    "tags",
    "confidence",
    "status",
    "obsidian_path",
    "updated_at",
}
REQUIRED_EVIDENCE_LINK_COLUMNS = {
    "evidence_id",
    "rel_id",
    "node_id",
    "evidence_type",
    "title",
    "description",
    "sample_n",
    "result_metric",
    "supports",
    "confidence",
    "source_ref",
}
REQUIRED_KNOWLEDGE_RELATIONSHIP_COLUMNS = {
    "rel_id",
    "from_node_id",
    "to_node_id",
    "rel_type",
    "strength",
    "rationale",
    "evidence_count",
    "is_bidirectional",
    "created_by",
    "validation_status",
    "source_ref",
    "principle_ref",
    "hypothesis_ref",
}
SYNC_COLUMNS = (
    "node_id",
    "node_type",
    "title",
    "description",
    "source_id",
    "source_table",
    "tags",
    "confidence",
    "status",
    "obsidian_path",
)
EVIDENCE_SYNC_COLUMNS = (
    "evidence_id",
    "rel_id",
    "node_id",
    "evidence_type",
    "title",
    "description",
    "sample_n",
    "result_metric",
    "supports",
    "confidence",
    "source_ref",
)
RELATIONSHIP_SYNC_COLUMNS = (
    "rel_id",
    "from_node_id",
    "to_node_id",
    "rel_type",
    "strength",
    "rationale",
    "evidence_count",
    "is_bidirectional",
    "created_by",
    "validation_status",
    "source_ref",
    "principle_ref",
    "hypothesis_ref",
)


def _emit_json(data: dict[str, Any]) -> None:
    text = json.dumps(data, ensure_ascii=False, indent=2)
    try:
        sys.stdout.write(text + "\n")
    except UnicodeEncodeError:
        sys.stdout.write(json.dumps(data, ensure_ascii=True, indent=2) + "\n")


def _open_readonly(db_path: Path) -> sqlite3.Connection:
    uri = db_path.resolve().as_uri() + "?mode=ro"
    con = sqlite3.connect(uri, uri=True)
    con.row_factory = sqlite3.Row
    return con


def _table_exists(con: sqlite3.Connection, table_name: str) -> bool:
    row = con.execute(
        "SELECT 1 FROM sqlite_master WHERE type='table' AND name=?",
        (table_name,),
    ).fetchone()
    return row is not None


def _table_count(con: sqlite3.Connection, table_name: str) -> int | None:
    if not _table_exists(con, table_name):
        return None
    row = con.execute(f"SELECT COUNT(*) AS count FROM {table_name}").fetchone()
    return int(row["count"])


def _schema_version(con: sqlite3.Connection) -> str | None:
    if not _table_exists(con, "db_meta"):
        return None
    row = con.execute(
        "SELECT value FROM db_meta WHERE key='schema_version'",
    ).fetchone()
    return str(row["value"]) if row else None


def _count_raw_local_files(raw_dir: Path) -> int:
    if not raw_dir.exists():
        return 0
    return sum(1 for path in raw_dir.glob("*.md") if path.is_file())


def _count_concepts(index_path: Path) -> int:
    if not index_path.exists():
        return 0
    data = json.loads(index_path.read_text(encoding="utf-8"))
    return len(data.get("concepts", {}))


def _knowledge_node_columns(con: sqlite3.Connection) -> set[str]:
    if not _table_exists(con, "knowledge_nodes"):
        return set()
    rows = con.execute("PRAGMA table_info(knowledge_nodes)").fetchall()
    return {str(row["name"]) for row in rows}


def _table_columns(con: sqlite3.Connection, table_name: str) -> set[str]:
    if not _table_exists(con, table_name):
        return set()
    rows = con.execute(f"PRAGMA table_info({table_name})").fetchall()
    return {str(row["name"]) for row in rows}


def _concept_node_id(concept_name: str) -> str:
    normalized = re.sub(r"[^a-z0-9]+", "_", concept_name.lower()).strip("_")
    slug = normalized[:48] or "concept"
    digest = hashlib.sha1(concept_name.encode("utf-8")).hexdigest()[:10]
    return f"learning_concept:{slug}:{digest}"


def _concept_note_path(concept_name: str) -> str:
    filename = re.sub(r"[^A-Za-z0-9._-]+", "_", concept_name).strip("_")
    filename = filename or hashlib.sha1(concept_name.encode("utf-8")).hexdigest()[:12]
    return str(PROJECT_ROOT / "concepts" / f"{filename}.md")


def _load_concepts(index_path: Path) -> dict[str, dict[str, Any]]:
    if not index_path.exists():
        return {}
    data = json.loads(index_path.read_text(encoding="utf-8"))
    concepts = data.get("concepts", {})
    if not isinstance(concepts, dict):
        return {}
    return {
        str(name): value if isinstance(value, dict) else {"concept": str(name)}
        for name, value in concepts.items()
    }


def _build_concept_payload(concept_name: str, concept_data: dict[str, Any]) -> dict[str, Any]:
    evidence_count = int(concept_data.get("evidence_count") or 0)
    rule_types = sorted(str(item) for item in concept_data.get("related_rule_types", []) if item)
    sources = [str(item) for item in concept_data.get("sources", []) if item]
    first_source = sources[0] if sources else None
    description_parts = [
        f"Learning concept synced from knowledge_index.json.",
        f"Evidence count: {evidence_count}.",
    ]
    if sources:
        description_parts.append(f"Sources: {', '.join(sources[:8])}.")

    tags = ["learning_concept", *rule_types]
    return {
        "node_id": _concept_node_id(concept_name),
        "node_type": "concept",
        "title": str(concept_data.get("concept") or concept_name),
        "description": " ".join(description_parts),
        "source_id": first_source,
        "source_table": "knowledge_index",
        "tags": ",".join(tags),
        "confidence": float(concept_data.get("confidence") or 0),
        "status": "active",
        "obsidian_path": _concept_note_path(concept_name),
    }


def _source_details_by_key(concept_data: dict[str, Any]) -> dict[str, dict[str, Any]]:
    details: dict[str, dict[str, Any]] = {}
    for item in concept_data.get("source_details", []) or []:
        if not isinstance(item, dict):
            continue
        for key in (item.get("video_id"), item.get("url"), item.get("title")):
            if key:
                details[str(key)] = item
    return details


def _source_ref_from_detail(source: str, detail: dict[str, Any] | None) -> str:
    if not detail:
        return source
    return str(detail.get("url") or detail.get("video_id") or source)


def _evidence_type(source_ref: str) -> str:
    # Live DB restricts evidence_type to a fixed enum. Keep the source kind
    # in result_metric/source_ref and use the broad allowed type here.
    return "manual_observation"


def _source_kind(source_ref: str) -> str:
    lowered = source_ref.lower()
    if "youtube.com" in lowered or "youtu.be" in lowered:
        return "youtube"
    if re.match(r"^[a-z]:\\", lowered) or lowered.endswith((".mp4", ".png", ".jpg", ".jpeg", ".md", ".txt")):
        return "local"
    return "source"


def _evidence_id(node_id: str, source_ref: str) -> str:
    digest = hashlib.sha1(f"{node_id}|{source_ref}".encode("utf-8")).hexdigest()[:16]
    return f"learning_evidence:{digest}"


def _relationship_id(from_node_id: str, to_node_id: str, rel_type: str) -> str:
    digest = hashlib.sha1(f"{from_node_id}|{to_node_id}|{rel_type}".encode("utf-8")).hexdigest()[:16]
    return f"learning_rel:{digest}"


def _build_evidence_payloads(concept_name: str, concept_data: dict[str, Any]) -> list[dict[str, Any]]:
    node_id = _concept_node_id(concept_name)
    details = _source_details_by_key(concept_data)
    sources = [str(item) for item in concept_data.get("sources", []) if item]
    if not sources and concept_data.get("source_details"):
        sources = [
            str(item.get("video_id") or item.get("url") or item.get("title"))
            for item in concept_data.get("source_details", [])
            if isinstance(item, dict) and (item.get("video_id") or item.get("url") or item.get("title"))
        ]

    payloads: list[dict[str, Any]] = []
    confidence = float(concept_data.get("confidence") or 0)
    evidence_count = int(concept_data.get("evidence_count") or len(sources) or 0)
    for source in sources:
        detail = details.get(source)
        source_ref = _source_ref_from_detail(source, detail)
        title = str((detail or {}).get("title") or f"{concept_name} source {source}")
        description = f"Evidence source for learning concept '{concept_name}'."
        if detail and detail.get("video_id"):
            description += f" video_id={detail['video_id']}."
        payloads.append(
            {
                "evidence_id": _evidence_id(node_id, source_ref),
                "rel_id": None,
                "node_id": node_id,
                "evidence_type": _evidence_type(source_ref),
                "title": title,
                "description": description,
                "sample_n": evidence_count,
                "result_metric": f"knowledge_index.{_source_kind(source_ref)}",
                "supports": 1,
                "confidence": confidence,
                "source_ref": source_ref,
            }
        )
    return payloads


def _build_relationship_payloads(concepts: dict[str, dict[str, Any]]) -> list[dict[str, Any]]:
    payloads: list[dict[str, Any]] = []
    items = sorted(concepts.items(), key=lambda item: item[0].lower())
    for index, (left_name, left_data) in enumerate(items):
        for right_name, right_data in items[index + 1 :]:
            shared_sources = sorted(
                set(str(item) for item in left_data.get("sources", []) if item)
                & set(str(item) for item in right_data.get("sources", []) if item)
            )
            if len(shared_sources) < 2:
                continue
            shared_rule_types = sorted(
                set(str(item) for item in left_data.get("related_rule_types", []) if item)
                & set(str(item) for item in right_data.get("related_rule_types", []) if item)
            )
            left_node_id = _concept_node_id(left_name)
            right_node_id = _concept_node_id(right_name)
            from_node_id, to_node_id = sorted([left_node_id, right_node_id])
            strength = min(95, 50 + (len(shared_sources) * 10) + (len(shared_rule_types) * 5))
            source_ref = f"knowledge_index:shared_sources={','.join(shared_sources[:8])}"
            rule_text = ", ".join(shared_rule_types) if shared_rule_types else "no shared rule type"
            rationale = (
                f"Learning concepts share {len(shared_sources)} sources "
                f"({', '.join(shared_sources[:5])}) and {rule_text}."
            )
            payloads.append(
                {
                    "rel_id": _relationship_id(from_node_id, to_node_id, "related_to"),
                    "from_node_id": from_node_id,
                    "to_node_id": to_node_id,
                    "rel_type": "related_to",
                    "strength": strength,
                    "rationale": rationale,
                    "evidence_count": len(shared_sources),
                    "is_bidirectional": 1,
                    "created_by": "learning_db_bridge",
                    "validation_status": "observing",
                    "source_ref": source_ref,
                    "principle_ref": "",
                    "hypothesis_ref": "",
                }
            )
    return payloads


def _fetch_existing_learning_node(
    con: sqlite3.Connection,
    node_id: str,
) -> dict[str, Any] | None:
    row = con.execute(
        """
        SELECT node_id, node_type, title, description, source_id, source_table,
               tags, confidence, status, obsidian_path
        FROM knowledge_nodes
        WHERE node_id=?
        """,
        (node_id,),
    ).fetchone()
    return dict(row) if row else None


def _payload_differs(existing: dict[str, Any], payload: dict[str, Any]) -> bool:
    for column in SYNC_COLUMNS:
        left = existing.get(column)
        right = payload.get(column)
        if column == "confidence":
            if float(left or 0) != float(right or 0):
                return True
            continue
        if (left or None) != (right or None):
            return True
    return False


def _evidence_payload_differs(existing: dict[str, Any], payload: dict[str, Any]) -> bool:
    for column in EVIDENCE_SYNC_COLUMNS:
        left = existing.get(column)
        right = payload.get(column)
        if column in {"confidence"}:
            if float(left or 0) != float(right or 0):
                return True
            continue
        if column in {"sample_n", "supports"}:
            if int(left or 0) != int(right or 0):
                return True
            continue
        if (left or None) != (right or None):
            return True
    return False


def _relationship_payload_differs(existing: dict[str, Any], payload: dict[str, Any]) -> bool:
    for column in RELATIONSHIP_SYNC_COLUMNS:
        left = existing.get(column)
        right = payload.get(column)
        if column == "strength":
            if float(left or 0) != float(right or 0):
                return True
            continue
        if column in {"evidence_count", "is_bidirectional"}:
            if int(left or 0) != int(right or 0):
                return True
            continue
        if (left or None) != (right or None):
            return True
    return False


def _fetch_existing_evidence(
    con: sqlite3.Connection,
    evidence_id: str,
) -> dict[str, Any] | None:
    row = con.execute(
        """
        SELECT evidence_id, rel_id, node_id, evidence_type, title, description,
               sample_n, result_metric, supports, confidence, source_ref
        FROM evidence_links
        WHERE evidence_id=?
        """,
        (evidence_id,),
    ).fetchone()
    return dict(row) if row else None


def _knowledge_node_exists(con: sqlite3.Connection, node_id: str) -> bool:
    row = con.execute(
        "SELECT 1 FROM knowledge_nodes WHERE node_id=?",
        (node_id,),
    ).fetchone()
    return row is not None


def _fetch_existing_relationship(
    con: sqlite3.Connection,
    rel_id: str,
) -> dict[str, Any] | None:
    row = con.execute(
        """
        SELECT rel_id, from_node_id, to_node_id, rel_type, strength, rationale,
               evidence_count, is_bidirectional, created_by, validation_status,
               source_ref, principle_ref, hypothesis_ref
        FROM knowledge_relationships
        WHERE rel_id=?
        """,
        (rel_id,),
    ).fetchone()
    return dict(row) if row else None


def get_bridge_status(
    *,
    db_path: str | Path = DEFAULT_DB_PATH,
    raw_dir: str | Path = DEFAULT_LOCAL_RAW_DIR,
    index_path: str | Path = DEFAULT_INDEX_PATH,
) -> dict[str, Any]:
    db_path = Path(db_path)
    raw_dir = Path(raw_dir)
    index_path = Path(index_path)

    status: dict[str, Any] = {
        "mode": "dry_run",
        "db_path": str(db_path),
        "db_exists": db_path.exists(),
        "can_write": db_path.exists() and db_path.is_file(),
        "schema_version": None,
        "tables": {
            table: {"exists": False, "count": None}
            for table in STATUS_TABLES
        },
        "raw_dir": str(raw_dir),
        "raw_local_files": _count_raw_local_files(raw_dir),
        "index_path": str(index_path),
        "concepts_ready_to_sync": _count_concepts(index_path),
    }

    if not db_path.exists():
        return status

    with _open_readonly(db_path) as con:
        status["schema_version"] = _schema_version(con)
        for table in STATUS_TABLES:
            exists = _table_exists(con, table)
            status["tables"][table] = {
                "exists": exists,
                "count": _table_count(con, table) if exists else None,
            }
    return status


def sync_concepts(
    *,
    db_path: str | Path = DEFAULT_DB_PATH,
    index_path: str | Path = DEFAULT_INDEX_PATH,
    apply: bool = False,
) -> dict[str, Any]:
    db_path = Path(db_path)
    index_path = Path(index_path)
    mode = "apply" if apply else "dry_run"
    result: dict[str, Any] = {
        "ok": True,
        "mode": mode,
        "applied": apply,
        "db_path": str(db_path),
        "index_path": str(index_path),
        "concepts_seen": 0,
        "planned_create": 0,
        "planned_update": 0,
        "skipped": 0,
        "created": 0,
        "updated": 0,
        "items": [],
    }

    if not db_path.exists():
        result.update({"ok": False, "error": "db_missing"})
        return result

    concepts = _load_concepts(index_path)
    result["concepts_seen"] = len(concepts)

    connection_factory = sqlite3.connect
    open_target = db_path
    if not apply:
        connection_factory = lambda path: _open_readonly(Path(path))  # noqa: E731
        open_target = db_path

    with connection_factory(open_target) as con:
        con.row_factory = sqlite3.Row
        columns = _knowledge_node_columns(con)
        missing_columns = sorted(REQUIRED_KNOWLEDGE_NODE_COLUMNS - columns)
        if missing_columns:
            result.update(
                {
                    "ok": False,
                    "error": "knowledge_nodes_schema_missing_columns",
                    "missing_columns": missing_columns,
                }
            )
            return result

        payloads = [
            _build_concept_payload(name, data)
            for name, data in sorted(concepts.items(), key=lambda item: item[0].lower())
        ]
        for payload in payloads:
            existing = _fetch_existing_learning_node(con, payload["node_id"])
            if existing is None:
                action = "create"
                result["planned_create"] += 1
            elif _payload_differs(existing, payload):
                action = "update"
                result["planned_update"] += 1
            else:
                action = "skip"
                result["skipped"] += 1

            if apply and action == "create":
                con.execute(
                    """
                    INSERT INTO knowledge_nodes (
                        node_id, node_type, title, description, source_id,
                        source_table, tags, confidence, status, obsidian_path
                    )
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """,
                    tuple(payload[column] for column in SYNC_COLUMNS),
                )
                result["created"] += 1
            elif apply and action == "update":
                con.execute(
                    """
                    UPDATE knowledge_nodes
                    SET node_type=?, title=?, description=?, source_id=?,
                        source_table=?, tags=?, confidence=?, status=?,
                        obsidian_path=?, updated_at=datetime('now')
                    WHERE node_id=?
                    """,
                    (
                        payload["node_type"],
                        payload["title"],
                        payload["description"],
                        payload["source_id"],
                        payload["source_table"],
                        payload["tags"],
                        payload["confidence"],
                        payload["status"],
                        payload["obsidian_path"],
                        payload["node_id"],
                    ),
                )
                result["updated"] += 1

            if len(result["items"]) < 10:
                result["items"].append(
                    {
                        "action": action,
                        "node_id": payload["node_id"],
                        "title": payload["title"],
                    }
                )

        if apply:
            con.commit()

    return result


def sync_evidence(
    *,
    db_path: str | Path = DEFAULT_DB_PATH,
    index_path: str | Path = DEFAULT_INDEX_PATH,
    apply: bool = False,
) -> dict[str, Any]:
    db_path = Path(db_path)
    index_path = Path(index_path)
    mode = "apply" if apply else "dry_run"
    result: dict[str, Any] = {
        "ok": True,
        "mode": mode,
        "applied": apply,
        "db_path": str(db_path),
        "index_path": str(index_path),
        "concepts_seen": 0,
        "missing_concept_nodes": 0,
        "planned_create": 0,
        "planned_update": 0,
        "skipped": 0,
        "created": 0,
        "updated": 0,
        "items": [],
    }

    if not db_path.exists():
        result.update({"ok": False, "error": "db_missing"})
        return result

    concepts = _load_concepts(index_path)
    result["concepts_seen"] = len(concepts)

    connection_factory = sqlite3.connect
    if not apply:
        connection_factory = lambda path: _open_readonly(Path(path))  # noqa: E731

    with connection_factory(db_path) as con:
        con.row_factory = sqlite3.Row
        evidence_columns = _table_columns(con, "evidence_links")
        missing_columns = sorted(REQUIRED_EVIDENCE_LINK_COLUMNS - evidence_columns)
        if missing_columns:
            result.update(
                {
                    "ok": False,
                    "error": "evidence_links_schema_missing_columns",
                    "missing_columns": missing_columns,
                }
            )
            return result

        for concept_name, concept_data in sorted(concepts.items(), key=lambda item: item[0].lower()):
            node_id = _concept_node_id(concept_name)
            if not _knowledge_node_exists(con, node_id):
                result["missing_concept_nodes"] += 1
                continue
            for payload in _build_evidence_payloads(concept_name, concept_data):
                existing = _fetch_existing_evidence(con, payload["evidence_id"])
                if existing is None:
                    action = "create"
                    result["planned_create"] += 1
                elif _evidence_payload_differs(existing, payload):
                    action = "update"
                    result["planned_update"] += 1
                else:
                    action = "skip"
                    result["skipped"] += 1

                if apply and action == "create":
                    con.execute(
                        """
                        INSERT INTO evidence_links (
                            evidence_id, rel_id, node_id, evidence_type, title,
                            description, sample_n, result_metric, supports,
                            confidence, source_ref
                        )
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                        """,
                        tuple(payload[column] for column in EVIDENCE_SYNC_COLUMNS),
                    )
                    result["created"] += 1
                elif apply and action == "update":
                    con.execute(
                        """
                        UPDATE evidence_links
                        SET rel_id=?, node_id=?, evidence_type=?, title=?,
                            description=?, sample_n=?, result_metric=?,
                            supports=?, confidence=?, source_ref=?
                        WHERE evidence_id=?
                        """,
                        (
                            payload["rel_id"],
                            payload["node_id"],
                            payload["evidence_type"],
                            payload["title"],
                            payload["description"],
                            payload["sample_n"],
                            payload["result_metric"],
                            payload["supports"],
                            payload["confidence"],
                            payload["source_ref"],
                            payload["evidence_id"],
                        ),
                    )
                    result["updated"] += 1

                if len(result["items"]) < 10:
                    result["items"].append(
                        {
                            "action": action,
                            "evidence_id": payload["evidence_id"],
                            "node_id": payload["node_id"],
                            "source_ref": payload["source_ref"],
                        }
                    )

        if apply:
            con.commit()

    return result


def sync_relationships(
    *,
    db_path: str | Path = DEFAULT_DB_PATH,
    index_path: str | Path = DEFAULT_INDEX_PATH,
    apply: bool = False,
) -> dict[str, Any]:
    db_path = Path(db_path)
    index_path = Path(index_path)
    mode = "apply" if apply else "dry_run"
    result: dict[str, Any] = {
        "ok": True,
        "mode": mode,
        "applied": apply,
        "db_path": str(db_path),
        "index_path": str(index_path),
        "concepts_seen": 0,
        "missing_concept_nodes": 0,
        "planned_create": 0,
        "planned_update": 0,
        "skipped": 0,
        "created": 0,
        "updated": 0,
        "items": [],
    }

    if not db_path.exists():
        result.update({"ok": False, "error": "db_missing"})
        return result

    concepts = _load_concepts(index_path)
    result["concepts_seen"] = len(concepts)

    connection_factory = sqlite3.connect
    if not apply:
        connection_factory = lambda path: _open_readonly(Path(path))  # noqa: E731

    with connection_factory(db_path) as con:
        con.row_factory = sqlite3.Row
        relationship_columns = _table_columns(con, "knowledge_relationships")
        missing_columns = sorted(REQUIRED_KNOWLEDGE_RELATIONSHIP_COLUMNS - relationship_columns)
        if missing_columns:
            result.update(
                {
                    "ok": False,
                    "error": "knowledge_relationships_schema_missing_columns",
                    "missing_columns": missing_columns,
                }
            )
            return result

        for payload in _build_relationship_payloads(concepts):
            if not (
                _knowledge_node_exists(con, payload["from_node_id"])
                and _knowledge_node_exists(con, payload["to_node_id"])
            ):
                result["missing_concept_nodes"] += 1
                continue
            existing = _fetch_existing_relationship(con, payload["rel_id"])
            if existing is None:
                action = "create"
                result["planned_create"] += 1
            elif _relationship_payload_differs(existing, payload):
                action = "update"
                result["planned_update"] += 1
            else:
                action = "skip"
                result["skipped"] += 1

            if apply and action == "create":
                con.execute(
                    """
                    INSERT INTO knowledge_relationships (
                        rel_id, from_node_id, to_node_id, rel_type, strength,
                        rationale, evidence_count, is_bidirectional, created_by,
                        validation_status, source_ref, principle_ref, hypothesis_ref
                    )
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                    """,
                    tuple(payload[column] for column in RELATIONSHIP_SYNC_COLUMNS),
                )
                result["created"] += 1
            elif apply and action == "update":
                con.execute(
                    """
                    UPDATE knowledge_relationships
                    SET from_node_id=?, to_node_id=?, rel_type=?, strength=?,
                        rationale=?, evidence_count=?, is_bidirectional=?,
                        created_by=?, validation_status=?, source_ref=?,
                        principle_ref=?, hypothesis_ref=?
                    WHERE rel_id=?
                    """,
                    (
                        payload["from_node_id"],
                        payload["to_node_id"],
                        payload["rel_type"],
                        payload["strength"],
                        payload["rationale"],
                        payload["evidence_count"],
                        payload["is_bidirectional"],
                        payload["created_by"],
                        payload["validation_status"],
                        payload["source_ref"],
                        payload["principle_ref"],
                        payload["hypothesis_ref"],
                        payload["rel_id"],
                    ),
                )
                result["updated"] += 1

            if len(result["items"]) < 10:
                result["items"].append(
                    {
                        "action": action,
                        "rel_id": payload["rel_id"],
                        "from_node_id": payload["from_node_id"],
                        "to_node_id": payload["to_node_id"],
                        "source_ref": payload["source_ref"],
                    }
                )

        if apply:
            con.commit()

    return result


def _build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="EA Knowledge Brain DB bridge")
    subparsers = parser.add_subparsers(dest="command", required=True)

    status_parser = subparsers.add_parser(
        "status",
        help="Read-only dry-run status for syncing learning files into the existing SQLite DB",
    )
    status_parser.add_argument(
        "--db-path",
        default=str(DEFAULT_DB_PATH),
        help="Existing SQLite DB path. Defaults to DATA/processed/trades.sqlite",
    )
    status_parser.add_argument(
        "--raw-dir",
        default=str(DEFAULT_LOCAL_RAW_DIR),
        help="Local raw evidence directory to count",
    )
    status_parser.add_argument(
        "--index",
        default=str(DEFAULT_INDEX_PATH),
        help="knowledge_index.json path to count concepts ready for sync",
    )

    sync_parser = subparsers.add_parser(
        "sync-concepts",
        help="Sync knowledge_index.json concepts into existing knowledge_nodes",
    )
    sync_parser.add_argument(
        "--db-path",
        default=str(DEFAULT_DB_PATH),
        help="Existing SQLite DB path. Defaults to DATA/processed/trades.sqlite",
    )
    sync_parser.add_argument(
        "--index",
        default=str(DEFAULT_INDEX_PATH),
        help="knowledge_index.json path to sync",
    )
    mode_group = sync_parser.add_mutually_exclusive_group()
    mode_group.add_argument(
        "--dry-run",
        action="store_true",
        help="Plan sync without writing. This is the default.",
    )
    mode_group.add_argument(
        "--apply",
        action="store_true",
        help="Write planned concept changes to the existing DB.",
    )

    evidence_parser = subparsers.add_parser(
        "sync-evidence",
        help="Sync knowledge_index.json source evidence into existing evidence_links",
    )
    evidence_parser.add_argument(
        "--db-path",
        default=str(DEFAULT_DB_PATH),
        help="Existing SQLite DB path. Defaults to DATA/processed/trades.sqlite",
    )
    evidence_parser.add_argument(
        "--index",
        default=str(DEFAULT_INDEX_PATH),
        help="knowledge_index.json path to sync evidence from",
    )
    evidence_mode_group = evidence_parser.add_mutually_exclusive_group()
    evidence_mode_group.add_argument(
        "--dry-run",
        action="store_true",
        help="Plan evidence sync without writing. This is the default.",
    )
    evidence_mode_group.add_argument(
        "--apply",
        action="store_true",
        help="Write planned evidence changes to the existing DB.",
    )

    relationship_parser = subparsers.add_parser(
        "sync-relationships",
        help="Sync relationships between existing learning concept nodes",
    )
    relationship_parser.add_argument(
        "--db-path",
        default=str(DEFAULT_DB_PATH),
        help="Existing SQLite DB path. Defaults to DATA/processed/trades.sqlite",
    )
    relationship_parser.add_argument(
        "--index",
        default=str(DEFAULT_INDEX_PATH),
        help="knowledge_index.json path to plan relationships from",
    )
    relationship_mode_group = relationship_parser.add_mutually_exclusive_group()
    relationship_mode_group.add_argument(
        "--dry-run",
        action="store_true",
        help="Plan relationship sync without writing. This is the default.",
    )
    relationship_mode_group.add_argument(
        "--apply",
        action="store_true",
        help="Write planned relationship changes to the existing DB.",
    )
    return parser


def main(argv: list[str] | None = None) -> int:
    parser = _build_parser()
    args = parser.parse_args(argv)

    if args.command == "status":
        _emit_json(
            get_bridge_status(
                db_path=args.db_path,
                raw_dir=args.raw_dir,
                index_path=args.index,
            )
        )
        return 0

    if args.command == "sync-concepts":
        _emit_json(
            sync_concepts(
                db_path=args.db_path,
                index_path=args.index,
                apply=bool(args.apply),
            )
        )
        return 0

    if args.command == "sync-evidence":
        _emit_json(
            sync_evidence(
                db_path=args.db_path,
                index_path=args.index,
                apply=bool(args.apply),
            )
        )
        return 0

    if args.command == "sync-relationships":
        _emit_json(
            sync_relationships(
                db_path=args.db_path,
                index_path=args.index,
                apply=bool(args.apply),
            )
        )
        return 0

    parser.error(f"Unknown command: {args.command}")
    return 2


if __name__ == "__main__":
    raise SystemExit(main())
