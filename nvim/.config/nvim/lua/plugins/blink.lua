GLOB.timer.start('blink')
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
        ['<C-space>'] = false,
        ['<C-e>'] = { 'show', 'cancel', 'fallback' },
        ['<C-y>'] = { 'select_and_accept', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        ['<C-r>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },

    cmdline = { enabled = false },

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
            path = {
                -- Path completion from cwd instead of current buffer's directory
                opts = { get_cwd = function(_) return vim.fn.getcwd() end },
            },
        },
    },
    completion = {
        list = {
            selection = { preselect = false },
        },
        menu = {
            scrollbar = false,
            draw = {
                treesitter = { 'lsp' },
                columns = {
                    { 'kind_icon' },
                    { 'label', 'label_description', gap = 1 },
                    { 'source_name' },
                },
            },
        },
        documentation = {
            auto_show = true,
            window = {
                border = 'rounded',
            },
        },
        ghost_text = {
            enabled = true,
        },
    },
})
GLOB.timer.stop('blink')
