#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

. "$env:DOTFILES\core\main.ps1"

Get-ChildItem -Path $env:TEMP         -Filter *.* -Recurse | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
Get-ChildItem -Path "C:\Windows\Temp" -Filter *.* -Recurse | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
