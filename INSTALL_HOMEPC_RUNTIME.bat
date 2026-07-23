@echo off
setlocal EnableExtensions
chcp 65001 >nul

REM One-click bootstrap for the HomePC runtime. This script never starts MT5,
REM Algo Trading, ngrok, or any trading service.
set "REPO_URL=https://github.com/iceepiya-art/EA-Knowledge-Base.git"
if not defined EA_KB_HOME_RUNTIME_ROOT set "EA_KB_HOME_RUNTIME_ROOT=C:\EA_KB_Runtime\EA-Knowledge-Base"

echo ========================================================
echo      EA KNOWLEDGE BASE - HOMEPC RUNTIME INSTALLER
echo ========================================================
echo Target: %EA_KB_HOME_RUNTIME_ROOT%
echo.

where git >nul 2>nul
if errorlevel 1 (
    echo [ERROR] Git for Windows is required. Install Git, then run again.
    exit /b 1
)

if exist "%EA_KB_HOME_RUNTIME_ROOT%\.git" (
    echo [1/2] Existing runtime found. Running safe update checks...
) else (
    if exist "%EA_KB_HOME_RUNTIME_ROOT%" (
        echo [ERROR] Target exists but is not a Git checkout: %EA_KB_HOME_RUNTIME_ROOT%
        exit /b 1
    )
    echo [1/2] Cloning runtime repository...
    git clone "%REPO_URL%" "%EA_KB_HOME_RUNTIME_ROOT%"
    if errorlevel 1 exit /b 1
)

echo [2/2] Validating the local runtime...
call "%EA_KB_HOME_RUNTIME_ROOT%\SETUP_HOME_RUNTIME.bat"
if errorlevel 1 exit /b 1

echo.
echo [OK] HomePC runtime is installed and validated.
echo Next: compile MasterEA_v3.mq5 in FTMO MetaEditor on this HomePC.
endlocal
