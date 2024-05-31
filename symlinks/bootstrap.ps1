#Requires -PSEdition Core

# Script variables
$SCRIPT_NAME    = "Symlinks Applier"
$SCRIPT_VERSION = "v1.0.1"
$SCRIPT_LOG     = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"

# Script colors
$PURPLE = "#ce3ed6"
$VIOLET = "#c698f2"
$GREEN  = "#6dca7b"
$BLUE   = "#11a8cd"

# Script values
$dotbotPath          = Join-Path -Path $env:DOTFILES -ChildPath "modules\dotbot\bin\dotbot"
$defaultSymlinksFile = Join-Path -Path $env:DOTFILES -ChildPath "symlinks\conf.windows.yaml"
$symlinksFile        = ""
$defaultHelp         = @"
Usage:
  symlink [<flag>]

Flags:
  -h, --help       Show context-sensitive help.
  -v, --version    Print the version number.
  -f, --file       Applies all the symlinks in a file.
                   Defaults to: $defaultSymlinksFile

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

# Arguments
if ($args.Length -gt 0) {
    switch ($args[0]) {
        { $_ -eq "-h" -or $_ -eq "--help" } {
            Write-Host $defaultHelp
            exit 0
        }
        { $_ -eq "-v" -or $_ -eq "--version" } {
            Write-Host "$SCRIPT_NAME $SCRIPT_VERSION"
            exit 0
        }
        { $_ -eq "-f" -or $_ -eq "--file" } {
            $symlinksFile = gum file --cursor="❯" --height=10 --file --no-show-help --cursor.foreground=$PURPLE --symlink.foreground=$BLUE --selected.foreground="" --directory.foreground=$VIOLET --file.foreground=$GREEN $( $defaultSymlinksFile | Split-Path -Parent )
        }
        default {
            Write-Host $defaultHelp
            exit 1
        }
    }
}

# If symlinks file is not specified, use the default location
if (-not $symlinksFile) {
    $symlinksFile = $defaultSymlinksFile
}

# Check if the symlinks file exists
if (-not (Test-Path -Path $symlinksFile -PathType Leaf)) {
    if ($symlinksFile -eq $defaultSymlinksFile) {
        Logger -Level warn -Message "Default symlinks file not found" -Structured "file ""$defaultSymlinksFile"""
        Write-Host $defaultHelp
    }
    else {
        Write-Host "File does not exist: $symlinksFile" -ForegroundColor Red
    }
    exit 1
}

# Apply the symlinks
$symlinksLabel = gum style --foreground=$VIOLET symlinks
gum spin --spinner="moon" --title="Applying $symlinksLabel..." --show-output -- python $dotbotPath -d $env:DOTFILES -c $symlinksFile
Logger -Level debug -Message "Symlinks applied" -Structured "file ""$symlinksFile"""
