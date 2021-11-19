@echo off

set SetupFolder="D:\SETUP"

::Elevate to administrator privileges if you do not have them
net session >nul 2>&1 || REM Admin only command, if the error level is 0, it means we have admin privileges
if %errorLevel% == 0 (
  goto setup 
) else ( 
  powershell -command "Start-Process %0 -Verb runas" || REM Restart current batch file as admin
)
exit

:setup
cd /d "%SetupFolder%"
cls

forfiles /P %SetupFolder%\scripts\ /c "cmd /c echo Starting @FNAME. & cmd.exe /c start cmd.exe /c @PATH"
echo Done.
exit