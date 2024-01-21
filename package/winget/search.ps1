#Requires -PSEdition Core

# Script colors
$PURPLE = "#ce3ed6"
$VIOLET = "#c698f2"

# Helper
function Count-Ideographs {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$InputString
    )

    $pattern = "[\p{IsCJKUnifiedIdeographs}]"
    $matches = [System.Text.RegularExpressions.Regex]::Matches($InputString, $pattern)
    return $matches.Count
}

# Main
function Winget-Search {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Query
    )

    try {
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
        $result = winget.exe search $Query | Out-String

        if ($result.Contains("No package found")) {
            Write-Host "🔍 No package found"
            return
        }

        $lines  = $result.Split([Environment]::NewLine)

        # Find the line that starts with Name, it contains the header
        $pointer = 0
        while (-not $lines[$pointer].StartsWith("Name")) {
            $pointer++
        }

        # Line has the header, we can find char where we find Id and Version
        $idStart      = $lines[$pointer].IndexOf("Id")
        $versionStart = $lines[$pointer].IndexOf("Version")

        # Now cycle in real package and split accordingly
        $parsedList = @()
        for ($i = $pointer + 1; $i -le $lines.Length; $i++) {
            $line = $lines[$i]

            if ($line.Length -gt ($idStart + 1) -and -not $line.StartsWith("-")) {
                $ideographsCount = Count-Ideographs -InputString $line
                $id              = $line.Substring($idStart - $ideographsCount, $versionStart - $idStart).TrimEnd()
                $parsedList     += $id
            }
        }

        $chosenPackage = Invoke-Expression "gum filter --placeholder=""Search..."" --match.foreground=$PURPLE --prompt.foreground=$PURPLE --text.foreground=$VIOLET --indicator.foreground=$PURPLE --unselected-prefix.foreground=$VIOLET --selected-indicator.foreground=$PURPLE --cursor-text.foreground="""" --height=10 $parsedList"

        if (-not $chosenPackage) {
            return
        }

        $packageInstalled = ((winget.exe list --exact --query $chosenPackage) -join "").Contains($chosenPackage)
        $action           = if ($packageInstalled) { "Updating" } else { "Installing" }
        $output           = if ($packageInstalled) { "updated"  } else { "installed"  }

        # Install or update the chosen package
        $packageLabel  = Invoke-Expression "gum style --foreground=$VIOLET $chosenPackage"
        $packageOutput = Invoke-Expression "gum spin --spinner moon --title ""$action $packageLabel..."" --show-output -- winget.exe install --exact --silent --accept-source-agreements --accept-package-agreements --id $chosenPackage"

        if (($packageOutput -join "").Contains("No available upgrade found")) {
            Write-Host "✨ Package already $output`: $packageLabel"
        }
        elseif ($packageOutput.Contains("Successfully installed")) {
            Write-Host "✔️ Package $output`: $packageLabel"
        }
        else {
            Write-Host "❌ Package could not be $output`: $packageLabel"
        }
    }
    catch { }
}
