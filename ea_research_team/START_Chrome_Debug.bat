@echo off
echo =====================================
echo  Open Chrome in Debug Mode
echo  Run this ONCE per session
echo =====================================
echo.
echo Restarting Chrome with debug port 9222...
taskkill /F /IM chrome.exe 2>nul
timeout /t 2 /nobreak >nul
start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222 --user-data-dir="%LOCALAPPDATA%\Google\Chrome\User Data" --profile-directory=Default
echo.
echo Done. Chrome is ready on port 9222.
echo Now you can run RUN_NotebookLM.bat anytime.
echo.
pause
