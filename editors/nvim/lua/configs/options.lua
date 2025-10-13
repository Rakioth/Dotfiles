require "nvchad.options"

local o = vim.o

o.guicursor = "n-v-c-sm-i-ci-ve-r-cr-o:ver25,t:ver25-blinkon500-blinkoff500-TermCursor"
o.relativenumber = true
o.wrap = false
o.scrolloff = 8

o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4

o.hlsearch = false
o.incsearch = true

o.swapfile = false
o.backup = false

local is_windows = vim.fn.has "win32" ~= 0
if is_windows then
  o.shell = "pwsh"
  o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
  o.shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait"
  o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
  o.shellquote = ""
  o.shellxquote = ""
end
