@echo off
setlocal EnableExtensions
chcp 65001 >nul
title EA KNOWLEDGE BASE - RESTART LOCAL API
set "ROOT=%~dp0"
set "LEARNING=%ROOT%ea_research_team\learning"
set "PY=py -3.13"
set "SIGNAL_URL=http://127.0.0.1:5000/api/signals/latest?symbol=XAUUSD"

echo ========================================================
echo       RESTART CURRENT HOME RUNTIME FLASK API
echo ========================================================
echo This starts only the local Flask API. It does NOT open MT5,
echo attach an EA, enable Algo Trading, or place trades.
echo.

if not exist "%LEARNING%\server.py" (
  echo [FAIL] Runtime server.py is missing: %LEARNING%\server.py
  goto :failed
)

%PY% --version >nul 2>nul
if errorlevel 1 (
  echo [FAIL] Python 3.13 is unavailable.
  goto :failed
)

echo [1/3] Stopping an old local server.py on port 5000 when present...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$listeners=Get-NetTCPConnection -LocalPort 5000 -State Listen -ErrorAction SilentlyContinue; foreach($listener in $listeners){$process=Get-CimInstance Win32_Process -Filter ('ProcessId='+$listener.OwningProcess); if($process.CommandLine -notmatch 'server\.py'){Write-Host '[FAIL] Port 5000 belongs to a non-EA process. It was not stopped.'; exit 1}; Stop-Process -Id $listener.OwningProcess -Force -ErrorAction Stop}; exit 0"
if errorlevel 1 goto :failed

echo [2/3] Starting Flask API from this Runtime copy...
start "EA Knowledge Brain API" /min cmd /c "cd /d ""%LEARNING%"" && set EA_KB_NO_RELOADER=1 && %PY% server.py"

echo [3/3] Verifying the MasterEA signal endpoint...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ready=$false; 1..15 | ForEach-Object { try { $response=Invoke-WebRequest -UseBasicParsing -Uri '%SIGNAL_URL%' -TimeoutSec 2; if($response.StatusCode -eq 200){$ready=$true; break} } catch {}; Start-Sleep -Seconds 1 }; if($ready){Write-Host '[OK] Signal endpoint returned HTTP 200.'; exit 0}; Write-Host '[FAIL] Signal endpoint did not return HTTP 200.'; exit 1"
if errorlevel 1 goto :failed

echo.
echo [OK] Current Runtime API is ready. Verify in a browser:
echo %SIGNAL_URL%
echo.
pause
exit /b 0

:failed
echo.
echo [BLOCKED] API restart was not completed. No trade was opened.
echo.
pause
exit /b 1
