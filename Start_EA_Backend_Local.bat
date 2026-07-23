@echo off
setlocal EnableExtensions
set "ROOT=%~dp0"
if not defined EA_KB_LOCAL_RUNTIME_ROOT set "EA_KB_LOCAL_RUNTIME_ROOT=C:\EA_KB_Runtime\EA-Knowledge-Base"
py -3.13 -m ea_research_team.learning.local_runtime prepare --runtime-root "%EA_KB_LOCAL_RUNTIME_ROOT%"
if errorlevel 1 exit /b 1
call "%EA_KB_LOCAL_RUNTIME_ROOT%\Start_EA_Backend.bat"
endlocal
