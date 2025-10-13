#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

. "$env:DOTFILES\core\main.ps1"

Util-ItemProperty -Path "HKCU:\System\GameConfigStore"                      -Name "GameDVR_FSEBehavior"              -Value "2" -Type DWord
Util-ItemProperty -Path "HKCU:\System\GameConfigStore"                      -Name "GameDVR_Enabled"                  -Value "0" -Type DWord
Util-ItemProperty -Path "HKCU:\System\GameConfigStore"                      -Name "GameDVR_HonorUserFSEBehaviorMode" -Value "1" -Type DWord
Util-ItemProperty -Path "HKCU:\System\GameConfigStore"                      -Name "GameDVR_EFSEFeatureFlags"         -Value "0" -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR"                     -Value "0" -Type DWord
