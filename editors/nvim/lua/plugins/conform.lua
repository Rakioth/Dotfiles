return {
  "stevearc/conform.nvim",
  dependencies = { "mason-org/mason.nvim" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>fm",
      function()
        require("conform").format { lsp_fallback = true }
      end,
      mode = { "n", "x" },
      desc = "general format file",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
    },

    formatters = {
      biome = { require_cwd = true },
    },
  },
}
