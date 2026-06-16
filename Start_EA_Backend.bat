@echo off
cd /d "g:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\ea_research_team\learning"

:: Start Server Manager hidden using the correct Python 3.13 environment
start /min "" py -3.13 server_manager.py

:: Wait a few seconds for it to bind to port 5050
timeout /t 3 /nobreak > nul

:: Send POST request to start all managed servers (Flask API, Telegram Bot, Auto Worker)
curl -X POST http://127.0.0.1:5050/api/manager/start

