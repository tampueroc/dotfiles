return {
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            require('lspconfig.ui.windows').default_options.border = 'rounded'
            local configure_server = require('lsp').configure_server

            -- Server with no configuration
            configure_server 'html'
            configure_server 'cssls'
        end
        }
    }
