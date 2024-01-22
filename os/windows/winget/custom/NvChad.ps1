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

    $isPackageInstalled = ((winget.exe list --exact --query $Package) -join "").Contains($Package)

    if ($isPackageInstalled) {
        Logger -Level debug -Message "Dependency already installed" -Structured "dependency $Package"
        return
    }

    $packageOutput = winget.exe install --exact --silent --accept-source-agreements --accept-package-agreements --id $Package

    if ($packageOutput.Contains("Successfully installed")) {
        Logger -Level debug -Message "Dependency installed" -Structured "dependency $Package"
    }
    else {
        Logger -Level error -Message "Dependency could not be installed" -Structured "dependency $Package"
        exit 1
    }
}

function Config-Dependency {
    $binPath       = "C:\Program Files (x86)\GnuWin32\bin"
    $persistedPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User) -split ";"
    if ($persistedPath -notcontains $binPath) {
        $persistedPath += $binPath
        [Environment]::SetEnvironmentVariable("Path", $persistedPath -join ";", [EnvironmentVariableTarget]::User)
    }
    Logger -Level debug -Message "Binaries added to PATH" -Structured "path ""$binPath"""
}

Install-Dependency -Package "Git.Git"
Install-Dependency -Package "GnuWin32.Make"
Install-Dependency -Package "BurntSushi.ripgrep.MSVC"
Install-Dependency -Package "Neovim.Neovim"

Config-Dependency

$pathInstallation = Join-Path -Path $env:LOCALAPPDATA -ChildPath "nvim"
$pathGit          = Join-Path -Path $env:PROGRAMFILES -ChildPath "Git\cmd\git.exe"
Start-Process $pathGit -ArgumentList "clone ""https://github.com/$SCRIPT_SOURCE"" $pathInstallation --depth 1" -NoNewWindow
Logger -Level debug -Message "Repository cloned" -Structured "path ""$pathInstallation"""
