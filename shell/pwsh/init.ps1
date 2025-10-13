. "$env:DOTFILES\core\main.ps1"
. "$env:DOTFILES\shell\pwsh\aliases.ps1"
. "$env:DOTFILES\shell\pwsh\exports.ps1"

Get-Content -Path "$env:DOTFILES\shell\pwsh\.psrc" | ForEach-Object {
    if (-not (Get-Module -Name $_ -ListAvailable)) {
        Install-Module -Name $_ -Repository PSGallery -Scope CurrentUser -Force
        Output-Success -Message "Module '$_' installed"
    }
    Import-Module -Name $_
}

Get-ChildItem -Path "$env:DOTFILES\bin\*.ps1" -File -ErrorAction SilentlyContinue |
    ForEach-Object { Set-Alias -Name $_.BaseName -Value $_.FullName }

Get-ChildItem -Path "$env:DOTFILES\shell\pwsh\completions\*.ps1" -File -ErrorAction SilentlyContinue |
    ForEach-Object { . $_.FullName }

Set-PSReadLineOption -EditMode Emacs -BellStyle None -PredictionViewStyle ListView
Set-PSReadLineKeyHandler -Key Tab -ScriptBlock { Invoke-FzfTabCompletion }
Set-PsFzfOption -PSReadlineChordProvider "Ctrl+r" -PSReadlineChordReverseHistory "Ctrl+h" -TabContinuousTrigger Tab -TabExpansion

Invoke-Expression -Command (&starship init powershell)
Invoke-Expression -Command (& { (zoxide init powershell | Out-String) })
