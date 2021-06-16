title Creating Scheduled Tasks..
::Cipher the non-used part of my C drive so deleted files are unrecoverable
SCHTASKS /CREATE /SC DAILY /TN "MyTasks\Cipher" /TR "Cipher.exe /w:C:" /ST 00:00
::Update all apps winget has to offer. Not sure if it works?
SCHTASKS /CREATE /SC DAILY /TN "MyTasks\Updater" /TR "%localappdata%\Microsoft\WindowsApps\winget.exe upgrade --all" /ST 03:00
