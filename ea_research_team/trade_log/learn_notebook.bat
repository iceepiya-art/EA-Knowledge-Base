@echo off
cd /d "C:\Users\ADMIN\Desktop\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\learning"
echo.
echo ============================================
echo  Learn from NotebookLM
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

echo Paste NotebookLM URL or ID and press Enter
echo Example: https://notebooklm.google.com/notebook/9eb02bf0-...
echo.
set /p INPUT="URL or ID: "

for /f "tokens=2 delims=/" %%a in ("%INPUT:notebooklm.google.com/notebook/=%") do set NB_ID=%%a
if "%NB_ID%"=="" set NB_ID=%INPUT%

echo.
echo Notebook ID: %NB_ID%
echo.
call "%PYTHON_CMD%" run.py learn_nb %NB_ID%
echo.
pause
