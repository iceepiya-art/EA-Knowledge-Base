param(
    [string]$SourceImage = "C:\Users\ADMIN\Desktop\Screenshot 2026-05-31 122833.jpg",
    [string]$ShortcutName = "EA Knowledge Brain.lnk"
)

$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$launcher = Join-Path $root "Start_EA_Knowledge_Brain.bat"
$silentLauncher = Join-Path $root "Start_EA_Knowledge_Brain_Silent.ps1"
$iconDir = Join-Path $root "assets"
$iconPath = Join-Path $iconDir "ea-knowledge-brain.ico"

if (-not (Test-Path $launcher)) {
    throw "Launcher not found: $launcher"
}
if (-not (Test-Path $silentLauncher)) {
    throw "Silent launcher not found: $silentLauncher"
}
if (-not (Test-Path $SourceImage)) {
    throw "Source image not found: $SourceImage"
}

New-Item -ItemType Directory -Force -Path $iconDir | Out-Null

Add-Type -AssemblyName System.Drawing
Add-Type @"
using System;
using System.Runtime.InteropServices;
public class NativeMethods {
    [DllImport("user32.dll", SetLastError=true)]
    public static extern bool DestroyIcon(IntPtr hIcon);
}
"@

$image = [System.Drawing.Image]::FromFile($SourceImage)
$bitmap = New-Object System.Drawing.Bitmap 256, 256
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
$graphics.Clear([System.Drawing.Color]::Transparent)
$graphics.DrawImage($image, 0, 0, 256, 256)

$handle = $bitmap.GetHicon()
$icon = [System.Drawing.Icon]::FromHandle($handle)
$stream = [System.IO.File]::Open($iconPath, [System.IO.FileMode]::Create)
try {
    $icon.Save($stream)
}
finally {
    $stream.Close()
    $icon.Dispose()
    [NativeMethods]::DestroyIcon($handle) | Out-Null
    $graphics.Dispose()
    $bitmap.Dispose()
    $image.Dispose()
}

$desktop = [Environment]::GetFolderPath("Desktop")
$shortcutPath = Join-Path $desktop $ShortcutName
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$silentLauncher`""
$shortcut.WorkingDirectory = $root
$shortcut.IconLocation = "$iconPath,0"
$shortcut.Description = "Start EA Knowledge Brain dashboard and API"
$shortcut.WindowStyle = 7
$shortcut.Save()

Write-Host "Created shortcut: $shortcutPath"
Write-Host "Created icon: $iconPath"
