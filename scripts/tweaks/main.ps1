$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

$HELP = @"
Usage:
  tweaks [<presets>...]

"@

$selected = @()
if ($args.Count -gt 0) {
    if ($args[0] -in @("-h", "--help")) {
        Write-Host $HELP
        exit 0
    }

    $selected = $args
} else {
    $options = Get-ChildItem -Path "$PSScriptRoot\*.ps1" -Exclude "main.ps1", "exec.ps1" -File -ErrorAction SilentlyContinue |
        ForEach-Object { $_.BaseName } |
        Sort-Object -Unique

    $tweaksLabel = gum style --foreground $PrimaryColor tweaks
    $selected    = Gum-Filter -Header "✨ Select the $tweaksLabel to apply: " -Options $options
}

if ($selected) {
    sudo.exe pwsh -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\exec.ps1" $selected
}
