-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has('win32') ~= 0
local sep = is_windows and '\\' or '/'
local delim = is_windows and ';' or ':'
vim.env.PATH = table.concat({ vim.fn.stdpath('data'), 'mason', 'bin' }, sep) .. delim .. vim.env.PATH

return {
  'williamboman/mason.nvim',
  event = 'VeryLazy',
  dependencies = {
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      config = function()
        require('mason-tool-installer').setup({
          ensure_installed = {
            'tree-sitter-cli',
            -- LSP servers
            'css-lsp',
            'lua-language-server',
            'yaml-language-server',
            'json-lsp',
            'markdown-oxide',
            'taplo',
            'pyright',
            'docker-language-server',
            'bash-language-server',
            -- Formatters
            'stylua',
            'prettier',
            'shfmt',
            'black',
            -- Linters
            'shellcheck',
          },
        })
      end,
    },
  },
  init = function() vim.keymap.set('n', '<leader>hm', ':Mason<CR>', { desc = 'Mason' }) end,
  config = function() require('mason').setup({}) end,
}
