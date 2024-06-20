source ${DOTFILES}/shell/zsh/functions.sh

# 🧭 Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# 🚀 Editors
alias co="code"
alias id="/mnt/c/Program\ Files\ \(x86\)/JetBrains/IntelliJ\ IDEA\ 2024.1.3/bin/idea64.exe"
alias vim="nvim"

# 📜 Listings
alias ls="lsd"
alias ll="lsd -l --group-dirs=first"
alias la="lsd -la --group-dirs=first"
alias lt="lsd --tree"

# 🔎 Text Utils
alias cat="bat"
alias ix="upload_item"

# ⚙️ System
alias c="clear"
alias q="exit"

# 🌱 Git
alias gaa="git add -A"
alias gca="git_commit_all"
alias gs="git status -sb"
alias gf="git fetch --all"
alias gph="git push"
alias gpl="git pull --autostash"
alias glg="git log --graph --abbrev-commit --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias gcl="git_clone"
