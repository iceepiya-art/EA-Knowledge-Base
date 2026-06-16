@echo off
cd /d "%~dp0"
py -3.14 AUTOMATION\continuous_learning_pipeline.py --loop --interval 300
pause
