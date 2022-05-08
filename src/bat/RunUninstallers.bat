title Uninstalling Junk..

call %SetupFolder%src\custom_uninstallers\1drive.bat

::Preinstalled junk
PowerShell -File "%SetupFolder%src\ps\AppxCleaner.ps1"

::Remove unwanted tasks
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentLogOn" /Disable
schtasks /Change /TN "Microsoft\Office\OfficeTelemetryAgentFallBack" /Disable
schtasks /Change /TN "Microsoft\Office\Office 15 Subscription Heartbeat" /Disable