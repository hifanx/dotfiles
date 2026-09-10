---@brief https://github.com/microsoft/pyright

---@type vim.lsp.Config
return {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
        'pyrightconfig.json',
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        '.git',
    },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
            },
        },
    },
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, 'LspPyrightOrganizeImports', function()
            local params = {
                command = 'pyright.organizeimports',
                arguments = { vim.uri_from_bufnr(bufnr) },
            }

            -- Using client.request() directly because "pyright.organizeimports" is private
            -- (not advertised via capabilities), which client:exec_cmd() refuses to call.
            -- https://github.com/neovim/neovim/blob/c333d64663d3b6e0dd9aa440e433d346af4a3d81/runtime/lua/vim/lsp/client.lua#L1024-L1030
            ---@diagnostic disable-next-line: param-type-mismatch
            client.request('workspace/executeCommand', params, nil, bufnr)
        end, {
            desc = 'Organize Imports',
        })
    end,
}
