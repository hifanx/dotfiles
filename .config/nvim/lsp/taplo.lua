---@brief https://taplo.tamasfe.dev/cli/usage/language-server.html

---@type vim.lsp.Config
return {
    cmd = { 'taplo', 'lsp', 'stdio' },
    filetypes = { 'toml' },
    -- Fall back to the file's dir: with no root, taplo excludes the document.
    root_dir = function(bufnr, on_dir)
        on_dir(
            vim.fs.root(bufnr, { '.taplo.toml', 'taplo.toml', '.git' })
                or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
        )
    end,
}
