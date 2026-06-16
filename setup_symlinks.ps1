$gDrive = "G:\My Drive\save log-blueprint-skill\EA-Knowledge-Base\claw-empire-config"
$cDrive = "C:\Users\ADMIN\Documents\claw-empire"

New-Item -ItemType Directory -Force -Path $gDrive
Move-Item -Path "$cDrive\AGENTS.md" -Destination "$gDrive\AGENTS.md" -Force
Move-Item -Path "$cDrive\.env" -Destination "$gDrive\.env" -Force

New-Item -ItemType SymbolicLink -Path "$cDrive\AGENTS.md" -Target "$gDrive\AGENTS.md" -Force
New-Item -ItemType SymbolicLink -Path "$cDrive\.env" -Target "$gDrive\.env" -Force

Write-Host "Symlinks created successfully!"
