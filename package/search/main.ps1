$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

$HELP = @"
Usage:
  search <package>

"@

if (-not $args -or $args[0] -in @("-h", "--help")) {
    Write-Host $HELP
    exit 1
}

$options = Find-WinGetPackage -Query $args -Source "winget" |
    Select-Object -ExpandProperty Id |
    Sort-Object -Unique

if (-not $options) {
    Write-Host "🔍 No packages found"
    exit 0
}

$packagesLabel = gum style --foreground $PrimaryColor package
$selected      = Gum-Filter -Header "📦 Select the $packagesLabel to install: " -Options $options -Limit 1 -SelectIfOne

if (-not $selected) {
    exit 0
}

$packageLabel = gum style --foreground $SecondaryColor $selected
gum spin --spinner moon --title "Installing $packageLabel..." -- sudo.exe winget install --exact --silent --accept-source-agreements --accept-package-agreements --id $selected

switch ($LASTEXITCODE) {
    0           { Write-Host "✅ Package successfully installed: $packageLabel" }
    -1978335212 { Write-Host "🚧 Package not available: $packageLabel"          }
    -1978335189 { Write-Host "🎉 Package already installed: $packageLabel"      }
    default     { Write-Host "🚫 Package could not be installed: $packageLabel" }
}
