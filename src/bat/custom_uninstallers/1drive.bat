taskkill /f /im OneDrive.exe
taskkill /f /im explorer.exe
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
%SystemRoot%\System32\OneDriveSetup.exe /uninstall

cd /d %SystemDrive%\

FOR /F "tokens=* USEBACKQ" %%F IN (`dir /S /B *onedrive*`) DO (
  TAKEOWN /F "%%F" /r /d y
  ICACLS "%%F" /grant %username%:F /T
  RMDIR /S /Q "%%F"
  DEL /S /F /Q "%%F"
)

set tempreg="%temp%\nuke1driveFromReg.reg"
echo.Windows Registry Editor Version 5.00>%tempreg%
FOR /F "tokens=* USEBACKQ" %%F IN (`REG QUERY HKLM /S /f "onedrive" /k`) DO (
  echo.[-%%F]>>%tempreg%
)
REG IMPORT %tempreg%
DEL /S /F /Q %tempreg%

cd /d %SetupFolder%
explorer.exe