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
        Owner = "ryanoasis"
        Name  = "nerd-fonts"
    }

    Fonts = @{
        PackagePattern = "CascadiaCode.zip"
        FilePattern    = "*NerdFontMono*"
        FontName       = "CaskaydiaCove"
        FontType       = " (TrueType)"
    }

    Paths = @{
        TempFolder   = "NerdFonts"
        FontsPath    = Join-Path -Path $env:WINDIR -ChildPath "Fonts"
        RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
    }
}

function Test-FontsInstalled {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FontPattern
    )

    $installedFonts = Get-ItemProperty -Path $Config.Paths.RegistryPath |
        Get-Member -MemberType NoteProperty |
        Where-Object { $_.Name -like "*$FontPattern*" }
    $installedFonts.Count -gt 0
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

function Download-FontPackage {
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

function Install-FontsFromArchive {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ArchivePath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DownloadPath
    )

    Expand-Archive -Path $ArchivePath -DestinationPath $DownloadPath -Force
    $fontFiles = Get-ChildItem -Path $DownloadPath -Filter $Config.Fonts.FilePattern

    $fontFiles | ForEach-Object {
        $fontName = $_.Name.Replace($_.Extension, $Config.Fonts.FontType)
        Set-ItemProperty -Path $Config.Paths.RegistryPath -Name $fontName -Value $_.Name -Type String
        Copy-Item -Path $_.FullName -Destination $Config.Paths.FontsPath -Force
    }
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
    if (Test-FontsInstalled -FontPattern $Config.Fonts.FontName) {
        exit $Config.ExitCodes.AlreadyInstalled
    }

    $downloadUrl = Get-LatestReleaseDownloadUrl -Owner $Config.Repository.Owner -Repository $Config.Repository.Name -FilePattern $Config.Fonts.PackagePattern
    if (-not $downloadUrl) {
        exit $Config.ExitCodes.InstallerNotAvailable
    }

    $packagePath = Download-FontPackage -DownloadUrl $downloadUrl
    if (-not (Test-Path -Path $packagePath)) {
        exit $Config.ExitCodes.InstallerNotAvailable
    }

    $tempDownloadPath = Join-Path -Path $env:TEMP -ChildPath $Config.Paths.TempFolder
    Install-FontsFromArchive -ArchivePath $packagePath -DownloadPath $tempDownloadPath
    exit $Config.ExitCodes.Success
} catch {
    exit $Config.ExitCodes.GeneralError
} finally {
    Remove-TemporaryFiles -Path $packagePath
    Remove-TemporaryFiles -Path $tempDownloadPath
}
