from __future__ import annotations

import json
from pathlib import Path

from parallel_agent_supervisor import ParallelAgentSupervisor, SupervisorConfig


def test_default_jobs_include_full_auto_council():
    from parallel_agent_supervisor import default_jobs

    jobs = default_jobs()

    assert set(jobs) == {
        "vera_knowledge_audit",
        "nova_source_audit",
        "diag_runtime_health",
        "momo_regime_data_audit",
        "iris_chart_inbox_audit",
        "penny_currency_data_audit",
        "kira_macro_calendar_audit",
        "risco_rule_risk_audit",
        "nara_session_gate_audit",
        "remy_backtest_artifact_audit",
        "scribe_handoff_audit",
        "hermes_conflict_triage_audit",
        "youtube_queue_audit",
    }


class FakeApi:
    def get(self, path: str) -> dict:
        if path == "/pipeline-status":
            return {"running": False, "error": None}
        if path == "/download-status":
            return {"running": True, "status": "Transcribing", "success": 3, "failed": 1}
        if path == "/status":
            return {
                "blueprint_ready": True,
                "concepts": {"total": 1428},
                "ea_rules": 295,
                "videos": {"learned": 65, "needs_check": 91},
            }
        if path == "/health":
            return {"status": "ok", "service": "ea-knowledge-brain"}
        raise AssertionError(path)


def test_tick_runs_agent_jobs_and_writes_isolated_reports(tmp_path):
    job_names: list[str] = []

    def nova_job(context):
        job_names.append("nova")
        return {
            "agent": "Nova",
            "status": "ok",
            "summary": f"Scanned {context.workspace_root.name}",
            "recommendation": "Prepare next source batch",
        }

    def diag_job(context):
        job_names.append("diag")
        return {
            "agent": "Diag",
            "status": "ok",
            "summary": "Download is still running",
            "recommendation": "Do not start write jobs yet",
        }

    config = SupervisorConfig(
        workspace_root=tmp_path,
        state_dir=tmp_path / "state",
        reports_dir=tmp_path / "reports",
        interval_seconds=1,
    )
    supervisor = ParallelAgentSupervisor(
        config,
        api=FakeApi(),
        jobs={"nova_source_audit": nova_job, "diag_runtime_health": diag_job},
    )

    result = supervisor.tick()

    assert result["action"] == "agent_reports"
    assert result["total"] == 2
    assert sorted(job_names) == ["diag", "nova"]
    status = json.loads((tmp_path / "state" / "parallel_agent_supervisor_status.json").read_text())
    assert status["running"] is True
    assert status["total"] == 2
    report_files = sorted((tmp_path / "reports").glob("*.json"))
    assert [path.stem for path in report_files] == ["diag_runtime_health", "nova_source_audit"]
    report = json.loads((tmp_path / "reports" / "nova_source_audit.json").read_text())
    assert report["agent"] == "Nova"
    assert report["recommendation"] == "Prepare next source batch"


def test_full_auto_council_tick_writes_compact_read_only_reports(tmp_path):
    workspace = tmp_path / "workspace"
    workspace.mkdir()
    (workspace / ".agent_handoff").mkdir()
    (workspace / ".agent_handoff" / "ACTIVE_PLAN.json").write_text(
        json.dumps({"status": "completed", "current_step": "ready", "next_actions": []}),
        encoding="utf-8",
    )
    shared_file = workspace / "DATA" / "raw" / "mql5_code_insights.json"
    shared_file.parent.mkdir(parents=True)
    shared_file.write_text("[]", encoding="utf-8")
    before = shared_file.read_text(encoding="utf-8")

    config = SupervisorConfig(
        workspace_root=workspace,
        jobot_root=tmp_path / "missing_jobot",
        state_dir=tmp_path / "state",
        reports_dir=tmp_path / "reports",
    )
    supervisor = ParallelAgentSupervisor(config, api=FakeApi())

    result = supervisor.tick()

    assert result["action"] == "agent_reports"
    assert result["total"] == 13
    assert shared_file.read_text(encoding="utf-8") == before
    report_files = sorted((tmp_path / "reports").glob("*.json"))
    assert len(report_files) == 13
    for report_path in report_files:
        assert report_path.stat().st_size < 10_000
        report = json.loads(report_path.read_text(encoding="utf-8"))
        assert set(report) >= {"job", "updated_at", "agent", "status", "summary", "recommendation"}
        assert report["status"] in {"ok", "warning", "blocked", "error"}


def test_auto_council_reports_explicitly_disable_paid_and_video_actions(tmp_path):
    config = SupervisorConfig(
        workspace_root=tmp_path,
        jobot_root=tmp_path / "missing_jobot",
        state_dir=tmp_path / "state",
        reports_dir=tmp_path / "reports",
    )
    supervisor = ParallelAgentSupervisor(config, api=FakeApi())

    supervisor.tick()

    hermes = json.loads((tmp_path / "reports" / "hermes_conflict_triage_audit.json").read_text(encoding="utf-8"))
    youtube = json.loads((tmp_path / "reports" / "youtube_queue_audit.json").read_text(encoding="utf-8"))
    iris = json.loads((tmp_path / "reports" / "iris_chart_inbox_audit.json").read_text(encoding="utf-8"))

    assert hermes["data"]["auto_resolve_enabled"] is False
    assert youtube["data"]["auto_intake_enabled"] is False
    assert "Do not run vision analysis automatically" in iris["recommendation"]


def test_default_nova_job_recommends_mql_batch_without_writing_shared_state(tmp_path):
    jobot = tmp_path / "jobot"
    jobot.mkdir()
    (jobot / "first.mq5").write_text("void OnTick() {}", encoding="utf-8")
    (jobot / "second.mqh").write_text("double Lots = 0.01;", encoding="utf-8")
    shared_file = tmp_path / "DATA" / "raw" / "mql5_code_insights.json"
    shared_file.parent.mkdir(parents=True)
    shared_file.write_text("[]", encoding="utf-8")
    before = shared_file.read_text(encoding="utf-8")

    config = SupervisorConfig(
        workspace_root=tmp_path,
        jobot_root=jobot,
        state_dir=tmp_path / "state",
        reports_dir=tmp_path / "reports",
    )
    supervisor = ParallelAgentSupervisor(config, api=FakeApi())

    result = supervisor.tick()

    assert result["action"] == "agent_reports"
    nova = json.loads((tmp_path / "reports" / "nova_source_audit.json").read_text())
    assert nova["status"] == "ok"
    assert "2 unprocessed MQL/source candidates" in nova["summary"]
    assert nova["recommendation"] == "Queue a controlled source-first MQL batch when pipeline and download are idle."
    assert shared_file.read_text(encoding="utf-8") == before


def test_default_nova_job_prepares_next_unprocessed_mql_batch(tmp_path):
    jobot = tmp_path / "jobot"
    jobot.mkdir()
    first = jobot / "first.mq5"
    second = jobot / "second.mq5"
    third = jobot / "third.mq5"
    first.write_text("first", encoding="utf-8")
    second.write_text("second", encoding="utf-8")
    third.write_text("third", encoding="utf-8")
    import mql5_code_intake as intake

    manifest_path = tmp_path / "manifest.json"
    manifest_path.write_text(json.dumps({
        "version": 1,
        "processed_hashes": {
            intake.get_file_hash(str(first)): {
                "source_file": str(first),
                "status": "processed",
            }
        },
    }), encoding="utf-8")
    config = SupervisorConfig(
        workspace_root=tmp_path,
        jobot_root=jobot,
        mql_manifest_path=manifest_path,
        state_dir=tmp_path / "state",
        reports_dir=tmp_path / "reports",
    )
    supervisor = ParallelAgentSupervisor(config, api=FakeApi())

    supervisor.tick()

    nova = json.loads((tmp_path / "reports" / "nova_source_audit.json").read_text())
    assert nova["data"]["candidate_count"] == 2
    assert nova["data"]["next_batch"] == [str(second), str(third)]
    assert "--limit 10 --workers 1" in nova["data"]["command"]


def test_diag_report_keeps_pipeline_payload_compact(tmp_path):
    class VerboseApi(FakeApi):
        def get(self, path: str) -> dict:
            if path == "/pipeline-status":
                return {
                    "running": False,
                    "error": None,
                    "result": {"blueprint": {"mql5_code": "x" * 100_000}},
                }
            return super().get(path)

    config = SupervisorConfig(
        workspace_root=tmp_path,
        state_dir=tmp_path / "state",
        reports_dir=tmp_path / "reports",
    )
    supervisor = ParallelAgentSupervisor(config, api=VerboseApi(), jobs=None)

    supervisor.tick()

    diag_path = tmp_path / "reports" / "diag_runtime_health.json"
    assert diag_path.stat().st_size < 10_000
    diag = json.loads(diag_path.read_text(encoding="utf-8"))
    assert diag["data"]["pipeline"] == {"running": False, "error": None}


def test_diag_report_includes_system_watchdog(tmp_path, monkeypatch):
    workspace = tmp_path / "workspace"
    reports_dir = workspace / ".agent_handoff" / "agent_reports"
    reports_dir.mkdir(parents=True)
    (reports_dir / "old_report.json").write_text(
        json.dumps({"updated_at": "2026-06-06T10:00:00+07:00"}),
        encoding="utf-8",
    )
    state_dir = tmp_path / "state"
    state_dir.mkdir()
    (state_dir / "download_status.json").write_text(
        json.dumps({"running": False}),
        encoding="utf-8",
    )
    monkeypatch.setattr(
        "parallel_agent_supervisor._read_json_url",
        lambda url, timeout=2: {
            "ok": True,
            "data": {
                "manager_online": True,
                "api_online": True,
                "managed": True,
                "pid": 5544,
            },
            "latency_ms": 7,
        },
    )

    config = SupervisorConfig(
        workspace_root=workspace,
        state_dir=state_dir,
        reports_dir=reports_dir,
    )
    supervisor = ParallelAgentSupervisor(config, api=FakeApi(), jobs=None)

    supervisor.tick()

    diag = json.loads((reports_dir / "diag_runtime_health.json").read_text(encoding="utf-8"))
    watchdog = diag["data"]["watchdog"]
    assert watchdog["server_manager"]["managed"] is True
    assert watchdog["api_latency_ms"] >= 0
    assert watchdog["runtime_files"]["download_status.json"]["readable"] is True
    assert watchdog["report_freshness"]["stale_count"] >= 1
    assert watchdog["paid_api_guard"]["unknown_billing_treated_as_paid"] is True
