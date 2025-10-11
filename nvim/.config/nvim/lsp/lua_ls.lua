---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  settings = {
    Lua = {
      format = {
        enable = false,
      },
      completion = {
        callSnippet = "Replace",
      },
      runtime = { -- NOTE: need this or gd in init.lua for spec won't work
        version = "LuaJIT",
        special = {
          spec = "require",
        },
      },
      diagnostics = {
        globals = { "vim", "spec" },
        disable = { "missing-fields" },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
        },
      },
    },
  },
}
