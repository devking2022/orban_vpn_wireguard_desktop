# Install Certificate to Trusted Publishers
Write-Host "Installing Certificate to Trusted Publishers..." -ForegroundColor Green

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "Warning: This script should be run as Administrator for best results." -ForegroundColor Yellow
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
}

# Check if certificate exists
$certPath = Join-Path $PSScriptRoot "MyCert.cer"
if (-not (Test-Path $certPath)) {
    Write-Host "Error: MyCert.cer not found!" -ForegroundColor Red
    Write-Host "Please run create_certificate_ps.ps1 first to create the certificate." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

try {
    # Import the certificate to Trusted Root Certification Authorities
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($certPath)
    $store = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root", "LocalMachine")
    $store.Open("ReadWrite")
    $store.Add($cert)
    $store.Close()
    
    Write-Host "Certificate installed successfully!" -ForegroundColor Green
    Write-Host "The application should now run without the 'unknown publisher' dialog." -ForegroundColor Yellow
    
    # Also add to Trusted Publishers
    $publisherStore = New-Object System.Security.Cryptography.X509Certificates.X509Store("TrustedPublisher", "LocalMachine")
    $publisherStore.Open("ReadWrite")
    $publisherStore.Add($cert)
    $publisherStore.Close()
    
    Write-Host "Certificate also added to Trusted Publishers!" -ForegroundColor Green
    
} catch {
    Write-Host "Error installing certificate: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "You may need to run this script as Administrator." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Certificate installation complete!" -ForegroundColor Green
Write-Host "You can now run your application without UAC dialogs." -ForegroundColor Yellow
Read-Host "Press Enter to exit" 