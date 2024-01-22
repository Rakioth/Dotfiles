#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME   = "MicrosoftOffice Installer"
$SCRIPT_LOG    = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"
$SCRIPT_SOURCE = "https://www.microsoft.com/en-us/download/details.aspx?id=49117"

# Script values
$officeConfig = @"
<Configuration>
  <Add OfficeClientEdition="64" Channel="PerpetualVL2021">
    <Product ID="ProPlus2021Volume">
      <Language ID="en-us" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="OneNote" />
      <ExcludeApp ID="Outlook" />
      <ExcludeApp ID="Publisher" />
    </Product>
  </Add>
  <AppSettings>
    <Setup Name="Company" Value="Raks Labs" />
  </AppSettings>
  <Display Level="None" AcceptEULA="TRUE" />
</Configuration>
"@

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

    $downloadUri = ((Invoke-WebRequest -Uri $Source).Links | Where-Object { $_.href -like $FilePattern }).href
    $tempPath    = Join-Path -Path $env:TEMP -ChildPath "MicrosoftOffice"
    New-Item -ItemType Directory -Path $tempPath -Force
    Start-BitsTransfer -Source $downloadUri -Destination $tempPath
    $wrapper = (Resolve-Path -Path "$tempPath\*office*.exe").Path
    Start-Process -FilePath $wrapper -ArgumentList "/extract:$tempPath /quiet" -NoNewWindow -Wait
    Remove-Item $wrapper -Force
    Logger -Level debug -Message "Package downloaded" -Structured "path ""$tempPath"""
    return $tempPath
}

function Install-Package {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    $configPath = Join-Path -Path $Path -ChildPath "config.xml"
    $officeConfig | Out-File -FilePath $configPath
    $installer = Join-Path -Path $Path -ChildPath "setup.exe"
    Start-Process -FilePath $installer -ArgumentList "/configure $configPath" -NoNewWindow -Wait
    Remove-Item $Path -Force -Recurse
    Logger -Level debug -Message "Leftovers removed" -Structured "path ""$Path"""
}

$packagePath = Download-Package -Source $SCRIPT_SOURCE -FilePattern "*.exe"
Install-Package -Path $packagePath.FullName
& ([ScriptBlock]::Create((irm https://massgrave.dev/get))) /Ohook
