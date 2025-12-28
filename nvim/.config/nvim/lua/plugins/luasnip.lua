local ls = require('luasnip')
local types = require('luasnip.util.types')

vim.keymap.set({ 'i', 's' }, '<Tab>', function()
    if ls.jumpable(1) then
        ls.jump(1)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Tab>', true, false, true), 'n', false)
    end
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<S-Tab>', function()
    if ls.jumpable(-1) then
        ls.jump(-1)
    else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<S-Tab>', true, false, true), 'n', false)
    end
end, { silent = true })

vim.keymap.set({ 'i', 's' }, '<C-c>', function()
    if ls.expandable() then
        ls.expand()
    elseif ls.choice_active() then
        ls.change_choice(1)
    end
end, { silent = true })

ls.setup({
    update_events = { 'TextChanged', 'TextChangedI' },
    delete_check_events = 'TextChanged',
    enable_autosnippets = true,
    ext_opts = {
        [types.insertNode] = {
            unvisited = {
                virt_text = { { '◌', 'LspInlayHint' } },
                virt_text_pos = 'inline',
            },
        },
        [types.exitNode] = {
            unvisited = {
                virt_text = { { '◌', 'LspInlayHint' } },
                virt_text_pos = 'inline',
            },
        },
        [types.choiceNode] = {
            active = {
                virt_text = { { '<-- choice node', 'LspInlayHint' } },
            },
        },
    },
})

require('luasnip.loaders.from_lua').lazy_load({
    paths = vim.fn.stdpath('config') .. '/snippets',
})
