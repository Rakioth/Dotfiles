#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME   = "AdobePhotoshop Installer"
$SCRIPT_LOG    = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"
$SCRIPT_SOURCE = "https://pb.wtf/t/400331"

# Script values
$systemLanguage    = (Get-SystemPreferredUILanguage).Replace("-", "_")
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

    $isPackageInstalled = ((winget.exe list --exact $Package) -join "").Contains($Package)

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
    $tempPath    = Join-Path -Path $env:TEMP -ChildPath "AdobePhotoshop"
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

    $disk        = (Resolve-Path -Path "$Path\*Photoshop*\*Photoshop*iso").Path
    $driveLetter = (Mount-DiskImage $disk | Get-Volume).DriveLetter
    Logger -Level debug -Message "Disk mounted" -Structured "iso ""$disk"""
    $installer    = (Resolve-Path -Path "$driveLetter`:\*Adobe*\*.exe").Path
    $installerJob = Start-Job -ScriptBlock { Start-Process -FilePath $args[0] -ArgumentList "--silent=1 --lang=$systemLanguage" -NoNewWindow -Wait } -ArgumentList $installer
    $installerJob | Wait-Job | Remove-Job
    Dismount-DiskImage $disk
    Logger -Level debug -Message "Disk dismounted" -Structured "iso ""$disk"""
    Remove-Item $Path -Force -Recurse
    Logger -Level debug -Message "Leftovers removed" -Structured "path ""$Path"""
}

Install-Dependency -Package "qBittorrent.qBittorrent"
Config-Dependency

$packagePath = Download-Package -Source $SCRIPT_SOURCE -FilePattern "magnet"
Install-Package -Path $packagePath
