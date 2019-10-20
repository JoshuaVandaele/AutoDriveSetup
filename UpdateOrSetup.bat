@ECHO off
setlocal enableextensions enabledelayedexpansion

title SETUP OF S:\
ECHO Please wait...

:: Asks for admin perm if not already given
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

:: LABEL OF THE VOLUME YOU WANT TO USE
set label="Games"

vol S: | findstr %label% && goto Ssetup 
vol S: | findstr "Volume in drive" && set replace=1

for %%p in (A B C D E F G H I J K L M N O P Q R T U V W X Y Z) do (
  vol %%p: 2>nul | findstr %label% && set curDrive=%%p
)

if "%replace%"=="1" do (
  ECHO.select volume S > %tmp%/ChangeDriveLetter.diskpart
  ECHO.assign >> %tmp%/ChangeDriveLetter.diskpart
  diskpart /s %tmp%/ChangeDriveLetter.diskpart
)

ECHO.select volume %curDrive% > %tmp%/ChangeDriveLetter.diskpart
ECHO.assign LETTER=S >> %tmp%/ChangeDriveLetter.diskpart
diskpart /s %tmp%/ChangeDriveLetter.diskpart

del %tmp%/ChangeDriveLetter.diskpart >nul 2>nul

:Ssetup

set /a symCount = 0
set /a fontCount = 0
for /f "usebackq skip=1 tokens=*" %%i in (`wmic useraccount where name^='%username%' get SID ^| findstr /r /v "^$"`) do set SID=%%i

:: Old folders
set old[0]="%appdata%"
set old[1]="%localappdata%"
set old[2]="%ProgramFiles(x86)%"
set old[3]="%ProgramFiles%"
set old[4]="%CommonProgramFiles(x86)%"
set old[5]="%CommonProgramFiles%"
set old[6]="%userprofile%\Documents"
set old[7]="%appdata%\..\LocalLow"
set old[8]="%ALLUSERSPROFILE%"
set old[9]="%USERPROFILE%"


:: New folder locations
set new[0]="S:\SFiles\Programs\AppData\Roaming"
set new[1]="S:\SFiles\Programs\AppData\Local"
set new[2]="S:\SFiles\Programs\Program Files (x86)"
set new[3]="S:\SFiles\Programs\Program Files"
set new[4]="S:\SFiles\Programs\Common Files (x86)"
set new[5]="S:\SFiles\Programs\Common Files"
set new[6]="S:\SFiles\Programs\Documents"
set new[7]="S:\SFiles\Programs\AppData\LocalLow"
set new[8]="S:\SFiles\Programs\ProgramData"
set new[9]="S:\SFiles\Programs\userdir"

cd /d S:

:: Start creating symlinks
FOR %%i IN (0,1,2,3,4,5,6,7,8,9) DO (
  mkdir !new[%%i]! >nul 2>nul
  cd !new[%%i]!
  FOR /D %%p IN (*) DO (
    set /a symCount += 1
    rmdir /S /Q !old[%%i]!\"%%p" >nul 2>nul
    mklink /J !old[%%i]!\"%%p" !new[%%i]!\"%%p" >nul 2>nul
    ECHO ^>!new[%%i]! ^|^| %%p 
  )
)
echo.Put your corresponding folders into these sub-folders and then run the setup script (example: put C:\Program Files\Steam\ to S:\SFiles\Program Files\Steam\>"S:\SFiles\Programs\HowToUse.txt"

:: Reading all locations on the disk so it's not slow
start "Reading file locations..." /D S: /MIN /REALTIME cmd /c "echo Giving the drive a spin, ignore this. && tree /F S:" 

CHOICE /C YN /T 30 /D N /M "Is this computer yours? (SOME INCHANGABLE MODIFICATIONS WILL BE APPORTED IF YOU SELECT YES.)"
IF ERRORLEVEL 2 GOTO END
:::::::::: SETTING UP FEATURES :::::::::::::::::
title Adding a few things....
ECHO.

:: Adding to the PATH my own directory
mkdir "S:\SFiles\PATH" >nul 2>nul
set np="S:\SFiles\PATH"
set Xtra="%np%\Python;%np%\Python\Scripts;%np%\Lua"
ECHO %path%|find /i "%np:"=%">nul  || setx /M PATH %PATH%;%np%;%Xtra% >nul 2>nul

:: Adding to the startup my own directory
mkdir S:\Sfiles\Startup\ >nul 2>nul
echo.for %%v in ('S:\Sfiles\Startup\*') do start '' '%%~v' > "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\startup.bat" >nul 2>nul &&  ECHO.Added startup programs

:: Edit Windows update settings
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v AUOptions /t REG_DWORD /d 4 /f >nul 2>nul &&                     ECHO.Updates will automatically install.
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU /v NoAutoRebootWithLoggedOnUsers /t REG_DWORD /d 1 /f >nul 2>nul && ECHO.Windows won't restart while you're logged in.

:: Customize Taskbar
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows /v AllowCortana /t REG_DWORD /d 0 /f >nul 2>nul &&                                   ECHO.Disabled Cortana.

:: Customize OS features in general
echo y|del %localappdata%\Microsoft\WindowsApps\py* >nul 2>nul
echo y|taskkill /f /im OneDrive.exe >nul 2>nul
echo y|%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall >nul 2>nul
reg add HKLM\SOFTWARE\Policies\Microsoft\Windows /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f >nul 2>nul &&                            ECHO.Disabled Microsoft's cloud service.

powershell -command "& {get-appxpackage *skype* | remove-appxpackage}"; "& {get-appxpackage *people* | remove-appxpackage}"; "& {get-appxpackage *getstarted* | remove-appxpackage}"; "& {get-appxpackage *officehub* | remove-appxpackage}"; "& {get-appxpackage *feedback* | remove-appxpackage}"; "& {get-appxpackage *messaging* | remove-appxpackage} "; "& {get-appxpackage *bing* | remove-appxpackage}";  "& {get-appxpackage *onenote* | remove-appxpackage}"
                                                                                                                                      ECHO.Uninstalled useless default Windows apps

reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer /v AllowOnlineTips /t REG_DWORD /d 0 /f >nul 2>nul &&        ECHO.We turned off Windows tips.
bcdedit /timeout 3 >nul 2>nul &&                                                                                                      ECHO.Boot menu timeout set to 3 seconds.
reg add HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v HideFileExt /t REG_DWORD /d 0 /f >nul 2>nul &&            ECHO.You can now see file extentions!
reg add HKLM\SOFTWARE\Microsoft\DataCollection /v AllowTelemetry /t REG_DWORD /d 0 /f >nul 2>nul &&                                   ECHO.Disabled Microsoft's keylogger.
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize /v AppsUseLightTheme /t REG_DWORD /d 0 /f >nul 2>nul &&     ECHO.Apps will now use the dark theme.
reg add HKLM\SOFTWARE\Microsoft\Windows\Current\Version\ImmersiveShell /v UseActionCenterExperience /t REG_DWORD /d 0 /f >nul 2>nul &&ECHO.Disabled Action Center.
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced /v UseOLEDTaskbarTransparency /t REG_DWORD /d 1 /f >nul 2>nul && ECHO.Enabled taskbar transparency.
reg add HKCU\USER\Control Panel\Desktop /v AutoEndTasks /t REG_DWORD /d 0 /f >nul 2>NUL &&                                            ECHO.Windows won't ask for you to close apps on shutdown.

%np%\SetACL.exe -on "HKCR\Directory\Background\shell\cmd" -ot reg -actn setowner -ownr "n:Administrators" >nul 2>nul
%np%\SetACL.exe -on "HKCR\Directory\Background\shell\cmd" -ot reg -actn ace -ace "n:Administrators;p:full" >nul 2>nul
ECHO Y|reg delete HKCR\Directory\Background\shell\cmd\ /v HideBasedOnVelocityId >nul 2>nul
reg add HKCR\Directory\Background\shell\cmd /v ShowBasedOnVelocityId /t REG_DWORD /d 6527944 /f >nul 2>nul
%np%\SetACL.exe -on "HKCR\Directory\Background\shell\Powershell" -ot reg -actn setowner -ownr "n:Administrators" >nul 2>nul
%np%\SetACL.exe -on "HKCR\Directory\Background\shell\Powershell" -ot reg -actn ace -ace "n:Administrators;p:full" >nul 2>nul
ECHO Y|reg delete HKCR\Directory\Background\shell\Powershell\ /v ShowBasedOnVelocityId >nul 2>nul
reg add HKCR\Directory\Background\shell\Powershell /v HideBasedOnVelocityId /t REG_DWORD /d 6527944 /f >nul 2>nul &&                  ECHO.Added CMD to extended context menu. || REM and it was way too hard what the fuck microsoft why do I need to download a program to modify my registry's perms

if exist "S:\SFiles\Programs\Program Files\Sublime Text 3\" (
  reg add "HKCR\*\shell\Open with Sublime Text" /v Icon   /t REG_SZ /d "S:\SFiles\Programs\Program Files\Sublime Text 3\sublime_text.exe,0" /f >nul 2>nul
  reg add "HKCR\*\shell\Open with Sublime Text" /ve /d "Open with &Sublime Text" /f >nul 2>nul
  reg add "HKCR\*\shell\Open with Sublime Text\command" /ve /d "S:\SFiles\Programs\Program Files\Sublime Text 3\sublime_text.exe \"%%1\"" /f >nul 2>nul && ECHO.Added "Open with Sublime Text" to the context menu.
)
if exist "S:\SFiles\Programs\Program Files\AutoHotkey\" (
  assoc .ahk=AutoHotkey >nul 2>nul
  ftype AutoHotkey="S:\SFiles\Programs\Program Files\AutoHotkey\AutoHotkey.exe" "%1" >nul 2>nul &&                                     ECHO.Associated Auto HotKey files.
)

:: Add shortcuts to desktop
copy "S:\SFiles\Others\Desktop" "%userprofile%\Desktop" >nul 2>nul &&                                                                  ECHO.Added shortcuts to your desktop.

:: Add fonts via Symlinks
ECHO.Checking if you have all avaible fonts.
mkdir "S:\SFiles\Others\fonts" >nul 2>nul
echo.Put all your ttf files here to make the computer install them using symlinks>"S:\SFiles\Others\fonts\HowToUse.txt" 
cd "S:\SFiles\Others\fonts"
for /R %%f in (*.ttf) DO (
  set file="%%~nf (TrueType)"
  ECHO N|reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v !file:-= ! /t REG_SZ /d "%%~nf.ttf" 2>NUL | findstr "succ" && ECHO.Added the font %%~nf && set /a fontCount += 1
  mklink "%systemroot%\fonts\%%~nf.ttf" "%%f" >nul 2>nul
)

::Install drivers & start them
if exist "C:\Program Files\Oracle\VirtualBox\drivers" (
  pnputil -i -a "C:\Program Files\Oracle\VirtualBox\drivers\vboxdrv\VBoxDrv.inf"
  net start vboxdrv
)

::THE END
:END
ECHO.
ECHO.Done, !symCount! symbolic links created and !fontCount! fonts added. 
if !fontCount gtr 0 echo Some fonts may require a restart to install properly.
ECHO.You may require to restart your computer for some features to work.
move "%0" "S:\SFiles\UpdateOrSetup.bat" >nul 2>nul
pause
