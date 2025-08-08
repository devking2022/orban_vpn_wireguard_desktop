# UAC Dialog Solution for VPN Application

## Problem
Windows 10 shows a User Account Control (UAC) dialog asking "Do you want to allow this app from an unknown publisher to make changes to your device?" every time you run the VPN application.

## Root Cause
This happens because:
1. The application isn't digitally signed by a trusted certificate authority
2. Windows treats unsigned applications as potentially malicious
3. VPN applications need admin privileges to modify network settings

## Solution Implemented

### ✅ **Complete Solution (Recommended)**
Run the comprehensive script that handles everything:
```powershell
.\fix_uac.ps1
```

This script will:
1. Create a self-signed certificate
2. Build the Flutter application
3. Sign the application with the certificate
4. Install the certificate to trusted stores

### ✅ **Step-by-Step Solution**

#### Step 1: Create Certificate
```powershell
.\create_cert.ps1
```

#### Step 2: Build Application
```cmd
flutter build windows
```

#### Step 3: Sign Application
```powershell
.\sign_app.ps1
```

#### Step 4: Install Certificate
```powershell
.\install_cert.ps1
```

### ✅ **Quick Launch**
After completing the above steps, you can run:
```powershell
.\run_vpn.ps1
```

## Files Created

### Certificate Files:
- `MyCert.pfx` - Certificate for signing (private key included)
- `MyCert.cer` - Public certificate for installation

### Scripts:
- `create_cert.ps1` - Creates self-signed certificate
- `sign_app.ps1` - Signs the application
- `install_cert.ps1` - Installs certificate to trusted stores
- `fix_uac.ps1` - Complete automation script
- `run_vpn.ps1` - Launches application with admin privileges

## How It Works

### 1. **Self-Signed Certificate**
- Creates a certificate with your company name
- Valid for 3 years
- Used for code signing

### 2. **Application Signing**
- Signs the main executable (`orban_vpn_desktop.exe`)
- Signs the WireGuard service (`wireguard_svc.exe`)
- Uses timestamp server for long-term validity

### 3. **Certificate Installation**
- Installs certificate to "Trusted Root Certification Authorities"
- Installs certificate to "Trusted Publishers"
- Tells Windows to trust your application

### 4. **Admin Privileges**
- Modified `runner.exe.manifest` to request admin privileges
- Application runs with proper permissions from start

## Benefits

✅ **No more UAC dialogs** - Application is trusted by Windows
✅ **Professional appearance** - Shows your company name instead of "unknown publisher"
✅ **Proper admin privileges** - VPN functionality works correctly
✅ **System tray support** - All features work as expected
✅ **One-time setup** - Certificate remains valid for 3 years

## For Production Use

For commercial applications, consider:
1. **Purchasing a Code Signing Certificate** (~$200-500/year)
   - DigiCert, Sectigo, GlobalSign, Comodo
   - Eliminates all security warnings
   - Required for Windows SmartScreen approval

2. **Microsoft SmartScreen Submission**
   - Submit your application to Microsoft for analysis
   - Free but takes time
   - Microsoft may whitelist your application

## Troubleshooting

### If you still see UAC dialogs:
1. Run PowerShell as Administrator
2. Re-run `.\install_certificate_ps.ps1`
3. Check that certificate is in "Trusted Root Certification Authorities"

### If signing fails:
1. Make sure you're running as Administrator
2. Check that certificate files exist
3. Verify the application was built successfully

### If application doesn't start:
1. Check that all DLL files are present
2. Verify WireGuard components are installed
3. Run `flutter clean` and rebuild

## Security Notes

- Self-signed certificates are for development/testing
- For production, use a trusted certificate authority
- Keep your private key secure
- Certificate is valid for 3 years 