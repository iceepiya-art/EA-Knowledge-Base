@echo off
echo ===================================================
echo   Claw-Empire Cloud Sync ^& Run (Portable Config)
echo ===================================================
echo.

SET "G_DRIVE=G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\claw-empire-config"
SET "C_DRIVE=C:\Users\ADMIN\Documents\claw-empire"

if not exist "%C_DRIVE%\package.json" (
    echo [!] Program not found on C: drive. Please install first.
    pause
    exit /b
)

if exist "%G_DRIVE%\AGENTS.md" (
    echo [*] Pulling latest configs from Google Drive...
    copy /Y "%G_DRIVE%\AGENTS.md" "%C_DRIVE%\AGENTS.md" >nul
    copy /Y "%G_DRIVE%\.env" "%C_DRIVE%\.env" >nul
) else (
    echo [*] No configs found on Google Drive. Backing up from local...
    if not exist "%G_DRIVE%" mkdir "%G_DRIVE%"
    copy /Y "%C_DRIVE%\AGENTS.md" "%G_DRIVE%\AGENTS.md" >nul
    copy /Y "%C_DRIVE%\.env" "%G_DRIVE%\.env" >nul
)

echo [*] Starting Claw-Empire Server...
echo [*] Press Ctrl+C to stop the server and sync configs back.
echo.
cd /d "%C_DRIVE%"
call pnpm dev:local

echo.
echo [*] Server stopped. Syncing configs back to Google Drive...
copy /Y "%C_DRIVE%\AGENTS.md" "%G_DRIVE%\AGENTS.md" >nul
copy /Y "%C_DRIVE%\.env" "%G_DRIVE%\.env" >nul
echo [*] Sync complete!
pause
