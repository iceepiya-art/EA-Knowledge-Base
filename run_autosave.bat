@echo off
title Workspace Autosave Daemon
cd /d "%~dp0"
echo [*] Starting Workspace Autosave Daemon...
start "Workspace_Autosave" python scripts/workspace_autosave_daemon.py
echo [✓] Autosave Daemon started.
timeout /t 3
