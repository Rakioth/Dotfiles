# Script colors/styles
$red    = "$( [char]27 )[0;31m"
$green  = "$( [char]27 )[0;32m"
$purple = "$( [char]27 )[38;2;206;62;214m"
$violet = "$( [char]27 )[38;2;198;152;242m"
$normal = "$( [char]27 )[0m"

$italic  = "$( [char]27 )[3m"
$regular = "$( [char]27 )[0m"

$hex_purple = "#ce3ed6"
$hex_violet = "#c698f2"
$hex_green  = "#6dca7b"
$hex_blue   = "#11a8cd"

# Script values
$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

$dotfilesRepository = "https://github.com/Rakioth/Dotfiles.git"
$dotfilesEnv        = "DOTFILES"
$dotfilesFolder     = ".dotfiles"
$dotfilesPath       = Join-Path -Path $env:USERPROFILE -ChildPath $dotfilesFolder

# Script functions
function Get-Emoji {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Unicode
    )

    return [System.Char]::ConvertFromUtf32([System.Convert]::toInt32($Unicode, 16))
}

function Write-Error {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message
    )

    Write-Host "   $( $red )$( Get-Emoji -Unicode "276F" )$( $normal ) $Message"
}

function Write-Success {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message
    )

    Write-Host "   $( $green )$( Get-Emoji -Unicode "276F" )$( $normal ) $Message"
}

function Install-Package {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Unicode,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Id
    )

    Write-Host "$( Get-Emoji -Unicode $Unicode ) $( $violet )Installing$( $normal ) package: $( $purple )$Id$( $normal )"
    $packageOutput = Invoke-Expression "winget.exe install --exact --silent --accept-source-agreements --accept-package-agreements --id $Id"

    if ($LastExitCode -eq 0) {
        Write-Success "Successfully installed"
    } elseif ($LastExitCode -eq -1978335189) {
        Write-Success "Already installed"
    } else {
        Write-Error "Error installing"
        exit $LastExitCode
    }
}

# Start as admin if not already
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process -FilePath "wt.exe" -ArgumentList "powershell -NoProfile -ExecutionPolicy Bypass -Command $( $MyInvocation.MyCommand.Definition )" -Verb RunAs
    exit 0
}

Write-Host @"
$( $purple )$( Get-Emoji -Unicode "256D" )$( (Get-Emoji -Unicode "2500") * 50 )$( Get-Emoji -Unicode "256E" )$( $normal )
$( $purple )$( Get-Emoji -Unicode "2502" )$( $normal )              $( Get-Emoji -Unicode "1F940" ) $( $italic )Dotfiles Installer$( $regular )               $( $purple )$( Get-Emoji -Unicode "2502" )$( $normal )
$( $purple )$( Get-Emoji -Unicode "2570" )$( (Get-Emoji -Unicode "2500") * 50 )$( Get-Emoji -Unicode "256F" )$( $normal )

"@

# Install dependencies
Install-Package -Unicode "1F4E6" -Id "Microsoft.AppInstaller"
Install-Package -Unicode "1F41A" -Id "Microsoft.PowerShell"
Install-Package -Unicode "1F380" -Id "charmbracelet.gum"
Install-Package -Unicode "1F9EC" -Id "Git.Git"
Install-Package -Unicode "1F40D" -Id "Python.Python.3.13"

# Refresh PATH
$paths    = (((Get-ItemPropertyValue -Path "HKCU:\Environment" -Name Path) -split ";") + ((Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name Path) -split ";")) | Select-Object -Unique
$env:PATH = $paths -join ";"
Write-Host

# Set dotfiles path
gum confirm --default=no --selected.background=$hex_purple --prompt.foreground="" --prompt.italic --no-show-help "Change dotfiles location? (default ~/.dotfiles)"
if ($LastExitCode -eq 0) {
    do {
        $dotfilesLocation = gum file --cursor="❯" --height=10 --directory --no-show-help --cursor.foreground=$hex_purple --symlink.foreground=$hex_blue --selected.foreground="" --directory.foreground=$hex_violet --file.foreground=$hex_green $env:USERPROFILE
    } while (-not (Test-Path -Path $dotfilesLocation -PathType Container))

    $dotfilesPath = Join-Path -Path $dotfilesLocation -ChildPath $dotfilesFolder
}

# Create dotfiles environment variable
Set-ItemProperty -Path "HKCU:\Environment" -Name $dotfilesEnv -Value $dotfilesPath -Type String
Set-Item -Path "env:$dotfilesEnv" -Value $dotfilesPath

# Clone dotfiles
$dotfilesLabel = gum style --foreground=$hex_violet $dotfilesFolder
gum spin --spinner meter --spinner.foreground=$hex_violet --title "Cloning $dotfilesLabel..." -- git clone --recursive "https://github.com/$dotfilesRepository.git" $env:DOTFILES
gum spin --spinner meter --spinner.foreground=$hex_violet --title "Taking ownership of $dotfilesLabel..." -- takeown /f $env:DOTFILES /r /d y
$dotfilesLabel = gum style --foreground=$hex_purple $dotfilesFolder
gum style --border-foreground=$hex_purple --border=rounded --align=center --width=50 --italic "🎉 $dotfilesLabel cloned!"

# Install packages
pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "os\bootstrap.ps1")

# Apply symlinks
pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "symlinks\bootstrap.ps1")

# Set-up resources
pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "resources\bootstrap.ps1")

# Windows tweaks
gum confirm --default=yes --selected.background=$hex_purple --prompt.foreground="" --prompt.italic --no-show-help "Apply Windows registry tweaks?"
if ($LastExitCode -eq 0) {
    $tweaksLabel = gum style --foreground=$hex_violet "tweaks"
    gum spin --spinner dot --spinner.foreground=$hex_violet --title "Making $tweaksLabel..." -- pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "scripts\tweaks.ps1")
}
