@echo off
cd /d "%~dp0"
echo.
echo ============================================
echo  Import MT5 Trade History
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
    echo.
    pause
    exit /b 1
)

if not exist "trades.html" (
    echo [ERROR] ไม่พบไฟล์ trades.html
    echo.
    echo วิธี export จาก MT5:
    echo   1. MT5 ^> Terminal ^> History tab
    echo   2. คลิกขวา ^> Save as Report
    echo   3. บันทึกเป็น trades.html ในโฟลเดอร์นี้:
    echo   %~dp0
    echo.
    pause
    exit
)

call "%PYTHON_CMD%" ..\learning\run.py import_mt5 trades.html
echo.
echo ============================================
echo  ดูผลวิเคราะห์:
call "%PYTHON_CMD%" ..\learning\run.py trade_stats
echo ============================================
echo.
pause
