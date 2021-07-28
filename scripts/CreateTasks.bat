title Creating Scheduled Tasks..
::Cipher the non-used part of my drive so deleted files are unrecoverable
REM SCHTASKS /CREATE /SC MONTHLY /TN "MyTasks\CipherC" /TR "Cipher.exe /w:C:" /ST 00:00
SCHTASKS /CREATE /SC MONTHLY /TN "MyTasks\CipherD" /TR "Cipher.exe /w:D:" /ST 00:00

::Update all apps winget has to offer.
SCHTASKS /CREATE /SC WEEKLY /TN "MyTasks\Updater" /TR "%localappdata%\Microsoft\WindowsApps\winget.exe upgrade --all" /ST 03:00
