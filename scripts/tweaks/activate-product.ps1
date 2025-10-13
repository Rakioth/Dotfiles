#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

. "$env:DOTFILES\core\main.ps1"

$licenseStatus = Get-CimInstance SoftwareLicensingProduct -Filter "Name LIKE 'Windows%'" |
    Where-Object { $_.PartialProductKey } |
    Select-Object -ExpandProperty LicenseStatus

if ($licenseStatus -eq 1) {
    exit 0
}

$activationUrl    = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String("aAB0AHQAcABzADoALwAvAGcAZQB0AC4AYQBjAHQAaQB2AGEAdABlAGQALgB3AGkAbgA="))
$activationScript = Invoke-RestMethod -Uri $activationUrl
$scriptBlock      = [ScriptBlock]::Create($activationScript)
& $scriptBlock /HWID
