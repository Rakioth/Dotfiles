#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME = "Tiles Setup"
$SCRIPT_LOG  = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"

# Script values
$registryPath  = "HKCU:\Software\Stardock\Start8\Start8.ini"
$tilesPath     = Join-Path -Path $env:DOTFILES -ChildPath "resources\tiles"
$installedApps = Get-StartApps
$programs      = @(
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "Steam" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Steam.png"
        GroupContents = "GRP2001"
        Order         = "0"
        Value         = "|-1|1|0|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "EA" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "EA.png"
        GroupContents = "GRP2001"
        Order         = "1"
        Value         = "|-1|1|2|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "Ubisoft Connect" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Ubisoft Connect.png"
        GroupContents = "GRP2001"
        Order         = "2"
        Value         = "|-1|1|4|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "Battle.net" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Battle.net.png"
        GroupContents = "GRP2001"
        Order         = "3"
        Value         = "|-1|1|0|2|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "Xbox" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Xbox.png"
        GroupContents = "GRP2001"
        Order         = "4"
        Value         = "|-1|1|2|2|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "Media Player" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Media Player.png"
        GroupContents = "GRP2001"
        Order         = "5"
        Value         = "|-1|1|4|2|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "010 Editor" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "010 Editor.png"
        GroupContents = "GRP2002"
        Order         = "0"
        Value         = "|-1|1|0|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "Visual Studio Code" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Visual Studio Code.png"
        GroupContents = "GRP2002"
        Order         = "1"
        Value         = "|-1|1|2|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "Visual Studio 2022" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Visual Studio 2022.png"
        GroupContents = "GRP2002"
        Order         = "2"
        Value         = "|-1|1|4|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "GitHub Desktop" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "GitHub Desktop.png"
        GroupContents = "GRP2002"
        Order         = "3"
        Value         = "|-1|1|0|2|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "Adobe Photoshop 2024" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Adobe Photoshop.png"
        GroupContents = "GRP2002"
        Order         = "4"
        Value         = "|-1|1|2|2|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "Microsoft Clipchamp" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Clipchamp.png"
        GroupContents = "GRP2002"
        Order         = "5"
        Value         = "|-1|1|4|2|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "Discord" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Discord.png"
        GroupContents = "GRP2003"
        Order         = "0"
        Value         = "|-1|1|0|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "KeePassXC" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "KeePassXC.png"
        GroupContents = "GRP2003"
        Order         = "1"
        Value         = "|-1|1|2|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "Docker Desktop" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Docker.png"
        GroupContents = "GRP2003"
        Order         = "2"
        Value         = "|-1|1|4|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "Word" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Word.png"
        GroupContents = "GRP2004"
        Order         = "0"
        Value         = "|-1|1|0|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "PowerPoint" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "PowerPoint.png"
        GroupContents = "GRP2004"
        Order         = "1"
        Value         = "|-1|1|2|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = ($installedApps | Where-Object { $_.Name -eq "Excel" }).AppID
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Excel.png"
        GroupContents = "GRP2004"
        Order         = "2"
        Value         = "|-1|1|4|0|-1||"
    }
)

# Logger
function Logger {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("none", "debug", "info", "warn", "error", "fatal")]
        [string]$Level = "none",
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,
        [Parameter(Mandatory = $false)]
        [string]$Structured
    )

    Start-Process -FilePath gum -ArgumentList "log --file $SCRIPT_LOG --time timeonly --level $Level --prefix ""$SCRIPT_NAME"" --structured ""$Message"" $Structured" -NoNewWindow
}

# Check registry path
if (-not (Test-Path -Path $registryPath)) {
    Logger -Level error -Message "Registry path not found" -Structured "path ""$registryPath"""
    exit 1
}

# Remove registry keys
Remove-Item -Path "$registryPath\GroupContents"          -Recurse -Force
Remove-Item -Path "$registryPath\Groups"                 -Recurse -Force
Remove-Item -Path "$registryPath\Start8\CustomTiles"     -Recurse -Force
Remove-Item -Path "$registryPath\Start8\CustomTilesText" -Recurse -Force
Remove-Item -Path "$registryPath\Start8\Locations10"     -Recurse -Force
Logger -Level debug -Message "Registry keys removed" -Structured "path ""$registryPath"""

# Create registry keys
New-Item -Path "$registryPath\GroupContents"              -Force
New-Item -Path "$registryPath\GroupContents\`$PINNEDDEF$" -Force
New-Item -Path "$registryPath\GroupContents\GRP2001"      -Force
New-Item -Path "$registryPath\GroupContents\GRP2002"      -Force
New-Item -Path "$registryPath\GroupContents\GRP2003"      -Force
New-Item -Path "$registryPath\GroupContents\GRP2004"      -Force
New-Item -Path "$registryPath\Groups"                     -Force
New-Item -Path "$registryPath\Start8\CustomTiles"         -Force
New-Item -Path "$registryPath\Start8\CustomTilesText"     -Force
New-Item -Path "$registryPath\Start8\Locations10"         -Force
Logger -Level debug -Message "Registry keys created" -Structured "path ""$registryPath"""

# Set registry values
Set-ItemProperty -Path "$registryPath\Groups" -Name "0" -Value "GRP2001|Launchers|0|0|0|0|0|1|0|0|" -Type String
Set-ItemProperty -Path "$registryPath\Groups" -Name "1" -Value "GRP2002|Editors|0|0|0|0|0|2|0|0|"   -Type String
Set-ItemProperty -Path "$registryPath\Groups" -Name "2" -Value "GRP2003|Tools|0|0|0|0|0|1|0|0|"     -Type String
Set-ItemProperty -Path "$registryPath\Groups" -Name "3" -Value "GRP2004|Office|0|0|0|0|0|2|0|0|"    -Type String

Set-ItemProperty -Path "$registryPath\Start8" -Name "MenuMode"            -Value "2"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "lRight"              -Value "3"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "FlushMetro3"         -Value "1"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "CustomColour"        -Value "0"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "MenuAlphaValue"      -Value "30"   -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "OffsetStart"         -Value "0"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "TaskbarAlphaValue"   -Value "0"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "UseCortanaSearch"    -Value "0"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "OldSearch"           -Value "0"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "AllowTabSearch"      -Value "0"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "HideRecentAllApps"   -Value "1"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "HideAppsList"        -Value "1"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "NoSyncPins"          -Value "1"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "GroupUniqueID"       -Value "2004" -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "Win10WidthC"         -Value "2"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "Win10Height"         -Value "428"  -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "TaskbarDisallowBlur" -Value "1"    -Type String
Set-ItemProperty -Path "$registryPath\Start8" -Name "FlushMetro4"         -Value "1"    -Type String
# Start11 v2
# Set-ItemProperty -Path "$registryPath\Start8" -Name "Win10Height"         -Value "438"  -Type String
# Set-ItemProperty -Path "$registryPath\Start8" -Name "UseFormicaEffect"    -Value "1"    -Type String

Set-ItemProperty -Path "$registryPath\Start8\Locations10" -Name "2"  -Value "Control Panel" -Type String
Set-ItemProperty -Path "$registryPath\Start8\Locations10" -Name "96" -Value "Settings"      -Type String

$programs | ForEach-Object {
    if (-not $_.ProgramPath) {
        Logger -Level warn -Message "Program not found" -Structured "path ""$( $_.ProgramPath )"""
        return
    }

    Set-ItemProperty -Path "$registryPath\GroupContents\$( $_.GroupContents )" -Name $_.Order                               -Value "$( $_.ProgramPath )$( $_.Value )" -Type String
    Set-ItemProperty -Path "$registryPath\Start8\CustomTiles"                  -Name "$($_.ProgramPath.Replace("\", "_") )" -Value "$( $_.TilePath )"                 -Type String
    Set-ItemProperty -Path "$registryPath\Start8\CustomTilesText"              -Name "$($_.ProgramPath.Replace("\", "_") )" -Value "1"                                -Type String
}
Logger -Level debug -Message "Registry values set" -Structured "path ""$registryPath"""

# Restart explorer
Stop-Process -Name explorer -Force
Logger -Level debug -Message "Stoping process" -Structured "process explorer"
Start-Process -FilePath explorer
Logger -Level debug -Message "Starting process" -Structured "process explorer"
