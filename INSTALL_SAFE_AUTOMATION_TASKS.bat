@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File AUTOMATION\setup_windows_tasks.ps1
pause
