@echo off
net session >nul 2>&1
if %errorLevel% == 0 (
  goto setup 
) else ( 
  powershell -command "Start-Process %0 -Verb runas"
)
exit

:setup
REG EXPORT "HKCU\Software\Microsoft\Windows\Shell\Bags\1\Desktop" "D:\SETUP\Regedit\DesktopLayoutPt1.reg" /y
REG EXPORT "HKCU\Software\Microsoft\Windows\Shell\BagMRU" "D:\SETUP\Regedit\DesktopLayoutPt2.reg" /y

copy /y /v "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "D:\SETUP\files\WT\settings.json" || REM Windows Terminal settings file