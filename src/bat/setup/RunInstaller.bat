set wingetargs=--accept-package-agreements --accept-source-agreements --silent

set packageManager=%1
set package=%2

if %packageManager%=="winget" (winget install %wingetargs% --id %package%)
if %packageManager%=="choco" (choco install %package%)
if %packageManager%=="batch" (call %package%)

cd /d %SetupFolder%
call "%SetupFolder%\src\tools\RefreshEnv.cmd"