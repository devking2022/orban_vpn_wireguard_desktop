# Create Self-Signed Certificate using PowerShell
Write-Host "Creating Self-Signed Certificate for Code Signing..." -ForegroundColor Green

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "Warning: This script should be run as Administrator for best results." -ForegroundColor Yellow
}

# Create certificate parameters
$certParams = @{
    Subject = "CN=Orban VPN Desktop"
    CertStoreLocation = "Cert:\LocalMachine\My"
    KeyAlgorithm = "RSA"
    KeyLength = 2048
    HashAlgorithm = "SHA256"
    KeyUsage = "DigitalSignature"
    TextExtension = @("2.5.29.37={text}1.3.6.1.5.5.7.3.3")
    NotAfter = (Get-Date).AddYears(3)
    FriendlyName = "Orban VPN Desktop Code Signing Certificate"
}

try {
    Write-Host "Creating self-signed certificate..." -ForegroundColor Yellow
    $cert = New-SelfSignedCertificate @certParams
    
    # Export certificate to PFX file
    $pfxPassword = ConvertTo-SecureString -String "password" -Force -AsPlainText
    $pfxPath = Join-Path $PSScriptRoot "MyCert.pfx"
    Export-PfxCertificate -Cert $cert -FilePath $pfxPath -Password $pfxPassword
    
    # Export public key to CER file
    $cerPath = Join-Path $PSScriptRoot "MyCert.cer"
    Export-Certificate -Cert $cert -FilePath $cerPath
    
    Write-Host "Certificate created successfully!" -ForegroundColor Green
    Write-Host "Files created:" -ForegroundColor Yellow
    Write-Host "- MyCert.pfx (Certificate for signing)" -ForegroundColor White
    Write-Host "- MyCert.cer (Public certificate)" -ForegroundColor White
    Write-Host ""
    Write-Host "Certificate Details:" -ForegroundColor Cyan
    Write-Host "Subject: $($cert.Subject)" -ForegroundColor White
    Write-Host "Thumbprint: $($cert.Thumbprint)" -ForegroundColor White
    Write-Host "Valid Until: $($cert.NotAfter)" -ForegroundColor White
    
} catch {
    Write-Host "Error creating certificate: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Run sign_application_ps.ps1 to sign your application" -ForegroundColor White
Write-Host "2. Run install_certificate_ps.ps1 to trust the certificate" -ForegroundColor White 