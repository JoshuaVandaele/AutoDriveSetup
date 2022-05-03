::Install Discord and needed Powercord components
winget install %wingetargs% --id "Discord.Discord.Canary"
winget install %wingetargs% --id "OpenJS.NodeJS.LTS"
call "%SetupFolder%scripts\custom_installers\gitinstall.bat"
call "%SetupFolder%tools\RefreshEnv.cmd"

::Download and inject powercord
cd "%SetupFolder%files"
git clone https://github.com/powercord-org/powercord
cd powercord
git config --global --add safe.directory %SetupFolder%files/powercord
git pull
npm i
npm audit fix
npm update
npm i
npm run plug

::Restart Discord if it's launched
tasklist /fi "ImageName eq DiscordCanary.exe" | find "DiscordCanary.exe"
if %errorlevel% == 0 (
	taskkill DiscordCanary.exe
	"%localappdata%\DiscordCanary\Update.exe" --processStart DiscordCanary.exe
)