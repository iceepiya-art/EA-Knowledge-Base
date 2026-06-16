$total = 0
while ($true) {
    Write-Host "Running MQL Code Intake (Batch limit 50)..."
    py -3.13 ea_research_team\learning\mql5_code_intake.py --root "G:\My Drive\jobot" --limit 50 --workers 3
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Intake script failed or finished with error. Stopping."
        break
    }
    
    $manifest = Get-Content "data\raw\mql5_code_manifest.json" | ConvertFrom-Json
    $processed = $manifest.processed_hashes.PSObject.Properties.Count
    if ($processed -eq $total) {
        Write-Host "ALL MQL FILES EXHAUSTED OR SKIPPED."
        break
    }
    $total = $processed

    Write-Host "Merging insights..."
    py -3.13 ea_research_team\learning\merge_code_insights.py
    
    Write-Host "Generating report..."
    py -3.13 ea_research_team\learning\generate_mql5_report.py
    
    Write-Host "Syncing DB..."
    py -3.13 ea_research_team\learning\db_bridge.py sync-concepts --apply
    py -3.13 ea_research_team\learning\db_bridge.py sync-evidence --apply
    py -3.13 ea_research_team\learning\db_bridge.py sync-relationships --apply
    
    Write-Host "Total Processed: $total"
    Start-Sleep -Seconds 5
}
