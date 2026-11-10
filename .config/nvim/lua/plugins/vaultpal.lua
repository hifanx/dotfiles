if vim.g.profile ~= 'sif' then return end
--[[
require('vaultpal').setup({
    roots = nil,
    assets_dir = 'assets',
    keymaps = {},
    cleanup = {
        working_dirs = { '1.Projects', '2.Areas', '3.Resources', '4.Archive' },
        trash = true,
        max_width = 0.6,
        max_height = 0.9,
        excluded = {},
        keymaps = {
            cancel = 'c',
            exclude = 'x',
            confirm = '<CR>',
            open = 'o',
        },
    },
})
]]

vim.g.vaultpal_roots = {
    '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian',
    '~/git/vaultpal.nvim/test/vault',
}

require('vaultpal').setup({
    keymaps = {
        open_home = { '<leader>oh', desc = 'Open Home.md' },
        save_assets = { '<leader>p', desc = 'Paste assets' },
        open_in_obsidian = { '<leader>oo', desc = 'Open in Obsidian' },
        toggle_todo = { '<leader>ot', desc = 'Toggle todo' },
        cleanup = { '<leader>oc', desc = 'Cleanup notes' },
        cleanup_assets = { '<leader>oa', desc = 'Cleanup assets' },
        preview = { 'K', desc = 'Preview attachment or LSP hover' },
    },
})
