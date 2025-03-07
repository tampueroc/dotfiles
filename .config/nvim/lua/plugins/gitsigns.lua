-- Adds git releated signs to the gutter, as well as utilities for managing changes.
return {
    {
        'lewis6991/gitsigns.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        opts =  {
            signs = {
                add          = { text = '┃' },
                change       = { text = '┃' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            signs_staged = {
                add          = { text = '┃' },
                change       = { text = '┃' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
                untracked    = { text = '┆' },
            },
            preview_config = { border = 'rounded' },
            on_attach = function(bufnr)
                local gitlinker = require 'gitlinker'
                local gs = package.loaded.gitsigns

                -- Gitlinker doesn't add descriptions.
                -- local miniclue = require 'mini.clue'
                -- miniclue.set_mapping_desc('n', '<leader>gc', 'Copy GitHub link')
                -- miniclue.set_mapping_desc('v', '<leader>gc', 'Copy GitHub link')

                -- Mappings.
                ---@param lhs string
                ---@param rhs function
                ---@param desc string
                local function nmap(lhs, rhs, desc)
                    vim.keymap.set('n', lhs, rhs, { desc = desc, buffer = bufnr })
                end
                nmap('<leader>go', function()
                    gitlinker.get_buf_range_url('n', { action_callback = require('gitlinker.actions').open_in_browser })
                end, 'Open in browser')
                nmap('[g', gs.prev_hunk, 'Previous hunk')
                nmap(']g', gs.next_hunk, 'Next hunk')
                nmap('<leader>gR', gs.reset_buffer, 'Reset buffer')
                nmap('<leader>gb', gs.blame_line, 'Blame line')
                nmap('<leader>gp', gs.preview_hunk, 'Preview hunk')
                nmap('<leader>gr', gs.reset_hunk, 'Reset hunk')
                nmap('<leader>gs', gs.stage_hunk, 'Stage hunk')

                -- Text object:
                vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<cr>')
            end,
        },
    },
}
