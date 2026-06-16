@echo off
title QTrade OS Dashboard
cd /d "%~dp0"

echo.
echo  ====================================================
echo   QTrade OS  --  Analytics Dashboard
echo  ====================================================
echo.

REM ── Find correct Python ──────────────────────────────────────────────────────
set PY=

py -3.14 -c "import streamlit" 2>nul
if %errorlevel%==0 (
    set PY=py -3.14
    goto :found_python
)

"C:\Users\ADMIN\AppData\Local\Programs\Python\Python314\python.exe" -c "import streamlit" 2>nul
if %errorlevel%==0 (
    set PY=C:\Users\ADMIN\AppData\Local\Programs\Python\Python314\python.exe
    goto :found_python
)

echo ERROR: Cannot find Python with streamlit installed.
echo.
echo Fix:
echo   py -3.14 -m pip install -r ANALYTICS\requirements.txt
echo.
pause
exit /b 1

:found_python
echo Python: %PY%

REM ── Init database if missing ─────────────────────────────────────────────────
if not exist "DATA\processed\trades.sqlite" (
    echo Initializing database...
    %PY% ANALYTICS\setup_db.py
    if %errorlevel% neq 0 (
        echo ERROR: Database initialization failed.
        pause & exit /b 1
    )
)

REM ── Check for trade data ─────────────────────────────────────────────────────
%PY% ANALYTICS\importers\mt5_importer.py --stats

echo.
echo  Dashboard: http://localhost:5055
echo  Stop:      Ctrl+C
echo.

%PY% -m streamlit run ANALYTICS\dashboard\app.py ^
    --server.port 5055 ^
    --server.headless false ^
    --browser.gatherUsageStats false ^
    --theme.base dark ^
    --theme.primaryColor "#5c6bc0"
