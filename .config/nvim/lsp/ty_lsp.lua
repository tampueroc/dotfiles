--@type vim.lsp.Config
return {
    cmd = { 'ty', 'server' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'mypy.ini'
    },
    settings = {
        ty = {
            trace = {
                server = "messages"
            },
            experimental = {
                completions = {
                    enable = true
                }
            }
        }
    }
}

