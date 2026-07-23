@echo off
setlocal

echo Stopping EA Knowledge Brain...

powershell -NoProfile -ExecutionPolicy Bypass -Command "try { Invoke-RestMethod -Uri 'http://127.0.0.1:5050/api/manager/stop' -Method POST -TimeoutSec 5 | Out-Null } catch { }; foreach ($port in 5050,5000) { for ($attempt=0; $attempt -lt 3; $attempt++) { $listeners=@(Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue); if ($listeners.Count -eq 0) { break }; foreach ($listener in $listeners) { Stop-Process -Id $listener.OwningProcess -Force -ErrorAction SilentlyContinue }; Start-Sleep -Milliseconds 500 } }; Write-Host 'EA Knowledge Brain manager and local Flask API stopped.'"

echo.
echo Done. You can close this window.
echo.
if not defined EA_KB_NO_PAUSE pause

endlocal
