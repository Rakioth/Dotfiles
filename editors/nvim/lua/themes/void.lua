---@type Base46Table
local M = {}

M.base_30 = {
  white = "#d5ced9",
  black = "#1e1e1e",
  darker_black = "#1a1a1a",
  black2 = "#262626",
  one_bg = "#2a2a2a",
  one_bg2 = "#2e2e2e",
  one_bg3 = "#323232",
  grey = "#423c35",
  grey_fg = "#5f6167",
  grey_fg2 = "#6a6a6a",
  light_grey = "#7a7a7a",
  red = "#fb4934",
  baby_pink = "#cc241d",
  pink = "#ff75a0",
  line = "#262626",
  green = "#b8bb26",
  vibrant_green = "#a9b665",
  nord_blue = "#82d173",
  blue = "#458588",
  yellow = "#d79921",
  sun = "#fabd2f",
  purple = "#b4bbc8",
  dark_purple = "#ce3ed6",
  teal = "#749689",
  orange = "#e78a4e",
  cyan = "#82b3a8",
  statusline_bg = "#262626",
  lightbg = "#323232",
  pmenu_bg = "#82d173",
  folder_bg = "#749689",
}

M.base_16 = {
  base00 = "#1e1e1e",
  base01 = "#262626",
  base02 = "#2a2a2a",
  base03 = "#5f6167",
  base04 = "#7a7a7a",
  base05 = "#d5ced9",
  base06 = "#e0d9de",
  base07 = "#ffffff",
  base08 = "#c698f2",
  base09 = "#d3869b",
  base0A = "#82aaff",
  base0B = "#b8bb26",
  base0C = "#8ec07c",
  base0D = "#82d173",
  base0E = "#ce3ed6",
  base0F = "#11a8cd",
}

M.polish_hl = {
  syntax = {
    Operator = { fg = M.base_30.nord_blue },
  },

  treesitter = {
    ["@operator"] = { fg = M.base_30.nord_blue },
  },
}

M.type = "dark"

M = require("base46").override_theme(M, "void")

return M
