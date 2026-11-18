-- Debugger
local pack = require("pack")

local keys = {
    {
        '<leader>db',
        function()
            require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle breakpoint',
    },
    {
        '<leader>dB',
        '<cmd>FzfLua dap_breakpoints<cr>',
        desc = 'List breakpoints',
    },
    {
        '<F5>',
        function()
            require('dap').continue()
        end,
        desc = 'Continue',
    },
    {
        '<F10>',
        function()
            require('dap').step_over()
        end,
        desc = 'Step over',
    },
    {
        '<leader>dT',
        function ()
            require('dapui').float_element('console', { position = 'center' })
        end,
        desc = 'Debuger: Floating Console'
    },
    {
        '<leader>dQ',
        function ()
            require('dap').terminate()
        end,
        desc = 'Debuger: Terminate Session'
    },

}

keys[#keys + 1] = {
    '<leader>de',
    function()
        -- The second call jumps into the evaluation window.
        require('dapui').eval()
        require('dapui').eval()
    end,
    desc = 'Evaluate expression',
}
keys[#keys + 1] = {
    '<leader>dl',
    function()
        require('osv').launch { port = 8086 }
    end,
    desc = 'Launch Lua adapter',
}

local function configure()
    local dap = require('dap')
    local dapui = require('dapui')

    -- Automatically open the UI when a new debug session is created.
    dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open {}
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close {}
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close {}
    end

    -- Lua configurations.
    dap.adapters.nlua = function(callback, config)
        callback { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 }
    end

    dap.configurations['lua'] = {
        {
            type = 'nlua',
            request = 'attach',
            name = 'Attach to running Neovim instance',
        },
    }

    -- Python configurations
    require('dap-python').setup()

    -- Node configurations
    require("dap").adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
            command = "node",
            args = {(os.getenv("HOME") .. "/Code/dap/vscode-js-debug/out/src/dapDebugServer.js"), "${port}"},
        }
    }
    require("dap").configurations.javascript = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
        },
        {
            name = 'Attach by port',
            type = 'pwa-node',
            request = 'attach',
            port = 9229,
            restart = true,
            skipFiles = { '<node_internals>/**', 'node_modules/**' },
            cwd = "${workspaceFolder}"
        }
    }


    -- C configurations.
    dap.adapters.codelldb = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
            command = 'codelldb',
            args = { '--port', '${port}' },
        },
    }
end

pack.add({
    { src = "mfussenegger/nvim-dap", setup = false },
    { src = "nvim-neotest/nvim-nio", setup = false },
    {
        src = "rcarriga/nvim-dap-ui",
        module_name = "dapui",
        opts = {
            floating = { border = 'rounded' },
            controls = { enabled = false },
            layouts = {
                {
                    elements = { { id = 'scopes', size = 1.0 } },
                    position = 'bottom',
                    size = 15,
                },
            },
        },
    },
    {
        src = "theHamsta/nvim-dap-virtual-text",
        opts = { virt_text_pos = 'eol' },
    },
    { src = "jbyuki/one-small-step-for-vimkind", setup = false },
    { src = "mfussenegger/nvim-dap-python", setup = false },
})
configure()
pack.map_keys(keys)
