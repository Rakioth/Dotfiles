#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

$Config = @{
    ExitCodes = @{
        Success               = 0
        GeneralError          = 1
        InstallerNotAvailable = -1978335212
        AlreadyInstalled      = -1978335189
    }

    WSL = @{
        Distribution    = "archlinux"
        DefaultPassword = "raksonme"
    }
}

function Test-WSL {
    wsl --status *>$null
    if ($LASTEXITCODE -eq 50) { return $false }

    $output = wsl --list
    $output.Replace("`0", "") -match $Config.WSL.Distribution
}

function Install-WSL {
    wsl --update *>$null
    wsl --install $Config.WSL.Distribution --no-launch *>$null
    wsl --set-default $Config.WSL.Distribution
}

function Set-EnvironmentConfiguration {
    $dotfilesPathParts = $env:DOTFILES.Split(":")
    $wslDotfilesPath   = "/mnt/$( $dotfilesPathParts[0].ToLower() )$( $dotfilesPathParts[1].Replace("\", "/") )"
    wsl --exec bash -c "echo 'DOTFILES=$wslDotfilesPath' | tee -a /etc/environment"
    wsl --exec bash -c "echo 'export DOTFILES=$wslDotfilesPath' | tee -a /etc/profile.d/dotfiles.sh"
}

function Set-SystemConfiguration {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Username,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Password
    )

    $systemLanguage = (Get-SystemPreferredUILanguage).Replace("-", "_")
    wsl --exec bash -c "echo '$systemLanguage.UTF-8 UTF-8' | tee -a /etc/locale.gen"
    wsl --exec bash -c "locale-gen"

    wsl --exec bash -c "echo 'root:$Password' | chpasswd"
    wsl --exec bash -c "echo '%wheel ALL=(ALL) ALL' | tee -a /etc/sudoers"
    wsl --exec bash -c "useradd -m -G wheel -s /bin/bash $Username"
    wsl --exec bash -c "echo '$( $Username ):$Password' | chpasswd"
    wsl --exec bash -c "pacman -Syyu sudo --noconfirm" *>$null
    wsl --manage archlinux --set-default-user $Username
}

try {
    if (Test-WSL) {
        exit $Config.ExitCodes.AlreadyInstalled
    }

    if (-not (Test-Path -Path $env:DOTFILES)) {
        exit $Config.ExitCodes.InstallerNotAvailable
    }

    Install-WSL
    Set-EnvironmentConfiguration
    Set-SystemConfiguration -Username $env:USERNAME -Password $Config.WSL.DefaultPassword
    exit $Config.ExitCodes.Success
} catch {
    exit $Config.ExitCodes.GeneralError
}
