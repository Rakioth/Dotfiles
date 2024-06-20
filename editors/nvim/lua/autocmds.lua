require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

-- change the working directory to the directory of the file
autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("ChangeDirectory", {}),
  pattern = "*",
  callback = function()
    vim.fn.execute "cd %:p:h"
  end,
})
