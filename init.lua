---@diagnostic disable: undefined-global

require("config.lazy")

vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true
vim.cmd.syntax("on")
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.o.signcolumn = "yes"


require("diagnostic_virtual_lines_theme").setup()
