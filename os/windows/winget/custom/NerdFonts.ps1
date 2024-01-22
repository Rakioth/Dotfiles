#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME   = "NerdFonts Installer"
$SCRIPT_LOG    = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"
$SCRIPT_SOURCE = "ryanoasis/nerd-fonts"

# Script values
$fontsPath    = Join-Path -Path $env:WINDIR -ChildPath "Fonts"
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"

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
        [string]$Path
    )

    $tempPath = Join-Path -Path $env:TEMP -ChildPath "NerdFonts"
    Expand-Archive -Path $Path -DestinationPath $tempPath -Force

    Get-ChildItem -Path $tempPath -Filter "*NerdFontMono*" | ForEach-Object {
        Set-ItemProperty -Path $registryPath -Name $_.Name.Replace($_.Extension, " (TrueType)") -Value $_.Name -Type String
        Copy-Item -Path $_.FullName -Destination $fontsPath -Force
    }

    Remove-Item $Path, $tempPath -Recurse -Force
    Logger -Level debug -Message "Leftovers removed" -Structured "path ""$Path"" path ""$tempPath"""
}

$packagePath = Download-Package -Source $SCRIPT_SOURCE -FilePattern "CascadiaCode.zip"
Install-Package -Path $packagePath
