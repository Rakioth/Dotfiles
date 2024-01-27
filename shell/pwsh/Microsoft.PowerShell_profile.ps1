# PSReadLine
Import-Module -Name PSReadLine
Set-PSReadLineOption -BellStyle None -PredictionSource History -PredictionViewStyle ListView

# PSFzf
Import-Module -Name PSFzf
Set-PsFzfOption -PSReadlineChordProvider "Ctrl+r" -PSReadlineChordReverseHistory "Ctrl+h"

# Aliases
. "$env:DOTFILES\shell\pwsh\Scripts\aliases.ps1"

# Exports
. "$env:DOTFILES\shell\pwsh\Scripts\exports.ps1"

# Winget Extensions
. "$env:DOTFILES\package\main.ps1"

# Prompt
Invoke-Expression (&starship init powershell)

# Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
