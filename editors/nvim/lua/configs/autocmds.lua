require "nvchad.autocmds"

local autocmd = vim.api.nvim_create_autocmd

autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})

autocmd("VimEnter", {
  callback = function(args)
    local stat = vim.uv.fs_stat(args.file)
    if not stat then
      return
    end

    local dir = vim.fn.fnamemodify(args.file, stat.type == "file" and ":p:h" or ":p")
    vim.cmd.cd(dir)
  end,
})
