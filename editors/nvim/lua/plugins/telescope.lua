-- TODO: remove this file once this issue is fixed: https://github.com/nvim-telescope/telescope.nvim/issues/2446
return {
  "nvim-telescope/telescope.nvim",
  config = function(_, opts)
    local telescope = require "telescope"
    local actions = require "telescope.actions"

    if vim.fn.has "win32" == 0 then
      return telescope.setup(opts)
    end

    local function setup_windows_escaping()
      local original_fnameescape = vim.fn.fnameescape

      local function windows_fnameescape(path)
        local escaped_path = original_fnameescape(path)
        local needs_extra_escape = path:find "[%[%]`%$~]"
        local escape_char = needs_extra_escape and "\\\\" or "\\"

        escaped_path = escaped_path:gsub("\\[%(%)%^&;]", escape_char .. "%1")

        if needs_extra_escape then
          escaped_path = escaped_path:gsub("\\\\['` ]", "\\%1")
        end

        return escaped_path
      end

      local function select_default_with_escaping(prompt_bufnr)
        vim.fn.fnameescape = windows_fnameescape
        local result = actions.select_default(prompt_bufnr, "default")
        vim.fn.fnameescape = original_fnameescape
        return result
      end

      return select_default_with_escaping
    end

    local select_default = setup_windows_escaping()

    opts.defaults = opts.defaults or {}
    opts.defaults.mappings = opts.defaults.mappings or {}
    opts.defaults.mappings.i = opts.defaults.mappings.i or {}
    opts.defaults.mappings.n = opts.defaults.mappings.n or {}

    opts.defaults.mappings.i["<CR>"] = select_default
    opts.defaults.mappings.n["<CR>"] = select_default

    telescope.setup(opts)
  end,
}
