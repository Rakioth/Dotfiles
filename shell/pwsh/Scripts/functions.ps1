function Set-Location-One-Time {
    Set-Location -Path ".."
}

function Set-Location-Two-Times {
    Set-Location -Path "..\.."
}

function Set-Location-Three-Times {
    Set-Location -Path "..\..\.."
}

function Start-Code {
    $ErrorActionPreference = "SilentlyContinue"
    Start-Process -FilePath code -ArgumentList $args -NoNewWindow
}

function Start-IntelliJ {
    $ErrorActionPreference = "SilentlyContinue"
    Start-Process -FilePath "C:\Program Files (x86)\JetBrains\IntelliJ IDEA 2023.3.3\bin\idea64.exe" -ArgumentList $args -NoNewWindow
}

function List-Items {
    lsd -l --group-dirs=first $args
}

function List-Hidden-Items {
    lsd -la --group-dirs=first $args
}

function List-Tree {
    lsd --tree $args
}

function Less-Content {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$Path
    )

    Get-Content -Path $Path -Wait
}

function Head-Content {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int32]$First,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$Path
    )

    Get-Content -Path $Path | Select-Object -First $First
}

function Tail-Content {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int32]$Last,
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$Path
    )

    Get-Content -Path $Path | Select-Object -Last $Last
}

function Touch-Item {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Name
    )

    $Name | ForEach-Object { New-Item -ItemType File -Name $_ | Out-Null }
}

function Upload-Item {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$Path
    )

    $link = curl -sF "file=@$Path" 0x0.st

    if ($link.Contains("<html>")) {
        Write-Error "Upload failed"
        return
    }

    $link | Set-Clipboard
}

function Which-Command {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Name
    )

    Get-Command -Name $Name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Definition
}

function Grep-Process {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Name
    )

    Get-Process -Name $( $Name | ForEach-Object { "*$_*" } )
}

function Kill-Process {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Name
    )

    Stop-Process -Name $Name -ErrorAction SilentlyContinue
}

function Compress-Zip {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ })]
        [string]$Path,
        [Parameter(Mandatory = $false)]
        [ValidateScript({ Test-Path -Path $_ -PathType Container })]
        [string]$DestinationPath = $pwd
    )

    Compress-Archive -Path $Path -DestinationPath (Join-Path -Path $DestinationPath -ChildPath "$( Split-Path -Path $Path -Leaf ).zip") -Force
}

function Expand-Zip {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$Path,
        [Parameter(Mandatory = $false)]
        [ValidateScript({ Test-Path -Path $_ -IsValid })]
        [string]$DestinationPath = $pwd
    )

    Expand-Archive -Path $Path -DestinationPath $DestinationPath -Force
}

function Start-Admin {
    gsudo --loadProfile $args
}

function Quit {
    Exit
}

function Git-Add-All {
    git add -A
}

function Git-Commit-All {
    git add -A && git commit -m "$args"
}

function Git-Status {
    git status -sb
}

function Git-Fetch {
    git fetch --all
}

function Git-Push {
    git push
}

function Git-Pull {
    git pull --autostash
}

function Git-Log {
    git log --graph --abbrev-commit --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
}

function Git-Clone {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $splitPath = $Path.Split("/", 3)

    if ($splitPath.Length -lt 3) {
        git clone "https://github.com/$Path.git" --depth 1
        return
    }

    git clone "https://github.com/$( $splitPath[0] )/$( $splitPath[1] ).git" --depth 1 --no-checkout
    if ($LastExitCode -ne 0) {
        return
    }

    Set-Location -Path $splitPath[1]
    git sparse-checkout set $splitPath[2]
    git checkout
    Set-Location -Path ".."
}
