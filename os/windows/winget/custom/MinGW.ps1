#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME   = "MinGW Installer"
$SCRIPT_LOG    = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"
$SCRIPT_SOURCE = "brechtsanders/winlibs_mingw"

# Logger
function Logger {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("none", "debug", "info", "warn", "error", "fatal")]
        [string]$Level = "none",
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,
        [Parameter(Mandatory = $false)]
        [string]$Structured
    )

    Start-Process -FilePath gum -ArgumentList "log --file $SCRIPT_LOG --time timeonly --level $Level --prefix ""$SCRIPT_NAME"" --structured ""$Message"" $Structured" -NoNewWindow
}

# Helper
function Download-Package {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Source,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FilePattern
    )

    $releasesUri = "https://api.github.com/repos/$Source/releases/latest"
    $downloadUri = ((Invoke-RestMethod -Method GET -Uri $releasesUri).assets | Where-Object { $_.name -like $FilePattern -and -not ($_.name -like "*llvm*") }).browser_download_url
    $fileName    = Split-Path -Path $downloadUri -Leaf
    $tempPath    = Join-Path -Path $env:TEMP -ChildPath $fileName
    Start-BitsTransfer -Source $downloadUri -Destination $tempPath
    Logger -Level debug -Message "Package downloaded" -Structured "path ""$tempPath"""
    return $tempPath
}

function Install-Package {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DestinationPath
    )

    Expand-Archive -Path $Path -DestinationPath $DestinationPath -Force
    Remove-Item $Path -Force
    Logger -Level debug -Message "Leftovers removed" -Structured "path ""$Path"""

    $binPath       = Join-Path -Path $DestinationPath -ChildPath "mingw64\bin"
    $persistedPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) -split ";"
    if ($persistedPath -notcontains $binPath) {
        $persistedPath += $binPath
        [Environment]::SetEnvironmentVariable("Path", $persistedPath -join ";", [EnvironmentVariableTarget]::User)
    }
    Logger -Level debug -Message "Binaries added to PATH" -Structured "path ""$binPath"""
}

$packagePath = Download-Package -Source $SCRIPT_SOURCE -FilePattern "*x86*.zip"
Install-Package -Path $packagePath -DestinationPath $env:PROGRAMFILES
