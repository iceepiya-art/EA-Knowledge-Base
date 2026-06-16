$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$learning = Join-Path $root "ea_research_team\learning"
$dashboard = Join-Path $root "00_Dashboard\EA_Knowledge_Brain_Dashboard.html"
$logDir = Join-Path $root ".agent_handoff\logs"
$managerOutLog = Join-Path $logDir "ea_kb_manager_silent.out.log"
$managerErrLog = Join-Path $logDir "ea_kb_manager_silent.err.log"
$apiStatusUrl = "http://127.0.0.1:5000/api/learning/status"
$managerStatusUrl = "http://127.0.0.1:5050/api/manager/status"
$managerStartUrl = "http://127.0.0.1:5050/api/manager/start"

New-Item -ItemType Directory -Force -Path $logDir | Out-Null

if (-not $env:LOCAL_LLM_URL) {
    $env:LOCAL_LLM_URL = "http://127.0.0.1:1234/v1"
}
if (-not $env:LOCAL_LLM_API_KEY) {
    $env:LOCAL_LLM_API_KEY = "lm-studio"
}
if (-not $env:LOCAL_LLM_MODEL) {
    $env:LOCAL_LLM_MODEL = "google/gemma-4-e4b"
}

function Test-Url {
    param([string]$Url, [int]$TimeoutSec = 2)
    try {
        Invoke-RestMethod -Uri $Url -TimeoutSec $TimeoutSec | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function Start-Manager {
    $portOpen = Get-NetTCPConnection -LocalPort 5050 -State Listen -ErrorAction SilentlyContinue
    if ($portOpen) {
        return
    }

    Start-Process `
        -FilePath "py" `
        -ArgumentList @("-3.13", "server_manager.py") `
        -WorkingDirectory $learning `
        -WindowStyle Hidden `
        -RedirectStandardOutput $managerOutLog `
        -RedirectStandardError $managerErrLog

    $deadline = (Get-Date).AddSeconds(10)
    while ((Get-Date) -lt $deadline) {
        if (Test-Url $managerStatusUrl 1) {
            return
        }
        Start-Sleep -Milliseconds 300
    }
}

Start-Manager

try {
    Invoke-RestMethod -Method Post -Uri $managerStartUrl -TimeoutSec 15 | Out-Null
}
catch {
    # Direct API fallback below keeps dashboard usable if the manager is unavailable.
}

if (-not (Test-Url $apiStatusUrl 2)) {
    $apiOutLog = Join-Path $logDir "ea_kb_api_silent.out.log"
    $apiErrLog = Join-Path $logDir "ea_kb_api_silent.err.log"
    Start-Process `
        -FilePath "py" `
        -ArgumentList @("-3.13", "server.py") `
        -WorkingDirectory $learning `
        -WindowStyle Hidden `
        -RedirectStandardOutput $apiOutLog `
        -RedirectStandardError $apiErrLog
}

Start-Process $dashboard
