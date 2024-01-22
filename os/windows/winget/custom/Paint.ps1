#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME   = "Paint Installer"
$SCRIPT_LOG    = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"
$SCRIPT_SOURCE = "paintdotnet/release"

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
        [string]$Path,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$DestinationPath,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ShortcutName
    )

    Expand-Archive -Path $Path -DestinationPath $DestinationPath -Force
    Remove-Item $Path -Force
    Logger -Level debug -Message "Leftovers removed" -Structured "path ""$Path"""

    $shortcutPath = Join-Path -Path $env:PROGRAMDATA -ChildPath "Microsoft\Windows\Start Menu\Programs\$ShortcutName.lnk"
    $targetPath   = Join-Path -Path $DestinationPath -ChildPath "paintdotnet.exe"

    $wScriptObj = New-Object -ComObject WScript.Shell
    $shortcut   = $wScriptObj.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $targetPath
    $shortcut.Save()
    Logger -Level debug -Message "Shortcut created" -Structured "path ""$shortcutPath"""
}

$packagePath = Download-Package -Source $SCRIPT_SOURCE -FilePattern "*portable.x64.zip"
$pathExtract = Join-Path -Path $env:PROGRAMFILES -ChildPath "Paint.NET"

Install-Package -Path $packagePath -DestinationPath $pathExtract -ShortcutName "Paint.NET"
