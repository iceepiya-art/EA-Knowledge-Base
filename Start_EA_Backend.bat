@echo off
setlocal EnableExtensions
set "ROOT=%~dp0"
set "LEARNING=%ROOT%ea_research_team\learning"

:: This launcher is intentionally local-runtime only.  It never uses G:\My Drive.
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath 'py' -ArgumentList '-3.13','server.py' -WorkingDirectory '%LEARNING%' -WindowStyle Hidden"

:: Wait for the local Flask API to bind, then report its health.
timeout /t 3 /nobreak > nul
powershell -NoProfile -Command "try { Invoke-WebRequest -UseBasicParsing -TimeoutSec 5 'http://127.0.0.1:5000/api/signals/latest?symbol=XAUUSD' | Out-Null; Write-Host '[OK] Local signal API is reachable.' } catch { Write-Error '[ERROR] Local signal API did not start.'; exit 1 }"
endlocal

