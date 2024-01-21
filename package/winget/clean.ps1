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
function Winget-Clean {
    try {
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
        $result = winget.exe list | Out-String
        $lines  = $result.Split([Environment]::NewLine)

        # Find the line that starts with Name, it contains the header
        $pointer = 0
        while (-not $lines[$pointer].StartsWith("Name")) {
            $pointer++
        }

        # Line has the header, we can find char where we find Id and Version
        $idStart      = $lines[$pointer].IndexOf("Id")
        $versionStart = $lines[$pointer].IndexOf("Version")
        $sourceStart  = $lines[$pointer].IndexOf("Source")

        # Now cycle in real package and split accordingly
        $parsedList = @()
        for ($i = $pointer + 1; $i -le $lines.Length; $i++) {
            $line = $lines[$i]

            if ($line.Length -gt ($idStart + 1) -and -not $line.StartsWith("-")) {
                $ideographsCount = Count-Ideographs -InputString $line
                $id              = $line.Substring($idStart - $ideographsCount, $versionStart - $idStart).TrimEnd()
                $source          = $line.Substring($sourceStart - $ideographsCount, $line.Length - $sourceStart).TrimEnd()
                if ($source) {
                    $parsedList += $id
                }
            }
        }

        $chosenPackages = Invoke-Expression "gum filter --no-limit --placeholder=""Search..."" --match.foreground=$PURPLE --prompt.foreground=$PURPLE --text.foreground=$VIOLET --indicator.foreground=$PURPLE --unselected-prefix.foreground=$VIOLET --selected-indicator.foreground=$PURPLE --cursor-text.foreground="""" --height=10 $parsedList"

        # Uninstall the chosen packages
        $chosenPackages | ForEach-Object {
            $packageLabel  = Invoke-Expression "gum style --foreground=$VIOLET $_"
            $packageOutput = Invoke-Expression "gum spin --spinner moon --title ""Uninstalling $packageLabel..."" --show-output -- winget.exe uninstall --exact --silent --purge --force --id $_"

            if ($packageOutput.Contains("Successfully uninstalled")) {
                Write-Host "✔️ Package uninstalled: $packageLabel"
            }
            else {
                Write-Host "❌ Package could not be uninstalled: $packageLabel"
            }
        }
    }
    catch { }
}
