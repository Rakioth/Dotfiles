local output_contexts = io.popen('pwsh -c "Dot-ListContexts"'):read("*a")
local list_contexts = {}

for context in output_contexts:gmatch("%S+") do
    table.insert(list_contexts, context)
end

local function list_scripts(word, word_index, line_state)
    local line = line_state:getline()
    local words = {}

    for w in line:gmatch("%S+") do
        table.insert(words, w)
    end

    local output_scripts = io.popen('pwsh -c "Dot-ListContextScripts" ' .. words[2]):read("*a")
    local list_scripts = {}

    for script in output_scripts:gmatch("%S+") do
        table.insert(list_scripts, script)
    end

    return list_scripts
end

clink.argmatcher("dot")
:addarg(list_contexts)
:addarg(list_scripts)
:nofiles()
