---@type ChadrcConfig
local M = {}

local highlights = require "highlights"

M.ui = {
  theme = "codely_purple",
  transparency = true,

  hl_add = highlights.add,
  hl_override = highlights.override,

  tabufline = {
    enabled = false,
  },

  nvdash = {
    load_on_startup = true,
  },
}

return M
