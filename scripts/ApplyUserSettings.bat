title Applying your settings..
::Set refreshrates (Requires a restart)
"%SetupFolder%\tools\ChangeScreenResolution.exe" /f=165

::Spam f8 to get into the good ole recovery menu
bcdedit /set "{current}" bootmenupolicy legacy

::Allow symlinks thru Remote to local and Remote to Remote
fsutil behavior set SymlinkEvaluation R2L:1
fsutil behavior set SymlinkEvaluation R2R:1

::Windows Features
powershell /command  "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart"
powershell /command  "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart"

::Enable hibernation option
powercfg.exe /hibernate on

::Add git shortcuts
git config --global alias.submit "!git add -A && git commit && git push" || REM Don't judge me I'm lazy ok

::Move settings files
copy /y /v "%SetupFolder%\files\WT\settings.json" "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" || REM Windows terminal settings

::Reg files
for /r %%f in ("%SetupFolder%regedit\*") do (reg import "%%f")

::Show file extensions in Explorer
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t  REG_DWORD /d 0 /f

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