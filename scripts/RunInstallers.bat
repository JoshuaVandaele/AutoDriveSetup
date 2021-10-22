title Installing Apps..
::Install chocolatey
powershell /command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted"
powershell /command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

::Install.. everything else
call "%SetupFolder%\tools\RefreshEnv.cmd"
choco feature enable -n allowGlobalConfirmation

::Communication
start winget install --id "Google.Chrome"
start choco install google-backup-and-sync
start winget install --id "Discord.DiscordCanary"
start winget install --id "Discord.Discord"

::User software
start winget install --id "ShareX.ShareX"
start winget install --id "VideoLAN.VLCNightly"
start winget install --id "WinSCP.WinSCP"
start winget install --id "7zip"
start winget install --id "WinDirStat"
start choco install cheatengine
start choco install utorrent
start winget install --id "Lexikos.AutoHotkey"
start winget install --id "LogMeIn.LastPasswin"

::Dev
start winget install --id "Windows Terminal"
start winget install --id "SublimeHQ.SublimeText.4"
start winget install --id "Canonical.Ubuntu"
start winget install --id "Microsoft.VisualStudio.2019.Community"
start winget install --id "Python.Python.3"
start winget install --id "Google.AndroidStudio"
start choco install lua
start winget install --id "Oracle.JavaRuntimeEnvironment"
start winget install --id "UnityTechnologies.UnityHub"
start winget install --id "Git.Git"
start winget install --id "JetBrains.IntelliJIDEA.Community"
start winget install --id "Oracle.VirtualBox"
start winget install --id "TexasInstruments.TIConnectCE"

::Gaming
start winget install --id "EpicGames.EpicGamesLauncher"
start winget install --id "Oculus"
start winget install --id "StefanSundin.Superf4"

::Office
start winget install --id "LibreOffice.LibreOffice"
start winget install --id "KDE.Krita"

::Hardware
start winget install --id "Nvidia.GeForceExperience"
start winget install --id "REALiX.HWiNFO"

choco feature disable -n allowGlobalConfirmation
call "%SetupFolder%\tools\RefreshEnv.cmd"

::WSL/Ubuntu
wsl --update || REM WSL->WSL2
ubuntu2004 install --root || REM Install ubuntu
ubuntu2004 run sudo apt-get update || REM Update ubuntu, because fresh installs aren't already fully updated for some reason
echo y|ubuntu2004 run sudo apt-get upgrade

::Update python's pip, because apparently it doesn't come with the latest pip version
python.exe -m pip install --upgrade pip

::Recreate steam shortcuts
pip install urllib3 || REM Installing required libraries for steam shortcut
pip install pillow
echo D:/Games/SteamLibrary|python "%SetupFolder%\tools\steamshortcut.py" || REM Credits go to https://github.com/JeeZeh/steam-shortcut-generator
robocopy /MOVE "%SetupFolder%/shortcuts" "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Steam Games" || REM Move shortcuts to the start menu
robocopy /MOVE "%SetupFolder%/tools/shortcuts" "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Steam Games" || REM Sometimes it doesn't work, idk
del /F /Q "%SetupFolder%/error_log.txt" || REM Delete error logs it generates every time for some reason
del /F /Q "%SetupFolder%/tools/error_log.txt"
del /F /Q "%SetupFolder%/scripts/error_log.txt"

::Tasks to run at the next start of windows
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "ShareX" /d "%SetupFolder%\files\ShareXUploader.sxcu" || REM Add ShareX's Custom Uploader by running it at next restart

::Windows Updates
powershell /command "Install-Module PSWindowsUpdate -Force"
powershell /command "Get-WindowsUpdate"
powershell /command "Install-WindowsUpdate"