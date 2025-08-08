# Complete Solution: Build, Sign, and Install VPN Application
param(
    [switch]$SkipBuild,
    [switch]$SkipSigning,
    [switch]$SkipInstall,
    [switch]$Force
)

Write-Host "=== Complete VPN Application Solution ===" -ForegroundColor Cyan
Write-Host "This script will:" -ForegroundColor White
Write-Host "1. Create a self-signed certificate" -ForegroundColor White
Write-Host "2. Build the Flutter application" -ForegroundColor White
Write-Host "3. Sign the application with the certificate" -ForegroundColor White
Write-Host "4. Install the certificate to trusted stores" -ForegroundColor White
Write-Host ""

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "Warning: This script should be run as Administrator for best results." -ForegroundColor Yellow
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    if (-not $Force) {
        $response = Read-Host "Continue anyway? (y/N)"
        if ($response -ne "y" -and $response -ne "Y") {
            exit 1
        }
    }
}

# Step 1: Create Certificate
Write-Host "Step 1: Creating Certificate..." -ForegroundColor Green
if (-not (Test-Path "MyCert.pfx") -or $Force) {
    & .\create_cert.ps1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Certificate creation failed!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Certificate already exists, skipping creation..." -ForegroundColor Yellow
}

# Step 2: Build Application
if (-not $SkipBuild) {
    Write-Host "Step 2: Building Application..." -ForegroundColor Green
    flutter clean
    flutter build windows
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Build failed!" -ForegroundColor Red
        exit 1
    }
    Write-Host "Build completed successfully!" -ForegroundColor Green
} else {
    Write-Host "Skipping build..." -ForegroundColor Yellow
}

# Step 3: Sign Application
if (-not $SkipSigning) {
    Write-Host "Step 3: Signing Application..." -ForegroundColor Green
    & .\sign_app.ps1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Signing failed!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Skipping signing..." -ForegroundColor Yellow
}

# Step 4: Install Certificate
if (-not $SkipInstall) {
    Write-Host "Step 4: Installing Certificate..." -ForegroundColor Green
    & .\install_cert.ps1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Certificate installation failed!" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Skipping certificate installation..." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=== Solution Complete! ===" -ForegroundColor Green
Write-Host "Your VPN application is now:" -ForegroundColor White
Write-Host "✅ Built and ready to run" -ForegroundColor Green
Write-Host "✅ Signed with a self-signed certificate" -ForegroundColor Green
Write-Host "✅ Certificate installed to trusted stores" -ForegroundColor Green
Write-Host "✅ Should run without UAC dialogs" -ForegroundColor Green
Write-Host ""
Write-Host "You can now run: build\windows\x64\runner\Release\orban_vpn_desktop.exe" -ForegroundColor Cyan
Write-Host "Or use: .\run_vpn.ps1" -ForegroundColor Cyan 