local opt = vim.opt
local global = vim.o

opt.swapfile = false
opt.relativenumber = true
opt.guicursor = ""
opt.wrap = false
opt.hlsearch = false
opt.incsearch = true
opt.scrolloff = 8
opt.isfname:append("@-@")

global.shada = ""

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local raks_group = augroup("raks", {})

autocmd("VimEnter", {
    group = raks_group,
    pattern = "*",
    callback = function()
        vim.fn.execute("cd %:p:h")
    end,
})
