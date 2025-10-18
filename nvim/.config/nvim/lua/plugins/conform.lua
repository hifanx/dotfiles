return {
  'stevearc/conform.nvim',
  cmd = { 'ConformInfo' },
  init = function()
    vim.keymap.set(
      { 'n', 'v' },
      '<Leader>lf',
      function() require('conform').format({ async = true, lsp_fallback = true }) end,
      { desc = '[F]ormat buffer' }
    )
    vim.keymap.set('n', '<Leader>hI', ':ConformInfo<CR>', { desc = '[C]onform info' })
    vim.keymap.set('n', '<leader>hi', ':LspInfo<CR>', { desc = 'LSP [I]nfo' })
  end,
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        lua = { 'stylua' },
        python = { 'black' },
        markdown = { 'prettier' },
        svelte = { 'prettier' },
        javascript = { 'prettier' },
        typescript = { 'prettier' },
        vue = { 'prettier' },
        css = { 'prettier' },
        scss = { 'prettier' },
        less = { 'prettier' },
        html = { 'prettier' },
        json = { 'prettier' },
        jsonc = { 'prettier' },
        yaml = { 'prettier' },
        graphql = { 'prettier' },
        handlebars = { 'prettier' },
        sh = { 'shfmt' },
        bash = { 'shfmt' },
        toml = { 'taplo' },
      },
      formatters = {
        shfmt = { append_args = { '-i', '2' } },
      },
    })
  end,
}
