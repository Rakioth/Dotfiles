#!/usr/bin/env bash

source "$DOTFILES/core/main.sh"

export ZIM_HOME="$HOME/.zim"

export FZF_CTRL_T_COMMAND="fd --type file --follow --hidden --exclude .git"
export FZF_DEFAULT_OPTS="--prompt='◉ ' --pointer='$PROMPT_SYMBOL ' --marker='• ' --exact --no-sort --bind=ctrl-z:ignore --cycle --keep-right --height=45% --info=inline-right --layout=reverse --tabstop=1 --exit-0 --preview-window=border-rounded --color=fg:$SECONDARY_COLOR,bg:-1,hl:$PRIMARY_COLOR,fg+:white,bg+:-1,hl+:bright-cyan,info:yellow,prompt:yellow,pointer:$PRIMARY_COLOR,marker:yellow,spinner:yellow,header:yellow"

export _ZO_FZF_OPTS=$FZF_DEFAULT_OPTS
