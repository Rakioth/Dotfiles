return {
  -- TODO: remove lazyspec once blink is default: https://github.com/NvChad/NvChad/discussions/3244
  { import = "nvchad.blink.lazyspec" },
  {
    "zbirenbaum/copilot.lua",
    cmd = { "Copilot" },
    event = "BufReadPost",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = { ["*"] = true },
    },
  },
  {
    "giuxtaposition/blink-cmp-copilot",
    lazy = false,
    dependencies = { "Saghen/blink.cmp", "zbirenbaum/copilot.lua" },
    specs = {
      {
        "Saghen/blink.cmp",
        opts = function(_, opts)
          table.insert(opts.sources.default, "copilot")
          opts.sources.providers = opts.sources.providers or {}
          opts.sources.providers.copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          }
        end,
      },
    },
  },
}
