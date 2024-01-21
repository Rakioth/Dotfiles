local null_ls = require "null-ls"

local b = null_ls.builtins

local sources = {
    b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } },
    b.formatting.deno_fmt,
    b.formatting.stylua,
}

null_ls.setup {
    debug = true,
    sources = sources,
}
