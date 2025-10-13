. "$env:DOTFILES\core\main.ps1"

function Set-Location-One-Time {
    Set-Location -Path ".."
}

function Set-Location-Two-Times {
    Set-Location -Path "..\.."
}

function Set-Location-Three-Times {
    Set-Location -Path "..\..\.."
}

function Start-IntelliJ {
    $filePath = (Resolve-Path -Path "C:\Program Files (x86)\JetBrains\IntelliJ IDEA *\bin\idea64.exe").Path
    Start-Process -FilePath $filePath -ArgumentList $args -NoNewWindow
}

function Get-DirectoryList {
    lsd -l --group-dirs=first $args
}

function Get-DirectoryListAll {
    lsd -a --group-dirs=first $args
}

function Get-DirectoryListDetailed {
    lsd -la --group-dirs=first $args
}

function Get-DirectoryTree {
    lsd --tree $args
}

function Head-Content {
    param(
        [int]$n,
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)] $args
    )

    $lines = if ($n -le 0) { 10 } else { $n }
    bat --line-range=":${lines}" $args
}

function Tail-Content {
    param(
        [int]$n,
        [Parameter(Position = 0, ValueFromRemainingArguments = $true)] $args
    )

    $lines = if ($n -le 0) { 10 } else { $n }
    bat --line-range="-${lines}:" $args
}

function Touch-Item {
    $args | ForEach-Object { New-Item -Name $_ -ItemType File | Out-Null }
}

function Upload-Item {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateScript({ Test-Path -Path $_ -PathType Leaf })]
        [string]$Path
    )

    $uploadResponse   = curl -s -w "%{http_code}" -F "file=@$Path" 0x0.st
    $responseSegments = $uploadResponse -split "`n"

    $statusCode = $responseSegments[-1]
    $uploadUrl  = $responseSegments[0]

    if ($statusCode -ne "200") {
        Output-Error -Message "Upload failed with status code $statusCode."
        return
    }

    $uploadUrl | Set-Clipboard
    Output-Success "URL copied to clipboard."
}

function Which-Command {
    Get-Command -Name $args -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Definition
}

function Grep-Process {
    Get-Process -Name ($args | ForEach-Object { "*$_*" })
}

function Kill-Process {
    Stop-Process -Name $args -ErrorAction SilentlyContinue
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

    $zipName     = "$( Split-Path -Path $Path -Leaf ).zip"
    $destination = Join-Path -Path $DestinationPath -ChildPath $zipName
    Compress-Archive -Path $Path -DestinationPath $destination -Force
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

function Start-Sudo {
    function ConvertTo-Base64([string]$Command) {
        [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($Command))
    }

    switch ($args[0]) {
        "su" {
            sudo.exe pwsh -NoLogo
        }
        "!!" {
            $encodedCommand = ConvertTo-Base64 -Command "$(Get-History -Count 1)"
            sudo.exe pwsh -EncodedCommand $encodedCommand
        }
        { $_ -is [scriptblock] } {
            $encodedCommand = ConvertTo-Base64 -Command $_
            sudo.exe pwsh -EncodedCommand $encodedCommand
        }
        { Get-Command -Name $_ -Type Application -ErrorAction Ignore } {
            sudo.exe $args
        }
        { Get-Command -Name $_ -Type Cmdlet, ExternalScript, Alias -ErrorAction Ignore } {
            $encodedCommand = ConvertTo-Base64 -Command "$args"
            sudo.exe pwsh -EncodedCommand $encodedCommand
        }
        default {
            Output-Error -Message "Cannot find '$_'"
        }
    }
}

function Clear-Bin {
    Clear-RecycleBin -Force
}

function Quit {
    exit
}

function Git-Remove {
    $stagedFiles = git diff --name-only --cached 2>$null
    if ($LASTEXITCODE -ne 0) {
        Output-Error -Message "Not inside a Git repository."
        return
    }

    if (-not $stagedFiles) {
        Write-Host "🔍 No staged changes found"
        return
    }

    $selectedFiles = $stagedFiles | Sort-Object -Unique | fzf --multi --preview="git diff HEAD --color=always -- {}"
    if ($selectedFiles) {
        git reset HEAD $selectedFiles | Out-Null
    }
}

function Git-Add {
    $unstagedFiles = git diff --name-only 2>$null && git ls-files --others --exclude-standard 2>$null
    if ($LASTEXITCODE -ne 0) {
        Output-Error -Message "Not inside a Git repository."
        return
    }

    if (-not $unstagedFiles) {
        Write-Host "🔍 No unstaged changes found"
        return
    }

    $selectedFiles = $unstagedFiles | Sort-Object -Unique | fzf --multi --preview="git diff HEAD --color=always -- {}"
    if ($selectedFiles) {
        git add $selectedFiles
    }
}

function Git-Add-All {
    git add -A $args
}

function Git-Commit {
    git commit -m "$args"
}

function Git-Commit-All {
    git add -A && git commit -m "$args"
}

function Git-Commit-Push {
    git commit -m "$args" && git push
}

function Git-Commit-All-Push {
    git add -A && git commit -m "$args" && git push
}

function Git-Discard {
    git add -A && git reset --hard | Out-Null
}

function Git-Undo {
    git reset HEAD~1 --mixed
}

function Git-Ignore {
    git ls-files --cached --ignored --exclude-standard |
        ForEach-Object { git rm --cached $_ }
}

function Git-Status {
    git status -sb $args
}

function Git-Fetch {
    git fetch --all -p $args
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
    $splitPath     = $args[0].Split("/", 3)
    $remainingArgs = $args[1..$args.Count]

    if ($splitPath.Count -lt 3) {
        git clone "https://github.com/$( $args[0] ).git" $remainingArgs
        return
    }

    git clone "https://github.com/$( $splitPath[0] )/$( $splitPath[1] ).git" --no-checkout $remainingArgs
    if ($LASTEXITCODE -ne 0) { return }

    Push-Location -Path $splitPath[1]
    git sparse-checkout set $splitPath[2]
    git checkout
    Pop-Location
}
