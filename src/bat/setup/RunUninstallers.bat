title Uninstalling Junk..

call %SetupFolder%src\custom_uninstallers\1drive.bat
call %SetupFolder%src\custom_uninstallers\edge.bat

::Preinstalled junk
PowerShell -File "%SetupFolder%src\uninstallers\AppxCleaner.ps1"

::Remove unwanted tasks
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable
schtasks /Change /TN "Microsoft\Office\Office 15 Subscription Heartbeat" /Disable