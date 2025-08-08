# Sign Application using PowerShell
Write-Host "Signing VPN Application with Certificate..." -ForegroundColor Green

# Check if certificate exists
$pfxPath = Join-Path $PSScriptRoot "MyCert.pfx"
if (-not (Test-Path $pfxPath)) {
    Write-Host "Error: MyCert.pfx not found!" -ForegroundColor Red
    Write-Host "Please run create_certificate_ps.ps1 first to create the certificate." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if application exists
$appPath = Join-Path $PSScriptRoot "build\windows\x64\runner\Release\orban_vpn_desktop.exe"
if (-not (Test-Path $appPath)) {
    Write-Host "Error: Application not found!" -ForegroundColor Red
    Write-Host "Please build the application first using 'flutter build windows'" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

try {
    # Import the certificate
    $pfxPassword = ConvertTo-SecureString -String "password" -Force -AsPlainText
    $cert = Import-PfxCertificate -FilePath $pfxPath -Password $pfxPassword -CertStoreLocation Cert:\LocalMachine\My
    
    Write-Host "Certificate imported successfully!" -ForegroundColor Green
    Write-Host "Certificate Thumbprint: $($cert.Thumbprint)" -ForegroundColor Yellow
    
    # Sign the application using Set-AuthenticodeSignature
    Write-Host "Signing main executable..." -ForegroundColor Yellow
    $signature = Set-AuthenticodeSignature -FilePath $appPath -Certificate $cert -TimestampServer "http://timestamp.digicert.com"
    
    if ($signature.Status -eq "Valid") {
        Write-Host "Application signed successfully!" -ForegroundColor Green
    } else {
        Write-Host "Warning: Signature status is $($signature.Status)" -ForegroundColor Yellow
    }
    
    # Sign WireGuard service if it exists
    $wgServicePath = Join-Path $PSScriptRoot "build\windows\x64\runner\Release\wireguard_svc.exe"
    if (Test-Path $wgServicePath) {
        Write-Host "Signing WireGuard service..." -ForegroundColor Yellow
        $wgSignature = Set-AuthenticodeSignature -FilePath $wgServicePath -Certificate $cert -TimestampServer "http://timestamp.digicert.com"
        
        if ($wgSignature.Status -eq "Valid") {
            Write-Host "WireGuard service signed successfully!" -ForegroundColor Green
        } else {
            Write-Host "Warning: WireGuard signature status is $($wgSignature.Status)" -ForegroundColor Yellow
        }
    }
    
} catch {
    Write-Host "Error signing application: $($_.Exception.Message)" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Application signed successfully!" -ForegroundColor Green
Write-Host "Next step: Run install_certificate_ps.ps1 to trust the certificate" -ForegroundColor Cyan
Read-Host "Press Enter to continue" 