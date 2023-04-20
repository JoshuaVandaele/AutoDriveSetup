cd /d %TEMP%

:: Download installer
curl https://win.rustup.rs/x86_64 -o rustup-init.exe

:: Run installer
rustup-init.exe -y

:: Clean up
del rustup-init.exe