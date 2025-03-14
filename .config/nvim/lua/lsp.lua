local methods = vim.lsp.protocol.Methods
local M = {}

--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
local function on_attach(client, bufnr)
    ---@param lhs string
    ---@param rhs string|function
    ---@param desc string
    ---@param mode? string|string[]
    local function keymap(lhs, rhs, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    keymap('grr', '<cmd>FzfLua lsp_references<cr>', 'vim.lsp.buf.references()')

    keymap('gy', '<cmd>FzfLua lsp_typedefs<cr>', 'Go to type definition')

    keymap('<leader>fs', '<cmd>FzfLua lsp_document_symbols<cr>', 'Document symbols')
    keymap('<leader>fS', function()
        -- Disable the grep switch header.
        require('fzf-lua').lsp_live_workspace_symbols { no_header_i = true }
    end, 'Workspace symbols')

    keymap('[d', function()
        vim.diagnostic.jump { count = -1 }
    end, 'Previous diagnostic')
    keymap(']d', function()
        vim.diagnostic.jump { count = 1 }
    end, 'Next diagnostic')
    keymap('[e', function()
        vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
    end, 'Previous error')
    keymap(']e', function()
        vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
    end, 'Next error')

    if client:supports_method(methods.textDocument_definition) then
        keymap('gD', '<cmd>FzfLua lsp_definitions<cr>', 'Peek definition')
        keymap('gd', function()
            require('fzf-lua').lsp_definitions { jump_to_single_result = true }
        end, 'Go to definition')
    end

    if client:supports_method(methods.textDocument_signatureHelp) then
        local blink_window = require 'blink.cmp.completion.windows.menu'
        local blink = require 'blink.cmp'

        keymap('<C-k>', function()
            -- Close the completion menu first (if open).
            if blink_window.win:is_open() then
                blink.hide()
            end

            vim.lsp.buf.signature_help()
        end, 'Signature help', 'i')
    end

    if client:supports_method(methods.textDocument_documentHighlight) then
        local under_cursor_highlights_group =
            vim.api.nvim_create_augroup('mariasolos/cursor_highlights', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'InsertLeave' }, {
            group = under_cursor_highlights_group,
            desc = 'Highlight references under the cursor',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufLeave' }, {
            group = under_cursor_highlights_group,
            desc = 'Clear highlight references',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end

    if client:supports_method(methods.textDocument_inlayHint) then
        vim.keymap.set('n', '<leader>ci', function()
            -- Toggle the hints:
            local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
            vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })

            -- If toggling them on, turn them back off when entering insert mode.
            if not enabled then
                vim.api.nvim_create_autocmd('InsertEnter', {
                    buffer = bufnr,
                    once = true,
                    callback = function()
                        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                    end,
                })
            end
        end, { buffer = bufnr, desc = 'Toggle inlay hints' })
    end
    if client.name == "svelte" then
        vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.js", "*.ts" },
            group = vim.api.nvim_create_augroup("svelte_ondidchangetsorjsfile", { clear = true }),
            callback = function(ctx)
                -- Here use ctx.match instead of ctx.file
                client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
            end,
        })
    end
end

-- Update mappings when registering dynamic capabilities.
local register_capability = vim.lsp.handlers[methods.client_registerCapability]
vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
        return
    end

    on_attach(client, vim.api.nvim_get_current_buf())

    return register_capability(err, res, ctx)
end

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'Configure LSP keymaps',
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)

        -- I don't think this can happen but it's a wild world out there.
        if not client then
            return
        end

        on_attach(client, args.buf)
    end,
})

--- Configures the given server with its settings and applying the regular
--- client capabilities (+ the completion ones from blink.cmp).
---@param server string
---@param settings? table
function M.configure_server(server, settings)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)

    require('lspconfig')[server].setup(
        vim.tbl_deep_extend('error', { capabilities = capabilities, silent = true }, settings or {})
    )
end
return M
