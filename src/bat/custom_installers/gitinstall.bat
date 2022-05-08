winget install %wingetargs% --id "Git.Git"
call "%SetupFolder%tools\RefreshEnv.cmd"
::Add git shortcuts and preferences
git config --global alias.submit "!git add -A && git commit && git push" || REM Don't judge me I'm lazy ok
git config --global alias.upstreamfetch "!git fetch upstream && git checkout master && git reset --hard upstream/master || ECHO.Add your upstream repo with git remote add upstream /url/to/original/repo"
git config --global core.editor "'C:\Program Files\Sublime Text\subl.exe' -nw"