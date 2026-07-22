@echo off
setlocal EnableExtensions
chcp 65001 >nul
title ACCOUNT-LOCKED TRADING LAUNCHER
set "ROOT=%~dp0"

echo ========================================================
echo       ACCOUNT-LOCKED TRADING LAUNCHER
echo ========================================================
set /p "EXPECTED_MT5_ACCOUNT=Enter the MT5 account number to use: "
if "%EXPECTED_MT5_ACCOUNT%"=="" (
  echo [BLOCKED] An MT5 account number is required.
  pause
  exit /b 1
)
set /p "ACCOUNT_RISK_PROFILE=Profile [FTMO_2STEP / TOPSTEP / PERSONAL]: "
if /I "%ACCOUNT_RISK_PROFILE%"=="FTMO_2STEP" goto :ftmo
if /I "%ACCOUNT_RISK_PROFILE%"=="TOPSTEP" goto :topstep
if /I "%ACCOUNT_RISK_PROFILE%"=="PERSONAL" goto :personal
echo [BLOCKED] Unsupported profile.
pause
exit /b 1

:ftmo
set /p "RISK_INITIAL_BALANCE=FTMO initial balance: "
set /p "FTMO_DAILY_RESET_BALANCE=Balance recorded at 00:00 CE(S)T: "
set "RISK_SAFETY_BUFFER_PCT=20"
goto :start

:topstep
set /p "TOPSTEP_ACCOUNT_ID=Topstep API account ID: "
set /p "TOPSTEP_MLL_FLOOR=Current trailing MLL floor: "
set /p "TOPSTEP_MAX_CONTRACTS=Maximum contracts for this account: "
goto :start

:personal
set /p "PERSONAL_EQUITY_FLOOR=Optional personal equity floor (blank = no floor): "

:start
echo.
echo [LOCK] Account=%EXPECTED_MT5_ACCOUNT% Profile=%ACCOUNT_RISK_PROFILE%
echo Starting only if the connected account matches the lock...
call "%ROOT%START_MASTER_TRADING_CYCLE.bat"
endlocal
