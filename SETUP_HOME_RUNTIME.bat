@echo off
setlocal EnableExtensions
chcp 65001 >nul

REM Installs or updates a safe, local copy for the home runtime.
REM This launcher deliberately does not start MT5, ngrok, or the trading stack.
set "REPO_URL=https://github.com/iceepiya-art/EA-Knowledge-Base.git"
if not defined EA_KB_HOME_RUNTIME_ROOT set "EA_KB_HOME_RUNTIME_ROOT=C:\EA_KB_Runtime\EA-Knowledge-Base"

echo ========================================================
echo      EA KNOWLEDGE BASE - HOME RUNTIME SETUP
echo ========================================================
echo Target: %EA_KB_HOME_RUNTIME_ROOT%
echo.

where git >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Git is required. Install Git for Windows, then run this again.
    exit /b 1
)

where py >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Python Launcher is required. Install Python 3.13, then run this again.
    exit /b 1
)

if exist "%EA_KB_HOME_RUNTIME_ROOT%\.git" (
    echo [1/4] Updating existing runtime copy...
    git -C "%EA_KB_HOME_RUNTIME_ROOT%" pull --ff-only
    if errorlevel 1 (
        echo [ERROR] Update failed. Resolve local changes or pull conflicts first.
        exit /b 1
    )
) else (
    if exist "%EA_KB_HOME_RUNTIME_ROOT%" (
        echo [ERROR] Target exists but is not a Git checkout: %EA_KB_HOME_RUNTIME_ROOT%
        echo Choose an empty target folder or set EA_KB_HOME_RUNTIME_ROOT first.
        exit /b 1
    )
    echo [1/4] Cloning runtime copy...
    git clone "%REPO_URL%" "%EA_KB_HOME_RUNTIME_ROOT%"
    if errorlevel 1 exit /b 1
)

echo [2/4] Checking Python 3.13...
py -3.13 --version
if errorlevel 1 (
    echo [ERROR] Python 3.13 is required.
    exit /b 1
)

echo [3/4] Creating machine-local .env when needed...
if not exist "%EA_KB_HOME_RUNTIME_ROOT%\.env" (
    copy "%EA_KB_HOME_RUNTIME_ROOT%\.env.example" "%EA_KB_HOME_RUNTIME_ROOT%\.env" >nul
    echo [ACTION REQUIRED] Edit .env and set CME_ALPHAEDGE_DIR for this machine.
) else (
    echo [OK] Existing .env was preserved.
)

echo [4/4] Running safe launcher checks...
py -3.13 -m pytest -q "%EA_KB_HOME_RUNTIME_ROOT%\ea_research_team\learning\test_home_runtime_setup.py" "%EA_KB_HOME_RUNTIME_ROOT%\ea_research_team\learning\test_launcher_scripts.py" -k "home_runtime_setup or start_launcher or silent_launcher or stop_launcher or backend_launcher or migrate_launcher"
if errorlevel 1 (
    echo [ERROR] Setup completed, but launcher checks failed. Do not start trading.
    exit /b 1
)

echo.
echo [OK] Home runtime is ready for a safe research start.
echo Next: edit .env, then run START_MASTER_FULL_RESEARCH.bat.
echo Do not run 1_START_TRADING_NOW.bat until MT5, CME, and TradingView are verified.
endlocal
