#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME   = "ArchWSL Installer"
$SCRIPT_LOG    = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"
$SCRIPT_SOURCE = "yuk7/ArchWSL"

# Script values
$archUser = "raks"
$archPass = "raksonme"

# Logger
function Logger {
    param(
        [Parameter(Mandatory = $false)]
        [ValidateSet("none", "debug", "info", "warn", "error", "fatal")]
        [string]$Level = "none",
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,
        [Parameter(Mandatory = $false)]
        [string]$Structured
    )

    Start-Process -FilePath gum -ArgumentList "log --file $SCRIPT_LOG --time timeonly --level $Level --prefix ""$SCRIPT_NAME"" --structured ""$Message"" $Structured" -NoNewWindow
}

# Helper
function Download-Package {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Source,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FilePattern
    )

    $releasesUri = "https://api.github.com/repos/$Source/releases/latest"
    $downloadUri = ((Invoke-RestMethod -Method GET -Uri $releasesUri).assets | Where-Object { $_.name -like $FilePattern }).browser_download_url
    $fileName    = Split-Path -Path $downloadUri -Leaf
    $tempPath    = Join-Path -Path $env:TEMP -ChildPath $fileName
    Start-BitsTransfer -Source $downloadUri -Destination $tempPath
    Logger -Level debug -Message "Package downloaded" -Structured "path ""$tempPath"""
    return $tempPath
}

function Install-Package {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CertificatePath,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$AppPath
    )

    Import-Certificate -FilePath $CertificatePath -CertStoreLocation "Cert:\LocalMachine\TrustedPeople"
    Add-AppxPackage -Path $AppPath
    Remove-Item $CertificatePath -Force
    Remove-Item $AppPath -Force
    Logger -Level debug -Message "Leftovers removed" -Structured "path ""$CertificatePath"""
    Logger -Level debug -Message "Leftovers removed" -Structured "path ""$AppPath"""
}

#Check if Hyper-V is enabled
if (-not ((Get-ComputerInfo).HyperVisorPresent)) {
    Logger -Level error -Message "Hyper-V BIOS setting not enabled" -Structured "restart required"
    exit 1
}

# Check if WSL is enabled
if (-not (Get-Command "wslconfig")) {
    Start-Process -FilePath wsl -ArgumentList "--install" -NoNewWindow -Wait
    Logger -Level warn -Message "Windows Subsystem for Linux enabled" -Structured "restart required"
    Restart-Computer
    exit 1
}

$certificatePath = Download-Package -Source $SCRIPT_SOURCE -FilePattern "ArchWSL-AppX*.cer"
$appPath         = Download-Package -Source $SCRIPT_SOURCE -FilePattern "ArchWSL-AppX*.appx"

Install-Package -CertificatePath $certificatePath -AppPath $appPath

$packagePath = (Resolve-Path -Path "$env:PROGRAMFILES\WindowsApps\yuk7.archwsl*\Arch.exe").Path

# Initialize Arch
$arch = Start-Process -FilePath $packagePath -WindowStyle Hidden
Start-Sleep -Seconds 60
$arch | Stop-Process

# Configure Arch
Start-Process -FilePath $packagePath -ArgumentList "run echo ""root:$archPass"" | chpasswd; echo ""%wheel ALL=(ALL) ALL"" > /etc/sudoers.d/wheel; useradd -m -G wheel -s /bin/bash $archUser; echo ""$archUser`:$archPass"" | chpasswd $archUser" -NoNewWindow -Wait
Start-Process -FilePath $packagePath -ArgumentList "config --default-user $archUser" -NoNewWindow -Wait
Start-Process -FilePath $packagePath -ArgumentList "run echo ""$archPass"" | sudo -S pacman-key --init; echo ""$archPass"" | sudo -S pacman-key --populate; echo ""$archPass"" | sudo -S pacman -Sy archlinux-keyring --noconfirm; echo ""$archPass"" | sudo -S pacman -Su --noconfirm" -NoNewWindow -Wait

# Dotfiles Environment Variable
$parsedpackagePath = $packagePath.Replace(' ', '` ')
$wslDotfilesPath   = Invoke-Expression "$parsedpackagePath runp echo $env:DOTFILES"
Start-Process -FilePath $packagePath -ArgumentList "run echo ""$archPass"" | sudo -S tee -a /etc/environment <<< ""DOTFILES=$wslDotfilesPath"""           -NoNewWindow -Wait
Start-Process -FilePath $packagePath -ArgumentList "run echo ""$archPass"" | sudo -S tee -a /etc/profile.d/dotfiles.sh <<< ""DOTFILES=$wslDotfilesPath""" -NoNewWindow -Wait

# Register Arch
winget.exe uninstall --exact --silent --purge --force --id Canonical.Ubuntu.2204
Start-Process -FilePath wsl -ArgumentList "--unregister Ubuntu" -NoNewWindow -Wait
Start-Process -FilePath wsl -ArgumentList "--set-default Arch"  -NoNewWindow -Wait
