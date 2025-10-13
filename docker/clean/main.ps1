$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

$DOCKER_PATH = "$env:PROGRAMFILES\Docker\Docker\Docker Desktop.exe"
$HELP        = @"
Usage:
  clean [<containers>...]

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
    $options = docker ps -a --format "{{.Names}}" | Sort-Object -Unique

    if (-not $options) {
        Write-Host "🔍 No containers found"
        exit 0
    }

    $containersLabel = gum style --foreground $PrimaryColor containers
    $selected        = Gum-Filter -Header "🐳 Select the $containersLabel to remove: " -Options $options
}

$selected | Sort-Object -Unique | ForEach-Object {
    $containerLabel = gum style --foreground $SecondaryColor $_
    $status         = docker ps --filter "name=^${_}$" --format "{{.Names}}"

    if ($status) {
        gum spin --spinner globe --title "Stopping $containerLabel..." -- docker stop $_
        if ($LASTEXITCODE -ne 0) {
            Write-Host "🚫 Container could not be stopped: $containerLabel"
            continue
        }
    }

    gum spin --spinner globe --title "Removing $containerLabel..." -- docker rm $_

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Container successfully removed: $containerLabel"
    } else {
        Write-Host "🚫 Container could not be removed: $containerLabel"
    }
}
