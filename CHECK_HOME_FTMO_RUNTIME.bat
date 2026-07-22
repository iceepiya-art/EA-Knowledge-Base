@echo off
setlocal EnableExtensions
chcp 65001 >nul
title FTMO HOME RUNTIME - SAFE PREFLIGHT
set "ROOT=%~dp0"

echo ========================================================
echo       FTMO HOME RUNTIME - SAFE PREFLIGHT CHECK
echo ========================================================
echo This check is read-only. It never opens MT5 or sends trades.
echo.

set "FAILED=0"

echo [1/4] Checking Python 3.13...
py -3.13 --version
if errorlevel 1 (
  echo [FAIL] Python 3.13 is unavailable.
  set "FAILED=1"
) else (
  echo [OK] Python 3.13 is available.
)

echo.
echo [2/4] Checking machine-local configuration...
if not exist "%ROOT%.env" (
  echo [FAIL] .env is missing. Run SETUP_HOME_RUNTIME.bat, then configure .env.
  set "FAILED=1"
) else (
  echo [OK] .env exists. Values remain private and were not displayed.
)

echo.
echo [3/4] Checking whether an MT5 terminal is already open...
tasklist /FI "IMAGENAME eq terminal64.exe" /NH | findstr /I "terminal64.exe" >nul
if errorlevel 1 (
  echo [WARN] No MT5 terminal process was found. Open FTMO MT5 and verify the selected account manually.
) else (
  echo [OK] An MT5 terminal process is open. Verify the FTMO account number before attaching any EA.
)

echo.
echo [4/4] Checking the local dashboard API...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-RestMethod -Uri 'http://127.0.0.1:5000/dashboard' -TimeoutSec 3 | Out-Null; exit 0 } catch { exit 1 }"
if errorlevel 1 (
  echo [WARN] Dashboard is not running. To start research services only, run START_MASTER_FULL_RESEARCH.bat.
) else (
  echo [OK] Dashboard API is reachable.
)

echo.
if "%FAILED%"=="1" (
  echo [BLOCKED] Resolve the failed checks before using the runtime.
  echo.
  pause
  exit /b 1
)

echo [OK] Runtime preflight completed. No trading action was performed.
echo Next: verify the FTMO account in MT5, then attach the EA manually when you choose.
echo.
pause
exit /b 0
