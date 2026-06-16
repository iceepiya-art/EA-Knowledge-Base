@echo off
echo ========================================================
echo EA Knowledge Brain - Daily System Synchronization
echo ========================================================
echo.
cd /d "g:\My Drive\save log-blueprint-skill\EA-Knowledge-Base"

echo [1/4] Syncing SQLite Database (Concepts)...
python ea_research_team\learning\db_bridge.py sync-concepts --apply

echo.
echo [2/4] Syncing SQLite Database (Evidence)...
python ea_research_team\learning\db_bridge.py sync-evidence --apply

echo.
echo [3/4] Syncing SQLite Database (Relationships)...
python ea_research_team\learning\db_bridge.py sync-relationships --apply

echo.
echo [4/4] Updating Graphify Architecture Graph...
graphify update .

echo.
echo ========================================================
echo Sync Completed Successfully!
echo ========================================================
