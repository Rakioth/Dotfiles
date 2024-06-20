return {
  {
    "mfussenegger/nvim-dap",
  },
  {
    "anuvyklack/pretty-fold.nvim",
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  {
    "zbirenbaum/copilot.lua",
    opts = require "configs.copilot",
  },
  {
    "williamboman/mason.nvim",
    opts = require "configs.mason",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = require "configs.treesitter",
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = require "configs.nvimtree",
  },
  {
    "NvChad/nvim-colorizer.lua",
    opts = require "configs.colorizer",
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    event = "VeryLazy",
    dependencies = "nvim-lua/plenary.nvim",
    config = function()
      require("harpoon"):setup()
    end,
  },
}
