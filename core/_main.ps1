Get-ChildItem -Path "$env:DOTFILES\core\*.ps1" -Exclude "_main.ps1" -ErrorAction SilentlyContinue |
ForEach-Object { . $_.FullName }
