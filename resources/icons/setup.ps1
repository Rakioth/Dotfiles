#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME = "Icons Setup"
$SCRIPT_LOG  = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"

# Script values
$iconsPath      = Join-Path -Path $env:DOTFILES -ChildPath "resources\icons"
$shortcutsPaths = @(
    Join-Path -Path $env:PROGRAMDATA -ChildPath "Microsoft\Windows\Start Menu\Programs"
    Join-Path -Path $env:APPDATA     -ChildPath "Microsoft\Windows\Start Menu\Programs"
)
$excludeFolders = @(
    "Accessibility"
    "Accessories"
    "Administrative Tools"
    "Maintenance"
    "Microsoft Office Tools"
    "Startup"
    "System Tools"
    "Windows Accessories"
    "Windows PowerShell"
    "Windows System"
    "Windows Tools"
)

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
function Move-Shortcut {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [System.IO.FileSystemInfo]$ShortcutFile
    )

    $shortcutPath = $shortcutsPaths | Where-Object { $ShortcutFile.DirectoryName -like "$_*" }
    $parsedPath   = $ShortcutFile.DirectoryName.Replace($shortcutPath, "")

    $shortcutDestination = Join-Path -Path $shortcutPath -ChildPath $ShortcutFile.Name
    $shortcutRoot        = Join-Path -Path $shortcutPath -ChildPath ($parsedPath -split "\\")[1]

    Move-Item -Path $ShortcutFile.FullName -Destination $shortcutDestination -Force
    Logger -Level debug -Message "Shortcut moved" -Structured "path ""$( $ShortcutFile.FullName )"""
    return $shortcutRoot
}

$excludePattern = '\b(?:' + ($excludeFolders -join "|") + ')\b'
$shortcutsFiles = Get-ChildItem -Path $shortcutsPaths -Filter "*.lnk" -Recurse | Where-Object { $_.DirectoryName -notmatch $excludePattern }
$iconsFiles     = Get-ChildItem -Path $iconsPath -Filter "*.ico"

$iconsFiles | ForEach-Object {
    $iconBaseName      = [System.IO.Path]::GetFileNameWithoutExtension($_.Name)
    $matchingShortcuts = $shortcutsFiles | Where-Object { $_.BaseName -like "$iconBaseName*" }

    # If no matching shortcut is found, skip to the next icon
    if (-not $matchingShortcuts) {
        Logger -Level warn -Message "Shortcut not found" -Structured "icon ""$( $_.FullName )"""
        return
    }

    $removeList = @()
    foreach ($matchingShortcut in $matchingShortcuts) {
        $wScriptObj            = New-Object -ComObject WScript.Shell
        $shortcut              = $wScriptObj.CreateShortcut($matchingShortcut.FullName)
        $shortcut.IconLocation = $_.FullName
        $shortcut.Save()
        Logger -Level debug -Message "Shortcut updated" -Structured "path ""$( $matchingShortcut.FullName )"""

        # If the shortcut is not in the expected path, move it
        if (-not ($shortcutsPaths -contains $matchingShortcut.DirectoryName)) {
            $removeList += Move-Shortcut -ShortcutFile $matchingShortcut
        }
    }

    Remove-Item -Path $removeList -Force -Recurse
    Logger -Level debug -Message "Leftovers removed"
}
