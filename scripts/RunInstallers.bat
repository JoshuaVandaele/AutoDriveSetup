title Installing Apps..

::Install chocolatey
powershell /command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted"
powershell /command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

::Install.. everything else
call "%SetupFolder%tools\RefreshEnv.cmd"
choco feature enable -n allowGlobalConfirmation

::Communication
call RunInstaller "winget" "Google.Chrome"
call RunInstaller "winget" "Google.Drive"
call RunInstaller "winget" "Discord.Discord" 
call RunInstaller "batch" "%SetupFolder%scripts\custom_installers\powercord.bat"

::User software
call RunInstaller "winget" "ShareX.ShareX" 
call RunInstaller "winget" "VideoLAN.VLCNightly" 
call RunInstaller "winget" "WinSCP.WinSCP" 
call RunInstaller "winget" "7zip.7zip" 
call RunInstaller "winget" "WinDirStat.WinDirStat" 
call RunInstaller "choco" cheatengine
call RunInstaller "winget" "qBittorrent.qBittorrent"
call RunInstaller "winget" "Lexikos.AutoHotkey"

::Dev
call RunInstaller "winget" "Microsoft.WindowsTerminal" 
call RunInstaller "winget" "SublimeHQ.SublimeText.4" 
call RunInstaller "batch" "%SetupFolder%scripts\custom_installers\ubuntu.bat" 
call RunInstaller "winget" "Microsoft.VisualStudio.2019.Community" 
call RunInstaller "winget" "Google.AndroidStudio" 
call RunInstaller "choco" "lua"
call RunInstaller "winget" "Python.Python.3" 
call RunInstaller "winget" "Oracle.JavaRuntimeEnvironment" 
call RunInstaller "winget" "UnityTechnologies.UnityHub" 
call RunInstaller "winget" "JetBrains.IntelliJIDEA.Community" 
call RunInstaller "winget" "Oracle.VirtualBox" 
call RunInstaller "winget" "TexasInstruments.TIConnectCE" 
call RunInstaller "winget" "Microsoft.OpenJDK.17"

::Gaming
call RunInstaller "winget" "EpicGames.EpicGamesLauncher"
call RunInstaller "winget" "StefanSundin.Superf4" 

::Office
call RunInstaller "winget" "LibreOffice.LibreOffice" 
call RunInstaller "winget" "KDE.Krita" 

::Hardware
call RunInstaller "winget" "Nvidia.GeForceExperience" 
call RunInstaller "winget" "REALiX.HWiNFO" 

choco feature disable -n allowGlobalConfirmation
call "%SetupFolder%tools\RefreshEnv.cmd"

::Update python's pip, because apparently it doesn't come with the latest pip version
python.exe -m pip install --upgrade pip

::Recreate steam shortcuts
pip install urllib3 pillow vdf || REM Installing required libraries for steam shortcut
echo folfy_blue|python "%SetupFolder%tools\steamshortcut.py" || REM Credits go to https://github.com/JeeZeh/steam-shortcut-generator
del /F /Q "%SetupFolder%error_log.txt" || REM Delete error logs it generates every time for some reason
del /F /Q "%SetupFolder%tools/error_log.txt"
del /F /Q "%SetupFolder%scripts/error_log.txt"

::Tasks to run at the next start of windows
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "ShareX" /d "%SetupFolder%files\ShareXUploader.sxcu" || REM Add ShareX's Custom Uploader by running it at next restart
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "WallpaperEngine" /d "D:\Program Files (x86)\Steam\steam.exe -applaunch 431960" || REM Install Wallpaper Engine at next restart

::Windows Updates
powershell /command "Install-Module PSWindowsUpdate -Force"
powershell /command "Get-WindowsUpdate"
powershell /command "Install-WindowsUpdate"

::Windows app store updates
powershell /command "Get-CimInstance -Namespace 'Root\cimv2\mdm\dmmap' -ClassName 'MDM_EnterpriseModernAppManagement_AppManagement01' | Invoke-CimMethod -MethodName UpdateScanMethod"

::All other updates
winget upgrade --all