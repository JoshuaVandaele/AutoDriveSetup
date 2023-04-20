SET WORKING_DIR=%TEMP%\%RANDOM%-%RANDOM%-%RANDOM%-%RANDOM%
MKDIR %WORKING_DIR%
cd /d %WORKING_DIR%

::Update python's pip, because apparently it doesn't come with the latest pip version
python.exe -m pip install --upgrade pip

:: Use a tool created by JeeZeh, go check it out at the link below
git clone https://github.com/JeeZeh/steam-shortcut-generator ssg

:: Download Python 3.7 (Required for this script to work)
mkdir python-3.7
cd python-3.7
curl https://www.python.org/ftp/python/3.7.0/python-3.7.0-embed-amd64.zip -o python-3.7.0-embed-amd64.zip

:: Extract ZIP file
tar -xf python-3.7.0-embed-amd64.zip

del python37._pth
:: Download pip
curl https://bootstrap.pypa.io/get-pip.py -L -o get-pip.py
"./python.exe" get-pip.py
cd ..

cd ssg

:: Recreate steam shortcuts
"../python-3.7/python.exe" -m pip install -U -r requirements.txt

echo.folfy_blue>stdin.txt
echo.y>>stdin.txt
echo.y>>stdin.txt
echo.y>>stdin.txt

type stdin.txt|"../python-3.7/python.exe" steam_shortcuts.py

:: Clean up
cd /d %WORKING_DIR%/..
rmdir /s /q %WORKING_DIR%