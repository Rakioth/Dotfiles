#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

. "$env:DOTFILES\core\main.ps1"

Util-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications"  -Name "ToastEnabled"         -Value "0" -Type DWord
Util-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme"    -Value "0" -Type DWord
Util-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value "0" -Type DWord

$SID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
Util-ItemProperty -Path "HKU:\$SID\Console\%%Startup" -Name "DelegationConsole"  -Value "{2EACA947-7F5F-4CFA-BA87-8F7FBEEFBE69}" -Type String
Util-ItemProperty -Path "HKU:\$SID\Console\%%Startup" -Name "DelegationTerminal" -Value "{E12CFF52-A866-4C77-9A90-F570A7AA2C6B}" -Type String

Get-ChildItem -Path "$env:USERPROFILE\Desktop" -Filter "*.lnk" -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path "$env:PUBLIC\Desktop"      -Filter "*.lnk" -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue

Rename-Computer -NewName "VOID"

$startColor    = 0xFFA43695
$accentColor   = 0xFF981789
$accentPalette = [byte[]](
    0xF1, 0xBA, 0xF4, 0x00,
    0xDF, 0x98, 0xE5, 0x00,
    0xBE, 0x5C, 0xCA, 0x00,
    0xB2, 0x45, 0xC0, 0x00,
    0x95, 0x36, 0xA4, 0x00,
    0x71, 0x23, 0x81, 0x00,
    0x47, 0x0C, 0x58, 0x00,
    0x88, 0x17, 0x98, 0x00
)

Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\SystemProtectedUserData\$SID\AnyoneRead\Colors" -Name "StartColor"               -Value $startColor    -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\SystemProtectedUserData\$SID\AnyoneRead\Colors" -Name "AccentColor"              -Value $accentColor   -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize"                         -Name "ColorPrevalence"          -Value "1"            -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"                            -Name "StartColorMenu"           -Value $startColor    -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"                            -Name "AccentColorMenu"          -Value $accentColor   -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent"                            -Name "AccentPalette"            -Value $accentPalette -Type Binary
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\DWM"                                                       -Name "ColorPrevalence"          -Value "1"            -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\DWM"                                                       -Name "AccentColor"              -Value $accentColor   -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\DWM"                                                       -Name "ColorizationColor"        -Value "c4891798"     -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\DWM"                                                       -Name "ColorizationAfterglow"    -Value "c4891798"     -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\DWM"                                                       -Name "EnableWindowColorization" -Value "1"            -Type DWord

$release     = Invoke-RestMethod -Method GET -Uri "https://api.github.com/repos/krlvm/AccentColorizer-E11/releases/latest"
$downloadUrl = $release.assets | Where-Object { $_.name -like "*.exe" } | Select-Object -ExpandProperty "browser_download_url" -First 1
$fileName    = Split-Path -Path $downloadUrl -Leaf
$tempPath    = Join-Path -Path $env:TEMP -ChildPath $fileName
Start-BitsTransfer -Source $downloadUrl -Destination $tempPath
Start-Process -FilePath $tempPath -ArgumentList "-Apply"
