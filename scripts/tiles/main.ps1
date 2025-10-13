$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

$REGISTRY_BASE_PATH = "HKCU:\Software\Stardock\Start8\Start8.ini"
$GROUP_NAME         = "𝖈𝖔𝖉𝖊 𝖘𝖑𝖆𝖞𝖊𝖗"
$GROUP_ID           = "2001"

$TILE_PROGRAMS = @(
    @{ Name = "Steam";          Image = "skull.png";  Order = 0; Value = "|-1|3|0|0|-1||" }
    @{ Name = "GitHub Desktop"; Image = "zodd.png";   Order = 1; Value = "|-1|1|4|0|-1||" }
    @{ Name = "Snipping Tool";  Image = "knight.png"; Order = 2; Value = "|-1|1|4|2|-1||" }
    @{ Name = "Notepad";        Image = "guts.png";   Order = 3; Value = "|-1|1|0|4|-1||" }
    @{ Name = "Docker Desktop"; Image = "logo.png";   Order = 4; Value = "|-1|2|2|4|-1||" }
)

$START8_SETTINGS = @{
    "MenuMode"            = "2"
    "lRight"              = "3"
    "FlushMetro3"         = "1"
    "CustomColour"        = "0"
    "MenuAlphaValue"      = "30"
    "OffsetStart"         = "0"
    "TaskbarAlphaValue"   = "0"
    "UseCortanaSearch"    = "0"
    "OldSearch"           = "0"
    "AllowTabSearch"      = "0"
    "HideRecentAllApps"   = "1"
    "HideAppsList"        = "1"
    "NoSyncPins"          = "1"
    "GroupUniqueID"       = $GROUP_ID
    "Win10WidthC"         = "1"
    "Win10Height"         = "400"
    "TaskbarDisallowBlur" = "1"
    "FlushMetro4"         = "1"
}

$LOCATION_SETTINGS = @{
    "2"  = "Control Panel"
    "96" = "Settings"
}

function Test-RegistryPath {
    param([string]$Path)

    if (-not (Test-Path -Path $Path)) {
        Output-Error -Message "Start11 registry path not found" -Label "   $PromptSymbol"
        exit 1
    }
}

function Remove-RegistryKeys {
    param([string]$BasePath)

    $keysToRemove = @(
        "GroupContents",
        "Groups",
        "Start8\CustomTiles",
        "Start8\CustomTilesText",
        "Start8\Locations10"
    )

    $keysToRemove | ForEach-Object {
        $fullPath = Join-Path -Path $BasePath -ChildPath $_
        if (Test-Path $fullPath) {
            Remove-Item -Path $fullPath -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    Output-Success -Message "Existing registry keys cleaned up" -Label "   $PromptSymbol"
}

function Set-Start8Configuration {
    param([string]$BasePath, [hashtable]$Settings, [hashtable]$Locations, [string]$GroupName, [string]$GroupId)

    $groupValue = "GRP$GroupId|$GroupName|0|0|0|0|0|1|0|0|"
    Util-ItemProperty -Path "$BasePath\Groups" -Name "0" -Value $groupValue -Type String

    $Settings.GetEnumerator() | ForEach-Object {
        Util-ItemProperty -Path "$BasePath\Start8" -Name $_.Key -Value $_.Value -Type String
    }

    $Locations.GetEnumerator() | ForEach-Object {
        Util-ItemProperty -Path "$BasePath\Start8\Locations10" -Name $_.Key -Value $_.Value -Type String
    }

    Output-Success -Message "Start11 configuration applied" -Label "   $PromptSymbol"
}

function Set-TileConfiguration {
    param([string]$BasePath, [array]$Programs, [string]$GroupId, [string]$ScriptRoot)

    $startApps       = Get-StartApps
    $configuredCount = 0

    foreach ($program in $Programs) {
        $app = $startApps | Where-Object { $_.Name -eq $program.Name }

        if (-not $app) {
            Output-Error -Message "Application '$( $program.Name )' not found in Start menu" -Label "   $PromptSymbol"
            continue
        }

        $tilePath = Join-Path -Path $ScriptRoot -ChildPath $program.Image
        if (-not (Test-Path -Path $tilePath)) {
            Output-Error -Message "Tile image '$( $program.Image )' not found" -Label "   $PromptSymbol"
            continue
        }

        $appIdKey  = $app.AppID.Replace("\", "_")
        $tileValue = "$( $app.AppID )$( $program.Value )"

        Util-ItemProperty -Path "$BasePath\GroupContents\GRP$GroupId" -Name $program.Order.ToString() -Value $tileValue -Type String
        Util-ItemProperty -Path "$BasePath\Start8\CustomTiles"        -Name $appIdKey                 -Value $tilePath  -Type String
        Util-ItemProperty -Path "$BasePath\Start8\CustomTilesText"    -Name $appIdKey                 -Value "1"        -Type String

        $configuredCount++
    }

    Output-Success -Message "Configured $configuredCount tile(s) successfully" -Label "   $PromptSymbol"
}

function Restart-Explorer {
    try {
        Start-Process -FilePath "explorer" -WindowStyle Hidden
        do {
            Start-Sleep -Milliseconds 100
            $explorer = Get-Process -Name "explorer" -ErrorAction SilentlyContinue
        } until ($explorer)
        Stop-Process $explorer -Force
        Output-Success -Message "Windows Explorer restarted to apply changes" -Label "   $PromptSymbol"
    } catch {
        Output-Error -Message "Failed to restart Explorer: $($_.Exception.Message)" -Label "   $PromptSymbol"
    }
}

$tilesLabel = gum style --foreground $PrimaryColor "Start11 Tiles"
Write-Host "🧱 Configuring $tilesLabel..."
Test-RegistryPath -Path $REGISTRY_BASE_PATH

Remove-RegistryKeys     -BasePath $REGISTRY_BASE_PATH
Set-Start8Configuration -BasePath $REGISTRY_BASE_PATH -Settings $START8_SETTINGS -Locations $LOCATION_SETTINGS -GroupName $GROUP_NAME -GroupId $GROUP_ID
Set-TileConfiguration   -BasePath $REGISTRY_BASE_PATH -Programs $TILE_PROGRAMS -GroupId $GROUP_ID -ScriptRoot $PSScriptRoot

Restart-Explorer
Output-Success -Message "Start11 tiles configuration completed successfully!" -Label "   $PromptSymbol"
