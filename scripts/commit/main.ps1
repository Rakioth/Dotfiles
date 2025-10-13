$ErrorActionPreference = "Stop"

. "$env:DOTFILES\core\main.ps1"

git rev-parse --is-inside-work-tree *>$null
if ($LASTEXITCODE -ne 0) {
    Output-Error -Message "Not inside a Git repository."
    exit 1
}

if (Get-Command -Name "diny" -ErrorAction SilentlyContinue) {
    $dinyConfig = @{
        useConventional = $true
        useEmoji        = $false
        tone            = "professional"
        length          = "normal"
    } | ConvertTo-Json

    $gitRoot        = git rev-parse --show-toplevel
    $dinyConfigPath = Join-Path -Path $gitRoot -ChildPath ".git/diny-config.json"

    if (-not (Test-Path -Path $dinyConfigPath)) {
        $dinyConfig | Out-File -FilePath $dinyConfigPath -Encoding utf8
    }
}

$stagedFiles = git diff --name-only --cached
if (-not $stagedFiles) {
    Write-Host "🔍 No changes to commit"
    exit 0
}

$emojiMap = @{
    build    = "🏗️"
    chore    = "🔧"
    ci       = "🚦"
    docs     = "📝"
    feat     = "✨"
    fix      = "🐛"
    perf     = "🧠"
    refactor = "🧩"
    revert   = "💥"
    style    = "💅"
    test     = "🧪"
}

function Get-CommitEmoji {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$CommitType
    )

    $normalizedType = $CommitType.ToLower()
    $matchedKey     = $emojiMap.Keys |
        Where-Object { $normalizedType -like "$_*" } |
        Select-Object -First 1

    if ($matchedKey) { $emojiMap[$matchedKey] } else { "❓" }
}

$generatedMessage       = ""
$generatedDescription   = ""
$previousOutputEncoding = [Console]::OutputEncoding

if (Get-Command -Name "diny" -ErrorAction SilentlyContinue) {
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    $commitLabel  = gum style --foreground $SecondaryColor commit
    $commitOutput = gum spin --spinner globe --title "Generating $commitLabel..." --show-output -- diny commit --print

    $generatedMessage = $commitOutput[1]

    if ($commitOutput.Count -gt 2) {
        $generatedDescription = ($commitOutput[2..($commitOutput.Count - 1)] -join "`n").Trim()
    }
} else {
    $commitOptions = $emojiMap.Keys | Sort-Object -Unique
    $commitLabel   = gum style --foreground $PrimaryColor commit
    $commitType    = Gum-Filter -Header "🔖 Select the $commitLabel type: " -Options $commitOptions -Limit 1

    if (-not $commitType) {
        exit 1
    }

    $commitScope = gum input --no-show-help `
        --prompt.foreground $PrimaryColor `
        --cursor.foreground "" `
        --prompt "$PromptSymbol " `
        --placeholder "scope"

    $generatedMessage = if ($commitScope) {
        "$commitType($commitScope): "
    } else {
        "${commitType}: "
    }
}

$commitMessage = gum input --no-show-help `
    --prompt.foreground $PrimaryColor `
    --cursor.foreground "" `
    --prompt "$PromptSymbol " `
    --placeholder "Summary of this change" `
    --value="$generatedMessage"

if (-not $commitMessage) {
    exit 1
}

$messageParts  = $commitMessage.Split(":", 2)
$commitType    = $messageParts[0]
$commitContent = if ($messageParts.Count -gt 1) { $messageParts[1] } else { "" }

$scope  = gum style --foreground $SecondaryColor "${commitType}:"
$emoji  = Get-CommitEmoji -CommitType $commitType
$header = "$emoji $scope$commitContent"

$commitDescription = gum write --no-show-help --show-line-numbers `
    --header "$header`n" `
    --prompt.foreground $PrimaryColor `
    --cursor-line-number.foreground $SecondaryColor `
    --line-number.foreground "240" `
    --cursor.foreground "" `
    --placeholder "Details of this change" `
    --value="$generatedDescription" | Out-String

Write-Host
[Console]::OutputEncoding = $previousOutputEncoding

gum confirm --no-show-help --prompt.italic `
    --selected.background $PrimaryColor `
    --prompt.foreground "" `
    "Commit changes?"

if ($LASTEXITCODE -ne 0) {
    exit 1
}

git commit -m "$commitMessage" -m "$commitDescription"

if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

gum confirm --no-show-help --prompt.italic `
    --selected.background $PrimaryColor `
    --prompt.foreground "" `
    "`nPush changes?"

if ($LASTEXITCODE -eq 0) {
    git push
    exit $LASTEXITCODE
}
