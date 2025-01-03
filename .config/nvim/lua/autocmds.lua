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
