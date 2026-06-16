@echo off
cd /d "C:\Users\ADMIN\Desktop\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\learning"
echo.
echo ============================================
echo  NotebookLM Login
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

echo Using Python:
echo   %PYTHON_CMD%
echo.
set "NOTEBOOKLM_DIR=%USERPROFILE%\.notebooklm"
set "NOTEBOOKLM_STORAGE=%NOTEBOOKLM_DIR%\storage_state.json"

if not exist "%NOTEBOOKLM_DIR%" mkdir "%NOTEBOOKLM_DIR%"

echo Auth file:
echo   %NOTEBOOKLM_STORAGE%
echo.
echo IMPORTANT:
echo   1. A browser login window will open.
echo   2. Complete Google / NotebookLM login in that browser.
echo   3. Come back to THIS black window.
echo   4. Press ENTER here so the auth file is saved.
echo.
call "%PYTHON_CMD%" -m notebooklm login --storage "%NOTEBOOKLM_STORAGE%"
echo.
if exist "%NOTEBOOKLM_STORAGE%" (
    echo [OK] NotebookLM auth saved.
) else (
    echo [ERROR] Auth file was not created.
    echo Make sure you finish login in the browser, then press ENTER in this window.
)
echo.
pause
