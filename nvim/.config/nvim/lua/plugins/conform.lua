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

vim.api.nvim_create_user_command('FormatDisable', function(args)
    if args.bang then
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = 'Disable autoformat-on-save',
    bang = true,
})

vim.api.nvim_create_user_command('FormatEnable', function(args)
    if args.bang then
        vim.b.disable_autoformat = false
    else
        vim.g.disable_autoformat = false
    end
end, {
    desc = 'Enable autoformat-on-save',
    bang = true,
})

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
    default_format_opts = {
        lsp_format = 'fallback',
    },
    format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
        return { timeout_ms = 500 }
    end,
    formatters = {
        shfmt = { append_args = { '-i', '2' } },
    },
})
