@echo off
setlocal EnableExtensions
set "ROOT=%~dp0"
if not defined EA_KB_LOCAL_RUNTIME_ROOT set "EA_KB_LOCAL_RUNTIME_ROOT=C:\EA_KB_Runtime\EA-Knowledge-Base"
py -3.13 -m ea_research_team.learning.local_runtime prepare --runtime-root "%EA_KB_LOCAL_RUNTIME_ROOT%"
if errorlevel 1 (
  echo Local runtime preparation failed. Existing services were not stopped.
  exit /b 1
)
set "EA_KB_NO_PAUSE=1"
call "%ROOT%Stop_EA_Knowledge_Brain.bat"
endlocal
