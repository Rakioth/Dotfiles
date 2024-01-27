#Requires -PSEdition Core

function dot {
    switch ($args[0]) {
        "import" {
            pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "os\bootstrap.ps1") $args[1..$args.Count]
        }
        "symlink" {
            pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "symlinks\bootstrap.ps1") $args[1..$args.Count]
        }
        "resource" {
            pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "resources\bootstrap.ps1") $args[1..$args.Count]
        }
        default {
            Write-Host @"
Usage:
  dot [<command>]

Commands:
  import      Install packages.
  symlink     Apply symlinks.
  resource    Set-up resources.

"@
        }
    }
}

Register-ArgumentCompleter -CommandName dot -ScriptBlock {
    param($wordToComplete)

    @("import", "symlink", "resource") | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object { "$_" }
}
