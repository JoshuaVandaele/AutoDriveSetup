title Uninstalling Junk..

::Fuck OneDrive
taskkill /f /im OneDrive.exe
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
%SystemRoot%\System32\OneDriveSetup.exe /uninstall
rmdir /S /Q %onedrive%
rmdir /S /Q %USERPROFILE%\OneDrive
REG delete HKCU\Environment /F /V "OneDrive"
REG delete HKCU\Environment /F /V "OneDriveConsumer"

::Preinstalled junk
PowerShell -Command "Get-AppxPackage *Candy* | Remove-AppxPackage"

::Remove unwanted tasks
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable
schtasks /Change /TN "Microsoft\Office\Office 15 Subscription Heartbeat" /Disable