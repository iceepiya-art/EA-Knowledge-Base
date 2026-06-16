"""Small process manager for the EA Knowledge Brain Flask API.

Run this file once, then the dashboard can start/stop/restart server.py.
"""
from __future__ import annotations

import json
import os
import signal
import subprocess
import sys
import time
import urllib.request
import urllib.parse
from pathlib import Path
from typing import Any

from flask import Flask, Response, jsonify


ROOT = Path(__file__).resolve().parents[2]
LEARNING_DIR = Path(__file__).resolve().parent
SERVER_SCRIPT = LEARNING_DIR / "server.py"
TELEGRAM_SCRIPT = LEARNING_DIR / "telegram_bot.py"
TELEGRAM_TOKEN_FILE = LEARNING_DIR / "telegram_token.txt"
AUTO_WORKER_SCRIPT = LEARNING_DIR / "auto_learning_worker.py"
PARALLEL_SUPERVISOR_SCRIPT = LEARNING_DIR / "parallel_agent_supervisor.py"
DEFAULT_STATE_DIR = LEARNING_DIR / ".server_manager"
DEFAULT_API_STATUS_URL = "http://127.0.0.1:5000/api/learning/health"
DEFAULT_API_STATUS_TIMEOUT = 3.0


def _cors(resp: Response) -> Response:
    resp.headers["Access-Control-Allow-Origin"] = "*"
    resp.headers["Access-Control-Allow-Headers"] = "Content-Type"
    resp.headers["Access-Control-Allow-Methods"] = "GET, POST, OPTIONS"
    return resp


def _json(data: Any, status: int = 200) -> Response:
    resp = jsonify(data)
    resp.status_code = status
    return _cors(resp)


class ServerManager:
    def __init__(
        self,
        *,
        state_dir: str | Path = DEFAULT_STATE_DIR,
        api_status_url: str = DEFAULT_API_STATUS_URL,
        server_script: str | Path = SERVER_SCRIPT,
        telegram_script: str | Path = TELEGRAM_SCRIPT,
        telegram_token_file: str | Path = TELEGRAM_TOKEN_FILE,
        auto_worker_script: str | Path = AUTO_WORKER_SCRIPT,
        parallel_supervisor_script: str | Path = PARALLEL_SUPERVISOR_SCRIPT,
        api_status_timeout: float = DEFAULT_API_STATUS_TIMEOUT,
    ) -> None:
        self.state_dir = Path(state_dir)
        self.state_dir.mkdir(parents=True, exist_ok=True)
        self.pid_path = self.state_dir / "api_server.pid"
        self.log_path = self.state_dir / "api_server.log"
        self.telegram_pid_path = self.state_dir / "telegram_bot.pid"
        self.telegram_log_path = self.state_dir / "telegram_bot.log"
        self.auto_worker_pid_path = self.state_dir / "auto_learning_worker.pid"
        self.auto_worker_log_path = self.state_dir / "auto_learning_worker.log"
        self.parallel_supervisor_pid_path = self.state_dir / "parallel_agent_supervisor.pid"
        self.parallel_supervisor_log_path = self.state_dir / "parallel_agent_supervisor.log"
        self.api_status_url = api_status_url
        self.api_status_timeout = api_status_timeout
        self.server_script = Path(server_script)
        self.telegram_script = Path(telegram_script)
        self.telegram_token_file = Path(telegram_token_file)
        self.auto_worker_script = Path(auto_worker_script)
        self.parallel_supervisor_script = Path(parallel_supervisor_script)
        self.process: subprocess.Popen | None = None
        self.telegram_process: subprocess.Popen | None = None
        self.auto_worker_process: subprocess.Popen | None = None
        self.parallel_supervisor_process: subprocess.Popen | None = None
        self._log_handle = None
        self._telegram_log_handle = None
        self._auto_worker_log_handle = None
        self._parallel_supervisor_log_handle = None

    def status(self) -> dict[str, Any]:
        pid = self._read_pid()
        managed = bool(pid and self._pid_running(pid))
        if pid and not managed:
            self._clear_pid()
            pid = None
        api_online = self._api_online()
        if api_online:
            listener_pid = self._find_api_server_pid()
            if listener_pid and self._pid_running(listener_pid) and listener_pid != pid:
                self._write_pid(listener_pid)
                pid = listener_pid
                managed = True
        if not managed and api_online:
            pid = self._adopt_external_api_process()
            managed = bool(pid and self._pid_running(pid))
        telegram = self._telegram_status()
        auto_worker = self._auto_worker_status()
        parallel_supervisor = self._parallel_supervisor_status()
        return {
            "manager_online": True,
            "api_online": api_online,
            "managed": managed,
            "pid": pid if managed else None,
            "telegram_configured": self._telegram_configured(),
            "telegram_managed": telegram["managed"],
            "telegram_pid": telegram["pid"],
            "telegram_log_path": str(self.telegram_log_path),
            "auto_worker_available": self.auto_worker_script.exists(),
            "auto_worker_managed": auto_worker["managed"],
            "auto_worker_pid": auto_worker["pid"],
            "auto_worker_log_path": str(self.auto_worker_log_path),
            "parallel_supervisor_available": self.parallel_supervisor_script.exists(),
            "parallel_supervisor_managed": parallel_supervisor["managed"],
            "parallel_supervisor_pid": parallel_supervisor["pid"],
            "parallel_supervisor_log_path": str(self.parallel_supervisor_log_path),
            "api_url": self.api_status_url.replace("/api/learning/health", "").replace("/api/learning/status", ""),
            "log_path": str(self.log_path),
            "start_command": (
                f'cd "{LEARNING_DIR}" && python server_manager.py'
            ),
        }

    def start(self) -> dict[str, Any]:
        current = self.status()
        if current["api_online"]:
            telegram = self._ensure_telegram_bot()
            auto_worker = self._ensure_auto_worker()
            parallel_supervisor = self._ensure_parallel_supervisor()
            return {**current, "status": "already_running", **telegram, **auto_worker, **parallel_supervisor}

        env = os.environ.copy()
        env["EA_KB_NO_RELOADER"] = "1"
        env["PYTHONUNBUFFERED"] = "1"
        self._log_handle = self.log_path.open("a", encoding="utf-8")
        self.process = subprocess.Popen(
            [sys.executable, str(self.server_script)],
            cwd=str(self.server_script.parent),
            stdout=self._log_handle,
            stderr=subprocess.STDOUT,
            env=env,
        )
        self._write_pid(self.process.pid)
        api_online = self._wait_api()
        telegram = self._ensure_telegram_bot()
        auto_worker = self._ensure_auto_worker()
        parallel_supervisor = self._ensure_parallel_supervisor()
        return {
            "status": "started",
            "pid": self.process.pid,
            "api_online": api_online,
            "managed": True,
            "log_path": str(self.log_path),
            **telegram,
            **auto_worker,
            **parallel_supervisor,
        }

    def stop(self) -> dict[str, Any]:
        telegram = self._stop_telegram_bot()
        auto_worker = self._stop_auto_worker()
        parallel_supervisor = self._stop_parallel_supervisor()
        pid = self._read_pid()
        if not pid:
            return {
                "status": "not_running",
                "stopped": False,
                "api_online": self._api_online(),
                "telegram": telegram,
                "auto_worker": auto_worker,
                "parallel_supervisor": parallel_supervisor,
            }

        if self.process and self.process.poll() is None:
            self.process.terminate()
            try:
                self.process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                self.process.kill()
                self.process.wait(timeout=5)
        elif self._pid_running(pid):
            os.kill(pid, signal.SIGTERM)
            deadline = time.time() + 5
            while time.time() < deadline and self._pid_running(pid):
                time.sleep(0.1)
            if self._pid_running(pid):
                os.kill(pid, signal.SIGTERM)

        self._clear_pid()
        return {
            "status": "stopped",
            "stopped": True,
            "pid": pid,
            "api_online": self._api_online(),
            "telegram": telegram,
            "auto_worker": auto_worker,
            "parallel_supervisor": parallel_supervisor,
        }

    def restart(self) -> dict[str, Any]:
        stopped = self.stop()
        started = self.start()
        return {"status": "restarted", "stop": stopped, "start": started}

    def _api_online(self) -> bool:
        try:
            with urllib.request.urlopen(self.api_status_url, timeout=self.api_status_timeout) as resp:
                return 200 <= resp.status < 500
        except Exception:
            return False

    def _wait_api(self, timeout: float = 10.0) -> bool:
        deadline = time.time() + timeout
        while time.time() < deadline:
            if self._api_online():
                return True
            time.sleep(0.25)
        return False

    def _adopt_external_api_process(self) -> int | None:
        pid = self._find_api_server_pid()
        if not pid or not self._pid_running(pid):
            return None
        self._write_pid(pid)
        return pid

    def _find_api_server_pid(self) -> int | None:
        parsed = urllib.parse.urlparse(self.api_status_url)
        port = parsed.port
        if not port or not sys.platform.startswith("win"):
            return None
        try:
            result = subprocess.run(
                [
                    "powershell",
                    "-NoProfile",
                    "-Command",
                    f"Get-NetTCPConnection -LocalPort {port} -State Listen | Select-Object -First 1 -ExpandProperty OwningProcess",
                ],
                capture_output=True,
                text=True,
                timeout=3,
            )
            pid_text = result.stdout.strip().splitlines()[0] if result.stdout.strip() else ""
            pid = int(pid_text)
        except Exception:
            return None
        command_line = self._process_command_line(pid)
        if "server.py" not in command_line:
            return None
        return pid

    def _process_command_line(self, pid: int) -> str:
        if not sys.platform.startswith("win"):
            return ""
        try:
            result = subprocess.run(
                [
                    "powershell",
                    "-NoProfile",
                    "-Command",
                    f"(Get-CimInstance Win32_Process -Filter \"ProcessId={pid}\").CommandLine",
                ],
                capture_output=True,
                text=True,
                timeout=3,
            )
            return result.stdout.strip()
        except Exception:
            return ""

    def _pid_running(self, pid: int) -> bool:
        if sys.platform.startswith("win"):
            try:
                result = subprocess.run(
                    ["tasklist", "/FI", f"PID eq {pid}", "/FO", "CSV", "/NH"],
                    capture_output=True,
                    text=True,
                    timeout=2,
                )
                return f'"{pid}"' in result.stdout or f",{pid}," in result.stdout
            except Exception:
                return False
        try:
            os.kill(pid, 0)
            return True
        except PermissionError:
            return True
        except OSError:
            return False

    def _telegram_configured(self) -> bool:
        return bool(os.environ.get("TELEGRAM_BOT_TOKEN")) or self.telegram_token_file.exists()

    def _telegram_status(self) -> dict[str, Any]:
        pid = self._read_pid_from(self.telegram_pid_path)
        managed = bool(pid and self._pid_running(pid))
        if pid and not managed:
            self._clear_pid_path(self.telegram_pid_path)
            pid = None
        return {"managed": managed, "pid": pid if managed else None}

    def _ensure_telegram_bot(self) -> dict[str, Any]:
        if not self._telegram_configured():
            self._clear_pid_path(self.telegram_pid_path)
            return {
                "telegram_status": "unconfigured",
                "telegram_pid": None,
                "telegram_managed": False,
                "telegram_log_path": str(self.telegram_log_path),
            }

        current = self._telegram_status()
        if current["managed"]:
            return {
                "telegram_status": "already_running",
                "telegram_pid": current["pid"],
                "telegram_managed": True,
                "telegram_log_path": str(self.telegram_log_path),
            }

        env = os.environ.copy()
        env["PYTHONUNBUFFERED"] = "1"
        self._telegram_log_handle = self.telegram_log_path.open("a", encoding="utf-8")
        self.telegram_process = subprocess.Popen(
            [sys.executable, str(self.telegram_script)],
            cwd=str(self.telegram_script.parent),
            stdout=self._telegram_log_handle,
            stderr=subprocess.STDOUT,
            env=env,
        )
        self._write_pid_to(self.telegram_pid_path, self.telegram_process.pid)
        return {
            "telegram_status": "started",
            "telegram_pid": self.telegram_process.pid,
            "telegram_managed": True,
            "telegram_log_path": str(self.telegram_log_path),
        }

    def _stop_telegram_bot(self) -> dict[str, Any]:
        pid = self._read_pid_from(self.telegram_pid_path)
        if not pid:
            return {"status": "not_running", "stopped": False}

        if self.telegram_process and self.telegram_process.poll() is None:
            self.telegram_process.terminate()
            try:
                self.telegram_process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                self.telegram_process.kill()
                self.telegram_process.wait(timeout=5)
        elif self._pid_running(pid):
            os.kill(pid, signal.SIGTERM)
            deadline = time.time() + 5
            while time.time() < deadline and self._pid_running(pid):
                time.sleep(0.1)
            if self._pid_running(pid):
                os.kill(pid, signal.SIGTERM)

        self._clear_pid_path(self.telegram_pid_path)
        return {"status": "stopped", "stopped": True, "pid": pid}

    def _auto_worker_status(self) -> dict[str, Any]:
        pid = self._read_pid_from(self.auto_worker_pid_path)
        managed = bool(pid and self._pid_running(pid))
        if pid and not managed:
            self._clear_pid_path(self.auto_worker_pid_path)
            pid = None
        return {"managed": managed, "pid": pid if managed else None}

    def _parallel_supervisor_status(self) -> dict[str, Any]:
        pid = self._read_pid_from(self.parallel_supervisor_pid_path)
        managed = bool(pid and self._pid_running(pid))
        if pid and not managed:
            self._clear_pid_path(self.parallel_supervisor_pid_path)
            pid = None
        return {"managed": managed, "pid": pid if managed else None}

    def _ensure_auto_worker(self) -> dict[str, Any]:
        if not self.auto_worker_script.exists():
            self._clear_pid_path(self.auto_worker_pid_path)
            return {
                "auto_worker_status": "unavailable",
                "auto_worker_pid": None,
                "auto_worker_managed": False,
                "auto_worker_log_path": str(self.auto_worker_log_path),
            }

        current = self._auto_worker_status()
        if current["managed"]:
            return {
                "auto_worker_status": "already_running",
                "auto_worker_pid": current["pid"],
                "auto_worker_managed": True,
                "auto_worker_log_path": str(self.auto_worker_log_path),
            }

        env = os.environ.copy()
        env.setdefault("ORCA_TRANSCRIPTION_ENGINES", "faster_whisper")
        env.setdefault("EA_KB_AUTOPILOT_YOUTUBE_ENABLED", "0")
        env.setdefault("EA_KB_AUTOPILOT_LOCAL_VIDEO_ENABLED", "1")
        env.setdefault("EA_KB_LOCAL_VIDEO_INBOX_DIR", r"G:\My Drive\YT_Downloads")
        env.setdefault("EA_KB_AUTOPILOT_LIMIT", "1")
        env["PYTHONUNBUFFERED"] = "1"
        self._auto_worker_log_handle = self.auto_worker_log_path.open("a", encoding="utf-8")
        self.auto_worker_process = subprocess.Popen(
            [sys.executable, str(self.auto_worker_script)],
            cwd=str(self.auto_worker_script.parent),
            stdout=self._auto_worker_log_handle,
            stderr=subprocess.STDOUT,
            env=env,
        )
        self._write_pid_to(self.auto_worker_pid_path, self.auto_worker_process.pid)
        return {
            "auto_worker_status": "started",
            "auto_worker_pid": self.auto_worker_process.pid,
            "auto_worker_managed": True,
            "auto_worker_log_path": str(self.auto_worker_log_path),
        }

    def _stop_auto_worker(self) -> dict[str, Any]:
        pid = self._read_pid_from(self.auto_worker_pid_path)
        if not pid:
            return {"status": "not_running", "stopped": False}

        if self.auto_worker_process and self.auto_worker_process.poll() is None:
            self.auto_worker_process.terminate()
            try:
                self.auto_worker_process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                self.auto_worker_process.kill()
                self.auto_worker_process.wait(timeout=5)
        elif self._pid_running(pid):
            os.kill(pid, signal.SIGTERM)
            deadline = time.time() + 5
            while time.time() < deadline and self._pid_running(pid):
                time.sleep(0.1)
            if self._pid_running(pid):
                os.kill(pid, signal.SIGTERM)

        self._clear_pid_path(self.auto_worker_pid_path)
        return {"status": "stopped", "stopped": True, "pid": pid}

    def _ensure_parallel_supervisor(self) -> dict[str, Any]:
        if not self.parallel_supervisor_script.exists():
            self._clear_pid_path(self.parallel_supervisor_pid_path)
            return {
                "parallel_supervisor_status": "unavailable",
                "parallel_supervisor_pid": None,
                "parallel_supervisor_managed": False,
                "parallel_supervisor_log_path": str(self.parallel_supervisor_log_path),
            }

        current = self._parallel_supervisor_status()
        if current["managed"]:
            return {
                "parallel_supervisor_status": "already_running",
                "parallel_supervisor_pid": current["pid"],
                "parallel_supervisor_managed": True,
                "parallel_supervisor_log_path": str(self.parallel_supervisor_log_path),
            }

        env = os.environ.copy()
        env["PYTHONUNBUFFERED"] = "1"
        self._parallel_supervisor_log_handle = self.parallel_supervisor_log_path.open("a", encoding="utf-8")
        self.parallel_supervisor_process = subprocess.Popen(
            [sys.executable, str(self.parallel_supervisor_script)],
            cwd=str(self.parallel_supervisor_script.parent),
            stdout=self._parallel_supervisor_log_handle,
            stderr=subprocess.STDOUT,
            env=env,
        )
        self._write_pid_to(self.parallel_supervisor_pid_path, self.parallel_supervisor_process.pid)
        return {
            "parallel_supervisor_status": "started",
            "parallel_supervisor_pid": self.parallel_supervisor_process.pid,
            "parallel_supervisor_managed": True,
            "parallel_supervisor_log_path": str(self.parallel_supervisor_log_path),
        }

    def _stop_parallel_supervisor(self) -> dict[str, Any]:
        pid = self._read_pid_from(self.parallel_supervisor_pid_path)
        if not pid:
            return {"status": "not_running", "stopped": False}

        if self.parallel_supervisor_process and self.parallel_supervisor_process.poll() is None:
            self.parallel_supervisor_process.terminate()
            try:
                self.parallel_supervisor_process.wait(timeout=5)
            except subprocess.TimeoutExpired:
                self.parallel_supervisor_process.kill()
                self.parallel_supervisor_process.wait(timeout=5)
        elif self._pid_running(pid):
            os.kill(pid, signal.SIGTERM)
            deadline = time.time() + 5
            while time.time() < deadline and self._pid_running(pid):
                time.sleep(0.1)
            if self._pid_running(pid):
                os.kill(pid, signal.SIGTERM)

        self._clear_pid_path(self.parallel_supervisor_pid_path)
        return {"status": "stopped", "stopped": True, "pid": pid}

    def _read_pid(self) -> int | None:
        return self._read_pid_from(self.pid_path)

    def _read_pid_from(self, path: Path) -> int | None:
        if not path.exists():
            return None
        try:
            return int(path.read_text(encoding="utf-8").strip())
        except ValueError:
            self._clear_pid_path(path)
            return None

    def _write_pid(self, pid: int) -> None:
        self._write_pid_to(self.pid_path, pid)

    def _write_pid_to(self, path: Path, pid: int) -> None:
        tmp = path.with_suffix(".tmp")
        tmp.write_text(str(pid), encoding="utf-8")
        tmp.replace(path)

    def _clear_pid(self) -> None:
        self._clear_pid_path(self.pid_path)

    def _clear_pid_path(self, path: Path) -> None:
        if path.exists():
            path.unlink()


def create_app(manager: ServerManager | None = None) -> Flask:
    app = Flask(__name__)
    manager = manager or ServerManager()

    @app.before_request
    def handle_options():
        from flask import request
        if request.method == "OPTIONS":
            return _cors(Response("", status=204))
        return None

    @app.route("/api/manager/status")
    def get_status():
        return _json(manager.status())

    @app.route("/api/manager/start", methods=["POST"])
    def post_start():
        return _json(manager.start())

    @app.route("/api/manager/stop", methods=["POST"])
    def post_stop():
        return _json(manager.stop())

    @app.route("/api/manager/restart", methods=["POST"])
    def post_restart():
        return _json(manager.restart())

    return app


if __name__ == "__main__":
    app = create_app()
    print("EA Knowledge Brain Server Manager")
    print("  http://localhost:5050")
    print("  GET  /api/manager/status")
    print("  POST /api/manager/start")
    print("  POST /api/manager/stop")
    print("  POST /api/manager/restart")
    app.run(debug=False, port=5050, use_reloader=False)
