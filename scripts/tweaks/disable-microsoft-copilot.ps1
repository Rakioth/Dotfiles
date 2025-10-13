#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

. "$env:DOTFILES\core\main.ps1"

Util-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"          -Name "TurnOffWindowsCopilot" -Value "1" -Type DWord
Util-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"          -Name "TurnOffWindowsCopilot" -Value "1" -Type DWord
Util-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowCopilotButton"     -Value "0" -Type DWord

Dism /Online /Remove-Package /PackageName:Microsoft.Windows.Copilot
