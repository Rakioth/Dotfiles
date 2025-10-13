$PrimaryColor   = "#ce3ed6"
$SecondaryColor = "#c698f2"
$PromptSymbol   = "❯"

function Gum-Filter {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Options,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [int]$Limit = 0,

        [Parameter(Mandatory = $false)]
        [string]$Header,

        [Parameter(Mandatory = $false)]
        [switch]$SelectIfOne,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$PrimaryColor = $script:PrimaryColor,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SecondaryColor = $script:SecondaryColor,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$PromptSymbol = $script:PromptSymbol
    )

    $flags = @()
    if ($Limit -gt 0) { $flags += "--limit=$Limit"   } else { $flags += "--no-limit" }
    if ($Header)      { $flags += "--header=$Header" }
    if ($SelectIfOne) { $flags += "--select-if-one"  }

    gum filter @flags $Options `
        --no-show-help --no-fuzzy `
        --prompt.foreground $PrimaryColor `
        --indicator.foreground $PrimaryColor `
        --match.foreground $PrimaryColor `
        --selected-indicator.foreground $SecondaryColor `
        --cursor-text.foreground $SecondaryColor `
        --text.foreground "240" `
        --header.foreground "" `
        --prompt "$PromptSymbol " `
        --placeholder "Search..." `
        --height 10
}
