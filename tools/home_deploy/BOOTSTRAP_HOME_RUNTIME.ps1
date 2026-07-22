param(
    [Parameter(Mandatory = $true)][string]$RepositoryUrl,
    [string]$TargetRoot = 'C:\EA_KB_Runtime\EA-Knowledge-Base'
)

$ErrorActionPreference = 'Stop'
if ($TargetRoot -match '(?i)my drive') { throw 'TargetRoot must be on a local drive, not Google Drive.' }
if (Test-Path -LiteralPath $TargetRoot) { throw "Target already exists: $TargetRoot" }

$parent = Split-Path -Parent $TargetRoot
New-Item -ItemType Directory -Force -Path $parent | Out-Null

# Shallow + partial clone minimizes initial network transfer when the remote supports it.
git clone --depth 1 --filter=blob:none $RepositoryUrl $TargetRoot
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$example = Join-Path $TargetRoot 'tools\home_deploy\home_runtime.env.example'
$config = Join-Path $TargetRoot 'home_runtime.env'
Copy-Item -LiteralPath $example -Destination $config
Write-Host "Created $config. Set EA_KB_MT5_EXPERTS_DIR, then run tools\home_deploy\UPDATE_HOME_RUNTIME.ps1."
