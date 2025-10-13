require "nvchad.mappings"

local map = vim.keymap.set

map("n", ";", ":", { desc = "enter command mode" })
map("i", "jk", "<ESC>", { desc = "exit insert mode" })

map("n", "<C-d>", "<C-d>zz", { desc = "half page down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "half page up and center" })
map("n", "n", "nzzzv", { desc = "next search result and center" })
map("n", "N", "Nzzzv", { desc = "previous search result and center" })

map("n", "J", "mzJ`z", { desc = "join lines without moving cursor" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "move selected lines down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "move selected lines up" })

map("x", "<leader>p", [["_dP]], { desc = "paste without overwriting register" })
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "yank to system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "yank line to system clipboard" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "delete without affecting register" })

map("n", "<A-k>", "<cmd>cnext<CR>zz", { desc = "next quickfix item and center" })
map("n", "<A-j>", "<cmd>cprev<CR>zz", { desc = "previous quickfix item and center" })
map("n", "<leader>k", "<cmd>lnext<CR>zz", { desc = "next location list item and center" })
map("n", "<leader>j", "<cmd>lprev<CR>zz", { desc = "previous location list item and center" })

map(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "search and replace word under cursor" }
)

map({ "n", "t" }, "<leader>lg", function()
  require("nvchad.term").toggle {
    pos = "float",
    id = "lazygit",
    cmd = "lazygit",
    float_opts = {
      relative = "editor",
      width = 1,
      height = 0.9,
      row = 0.01,
      col = 0,
      border = "none",
    },
  }
end, { desc = "toggle lazygit terminal" })

local nomap = vim.keymap.del
nomap("n", "<C-n>")
