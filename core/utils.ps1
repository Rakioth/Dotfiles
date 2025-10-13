function Util-ItemProperty {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Path,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $false)]
        [Object]$Value,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.Win32.RegistryValueKind]$Type
    )

    if (-not (Test-Path -Path "HKU:\")) {
        New-PSDrive -PSProvider Registry -Name HKU -Root HKEY_USERS | Out-Null
    }

    if (-not (Test-Path -Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }

    if ($Value -ne $null) {
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -Force -ErrorAction SilentlyContinue
    } else {
        Remove-ItemProperty -Path $Path -Name $Name -Force -ErrorAction SilentlyContinue
    }
}

function Util-ScheduledTask {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$TaskName,

        [Parameter(Mandatory = $false)]
        [switch]$Disabled
    )

    if ($Disabled) {
        Disable-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    } else {
        Enable-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue
    }
}

function Util-Service {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.Commands.ServiceStartupType]$StartupType
    )

    Get-Service -Name $Name -ErrorAction SilentlyContinue |
        Set-Service -StartupType $StartupType -ErrorAction SilentlyContinue
}
