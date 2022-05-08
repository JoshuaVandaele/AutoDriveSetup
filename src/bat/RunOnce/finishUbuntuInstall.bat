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
wsl --update 2>nul|| REM WSL->WSL2
ubuntu install --root || REM Install ubuntu
ubuntu run sudo apt-get update || REM Update ubuntu, because fresh installs aren't already fully updated for some reason
echo y|ubuntu run sudo apt-get upgrade