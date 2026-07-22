param(
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$config = Join-Path $root 'home_runtime.env'
$reportDir = Join-Path $root 'reports\home_deploy'
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$args = @('--root', $root, '--config', $config, '--report', (Join-Path $reportDir "deploy_$stamp.json"))
if ($DryRun) { $args += '--dry-run' }

if (-not (Test-Path -LiteralPath $config)) {
    throw "Missing $config. Copy tools\home_deploy\home_runtime.env.example to home_runtime.env and set the local MT5 Experts path."
}

& py -3.13 (Join-Path $PSScriptRoot 'home_runtime_update.py') @args
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host 'Deploy completed. Reload MasterEA_v3 on the MT5 charts before enabling/continuing execution.'
