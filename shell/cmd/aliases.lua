local function alias(name, value)
    local command = value or ('pwsh -c "' .. name .. '" $*')
    os.execute("doskey " .. name .. "=" .. command)
end

alias("dot")

alias("id")
alias("co",  "code $*")
alias("vim", "nvim $*")
alias("n",   "notepad $*")
alias("e",   "explorer $*")

alias("ls",  "lsd $*")
alias("ll",  "lsd -l --group-dirs=first $*")
alias("la",  "lsd -a --group-dirs=first $*")
alias("lla", "lsd -la --group-dirs=first $*")
alias("lt",  "lsd --tree $*")

alias("cat", "bat $*")
alias("head")
alias("tail")

alias("touch")
alias("ix")
alias("which", "where $*")

alias("rm")
alias("cp")
alias("mv")
alias("pwd", "cd")

alias("ps",    "tasklist $*")
alias("pgrep", 'tasklist $b find /I "$*"')
alias("pkill", "taskkill /T /F /IM $*")

alias("zip")
alias("unzip")

alias("sudo", 'if "$1"=="su" (sudo.exe cmd /k) else (sudo.exe $*)')
alias("bin")
alias("c",    "cls")
alias("q",    "exit")

alias("gr")
alias("ga")
alias("gaa",  "git add -A $*")
alias("gc",   'git commit -m "$*"')
alias("gca",  'git add -A $t git commit -m "$*"')
alias("gcp",  'git commit -m "$*" $t git push')
alias("gcap", 'git add -A $t git commit -m "$*" $t git push')
alias("gs",   "git status -sb $*")
alias("gf",   "git fetch --all -p $*")
alias("gps",  "git push $*")
alias("gpl",  "git pull --autostash $*")
alias("glg",  'git log --graph --abbrev-commit --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"')
alias("gcl")
