function Dot-ListContexts {
    Get-ChildItem -Path "$env:DOTFILES\*\*\main.ps1" -File -ErrorAction SilentlyContinue |
    ForEach-Object { $_.Directory.Parent.Name } |
    Sort-Object -Unique
}

function Dot-ListContextScripts {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Context
    )

    Get-ChildItem -Path "$env:DOTFILES\$Context\*\main.ps1" -File -ErrorAction SilentlyContinue |
    ForEach-Object { $_.Directory.Name } |
    Sort-Object -Unique
}

function Dot-ListScriptsPath {
    Get-ChildItem -Path "$env:DOTFILES\*\*\main.ps1" -File -ErrorAction SilentlyContinue |
    ForEach-Object { $_.FullName } |
    Sort-Object -Unique
}
