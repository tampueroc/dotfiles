-- Auto-completion:
return {
    {
        'saghen/blink.cmp',
        version = '*',
        event = 'InsertEnter',
        opts = {
            keymap = {
                ['<CR>'] = { 'accept', 'fallback' },
                ['/'] = { 'hide', 'fallback' },
                ['<C-n>'] = { 'select_next', 'show' },
                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<C-p>'] = { 'select_prev' },
                ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
            },
            completion = {
                list = {
                    -- Insert items while navigating the completion list.
                    selection = 'auto_insert',
                    max_items = 10,
                },
                menu = {
                    border = 'rounded',
                },
                documentation = {
                    auto_show = true,
                    window = { border = 'rounded' },
                },
            },
            sources = {
                -- Disable command line completion:
                cmdline = {},
            },
        },
    },
}
