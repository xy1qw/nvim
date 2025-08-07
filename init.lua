-- Deps

local deps = {
  'nvim-telescope/telescope.nvim',
  'windwp/windline.nvim',
  'scottmckendry/cyberdream.nvim',
  'neovim/nvim-lspconfig',
  'echasnovski/mini.nvim'
}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup(deps) 

-- e Deps --




-- Common --

vim.g.mapleader = ' '

vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true
vim.cmd.syntax("on")

-- e Common --




-- Theme -- 

vim.cmd.colorscheme("cyberdream")

-- e Theme --


-- LSP -- 

local lspconfig = require("lspconfig")

lspconfig.ts_ls.setup({})

lspconfig.pyright.setup({})

lspconfig.gopls.setup({})

lspconfig.eslint.setup({})

lspconfig.jsonls.setup({})

-- LSP --



-- wlsample --

require('wlsample.airline_luffy')

-- e wlsample --


-- telescope --

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- e telescope --


-- mini -- 

local minifiles = require('mini.files')

vim.keymap.set('n', '<leader>e', minifiles.open, { desc = 'Telescope help tags' })


-- e mini --
