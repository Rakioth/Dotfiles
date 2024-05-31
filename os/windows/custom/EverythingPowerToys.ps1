#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME   = "EverythingPowerToys Installer"
$SCRIPT_LOG    = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"
$SCRIPT_SOURCE = "lin-ycv/EverythingPowerToys"

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
    $downloadUri = ((Invoke-RestMethod -Method GET -Uri $releasesUri).assets | Where-Object { $_.name -like $FilePattern }).browser_download_url
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
}

Install-Dependency -Package "voidtools.Everything"
Install-Dependency -Package "Microsoft.PowerToys"

$packagePath = Download-Package -Source $SCRIPT_SOURCE -FilePattern "*-x64.zip"
$pathExtract = Join-Path -Path $env:PROGRAMFILES -ChildPath "PowerToys\RunPlugins"

# If the path does not exist, try the user folder
if (-not (Test-Path -Path $pathExtract -PathType Container)) {
    $pathExtract = Join-Path -Path $env:LOCALAPPDATA -ChildPath "PowerToys\RunPlugins"
}

# Stop the process to avoid errors
Stop-Process -Name PowerToys
Logger -Level debug -Message "Stoping process" -Structured "process PowerToys"
Install-Package -Path $packagePath -DestinationPath $pathExtract

# Start the process again
$executablePath = Join-Path -Path ($pathExtract | Split-Path) -ChildPath "PowerToys.exe"
Start-Process -FilePath $executablePath
Logger -Level debug -Message "Starting process" -Structured "process ""$executablePath"""
