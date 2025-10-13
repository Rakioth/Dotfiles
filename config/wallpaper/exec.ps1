#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

$WALLPAPER_ENGINE_PATH = "C:\Program Files (x86)\Steam\steamapps\common\wallpaper_engine"
$EXECUTABLE_PATH       = Join-Path -Path $WALLPAPER_ENGINE_PATH -ChildPath "wallpaper32.exe"
$CONFIG_PATH           = Join-Path -Path $WALLPAPER_ENGINE_PATH -ChildPath "config.json"

$CUSTOM_PROPERTIES = @{
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/1204132490/scene.pkg" = @{
        Monitor0 = @{ schemecolor = "0.5372549019607843 0.09019607843137255 0.596078431372549" }
    }
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/1419340306/scene.pkg" = @{
        Monitor0 = @{ schemecolor = "0.5372549019607843 0.09019607843137255 0.596078431372549" }
    }
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/1879751838/scene.pkg" = @{
        Monitor0 = @{ schemecolor = "0.5372549019607843 0.09019607843137255 0.596078431372549" }
    }
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/2917259075/scene.pkg" = @{
        Monitor0 = @{
            audioprocessing = $false
            schemecolor     = "0.5372549019607843 0.09019607843137255 0.596078431372549"
            wec_e           = $true
            wec_hue         = 30
        }
    }
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/3141421197/scene.pkg" = @{
        Monitor0 = @{
            schemecolor = "0.5372549019607843 0.09019607843137255 0.596078431372549"
            wec_brs     = 43
            wec_con     = 100
            wec_e       = $true
            wec_hue     = 33
            wec_sa      = 100
        }
    }
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/839094818/scene.pkg" = @{
        Monitor0 = @{
            schemecolor = "0.5372549019607843 0.09019607843137255 0.596078431372549"
            wec_e       = $true
            wec_hue     = 33
        }
    }
    "C:/Program Files (x86)/Steam/steamapps/common/wallpaper_engine/projects/myprojects/sagath/scene.pkg" = @{
        Monitor0 = @{
            volume  = 0
            wec_brs = 39
            wec_e   = $true
            wec_hue = 31
            wec_sa  = 36
        }
    }
}

if (-not (Test-Path -Path $CONFIG_PATH)) {
    exit 1
}

$config = Get-Content -Path $CONFIG_PATH | ConvertFrom-Json
if ($configFile.$env:USERNAME.wproperties) {
    exit 0
}

Stop-Process -Name "wallpaper32" -Force -ErrorAction SilentlyContinue
$config.$env:USERNAME.wproperties = $CUSTOM_PROPERTIES
$config | ConvertTo-Json -Depth 100 | Set-Content -Path $CONFIG_PATH
Start-Process -FilePath $EXECUTABLE_PATH
