$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

$DOCKER_PATH = "$env:PROGRAMFILES\Docker\Docker\Docker Desktop.exe"
$HELP        = @"
Usage:
  start [<containers>...]

"@

if (-not (Test-Path -Path $DOCKER_PATH)) {
    Output-Error -Message "Docker Desktop is not installed."
    exit 1
}

$docker = Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue
if (-not $docker) {
    Start-Process -FilePath $DOCKER_PATH -ArgumentList "-Autostart"
    do {
        Start-Sleep -Milliseconds 100
        $docker = Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue
    } until ($docker)
    Start-Sleep -Seconds 3
}

$selected = @()
if ($args.Count -gt 0) {
    if ($args[0] -in @("-h", "--help")) {
        Write-Host $HELP
        exit 0
    }

    $selected = $args
} else {
    $options = docker ps -a --filter "status=exited" --filter "status=created" --format "{{.Names}}" | Sort-Object -Unique

    if (-not $options) {
        Write-Host "🔍 No containers found"
        exit 0
    }

    $containersLabel = gum style --foreground $PrimaryColor containers
    $selected        = Gum-Filter -Header "🐳 Select the $containersLabel to start: " -Options $options
}

$selected | Sort-Object -Unique | ForEach-Object {
    $containerLabel = gum style --foreground $SecondaryColor $_
    gum spin --spinner globe --title "Starting $containerLabel..." -- docker start $_

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Container successfully started: $containerLabel"
    } else {
        Write-Host "🚫 Container could not be started: $containerLabel"
    }
}
