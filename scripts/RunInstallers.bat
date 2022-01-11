title Installing Apps..

set wingetargs=--accept-package-agreements --accept-source-agreements --silent

::Install chocolatey
powershell /command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted"
powershell /command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

::Install.. everything else
call "%SetupFolder%\tools\RefreshEnv.cmd"
choco feature enable -n allowGlobalConfirmation

::Communication
start winget install %wingetargs% --id "Google.Chrome" 
start winget install %wingetargs% --id "Google.Drive"
start winget install %wingetargs% --id "Discord.Discord" 
start "%SetupFolder%\scripts\custom_installers\powercord.bat"

::User software
start winget install %wingetargs% --id "ShareX.ShareX" 
start winget install %wingetargs% --id "VideoLAN.VLCNightly" 
start winget install %wingetargs% --id "WinSCP.WinSCP" 
start winget install %wingetargs% --id "7zip.7zip" 
start winget install %wingetargs% --id "WinDirStat.WinDirStat" 
start choco install cheatengine
start winget install %wingetargs% --id "qBittorrent.qBittorrent"
start winget install %wingetargs% --id "Lexikos.AutoHotkey" 
start winget install %wingetargs% --id "LogMeIn.LastPasswin" 

::Dev
start winget install %wingetargs% --id "Microsoft.WindowsTerminal" 
start winget install %wingetargs% --id "SublimeHQ.SublimeText.4" 
start winget install %wingetargs% --id "Python.Python.3" 
start "%SetupFolder%\scripts\custom_installers\ubuntu.bat" 
start winget install %wingetargs% --id "Microsoft.VisualStudio.2019.Community" 
start winget install %wingetargs% --id "Google.AndroidStudio" 
start choco install lua
start winget install %wingetargs% --id "Oracle.JavaRuntimeEnvironment" 
start winget install %wingetargs% --id "UnityTechnologies.UnityHub" 
REM start winget install --id "Git.Git" || REM Executed in custom_installers\powercord.bat
start winget install %wingetargs% --id "JetBrains.IntelliJIDEA.Community" 
start winget install %wingetargs% --id "Oracle.VirtualBox" 
start winget install %wingetargs% --id "TexasInstruments.TIConnectCE" 

::Gaming
start winget install %wingetargs% --id "EpicGames.EpicGamesLauncher"
start winget install %wingetargs% --id "StefanSundin.Superf4" 

::Office
start winget install %wingetargs% --id "LibreOffice.LibreOffice" 
start winget install %wingetargs% --id "KDE.Krita" 

::Hardware
start winget install %wingetargs% --id "Nvidia.GeForceExperience" 
start winget install %wingetargs% --id "REALiX.HWiNFO" 

choco feature disable -n allowGlobalConfirmation
call "%SetupFolder%\tools\RefreshEnv.cmd"

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

::Windows app store updates
powershell /command "Get-CimInstance -Namespace 'Root\cimv2\mdm\dmmap' -ClassName 'MDM_EnterpriseModernAppManagement_AppManagement01' | Invoke-CimMethod -MethodName UpdateScanMethod"

::All other updates
winget upgrade --all