@echo off
net session >nul 2>&1
if %errorLevel% == 0 (
  goto setup 
) else ( 
  powershell -command "Start-Process %0 -Verb runas"
)
exit

:setup
REG EXPORT "HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop" "D:\SETUP\Regedit\DesktopLayout.reg" /y || REM Desktop layout, but this doesnt seem to work in newer windows versions

copy /y /v "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "D:\SETUP\files\WT\settings.json" || REM Windows Terminal settings file