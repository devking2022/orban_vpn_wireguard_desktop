# Quick Start: Remove UAC Dialog

## One Command Solution
```powershell
.\fix_uac.ps1
```

This will:
1. Create certificate
2. Build application  
3. Sign application
4. Install certificate

## Manual Steps (if needed)
```powershell
# 1. Create certificate
.\create_cert.ps1

# 2. Build app
flutter build windows

# 3. Sign app
.\sign_app.ps1

# 4. Install certificate
.\install_cert.ps1
```

## Run Application
```powershell
.\run_vpn.ps1
```

## Files Created
- `MyCert.pfx` & `MyCert.cer` - Certificate files
- `create_cert.ps1` - Create certificate
- `sign_app.ps1` - Sign application
- `install_cert.ps1` - Install certificate
- `fix_uac.ps1` - Complete automation
- `run_vpn.ps1` - Run application
- `README_UAC.md` - Detailed guide 