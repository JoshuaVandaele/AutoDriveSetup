:: Usage - CALL CreateLNK.bat SOURCE DESTINATION
:: Example: CALL CreateLNK.bat "Dolphin.exe" "%USERPROFILE%\Start Menu\Programs\Startup\Dolphin.lnk"
:: Made by Folfy Blue

SET SOURCE=%~1
SET DESTINATION=%~2

set SCRIPT="%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%.vbs"

echo Set oWS = WScript.CreateObject("WScript.Shell") > %SCRIPT%
echo sLinkFile = "%DESTINATION%" >> %SCRIPT%
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> %SCRIPT%
echo oLink.TargetPath = "%SOURCE%" >> %SCRIPT%
echo oLink.IconLocation = "%SOURCE%, 0" >> %SCRIPT%
echo oLink.WindowStyle = 1 >> %SCRIPT%
echo oLink.WorkingDirectory = "%INSTALL_LOCATION%" >> %SCRIPT%
echo oLink.Save >> %SCRIPT%

cscript /nologo %SCRIPT%
del %SCRIPT%