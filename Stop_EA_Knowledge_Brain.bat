@echo off
setlocal

echo Stopping EA Knowledge Brain...

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "try { Invoke-RestMethod -Uri 'http://127.0.0.1:5050/api/manager/stop' -Method POST -TimeoutSec 5 | Out-Null } catch { }; ^
   $listeners = Get-NetTCPConnection -LocalPort 5050 -State Listen -ErrorAction SilentlyContinue; ^
   foreach ($listener in $listeners) { Stop-Process -Id $listener.OwningProcess -Force -ErrorAction SilentlyContinue }; ^
   Write-Host 'EA Knowledge Brain manager stopped.'"

echo.
echo Done. You can close this window.
echo.
pause

endlocal
