winget install %wingetargs% --id "Canonical.Ubuntu"
call "%SetupFolder%src\tools\RefreshEnv.cmd"
wsl --update || REM WSL->WSL2
ubuntu install --root || REM Install ubuntu
ubuntu run sudo apt-get update || REM Update ubuntu, because fresh installs aren't already fully updated for some reason
echo y|ubuntu run sudo apt-get upgrade