$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

$CONFIG = "link.windows.yml"
$HELP   = @"
Usage:
  apply [<links>...]

"@

$selected = @()
if ($args.Count -gt 0) {
    if ($args[0] -in @("-h", "--help")) {
        Write-Host $HELP
        exit 0
    }

    $selected = $args
} else {
    $options = Get-ChildItem -Path "$env:DOTFILES\*\*\$CONFIG" -File -ErrorAction SilentlyContinue |
        ForEach-Object { $_.Directory.Name } |
        Sort-Object -Unique

    $symlinksLabel = gum style --foreground $PrimaryColor symlinks
    $selected      = Gum-Filter -Header "🌐 Select the $symlinksLabel to apply: " -Options $options
}

$paths = @()
$selected | Sort-Object -Unique | ForEach-Object {
    $configPath = Resolve-Path -Path "$env:DOTFILES\*\$_\$CONFIG"

    if (-not $configPath) {
        Output-Error -Message "Link '$_' not found."
        exit 1
    }

    $paths += $configPath.Path
}

if ($paths) {
    $symlinksLabel = gum style --foreground $SecondaryColor symlinks
    gum spin --spinner moon --title "Applying $symlinksLabel..." --show-output --show-error -- `
        sudo.exe python "$env:DOTFILES\modules\dotbot\bin\dotbot" `
        --base-directory $env:DOTFILES `
        --config-file "$env:DOTFILES\symlinks\defaults.yml" `
        $paths `
        --verbose --force-color
}
