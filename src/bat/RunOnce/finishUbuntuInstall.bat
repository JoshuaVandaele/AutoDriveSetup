::Elevate to administrator privileges if you do not have them
CALL "..\..\tools\getadmin.bat" %~dpf0

:setup
wsl --update 2>nul|| REM WSL->WSL2
ubuntu install --root || REM Install ubuntu
ubuntu run sudo apt-get update || REM Update ubuntu, because fresh installs aren't already fully updated for some reason
echo y|ubuntu run sudo apt-get upgrade