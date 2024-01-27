#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME   = "Noesis Installer"
$SCRIPT_LOG    = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"
$SCRIPT_SOURCE = "https://www.richwhitehouse.com"

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
    $tempPath    = Join-Path -Path $env:TEMP -ChildPath "noesis.zip"
    Start-BitsTransfer -Source "https://www.richwhitehouse.com/$( $downloadUri[-1] )" -Destination $tempPath
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
    $targetPath   = Join-Path -Path $DestinationPath -ChildPath "Noesis64.exe"

    $wScriptObj          = New-Object -ComObject WScript.Shell
    $shortcut            = $wScriptObj.CreateShortcut($shortcutPath)
    $shortcut.TargetPath = $targetPath
    $shortcut.Save()
    Logger -Level debug -Message "Shortcut created" -Structured "path ""$shortcutPath"""
}

$packagePath = Download-Package -Source "$SCRIPT_SOURCE/index.php?content=inc_res.php" -FilePattern "*noesisv*.zip"
$pathExtract = Join-Path -Path $env:PROGRAMFILES -ChildPath "Noesis"

Install-Package -Path $packagePath -DestinationPath $pathExtract -ShortcutName "Noesis"
