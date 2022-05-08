taskkill /f /im OneDrive.exe
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
%SystemRoot%\System32\OneDriveSetup.exe /uninstall

cd /d %SystemDrive%\

FOR /F "tokens=* USEBACKQ" %%F IN (`dir /S /B /AD *onedrive*`) DO (
  RMDIR /S /Q %%F >OneDriveDirs.txt 2>nul
)

FOR /F "tokens=* USEBACKQ" %%F IN (`dir /S /B *onedrive*`) DO (
  DEL /S /F /Q %%F >OneDriveFiles.txt 2>nul
)

set tempreg="%temp%\nukeOnedriveFromReg.reg"
echo.Windows Registry Editor Version 5.00>%tempreg%
FOR /F "tokens=* USEBACKQ" %%F IN (`REG QUERY HKLM /S /f "onedrive" /k`) DO (
  echo.[-%%F]>>%tempreg%
)
REG IMPORT %tempreg%
DEL /S /F /Q %tempreg%

cd /d %SetupFolder%