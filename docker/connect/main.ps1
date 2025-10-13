$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

$DOCKER_PATH = "$env:PROGRAMFILES\Docker\Docker\Docker Desktop.exe"
$HELP        = @"
Usage:
  connect [<container>]

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

$selected = ""
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

    $containersLabel = gum style --foreground $PrimaryColor container
    $selected        = Gum-Filter -Header "🐳 Select the $containersLabel to connect: " -Options $options -Limit 1
}

if (-not $selected) {
    exit 0
}

$status = docker ps --filter "name=^${selected}$" --format "{{.Names}}"
if (-not $status) {
    $containerLabel = gum style --foreground $SecondaryColor $selected
    gum spin --spinner globe --title "Starting $containerLabel..." -- docker start $selected
    if ($LASTEXITCODE -ne 0) {
        Output-Error -Message "Container '$selected' could not be started."
        exit 1
    }
}

docker exec -it $selected bash || docker exec -it $selected sh
