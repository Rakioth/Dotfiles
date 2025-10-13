function Output-Success {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Label = "Success:"
    )

    Write-Host "$( [char]27 )[0;32m$Label$( [char]27 )[0m $Message"
}

function Output-Error {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$Label = "Error:"
    )

    Write-Host "$( [char]27 )[0;31m$Label$( [char]27 )[0m $Message"
}
