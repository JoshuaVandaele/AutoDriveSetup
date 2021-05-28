@echo off

set SetupFolder="D:\SETUP"

::Elevate to administrator privileges if you do not have them
net session >nul 2>&1 || REM Admin only command, if the error level is 0, it means we have admin privileges
if %errorLevel% == 0 (
  goto setup 
) else ( 
  powershell -command "Start-Process %0 -Verb runas" || REM Restart current batch file as admin
)
exit

:setup
cd /d "%SetupFolder%"
cls

::Allow symlinks thru Remote to local and Remote to Remote
fsutil behavior set SymlinkEvaluation R2L:1
fsutil behavior set SymlinkEvaluation R2R:1

::System tweaks, runs all the registry files in the regedit folder
for /r %%f in ("regedit\*") do (reg import "%%f")

::Install chocolatey
powershell /command "Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted"
powershell /command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

::Execute powershell scripts
call "C:\ProgramData\chocolatey\bin\RefreshEnv.cmd" || REM Got bless this script
for /r %%f in ("tools\ps\*") do (powershell -File %%f) || REM Runs all the powershell files in tools/ps
call "C:\ProgramData\chocolatey\bin\RefreshEnv.cmd"

::WSL stuff
wsl --update || REM WSL->WSL2
ubuntu2004 install --root || REM Install ubuntu
ubuntu2004 run sudo apt-get update || REM Update ubuntu, because fresh installs aren't already fully updated for some reason
echo y|ubuntu2004 run sudo apt-get upgrade

::Update python's pip, because apparently it doesn't come with the latest pip version
python.exe -m pip install --upgrade pip

::Enable hibernation option
powercfg.exe /hibernate on

::Recreate steam shortcuts
pip install urllib3 || REM Installing required libraries for steam shortcut
pip install pillow
echo D:/Games/SteamLibrary|python "%SetupFolder%\tools\steamshortcut.py" || REM Credits go to https://github.com/JeeZeh/steam-shortcut-generator
robocopy /MOVE "%SetupFolder%/shortcuts" "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Steam Games" || REM Move shortcuts to the start menu
robocopy /MOVE "%SetupFolder%/tools/shortcuts" "C:/ProgramData/Microsoft/Windows/Start Menu/Programs/Steam Games" || REM Sometimes it doesn't work, idk
del /F /Q "%SetupFolder%/error_log.txt" || REM Delete error logs it generates every time for some reason
del /F /Q "%SetupFolder%/tools/error_log.txt"

::Add git shortcuts
git config --global alias.submit "!git add -A && git commit && git push" || REM Don't judge me I'm lazy ok

::Move files
copy /y /v "%SetupFolder%\files\WT\settings.json" "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" || REM Windows terminal settings

::Task scheduling
SCHTASKS /CREATE /SC DAILY /TN "MyTasks\Cipher" /TR "Cipher.exe /w:C:" /ST 00:00 || REM Cipher the non-used part of my C drive so deleted files are unrecoverable
SCHTASKS /CREATE /SC DAILY /TN "MyTasks\Updater" /TR "%localappdata%\Microsoft\WindowsApps\winget.exe upgrade --all" /ST 03:00 || REM Update all apps winget has to offer. Not sure if it works?

::mklinks
mklink /j "%localappdata%\LGHUB\" "D:\folfy\AppData\Local\LGHUB\"
mklink /j "%appdata%\.minecraft" "D:\folfy\AppData\Local\.minecraft"
mklink /J "C:\Program Files\Epic Games" "D:\Games\EpicLibrary"
mklink /J "C:\ProgramData\Epic" "D:\Games\EpicLibrary\Epic"

::RunOnce tasks
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" /v "ShareX" /d "%SetupFolder%\files\ShareXUploader.sxcu" || REM Add ShareX's Custom Uploader by running it at next restart

::Fuck OneDrive
taskkill /f /im OneDrive.exe
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
rmdir /S /Q %onedrive%
REG delete HKCU\Environment /F /V "OneDrive"
REG delete HKCU\Environment /F /V "OneDriveConsumer"

::Set refreshrates (Requires a restart)
"%SetupFolder%\tools\ChangeScreenResolution.exe" /f=165

::Spam f8 to get into the good ole recovery menu
bcdedit /set "{current}" bootmenupolicy legacy

::Map network drives
runas /trustlevel:0x20000 "net use Z: \\server\5TBStockage\Stockage Josh"

::Reset indexing so new programs are visible
net stop wsearch
REG ADD "HKLM\SOFTWARE\Microsoft\Windows Search" /v SetupCompletedSuccessfully /t REG_DWORD /d 0 /f
del "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb"
:wsearch
  net start wsearch
  IF NOT %ERRORLEVEL%==0 (goto :wsearch) ELSE goto :wsearchEnd
:wsearchEnd