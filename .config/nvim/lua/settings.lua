-- Leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Built-in plugins
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
vim.g.netrw_browse_split = 0

-- Editing
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.expandtab = true
vim.o.updatetime = 50

-- UI
vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.guicursor = ''
vim.o.termguicolors = true

-- Completion / command-line
vim.opt.wildignore:append { '.DS_Store' }

vim.o.splitright = true
vim.o.splitbelow = true
vim.o.title = true
