# From https://gist.github.com/mavaddat/26146d111abf62f6160b1bd02a392ba8
function Get-AppxPackageDownload
{
  [CmdletBinding(SupportsShouldProcess=$true)]
  param (
    [Parameter(Mandatory=$true,ValueFromPipeline)]
    [ValidateScript({[uri]::TryCreate($_, [UriKind]::Absolute, [ref]$null)})]
    [string]$Uri,
    [ValidateScript({Test-Path -Path $_ -PathType Container})]
    [string]$Path = "$PWD"
  )
   
  process
  {
    $Path = (Resolve-Path $Path).Path
    #Get Urls to download
    $WebResponse = Invoke-WebRequest -UseBasicParsing -Method 'POST' -Uri 'https://store.rg-adguard.net/api/GetFiles' -Body "type=url&url=$Uri&ring=Retail" -ContentType 'application/x-www-form-urlencoded'
    $LinksMatch = $WebResponse.Links | Where-Object { $_ -like '*.appx*' } | Where-Object { $_ -like '*_neutral_*' -or $_ -like "*_" + $env:PROCESSOR_ARCHITECTURE.Replace("AMD", "X").Replace("IA", "X") + "_*" } | Select-String -Pattern '(?<=a href=").+(?=" r)'
    $DownloadLinks = $LinksMatch.matches.value 

    function private:Resolve-NameConflict
    {
      #Accepts Path to a FILE and changes it so there are no name conflicts
      param(
        [string]$Path
      )
      $newPath = $Path
      if (Test-Path $Path -PathType Leaf)
      {
        $i = 0;
        $item = (Get-Item $Path)
        while ( (Test-Path $newPath -PathType Leaf) -and ($i -lt [int]([math]::Sqrt([int]::MaxValue))))
        {
          $i += 1;
          $newPath = Join-Path $item.DirectoryName ($item.BaseName + "($i)" + $item.Extension)
        }
      }
      return $newPath
    }
    #Download Urls
    foreach ($url in $DownloadLinks)
    {
      $FileRequest = Invoke-WebRequest -Uri $url -UseBasicParsing #-Method Head
      $FileName = ($FileRequest.Headers["Content-Disposition"] | Select-String -Pattern  '(?<=filename=).+').matches.value
      $FilePath = Join-Path $Path $FileName
      $FilePath = Resolve-NameConflict($FilePath)
      [System.IO.File]::WriteAllBytes($FilePath, $FileRequest.content) | Out-Null
      if ( ($ConfirmPreference -eq $false) -or $PSCmdlet.ShouldProcess($FileName, "Add Appx Package")) {
        Add-AppxPackage -Path $FilePath
      }
    }
  }
}

New-Item -Path $env:TEMP -Name "wingetinstall" -ItemType "directory"
Set-Location $env:TEMP\wingetinstall
Get-AppxPackageDownload 'https://www.microsoft.com/store/productId/9nblggh4nns1'
foreach($file in Get-ChildItem $env:TEMP\wingetinstall)
{
  Add-AppxPackage -Path $env:TEMP\wingetinstall\$file
}
# Don't ask me why we need to run it two times, it doesn't work otherwise
Invoke-WebRequest -Uri "https://github.com/microsoft/winget-cli/releases/download/v1.2.10271/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -OutFile "$env:TEMP\wingetinstall\DesktopAppInstaller.msix"
Add-AppxPackage -Path "$env:TEMP\wingetinstall\DesktopAppInstaller.msix"
Get-AppXPackage -allusers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}

