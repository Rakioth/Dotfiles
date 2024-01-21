#!/usr/bin/env zsh

# ZSH Options
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY_TIME
setopt EXTENDED_HISTORY
setopt HIST_FCNTL_LOCK
setopt HIST_NO_STORE
setopt +o nomatch

# ZSH Config
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_HIGHLIGHT_MAXLENGTH=300

# Initialize Modules
source ${ZIM_HOME}/init.zsh

# Aliases
source ${DOTFILES}/shell/zsh/aliases.sh

# Fzf
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
bindkey -r '^T'
bindkey -r '^R'
bindkey '^R' fzf-file-widget
bindkey '^H' fzf-history-widget

# Prompt
eval "$(starship init zsh)"

# Zoxide
eval "$(zoxide init zsh)"
