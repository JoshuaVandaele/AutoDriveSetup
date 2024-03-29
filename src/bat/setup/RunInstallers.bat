title Installing Apps..

::Install chocolatey
powershell /command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted"
powershell /command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

::Install winget
::https://www.microsoft.com/store/productId/9nblggh4nns1
call "%SetupFolder%src\bat\setup\RunInstaller" "powershell" "%SetupFolder%src\installers\InstallWinget.ps1" 
call "%SetupFolder%src\tools\RefreshEnv.cmd"
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "App Installer"

::Install.. everything else
call "%SetupFolder%src\tools\RefreshEnv.cmd"
choco feature enable -n allowGlobalConfirmation

::User software
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "ShareX.ShareX" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "VideoLAN.VLCNightly" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "WinSCP.WinSCP" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "7zip.7zip" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "WinDirStat.WinDirStat" 
call "%SetupFolder%src\bat\setup\RunInstaller" "choco" cheatengine
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "qBittorrent.qBittorrent"
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Lexikos.AutoHotkey"
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Mozilla.Firefox.DeveloperEdition"
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Google.Drive"
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Discord.Discord" 

::Dev
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Git.Git" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Microsoft.WindowsTerminal" 
call "%SetupFolder%src\bat\setup\RunInstaller" "batch" "%SetupFolder%src\installers\ubuntu.bat" 
call "%SetupFolder%src\bat\setup\RunInstaller" "powershell" "%SetupFolder%src\installers\InstallWSA.ps1" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Microsoft.VisualStudio.2022.Community" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Microsoft.VisualStudioCode" 
call "%SetupFolder%src\bat\setup\RunInstaller" "batch" "%SetupFolder%src\installers\HxD.bat" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Google.AndroidStudio" 
call "%SetupFolder%src\bat\setup\RunInstaller" "batch" "%SetupFolder%src\installers\rustup.bat" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "rjpcomputing.luaforwindows"
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Python.Python.3" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "OpenJS.NodeJS.LTS"
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Oracle.JavaRuntimeEnvironment" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "UnityTechnologies.UnityHub" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Oracle.VirtualBox" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Microsoft.OpenJDK.17"

::Gaming
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "EpicGames.EpicGamesLauncher"
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "StefanSundin.Superf4" 
call "%SetupFolder%src\bat\setup\RunInstaller" "batch" "%SetupFolder%src\installers\Dolphin.bat" 
call "%SetupFolder%src\bat\setup\RunInstaller" "batch" "%SetupFolder%src\installers\SteamShortcuts.bat" 

::Office
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "LibreOffice.LibreOffice" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "KDE.Krita" 

::Hardware
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "Nvidia.GeForceExperience" 
call "%SetupFolder%src\bat\setup\RunInstaller" "winget" "REALiX.HWiNFO" 

choco feature disable -n allowGlobalConfirmation
call "%SetupFolder%src\tools\RefreshEnv.cmd"

::Tasks to run at the next start of windows
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "ShareX" /d "%SetupFolder%files\ShareXUploader.sxcu" || REM Add ShareX's Custom Uploader by running it at next restart
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "WallpaperEngine" /d "D:\Program Files (x86)\Steam\steam.exe -applaunch 431960" || REM Install Wallpaper Engine at next restart

::Windows Updates
echo y|powershell /command "Install-Module PSWindowsUpdate -Force"
powershell /command "Get-WindowsUpdate"
powershell /command "Install-WindowsUpdate"

::Windows app store updates
powershell /command "Get-CimInstance -Namespace 'Root\cimv2\mdm\dmmap' -ClassName 'MDM_EnterpriseModernAppManagement_AppManagement01' | Invoke-CimMethod -MethodName UpdateScanMethod"

::All other updates
winget upgrade --all --accept-source-agreements --accept-package-agreements