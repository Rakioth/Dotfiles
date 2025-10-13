os.setenv("FZF_CTRL_T_COMMAND", "fd --type file --follow --hidden --exclude .git")
os.setenv("FZF_DEFAULT_OPTS",   '--prompt="◉ " --pointer="❯ " --marker="• " --exact --no-sort --bind=ctrl-z:ignore --cycle --keep-right --height=45% --info=inline-right --layout=reverse --tabstop=1 --exit-0 --preview-window=border-rounded --color=fg:#c698f2,bg:-1,hl:#ce3ed6,fg+:white,bg+:-1,hl+:bright-cyan,info:yellow,prompt:yellow,pointer:#ce3ed6,marker:yellow,spinner:yellow,header:yellow')

os.setenv("_ZO_FZF_OPTS", os.getenv "FZF_DEFAULT_OPTS")
