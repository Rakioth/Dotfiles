return {
  "mbbill/undotree",
  cmd = { "UndotreeToggle" },
  keys = {
    {
      "<leader>u",
      "<cmd>UndotreeToggle<CR>",
      mode = { "n" },
      desc = "toggle undotree",
    },
  },
  init = function()
    vim.g.undotree_HelpLine = 0
    vim.g.undotree_DiffpanelHeight = 17
    vim.g.undotree_DiffCommand = "git diff -p"
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_ShortIndicators = 1
    vim.g.undotree_WindowLayout = 2
  end,
}
