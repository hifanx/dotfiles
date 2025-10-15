return {
  'stevearc/conform.nvim',
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<Leader>lf',
      function() require('conform').format { async = true, lsp_fallback = true } end,
      mode = '',
      desc = '[F]ormat buffer',
    },
    { '<Leader>hI', ':ConformInfo<CR>', mode = 'n', desc = '[C]onform info' },
  },
  config = function()
    require('conform').setup {
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
    }
  end,
}
