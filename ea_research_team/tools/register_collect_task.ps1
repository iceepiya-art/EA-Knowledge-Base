$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$learningDir = Join-Path $projectRoot "learning"
$batchPath = Join-Path $learningDir "run_collect.bat"
$pythonPath = "C:\Users\ADMIN\AppData\Local\Programs\Python\Python313\python.exe"
$taskName = "EA Research Daily Collect"
$startTime = "08:00"

if (-not (Test-Path $batchPath)) {
    throw "Missing batch file: $batchPath"
}

if (-not (Test-Path $pythonPath)) {
    throw "Missing Python interpreter: $pythonPath"
}

$action = New-ScheduledTaskAction `
    -Execute "cmd.exe" `
    -Argument "/c set PYTHON_EXE=$pythonPath && `"$batchPath`"" `
    -WorkingDirectory $learningDir
$trigger = New-ScheduledTaskTrigger -Daily -At $startTime
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable

Register-ScheduledTask `
    -TaskName $taskName `
    -Action $action `
    -Trigger $trigger `
    -Settings $settings `
    -Description "Runs the EA learning collect pipeline every day at 08:00." `
    -Force | Out-Null

Write-Host "Scheduled task created/updated: $taskName"
Write-Host "Runs daily at $startTime"
Write-Host "Python: $pythonPath"
Write-Host "Command: $batchPath"
