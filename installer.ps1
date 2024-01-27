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

# Start as admin if not already
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Start-Process -FilePath "wt" -ArgumentList "-p Windows PowerShell $( $MyInvocation.MyCommand.Definition )" -Verb RunAs
    exit
}

# Update winget
$wingetBundle = Join-Path -Path $env:TEMP -ChildPath "winget.msixbundle"
Start-BitsTransfer -Source "https://aka.ms/getwinget" -Destination $wingetBundle
Add-AppPackage -ForceApplicationShutdown $wingetBundle
Remove-Item -Path $wingetBundle

# Check winget version
$wingetVersion = (winget.exe -v).Substring(1)
if ($wingetVersion -lt 1.6) {
    Write-Host "$( Get-Emoji -Unicode "274C" ) $( $ANSI_VIOLET )Winget$( $ANSI_RESET ) could not be updated"
    exit 1
}
Write-Host "$( Get-Emoji -Unicode "1F4E6" ) $( $ANSI_VIOLET )Winget$( $ANSI_RESET ) updated"

# Install pwsh
$pwshOutput = (Invoke-Expression "winget.exe install --exact --silent --accept-source-agreements --accept-package-agreements --id Microsoft.PowerShell") -join ""
if (-not $pwshOutput.Contains("already installed") -and -not $pwshOutput.Contains("Successfully installed")) {
    Write-Host "$( Get-Emoji -Unicode "274C" ) $( $ANSI_VIOLET )Pwsh$( $ANSI_RESET ) could not be installed"
    exit 1
}
Write-Host "$( Get-Emoji -Unicode "1F41A" ) $( $ANSI_VIOLET )Pwsh$( $ANSI_RESET ) installed"

# Install gum
$gumOutput = (Invoke-Expression "winget.exe install --exact --silent --accept-source-agreements --accept-package-agreements --id charmbracelet.gum") -join ""
if (-not $gumOutput.Contains("already installed") -and -not $gumOutput.Contains("Successfully installed")) {
    Write-Host "$( Get-Emoji -Unicode "274C" ) $( $ANSI_VIOLET )Gum$( $ANSI_RESET ) could not be installed"
    exit 1
}
Write-Host "$( Get-Emoji -Unicode "1F380" ) $( $ANSI_VIOLET )Gum$( $ANSI_RESET ) installed"

# Install git
$gitOutput = (Invoke-Expression "winget.exe install --exact --silent --accept-source-agreements --accept-package-agreements --id Git.Git") -join ""
if (-not $gitOutput.Contains("already installed") -and -not $gitOutput.Contains("Successfully installed")) {
    Write-Host "$( Get-Emoji -Unicode "274C" ) $( $ANSI_VIOLET )Git$( $ANSI_RESET ) could not be installed"
    exit 1
}
Write-Host "$( Get-Emoji -Unicode "1F419" ) $( $ANSI_VIOLET )Git$( $ANSI_RESET ) installed"

# Install python
$gitOutput = (Invoke-Expression "winget.exe install --exact --silent --accept-source-agreements --accept-package-agreements --id Python.Python.3.13") -join ""
if (-not $gitOutput.Contains("already installed") -and -not $gitOutput.Contains("Successfully installed")) {
    Write-Host "$( Get-Emoji -Unicode "274C" ) $( $ANSI_VIOLET )Python$( $ANSI_RESET ) could not be installed"
    exit 1
}
Write-Host "$( Get-Emoji -Unicode "1F40D" ) $( $ANSI_VIOLET )Python$( $ANSI_RESET ) installed"

# Refresh PATH
$paths    = (((Get-ItemPropertyValue -Path "HKCU:\Environment" -Name Path) -split ";") + ((Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" -Name Path) -split ";")) | Select-Object -Unique
$env:PATH = $paths -join ";"

# Set dotfiles path
gum confirm --default=no --selected.background=$PURPLE --prompt.italic "Change dotfiles location? (default ~/.dotfiles)"
if (-not $LastExitCode) {
    do {
        $dotfilesLocation = gum file --cursor="❯" --height=10 --directory --cursor.foreground=$PURPLE --symlink.foreground=$BLUE --selected.foreground="" --directory.foreground=$VIOLET --file.foreground=$GREEN $env:USERPROFILE
    } while (-not (Test-Path -Path $dotfilesLocation -PathType Container))

    $dotfilesPath = Join-Path -Path $dotfilesLocation -ChildPath $dotfilesFolder
}

# Create dotfiles environment variable
Set-ItemProperty -Path "HKCU:\Environment" -Name $dotfilesEnv -Value $dotfilesPath -Type String
Set-Item -Path "env:$dotfilesEnv" -Value $dotfilesPath

# Clone dotfiles
$dotfilesLabel = gum style --foreground=$VIOLET $dotfilesFolder
gum spin --spinner meter --spinner.foreground=$VIOLET --title "Cloning $dotfilesLabel..." -- git clone --recursive "https://github.com/$dotfilesRepository.git" $env:DOTFILES
Write-Host "$( Get-Emoji -Unicode "1F389" ) $dotfilesLabel cloned"

# Install packages
pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "os\bootstrap.ps1")

# Apply symlinks
pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "symlinks\bootstrap.ps1")

# Set-up resources
pwsh -ExecutionPolicy Bypass -File (Join-Path -Path $env:DOTFILES -ChildPath "resources\bootstrap.ps1")
