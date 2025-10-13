#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

$Config = @{
    ExitCodes = @{
        Success               = 0
        GeneralError          = 1
        InstallerNotAvailable = -1978335212
        AlreadyInstalled      = -1978335189
    }

    Repository = @{
        Owner = "dinoDanic"
        Name  = "diny"
    }

    Applications = @{
        Target      = "diny"
        ArchiveName = "diny_Windows_x86_64.zip"
    }

    Paths = @{
        TempFolder       = "Diny"
        InstallationPath = "$env:LOCALAPPDATA\Microsoft\WinGet\Links"
    }
}

function Test-ApplicationInstalled {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationName
    )

    $output = Get-Command -Name $ApplicationName -ErrorAction SilentlyContinue
    $null -ne $output
}

function Get-LatestReleaseDownloadUrl {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Owner,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Repository,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FilePattern
    )

    $releasesUri = "https://api.github.com/repos/$Owner/$Repository/releases/latest"
    $release     = Invoke-RestMethod -Method Get -Uri $releasesUri
    $asset       = $release.assets | Where-Object { $_.name -like $FilePattern } | Select-Object -First 1
    $asset.browser_download_url
}

function Download-ApplicationPackage {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DownloadUrl
    )

    $fileName = Split-Path -Path $DownloadUrl -Leaf
    $tempPath = Join-Path -Path $env:TEMP -ChildPath $fileName
    Start-BitsTransfer -Source $DownloadUrl -Destination $tempPath
    $tempPath
}

function Install-ApplicationFromArchive {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ArchivePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DownloadPath
    )

    Expand-Archive -Path $ArchivePath -DestinationPath $DownloadPath -Force
    $sourceExe = Join-Path -Path $DownloadPath -ChildPath "$( $Config.Applications.Target ).exe"
    Move-Item -Path $sourceExe -Destination $Config.Paths.InstallationPath -Force
}

function Remove-TemporaryFiles {
    param(
        [Parameter(Mandatory = $false)]
        [string]$Path
    )

    if (Test-Path -Path $Path) {
        Remove-Item -Path $Path -Recurse -Force
    }
}

try {
    if (Test-ApplicationInstalled -ApplicationName $Config.Applications.Target) {
        exit $Config.ExitCodes.AlreadyInstalled
    }

    $downloadUrl = Get-LatestReleaseDownloadUrl -Owner $Config.Repository.Owner -Repository $Config.Repository.Name -FilePattern $Config.Applications.ArchiveName
    if (-not $downloadUrl) {
        exit $Config.ExitCodes.InstallerNotAvailable
    }

    $packagePath = Download-ApplicationPackage -DownloadUrl $downloadUrl
    if (-not (Test-Path -Path $packagePath)) {
        exit $Config.ExitCodes.InstallerNotAvailable
    }

    $tempDownloadPath = Join-Path -Path $env:TEMP -ChildPath $Config.Paths.TempFolder
    Install-ApplicationFromArchive -ArchivePath $packagePath -DownloadPath $tempDownloadPath
    exit $Config.ExitCodes.Success
} catch {
    exit $Config.ExitCodes.GeneralError
} finally {
    Remove-TemporaryFiles -Path $packagePath
    Remove-TemporaryFiles -Path $tempDownloadPath
}
