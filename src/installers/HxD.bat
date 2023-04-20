cd /d %TEMP%

:: Download installer
curl https://mh-nexus.de/downloads/HxDSetup.zip -o HxDSetup.zip

:: Extract ZIP file
tar -xf HxDSetup.zip

:: Run installer
HxDSetup.exe ^
    /NORESTART ^
    /NOCLOSEAPPLICATIONS ^
    /NORESTARTAPPLICATIONS ^
    /VERYSILENT

:: Clean up
del HxDSetup.zip
del HxDSetup.exe