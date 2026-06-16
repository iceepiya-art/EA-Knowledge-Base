@echo off
cd /d "%~dp0"
echo.
echo ============================================
echo  Collect Learning + Open Review
echo ============================================
echo.

set "PYTHON_CMD="
set "DEFAULT_PYTHON=C:\Users\ADMIN\AppData\Local\Programs\Python\Python313\python.exe"

if defined PYTHON_EXE (
  if exist "%PYTHON_EXE%" set "PYTHON_CMD=%PYTHON_EXE%"
)

if not defined PYTHON_CMD (
  if exist "%DEFAULT_PYTHON%" set "PYTHON_CMD=%DEFAULT_PYTHON%"
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

echo [1/2] Collecting new knowledge...
call "%PYTHON_CMD%" run.py collect
if errorlevel 1 (
  echo.
  echo [ERROR] Collect failed.
  pause
  exit /b 1
)

echo.
echo [2/2] Opening review UI...
call "%~dp0start_review.bat"
