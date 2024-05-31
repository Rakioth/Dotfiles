#Requires -PSEdition Core

# Script variables
$SCRIPT_NAME    = "Script Manager"
$SCRIPT_VERSION = "v1.0.0"
$SCRIPT_LOG     = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"

# Script colors
$PURPLE = "#ce3ed6"
$VIOLET = "#c698f2"

# Script values
$scriptsPath  = Join-Path -Path $env:DOTFILES -ChildPath "scripts"
$scriptsFiles = Get-ChildItem -Path $scriptsPath -Filter "*.ps1" | Where-Object { $_.Name -ne "bootstrap.ps1" }
$defaultHelp  = @"
Usage:
  script [<flag>]

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

# Choose the scripts to run
$scripts       = $scriptsFiles | ForEach-Object { $_.BaseName }
$scriptsLabel  = gum style --foreground=$PURPLE scripts
$chosenScripts = gum filter --no-limit --prompt="❯ " --prompt.foreground=$PURPLE --indicator.foreground=$PURPLE --selected-indicator.foreground=$VIOLET --match.foreground=$PURPLE --placeholder="Search..." --text.foreground="240" --cursor-text.foreground=$VIOLET --header="📝 Select the $scriptsLabel you want to run: " --header.foreground="" --height=10 $scripts

# Run the chosen scripts
$chosenScripts | ForEach-Object {
    $scriptLabel = gum style --foreground=$VIOLET $_
    gum spin --spinner="monkey" --title="Running $scriptLabel..." -- pwsh -ExecutionPolicy Bypass -File $( Join-Path -Path $scriptsPath -ChildPath "$_.ps1" )
    Logger -Level debug -Message "Script run" -Structured "script $_"
}
