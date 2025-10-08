-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has "win32" ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath "data", "mason", "bin" }, sep) .. delim .. vim.env.PATH

return {
  "williamboman/mason.nvim",
  event = "VimEnter",
  keys = {
    { "<leader>hm", ":Mason<CR>", desc = "Mason" },
  },
  dependencies = {
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = function()
        local servers = {
          "css-lsp",
          "lua-language-server",
          "yaml-language-server",
          "json-lsp",
          "markdown-oxide",
          "taplo", -- toml
          "pyright",
          "docker-language-server",
          "bash-language-server",
        }

        local formatters = {
          "stylua", -- lua formatter
          "prettier", -- prettier formatter
          "shfmt", -- shell formatter
          "black", -- python formatter
        }

        local linters = {
          "markdownlint", -- markdown linter
          "ruff", -- python linter
          "shellcheck", -- shell linter, used by bash-language-server
        }

        local ensure_installed = {}
        vim.list_extend(ensure_installed, servers)
        vim.list_extend(ensure_installed, formatters)
        vim.list_extend(ensure_installed, linters)

        return {
          ensure_installed = ensure_installed,
        }
      end,
    },
  },
  opts = {},
}
