@echo off
echo Starting VPN Application with Admin Privileges...
cd /d "%~dp0"
powershell -Command "Start-Process 'build\windows\x64\runner\Release\orban_vpn_desktop.exe' -Verb RunAs"
pause 