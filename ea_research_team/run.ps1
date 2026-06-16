# EA Research Team — Quick Launcher
$env:PYTHONIOENCODING = "utf-8"
# Usage: .\run.ps1
# Usage: .\run.ps1 "SC100 คืออะไร"

# โหลด .env ถ้ามี
if (Test-Path ".env") {
    Get-Content ".env" | ForEach-Object {
        if ($_ -match "^\s*([^#][^=]+)=(.*)$") {
            [System.Environment]::SetEnvironmentVariable($Matches[1].Trim(), $Matches[2].Trim(), "Process")
        }
    }
}

if (-not $env:ANTHROPIC_API_KEY) {
    Write-Host "ERROR: ยังไม่ได้ตั้ง ANTHROPIC_API_KEY" -ForegroundColor Red
    Write-Host "1. copy .env.example -> .env" -ForegroundColor Yellow
    Write-Host "2. ใส่ API key ใน .env" -ForegroundColor Yellow
    exit 1
}

$question = $args -join " "
if ($question) {
    python orchestrator.py $question
} else {
    python orchestrator.py
}
