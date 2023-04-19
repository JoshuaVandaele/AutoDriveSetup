title Applying your settings..
::Set refreshrates (Requires a restart)
"%SetupFolder%src\tools\ChangeScreenResolution.exe" /f=165

::Spam f8 to get into the good ole recovery menu
bcdedit /set "{current}" bootmenupolicy legacy

::Allow symlinks thru Remote to local and Remote to Remote
fsutil behavior set SymlinkEvaluation R2L:1
fsutil behavior set SymlinkEvaluation R2R:1

::Windows Features
powershell /command  "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart"
powershell /command  "Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -All -NoRestart"
powershell /command  "Enable-WindowsOptionalFeature -Online -FeatureName TelnetClient -All -NoRestart"

::Rename Computer
powershell /command "Rename-Computer -NewName Desktop-Folfy"

::Enable hibernation option
powercfg.exe /hibernate on

::Move settings files
copy /y /v "%SetupFolder%files\WT\settings.json" "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" || REM Windows terminal settings

::Reg files
forfiles /P %SetupFolder%src\reg\ /C "cmd /c reg import @path"

::Hide the taskbar
powershell -command "&{$p='HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3';$v=(Get-ItemProperty -Path $p).Settings;$v[8]=3;&Set-ItemProperty -Path $p -Name Settings -Value $v;&Stop-Process -f -ProcessName explorer}"

::Remove old Desktop/Downloads/etc folder as the Reg file moved their location
RMDIR /S /Q "%USERPROFILE%\Desktop"
RMDIR /S /Q "%USERPROFILE%\Documents"
RMDIR /S /Q "%USERPROFILE%\Downloads"
RMDIR /S /Q "%USERPROFILE%\Videos"
RMDIR /S /Q "%USERPROFILE%\Pictures"
RMDIR /S /Q "%USERPROFILE%\Music"

::Maximum performence
powercfg /setactive SCHEME_MIN

::Map network drives
::runas /trustlevel:0x20000 "net use Z: \\server\5TBStockage\Stockage Josh"

::Reset indexing so new programs are visible
net stop wsearch
REG ADD "HKLM\SOFTWARE\Microsoft\Windows Search" /v SetupCompletedSuccessfully /t REG_DWORD /d 0 /f
del "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb"