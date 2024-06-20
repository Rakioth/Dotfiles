#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME   = "AdobeAcrobat Installer"
$SCRIPT_LOG    = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"
$SCRIPT_SOURCE = "https://pb.wtf/t/400153"

# Script values
# https://helpx.adobe.com/enterprise/using/deploying-acrobat.html
$languageCodes     = @{
    "en-US" = 1033
    "es-ES" = 1034
}
$systemLanguage    = if ($languageCodes.ContainsKey((Get-SystemPreferredUILanguage))) { $languageCodes[(Get-SystemPreferredUILanguage)] } else { $languageCodes["en-US"] }
$qBittorrent       = Join-Path -Path $env:PROGRAMFILES -ChildPath "qBittorrent\qbittorrent.exe"
$qBittorrentConfig = Join-Path -Path $env:APPDATA      -ChildPath "qBittorrent\qBittorrent.ini"
$qBittorrentLink   = Join-Path -Path $env:DOTFILES     -ChildPath "config\qbittorrent\qBittorrent.ini"

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
function Install-Dependency {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Package
    )

    $isPackageInstalled = ((winget.exe list --accept-source-agreements --exact $Package) -join "").Contains($Package)

    if ($isPackageInstalled) {
        Logger -Level debug -Message "Dependency already installed" -Structured "dependency $Package"
        return
    }

    winget.exe install --exact --silent --accept-source-agreements --accept-package-agreements --id $Package

    if ($LastExitCode -eq 0) {
        Logger -Level debug -Message "Dependency installed" -Structured "dependency $Package"
    }
    else {
        Logger -Level error -Message "Dependency could not be installed" -Structured "dependency $Package"
        exit 1
    }
}

function Config-Dependency {
    if ((Get-Item $qBittorrentConfig).LinkTarget -eq $qBittorrentLink) {
        Logger -Level debug -Message "Symbolic link already exists" -Structured "link ""$qBittorrentLink"""
        return
    }

    Start-Process -FilePath $qBittorrent -ArgumentList "--skip-dialog=true" -WindowStyle Minimized
    Start-Sleep -Seconds 3
    Stop-Process -Name qbittorrent
    Logger -Level debug -Message "Config file generated" -Structured "qbittorrent ""$qBittorrentConfig"""

    if (Test-Path -Path $qBittorrentConfig -PathType Leaf) {
        Remove-Item $qBittorrentConfig -Force
    }
    New-Item -ItemType SymbolicLink -Path $qBittorrentConfig -Target $qBittorrentLink -Force
    Logger -Level debug -Message "Symbolic link created" -Structured "link ""$qBittorrentLink"""
}

function Download-Package {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Source,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FilePattern
    )

    $downloadUri = ((Invoke-WebRequest -Uri $Source).Links | Where-Object { $_.href -match $FilePattern }).href
    $tempPath    = Join-Path -Path $env:TEMP -ChildPath "AdobeAcrobat"
    Start-Process -FilePath $qBittorrent -ArgumentList "$downloadUri --save-path=$tempPath --skip-dialog=true" -WindowStyle Minimized -Wait
    Logger -Level debug -Message "Package downloaded" -Structured "path ""$tempPath"""
    return $tempPath
}

function Install-Package {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    $disk        = (Resolve-Path -Path "$Path\*Acrobat*\*Acrobat*iso").Path
    $driveLetter = (Mount-DiskImage $disk | Get-Volume).DriveLetter
    Logger -Level debug -Message "Disk mounted" -Structured "iso ""$disk"""
    $installer    = (Resolve-Path -Path "$driveLetter`:\*Adobe*\Setup.exe").Path
    $enabler      = (Resolve-Path -Path "$driveLetter`:\*Adobe*\crack.exe").Path
    Start-Process -FilePath $installer -ArgumentList "/sl ""$systemLanguage"" /sAll" -NoNewWindow -Wait
    Start-Process -FilePath $enabler -NoNewWindow -Wait
    Dismount-DiskImage $disk
    Logger -Level debug -Message "Disk dismounted" -Structured "iso ""$disk"""
    Remove-Item $Path -Force -Recurse
    Logger -Level debug -Message "Leftovers removed" -Structured "path ""$Path"""
}

# Check if real-time protection is enabled
if ((Get-MpComputerStatus).RealTimeProtectionEnabled) {
    Logger -Level error -Message "Real-time protection is enabled" -Structured "requirement disabled"
    exit 1
}

Install-Dependency -Package "qBittorrent.qBittorrent"
Config-Dependency

$packagePath = Download-Package -Source $SCRIPT_SOURCE -FilePattern "magnet"
Install-Package -Path $packagePath
