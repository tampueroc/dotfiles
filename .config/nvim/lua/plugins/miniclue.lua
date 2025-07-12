-- Remember my mappings.
return {
    {
        'echasnovski/mini.clue',
        event = 'VeryLazy',
        opts = function()
            local miniclue = require 'mini.clue'
            for _, lhs in ipairs { '[%', ']%', 'g%' } do
                vim.keymap.del('n', lhs)
            end

            -- Add a-z/A-Z marks.
            local function mark_clues()
                local marks = {}
                vim.list_extend(marks, vim.fn.getmarklist(vim.api.nvim_get_current_buf()))
                vim.list_extend(marks, vim.fn.getmarklist())

                return vim.iter(marks)
                    :map(function(mark)
                        local key = mark.mark:sub(2, 2)

                        -- Just look at letter marks.
                        if not string.match(key, '^%a') then
                            return nil
                        end

                        -- For global marks, use the file as a description.
                        -- For local marks, use the line number and content.
                        local desc
                        if mark.file then
                            desc = vim.fn.fnamemodify(mark.file, ':p:~:.')
                        elseif mark.pos[1] and mark.pos[1] ~= 0 then
                            local line_num = mark.pos[2]
                            local lines = vim.fn.getbufline(mark.pos[1], line_num)
                            if lines and lines[1] then
                                desc = string.format('%d: %s', line_num, lines[1]:gsub('^%s*', ''))
                            end
                        end

                        if desc then
                            return { mode = 'n', keys = string.format('`%s', key), desc = desc }
                        end
                    end)
                    :totable()
            end

            return {
                triggers = {
                    -- Marks
                    { mode = 'n', keys = '`' },
                    { mode = 'x', keys = '`' },

                    -- `z` key
                    { mode = 'n', keys = 'z' },
                    -- `g` key
                    { mode = 'n', keys = 'g' },
                    { mode = 'x', keys = 'g' },

                    -- Registers
                    { mode = 'n', keys = '"' },
                    { mode = 'x', keys = '"' },
                    { mode = 'i', keys = '<C-r>' },
                    { mode = 'c', keys = '<C-r>' },

                    -- Built-in completion
                    { mode = 'i', keys = '<C-x>' },

                    -- Window commands
                    { mode = 'n', keys = '<C-w>' },

                    -- Leader triggers
                    { mode = 'n', keys = '<Leader>' },
                    { mode = 'x', keys = '<Leader>' },

                     -- Moving between stuff.
                    { mode = 'n', keys = '[' },
                    { mode = 'n', keys = ']' }
                },

                clues = {
                    -- Enhance this by adding descriptions for <Leader> mapping groups
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),
                    -- Custom extras.
                    mark_clues
                },
                window = {
                    delay = 500,
                    scroll_down = '<C-f>',
                    scroll_up = '<C-b>',
                    config = function(bufnr)
                        local max_width = 0
                        for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)) do
                            max_width = math.max(max_width, vim.fn.strchars(line))
                        end

                        -- Keep some right padding.
                        max_width = max_width + 2

                        return {
                            -- Dynamic width capped at 70.
                            width = math.min(70, max_width),
                        }
                    end,
                },
            }
        end,
    },
}
