#!/usr/bin/env zsh

source "$DOTFILES/shell/zsh/aliases.sh"
source "$DOTFILES/shell/zsh/exports.sh"

if [[ ! -e "$ZIM_HOME/zimfw.zsh" ]]; then
	curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

if [[ ! "$ZIM_HOME/init.zsh" -nt "$HOME/.zimrc" ]]; then
	source "$ZIM_HOME/zimfw.zsh" init
fi

fpath=("$DOTFILES/shell/zsh/completions" $fpath)
source "$ZIM_HOME/init.zsh"

for script in "$DOTFILES/bin"/*.sh; do
	alias "$(basename "$script" .sh)"="$script"
done

zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd -1 --color=always $realpath'
zstyle ':fzf-tab:complete:z:*' fzf-preview 'lsd -1 --color=always $realpath'

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

bindkey -e
bindkey -r '^T'
bindkey -r '^R'
bindkey '^R' fzf-file-widget
bindkey '^H' fzf-history-widget

setopt appendhistory
setopt complete_aliases
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_save_no_dups
setopt sharehistory

ZSH_HIGHLIGHT_STYLES[arg0]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[bracket-error]='fg=red'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=white'
ZSH_HIGHLIGHT_STYLES[comment]='fg=green'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan,underline'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=yellow,underline'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=white'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=green'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=yellow,underline'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red'
