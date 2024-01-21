---@type MappingsTable
local M = {}

M.general = {
    i = {
        ["jk"] = { "<ESC>", "Exit insert mode" },
    },

    n = {
        ["<leader>x"] = { ":close<CR>", "Close window" },

        ["<leader>sv"] = { "<C-w>v", "Split window vertically" },
        ["<leader>sh"] = { "<C-w>s", "Split window horizontally" },
        ["<leader>se"] = { "<C-w>=", "Make splits equal size" },

        ["J"] = { "mzJ`z", "Join with line below" },
        ["<C-d>"] = { "<C-d>zz", "Scroll down with line middle" },
        ["<C-u>"] = { "<C-u>zz", "Scroll up with line middle" },
        ["n"] = { "nzzzv", "Next occurrence with text centered" },
        ["N"] = { "Nzzzv", "Previous occurrence with text centered" },

        ["<leader>y"] = { [["+y]], "Yank selected text into the system clipboard" },
        ["<leader>Y"] = { [["+Y]], "Yank selected line into the system clipboard" },

        ["<leader>d"] = { [["_d]], "Delete selected text" },
        ["<leader>s"] = { [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], "Case-insensitive search and replace operation" },
    },

    v = {
        ["J"] = { ":m '>+1<CR>gv=gv", "Move selected lines down one line" },
        ["K"] = { ":m '<-2<CR>gv=gv", "Move selected lines up two lines" },

        ["<leader>y"] = { [["+y]], "Yank selected text into the system clipboard" },

        ["<leader>d"] = { [["_d]], "Delete selected text" },
    },

    x = {
        ["<leader>p"] = { [["_dP]], "Delete selected text, yank into system clipboard" },
    },
}

M.dap = {
    plugin = true,

    n = {
        ["<leader>db"] = { "<cmd> DapToggleBreakpoint <CR>", "Toggle breakpoint" },
        ["<leader>dus"] = {
            function()
                local widgets = require "dap.ui.widgets"
                local sidebar = widgets.sidebar(widgets.scopes)
                sidebar.open()
            end,
            "Open debugging sidebar"
        },
    },
}

M.harpoon = {
    n = {
        ["<leader>a"] = {
            function()
                local harpoon = require "harpoon"
                harpoon:list():append()
            end,
            "Harpoon add file"
        },
        ["<C-e>"] = {
            function()
                local harpoon = require "harpoon"
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            "Harpoon menu"
        },
        ["<C-u>"] = {
            function()
                local harpoon = require "harpoon"
                harpoon:list():select(1)
            end,
            "Harpoon go to file 1"
        },
        ["<C-i>"] = {
            function()
                local harpoon = require "harpoon"
                harpoon:list():select(2)
            end,
            "Harpoon go to file 2"
        },
        ["<C-o>"] = {
            function()
                local harpoon = require "harpoon"
                harpoon:list():select(3)
            end,
            "Harpoon go to file 3"
        },
        ["<C-p>"] = {
            function()
                local harpoon = require "harpoon"
                harpoon:list():select(4)
            end,
            "Harpoon go to file 4"
        },
    },
}

M.undotree = {
    n = {
        ["<leader>u"] = { "<cmd> UndotreeToggle <CR>", "Undotree menu" },
    },
}

return M
