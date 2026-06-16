@echo off
setlocal

set "ROOT=%~dp0"
set "LEARNING=%ROOT%ea_research_team\learning"
set "DASHBOARD=%ROOT%00_Dashboard\EA_Knowledge_Brain_Dashboard.html"
set "PY=py -3.13"
set "MANAGER_URL=http://127.0.0.1:5050/api/manager/status"
set "MANAGER_START_URL=http://127.0.0.1:5050/api/manager/start"
set "API_URL=http://127.0.0.1:5000/api/learning/status"
if not defined LOCAL_LLM_URL set "LOCAL_LLM_URL=http://127.0.0.1:1234/v1"
if not defined LOCAL_LLM_API_KEY set "LOCAL_LLM_API_KEY=lm-studio"
if not defined LOCAL_LLM_MODEL set "LOCAL_LLM_MODEL=google/gemma-4-e4b"

echo Starting EA Knowledge Brain...
echo Root: %ROOT%
echo Python: %PY%

powershell -NoProfile -ExecutionPolicy Bypass -Command "if (Get-NetTCPConnection -LocalPort 5050 -State Listen -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }"
if errorlevel 1 (
    echo Starting Server Manager on http://127.0.0.1:5050 ...
    start "EA Knowledge Brain Manager" /min cmd /c "cd /d "%LEARNING%" && %PY% server_manager.py"
    timeout /t 3 /nobreak >nul
) else (
    echo Server Manager already running.
)

echo Ensuring Flask API and Telegram bot are running...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-RestMethod -Method Post -Uri '%MANAGER_START_URL%' -TimeoutSec 15 | Out-Null; exit 0 } catch { exit 1 }"
if errorlevel 1 (
    echo Server Manager start request failed. Checking Flask API fallback...
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-RestMethod -Uri '%API_URL%' -TimeoutSec 2 | Out-Null; exit 0 } catch { exit 1 }"
if errorlevel 1 (
    echo Server Manager did not start the API. Using direct fallback...
    start "EA Knowledge Brain API" /min cmd /c "cd /d "%LEARNING%" && set EA_KB_NO_RELOADER=1 && %PY% server.py"
    timeout /t 5 /nobreak >nul
) else (
    echo Flask API already running.
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-RestMethod -Uri '%MANAGER_URL%' -TimeoutSec 2 | Out-Null; Write-Host 'Server Manager: Online' } catch { Write-Host 'Server Manager: Offline' }; try { Invoke-RestMethod -Uri '%API_URL%' -TimeoutSec 2 | Out-Null; Write-Host 'Flask API: Online' } catch { Write-Host 'Flask API: Offline' }"

start "" "%DASHBOARD%"

echo.
echo Server Manager: http://127.0.0.1:5050
echo Flask API:      http://127.0.0.1:5000
echo Dashboard opened.
echo.

endlocal
