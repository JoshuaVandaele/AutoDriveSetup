cd "%SetupFolder%files"

::Install Discord and needed Powercord components
winget install %wingetargs% --id "Discord.DiscordCanary"
winget install %wingetargs% --id "Git.Git"
winget install %wingetargs% --id "OpenJS.NodeJS.LTS"
call "%SetupFolder%tools\RefreshEnv.cmd"

::Download and inject powercord
git clone https://github.com/powercord-org/powercord
cd powercord
git pull
npm i
npm run plug

::Restart Discord if it's launched
tasklist /fi "ImageName eq DiscordCanary.exe" | find "DiscordCanary.exe"
if %errorlevel% == 0 (
	taskkill DiscordCanary.exe
	"%localappdata%\DiscordCanary\Update.exe" --processStart DiscordCanary.exe
)