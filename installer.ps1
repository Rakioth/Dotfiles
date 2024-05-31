# Script colors
$PURPLE      = "#ce3ed6"
$VIOLET      = "#c698f2"
$GREEN       = "#6dca7b"
$BLUE        = "#11a8cd"
$ANSI_VIOLET = "$( [char]27 )[38;2;198;152;242m"
$ANSI_RESET  = "$( [char]27 )[0m"

# Script values
$ProgressPreference = "SilentlyContinue"
$dotfilesRepository = "Rakioth/Dotfiles"
$dotfilesEnv        = "DOTFILES"
$dotfilesFolder     = ".dotfiles"
$dotfilesPath       = Join-Path -Path $env:USERPROFILE -ChildPath $dotfilesFolder

# Helper
function Get-Emoji {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Unicode
    )

    return [System.Char]::ConvertFromUtf32([System.Convert]::toInt32($Unicode, 16))
}

function Install-Dependency {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Package,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Emoji
    )

    $isPackageInstalled = ((winget.exe list --exact $Package) -join "").Contains($Package)

    if ($isPackageInstalled) {
        Write-Host "$( Get-Emoji -Unicode $Emoji ) $ANSI_VIOLET$Name$ANSI_RESET already installed"
        return
    }

    $packageOutput = Invoke-Expression "winget.exe install --exact --silent --accept-source-agreements --accept-package-agreements --id $Package"

    if ($LastExitCode -eq 0) {
        Write-Host "$( Get-Emoji -Unicode $Emoji ) $ANSI_VIOLET$Name$ANSI_RESET installed"
    }
    else {
        Write-Host "$( Get-Emoji -Unicode "274C" ) $ANSI_VIOLET$Name$ANSI_RESET could not be installed"
        exit 1
    }
}

function Update-Winget {
    $isWingetUpdated = (winget.exe -v).Substring(1) -ge 1.6

    if ($isWingetUpdated) {
        Write-Host "$( Get-Emoji -Unicode "1F4E6" ) $( $ANSI_VIOLET )Winget$( $ANSI_RESET ) already updated"
        return
    }

    $wingetBundle = Join-Path -Path $env:TEMP -ChildPath "winget.msixbundle"
    Start-BitsTransfer -Source "https://aka.ms/getwinget" -Destination $wingetBundle
    Add-AppPackage -ForceApplicationShutdown $wingetBundle
    Remove-Item -Path $wingetBundle

    if ((winget.exe -v).Substring(1) -ge 1.6) {
        Write-Host "$( Get-Emoji -Unicode "1F4E6" ) $( $ANSI_VIOLET )Winget$( $ANSI_RESET ) updated"
    }
    else {
        Write-Host "$( Get-Emoji -Unicode "274C" ) $( $ANSI_VIOLET )Winget$( $ANSI_RESET ) could not be updated"
        exit 1
    }
}

# Start as admin if not already
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process -FilePath "wt" -ArgumentList "-p Windows PowerShell $( $MyInvocation.MyCommand.Definition )" -Verb RunAs
    exit
}

# Update winget
Update-Winget

# Install dependencies
Install-Dependency -Package "Microsoft.PowerShell" -Name "Pwsh"   -Emoji "1F41A"
Install-Dependency -Package "charmbracelet.gum"    -Name "Gum"    -Emoji "1F380"
Install-Dependency -Package "Git.Git"              -Name "Git"    -Emoji "1F419"
Install-Dependency -Package "Python.Python.3.13"   -Name "Python" -Emoji "1F40D"

# Refresh PATH
$paths    = (((Get-ItemPropertyValue -Path "HKCU:\Environment" -Name Path) -split ";") + ((Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name Path) -split ";")) | Select-Object -Unique
$env:PATH = $paths -join ";"

# Set dotfiles path
gum confirm --default=no --selected.background=$PURPLE --prompt.foreground="" --prompt.italic --no-show-help "Change dotfiles location? (default ~/.dotfiles)"
if ($LastExitCode -eq 0) {
    do {
        $dotfilesLocation = gum file --cursor="❯" --height=10 --directory --no-show-help --cursor.foreground=$PURPLE --symlink.foreground=$BLUE --selected.foreground="" --directory.foreground=$VIOLET --file.foreground=$GREEN $env:USERPROFILE
    } while (-not (Test-Path -Path $dotfilesLocation -PathType Container))

    $dotfilesPath = Join-Path -Path $dotfilesLocation -ChildPath $dotfilesFolder
}

# Create dotfiles environment variable
Set-ItemProperty -Path "HKCU:\Environment" -Name $dotfilesEnv -Value $dotfilesPath -Type String
Set-Item -Path "env:$dotfilesEnv" -Value $dotfilesPath

# Clone dotfiles
$dotfilesLabel = gum style --foreground=$VIOLET $dotfilesFolder
gum spin --spinner meter --spinner.foreground=$VIOLET --title "Cloning $dotfilesLabel..." -- git clone --recursive "https://github.com/$dotfilesRepository.git" $env:DOTFILES
gum spin --spinner meter --spinner.foreground=$VIOLET --title "Taking ownership of $dotfilesLabel..." -- takeown /f $env:DOTFILES /r /d y
$dotfilesLabel = gum style --foreground=$PURPLE $dotfilesFolder
gum style --border-foreground=$PURPLE --border=rounded --align=center --width=50 --italic "🎉 $dotfilesLabel cloned!"

# Install packages
pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "os\bootstrap.ps1")

# Apply symlinks
pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "symlinks\bootstrap.ps1")

# Set-up resources
pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "resources\bootstrap.ps1")

# Windows tweaks
gum confirm --default=yes --selected.background=$PURPLE --prompt.foreground="" --prompt.italic --no-show-help "Apply Windows registry tweaks?"
if ($LastExitCode -eq 0) {
    $tweaksLabel = gum style --foreground=$VIOLET "tweaks"
    gum spin --spinner dot --spinner.foreground=$VIOLET --title "Making $tweaksLabel..." -- pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "scripts\tweaks.ps1")
}
