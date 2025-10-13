#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

$args | Sort-Object -Unique | ForEach-Object {
    winget search --exact --accept-source-agreements --id $_ | Out-Null

    $packageInstaller = if ($LASTEXITCODE -eq 0) {
        "winget install --exact --silent --accept-source-agreements --accept-package-agreements --id $_"
    } else {
        "pwsh -NoProfile -ExecutionPolicy Bypass -File '$PSScriptRoot\$( $_.Replace(".", "\") )\installer.ps1'"
    }

    $packageLabel  = gum style --foreground $SecondaryColor $_
    $packageOutput = Invoke-Expression -Command "gum spin --spinner globe --title ""Installing $packageLabel..."" -- $packageInstaller"

    switch ($LASTEXITCODE) {
        0           { Write-Host "✅ Package successfully installed: $packageLabel" }
        -1978335212 { Write-Host "🚧 Package not available: $packageLabel"          }
        -1978335189 { Write-Host "🎉 Package already installed: $packageLabel"      }
        default     { Write-Host "🚫 Package could not be installed: $packageLabel" }
    }
}
