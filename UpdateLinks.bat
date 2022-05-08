@echo off
::Elevate to administrator privileges if you do not have them
CALL "D:\SETUP\src\tools\getadmin.bat" %~dpf0

:setup
copy /y /v "%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" "D:\SETUP\files\WT\settings.json" || REM Windows Terminal settings file