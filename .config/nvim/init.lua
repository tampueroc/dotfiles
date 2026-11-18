if not vim.pack then
    error("This configuration requires Neovim with vim.pack (0.12 or later)")
end

require 'settings'
require 'keymaps'
require 'commands'
require 'autocmds'
require 'statusline'
require 'marks'
require 'lsp'

require("user.terminal.integration").setup()
