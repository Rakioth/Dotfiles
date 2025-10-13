$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

$HELP = @"
Usage:
  dot <context> <script> [<args>...]

"@

if ($args.Count -lt 2) {
    Write-Host $HELP
    exit 1
}

$context       = $args[0]
$script        = $args[1]
$remainingArgs = $args[2..$args.Count]

$scriptPath = "$env:DOTFILES\$context\$script\main.ps1"

if (-not (Test-Path -Path $scriptPath)) {
    Output-Error -Message "Script '$script' not found in context '$context'."
    exit 1
}

& $scriptPath @remainingArgs
