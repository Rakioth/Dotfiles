#Requires -PSEdition Core

# Script variables
$SCRIPT_NAME = "Wallpaper Bootstrap"
$SCRIPT_LOG  = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"

# Script values
$configPath       = "C:\Program Files (x86)\Steam\steamapps\common\wallpaper_engine\config.json"
$configProperties = Write-Output '
{
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/1204132490/scene.pkg": {
        "Monitor0": {
            "schemecolor": "0.5372549019607843 0.09019607843137255 0.596078431372549"
        }
    },
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/1419340306/scene.pkg": {
        "Monitor0": {
            "schemecolor": "0.5372549019607843 0.09019607843137255 0.596078431372549"
        }
    },
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/1879751838/scene.pkg": {
        "Monitor0": {
            "schemecolor": "0.5372549019607843 0.09019607843137255 0.596078431372549"
        }
    },
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/2917259075/scene.pkg": {
        "Monitor0": {
            "audioprocessing": false,
            "schemecolor": "0.5372549019607843 0.09019607843137255 0.596078431372549",
            "wec_e": true,
            "wec_hue": 30
        }
    },
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/3141421197/scene.pkg": {
        "Monitor0": {
            "schemecolor": "0.5372549019607843 0.09019607843137255 0.596078431372549",
            "wec_brs": 43,
            "wec_con": 100,
            "wec_e": true,
            "wec_hue": 33,
            "wec_sa": 100
        }
    },
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/839094818/scene.pkg": {
        "Monitor0": {
            "schemecolor": "0.5372549019607843 0.09019607843137255 0.596078431372549",
            "wec_e": true,
            "wec_hue": 33
        }
    },
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/sagath/scene.pkg": {
        "Monitor0": {
            "volume": 0,
            "wec_brs": 39,
            "wec_e": true,
            "wec_hue": 31,
            "wec_sa": 36
        }
    }
}
' | ConvertFrom-Json

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

# Check config path
if (-not (Test-Path -Path $configPath)) {
    Logger -Level error -Message "Config file not found" -Structured "path ""$configPath"""
    exit 1
}

# Stop the process to avoid errors
Stop-Process -Name wallpaper32
Logger -Level debug -Message "Stoping process" -Structured "process wallpaper32"

# Update config file
$configFile = Get-Content -Path $configPath | ConvertFrom-Json
$configFile.raks.wproperties = $configProperties
$configFile | ConvertTo-Json -Depth 100 | Set-Content -Path $configPath
Logger -Level debug -Message "Config file updated" -Structured "path ""$configPath"""

# Start the process again
$executablePath = "C:\Program Files (x86)\Steam\steamapps\common\wallpaper_engine\wallpaper32.exe"
Start-Process -FilePath $executablePath
Logger -Level debug -Message "Starting process" -Structured "process ""$executablePath"""
