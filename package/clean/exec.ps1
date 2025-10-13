#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

$args | Sort-Object -Unique | ForEach-Object {
    $packageLabel = gum style --foreground $SecondaryColor $_
    gum spin --spinner moon --title "Uninstalling $packageLabel..." -- winget uninstall --exact --silent --accept-source-agreements --force --purge --id $_

    switch ($LASTEXITCODE) {
        0           { Write-Host "✅ Package successfully uninstalled: $packageLabel" }
        -1978335212 { Write-Host "🚧 Package not available: $packageLabel"            }
        -1978335189 { Write-Host "🎉 Package already uninstalled: $packageLabel"      }
        default     { Write-Host "🚫 Package could not be uninstalled: $packageLabel" }
    }
}
