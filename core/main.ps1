Get-ChildItem -Path "$PSScriptRoot\*.ps1" -Exclude "main.ps1" -File -ErrorAction SilentlyContinue |
    ForEach-Object { . $_.FullName }
