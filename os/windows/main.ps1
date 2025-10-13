$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

$HELP = @"
Usage:
  windows [<packages>...]

"@

$selected = @()
if ($args.Count -gt 0) {
    if ($args[0] -in @("-h", "--help")) {
        Write-Host $HELP
        exit 0
    }

    $selected = $args
} else {
    $options       = Get-Content -Path "$PSScriptRoot\packages" | Sort-Object -Unique
    $packagesLabel = gum style --foreground $PrimaryColor packages
    $selected      = Gum-Filter -Header "🎯 Select the $packagesLabel to install: " -Options $options
}

if ($selected) {
    sudo.exe pwsh -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\exec.ps1" $selected
}
