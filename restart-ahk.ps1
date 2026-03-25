# restart-ahk.ps1 - Kill all AutoHotkey processes and restart main.ahk

# Self-elevate if not running as admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

$scriptDir = Split-Path -Parent $PSCommandPath
$mainAhk = Join-Path $scriptDir "main.ahk"

# Kill all AutoHotkey processes
$procs = Get-Process -Name "AutoHotkey*" -ErrorAction SilentlyContinue
if ($procs) {
    Write-Host "Killing $($procs.Count) AutoHotkey process(es)..."
    $procs | Stop-Process -Force
    Start-Sleep -Milliseconds 500
} else {
    Write-Host "No AutoHotkey processes found."
}

# Restart main.ahk (run as normal user, not elevated)
Write-Host "Starting main.ahk..."
$explorer = (Get-Process explorer -ErrorAction SilentlyContinue | Select-Object -First 1)
if ($explorer) {
    # Use explorer.exe to launch as the logged-in user, not as admin
    Start-Process explorer.exe $mainAhk
} else {
    Start-Process $mainAhk
}
Write-Host "Done."
