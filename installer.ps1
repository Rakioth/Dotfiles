$ErrorActionPreference = "Stop"
$ProgressPreference    = "SilentlyContinue"

# Script colors/styles
$RED    = "$( [char]27 )[0;31m"
$GREEN  = "$( [char]27 )[0;32m"
$PURPLE = "$( [char]27 )[38;2;206;62;214m"
$VIOLET = "$( [char]27 )[38;2;198;152;242m"
$NORMAL = "$( [char]27 )[0m"
$PROMPT = "❯"

$HEX_PURPLE = "#ce3ed6"
$HEX_VIOLET = "#c698f2"
$HEX_GREEN  = "#6dca7b"
$HEX_BLUE   = "#11a8cd"

# Script values
$DOTFILES_REPOSITORY = "https://github.com/Rakioth/Dotfiles.git"
$DOTFILES_ENV        = "DOTFILES"
$DOTFILES_FOLDER     = ".dotfiles"
$DOTFILES_PATH       = Join-Path -Path $env:USERPROFILE -ChildPath $DOTFILES_FOLDER

# Script functions
function Refresh-Path {
    $userPath   = (Get-ItemPropertyValue -Path "HKCU:\Environment"                                                  -Name Path) -split ";"
    $systemPath = (Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name Path) -split ";"
    $paths      = ($userPath + $systemPath) | Select-Object -Unique
    $env:PATH   = $paths -join ";"
}

function Get-Emoji {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Unicode
    )

    return [System.Char]::ConvertFromUtf32([System.Convert]::toInt32($Unicode, 16))
}

function Output-Success {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message
    )

    Write-Host "   $GREEN$( Get-Emoji -Unicode "276F" )$NORMAL $Message"
}

function Output-Error {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message
    )

    Write-Host "   $RED$( Get-Emoji -Unicode "276F" )$NORMAL $Message"
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

    Write-Host "$( Get-Emoji -Unicode $Unicode ) ${VIOLET}Installing${NORMAL} package: ${PURPLE}$Id${NORMAL}"
    $packageOutput = Invoke-Expression "winget install --exact --silent --accept-source-agreements --accept-package-agreements --id $Id"

    switch ($LASTEXITCODE) {
        0           {
            Output-Success "Successfully installed"
        }
        -1978335212 {
            Output-Error "Not available"
            exit $LASTEXITCODE
        }
        -1978335189 {
            Output-Success "Already installed"
        }
        default     {
            Output-Error "Could not be installed"
            exit $LASTEXITCODE
        }
    }
}

function Get-DotfilesPath {
    gum confirm --no-show-help --prompt.italic `
        --selected.background $HEX_PURPLE --prompt.foreground "" `
        --default=false `
        "Change dotfiles location? (default ~/.dotfiles)"

    if ($LASTEXITCODE -eq 0) {
        do {
            $location = gum file $env:USERPROFILE --no-show-help `
                --cursor.foreground $HEX_PURPLE `
                --symlink.foreground $HEX_BLUE `
                --directory.foreground $HEX_VIOLET `
                --file.foreground $HEX_GREEN `
                --selected.foreground "" `
                --directory=true `
                --file=false `
                --cursor $PROMPT `
                --height 10
        } until (Test-Path -Path $location -PathType Container)

        return Join-Path -Path $location -ChildPath $DOTFILES_FOLDER
    }

    return $DOTFILES_PATH
}

function Initialize-Dotfiles {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    Set-ItemProperty -Path "HKCU:\Environment" -Name $DOTFILES_ENV -Value $Path -Type String
    Set-Item -Path "env:$DOTFILES_ENV" -Value $Path

    $dotfilesLabel = gum style --foreground $HEX_VIOLET $DOTFILES_FOLDER
    gum spin --spinner meter --spinner.foreground $HEX_PURPLE --title "Cloning $dotfilesLabel..." -- git clone --recursive $DOTFILES_REPOSITORY $Path
    gum spin --spinner meter --spinner.foreground $HEX_PURPLE --title "Taking ownership of $dotfilesLabel..." -- takeown /f $Path /r /d y
}

# Start as admin if not already
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process -FilePath "wt" -ArgumentList "powershell -NoProfile -ExecutionPolicy Bypass -Command $( $MyInvocation.MyCommand.Definition )" -Verb RunAs
    exit 0
}

Write-Host @"
$PURPLE$( Get-Emoji -Unicode "256D" )$( (Get-Emoji -Unicode "2500") * 50 )$( Get-Emoji -Unicode "256E" )$NORMAL
$PURPLE$( Get-Emoji -Unicode "2502" )$NORMAL              $( Get-Emoji -Unicode "1F940" ) $( "$( [char]27 )[3m" )Dotfiles Installer$( "$( [char]27 )[0m" )               $PURPLE$( Get-Emoji -Unicode "2502" )$NORMAL
$PURPLE$( Get-Emoji -Unicode "2570" )$( (Get-Emoji -Unicode "2500") * 50 )$( Get-Emoji -Unicode "256F" )$NORMAL

"@

# Install dependencies
Install-Package -Unicode "1F4E6" -Id "Microsoft.AppInstaller"
Install-Package -Unicode "1F41A" -Id "Microsoft.PowerShell"
Install-Package -Unicode "1F380" -Id "charmbracelet.gum"
Install-Package -Unicode "1F9EC" -Id "Git.Git"
Install-Package -Unicode "1F40D" -Id "Python.Python.3.13"

Write-Host
Refresh-Path
$dotfilesLabel = gum style --foreground $HEX_VIOLET $DOTFILES_FOLDER

# Handle dotfiles setup
if (Test-Path -Path "env:$DOTFILES_ENV") {
    Write-Host "🎉 $dotfilesLabel already cloned!`n"
} else {
    $dotfilesPath = Get-DotfilesPath
    Initialize-Dotfiles -Path $dotfilesPath
    Write-Host "🎉 $dotfilesLabel cloned!`n"
}

# Enable inline sudo
sudo.exe config --enable normal | Out-Null
$dotfilesRoot = (Get-Item -Path "env:$DOTFILES_ENV").Value

# Install packages
pwsh -NoProfile -ExecutionPolicy Bypass -File "$dotfilesRoot\os\windows\main.ps1"
Refresh-Path

# Apply symlinks
Write-Host
pwsh -NoProfile -ExecutionPolicy Bypass -File "$dotfilesRoot\symlinks\apply\main.ps1"

# Windows tweaks
Write-Host
pwsh -NoProfile -ExecutionPolicy Bypass -File "$dotfilesRoot\scripts\tweaks\main.ps1"
