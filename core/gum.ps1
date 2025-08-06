function Gum-Filter {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Options,
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$PrimaryColor = "#ce3ed6",
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$SecondaryColor = "#c698f2"
    )

    gum filter --no-show-help --prompt="❯ " --prompt.foreground=$PrimaryColor --indicator.foreground=$PrimaryColor --match.foreground=$PrimaryColor --placeholder="Search..." --text.foreground="240" --cursor-text.foreground=$SecondaryColor --height=10 $Options
}
