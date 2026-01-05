local default = {
    'lsp',
    'snippets',
    'path',
    'buffer',
}

local ai = {
    'copilot',
}

if GLOB.is_sif then vim.list_extend(default, ai) end

require('blink.cmp').setup({
    keymap = {
        preset = 'none',
        ['<C-e>'] = { 'show', 'hide', 'fallback' },
        ['<C-y>'] = { 'select_and_accept', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-s>'] = { 'show_signature', 'hide_signature', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
    },

    signature = { enabled = true },
    cmdline = { completion = { menu = { auto_show = true } } },
    snippets = { preset = 'luasnip' },

    -- use :BlinkCmp status to view which sources providers are enabled or not enabled
    sources = {
        default = default,
        providers = {
            copilot = {
                name = 'copilot',
                module = 'blink-copilot',
                score_offset = -10,
                async = true,
                opts = {
                    kind_hl = 'BlinkCmpKindCopilot',
                },
            },
        },
    },
    completion = {
        list = { selection = { preselect = false } },
        menu = {
            scrollbar = false,
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
