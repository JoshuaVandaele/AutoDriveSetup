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
    $WebResponse = Invoke-WebRequest -UseBasicParsing -Method 'POST' -Uri 'https://store.rg-adguard.net/api/GetFiles' -Body "type=url&url=$Uri&ring=Slow" -ContentType 'application/x-www-form-urlencoded'
    $LinksMatch = $WebResponse.Links | Where-Object { $_ -like '*.msixbundle*' } | Where-Object { $_ -like '*_neutral_*' -or $_ -like "*_" + $env:PROCESSOR_ARCHITECTURE.Replace("AMD", "X").Replace("IA", "X") + "_*" } | Select-String -Pattern '(?<=a href=").+(?=" r)'
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
    $ProgressPreference = 'SilentlyContinue'
    foreach ($url in $DownloadLinks)
    {
      $FileName = "MsixBundle.msixbundle"
      $FilePath = Join-Path $Path $FileName
      $FilePath = Resolve-NameConflict($FilePath)

      Write-Output "Downloading $url to $FilePath"
      Start-BitsTransfer -Source $url -Destination $FilePath
      Write-Output "Done"
      if ( ($ConfirmPreference -eq $false) -or $PSCmdlet.ShouldProcess($FileName, "Add Appx Package")) {
        Add-AppxPackage -Path $FilePath
        Remove-Item -Path $FilePath
      }
    }
  }
}

New-Item -Path $env:TEMP -Name "WSAInstall" -ItemType "directory"
Set-Location $env:TEMP\WSAInstall
Get-AppxPackageDownload 'https://www.microsoft.com/store/productId/9P3395VX91NR'