title Uninstalling Junk..

call %SetupFolder%src\custom_uninstallers\1drive.bat

::Preinstalled junk
PowerShell -Command "Get-AppxPackage *Candy* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *MicrosoftTeams* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Disney* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *Spotify* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *faceb* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *adobe* | Remove-AppxPackage"
PowerShell -Command "Get-AppxPackage *prime* | Remove-AppxPackage"

::Remove unwanted tasks
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable
schtasks /Change /TN "Microsoft\Office\Office 15 Subscription Heartbeat" /Disable