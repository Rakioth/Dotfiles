#Requires -PSEdition Core

function Winget-Clean  {
    param (
        [Parameter(Mandatory = $false)]
        [string[]]$Ids
    )

    $PURPLE = "#ce3ed6"
    $VIOLET = "#c698f2"

    if ($Ids.Length -gt 0) {
        $chosenPackages = $Ids
    }
    else {
        $packages       = Get-WinGetPackage | Where-Object { $_.Source -eq "winget" } | Select-Object -ExpandProperty Id
        if (-not $packages) {
            Write-Host "🔍 No packages found"
            return
        }

        $packagesLabel  = gum style --foreground=$PURPLE packages
        $chosenPackages = gum filter --no-limit --prompt="❯ " --prompt.foreground=$PURPLE --indicator.foreground=$PURPLE --selected-indicator.foreground=$VIOLET --match.foreground=$PURPLE --placeholder="Search..." --text.foreground="240" --cursor-text.foreground=$VIOLET --header="🗑️ Select the $packagesLabel to uninstall: " --header.foreground="" --height=10 $packages
    }

    $chosenPackages | ForEach-Object {
        $packageLabel = gum style --foreground=$VIOLET $_
        gum spin --spinner="moon" --title="Uninstalling $packageLabel..." -- winget.exe uninstall --exact --silent --purge --force --id $_

        if ($LastExitCode -eq 0) {
            Write-Host "✔️ Package uninstalled: $packageLabel"
        }
        else {
            Write-Host "❌ Package could not be uninstalled: $packageLabel"
        }
    }
}
