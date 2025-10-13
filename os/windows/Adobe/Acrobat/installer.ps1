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

    Urls = @{
        BaseUrl    = "https://pb.wtf"
        SearchPath = "/tracker/"
    }

    Patterns = @{
        ReleasePage = "/t/"
        MagnetLink  = "magnet"
        TitleMatch  = "Adobe Acrobat Pro.*x64"
    }

    Applications = @{
        Target     = "Adobe Acrobat"
        Downloader = "qBittorrent.qBittorrent"
    }

    Paths = @{
        TempFolder       = "AdobeAcrobat"
        IsoSearchPattern = "*Acrobat*\*Acrobat*iso"
        SetupPattern     = "*Adobe*\Setup.exe"
        CrackPattern     = "*Adobe*\crack.exe"
    }

    LanguageCodes = @{
        "en" = 1033
        "es" = 1034
    }

    DefaultLanguage = "en"
}

function Test-ApplicationInstalled {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationName
    )

    $output = Invoke-Expression -Command "winget list --exact --accept-source-agreements --name '$ApplicationName'"
    $LASTEXITCODE -eq 0
}

function Get-TorrentPageUrl {
    $formData = @{
        ss = $Config.Applications.Target
        pn = "m0nkrus"
    }

    $webRequest = Invoke-WebRequest -Uri "$( $Config.Urls.BaseUrl )$( $Config.Urls.SearchPath )" -Method Post -Body $formData -ContentType "application/x-www-form-urlencoded"
    $webRequest.Links |
        Where-Object { $_.href -match $Config.Patterns.ReleasePage -and $_.outerHTML -match $Config.Patterns.TitleMatch } |
        Select-Object -ExpandProperty "href" -First 1
}

function Get-FirstMatchingLink {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Url,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Pattern
    )

    $webRequest = Invoke-WebRequest -Uri $Url
    $webRequest.Links |
        Where-Object { $_.href -match $Pattern } |
        Select-Object -ExpandProperty "href" -First 1
}

function Get-ApplicationMagnetLink {
    $torrentPageUrl = Get-TorrentPageUrl
    $fullTorrentUrl = "$( $Config.Urls.BaseUrl )$torrentPageUrl"
    Get-FirstMatchingLink -Url $fullTorrentUrl -Pattern $Config.Patterns.MagnetLink
}

function Install-DownloaderApplication {
    winget install --exact --silent --accept-source-agreements --accept-package-agreements --id $Config.Applications.Downloader
}

function Set-DownloaderConfiguration {
    $downloaderConfigPath = "$env:APPDATA\qBittorrent\qBittorrent.ini"
    $dotfilesConfigPath   = "$env:DOTFILES\config\qbittorrent\qBittorrent.ini"

    $currentLinkTarget = $null
    if (Test-Path -Path $downloaderConfigPath) {
        $configItem        = Get-Item -Path $downloaderConfigPath
        $currentLinkTarget = $configItem.LinkTarget
    }

    if ($currentLinkTarget -ne $dotfilesConfigPath) {
        New-Item -ItemType SymbolicLink -Path $downloaderConfigPath -Target $dotfilesConfigPath -Force
    }
}

function Start-TorrentDownload {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$MagnetLink,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DownloadPath
    )

    $encodedMagnetLink = $MagnetLink.Replace(" ", "%20")
    $downloaderPath    = "$env:PROGRAMFILES\qBittorrent\qbittorrent.exe"
    $arguments         = "$encodedMagnetLink --save-path=$DownloadPath --skip-dialog=true"
    Start-Process -FilePath $downloaderPath -ArgumentList $arguments -WindowStyle Minimized -Wait
}

function Install-ApplicationFromISO {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DownloadPath
    )

    $isoPath     = (Resolve-Path -Path "$DownloadPath\$( $Config.Paths.IsoSearchPattern )").Path
    $mountResult = Mount-DiskImage -ImagePath $isoPath
    $driveLetter = ($mountResult | Get-Volume).DriveLetter

    try {
        $installerPath = (Resolve-Path -Path "$driveLetter`:\$( $Config.Paths.SetupPattern )").Path
        $enablerPath   = (Resolve-Path -Path "$driveLetter`:\$( $Config.Paths.CrackPattern )").Path

        $systemLanguage = (Get-SystemPreferredUILanguage).Substring(0, 2)
        $languageCode   = if ($Config.LanguageCodes.ContainsKey($systemLanguage)) {
            $Config.LanguageCodes[$systemLanguage]
        } else {
            $Config.LanguageCodes[$Config.DefaultLanguage]
        }

        $installArguments = "/sl ""$languageCode"" /sAll"
        Start-Process -FilePath $installerPath -ArgumentList $installArguments -NoNewWindow -Wait
        Start-Process -FilePath $enablerPath -NoNewWindow -Wait
    } finally {
        Dismount-DiskImage -ImagePath $isoPath
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
    if (Test-ApplicationInstalled -ApplicationName $Config.Applications.Target) {
        exit $Config.ExitCodes.AlreadyInstalled
    }

    $magnetLink = Get-ApplicationMagnetLink
    if (-not $magnetLink) {
        exit $Config.ExitCodes.InstallerNotAvailable
    }

    Install-DownloaderApplication
    Set-DownloaderConfiguration

    $tempDownloadPath = Join-Path -Path $env:TEMP -ChildPath $Config.Paths.TempFolder
    Start-TorrentDownload -MagnetLink $magnetLink -DownloadPath $tempDownloadPath

    Install-ApplicationFromISO -DownloadPath $tempDownloadPath
    exit $Config.ExitCodes.Success
} catch {
    exit $Config.ExitCodes.GeneralError
} finally {
    Remove-TemporaryFiles -Path $tempDownloadPath
}
