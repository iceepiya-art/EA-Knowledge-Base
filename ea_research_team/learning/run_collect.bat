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
  exit /b 1
)

call "%PYTHON_CMD%" run.py collect
