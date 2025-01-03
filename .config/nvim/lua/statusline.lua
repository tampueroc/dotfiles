local M = {}

--- Git status (if any).
---@return string
function M.git_component()
    local head = vim.b.gitsigns_head
    if not head or head == '' then
        return ''
    end

    return string.format(' %s', head)
end

--- File-content encoding for the current buffer.
---@return string
function M.encoding_component()
    local encoding = vim.opt.fileencoding:get()
    return encoding ~= '' and string.format('%%#StatuslineModeSeparatorOther# %s', encoding) or ''
end

--- The current line, total line count, and column position.
---@return string
function M.position_component()
    local line = vim.fn.line '.'
    local line_count = vim.api.nvim_buf_line_count(0)
    local col = vim.fn.virtcol '.'

    return table.concat {
        '%#StatuslineItalic#l: ',
        string.format('%%#StatuslineTitle#%d', line),
        string.format('%%#StatuslineItalic#/%d c: %d', line_count, col),
    }
end

--- Renders the statusline.
---@return string
function M.render()
    ---@param components string[]
    ---@return string
    local function concat_components(components)
        return vim.iter(components):skip(1):fold(components[1], function(acc, component)
            return #component > 0 and string.format('%s    %s', acc, component) or acc
        end)
    end

    return table.concat {
        concat_components {
            M.git_component(),
        },
        '%#StatusLine#%=',
        concat_components {
            M.encoding_component(),
            M.position_component(),
        },
        ' ',
    }
end
vim.o.statusline = "%!v:lua.require'statusline'.render()"

return M
