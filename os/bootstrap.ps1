#Requires -PSEdition Core

# Script variables
$SCRIPT_NAME    = "Winget Importer"
$SCRIPT_VERSION = "v1.0.1"
$SCRIPT_LOG     = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"

# Script colors
$PURPLE = "#ce3ed6"
$VIOLET = "#c698f2"
$GREEN  = "#6dca7b"
$BLUE   = "#11a8cd"

# Script values
$customPackages            = @{
    "custom.AdobeAcrobat"        = Join-Path -Path $env:PROGRAMFILES -ChildPath "Adobe\*Acrobat*"
    "custom.AdobeAfterEffects"   = Join-Path -Path $env:PROGRAMFILES -ChildPath "Adobe\*Adobe After Effects*"
    "custom.AdobeIllustrator"    = Join-Path -Path $env:PROGRAMFILES -ChildPath "Adobe\*Adobe Illustrator*"
    "custom.AdobePhotoshop"      = Join-Path -Path $env:PROGRAMFILES -ChildPath "Adobe\*Adobe Photoshop*"
    "custom.ArchWSL"             = Join-Path -Path $env:PROGRAMFILES -ChildPath "WindowsApps\yuk7.archwsl*"
    "custom.BattleNet"           = "C:\Program Files (x86)\Battle.net"
    "custom.MicrosoftOffice"     = Join-Path -Path $env:PROGRAMFILES -ChildPath "Microsoft Office"
    "custom.MinGW"               = Join-Path -Path $env:PROGRAMFILES -ChildPath "mingw64"
    "custom.NerdFonts"           = Join-Path -Path $env:WINDIR       -ChildPath "Fonts\*NerdFontMono*"
    "custom.Noesis"              = Join-Path -Path $env:PROGRAMFILES -ChildPath "Noesis"
    "custom.NvChad"              = Join-Path -Path $env:PROGRAMFILES -ChildPath "Neovim"
    "custom.Paint"               = Join-Path -Path $env:PROGRAMFILES -ChildPath "Paint.NET"
    "custom.RockstarGames"       = Join-Path -Path $env:PROGRAMFILES -ChildPath "Rockstar Games"
}
$customPackagesPath        = Join-Path -Path $env:DOTFILES -ChildPath "os\windows\custom"
$defaultPackagesFile       = Join-Path -Path $env:DOTFILES -ChildPath "os\windows\Wingetfile"
$packagesFile              = ""
$defaultHelp               = @"
Usage:
  import [<flag>]

Flags:
  -h, --help       Show context-sensitive help.
  -v, --version    Print the version number.
  -f, --file       Installs all the packages in a file.
                   Defaults to: $defaultPackagesFile

"@

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
function Check-Custom-Package {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Package
    )

    if ($customPackages.ContainsKey($Package)) {
        return Test-Path -Path $customPackages[$Package]
    }

    return $false
}

function Get-Custom-Package {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Package
    )

    $parsedPackage = $Package.Replace("custom.", "")
    return Join-Path -Path $customPackagesPath -ChildPath "$parsedPackage.ps1"
}

# Arguments
if ($args.Length -gt 0) {
    switch ($args[0]) {
        { $_ -eq "-h" -or $_ -eq "--help" } {
            Write-Host $defaultHelp
            exit 0
        }
        { $_ -eq "-v" -or $_ -eq "--version" } {
            Write-Host "$SCRIPT_NAME $SCRIPT_VERSION"
            exit 0
        }
        { $_ -eq "-f" -or $_ -eq "--file" } {
            $packagesFile = gum file --cursor="❯" --height=10 --file --no-show-help --cursor.foreground=$PURPLE --symlink.foreground=$BLUE --selected.foreground="" --directory.foreground=$VIOLET --file.foreground=$GREEN $( $defaultPackagesFile | Split-Path -Parent )
        }
        default {
            Write-Host $defaultHelp
            exit 1
        }
    }
}

# If packages file is not specified, use the default location
if (-not $packagesFile) {
    $packagesFile = $defaultPackagesFile
}

# Check if the packages file exists
if (-not (Test-Path -Path $packagesFile -PathType Leaf)) {
    if ($packagesFile -eq $defaultPackagesFile) {
        Logger -Level warn -Message "Default packages file not found" -Structured "file $defaultPackagesFile"
        Write-Host $defaultHelp
    }
    else {
        Write-Host "File does not exist: $packagesFile" -ForegroundColor Red
    }
    exit 1
}

# Filter out the installed packages
$installedPackagesList    = (winget.exe list --accept-source-agreements) -join ""
$notInstalledPackagesList = Get-Content $packagesFile | Where-Object { -not $installedPackagesList.Contains($_) -and -not (Check-Custom-Package -Package $_) }

# If all the packages are already installed, exit
if ($notInstalledPackagesList -eq $null) {
    Write-Host "🤝 No packages to install"
    exit 0
}

# Choose the packages to install
$packagesLabel  = gum style --foreground=$PURPLE packages
$chosenPackages = gum filter --no-limit --prompt="❯ " --prompt.foreground=$PURPLE --indicator.foreground=$PURPLE --selected-indicator.foreground=$VIOLET --match.foreground=$PURPLE --placeholder="Search..." --text.foreground="240" --cursor-text.foreground=$VIOLET --header="🎯 Select the $packagesLabel to install: " --header.foreground="" --height=10 $notInstalledPackagesList

# Install the chosen packages
$chosenPackages | ForEach-Object {
    $isCustomPackage  = $false
    $packageLabel     = gum style --foreground=$VIOLET $_
    $packageInstaller = "winget.exe install --exact --silent --accept-source-agreements --accept-package-agreements --id $_"

    $isPackageAvailable = ((winget.exe search --accept-source-agreements --exact --query $_) -join "").Contains($_)
    $customPackagePath  = Get-Custom-Package -Package $_

    if (Test-Path -Path $customPackagePath -PathType Leaf) {
        $isCustomPackage  = $true
        $packageInstaller = "pwsh -ExecutionPolicy Bypass -File $customPackagePath"
    }
    elseif (-not $isPackageAvailable) {
        Logger -Level warn -Message "Package not available" -Structured "package $_"
        Write-Host "⚠️ Package not available: $packageLabel"
        return
    }

    $isPackageInstalled = ((winget.exe list --accept-source-agreements --exact $_) -join "").Contains($_)

    if ($isPackageInstalled) {
        Logger -Level debug -Message "Package already installed" -Structured "package $_"
        Write-Host "✨ Package already installed: $packageLabel"
        return
    }

    $packageOutput         = Invoke-Expression "gum spin --spinner globe --title ""Installing $packageLabel..."" -- $packageInstaller"
    $checkPackageInstalled = if ($isCustomPackage) { Check-Custom-Package -Package $_ } else { $LastExitCode -eq 0 }

    if ($checkPackageInstalled) {
        Logger -Level debug -Message "Package installed" -Structured "package $_"
        Write-Host "✔️ Package installed: $packageLabel"
    }
    else {
        Logger -Level error -Message "Package could not be installed" -Structured "package $_"
        Write-Host "❌ Package could not be installed: $packageLabel"
    }
}
