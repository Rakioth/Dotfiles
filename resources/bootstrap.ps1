#Requires -PSEdition Core

# Script variables
$SCRIPT_NAME    = "Resource Loader"
$SCRIPT_VERSION = "v1.0.1"
$SCRIPT_LOG     = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"

# Script colors
$PURPLE = "#ce3ed6"
$VIOLET = "#c698f2"

# Script values
$resourcesPath  = Join-Path -Path $env:DOTFILES -ChildPath "resources"
$resourcesFiles = Get-ChildItem -Path $resourcesPath -Filter "main.ps1" -Recurse
$defaultHelp    = @"
Usage:
  resource [<flag>]

Flags:
  -h, --help       Show context-sensitive help.
  -v, --version    Print the version number.

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
        default {
            Write-Host $defaultHelp
            exit 1
        }
    }
}

# Choose the resources to set-up
$resources       = $resourcesFiles | ForEach-Object { $_.PSParentPath | Split-Path -Leaf }
$resourcesLabel  = gum style --foreground=$PURPLE resources
$chosenResources = gum filter --no-limit --prompt="❯ " --prompt.foreground=$PURPLE --indicator.foreground=$PURPLE --selected-indicator.foreground=$VIOLET --match.foreground=$PURPLE --placeholder="Search..." --text.foreground="240" --cursor-text.foreground=$VIOLET --header="🎨 Select the $resourcesLabel you want to set-up: " --header.foreground="" --height=10 $resources

# Set-up the chosen resources
$chosenResources | ForEach-Object {
    $resourceLabel = gum style --foreground=$VIOLET $_
    gum spin --spinner="monkey" --title="Setting up $resourceLabel..." -- pwsh -ExecutionPolicy Bypass -File $( Join-Path -Path $resourcesPath -ChildPath "$_\main.ps1" )
    Logger -Level debug -Message "Resource set-up" -Structured "resource $_"
}
