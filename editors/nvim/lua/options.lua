require "nvchad.options"

local opt = vim.opt
local g = vim.g

-------------------------------------- globals -----------------------------------------
g.shada = ""

-------------------------------------- options ------------------------------------------
opt.swapfile = false
opt.relativenumber = true
opt.guicursor = ""
opt.wrap = false
opt.hlsearch = false
opt.incsearch = true
opt.scrolloff = 8
opt.isfname:append "@-@"
