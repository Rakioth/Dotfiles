function Output-Error {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message
    )

    Write-Host "$( "$( [char]27 )[0;31m" )Error:$( "$( [char]27 )[0m" ) $Message"
}
