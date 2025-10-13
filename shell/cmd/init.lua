local shell = os.getenv "DOTFILES" .. "\\shell\\cmd\\"

dofile(shell .. "aliases.lua")
dofile(shell .. "exports.lua")

local modules = io.popen("dir " .. shell .. "modules\\*.lua /b")
for module in modules:lines() do
    dofile(shell .. "modules\\" .. module)
end

local completions = io.popen("dir " .. shell .. "completions\\*.lua /b")
for completion in completions:lines() do
    dofile(shell .. "completions\\" .. completion)
end
