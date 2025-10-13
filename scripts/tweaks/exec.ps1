#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

$args | Sort-Object -Unique | ForEach-Object {
    $tweakInstaller = "pwsh -NoProfile -ExecutionPolicy Bypass -File '$PSScriptRoot\$_.ps1'"
    $tweakLabel     = gum style --foreground $SecondaryColor $_
    $tweakOutput    = Invoke-Expression -Command "gum spin --spinner monkey --title ""Applying $tweakLabel..."" -- $tweakInstaller"

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Tweak successfully applied: $tweakLabel"
    } else {
        Write-Host "🚫 Tweak could not be applied: $tweakLabel"
    }
}

Start-Process -FilePath "explorer" -WindowStyle Hidden
do {
    Start-Sleep -Milliseconds 100
    $explorer = Get-Process -Name "explorer" -ErrorAction SilentlyContinue
} until ($explorer)
Stop-Process $explorer -Force
