from __future__ import annotations

import json
import sqlite3
from pathlib import Path

import pytest

import db_bridge


def _make_db(path: Path) -> None:
    con = sqlite3.connect(path)
    con.executescript(
        """
        CREATE TABLE db_meta (key TEXT PRIMARY KEY, value TEXT);
        INSERT INTO db_meta VALUES ('schema_version', '10');
        CREATE TABLE knowledge_nodes (
            node_id TEXT PRIMARY KEY,
            node_type TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            source_id TEXT,
            source_table TEXT,
            tags TEXT,
            confidence REAL DEFAULT 0,
            status TEXT DEFAULT 'active',
            obsidian_path TEXT,
            created_at DATETIME DEFAULT (datetime('now')),
            updated_at DATETIME DEFAULT (datetime('now'))
        );
        CREATE TABLE knowledge_relationships (
            rel_id TEXT PRIMARY KEY,
            from_node_id TEXT NOT NULL,
            to_node_id TEXT NOT NULL,
            rel_type TEXT NOT NULL,
            strength REAL DEFAULT 50,
            rationale TEXT,
            evidence_count INTEGER DEFAULT 0,
            is_bidirectional INTEGER DEFAULT 0,
            created_by TEXT DEFAULT 'seed',
            created_at DATETIME DEFAULT (datetime('now')),
            validation_status TEXT DEFAULT 'unvalidated',
            source_ref TEXT DEFAULT '',
            principle_ref TEXT DEFAULT '',
            hypothesis_ref TEXT DEFAULT '',
            UNIQUE(from_node_id, to_node_id, rel_type)
        );
        CREATE TABLE evidence_links (
            evidence_id TEXT PRIMARY KEY,
            rel_id TEXT,
            node_id TEXT,
            evidence_type TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            sample_n INTEGER DEFAULT 0,
            result_metric TEXT,
            supports INTEGER DEFAULT 1,
            confidence REAL DEFAULT 50,
            source_ref TEXT,
            created_at DATETIME DEFAULT (datetime('now'))
        );
        INSERT INTO knowledge_nodes (node_id, node_type, title) VALUES ('concept:fvg', 'concept', 'FVG');
        INSERT INTO knowledge_relationships (rel_id, from_node_id, to_node_id, rel_type)
        VALUES ('rel:1', 'concept:fvg', 'concept:seed', 'related_to');
        INSERT INTO evidence_links (evidence_id, evidence_type, title) VALUES ('ev:1', 'seed', 'Evidence 1');
        INSERT INTO evidence_links (evidence_id, evidence_type, title) VALUES ('ev:2', 'seed', 'Evidence 2');
        """
    )
    con.commit()
    con.close()


def test_db_bridge_status_reads_existing_db_without_writing(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    before_mtime = db_path.stat().st_mtime_ns

    raw_dir = tmp_path / "raw" / "local"
    raw_dir.mkdir(parents=True)
    (raw_dir / "note1.md").write_text("raw note", encoding="utf-8")
    (raw_dir / "note2.md").write_text("raw note", encoding="utf-8")
    index_path = tmp_path / "knowledge_index.json"
    index_path.write_text(
        json.dumps({"concepts": {"FVG": {}, "CHoCH": {}}}),
        encoding="utf-8",
    )

    status = db_bridge.get_bridge_status(
        db_path=db_path,
        raw_dir=raw_dir,
        index_path=index_path,
    )

    assert status["mode"] == "dry_run"
    assert status["db_exists"] is True
    assert status["schema_version"] == "10"
    assert status["tables"]["knowledge_nodes"]["count"] == 1
    assert status["tables"]["knowledge_relationships"]["count"] == 1
    assert status["tables"]["evidence_links"]["count"] == 2
    assert status["raw_local_files"] == 2
    assert status["concepts_ready_to_sync"] == 2
    assert db_path.stat().st_mtime_ns == before_mtime


def test_db_bridge_status_is_safe_when_optional_tables_are_missing(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    con = sqlite3.connect(db_path)
    con.execute("CREATE TABLE db_meta (key TEXT PRIMARY KEY, value TEXT)")
    con.commit()
    con.close()

    status = db_bridge.get_bridge_status(
        db_path=db_path,
        raw_dir=tmp_path / "missing_raw",
        index_path=tmp_path / "missing_index.json",
    )

    assert status["db_exists"] is True
    assert status["tables"]["knowledge_nodes"]["exists"] is False
    assert status["tables"]["evidence_links"]["count"] is None
    assert status["raw_local_files"] == 0
    assert status["concepts_ready_to_sync"] == 0


def test_db_bridge_status_does_not_create_missing_db(tmp_path):
    db_path = tmp_path / "missing.sqlite"

    status = db_bridge.get_bridge_status(
        db_path=db_path,
        raw_dir=tmp_path / "raw",
        index_path=tmp_path / "knowledge_index.json",
    )

    assert status["db_exists"] is False
    assert not db_path.exists()


def test_db_bridge_cli_status_emits_json(tmp_path, capsys):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)

    exit_code = db_bridge.main(
        [
            "status",
            "--db-path",
            str(db_path),
            "--raw-dir",
            str(tmp_path / "raw"),
            "--index",
            str(tmp_path / "knowledge_index.json"),
        ]
    )

    assert exit_code == 0
    payload = json.loads(capsys.readouterr().out)
    assert payload["db_path"] == str(db_path)
    assert payload["mode"] == "dry_run"


def test_db_bridge_cli_rejects_unknown_command():
    with pytest.raises(SystemExit):
        db_bridge.main(["unknown"])


def _write_index(path: Path) -> None:
    path.write_text(
        json.dumps(
            {
                "concepts": {
                    "FVG": {
                        "concept": "FVG",
                        "confidence": 88,
                        "evidence_count": 3,
                        "related_rule_types": ["entry", "filter"],
                        "sources": ["video1", "video2"],
                        "source_details": [
                            {
                                "title": "First video",
                                "url": "https://example.test/video1",
                                "video_id": "video1",
                            }
                        ],
                    },
                    "Asia Session Filter": {
                        "concept": "Asia Session Filter",
                        "confidence": 70,
                        "evidence_count": 1,
                        "related_rule_types": ["regime"],
                        "sources": ["video3"],
                    },
                }
            },
            ensure_ascii=False,
        ),
        encoding="utf-8",
    )


def _write_relationship_index(path: Path) -> None:
    path.write_text(
        json.dumps(
            {
                "concepts": {
                    "FVG": {
                        "concept": "FVG",
                        "confidence": 88,
                        "evidence_count": 3,
                        "related_rule_types": ["entry", "filter"],
                        "sources": ["video1", "video2", "video3"],
                    },
                    "Order Block": {
                        "concept": "Order Block",
                        "confidence": 82,
                        "evidence_count": 2,
                        "related_rule_types": ["entry"],
                        "sources": ["video1", "video2"],
                    },
                    "Asia Session Filter": {
                        "concept": "Asia Session Filter",
                        "confidence": 70,
                        "evidence_count": 1,
                        "related_rule_types": ["regime"],
                        "sources": ["video4"],
                    },
                }
            },
            ensure_ascii=False,
        ),
        encoding="utf-8",
    )


def test_plan_concept_sync_dry_run_does_not_write(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)
    before_mtime = db_path.stat().st_mtime_ns

    plan = db_bridge.sync_concepts(
        db_path=db_path,
        index_path=index_path,
        apply=False,
    )

    assert plan["mode"] == "dry_run"
    assert plan["planned_create"] == 2
    assert plan["planned_update"] == 0
    assert plan["skipped"] == 0
    assert plan["applied"] is False
    assert db_path.stat().st_mtime_ns == before_mtime

    con = sqlite3.connect(db_path)
    count = con.execute("SELECT COUNT(*) FROM knowledge_nodes").fetchone()[0]
    con.close()
    assert count == 1


def test_apply_concept_sync_inserts_existing_db_nodes_idempotently(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)

    first = db_bridge.sync_concepts(
        db_path=db_path,
        index_path=index_path,
        apply=True,
    )
    second = db_bridge.sync_concepts(
        db_path=db_path,
        index_path=index_path,
        apply=True,
    )

    assert first["mode"] == "apply"
    assert first["created"] == 2
    assert first["updated"] == 0
    assert second["created"] == 0
    assert second["updated"] == 0
    assert second["skipped"] == 2

    con = sqlite3.connect(db_path)
    con.row_factory = sqlite3.Row
    rows = con.execute(
        "SELECT node_id, node_type, title, source_table, confidence, status FROM knowledge_nodes WHERE source_table='knowledge_index' ORDER BY title"
    ).fetchall()
    con.close()
    assert [row["title"] for row in rows] == ["Asia Session Filter", "FVG"]
    assert rows[0]["node_type"] == "concept"
    assert rows[1]["confidence"] == 88
    assert rows[1]["status"] == "active"


def test_concept_sync_updates_existing_learning_node_when_payload_changes(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)
    db_bridge.sync_concepts(db_path=db_path, index_path=index_path, apply=True)

    data = json.loads(index_path.read_text(encoding="utf-8"))
    data["concepts"]["FVG"]["confidence"] = 91
    index_path.write_text(json.dumps(data), encoding="utf-8")

    result = db_bridge.sync_concepts(
        db_path=db_path,
        index_path=index_path,
        apply=True,
    )

    assert result["created"] == 0
    assert result["updated"] == 1

    con = sqlite3.connect(db_path)
    confidence = con.execute(
        "SELECT confidence FROM knowledge_nodes WHERE title='FVG' AND source_table='knowledge_index'"
    ).fetchone()[0]
    con.close()
    assert confidence == 91


def test_concept_sync_refuses_missing_required_knowledge_node_columns(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    con = sqlite3.connect(db_path)
    con.execute("CREATE TABLE knowledge_nodes (node_id TEXT PRIMARY KEY, title TEXT)")
    con.commit()
    con.close()
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)

    result = db_bridge.sync_concepts(
        db_path=db_path,
        index_path=index_path,
        apply=False,
    )

    assert result["ok"] is False
    assert result["error"] == "knowledge_nodes_schema_missing_columns"
    assert "node_type" in result["missing_columns"]


def test_concept_sync_does_not_create_missing_db(tmp_path):
    db_path = tmp_path / "missing.sqlite"
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)

    result = db_bridge.sync_concepts(
        db_path=db_path,
        index_path=index_path,
        apply=True,
    )

    assert result["ok"] is False
    assert result["error"] == "db_missing"
    assert not db_path.exists()


def test_db_bridge_cli_sync_concepts_dry_run_emits_json(tmp_path, capsys):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)

    exit_code = db_bridge.main(
        [
            "sync-concepts",
            "--db-path",
            str(db_path),
            "--index",
            str(index_path),
            "--dry-run",
        ]
    )

    assert exit_code == 0
    payload = json.loads(capsys.readouterr().out)
    assert payload["mode"] == "dry_run"
    assert payload["planned_create"] == 2


def test_db_bridge_cli_sync_concepts_apply_writes_existing_db(tmp_path, capsys):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)

    exit_code = db_bridge.main(
        [
            "sync-concepts",
            "--db-path",
            str(db_path),
            "--index",
            str(index_path),
            "--apply",
        ]
    )

    assert exit_code == 0
    payload = json.loads(capsys.readouterr().out)
    assert payload["mode"] == "apply"
    assert payload["created"] == 2


def test_plan_evidence_sync_dry_run_does_not_write(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)
    db_bridge.sync_concepts(db_path=db_path, index_path=index_path, apply=True)
    before_mtime = db_path.stat().st_mtime_ns

    plan = db_bridge.sync_evidence(
        db_path=db_path,
        index_path=index_path,
        apply=False,
    )

    assert plan["mode"] == "dry_run"
    assert plan["concepts_seen"] == 2
    assert plan["planned_create"] == 3
    assert plan["planned_update"] == 0
    assert plan["skipped"] == 0
    assert db_path.stat().st_mtime_ns == before_mtime

    con = sqlite3.connect(db_path)
    count = con.execute("SELECT COUNT(*) FROM evidence_links").fetchone()[0]
    con.close()
    assert count == 2


def test_apply_evidence_sync_inserts_existing_db_links_idempotently(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)
    db_bridge.sync_concepts(db_path=db_path, index_path=index_path, apply=True)

    first = db_bridge.sync_evidence(db_path=db_path, index_path=index_path, apply=True)
    second = db_bridge.sync_evidence(db_path=db_path, index_path=index_path, apply=True)

    assert first["created"] == 3
    assert first["updated"] == 0
    assert second["created"] == 0
    assert second["updated"] == 0
    assert second["skipped"] == 3

    con = sqlite3.connect(db_path)
    con.row_factory = sqlite3.Row
    rows = con.execute(
        "SELECT evidence_type, title, supports, confidence, source_ref FROM evidence_links WHERE evidence_id LIKE 'learning_evidence:%' ORDER BY source_ref"
    ).fetchall()
    con.close()
    assert len(rows) == 3
    assert rows[0]["evidence_type"] == "manual_observation"
    assert rows[0]["supports"] == 1
    assert rows[0]["confidence"] == 88


def test_evidence_sync_updates_existing_link_when_payload_changes(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)
    db_bridge.sync_concepts(db_path=db_path, index_path=index_path, apply=True)
    db_bridge.sync_evidence(db_path=db_path, index_path=index_path, apply=True)

    data = json.loads(index_path.read_text(encoding="utf-8"))
    data["concepts"]["FVG"]["confidence"] = 91
    index_path.write_text(json.dumps(data), encoding="utf-8")
    db_bridge.sync_concepts(db_path=db_path, index_path=index_path, apply=True)

    result = db_bridge.sync_evidence(db_path=db_path, index_path=index_path, apply=True)

    assert result["created"] == 0
    assert result["updated"] == 2

    con = sqlite3.connect(db_path)
    values = [
        row[0]
        for row in con.execute(
            "SELECT confidence FROM evidence_links WHERE source_ref IN ('https://example.test/video1', 'video2') ORDER BY source_ref"
        )
    ]
    con.close()
    assert values == [91, 91]


def test_evidence_sync_requires_synced_concept_nodes(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)

    result = db_bridge.sync_evidence(db_path=db_path, index_path=index_path, apply=False)

    assert result["ok"] is True
    assert result["planned_create"] == 0
    assert result["missing_concept_nodes"] == 2


def test_evidence_sync_refuses_missing_required_evidence_columns(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    con = sqlite3.connect(db_path)
    con.executescript(
        """
        CREATE TABLE knowledge_nodes (
            node_id TEXT PRIMARY KEY,
            node_type TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            source_id TEXT,
            source_table TEXT,
            tags TEXT,
            confidence REAL DEFAULT 0,
            status TEXT DEFAULT 'active',
            obsidian_path TEXT,
            created_at DATETIME DEFAULT (datetime('now')),
            updated_at DATETIME DEFAULT (datetime('now'))
        );
        CREATE TABLE evidence_links (evidence_id TEXT PRIMARY KEY, title TEXT);
        """
    )
    con.commit()
    con.close()
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)

    result = db_bridge.sync_evidence(db_path=db_path, index_path=index_path, apply=False)

    assert result["ok"] is False
    assert result["error"] == "evidence_links_schema_missing_columns"
    assert "node_id" in result["missing_columns"]


def test_evidence_sync_does_not_create_missing_db(tmp_path):
    db_path = tmp_path / "missing.sqlite"
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)

    result = db_bridge.sync_evidence(db_path=db_path, index_path=index_path, apply=True)

    assert result["ok"] is False
    assert result["error"] == "db_missing"
    assert not db_path.exists()


def test_db_bridge_cli_sync_evidence_dry_run_emits_json(tmp_path, capsys):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)
    db_bridge.sync_concepts(db_path=db_path, index_path=index_path, apply=True)

    exit_code = db_bridge.main(
        [
            "sync-evidence",
            "--db-path",
            str(db_path),
            "--index",
            str(index_path),
            "--dry-run",
        ]
    )

    assert exit_code == 0
    payload = json.loads(capsys.readouterr().out)
    assert payload["mode"] == "dry_run"
    assert payload["planned_create"] == 3


def test_db_bridge_cli_sync_evidence_apply_writes_existing_db(tmp_path, capsys):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_index(index_path)
    db_bridge.sync_concepts(db_path=db_path, index_path=index_path, apply=True)

    exit_code = db_bridge.main(
        [
            "sync-evidence",
            "--db-path",
            str(db_path),
            "--index",
            str(index_path),
            "--apply",
        ]
    )

    assert exit_code == 0
    payload = json.loads(capsys.readouterr().out)
    assert payload["mode"] == "apply"
    assert payload["created"] == 3


def test_plan_relationship_sync_dry_run_does_not_write(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_relationship_index(index_path)
    db_bridge.sync_concepts(db_path=db_path, index_path=index_path, apply=True)
    before_mtime = db_path.stat().st_mtime_ns

    plan = db_bridge.sync_relationships(
        db_path=db_path,
        index_path=index_path,
        apply=False,
    )

    assert plan["mode"] == "dry_run"
    assert plan["concepts_seen"] == 3
    assert plan["planned_create"] == 1
    assert plan["planned_update"] == 0
    assert plan["skipped"] == 0
    assert plan["missing_concept_nodes"] == 0
    assert db_path.stat().st_mtime_ns == before_mtime

    con = sqlite3.connect(db_path)
    count = con.execute("SELECT COUNT(*) FROM knowledge_relationships").fetchone()[0]
    con.close()
    assert count == 1


def test_apply_relationship_sync_inserts_existing_db_edges_idempotently(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_relationship_index(index_path)
    db_bridge.sync_concepts(db_path=db_path, index_path=index_path, apply=True)

    first = db_bridge.sync_relationships(db_path=db_path, index_path=index_path, apply=True)
    second = db_bridge.sync_relationships(db_path=db_path, index_path=index_path, apply=True)

    assert first["created"] == 1
    assert first["updated"] == 0
    assert second["created"] == 0
    assert second["updated"] == 0
    assert second["skipped"] == 1

    con = sqlite3.connect(db_path)
    con.row_factory = sqlite3.Row
    rows = con.execute(
        "SELECT rel_type, strength, evidence_count, is_bidirectional, created_by, validation_status, source_ref FROM knowledge_relationships WHERE rel_id LIKE 'learning_rel:%'"
    ).fetchall()
    con.close()
    assert len(rows) == 1
    assert rows[0]["rel_type"] == "related_to"
    assert rows[0]["strength"] == 75
    assert rows[0]["evidence_count"] == 2
    assert rows[0]["is_bidirectional"] == 1
    assert rows[0]["created_by"] == "learning_db_bridge"
    assert rows[0]["validation_status"] == "observing"
    assert rows[0]["source_ref"] == "knowledge_index:shared_sources=video1,video2"


def test_relationship_sync_updates_existing_edge_when_payload_changes(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_relationship_index(index_path)
    db_bridge.sync_concepts(db_path=db_path, index_path=index_path, apply=True)
    db_bridge.sync_relationships(db_path=db_path, index_path=index_path, apply=True)

    data = json.loads(index_path.read_text(encoding="utf-8"))
    data["concepts"]["Order Block"]["sources"].append("video3")
    index_path.write_text(json.dumps(data), encoding="utf-8")

    result = db_bridge.sync_relationships(db_path=db_path, index_path=index_path, apply=True)

    assert result["created"] == 0
    assert result["updated"] == 1

    con = sqlite3.connect(db_path)
    row = con.execute(
        "SELECT strength, evidence_count, source_ref FROM knowledge_relationships WHERE rel_id LIKE 'learning_rel:%'"
    ).fetchone()
    con.close()
    assert row == (85, 3, "knowledge_index:shared_sources=video1,video2,video3")


def test_relationship_sync_requires_synced_concept_nodes(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_relationship_index(index_path)

    result = db_bridge.sync_relationships(db_path=db_path, index_path=index_path, apply=False)

    assert result["ok"] is True
    assert result["planned_create"] == 0
    assert result["missing_concept_nodes"] == 1


def test_relationship_sync_refuses_missing_required_relationship_columns(tmp_path):
    db_path = tmp_path / "trades.sqlite"
    con = sqlite3.connect(db_path)
    con.executescript(
        """
        CREATE TABLE knowledge_nodes (
            node_id TEXT PRIMARY KEY,
            node_type TEXT NOT NULL,
            title TEXT NOT NULL,
            description TEXT,
            source_id TEXT,
            source_table TEXT,
            tags TEXT,
            confidence REAL DEFAULT 0,
            status TEXT DEFAULT 'active',
            obsidian_path TEXT,
            created_at DATETIME DEFAULT (datetime('now')),
            updated_at DATETIME DEFAULT (datetime('now'))
        );
        CREATE TABLE knowledge_relationships (rel_id TEXT PRIMARY KEY);
        """
    )
    con.commit()
    con.close()
    index_path = tmp_path / "knowledge_index.json"
    _write_relationship_index(index_path)

    result = db_bridge.sync_relationships(db_path=db_path, index_path=index_path, apply=False)

    assert result["ok"] is False
    assert result["error"] == "knowledge_relationships_schema_missing_columns"
    assert "from_node_id" in result["missing_columns"]


def test_relationship_sync_does_not_create_missing_db(tmp_path):
    db_path = tmp_path / "missing.sqlite"
    index_path = tmp_path / "knowledge_index.json"
    _write_relationship_index(index_path)

    result = db_bridge.sync_relationships(
        db_path=db_path,
        index_path=index_path,
        apply=True,
    )

    assert result["ok"] is False
    assert result["error"] == "db_missing"
    assert not db_path.exists()


def test_db_bridge_cli_sync_relationships_dry_run_emits_json(tmp_path, capsys):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_relationship_index(index_path)
    db_bridge.sync_concepts(db_path=db_path, index_path=index_path, apply=True)

    exit_code = db_bridge.main(
        [
            "sync-relationships",
            "--db-path",
            str(db_path),
            "--index",
            str(index_path),
            "--dry-run",
        ]
    )

    assert exit_code == 0
    payload = json.loads(capsys.readouterr().out)
    assert payload["mode"] == "dry_run"
    assert payload["planned_create"] == 1


def test_db_bridge_cli_sync_relationships_apply_writes_existing_db(tmp_path, capsys):
    db_path = tmp_path / "trades.sqlite"
    _make_db(db_path)
    index_path = tmp_path / "knowledge_index.json"
    _write_relationship_index(index_path)
    db_bridge.sync_concepts(db_path=db_path, index_path=index_path, apply=True)

    exit_code = db_bridge.main(
        [
            "sync-relationships",
            "--db-path",
            str(db_path),
            "--index",
            str(index_path),
            "--apply",
        ]
    )

    assert exit_code == 0
    payload = json.loads(capsys.readouterr().out)
    assert payload["mode"] == "apply"
    assert payload["created"] == 1
