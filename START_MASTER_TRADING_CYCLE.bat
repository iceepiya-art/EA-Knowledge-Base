@echo off
title MASTER AI TRADING CYCLE - DO NOT CLOSE
color 0A

echo ========================================================
echo       STARTING MASTER AI TRADING DESK
echo ========================================================
echo.
echo 1. Connecting to MT5 Terminal (Master Account)...
echo 2. Initializing Hawk and Sage AI Agents...
echo 3. Starting continuous trading cycle...
echo.

chcp 65001 > nul
set PYTHONIOENCODING=utf-8
set "ROOT=%~dp0"
set "LEARNING=%ROOT%ea_research_team\learning"
set "DASHBOARD=%ROOT%00_Dashboard\EA_Knowledge_Brain_Dashboard.html"
set "PY=py -3.13"
set "MANAGER_URL=http://127.0.0.1:5050/api/manager/status"
set "MANAGER_START_URL=http://127.0.0.1:5050/api/manager/start"
set "API_URL=http://127.0.0.1:5000/api/learning/status"

echo Checking and installing required packages...
%PY% -m pip install psutil pandas_ta MetaTrader5 pandas python-dotenv requests pyTelegramBotAPI schedule > nul

powershell -NoProfile -ExecutionPolicy Bypass -Command "if (Get-NetTCPConnection -LocalPort 5050 -State Listen -ErrorAction SilentlyContinue) { exit 0 } else { exit 1 }"
if errorlevel 1 (
    echo Starting Server Manager on http://127.0.0.1:5050 ...
    start "EA Knowledge Brain Manager" /min cmd /c "cd /d ""%LEARNING%"" && %PY% server_manager.py"
    timeout /t 3 /nobreak >nul
) else (
    echo Server Manager already running.
)

echo Ensuring managed backend services are running...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-RestMethod -Method Post -Uri '%MANAGER_START_URL%' -TimeoutSec 15 | Out-Null; exit 0 } catch { exit 1 }"
if errorlevel 1 (
    echo Server Manager start request failed. Direct Flask fallback will be checked below.
)

echo Starting MT5 Terminal automatically...
start "" "C:\Program Files\FTMO Global Markets MT5 Terminal\terminal64.exe"
timeout /t 15 /nobreak >nul

echo Starting EA Knowledge Brain Dashboard...
start "" "%DASHBOARD%"

powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = Get-CimInstance Win32_Process | Where-Object { ($_.Name -match '^(python|py)\.exe$') -and ($_.CommandLine -match 'signal_distributor\.py') }; if ($p) { exit 0 } else { exit 1 }"
if errorlevel 1 (
    echo Starting Signal Distributor on port 5555...
    start "Signal Distributor" /min cmd /c "cd /d ""%~dp0ea_research_team\learning"" && py -3.13 signal_distributor.py"
    timeout /t 2 /nobreak >nul
) else (
    echo [SKIPPED] Signal Distributor is already running!
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-RestMethod -Uri '%API_URL%' -TimeoutSec 2 | Out-Null; exit 0 } catch { exit 1 }"
if errorlevel 1 (
    echo Starting Flask API Server on port 5000...
    start "Flask API Server" /min cmd /c "cd /d ""%LEARNING%"" && set EA_KB_NO_RELOADER=1 && %PY% server.py"
    timeout /t 2 /nobreak >nul
) else (
    echo [SKIPPED] Flask API Server is already running!
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = Get-CimInstance Win32_Process | Where-Object { ($_.Name -match '^(python|py)\.exe$') -and ($_.CommandLine -match 'crm_telegram_bot\.py') }; if ($p) { exit 0 } else { exit 1 }"
if errorlevel 1 (
    echo Starting CRM Telegram Bot...
    start "CRM Telegram Bot" /min cmd /c "cd /d ""%~dp0ea_research_team\learning"" && py -3.13 crm_telegram_bot.py"
    timeout /t 2 /nobreak >nul
) else (
    echo [SKIPPED] CRM Telegram Bot is already running!
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = Get-CimInstance Win32_Process | Where-Object { ($_.Name -match '^(python|py)\.exe$') -and ($_.CommandLine -match 'telegram_sales_bot\.py') }; if ($p) { exit 0 } else { exit 1 }"
if errorlevel 1 (
    echo Starting Sales Telegram Bot...
    start "Sales Telegram Bot" /min cmd /c "cd /d ""%~dp0ea_research_team\learning"" && py -3.13 telegram_sales_bot.py"
    timeout /t 2 /nobreak >nul
) else (
    echo [SKIPPED] Sales Telegram Bot is already running!
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = Get-CimInstance Win32_Process | Where-Object { ($_.Name -ieq 'ngrok.exe') -and ($_.CommandLine -match 'donator-uneven-slain\.ngrok-free\.dev') -and ($_.CommandLine -match '127\.0\.0\.1:5000') }; if ($p) { exit 0 } else { exit 1 }"
if errorlevel 1 (
    echo Starting Ngrok Service in background...
    start "Ngrok Service" /min cmd /c "ngrok http --url=https://donator-uneven-slain.ngrok-free.dev 127.0.0.1:5000"
    timeout /t 3 /nobreak >nul
) else (
    echo [SKIPPED] Ngrok Service is already running!
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "$p = Get-CimInstance Win32_Process | Where-Object { ($_.Name -match '^(python|py)\.exe$') -and ($_.CommandLine -match 'cme_scheduler\.py') }; if ($p) { exit 0 } else { exit 1 }"
if errorlevel 1 (
    echo Starting CME Auto Scheduler...
    start "CME Auto Scheduler" /min cmd /c "cd /d ""%~dp0ea_research_team\learning"" && py -3.13 cme_scheduler.py"
    timeout /t 2 /nobreak >nul
) else (
    echo [SKIPPED] CME Auto Scheduler is already running!
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-RestMethod -Uri '%MANAGER_URL%' -TimeoutSec 2 | Out-Null; Write-Host 'Server Manager: Online' } catch { Write-Host 'Server Manager: Offline' }; try { Invoke-RestMethod -Uri '%API_URL%' -TimeoutSec 2 | Out-Null; Write-Host 'Flask API: Online' } catch { Write-Host 'Flask API: Offline' }"

%PY% -u run_trading_cycle.py

echo.
echo ========================================================
echo       SYSTEM STOPPED OR CRASHED!
echo ========================================================
pause
