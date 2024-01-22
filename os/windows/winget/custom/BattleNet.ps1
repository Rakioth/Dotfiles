#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME   = "BattleNet Installer"
$SCRIPT_LOG    = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"
$SCRIPT_SOURCE = "https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"

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

    $tempPath = Join-Path -Path $env:TEMP -ChildPath $FilePattern
    Start-BitsTransfer -Source $Source -Destination $tempPath
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

    Start-Process -FilePath $Path -ArgumentList "--lang=enUS --installpath=""$DestinationPath""" -NoNewWindow -Wait
    Remove-Item $Path -Force
    Logger -Level debug -Message "Leftovers removed" -Structured "path ""$Path"""
}

$packagePath      = Download-Package -Source $SCRIPT_SOURCE -FilePattern "Battle.net-Setup.exe"
$pathInstallation = "C:\Program Files (x86)\Battle.net"

Install-Package -Path $packagePath -DestinationPath $pathInstallation
