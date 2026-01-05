---@type vim.lsp.Config
return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = {
        '.luarc.json',
        '.luarc.jsonc',
        '.luacheckrc',
        '.stylua.toml',
        'stylua.toml',
        '.git',
    },
    settings = {
        Lua = {
            format = { enable = false },
            completion = {
                callSnippet = 'Replace',
                keywordSnippet = 'Disable',
            },
            runtime = { version = 'LuaJIT' },
            diagnostics = {
                globals = { 'vim' },
                disable = { 'missing-fields' },
            },
            workspace = {
                checkThirdParty = false,
                ignoreSubmodules = true,
                -- library = { vim.env.VIMRUNTIME },
            },
            hint = {
                enable = true,
            },
            telemetry = { enable = false },
        },
    },
}
