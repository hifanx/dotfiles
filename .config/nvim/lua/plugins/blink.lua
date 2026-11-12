require('blink.cmp').setup({
    keymap = {
        preset = 'none',
        ['<C-e>'] = { 'show', 'hide', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
        ['<Tab>'] = {
            function(cmp)
                if cmp.snippet_active() then
                    return cmp.accept()
                else
                    return cmp.select_and_accept()
                end
            end,
            'snippet_forward',
            'fallback',
        },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    },

    signature = {
        enabled = true,
        trigger = {
            show_on_keyword = true,
            show_on_insert = true,
            show_on_accept = true,
        },
    },
    cmdline = {
        completion = { menu = { auto_show = true } },
        keymap = {
            preset = 'none',
            ['<Tab>'] = { 'select_and_accept', 'show', 'fallback' },
            ['<C-n>'] = { 'select_next', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback' },
            ['<C-e>'] = { 'cancel', 'fallback' },
        },
    },
    snippets = { preset = 'luasnip' },

    -- use :BlinkCmp status to view which sources providers are enabled or not enabled
    sources = {
        default = { 'lsp', 'snippets', 'path', 'buffer' },
        providers = {
            -- NOTE: default nets -4 (-1 provider, -3 snippets.score_offset); +5 lands snippets at +1, above lsp
            snippets = { score_offset = 5 },
        },
    },
    completion = {
        list = {
            max_items = 10,
            selection = {
                preselect = false,
                auto_insert = true,
            },
        },
        menu = {
            scrollbar = true,
            draw = {
                columns = {
                    { 'kind_icon' },
                    { 'label', 'label_description', gap = 1 },
                    { 'source_name' },
                },
            },
        },
        documentation = { auto_show = true },
        ghost_text = { enabled = true },
    },
})
