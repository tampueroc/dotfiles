--@type vim.lsp.Config
return {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cgf',
        'requirements.txt',
        'Pipfile',
        'mypy.ini'
    }
}
