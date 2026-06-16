@echo off
title QTrade OS  --  Import Trades
cd /d "%~dp0"

echo.
echo  ====================================================
echo   QTrade OS  --  Trade Importer
echo  ====================================================
echo.

REM ── Find correct Python ──────────────────────────────────────────────────────
set PY=

py -3.14 -c "import pandas" 2>nul
if %errorlevel%==0 (
    set PY=py -3.14
    goto :found_python
)

"C:\Users\ADMIN\AppData\Local\Programs\Python\Python314\python.exe" -c "import pandas" 2>nul
if %errorlevel%==0 (
    set PY=C:\Users\ADMIN\AppData\Local\Programs\Python\Python314\python.exe
    goto :found_python
)

echo ERROR: Cannot find Python with pandas installed.
echo Fix: py -3.14 -m pip install -r ANALYTICS\requirements.txt
pause & exit /b 1

:found_python

REM ── Init database if missing ─────────────────────────────────────────────────
if not exist "DATA\processed\trades.sqlite" (
    echo Initializing database...
    %PY% ANALYTICS\setup_db.py
    if %errorlevel% neq 0 (
        echo ERROR: Database init failed.
        pause & exit /b 1
    )
)

echo.
echo  Current trades in database:
%PY% ANALYTICS\importers\mt5_importer.py --stats
echo.
echo  ────────────────────────────────────────────────────
echo   Select import option:
echo  ────────────────────────────────────────────────────
echo.
echo   1  Import existing vault CSVs   (trades_M1, ftmo, ea_fix20, etc.)
echo   2  Import new MT5 exports       (DATA\raw\mt5_exports\*.csv)
echo   3  Import single file
echo   4  Show stats only
echo   5  Exit
echo.
set /p choice="Your choice (1-5): "

if "%choice%"=="1" goto :import_legacy
if "%choice%"=="2" goto :import_all
if "%choice%"=="3" goto :import_file
if "%choice%"=="4" goto :stats_only
if "%choice%"=="5" goto :end
echo Invalid choice.
goto :end

:import_legacy
echo.
echo Importing all existing vault CSVs...
%PY% ANALYTICS\importers\mt5_importer.py --legacy
if %errorlevel% neq 0 echo Import encountered errors — check AUTOMATION\logs\
echo.
echo Updated stats:
%PY% ANALYTICS\importers\mt5_importer.py --stats
goto :done

:import_all
echo.
echo Importing from DATA\raw\mt5_exports\...
%PY% ANALYTICS\importers\mt5_importer.py --all
echo.
echo Updated stats:
%PY% ANALYTICS\importers\mt5_importer.py --stats
goto :done

:import_file
echo.
set /p filepath="Enter CSV file path: "
if not exist "%filepath%" (
    echo File not found: %filepath%
    goto :done
)
set /p strategy="Strategy name (e.g. QField): "
%PY% ANALYTICS\importers\mt5_importer.py --file "%filepath%" --strategy "%strategy%"
echo.
%PY% ANALYTICS\importers\mt5_importer.py --stats
goto :done

:stats_only
%PY% ANALYTICS\importers\mt5_importer.py --stats
goto :done

:done
echo.
echo Done.
echo.
pause

:end
