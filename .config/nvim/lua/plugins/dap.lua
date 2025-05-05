-- Debugger
return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            'nvim-neotest/nvim-nio',
            {
                'rcarriga/nvim-dap-ui',
                keys = {
                    {
                        '<leader>de',
                        function()
                            -- Calling this twice to open and jump into the window.
                            require('dapui').eval()
                            require('dapui').eval()
                        end,
                        desc = 'Evaluate expression',
                    }
                },
                opts = {
                    floating = { border = 'rounded' },
                    layouts = {
                        {
                            elements = {
                                { id = 'stacks', size = 0.30 },
                                { id = 'breakpoints', size = 0.20 },
                                { id = 'scopes', size = 0.50 },
                            },
                            position = 'left',
                            size = 40,
                        },
                    },
                }
            },
            -- Virtual text
            {
                'theHamsta/nvim-dap-virtual-text',
                opts = { virt_text_pos = 'eol' },
            },
            {
                'jbyuki/one-small-step-for-vimkind',
                keys = {
                    {
                        '<leader>dl',
                        function()
                            require('osv').launch { port = 8086 }
                        end,
                        desc = 'Launch Lua adapter',
                    },
                },
            },
            {
                'mfussenegger/nvim-dap-python'
            }
        },
        keys = {
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
                '<F11>',
                function()
                    require('dap').step_into()
                end,
                desc = 'Step into',
            },
            {
                '<F12>',
                function()
                    require('dap').step_out()
                end,
                desc = 'Step Out',
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

        },
        config = function ()
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

    }
}
