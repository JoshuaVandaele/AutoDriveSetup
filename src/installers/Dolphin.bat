REM Requirements:
REM    - git
REM    - Visual Studio Community 2022
REM       - C++ Tools & Windows 11 SDK

set INSTALL_LOCATION=%ProgramW6432%\Dolphin

mkdir "%INSTALL_LOCATION%"
cd /d "%INSTALL_LOCATION%"

:: INSTALL REQUIRED VS COMPONENTS
"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" modify ^
    --installPath="C:\Program Files\Microsoft Visual Studio\2022\Community" ^
    --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Core ^
    --add Microsoft.VisualStudio.Component.Windows11SDK.22000 ^
    --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 ^
    -q

:: CLONES DOLPHIN AND INSTALL ITS DEPENDENCIES
git clone https://github.com/dolphin-emu/dolphin.git dolphin_source
cd dolphin_source
git submodule update --init

:: BUILD DOLPHIN
call "c:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
msbuild -v:m -m -p:Platform=x64,Configuration=Release Source\dolphin-emu.sln

:: MOVE EXECUTABLE TO INSTALL LOCATION
ROBOCOPY Binary/x64 "%INSTALL_LOCATION%" /MOVE /E

:: Custom PATH for the UserDirectory (Instead of %AppData%\Dolphin Emulator)
REG ADD "HKEY_CURRENT_USER\Software\Dolphin Emulator" /v "LocalUserConfig" /t REG_SZ /d 1 /f
REG ADD "HKEY_CURRENT_USER\Software\Dolphin Emulator" /v "UserDirectory" /t REG_SZ /d "%SetupFolder%\Dolphin" /f

:: REMOVE FILES USED FOR BUILD
cd ..
rmdir /s /q dolphin_source

:: CREATES A START MENU SHORTCUT
call "%SetupFolder%src\tools\CreateLNK.bat" "%INSTALL_LOCATION%\Dolphin.exe" "%USERPROFILE%\Start Menu\Programs\Startup\Dolphin.lnk"