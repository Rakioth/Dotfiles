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
        DownloadUrl = "https://downloader.battle.net/download/getInstaller?os=win&installer=Battle.net-Setup.exe"
    }

    Applications = @{
        Target = "Battle.net"
    }

    Paths = @{
        TempFileName     = "Battle.net-Setup.exe"
        InstallationPath = "C:\Program Files (x86)\Battle.net"
    }

    LanguageCodes = @{
        "en" = "enUS"
        "es" = "esES"
    }

    DefaultLanguage = "en"
}

function Test-ApplicationInstalled {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApplicationName
    )

    $output = Invoke-Expression -Command "winget list --accept-source-agreements --name '$ApplicationName'"
    $LASTEXITCODE -eq 0
}

function Download-ApplicationInstaller {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Source,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FileName
    )

    $tempPath = Join-Path -Path $env:TEMP -ChildPath $FileName
    Start-BitsTransfer -Source $Source -Destination $tempPath
    $tempPath
}

function Install-ApplicationFromExecutable {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$InstallerPath,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$InstallationPath
    )

    $systemLanguage = (Get-SystemPreferredUILanguage).Substring(0, 2)
    $languageCode   = if ($Config.LanguageCodes.ContainsKey($systemLanguage)) {
        $Config.LanguageCodes[$systemLanguage]
    } else {
        $Config.LanguageCodes[$Config.DefaultLanguage]
    }

    $installArguments = "--lang=$languageCode --installpath=""$InstallationPath"""
    Start-Process -FilePath $InstallerPath -ArgumentList $installArguments -NoNewWindow -Wait
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

    $installerPath = Download-ApplicationInstaller -Source $Config.Urls.DownloadUrl -FileName $Config.Paths.TempFileName
    if (-not (Test-Path -Path $installerPath)) {
        exit $Config.ExitCodes.InstallerNotAvailable
    }

    Install-ApplicationFromExecutable -InstallerPath $installerPath -InstallationPath $Config.Paths.InstallationPath
    exit $Config.ExitCodes.Success
} catch {
    exit $Config.ExitCodes.GeneralError
} finally {
    Remove-TemporaryFiles -Path $installerPath
}
