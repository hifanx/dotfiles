vim.g.disable_autoformat = false

vim.api.nvim_create_user_command('Format', function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ['end'] = { args.line2, end_line:len() },
        }
    end
    require('conform').format({ async = true, range = range })
end, { range = true })

vim.keymap.set('n', '<Leader>hf', function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify(('Format on save: %s'):format(vim.g.disable_autoformat and 'off' or 'on'))
end, { desc = 'Toggle format on save' })

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
        java = { 'google-java-format' },
    },
    format_after_save = function()
        if vim.g.disable_autoformat then return end
        return { lsp_format = 'fallback' }
    end,
    formatters = {
        shfmt = { append_args = { '-i', '2' } },
        ['google-java-format'] = { append_args = { '--aosp' } },
    },
})
