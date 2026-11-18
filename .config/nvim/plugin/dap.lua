local add = require('pack').add

add {
    { src = 'mfussenegger/nvim-dap', setup = false },
}

local dap = require('dap')
local map = function(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, { desc = desc })
end

map('<leader>db', dap.toggle_breakpoint, 'Toggle breakpoint')
map('<leader>dB', '<cmd>FzfLua dap_breakpoints<cr>', 'List breakpoints')
map('<leader>dc', function()
    dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, 'Conditional breakpoint')
map('<leader>dT', dap.repl.toggle, 'Toggle debugger REPL')
map('<leader>dQ', dap.terminate, 'Terminate debug session')
map('<F5>', dap.continue, 'Continue')
map('<F10>', dap.step_over, 'Step over')
map('<F11>', dap.step_into, 'Step into')
map('<F12>', dap.step_out, 'Step out')

-- Install debugpy in the Python environment used by the adapter.
dap.adapters.python = function(callback)
    local python = vim.env.VIRTUAL_ENV and (vim.env.VIRTUAL_ENV .. '/bin/python') or 'python3'
    callback { type = 'executable', command = python, args = { '-m', 'debugpy.adapter' } }
end
dap.configurations.python = {
    { type = 'python', request = 'launch', name = 'Launch current file', program = '${file}' },
}

dap.adapters['pwa-node'] = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = {
        command = 'node',
        args = { vim.fn.expand('~/Code/dap/vscode-js-debug/out/src/dapDebugServer.js'), '${port}' },
    },
}
dap.configurations.javascript = {
    {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        cwd = '${workspaceFolder}',
    },
    {
        type = 'pwa-node',
        request = 'attach',
        name = 'Attach by port',
        port = 9229,
        restart = true,
        skipFiles = { '<node_internals>/**', 'node_modules/**' },
        cwd = '${workspaceFolder}',
    },
}

dap.adapters.codelldb = {
    type = 'server',
    host = 'localhost',
    port = '${port}',
    executable = { command = 'codelldb', args = { '--port', '${port}' } },
}
