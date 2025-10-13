return {
  "L3MON4D3/LuaSnip",
  build = "make install_jsregexp",
  init = function()
    vim.g.vscode_snippets_path = os.getenv "DOTFILES" .. "/editors/code/snippets"
  end,
}
