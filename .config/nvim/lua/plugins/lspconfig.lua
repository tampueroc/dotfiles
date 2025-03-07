return {
    {
        'neovim/nvim-lspconfig',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            require('lspconfig.ui.windows').default_options.border = 'rounded'
            local configure_server = require('lsp').configure_server
            local lspconfig = require 'lspconfig'
            local async = require 'lspconfig.async'
            local function client_with_fn(fn)
              return function()
                local bufnr = vim.api.nvim_get_current_buf()
                local client = lspconfig.util.get_active_client_by_name(bufnr, 'texlab')
                if not client then
                  return vim.notify(('texlab client not found in bufnr %d'):format(bufnr), vim.log.levels.ERROR)
                end
                fn(client, bufnr)
              end
            end

            -- Server with no additional configuration
            configure_server('html')
            configure_server('cssls')

            configure_server('ts_ls', {
                cmd = {
                    "typescript-language-server",
                    "--stdio"
                },
                filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
                root_dir = lspconfig.util.root_pattern('tsconfig.json', 'package.json', 'jsconfig.json', '.git'),
                single_file_support = true,
            })

            configure_server('ruff', {
                cmd = { 'ruff', 'server' },
                filetypes = { 'python' },
                root_dir = function(fname)
                    local root_files = {
                        'pyproject.toml',
                        'setup.py',
                        'setup.cfg',
                        'requirements.txt',
                        'Pipfile',
                    }
                    return lspconfig.util.root_pattern(unpack(root_files))(fname)
                        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
                end,
                single_file_support = true,
                settings = {}
            })

            configure_server('basedpyright', {
                cmd = { 'basedpyright-langserver', '--stdio' },
                filetypes = { 'python' },
                root_dir = function(fname)
                    local root_files = {
                        'pyproject.toml',
                        'setup.py',
                        'setup.cfg',
                        'requirements.txt',
                        'Pipfile',
                    }
                    return lspconfig.util.root_pattern(unpack(root_files))(fname)
                        or vim.fs.dirname(vim.fs.find('.git', { path = fname, upward = true })[1])
                end,
                single_file_support = true,
                settings = {
                    basedpyright = {
                        disableOrganizeImports = true,
                        analysis = {
                            autoSearchPaths = true,
                            typeCheckingMode = 'basic',
                            diagnosticMode = 'openFilesOnly'
                        }
                    }
                },
            })

            configure_server('texlab', {
                cmd = { "texlab" },
                filetypes = { "tex", "plaintex", "bib" },
                root_dir = lspconfig.util.root_pattern('.git', '.latexmkrc', '.texlabroot', 'texlabroot', 'Tectonic.toml'),
                settings = {
                    texlab = {
                        rootDirectory = nil,
                        build = {
                            executable = 'latexmk',
                            args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
                            onSave = false,
                            forwardSearchAfter = false,
                        },
                        forwardSearch = {
                            executable = nil,
                            args = {},
                        },
                        chktex = {
                            onOpenAndSave = false,
                            onEdit = false,
                        },
                        diagnosticsDelay = 300,
                        latexFormatter = 'latexindent',
                        latexindent = {
                            ['local'] = nil, -- local is a reserved keyword
                            modifyLineBreaks = false,
                        },
                        bibtexFormatter = 'texlab',
                        formatterLineLength = 80,
                    }
                },
                commands = {
                    TexlabBuild = {
                        client_with_fn(buf_build),
                        description = 'Build the current buffer',
                    },
                }
            }
            )

            configure_server('gopls', {
                cmd = { 'gopls' },
                filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
                root_dir = function(fname)
                    -- see: https://github.com/neovim/nvim-lspconfig/issues/804
                    local mod_cache = nil
                    if not mod_cache then
                        local result = async.run_command { 'go', 'env', 'GOMODCACHE' }
                        if result and result[1] then
                            mod_cache = vim.trim(result[1])
                        else
                            mod_cache = vim.fn.system 'go env GOMODCACHE'
                        end
                    end
                    if mod_cache and fname:sub(1, #mod_cache) == mod_cache then
                        local clients = lspconfig.util.get_lsp_clients { name = 'gopls' }
                        if #clients > 0 then
                            return clients[#clients].config.root_dir
                        end
                    end
                    return lspconfig.util.root_pattern('go.work', 'go.mod', '.git')(fname)
                end,
                single_file_support = true,
            }
            )

        end,
    }
}

