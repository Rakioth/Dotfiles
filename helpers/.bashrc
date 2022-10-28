#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# Load Prompt Config
eval "$(oh-my-posh init bash --config /mnt/c/Users/Raks/Documents/PowerShell/raks.omp.json)"

# Alias
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
alias g='git'
alias v='nvim'
alias raks='cd /mnt/c/Users/Raks'
alias idea='cd /mnt/d/IdeaProjects'
alias cat='bat --style=plain'
alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'