#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

. "$env:DOTFILES\core\main.ps1"

Util-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Device Metadata"  -Name "PreventDeviceMetadataFromNetwork"  -Value "1"   -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching"  -Name "DontPromptForWindowsUpdate"        -Value "1"   -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching"  -Name "DontSearchWindowsUpdate"           -Value "1"   -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DriverSearching"  -Name "DriverUpdateWizardWuSearchEnabled" -Value "1"   -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"    -Name "ExcludeWUDriversInQualityUpdate"   -Value "1"   -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoRebootWithLoggedOnUsers"     -Value "1"   -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUPowerManagement"                 -Value "0"   -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"         -Name "BranchReadinessLevel"              -Value "20"  -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"         -Name "DeferFeatureUpdatesPeriodInDays"   -Value "365" -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"         -Name "DeferQualityUpdatesPeriodInDays"   -Value "4"   -Type DWord
