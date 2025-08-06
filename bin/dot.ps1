. "$env:DOTFILES\core\_main.ps1"

if ($args.Count -eq 0) {
    $opa = Gum-Filter -Options (Dot-ListContexts)
    Write-Host -NoNewline $opa
} elseif ($args.Count -eq 1) {
    if ($args[0] -in @("-h", "--help")) {
        Write-Host @"
Usage:
  dot
  dot <context>
  dot <context> <script> [<args>...]

"@
        exit 0
    }

    $context = $args[0]
    $scripts = Dot-ListContextScripts -Context $context
    if (-not $scripts) {
        Output-Error -Message "No scripts found for context '$context'."
        exit 1
    }

    Gum-Filter -Options $scripts
} else {
    $context = $args[0]
    $script = $args[1]
    $remainingArgs = $args[2..($args.Count - 1)]

    $scriptPath = "$env:DOTFILES\$context\$script\main.ps1"
    if (-not (Test-Path -Path $scriptPath)) {
        Output-Error -Message "Script '$script' not found in context '$context'."
        exit 1
    }

    pwsh -ExecutionPolicy Bypass -File $scriptPath $remainingArgs
}


Register-ArgumentCompleter -CommandName dot -ScriptBlock {
    param($wordToComplete)

    @("import", "symlink", "resource", "script") | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object { "$_" }
}
