vim.keymap.set(
    { 'n', 'v' },
    '<Leader>lf',
    function() require('conform').format({ async = true, lsp_fallback = true }) end,
    { desc = '[F]ormat buffer' }
)
vim.keymap.set('n', '<Leader>hc', ':ConformInfo<CR>', { desc = '[C]onform info' })

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
