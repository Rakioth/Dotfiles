local function alias(name, value)
    os.execute("doskey " .. name .. "=" .. value)
end

-- 🚀 Editors
alias("co",  "code $*")
alias("id",  '"C:\\Program Files (x86)\\JetBrains\\IntelliJ IDEA 2024.1.3\\bin\\idea64.exe" $*')
alias("vim", "nvim $*")
alias("n",   "notepad $*")
alias("e",   "explorer $*")

-- 📜 Listings
alias("ls", "lsd $*")
alias("ll", "lsd -l --group-dirs=first $*")
alias("la", "lsd -la --group-dirs=first $*")
alias("lt", "lsd --tree $*")

-- 🔎 Text Utils
alias("cat", "bat $*")

-- 📁 File Utils
alias("rmdir", "rmdir /S /Q $*")
alias("rm",    "del $*")
alias("cp",    "xcopy $*")
alias("mv",    "move $*")
alias("touch", "copy /B NUL $* $g NUL")
alias("ix",    'curl -sF "file=@$*" 0x0.st $b clip')
alias("which", "where $*")

-- 🏗️ Processes
alias("ps",    "tasklist $*")
alias("pgrep", 'tasklist $b find /I "$*"')
alias("pkill", "taskkill /T /F /IM $*")

-- 💾 Compression
alias("zip",   "tar -cavf $1.zip $2")
alias("unzip", "tar -xzvf $*")

-- ⚙️ System
alias("c", "cls")
alias("q", "exit")

-- 🌱 Git
alias("gaa", "git add -A $*")
alias("gca", 'git add -A $t git commit -m "$*"')
alias("gcp", 'git commit -m "$*" $t git push')
alias("gs",  "git status -sb $*")
alias("gf",  "git fetch --all $*")
alias("gph", "git push $*")
alias("gpl", "git pull --autostash $*")
alias("glg", 'git log --graph --abbrev-commit --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"')
alias("gcl", "git clone https://github.com/$*.git --depth 1")
