$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

$HELP = @"
Usage:
  clean [<packages>...]

"@

$selected = @()
if ($args.Count -gt 0) {
    if ($args[0] -in @("-h", "--help")) {
        Write-Host $HELP
        exit 0
    }

    $selected = $args
} else {
    $options = Get-WinGetPackage |
        Where-Object { $_.Source -eq "winget" } |
        Select-Object -ExpandProperty Id |
        Sort-Object -Unique

    if (-not $options) {
        Write-Host "🔍 No packages found"
        exit 0
    }

    $packagesLabel = gum style --foreground $PrimaryColor packages
    $selected      = Gum-Filter -Header "🗑️ Select the $packagesLabel to uninstall: " -Options $options
}

if ($selected) {
    sudo.exe pwsh -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\exec.ps1" $selected
}
