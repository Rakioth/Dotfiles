#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

. "$env:DOTFILES\core\main.ps1"

Util-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search"          -Name "BingSearchEnabled"      -Value "0" -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Start"     -Name "HideRecommendedSection" -Value "1" -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\PolicyManager\current\device\Education" -Name "IsEducationEnvironment" -Value "1" -Type DWord
Util-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"              -Name "HideRecommendedSection" -Value "1" -Type DWord

$SID = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\CurrentVersion\Start"             -Name "ShowRecentList"             -Value "0" -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackDocs"            -Value "0" -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_IrisRecommendations"  -Value "0" -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_AccountNotifications" -Value "0" -Type DWord
Util-ItemProperty -Path "HKU:\$SID\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_Layout"               -Value "1" -Type DWord
