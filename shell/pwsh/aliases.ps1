. "$env:DOTFILES\shell\pwsh\functions.ps1"

Set-Alias -Name ..   -Value Set-Location-One-Time
Set-Alias -Name ...  -Value Set-Location-Two-Times
Set-Alias -Name .... -Value Set-Location-Three-Times

Set-Alias -Name id  -Value Start-IntelliJ
Set-Alias -Name co  -Value code
Set-Alias -Name vim -Value nvim
Set-Alias -Name n   -Value notepad
Set-Alias -Name e   -Value explorer

Set-Alias -Name ls  -Value lsd
Set-Alias -Name ll  -Value Get-DirectoryList
Set-Alias -Name la  -Value Get-DirectoryListAll
Set-Alias -Name lla -Value Get-DirectoryListDetailed
Set-Alias -Name lt  -Value Get-DirectoryTree

Set-Alias -Name cat  -Value bat
Set-Alias -Name head -Value Head-Content
Set-Alias -Name tail -Value Tail-Content

Set-Alias -Name touch -Value Touch-Item
Set-Alias -Name ix    -Value Upload-Item
Set-Alias -Name which -Value Which-Command

Set-Alias -Name ps    -Value Get-Process
Set-Alias -Name pgrep -Value Grep-Process
Set-Alias -Name pkill -Value Kill-Process

Set-Alias -Name zip   -Value Compress-Zip
Set-Alias -Name unzip -Value Expand-Zip

Set-Alias -Name sudo -Value Start-Sudo
Set-Alias -Name bin  -Value Clear-Bin
Set-Alias -Name c    -Value Clear-Host
Set-Alias -Name q    -Value Quit

Set-Alias -Name gr   -Value Git-Remove
Set-Alias -Name ga   -Value Git-Add
Set-Alias -Name gaa  -Value Git-Add-All
Set-Alias -Name gc   -Value Git-Commit -Force
Set-Alias -Name gca  -Value Git-Commit-All
Set-Alias -Name gcp  -Value Git-Commit-Push
Set-Alias -Name gcap -Value Git-Commit-All-Push
Set-Alias -Name gd   -Value Git-Discard
Set-Alias -Name gu   -Value Git-Undo -Force
Set-Alias -Name gi   -Value Git-Ignore -Force
Set-Alias -Name gs   -Value Git-Status
Set-Alias -Name gf   -Value Git-Fetch
Set-Alias -Name gps  -Value Git-Push -Force
Set-Alias -Name gpl  -Value Git-Pull
Set-Alias -Name glg  -Value Git-Log
Set-Alias -Name gcl  -Value Git-Clone
