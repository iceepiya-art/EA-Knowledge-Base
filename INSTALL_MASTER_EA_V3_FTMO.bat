@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul
title INSTALL MASTER EA V3 - FTMO MT5
set "ROOT=%~dp0"
set "SOURCE=%ROOT%artifacts\generated_ea\MasterEA_v3.mq5"
set "METAEDITOR=C:\Program Files\FTMO Global Markets MT5 Terminal\metaeditor64.exe"
set "DATA_DIR="

echo ========================================================
echo     INSTALL + COMPILE MASTER EA V3 FOR FTMO MT5
echo ========================================================
echo This installs and compiles an EA only. It does NOT open MT5,
echo attach an EA to a chart, enable Algo Trading, or place trades.
echo.

if not exist "%SOURCE%" (
  echo [FAIL] Source not found: %SOURCE%
  goto :failed
)
if not exist "%METAEDITOR%" (
  echo [FAIL] FTMO MetaEditor was not found: %METAEDITOR%
  goto :failed
)

for /f "usebackq delims=" %%D in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "$root=Join-Path $env:APPDATA 'MetaQuotes\Terminal'; foreach($d in (Get-ChildItem -LiteralPath $root -Directory -ErrorAction SilentlyContinue)){ if((Test-Path (Join-Path $d.FullName 'MQL5\Experts')) -and (Test-Path (Join-Path $d.FullName 'origin.txt')) -and ((Get-Content -LiteralPath (Join-Path $d.FullName 'origin.txt') -Raw) -match 'FTMO Global Markets MT5 Terminal')){$d.FullName;break} }"`) do set "DATA_DIR=%%D"

if "%DATA_DIR%"=="" (
  echo [FAIL] The FTMO MT5 Data Folder could not be identified automatically.
  echo Open FTMO MT5 ^> File ^> Open Data Folder, then contact support with that path.
  goto :failed
)

set "EXPERTS=%DATA_DIR%\MQL5\Experts"
set "TARGET=%EXPERTS%\MasterEA_v3.mq5"
set "COMPILED=%EXPERTS%\MasterEA_v3.ex5"
set "BACKUP=%EXPERTS%\MasterEA_v3.before-install.mq5"

echo [1/3] FTMO Data Folder: %DATA_DIR%
if exist "%TARGET%" (
  copy /Y "%TARGET%" "%BACKUP%" >nul
  if errorlevel 1 (
    echo [FAIL] Unable to create source backup: %BACKUP%
    goto :failed
  )
  echo [OK] Existing source backed up as MasterEA_v3.before-install.mq5
)

echo [2/3] Installing MasterEA v3 source...
copy /Y "%SOURCE%" "%TARGET%" >nul
if errorlevel 1 (
  echo [FAIL] Unable to copy EA source into FTMO MQL5 Experts.
  goto :failed
)

echo [3/3] Compiling with FTMO MetaEditor...
start "MasterEA v3 compiler" /wait "%METAEDITOR%" /compile:"%TARGET%" /log:"%TEMP%\MasterEA_v3_compile.log"
if not exist "%COMPILED%" (
  echo [FAIL] Compile did not create MasterEA_v3.ex5
  echo Check: %TEMP%\MasterEA_v3_compile.log
  goto :failed
)

echo.
echo [OK] MasterEA_v3.ex5 is ready in:
echo %COMPILED%
echo Next: open FTMO MT5, Refresh Navigator, then attach it manually only when you choose.
echo.
pause
exit /b 0

:failed
echo.
echo No trade was opened. Resolve the reported issue before continuing.
echo.
pause
exit /b 1
