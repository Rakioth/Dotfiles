---@type ChadrcConfig
local M = {}

local highlights = require "custom.highlights"

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

M.plugins = "custom.plugins"

M.mappings = require "custom.mappings"

return M
