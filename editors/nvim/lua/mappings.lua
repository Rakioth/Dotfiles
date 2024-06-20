require "nvchad.mappings"

local map = vim.keymap.set

map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

map("n", "<leader>x", ":close<CR>", { desc = "Close window" })

map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })

map("n", "J", "mzJ`z", { desc = "Join with line below" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down with line middle" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up with line middle" })
map("n", "n", "nzzzv", { desc = "Next occurrence with text centered" })
map("n", "N", "Nzzzv", { desc = "Previous occurrence with text centered" })

map("n", "<leader>y", [["+y]], { desc = "Yank selected text into the system clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Yank selected line into the system clipboard" })

map("n", "<leader>d", [[\"_d]], { desc = "Delete selected text" })
map(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Case-insensitive search and replace operation" }
)

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down one line" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up two lines" })

map("v", "<leader>y", [["+y]], { desc = "Yank selected text into the system clipboard" })

map("v", "<leader>d", [["_d]], { desc = "Delete selected text" })

map("x", "<leader>p", [["_dP]], { desc = "Delete selected text, yank into system clipboard" })

-- dap
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Toggle breakpoint" })
map("n", "<leader>dus", function()
  local widgets = require "dap.ui.widgets"
  local sidebar = widgets.sidebar(widgets.scopes)
  sidebar.open()
end, { desc = "Open debugging sidebar" })

-- harpoon
map("n", "<leader>a", function()
  local harpoon = require "harpoon"
  harpoon:list():append()
end, { desc = "Harpoon add file" })
map("n", "<C-e>", function()
  local harpoon = require "harpoon"
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon menu" })
map("n", "<C-u>", function()
  local harpoon = require "harpoon"
  harpoon:list():select(1)
end, { desc = "Harpoon go to file 1" })
map("n", "<C-i>", function()
  local harpoon = require "harpoon"
  harpoon:list():select(2)
end, { desc = "Harpoon go to file 2" })
map("n", "<C-o>", function()
  local harpoon = require "harpoon"
  harpoon:list():select(3)
end, { desc = "Harpoon go to file 3" })
map("n", "<C-p>", function()
  local harpoon = require "harpoon"
  harpoon:list():select(4)
end, { desc = "Harpoon go to file 4" })

-- undotree
map("n", "<leader>u", "<cmd> UndotreeToggle <CR>", { desc = "Undotree menu" })
