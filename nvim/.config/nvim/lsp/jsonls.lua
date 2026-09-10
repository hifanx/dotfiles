---@brief https://github.com/hrsh7th/vscode-langservers-extracted

---@type vim.lsp.Config
return {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    init_options = {
        provideFormatter = true,
    },
    root_markers = { '.git' },
}
