@echo off
cd /d "%~dp0"

set "PYTHON_CMD="
set "DEFAULT_PYTHON=C:\Users\ADMIN\AppData\Local\Programs\Python\Python313\python.exe"

if defined PYTHON_EXE (
  if exist "%PYTHON_EXE%" set "PYTHON_CMD=%PYTHON_EXE%"
)

if not defined PYTHON_CMD (
  if exist "%DEFAULT_PYTHON%" set "PYTHON_CMD=%DEFAULT_PYTHON%"
)

if not defined PYTHON_CMD (
  if exist "%~dp0.venv\Scripts\python.exe" set "PYTHON_CMD=%~dp0.venv\Scripts\python.exe"
)

if not defined PYTHON_CMD (
  if exist "%~dp0..\.venv\Scripts\python.exe" set "PYTHON_CMD=%~dp0..\.venv\Scripts\python.exe"
)

if not defined PYTHON_CMD (
  where python >nul 2>nul && set "PYTHON_CMD=python"
)

if not defined PYTHON_CMD (
  where py >nul 2>nul && set "PYTHON_CMD=py -3"
)

if not defined PYTHON_CMD (
  echo [ERROR] Python not found. Set PYTHON_EXE or add Python to PATH.
  pause
  exit /b 1
)

echo Starting Review Server...
start "Learning Review Server" cmd /k ""%PYTHON_CMD%" run.py review"
timeout /t 3 /nobreak > nul
start "" http://127.0.0.1:5055
echo Server should be available at http://127.0.0.1:5055
