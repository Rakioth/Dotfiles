. "$env:DOTFILES\shell\pwsh\Scripts\functions.ps1"

# 🧭 Navigation
Set-Alias -Name ..   -Value Set-Location-One-Time
Set-Alias -Name ...  -Value Set-Location-Two-Times
Set-Alias -Name .... -Value Set-Location-Three-Times

# 🚀 Editors
Set-Alias -Name co  -Value Start-Code
Set-Alias -Name id  -Value Start-IntelliJ
Set-Alias -Name vim -Value nvim
Set-Alias -Name n   -Value notepad
Set-Alias -Name e   -Value explorer

# 📜 Listings
Set-Alias -Name ls -Value lsd
Set-Alias -Name ll -Value List-Items
Set-Alias -Name la -Value List-Hidden-Items
Set-Alias -Name lt -Value List-Tree

# 🔎 Text Utils
Set-Alias -Name cat  -Value bat
Set-Alias -Name less -Value Less-Content
Set-Alias -Name head -Value Head-Content
Set-Alias -Name tail -Value Tail-Content

# 📁 File Utils
Set-Alias -Name touch -Value Touch-Item
Set-Alias -Name ix    -Value Upload-Item
Set-Alias -Name which -Value Which-Command

# 🏗️ Processes
Set-Alias -Name ps    -Value Get-Process
Set-Alias -Name pgrep -Value Grep-Process
Set-Alias -Name pkill -Value Kill-Process

# 💾 Compression
Set-Alias -Name zip   -Value Compress-Zip
Set-Alias -Name unzip -Value Expand-Zip

# ⚙️ System
Set-Alias -Name sudo -Value Start-Admin
Set-Alias -Name bin  -Value Clear-Bin
Set-Alias -Name c    -Value clear
Set-Alias -Name q    -Value Quit

# 🌱 Git
Set-Alias -Name ga  -Value Git-Fuzzy-Add
Set-Alias -Name gr  -Value Git-Fuzzy-Remove
Set-Alias -Name gaa -Value Git-Add-All
Set-Alias -Name gca -Value Git-Commit-All
Set-Alias -Name gcp -Value Git-Commit-Push
Set-Alias -Name gs  -Value Git-Status
Set-Alias -Name gf  -Value Git-Fetch
Set-Alias -Name gph -Value Git-Push
Set-Alias -Name gpl -Value Git-Pull
Set-Alias -Name glg -Value Git-Log
Set-Alias -Name gcl -Value Git-Clone
