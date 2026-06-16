@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0register_collect_task.ps1"
pause
