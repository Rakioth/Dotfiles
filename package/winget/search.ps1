#Requires -PSEdition Core

function Winget-Search {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Query
    )

    $PURPLE = "#ce3ed6"
    $VIOLET = "#c698f2"

    $packages = Find-WinGetPackage -Query $Query -Source "winget" | Select-Object -ExpandProperty Id
    if (-not $packages) {
        Write-Host "🔍 No packages found"
        return
    }

    $packagesLabel = gum style --foreground=$PURPLE package
    $chosenPackage = gum filter --select-if-one --prompt="❯ " --prompt.foreground=$PURPLE --indicator.foreground=$PURPLE --match.foreground=$PURPLE --placeholder="Search..." --text.foreground="240" --cursor-text.foreground=$VIOLET --header="🚀 Select the $packagesLabel to install: " --header.foreground="" --height=10 $packages

    if (-not $chosenPackage) {
        return
    }

    $packageLabel = gum style --foreground=$VIOLET $chosenPackage
    gum spin --spinner="moon" --title="Installing $packageLabel..." -- winget.exe install --exact --silent --accept-source-agreements --accept-package-agreements --id $chosenPackage

    if ($LastExitCode -eq 0) {
        Write-Host "✔️ Package installed: $packageLabel"
    }
    else {
        Write-Host "❌ Package could not be installed: $packageLabel"
    }
}
