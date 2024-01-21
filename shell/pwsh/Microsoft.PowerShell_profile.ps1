. "$env:DOTFILES\shell\pwsh\Scripts\aliases.ps1"
. "$env:DOTFILES\shell\pwsh\Scripts\exports.ps1"

# PSReadLine
Import-Module -Name PSReadLine
Set-PSReadLineOption -BellStyle None -PredictionSource History -PredictionViewStyle ListView

# PSFzf
Import-Module -Name PSFzf
Set-PsFzfOption -PSReadlineChordProvider "Ctrl+r" -PSReadlineChordReverseHistory "Ctrl+h"

# WingetExtensions
Import-Module -Name WingetExtensions

# Prompt
Invoke-Expression (&starship init powershell)

# Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
