---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "void",
  transparency = true,
  hl_override = {
    NvDashAscii = { fg = "dark_purple" },
  },
}

M.ui = {
  tabufline = { lazyload = false, order = {} },
}

M.nvdash = {
  load_on_startup = true,
  header = {
    [[                               __                ]],
    [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
    [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
    [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
    [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
    [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
    [[                                                 ]],
    [[                                                 ]],
  },
  buttons = require "configs.nvdash",
}

M.term = {
  base46_colors = false,
}

return M
