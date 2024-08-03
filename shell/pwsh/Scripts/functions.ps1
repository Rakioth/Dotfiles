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
    Start-Process -FilePath code -ArgumentList $args -WindowStyle Hidden
}

function Start-IntelliJ {
    $ErrorActionPreference = "SilentlyContinue"
    Start-Process -FilePath "C:\Program Files (x86)\JetBrains\IntelliJ IDEA 2024.1.3\bin\idea64.exe" -ArgumentList $args -NoNewWindow
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
        [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Names
    )

    $Names | ForEach-Object { New-Item -ItemType File -Name $_ | Out-Null }
}

function Upload-Item {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$Path
    )

    $result      = curl -s -w "%{http_code}" -F "file=@$Path" 0x0.st
    $resultLines = $result -split "`n"

    if ($resultLines[-1] -ne "200") {
        Write-Host "Upload failed" -ForegroundColor Red
        return 1
    }

    $resultLines[0] | Set-Clipboard
}

function Which-Command {
    param (
        [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Names
    )

    Get-Command -Name $Names -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Definition
}

function Grep-Process {
    param (
        [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Names
    )

    Get-Process -Name $( $Names | ForEach-Object { "*$_*" } )
}

function Kill-Process {
    param (
        [Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
        [ValidateNotNullOrEmpty()]
        [string[]]$Names
    )

    Stop-Process -Name $Names -ErrorAction SilentlyContinue
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

function Clear-Bin {
    Clear-RecycleBin -Force
}

function Quit {
    Exit
}

function Git-Fuzzy-Add {
    git add (git ls-files --modified --others --exclude-standard | fzf --multi --ansi --preview="bat --color=always --style=numbers --line-range=:500 {}")
}

function Git-Fuzzy-Remove {
    git reset HEAD (git diff --cached --name-only --relative | fzf --multi --ansi --preview="bat --color=always --style=numbers --line-range=:500 {}")
}

function Git-Add-All {
    git add -A $args
}

function Git-Commit-All {
    git add -A && git commit -m "$args"
}

function Git-Commit-Push {
    git commit -m "$args" && git push
}

function Git-Status {
    git status -sb $args
}

function Git-Fetch {
    git fetch --all $args
}

function Git-Push {
    git push $args
}

function Git-Pull {
    git pull --autostash $args
}

function Git-Log {
    git log --graph --abbrev-commit --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'
}

function Git-Clone {
    $splitPath = $args[0].Split("/", 3)

    if ($splitPath.Length -lt 3) {
        git clone "https://github.com/$( $args[0] ).git" --depth 1 $args[1..$args.Length]
        return
    }

    git clone "https://github.com/$( $splitPath[0] )/$( $splitPath[1] ).git" --depth 1 --no-checkout $args[1..$args.Length]
    if ($LastExitCode -ne 0) {
        return
    }

    Set-Location -Path $splitPath[1]
    git sparse-checkout set $splitPath[2]
    git checkout
    Set-Location -Path ".."
}
