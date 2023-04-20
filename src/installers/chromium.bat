set INSTALL_LOCATION=%ProgramW6432%\Chromium

mkdir "%INSTALL_LOCATION%"

mkdir %TEMP%
cd /d %TEMP%

:: Download chromium
curl -L https://download-chromium.appspot.com/dl/Win_x64?type=snapshots -o chrome-win.zip

:: Extract ZIP file
tar -xf chrome-win.zip

:: Move chromium to its installation dir
ROBOCOPY chrome-win "%INSTALL_LOCATION%" /MOVE /E

:: Create a start menu shortcut
call "%SetupFolder%src\tools\CreateLNK.bat" "%INSTALL_LOCATION%\chrome.exe" "%USERPROFILE%\Start Menu\Programs\Startup\Chromium.lnk"

:: Clean up
del chrome-win.zip