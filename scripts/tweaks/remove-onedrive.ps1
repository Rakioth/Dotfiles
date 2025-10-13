#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

. "$env:DOTFILES\core\main.ps1"

$oneDrivePath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe"
if (-not (Test-Path -Path $oneDrivePath)) {
    exit 0
}

$SID                        = [System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value
$oneDriveUninstallString    = Get-ItemPropertyValue -Path $oneDrivePath -Name "UninstallString"
$oneDriveExe, $oneDriveArgs = $oneDriveUninstallString.Split(" ")
Start-Process -FilePath $oneDriveExe -ArgumentList "$oneDriveArgs /silent /cusid:$SID" -NoNewWindow -Wait

if (Test-Path -Path $oneDrivePath) {
    exit 1
}

Remove-Item -Path "$env:LOCALAPPDATA\Microsoft\OneDrive" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:LOCALAPPDATA\OneDrive"           -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:ProgramData\Microsoft OneDrive"  -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "$env:SystemDrive\OneDriveTemp"        -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "HKCU:\Software\Microsoft\OneDrive"    -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path $env:OneDrive                          -Recurse -Force -ErrorAction SilentlyContinue

Util-ItemProperty -Path "HKCU:\Environment" -Name "OneDrive" -Value $null -Type ExpandString
