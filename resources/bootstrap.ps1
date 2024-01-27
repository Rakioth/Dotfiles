#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME    = "Resource Loader"
$SCRIPT_VERSION = "v1.0.0"
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
if ($args.Count -gt 0) {
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
$resourcesLabel    = gum style --foreground=$PURPLE resources
$resources         = $resourcesFiles | ForEach-Object { $_.PSParentPath | Split-Path -Leaf }
$selectedResources = $resources      | ForEach-Object { "--selected=$_" }
$chosenResources   = gum choose --no-limit --cursor.foreground=$PURPLE --item.foreground=$VIOLET --selected.foreground=$VIOLET --header.foreground="" --header="🎯 Choose the $resourcesLabel you want to set-up:" $selectedResources $resources

# Set-up the chosen resources
$chosenResources | ForEach-Object {
    $resourceLabel = gum style --foreground=$VIOLET $_
    gum spin --spinner monkey --title "Setting up $resourceLabel..." -- pwsh -ExecutionPolicy Bypass -File $( Join-Path -Path $resourcesPath -ChildPath "$_\main.ps1" )
}
