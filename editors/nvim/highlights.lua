local M = {}

---@type Base46HLGroupsList
M.override = {
    Comment = {
        italic = true,
    },

    CmpDoc = {
        bg = "none",
    },

    NvDashAscii = {
        bg = "none",
        fg = "blue",
    },

    NvDashButtons = {
        bg = "none",
        fg = "white",
    },
}

---@type HLTable
M.add = {
    NvimTreeOpenedFolderName = {
        fg = "green",
        bold = true,
    },
}

return M
