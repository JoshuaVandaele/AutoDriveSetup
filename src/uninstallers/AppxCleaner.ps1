$Appx = @(
    "*Candy*"
    "*MicrosoftTeams*"
    "*Disney*"
    "*Spotify*"
    "*Facebook*"
    "*Amazon*"
    "*Hulu*"
    "*Pics*"
    "*TikTok*"
    "*Shazam*"
    "*Adobe*"
    "*OneDrive"
    "*king*"
    "*Advertising*"
)

# Stole from https://github.com/LeDragoX/Win-10-Smart-Debloat-Tools/blob/35536f928281beb9b127ec72cf72ea29a4e473fe/src/lib/remove-uwp-apps.psm1
ForEach ($Bloat in $Appx) {
    If ((Get-AppxPackage -AllUsers -Name $Bloat) -or (Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat)) {
        Get-AppxPackage -AllUsers -Name $Bloat | Remove-AppxPackage # App
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online -AllUsers # Payload
    }
}