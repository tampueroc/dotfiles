vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('tampueroc/trim_whitespace', { clear = true }),
    desc = 'Remove trailing whitespace before saving the buffer',
    callback = function(args)
        local save_cursor = vim.fn.getpos(".") -- Save the current cursor position
        vim.cmd([[%s/\s\+$//e]]) -- Remove trailing whitespace
        vim.fn.setpos(".", save_cursor) -- Restore the cursor position
    end,
})

vim.api.nvim_create_autocmd('VimEnter', {
    group = vim.api.nvim_create_augroup('tampueroc/dotfiles_setup', { clear = true }),
    desc = 'Special dotfiles setup',
    callback = function()
        local ok, inside_dotfiles = pcall(vim.startswith, vim.fn.getcwd(), vim.env.XDG_CONFIG_HOME)
        if not ok or not inside_dotfiles then
            return
        end

        -- Configure git environment.
        vim.env.GIT_WORK_TREE = vim.env.HOME
        vim.env.GIT_DIR = vim.env.HOME .. '/.cfg'
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('tampueroc/close_with_q', { clear = true }),
    desc = 'Close with <q>',
    pattern = {
        'git',
        'help',
        'man',
        'qf',
        'query',
        'scratch',
    },
    callback = function(args)
        vim.keymap.set('n', 'q', '<cmd>quit<cr>', { buffer = args.buf })
    end,
})


local line_numbers_group = vim.api.nvim_create_augroup('mariasolos/toggle_line_numbers', {})
vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
    group = line_numbers_group,
    desc = 'Toggle relative line numbers on',
    callback = function()
        if vim.wo.nu and not vim.startswith(vim.api.nvim_get_mode().mode, 'i') then
            vim.wo.relativenumber = true
        end
    end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
    group = line_numbers_group,
    desc = 'Toggle relative line numbers off',
    callback = function(args)
        if vim.wo.nu then
            vim.wo.relativenumber = false
        end

        -- Redraw here to avoid having to first write something for the line numbers to update.
        if args.event == 'CmdlineEnter' then
            vim.cmd.redraw()
        end
    end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
    group = vim.api.nvim_create_augroup('mariasolos/yank_highlight', { clear = true }),
    desc = 'Highlight on yank',
    callback = function()
        -- Setting a priority higher than the LSP references one.
        vim.hl.on_yank { higroup = 'Visual', priority = 250 }
    end,
})

vim.api.nvim_create_autocmd('WinScrolled', {
    group = vim.api.nvim_create_augroup('tampueroc/clamp_window_scroll', { clear = true }),
    desc = 'Never scroll past end-of-buffer',
    callback = function(ev)
        local win = assert(tonumber(ev.match))
        if vim.wo[win].scrollbind then
            -- Disabled for 'scrollbind' windows because it sometimes makes them out of sync.
            return
        end

        local buf = vim.api.nvim_win_get_buf(win)
        local line_count = vim.api.nvim_buf_line_count(buf)
        local win_height = math.min(vim.api.nvim_win_get_height(win), line_count)

        local last_visible_line = vim.fn.line('w0', win) + win_height - 1
        local out_of_buf_lines = last_visible_line - line_count

        if out_of_buf_lines > 0 then
            vim._with({ win = win }, function()
                vim.fn.winrestview({
                    topline = math.max(1, line_count - win_height + 1),
                })
                -- https://github.com/neovim/neovim/issues/35633#issuecomment-3256274806
                vim.api.nvim_feedkeys(vim.keycode('<Ignore>'), 'ni', false)
            end)
        end
    end,
})
