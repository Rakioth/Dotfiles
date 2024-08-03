-- 💫 Starship
os.setenv("STARSHIP_CONFIG", os.getenv("DOTFILES") .. "/config/starship/starship.toml")

-- 🧠 Fzf
os.setenv('FZF_CTRL_T_COMMAND', "fd --type file --follow --hidden --exclude .git")
os.setenv('FZF_DEFAULT_OPTS',   "--color=fg:#c698f2,bg:-1,hl:#ce3ed6,fg+:#d5ced9,bg+:-1,hl+:#29b8db,info:#82d173,prompt:#82d173,pointer:#ce3ed6,marker:#82d173,spinner:#82d173,header:#82d173 --prompt='❯ ' --pointer='❯' --marker='❯' --exact --no-sort --bind=ctrl-z:ignore --cycle --keep-right --height=45% --info=inline-right --layout=reverse --tabstop=1 --exit-0 --select-1")
os.setenv('_ZO_FZF_OPTS',       os.getenv("FZF_DEFAULT_OPTS"))
