$ErrorActionPreference = "Stop"

$Base = "C:\Users\ADMIN\Desktop\save log-blueprint-skill\EA-Knowledge-Base"
$Py = "py"

Write-Host "QTrade OS Safe Automation Task Scheduler Setup"
Write-Host "Base: $Base"
Write-Host ""

function Register-QTradeTask {
    param(
        [string]$Name,
        [string]$Script,
        [string]$Schedule,
        [string]$Time,
        [string]$Day = ""
    )

    $Action = New-ScheduledTaskAction `
        -Execute $Py `
        -Argument "-3.14 `"$Base\$Script`"" `
        -WorkingDirectory $Base

    if ($Schedule -eq "Daily") {
        $Trigger = New-ScheduledTaskTrigger -Daily -At $Time
    }
    elseif ($Schedule -eq "Weekly") {
        $Trigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek $Day -At $Time
    }
    elseif ($Schedule -eq "Minutes") {
        $Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) `
            -RepetitionInterval (New-TimeSpan -Minutes ([int]$Time)) `
            -RepetitionDuration (New-TimeSpan -Days 3650)
    }
    else {
        throw "Unknown schedule: $Schedule"
    }

    $Settings = New-ScheduledTaskSettingsSet `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -StartWhenAvailable `
        -MultipleInstances IgnoreNew

    Register-ScheduledTask `
        -TaskName $Name `
        -Action $Action `
        -Trigger $Trigger `
        -Settings $Settings `
        -Description "QTrade OS safe automation. Data/reporting only. No trading execution." `
        -Force | Out-Null

    Write-Host "Registered: $Name"
}

Register-QTradeTask `
    -Name "QTrade_Continuous_Learning" `
    -Script "AUTOMATION\continuous_learning_pipeline.py" `
    -Schedule "Minutes" `
    -Time "5"

Register-QTradeTask `
    -Name "QTrade_MT5_CSV_Watch" `
    -Script "AUTOMATION\watch_mt5_folder.py" `
    -Schedule "Minutes" `
    -Time "5"

Register-QTradeTask `
    -Name "QTrade_Daily_Safe_Report" `
    -Script "AUTOMATION\daily_import.py" `
    -Schedule "Daily" `
    -Time "23:55"

Register-QTradeTask `
    -Name "QTrade_Weekly_Safe_Report" `
    -Script "AUTOMATION\weekly_report.py" `
    -Schedule "Weekly" `
    -Day "Sunday" `
    -Time "18:00"

Write-Host ""
Write-Host "Done. Review tasks in Windows Task Scheduler:"
Write-Host "Task Scheduler Library -> QTrade_Continuous_Learning / QTrade_MT5_CSV_Watch / QTrade_Daily_Safe_Report / QTrade_Weekly_Safe_Report"
Write-Host "For the full pipeline, QTrade_Continuous_Learning is enough. Keep the older tasks disabled if you want one orchestrator."
Write-Host ""
Write-Host "Telegram is off by default. Enable it in SYSTEM\config\automation_config.json after testing."
