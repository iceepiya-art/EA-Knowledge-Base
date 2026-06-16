@echo off
echo =====================================
echo  NotebookLM Auto-Research to Obsidian
echo =====================================
echo.
echo NOTE: Run START_Chrome_Debug.bat first if Chrome is not open.
echo.
cd /d "%~dp0"
if "%~1"=="" (
    python notebooklm_auto.py
) else (
    python notebooklm_auto.py "%~1"
)
echo.
pause
