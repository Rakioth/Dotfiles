vim.api.nvim_create_autocmd("FileType", {
  callback = function(args)
    if vim.bo[args.buf].buflisted then
      local recent_folders = vim.g.RECENT_PROJECTS or {}

      local pwd = vim.fs.normalize(vim.uv.cwd())
      local home = vim.fs.normalize(os.getenv "HOME" or os.getenv "USERPROFILE")

      if not (home ~= pwd and not vim.tbl_contains(recent_folders, pwd)) then
        return
      end

      if #recent_folders == 5 then
        table.remove(recent_folders, 1)
      end

      table.insert(recent_folders, pwd)
      vim.g.RECENT_PROJECTS = recent_folders
    end
  end,
})

local home = vim.fs.normalize(os.getenv "HOME" or os.getenv "USERPROFILE")

local replace_home_path = function(path)
  if path:find(home) then
    return "~" .. string.gsub(path, "^" .. home, "")
  end
  return path
end

local letters = {}
for i = string.byte "a", string.byte "z" do
  local letter = string.char(i)
  if not vim.tbl_contains({ "j", "k", "h", "l", "f" }, letter) then
    table.insert(letters, letter)
  end
end

local function set_recent_files(tb)
  local files = {}

  for _, v in ipairs(vim.v.oldfiles) do
    if #files == 5 then
      break
    end
    local stat = vim.uv.fs_stat(v)
    if stat and stat.type == "file" then
      table.insert(files, vim.fs.normalize(v))
    end
  end

  for i, v in ipairs(files) do
    local devicon, devicon_hl = require("nvim-web-devicons").get_icon(v)
    local icon = devicon or ""
    local path = replace_home_path(v):sub(1, 100)
    local keybind = letters[i]

    local line = {
      multicolumn = true,
      no_gap = true,
      content = "fit",
      group = "recent_files",
      cmd = "e " .. v,
      keys = keybind,
    }

    table.insert(line, { txt = icon .. "  ", hl = devicon_hl })
    table.insert(line, { txt = path })
    table.insert(line, { txt = string.rep(" ", 3), pad = "full" })
    table.insert(line, { txt = keybind, hl = "comment" })

    table.insert(tb, line)
  end
end

local function set_recent_folders(tb)
  local dirs = vim.g.RECENT_PROJECTS or {}
  dirs = vim.list_slice(dirs, 0, 5)

  for i, v in ipairs(dirs) do
    local path = replace_home_path(v):sub(1, 100)
    local keybind = letters[i + 5]

    local line = {
      keys = keybind,
      multicolumn = true,
      no_gap = true,
      content = "fit",
      group = "recent_files",
      cmd = "cd " .. v .. " | NvimTreeFocus",
    }

    table.insert(line, { txt = "  ", hl = "LazyReasonSource" })
    table.insert(line, { txt = path })
    table.insert(line, { txt = string.rep(" ", 3), pad = "full" })
    table.insert(line, { txt = keybind, hl = "comment" })

    table.insert(tb, line)
  end
end

return function()
  local layout = {

    {
      multicolumn = true,
      pad = 3,
      content = "fit",
      { txt = "  Update [u]", hl = "DevIcondeb", keys = "u", cmd = "Lazy sync" },
      { txt = "  Files [f]", hl = "LazyReasonRuntime", keys = "f", cmd = "Telescope find_files" },
      { txt = "󰈬  Word [w]", hl = "LazyCommit", keys = "w", cmd = "Telescope live_grep" },
    },

    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "comment",
      content = "fit",
    },

    {
      txt = "  Most Recent files",
      hl = "Debug",
      no_gap = true,
      group = "recent_files",
    },

    { txt = "─", hl = "comment", no_gap = true, rep = true, group = "recent_files", content = "fit" },
  }

  set_recent_files(layout)
  table.insert(layout, { txt = "", no_gap = true })

  table.insert(layout, {
    txt = "  Recent Projects",
    hl = "Debug",
    no_gap = true,
    group = "recent_files",
  })

  table.insert(
    layout,
    { txt = "─", hl = "comment", no_gap = true, rep = true, group = "recent_files", content = "fit" }
  )

  set_recent_folders(layout)

  return layout
end
