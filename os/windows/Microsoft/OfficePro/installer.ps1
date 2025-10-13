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
        DownloadPage     = "https://www.microsoft.com/en-us/download/details.aspx?id=49117"
        ActivationScript = "aAB0AHQAcABzADoALwAvAGcAZQB0AC4AYQBjAHQAaQB2AGEAdABlAGQALgB3AGkAbgA="
    }

    Applications = @{
        Target = "Microsoft Office"
    }

    Paths = @{
        TempFolder = "MicrosoftOffice"
        ConfigFile = "config.xml"
        SetupFile  = "setup.exe"
    }

    Office = @{
        Edition      = "64"
        Channel      = "PerpetualVL2024"
        ProductId    = "ProPlus2024Volume"
        ExcludedApps = @("Access", "Groove", "Lync", "OneDrive", "OneNote", "Outlook", "Publisher")
    }

    LanguageCodes = @{
        "en" = "en-us"
        "es" = "es-es"
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

function Get-LatestReleaseDownloadUrl {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DownloadPageUrl,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FilePattern
    )

    $webRequest = Invoke-WebRequest -Uri $DownloadPageUrl
    $webRequest.Links |
        Where-Object { $_.href -like $FilePattern } |
        Select-Object -ExpandProperty "href" -First 1
}

function Download-ApplicationInstaller {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Source
    )

    $tempPath = Join-Path -Path $env:TEMP -ChildPath $Config.Paths.TempFolder
    New-Item -ItemType Directory -Path $tempPath -Force | Out-Null
    Start-BitsTransfer -Source $Source -Destination $tempPath

    $archivePath = (Resolve-Path -Path "$tempPath\*office*.exe").Path
    Start-Process -FilePath $archivePath -ArgumentList "/extract:$tempPath /quiet" -NoNewWindow -Wait
    $tempPath
}

function Get-ApplicationConfigurationXml {
    $systemLanguage = (Get-SystemPreferredUILanguage).Substring(0, 2)
    $languageCode = if ($Config.LanguageCodes.ContainsKey($systemLanguage)) {
        $Config.LanguageCodes[$systemLanguage]
    } else {
        $Config.LanguageCodes[$Config.DefaultLanguage]
    }

    $excludedAppsXml = ($Config.Office.ExcludedApps | ForEach-Object { "      <ExcludeApp ID=""$_"" />" }) -join "`n"

    @"
<Configuration>
  <Add OfficeClientEdition="$( $Config.Office.Edition )" Channel="$( $Config.Office.Channel )">
    <Product ID="$( $Config.Office.ProductId )">
      <Language ID="MatchOS" />
      <Language ID="$languageCode" />
$excludedAppsXml
    </Product>
    <Product ID="ProofingTools">
      <Language ID="MatchOS" />
      <Language ID="$languageCode" />
    </Product>
  </Add>
  <Updates Enabled="FALSE" />
  <Display Level="None" AcceptEULA="TRUE" />
  <Logging Level="Off" />
</Configuration>
"@
}

function Install-ApplicationFromExecutable {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$InstallerPath
    )

    $configPath    = Join-Path -Path $InstallerPath -ChildPath $Config.Paths.ConfigFile
    $installerPath = Join-Path -Path $InstallerPath -ChildPath $Config.Paths.SetupFile

    $appConfig = Get-ApplicationConfigurationXml
    $appConfig | Out-File -FilePath $configPath

    $installArguments = "/configure $configPath"
    Start-Process -FilePath $installerPath -ArgumentList $installArguments -NoNewWindow -Wait
}

function Invoke-ApplicationActivation {
	$activationUrl    = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($Config.Urls.ActivationScript))
    $activationScript = Invoke-RestMethod -Uri $activationUrl
    $scriptBlock      = [ScriptBlock]::Create($activationScript)
    & $scriptBlock /Ohook
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

    $downloadUrl = Get-LatestReleaseDownloadUrl -DownloadPageUrl $Config.Urls.DownloadPage -FilePattern "*.exe"
    if (-not $downloadUrl) {
        exit $Config.ExitCodes.InstallerNotAvailable
    }

    $installerPath = Download-ApplicationInstaller -Source $downloadUrl
    if (-not (Test-Path -Path $installerPath)) {
        exit $Config.ExitCodes.InstallerNotAvailable
    }

    Install-ApplicationFromExecutable -InstallerPath $installerPath
    Invoke-ApplicationActivation
    exit $Config.ExitCodes.Success
} catch {
    exit $Config.ExitCodes.GeneralError
} finally {
    Remove-TemporaryFiles -Path $installerPath
}
