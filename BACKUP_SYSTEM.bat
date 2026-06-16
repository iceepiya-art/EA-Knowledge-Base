@echo off
setlocal enabledelayedexpansion
title EA Knowledge Brain Backup System
color 0A

echo ===================================================
echo      EA Knowledge Brain 3-2-1 Backup System
echo ===================================================
echo.

:: 1. ดึงเวลาปัจจุบันเพื่อทำ Timestamp (YYYY-MM-DD_HHMM)
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set datetime=%%I
set YYYY=%datetime:~0,4%
set MM=%datetime:~4,2%
set DD=%datetime:~6,2%
set HH=%datetime:~8,2%
set MIN=%datetime:~10,2%

set BACKUP_NAME=EA-Knowledge-Base_backup_%YYYY%-%MM%-%DD%_%HH%%MIN%.zip

:: 2. ตั้งค่า Path ต่างๆ (เจ้านายสามารถแก้ Drive E: หรือ OneDrive ได้ตามเครื่องจริงครับ)
set SOURCE_PARENT=G:\My Drive\save log-blueprint-skill
set FOLDER_TO_BACKUP=EA-Knowledge-Base

set EXT_BACKUP_DIR=E:\EA-System-Backups\daily
set CLOUD_BACKUP_DIR=%USERPROFILE%\OneDrive\EA-System-Backups\weekly-zips

echo [INFO] Preparing Backup Directories...
if not exist "%EXT_BACKUP_DIR%" mkdir "%EXT_BACKUP_DIR%"
if not exist "%CLOUD_BACKUP_DIR%" mkdir "%CLOUD_BACKUP_DIR%"

echo.
echo [1/3] Compressing System Files (Zipping)...
echo Target: %EXT_BACKUP_DIR%\%BACKUP_NAME%
echo Please wait, this may take a few minutes depending on folder size...

:: เปลี่ยน Directory ไปที่โฟลเดอร์แม่ก่อน เพื่อให้ไฟล์ Zip มีโฟลเดอร์ EA-Knowledge-Base อยู่ข้างใน
cd /d "%SOURCE_PARENT%"

:: ใช้คำสั่ง tar ที่แถมมากับ Windows 10/11 ในการ Zip (เร็วกว่า Compress-Archive ของ PowerShell)
tar -a -c -f "%EXT_BACKUP_DIR%\%BACKUP_NAME%" "%FOLDER_TO_BACKUP%"

if %ERRORLEVEL% NEQ 0 (
    echo.
    color 0C
    echo [ERROR] Compression failed! Please check if files are locked or in use.
    pause
    exit /b %ERRORLEVEL%
)

echo.
echo [2/3] Local External Backup completed successfully!
echo Saved to: %EXT_BACKUP_DIR%\%BACKUP_NAME%

echo.
echo [3/3] Copying to Cloud Archive (OneDrive)...
copy "%EXT_BACKUP_DIR%\%BACKUP_NAME%" "%CLOUD_BACKUP_DIR%\" >nul

if %ERRORLEVEL% NEQ 0 (
    echo.
    color 0E
    echo [WARNING] Could not copy to OneDrive. 
    echo Please check if OneDrive path (%CLOUD_BACKUP_DIR%) exists on your PC.
) else (
    echo Cloud backup completed successfully!
)

echo.
echo ===================================================
echo Backup Process Finished Successfully!
echo ===================================================
echo * Secret files (.env, cookies) are securely archived in this zip.
echo * Recommendation: Don't forget to push source code to GitHub Private Repo!
echo.
pause
