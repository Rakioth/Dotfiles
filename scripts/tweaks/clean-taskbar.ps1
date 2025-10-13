#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

. "$env:DOTFILES\core\main.ps1"

$SID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\CurrentVersion\Search"                                     -Name "SearchboxTaskbarMode" -Value "0" -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"                          -Name "ShowTaskViewButton"   -Value "0" -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"                          -Name "TaskbarDa"            -Value "0" -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" -Name "TaskbarEndTask"       -Value "1" -Type DWord

winget uninstall --exact --silent --accept-source-agreements --force --purge --name "Windows Web Experience Pack"

Remove-Item -Path "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\ImplicitAppShortcuts\*" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*"              -Recurse -Force -ErrorAction SilentlyContinue

Util-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites"        -Value $null -Type Binary
Util-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "FavoritesResolve" -Value $null -Type Binary

$value = Get-ItemPropertyValue -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" -Name "Settings"
$value[8] = 3
Util-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" -Name "Settings" -Value $value -Type Binary
