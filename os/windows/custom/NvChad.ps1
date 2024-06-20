#Requires -PSEdition Core
#Requires -RunAsAdministrator

# Script variables
$SCRIPT_NAME   = "NvChad Installer"
$SCRIPT_LOG    = Join-Path -Path $env:USERPROFILE -ChildPath "dotfiles.log"
$SCRIPT_SOURCE = "NvChad/NvChad"

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
function Install-Dependency {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Package
    )

    $isPackageInstalled = ((winget.exe list --accept-source-agreements --exact $Package) -join "").Contains($Package)

    if ($isPackageInstalled) {
        Logger -Level debug -Message "Dependency already installed" -Structured "dependency $Package"
        return
    }

    winget.exe install --exact --silent --accept-source-agreements --accept-package-agreements --id $Package

    if ($LastExitCode -eq 0) {
        Logger -Level debug -Message "Dependency installed" -Structured "dependency $Package"
    }
    else {
        Logger -Level error -Message "Dependency could not be installed" -Structured "dependency $Package"
        exit 1
    }
}

Install-Dependency -Package "Git.Git"
Install-Dependency -Package "ezwinports.make"
Install-Dependency -Package "BurntSushi.ripgrep.MSVC"
Install-Dependency -Package "Neovim.Neovim"
