-- zk bundled LSP see: https://zk-org.github.io/zk/config/config-lsp.html
---@type vim.lsp.Config
return {
    cmd = { 'zk', 'lsp' },
    filetypes = { 'markdown' }
}
