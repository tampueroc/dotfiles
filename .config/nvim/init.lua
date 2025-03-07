vim.g.projects_dir = vim.env.HOME .. '/Code'

-- Install Lazy.
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system {
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable',
        lazypath,
    }
end
vim.opt.rtp = vim.opt.rtp ^ lazypath

---@type LazySpec
local plugins = 'plugins'

require 'settings'
require 'keymaps'
require 'commands'
require 'autocmds'
require 'statusline'

require('lazy').setup(plugins, {
	ui = { border = 'rounded' },
	dev = { path = vim.g.projects_dir },
	install = {
        -- Do not automatically install on startup.
 		missing = false,
	},
	change_detection = { notify = false }
	}
)
