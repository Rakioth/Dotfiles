return {
  "neovim/nvim-lspconfig",
  dependencies = { "mason-org/mason.nvim" },
  config = function()
    require("nvchad.configs.lspconfig").defaults()

    local servers = {
      "astro",
      "bashls",
      "biome",
      "cssls",
      "html",
      "lua_ls",
      "powershell_es",
      "tailwindcss",
      "ts_ls",
    }

    vim.lsp.config("powershell_es", {
      bundle_path = vim.fn.stdpath "data" .. "/mason/packages/powershell-editor-services",
    })

    vim.lsp.enable(servers)

    local x = vim.diagnostic.severity
    vim.diagnostic.config {
      signs = { text = { [x.ERROR] = "", [x.WARN] = "", [x.INFO] = "", [x.HINT] = "󰌵" } },
    }
  end,
}
