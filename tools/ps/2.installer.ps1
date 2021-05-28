choco feature enable -n allowGlobalConfirmation

#Communication
winget install "Google.Chrome"
choco install google-backup-and-sync
winget install "Discord.DiscordCanary"
winget install "Discord.Discord"

#User software
winget install "ShareX.ShareX"
winget install "VideoLAN.VLCNightly"
winget install "WinSCP.WinSCP"
winget install "7zip"
winget install "WinDirStat"
choco install cheatengine
choco install utorrent
winget install "Lexikos.AutoHotkey"
winget install "LogMeIn.LastPasswin"

#Dev
winget install "Windows Terminal"
winget install "SublimeHQ.SublimeText.4"
winget install "Canonical.Ubuntu"
winget install "Microsoft.VisualStudio.2019.Community"
winget install "Python.Python"
choco install lua
winget install "Oracle.JavaRuntimeEnvironment"
winget install "UnityTechnologies.UnityHub"
winget install "Git.Git"

#Gaming
winget install "EpicGames.EpicGamesLauncher"
winget install "Oculus"

#Office
winget install "LibreOffice.LibreOffice"
winget install "KDE.Krita"

#Hardware
winget install "Nvidia.GeForceExperience"
winget install "REALiX.HWiNFO"

choco feature disable -n allowGlobalConfirmation