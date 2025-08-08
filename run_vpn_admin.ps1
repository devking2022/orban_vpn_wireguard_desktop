# VPN Application Launcher with Admin Privileges
Write-Host "Starting VPN Application with Admin Privileges..." -ForegroundColor Green

# Get the directory where this script is located
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $scriptPath

# Path to the executable
$exePath = Join-Path $scriptPath "build\windows\x64\runner\Release\orban_vpn_desktop.exe"

# Check if the executable exists
if (Test-Path $exePath) {
    Write-Host "Launching VPN application..." -ForegroundColor Yellow
    Start-Process -FilePath $exePath -Verb RunAs
} else {
    Write-Host "Error: Executable not found at $exePath" -ForegroundColor Red
    Write-Host "Please build the application first using 'flutter build windows'" -ForegroundColor Red
    Read-Host "Press Enter to exit"
} 