#!/usr/bin/env bash

source "$DOTFILES/shell/zsh/functions.sh"

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias id="start_intellij"
alias co="code"
alias vim="nvim"
alias n="notepad.exe"
alias e="explorer.exe"

alias ls="lsd"
alias ll="lsd -l --group-dirs=first"
alias la="lsd -a --group-dirs=first"
alias lla="lsd -la --group-dirs=first"
alias lt="lsd --tree"

alias cat="bat"
alias ix="upload_item"

alias sudo="start_sudo "
alias c="clear"
alias q="exit"

alias gr="git_remove"
alias ga="git_add"
alias gaa="git add -A"
alias gc="git_commit"
alias gca="git_commit_all"
alias gcp="git_commit_push"
alias gcap="git_commit_all_push"
alias gd="git add -A && git reset --hard &>/dev/null"
alias gu="git reset HEAD~1 --mixed"
alias gi="git ls-files --cached --ignored --exclude-standard | xargs git rm --cached"
alias gs="git status -sb"
alias gf="git fetch --all -p"
alias gps="git push"
alias gpl="git pull --autostash"
alias glg="git log --graph --abbrev-commit --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias gcl="git_clone"
