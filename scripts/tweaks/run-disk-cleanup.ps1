#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

. "$env:DOTFILES\core\main.ps1"

cleanmgr /d C: /VERYLOWDISK
Dism /Online /Cleanup-Image /StartComponentCleanup /ResetBase
