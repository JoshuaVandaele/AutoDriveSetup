@echo off

set SetupFolder=%~dp0
echo %SetupFolder%

::Elevate to administrator privileges
CALL "%SetupFolder%src\tools\getadmin.bat" %~dpf0

:setup
echo Starting..
cd /d %SetupFolder%
cls
echo Starting..
forfiles /P %SetupFolder%src\bat\setup\ /c "cmd /c echo Starting @FNAME. & cmd.exe /c start cmd.exe /c @PATH"
echo Done.
exit