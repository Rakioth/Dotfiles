. "$env:DOTFILES\core\main.ps1"

$env:POWERSHELL_UPDATECHECK      = "Off"
$env:POWERSHELL_TELEMETRY_OPTOUT = "1"

$env:FZF_CTRL_T_COMMAND = "fd --type file --follow --hidden --exclude .git"
$env:FZF_DEFAULT_OPTS   = "--prompt='◉ ' --pointer='$PromptSymbol ' --marker='• ' --exact --no-sort --bind=ctrl-z:ignore --cycle --keep-right --height=45% --info=inline-right --layout=reverse --tabstop=1 --exit-0 --preview-window=border-rounded --color=fg:$SecondaryColor,bg:-1,hl:$PrimaryColor,fg+:white,bg+:-1,hl+:bright-cyan,info:yellow,prompt:yellow,pointer:$PrimaryColor,marker:yellow,spinner:yellow,header:yellow"

$env:_ZO_FZF_OPTS            = $env:FZF_DEFAULT_OPTS
$env:_PSFZF_FZF_DEFAULT_OPTS = "$env:FZF_DEFAULT_OPTS --preview-window=hidden"
