local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

    {
        "zbirenbaum/copilot.lua",
        lazy = false,
        opts = function()
            return require "custom.configs.copilot"
        end,
        config = function(_, opts)
            require("copilot").setup(opts)
        end,
    },

    {
        "anuvyklack/pretty-fold.nvim",
        lazy = false,
        config = function()
            require("pretty-fold").setup()
        end,
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        event = "VeryLazy",
        lazy = false,
        dependencies = "nvim-lua/plenary.nvim",
        init = function()
            require("core.utils").load_mappings "harpoon"
        end,
        config = function()
            require("harpoon"):setup()
        end,
    },

    {
        "mfussenegger/nvim-dap",
        init = function()
            require("core.utils").load_mappings "dap"
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "jose-elias-alvarez/null-ls.nvim",
            config = function()
                require "custom.configs.null-ls"
            end,
        },
        config = function()
            require "plugins.configs.lspconfig"
            require "custom.configs.lspconfig"
        end,
    },

    {
        "williamboman/mason.nvim",
        opts = overrides.mason,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        opts = overrides.treesitter,
    },

    {
        "nvim-tree/nvim-tree.lua",
        opts = overrides.nvimtree,
    },

    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup()
        end,
    },

    {
        "NvChad/nvim-colorizer.lua",
        opts = overrides.colorizer,
    },

    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        config = function()
            require("trouble").setup()
        end,
    },

    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        init = function()
            require("core.utils").load_mappings "undotree"
        end,
    },

}

return plugins
