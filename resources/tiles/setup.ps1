#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME = "Tiles Setup"
$SCRIPT_LOG  = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"

# Script values
$registryPath = "HKCU:\Software\Stardock\Start8\Start8.ini"
$tilesPath    = Join-Path -Path $env:DOTFILES -ChildPath "resources\tiles"
$programs     = @(
    [PSCustomObject]@{
        ProgramPath   = "{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Steam\Steam.exe"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Steam.png"
        GroupContents = "GRP2001"
        Order         = "0"
        Value         = "|-1|1|0|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "{6D809377-6AF0-444B-8957-A3773F02200E}\Electronic Arts\EA Desktop\EA Desktop\EALauncher.exe"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "EA.png"
        GroupContents = "GRP2001"
        Order         = "1"
        Value         = "|-1|1|2|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Ubisoft\Ubisoft Game Launcher\UbisoftConnect.exe"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Ubisoft Connect.png"
        GroupContents = "GRP2001"
        Order         = "2"
        Value         = "|-1|1|4|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "{7C5A40EF-A0FB-4BFC-874A-C0F2E0B9FA8E}\Battle.net\Battle.net Launcher.exe"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Battle.net.png"
        GroupContents = "GRP2001"
        Order         = "3"
        Value         = "|-1|1|0|2|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "Microsoft.GamingApp_8wekyb3d8bbwe!Microsoft.Xbox.App"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Xbox.png"
        GroupContents = "GRP2001"
        Order         = "4"
        Value         = "|-1|1|2|2|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "Microsoft.ZuneMusic_8wekyb3d8bbwe!Microsoft.ZuneMusic"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Media Player.png"
        GroupContents = "GRP2001"
        Order         = "5"
        Value         = "|-1|1|4|2|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "{6D809377-6AF0-444B-8957-A3773F02200E}\010 Editor\010Editor.exe"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "010 Editor.png"
        GroupContents = "GRP2002"
        Order         = "0"
        Value         = "|-1|1|0|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "Microsoft.VisualStudioCode"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Visual Studio Code.png"
        GroupContents = "GRP2002"
        Order         = "1"
        Value         = "|-1|1|2|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "VisualStudio.e5d89039"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Visual Studio 2022.png"
        GroupContents = "GRP2002"
        Order         = "2"
        Value         = "|-1|1|4|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "com.squirrel.GitHubDesktop.GitHubDesktop"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "GitHub Desktop.png"
        GroupContents = "GRP2002"
        Order         = "3"
        Value         = "|-1|1|0|2|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "{6D809377-6AF0-444B-8957-A3773F02200E}\Adobe\Adobe Photoshop 2024\Photoshop.exe"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Adobe Photoshop.png"
        GroupContents = "GRP2002"
        Order         = "4"
        Value         = "|-1|1|2|2|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "Clipchamp.Clipchamp_yxz26nhyzhsrt!App"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Clipchamp.png"
        GroupContents = "GRP2002"
        Order         = "5"
        Value         = "|-1|1|4|2|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "com.squirrel.Discord.Discord"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Discord.png"
        GroupContents = "GRP2003"
        Order         = "0"
        Value         = "|-1|1|0|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "{6D809377-6AF0-444B-8957-A3773F02200E}\KeePassXC\KeePassXC.exe"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "KeePassXC.png"
        GroupContents = "GRP2003"
        Order         = "1"
        Value         = "|-1|1|2|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "{6D809377-6AF0-444B-8957-A3773F02200E}\Oracle\VirtualBox\VirtualBox.exe"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Oracle VM VirtualBox.png"
        GroupContents = "GRP2003"
        Order         = "2"
        Value         = "|-1|1|4|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "Microsoft.Office.WINWORD.EXE.15"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "Word.png"
        GroupContents = "GRP2004"
        Order         = "0"
        Value         = "|-1|1|0|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "Microsoft.Office.POWERPNT.EXE.15"
        TilePath      = Join-Path -Path $tilesPath -ChildPath "PowerPoint.png"
        GroupContents = "GRP2004"
        Order         = "1"
        Value         = "|-1|1|2|0|-1||"
    }
    [PSCustomObject]@{
        ProgramPath   = "Microsoft.Office.EXCEL.EXE.15"
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
