title Creating MKLinks..
mklink /j "%localappdata%\LGHUB\" "D:\%username%\AppData\Local\LGHUB\"
mklink /j "%appdata%\.minecraft" "D:\%username%\AppData\Local\.minecraft"
mklink /J "C:\Program Files\Epic Games" "D:\Games\EpicLibrary"
mklink /J "C:\ProgramData\Epic" "D:\Games\EpicLibrary\Epic"

::tf2, not really mklinks but shut up
set sourceDir="D:\Program Files (x86)\Steam\steamapps\common\Team Fortress 2\tf"
set tfDir="C:\Users\folfy\steam\steamapps\common\Team Fortress 2\tf"

mkdir %tfDir%
xcopy /Y /V /E %sourceDir% %tfDir%