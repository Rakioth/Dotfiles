#!/usr/bin/env zsh

# Initialize Modules
source ${HOME}/.zim/init.zsh

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

# ZSH Highlights
ZSH_HIGHLIGHT_STYLES[alias]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[function]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[command]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=yellow,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=yellow,italic'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=8'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=8'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=8'
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=cyan'

# Fzf
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh
bindkey -r '^T'
bindkey -r '^R'
bindkey '^R' fzf-file-widget
bindkey '^H' fzf-history-widget

# Aliases
source ${DOTFILES}/shell/zsh/aliases.sh

# Exports
source ${DOTFILES}/shell/zsh/exports.sh

# Yay Extensions
source ${DOTFILES}/package/main.sh

# Dot Command
source ${DOTFILES}/bin/dot.sh

# Prompt
eval "$(starship init zsh)"

# Zoxide
eval "$(zoxide init zsh)"
