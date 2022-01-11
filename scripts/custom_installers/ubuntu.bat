start winget install --id "Canonical.Ubuntu"
call "%SetupFolder%\tools\RefreshEnv.cmd"
wsl --update || REM WSL->WSL2
ubuntu2004 install --root || REM Install ubuntu
ubuntu2004 run sudo apt-get update || REM Update ubuntu, because fresh installs aren't already fully updated for some reason
echo y|ubuntu2004 run sudo apt-get upgrade