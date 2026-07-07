"""Tests for server_manager.py.

ORCA: tests written before implementation.
The manager owns the Flask API process so the dashboard can start/stop it.
"""
from __future__ import annotations

import sys
from pathlib import Path
from unittest.mock import Mock

import pytest
from contextlib import contextmanager

from server_manager import ServerManager, create_app


@pytest.fixture(autouse=True)
def clear_telegram_env(monkeypatch):
    monkeypatch.delenv("TELEGRAM_BOT_TOKEN", raising=False)
    monkeypatch.delenv("SALES_TELEGRAM_BOT_TOKEN", raising=False)


def test_status_reports_api_online_when_probe_succeeds(tmp_path, monkeypatch):
    manager = ServerManager(state_dir=tmp_path)
    monkeypatch.setattr(manager, "_api_online", lambda: True)
    monkeypatch.setattr(manager, "_find_api_server_pid", lambda: None)

    data = manager.status()

    assert data["manager_online"] is True
    assert data["api_online"] is True
    assert data["managed"] is False


def test_status_adopts_external_api_process_when_online_and_pid_missing(tmp_path, monkeypatch):
    manager = ServerManager(state_dir=tmp_path)
    monkeypatch.setattr(manager, "_api_online", lambda: True)
    monkeypatch.setattr(manager, "_find_api_server_pid", lambda: 12345)
    monkeypatch.setattr(manager, "_pid_running", lambda pid: pid == 12345)

    data = manager.status()

    assert data["api_online"] is True
    assert data["managed"] is True
    assert data["pid"] == 12345
    assert manager.pid_path.read_text(encoding="utf-8") == "12345"


def test_status_replaces_stale_running_pid_with_actual_api_listener(tmp_path, monkeypatch):
    manager = ServerManager(state_dir=tmp_path)
    manager._write_pid(11111)
    monkeypatch.setattr(manager, "_api_online", lambda: True)
    monkeypatch.setattr(manager, "_find_api_server_pid", lambda: 22222)
    monkeypatch.setattr(manager, "_pid_running", lambda pid: pid in {11111, 22222})

    data = manager.status()

    assert data["managed"] is True
    assert data["pid"] == 22222
    assert manager.pid_path.read_text(encoding="utf-8") == "22222"


def test_default_api_status_url_uses_lightweight_health_endpoint(tmp_path):
    manager = ServerManager(state_dir=tmp_path)

    assert manager.api_status_url == "http://127.0.0.1:5000/api/learning/health"


def test_api_online_allows_slow_status_endpoint(tmp_path, monkeypatch):
    manager = ServerManager(state_dir=tmp_path)
    observed = {}

    @contextmanager
    def fake_urlopen(url, timeout):
        observed["url"] = url
        observed["timeout"] = timeout
        yield Mock(status=200)

    monkeypatch.setattr("server_manager.urllib.request.urlopen", fake_urlopen)

    assert manager._api_online() is True
    assert observed["timeout"] >= 3.0


def test_start_spawns_server_when_api_offline(tmp_path, monkeypatch):
    manager = ServerManager(state_dir=tmp_path, telegram_token_file=tmp_path / "missing_token.txt")
    fake_proc = Mock()
    fake_proc.pid = 12345
    fake_proc.poll.return_value = None
    monkeypatch.setattr(manager, "_api_online", lambda: False)
    monkeypatch.setattr(manager, "_wait_api", lambda timeout=10.0: True)
    popen = Mock(return_value=fake_proc)
    monkeypatch.setattr("server_manager.subprocess.Popen", popen)

    data = manager.start()

    assert data["status"] == "started"
    assert data["pid"] == 12345
    assert manager.pid_path.read_text(encoding="utf-8") == "12345"
    args = popen.call_args_list[0].args[0]
    assert Path(args[1]).name == "server.py"


def test_start_spawns_telegram_bot_when_configured(tmp_path, monkeypatch):
    telegram_script = tmp_path / "telegram_bot.py"
    telegram_script.write_text("print('bot')", encoding="utf-8")
    token_file = tmp_path / "telegram_token.txt"
    token_file.write_text("123:token", encoding="utf-8")
    manager = ServerManager(
        state_dir=tmp_path / "state",
        telegram_script=telegram_script,
        telegram_token_file=token_file,
        crm_telegram_script=tmp_path / "missing_crm.py",
        auto_worker_script=tmp_path / "missing_worker.py",
        parallel_supervisor_script=tmp_path / "missing_supervisor.py",
    )
    fake_api_proc = Mock()
    fake_api_proc.pid = 12345
    fake_api_proc.poll.return_value = None
    fake_bot_proc = Mock()
    fake_bot_proc.pid = 67890
    fake_bot_proc.poll.return_value = None
    monkeypatch.setattr(manager, "_api_online", lambda: False)
    monkeypatch.setattr(manager, "_wait_api", lambda timeout=10.0: True)
    popen = Mock(side_effect=[fake_api_proc, fake_bot_proc])
    monkeypatch.setattr("server_manager.subprocess.Popen", popen)

    data = manager.start()

    assert data["telegram_status"] == "started"
    assert data["telegram_pid"] == 67890
    assert manager.telegram_pid_path.read_text(encoding="utf-8") == "67890"
    bot_args = popen.call_args_list[1].args[0]
    assert Path(bot_args[1]).name == "telegram_bot.py"


def test_start_spawns_crm_telegram_bot_when_sales_token_configured(tmp_path, monkeypatch):
    telegram_script = tmp_path / "telegram_bot.py"
    telegram_script.write_text("print('bot')", encoding="utf-8")
    crm_script = tmp_path / "crm_telegram_bot.py"
    crm_script.write_text("print('crm bot')", encoding="utf-8")
    env_file = tmp_path / ".env"
    env_file.write_text("SALES_TELEGRAM_BOT_TOKEN=123:token\n", encoding="utf-8")
    manager = ServerManager(
        state_dir=tmp_path / "state",
        telegram_script=telegram_script,
        telegram_token_file=tmp_path / "missing_token.txt",
        crm_telegram_script=crm_script,
        env_file=env_file,
        auto_worker_script=tmp_path / "missing_worker.py",
        parallel_supervisor_script=tmp_path / "missing_supervisor.py",
    )
    fake_api_proc = Mock()
    fake_api_proc.pid = 12345
    fake_api_proc.poll.return_value = None
    fake_crm_proc = Mock()
    fake_crm_proc.pid = 23456
    fake_crm_proc.poll.return_value = None
    monkeypatch.setattr(manager, "_api_online", lambda: False)
    monkeypatch.setattr(manager, "_wait_api", lambda timeout=10.0: True)
    popen = Mock(side_effect=[fake_api_proc, fake_crm_proc])
    monkeypatch.setattr("server_manager.subprocess.Popen", popen)

    data = manager.start()

    assert data["crm_telegram_status"] == "started"
    assert data["crm_telegram_pid"] == 23456
    assert manager.crm_telegram_pid_path.read_text(encoding="utf-8") == "23456"
    crm_args = popen.call_args_list[1].args[0]
    assert Path(crm_args[1]).name == "crm_telegram_bot.py"


def test_status_reports_crm_telegram_fields(tmp_path, monkeypatch):
    crm_script = tmp_path / "crm_telegram_bot.py"
    crm_script.write_text("print('crm bot')", encoding="utf-8")
    env_file = tmp_path / ".env"
    env_file.write_text("SALES_TELEGRAM_BOT_TOKEN=123:token\n", encoding="utf-8")
    manager = ServerManager(
        state_dir=tmp_path / "state",
        telegram_token_file=tmp_path / "missing_token.txt",
        crm_telegram_script=crm_script,
        env_file=env_file,
        auto_worker_script=tmp_path / "missing_worker.py",
        parallel_supervisor_script=tmp_path / "missing_supervisor.py",
    )
    manager._write_pid_to(manager.crm_telegram_pid_path, 23456)
    monkeypatch.setattr(manager, "_api_online", lambda: True)
    monkeypatch.setattr(manager, "_pid_running", lambda pid: pid == 23456)

    data = manager.status()

    assert data["crm_telegram_configured"] is True
    assert data["crm_telegram_managed"] is True
    assert data["crm_telegram_pid"] == 23456
    assert data["crm_telegram_log_path"].endswith("crm_telegram_bot.log")

def test_start_spawns_auto_learning_worker(tmp_path, monkeypatch):
    worker_script = tmp_path / "auto_learning_worker.py"
    worker_script.write_text("print('worker')", encoding="utf-8")
    manager = ServerManager(
        state_dir=tmp_path / "state",
        telegram_token_file=tmp_path / "missing_token.txt",
        crm_telegram_script=tmp_path / "missing_crm.py",
        auto_worker_script=worker_script,
        parallel_supervisor_script=tmp_path / "missing_supervisor.py",
    )
    fake_api_proc = Mock()
    fake_api_proc.pid = 12345
    fake_api_proc.poll.return_value = None
    fake_worker_proc = Mock()
    fake_worker_proc.pid = 24680
    fake_worker_proc.poll.return_value = None
    monkeypatch.setattr(manager, "_api_online", lambda: False)
    monkeypatch.setattr(manager, "_wait_api", lambda timeout=10.0: True)
    popen = Mock(side_effect=[fake_api_proc, fake_worker_proc])
    monkeypatch.setattr("server_manager.subprocess.Popen", popen)

    data = manager.start()

    assert data["auto_worker_status"] == "started"
    assert data["auto_worker_pid"] == 24680
    worker_args = popen.call_args_list[1].args[0]
    assert Path(worker_args[1]).name == "auto_learning_worker.py"
    worker_env = popen.call_args_list[1].kwargs["env"]
    assert worker_env["EA_KB_AUTOPILOT_YOUTUBE_ENABLED"] == "0"
    assert worker_env["EA_KB_AUTOPILOT_LOCAL_VIDEO_ENABLED"] == "1"
    assert worker_env["EA_KB_LOCAL_VIDEO_INBOX_DIR"] == r"G:\My Drive\YT_Downloads"


def test_start_spawns_parallel_agent_supervisor(tmp_path, monkeypatch):
    supervisor_script = tmp_path / "parallel_agent_supervisor.py"
    supervisor_script.write_text("print('supervisor')", encoding="utf-8")
    manager = ServerManager(
        state_dir=tmp_path / "state",
        telegram_token_file=tmp_path / "missing_token.txt",
        crm_telegram_script=tmp_path / "missing_crm.py",
        auto_worker_script=tmp_path / "missing_worker.py",
        parallel_supervisor_script=supervisor_script,
    )
    fake_api_proc = Mock()
    fake_api_proc.pid = 12345
    fake_api_proc.poll.return_value = None
    fake_supervisor_proc = Mock()
    fake_supervisor_proc.pid = 13579
    fake_supervisor_proc.poll.return_value = None
    monkeypatch.setattr(manager, "_api_online", lambda: False)
    monkeypatch.setattr(manager, "_wait_api", lambda timeout=10.0: True)
    popen = Mock(side_effect=[fake_api_proc, fake_supervisor_proc])
    monkeypatch.setattr("server_manager.subprocess.Popen", popen)

    data = manager.start()

    assert data["parallel_supervisor_status"] == "started"
    assert data["parallel_supervisor_pid"] == 13579
    supervisor_args = popen.call_args_list[1].args[0]
    assert Path(supervisor_args[1]).name == "parallel_agent_supervisor.py"


def test_status_reports_parallel_supervisor_fields(tmp_path, monkeypatch):
    supervisor_script = tmp_path / "parallel_agent_supervisor.py"
    supervisor_script.write_text("print('supervisor')", encoding="utf-8")
    manager = ServerManager(
        state_dir=tmp_path / "state",
        telegram_token_file=tmp_path / "missing_token.txt",
        crm_telegram_script=tmp_path / "missing_crm.py",
        auto_worker_script=tmp_path / "missing_worker.py",
        parallel_supervisor_script=supervisor_script,
    )
    manager._write_pid_to(manager.parallel_supervisor_pid_path, 13579)
    monkeypatch.setattr(manager, "_api_online", lambda: True)
    monkeypatch.setattr(manager, "_pid_running", lambda pid: pid == 13579)

    data = manager.status()

    assert data["parallel_supervisor_available"] is True
    assert data["parallel_supervisor_managed"] is True
    assert data["parallel_supervisor_pid"] == 13579
    assert data["parallel_supervisor_log_path"].endswith("parallel_agent_supervisor.log")


def test_start_starts_telegram_even_when_api_already_online(tmp_path, monkeypatch):
    telegram_script = tmp_path / "telegram_bot.py"
    telegram_script.write_text("print('bot')", encoding="utf-8")
    token_file = tmp_path / "telegram_token.txt"
    token_file.write_text("123:token", encoding="utf-8")
    manager = ServerManager(
        state_dir=tmp_path / "state",
        telegram_script=telegram_script,
        telegram_token_file=token_file,
        crm_telegram_script=tmp_path / "missing_crm.py",
        auto_worker_script=tmp_path / "missing_worker.py",
        parallel_supervisor_script=tmp_path / "missing_supervisor.py",
    )
    fake_bot_proc = Mock()
    fake_bot_proc.pid = 67890
    fake_bot_proc.poll.return_value = None
    monkeypatch.setattr(manager, "_api_online", lambda: True)
    monkeypatch.setattr(manager, "_find_api_server_pid", lambda: None)
    popen = Mock(return_value=fake_bot_proc)
    monkeypatch.setattr("server_manager.subprocess.Popen", popen)

    data = manager.start()

    assert data["status"] == "already_running"
    assert data["telegram_status"] == "started"
    popen.assert_called_once()


def test_start_does_not_spawn_duplicate_telegram_bot(tmp_path, monkeypatch):
    telegram_script = tmp_path / "telegram_bot.py"
    telegram_script.write_text("print('bot')", encoding="utf-8")
    token_file = tmp_path / "telegram_token.txt"
    token_file.write_text("123:token", encoding="utf-8")
    manager = ServerManager(
        state_dir=tmp_path / "state",
        telegram_script=telegram_script,
        telegram_token_file=token_file,
        crm_telegram_script=tmp_path / "missing_crm.py",
        auto_worker_script=tmp_path / "missing_worker.py",
        parallel_supervisor_script=tmp_path / "missing_supervisor.py",
    )
    manager._write_pid_to(manager.telegram_pid_path, 67890)
    monkeypatch.setattr(manager, "_api_online", lambda: True)
    monkeypatch.setattr(manager, "_find_api_server_pid", lambda: None)
    monkeypatch.setattr(manager, "_pid_running", lambda pid: pid == 67890)
    popen = Mock()
    monkeypatch.setattr("server_manager.subprocess.Popen", popen)

    data = manager.start()

    assert data["telegram_status"] == "already_running"
    assert data["telegram_pid"] == 67890
    popen.assert_not_called()


def test_start_adopts_running_auxiliary_services_when_pid_files_missing(tmp_path, monkeypatch):
    crm_script = tmp_path / "crm_telegram_bot.py"
    crm_script.write_text("print('crm')", encoding="utf-8")
    worker_script = tmp_path / "auto_learning_worker.py"
    worker_script.write_text("print('worker')", encoding="utf-8")
    supervisor_script = tmp_path / "parallel_agent_supervisor.py"
    supervisor_script.write_text("print('supervisor')", encoding="utf-8")
    env_file = tmp_path / ".env"
    env_file.write_text("SALES_TELEGRAM_BOT_TOKEN=123:token\n", encoding="utf-8")
    manager = ServerManager(
        state_dir=tmp_path / "state",
        telegram_token_file=tmp_path / "missing_token.txt",
        crm_telegram_script=crm_script,
        env_file=env_file,
        auto_worker_script=worker_script,
        parallel_supervisor_script=supervisor_script,
    )
    existing = {
        crm_script: 23456,
        worker_script: 24680,
        supervisor_script: 13579,
    }
    monkeypatch.setattr(manager, "_api_online", lambda: True)
    monkeypatch.setattr(manager, "_find_api_server_pid", lambda: None)
    monkeypatch.setattr(manager, "_pid_running", lambda pid: pid in existing.values())
    monkeypatch.setattr(manager, "_find_process_pid_by_script", lambda script: existing.get(Path(script)))
    popen = Mock()
    monkeypatch.setattr("server_manager.subprocess.Popen", popen)

    data = manager.start()

    assert data["crm_telegram_status"] == "already_running"
    assert data["crm_telegram_pid"] == 23456
    assert manager.crm_telegram_pid_path.read_text(encoding="utf-8") == "23456"
    assert data["auto_worker_status"] == "already_running"
    assert data["auto_worker_pid"] == 24680
    assert manager.auto_worker_pid_path.read_text(encoding="utf-8") == "24680"
    assert data["parallel_supervisor_status"] == "already_running"
    assert data["parallel_supervisor_pid"] == 13579
    assert manager.parallel_supervisor_pid_path.read_text(encoding="utf-8") == "13579"
    popen.assert_not_called()


def test_start_does_not_spawn_when_api_already_online(tmp_path, monkeypatch):
    manager = ServerManager(
        state_dir=tmp_path,
        telegram_token_file=tmp_path / "missing_token.txt",
        crm_telegram_script=tmp_path / "missing_crm.py",
        auto_worker_script=tmp_path / "missing_worker.py",
        parallel_supervisor_script=tmp_path / "missing_supervisor.py",
    )
    monkeypatch.setattr(manager, "_api_online", lambda: True)
    monkeypatch.setattr(manager, "_find_api_server_pid", lambda: None)
    popen = Mock()
    monkeypatch.setattr("server_manager.subprocess.Popen", popen)

    data = manager.start()

    assert data["status"] == "already_running"
    assert data["api_online"] is True
    popen.assert_not_called()


def test_stop_terminates_owned_process(tmp_path, monkeypatch):
    manager = ServerManager(state_dir=tmp_path)
    fake_proc = Mock()
    fake_proc.pid = 222
    fake_proc.poll.return_value = None
    manager.process = fake_proc
    manager._write_pid(222)
    monkeypatch.setattr(manager, "_pid_running", lambda pid: True)

    data = manager.stop()

    assert data["status"] == "stopped"
    fake_proc.terminate.assert_called_once()
    assert not manager.pid_path.exists()


def test_restart_stops_then_starts(tmp_path, monkeypatch):
    manager = ServerManager(state_dir=tmp_path)
    calls = []
    monkeypatch.setattr(manager, "stop", lambda: calls.append("stop") or {"status": "stopped"})
    monkeypatch.setattr(manager, "start", lambda: calls.append("start") or {"status": "started", "pid": 7})

    data = manager.restart()

    assert calls == ["stop", "start"]
    assert data["status"] == "restarted"
    assert data["start"]["pid"] == 7


def test_pid_running_windows_uses_tasklist_output(tmp_path, monkeypatch):
    manager = ServerManager(state_dir=tmp_path)
    monkeypatch.setattr("server_manager.sys.platform", "win32")
    monkeypatch.setattr(
        "server_manager.subprocess.run",
        lambda *args, **kwargs: Mock(stdout='"python.exe","4321","Console","1","10,000 K"'),
    )

    assert manager._pid_running(4321) is True


def test_find_process_pid_by_script_matches_relative_cmdline_in_script_cwd(tmp_path, monkeypatch):
    script_path = tmp_path / "crm_telegram_bot.py"
    script_path.write_text("print('bot')", encoding="utf-8")
    manager = ServerManager(state_dir=tmp_path, crm_telegram_script=script_path)

    class FakeProcess:
        info = {"pid": 4321, "cmdline": ["py", "-3.13", "crm_telegram_bot.py"]}

        def cwd(self):
            return str(tmp_path)

    fake_psutil = Mock()
    fake_psutil.process_iter.return_value = [FakeProcess()]
    fake_psutil.NoSuchProcess = RuntimeError
    fake_psutil.AccessDenied = RuntimeError
    monkeypatch.setitem(sys.modules, "psutil", fake_psutil)
    monkeypatch.setattr(
        "server_manager.subprocess.run",
        Mock(side_effect=AssertionError("slow fallback should not be used")),
    )

    assert manager._find_process_pid_by_script(script_path) == 4321


def test_find_process_pid_by_script_skips_slow_fallback_after_successful_psutil_scan(tmp_path, monkeypatch):
    script_path = tmp_path / "auto_learning_worker.py"
    script_path.write_text("print('worker')", encoding="utf-8")
    manager = ServerManager(auto_worker_script=script_path)

    fake_psutil = Mock()
    fake_psutil.process_iter.return_value = []
    fake_psutil.NoSuchProcess = RuntimeError
    fake_psutil.AccessDenied = RuntimeError
    monkeypatch.setitem(sys.modules, "psutil", fake_psutil)
    slow_fallback = Mock(return_value=Mock(stdout=""))
    monkeypatch.setattr("server_manager.subprocess.run", slow_fallback)

    assert manager._find_process_pid_by_script(script_path) is None
    slow_fallback.assert_not_called()


def test_manager_status_endpoint_returns_json(tmp_path, monkeypatch):
    manager = ServerManager(state_dir=tmp_path)
    monkeypatch.setattr(manager, "_api_online", lambda: False)
    app = create_app(manager)

    resp = app.test_client().get("/api/manager/status")

    assert resp.status_code == 200
    assert resp.get_json()["manager_online"] is True
    assert resp.headers["Access-Control-Allow-Origin"] == "*"


def test_manager_start_endpoint_calls_manager(tmp_path, monkeypatch):
    manager = ServerManager(state_dir=tmp_path)
    monkeypatch.setattr(manager, "start", lambda: {"status": "started", "pid": 123})
    app = create_app(manager)

    data = app.test_client().post("/api/manager/start").get_json()

    assert data["status"] == "started"
    assert data["pid"] == 123
