winget install %wingetargs% --id "Canonical.Ubuntu"
call "%SetupFolder%src\tools\RefreshEnv.cmd"
wsl --install
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "UbuntuInstall" /d "%SetupFolder%src\bat\RunOnce\finishUbuntuInstall.bat" || REM Ensures Ubuntu is up to date