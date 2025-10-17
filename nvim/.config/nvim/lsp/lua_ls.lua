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
    'selene.toml',
    'selene.yml',
    '.git',
  },
  settings = {
    Lua = {
      format = {
        enable = false,
      },
      completion = {
        callSnippet = 'Replace',
      },
      -- NOTE: need this or gd in init.lua for spec won't work
      runtime = { version = 'LuaJIT', path = vim.split(package.path, ';') },
      diagnostics = {
        globals = { 'vim', 'spec' },
        disable = { 'missing-fields' },
      },
      workspace = {
        checkThirdParty = false,
        ignoreSubmodules = true,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
}
