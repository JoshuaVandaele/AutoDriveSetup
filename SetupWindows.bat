@echo off

set SetupFolder=%~dp0
echo %SetupFolder%

::Elevate to administrator privileges if you do not have them
NET SESSION || REM Admin only command, if the error level is 0, it means we have admin privileges
if %errorLevel% == 0 (
  goto setup 
) else ( 
  echo Getting administrator privileges..
  powershell -command "Start-Process %0 -Verb runas" || REM Restart current batch file as admin
)
exit


:setup
echo Starting..
cd /d %SetupFolder%
cls
echo Starting..
forfiles /P %SetupFolder%src\bat\setup\ /c "cmd /c echo Starting @FNAME. & cmd.exe /c start cmd.exe /c @PATH"
echo Done.
exit