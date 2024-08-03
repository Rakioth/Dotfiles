settings.add('zoxide.cmd', 'z', 'Changes the prefix of the aliases')
settings.add('zoxide.hook', { 'pwd', 'prompt', 'none' }, 'Changes when directory scores are incremented')
settings.add('zoxide.no_aliases', false, "Don't define aliases")
settings.add('zoxide.usepromptfilter', false, "Use clink promptfilter to hook even if onbeginedit is supported")
settings.add('zoxide.promptfilter_prio', -50, "Changes the priority of the promptfilter hook (only if usepromptfilter is true)")

local function __zoxide_cd(dir)
    if os.getenv '_ZO_ECHO' == '1' then
        print(dir)
    end

    if dir == '-' and (clink.version_encoded or 0) < 10020042 then
        return 'cd -'
    end

    return 'cd /d ' .. dir
end

local function __zoxide_query(options, keywords)
    options = table.concat(options, ' ')
    keywords = table.concat(keywords, ' ')

    local file = io.popen('zoxide query ' .. options .. ' -- ' .. keywords)
    local result = file:read '*line'
    local ok = file:close()

    if ok then
        return __zoxide_cd(result)
    else
        return 'call'
    end
end

local function __zoxide_add(dir)
    os.execute('zoxide add -- "' .. dir:gsub('^(.-)\\*$', '%1') .. '"')
end

local __usepromptfilter = settings.get 'zoxide.usepromptfilter'

if not clink.onbeginedit then
    __usepromptfilter = true
end

local __zoxide_oldpwd
function __zoxide_hook()
    local zoxide_hook = settings.get 'zoxide.hook'

    if zoxide_hook == 'none' then
        return
    elseif zoxide_hook == 'prompt' then
        __zoxide_add(os.getcwd())
    elseif zoxide_hook == 'pwd' then
        local cwd = os.getcwd()
        if __zoxide_oldpwd and __zoxide_oldpwd ~= cwd then
            __zoxide_add(cwd)
        end
        __zoxide_oldpwd = cwd
    end
end

if __usepromptfilter then
    local __promptfilter_prio = settings.get 'zoxide.promptfilter_prio'
    local __zoxide_prompt = clink.promptfilter(__promptfilter_prio)

    function __zoxide_prompt:filter()
        __zoxide_hook()
    end
else
    clink.onbeginedit(__zoxide_hook)
end

local function __zoxide_z(keywords)
    if #keywords == 0 then
        return __zoxide_cd(os.getenv('HOME'))
    elseif #keywords == 1 then
        local keyword = keywords[1]
        if keyword == '-' then
            return __zoxide_cd '-'
        elseif os.isdir(keyword) then
            return __zoxide_cd(keyword)
        end
    end

    local cwd = '"' .. os.getcwd() .. '"'
    return __zoxide_query({ '--exclude', cwd }, keywords)
end

local function __zoxide_zi(keywords)
    return __zoxide_query({ '--interactive' }, keywords)
end

local function onfilterinput(text)
    args = string.explode(text, ' ', '"')
    if #args == 0 then
        return
    end

    zoxide_cmd = settings.get 'zoxide.cmd'
    zoxide_no_aliases = settings.get 'zoxide.no_aliases'

    local cd_regex = '^%s*cd%s+/d%s+"(.-)"%s*$'
    if zoxide_cmd == 'cd' and text:match(cd_regex) then
        if zoxide_no_aliases then
            return
        else
            return __zoxide_cd(text:gsub(cd_regex, '%1')), false
        end
    end

    local cmd = table.remove(args, 1)
    if cmd == '__zoxide_z' or (cmd == zoxide_cmd and not zoxide_no_aliases) then
        return __zoxide_z(args), false
    elseif cmd == '__zoxide_zi' or (cmd == zoxide_cmd .. 'i' and not zoxide_no_aliases) then
        return __zoxide_zi(args), false
    else
        return
    end
end

if clink.onfilterinput then
    clink.onfilterinput(onfilterinput)
else
    clink.onendedit(onfilterinput)
end
