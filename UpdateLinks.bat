@echo off
net session >nul 2>&1
if %errorLevel% == 0 (
  goto setup 
) else ( 
  powershell -command "Start-Process %0 -Verb runas"
)
exit

:setup
copy /y /v "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "D:\SETUP\files\WT\settings.json" || REM Windows Terminal settings file