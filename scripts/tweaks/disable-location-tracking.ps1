#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

. "$env:DOTFILES\core\main.ps1"

Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location"              -Name "Value"                 -Value "Deny" -Type String
Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" -Name "SensorPermissionState" -Value "0"    -Type DWord
Util-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"                                        -Name "Status"                -Value "0"    -Type DWord
Util-ItemProperty -Path "HKLM:\SYSTEM\Maps"                                                                                          -Name "AutoUpdateEnabled"     -Value "0"    -Type DWord
