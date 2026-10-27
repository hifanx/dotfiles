--[[
Setup options and defaults
{
    roots = { '/path/to/vault' }, -- REQUIRED: nonempty list; no default on any OS.
    assets_dir = 'assets',       -- Vault-relative attachment directory.
    keymaps = {},                -- No default global mappings.
    cleanup = {
        -- Protection directories: these and their linked notes protect root notes.
        -- A supplied nonempty list REPLACES these defaults; every directory must exist.
        working_dirs = { '1.Projects', '2.Areas', '3.Resources', '4.Archive' },
        trash = true,            -- false permanently deletes reviewed files.
        excluded = {},           -- Extra exact vault-relative paths, not globs.
                                 -- Always also protects Home.md, AGENTS.md, CLAUDE.md.
        keymaps = {              -- Buffer-local review controls, not global mappings.
            cancel = 'c',
            exclude = 'x',
            confirm = '<CR>',
            open = 'o',
        },
    },
}
]]
require('vaultpal').setup({
    roots = {
        '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian',
        '~/git/vaultpal.nvim/test/vault',
    },
    cleanup = {
        working_dirs = {
            '1.Projects',
            '2.Areas',
            '3.Resources',
            '4.Archive',
        },
        trash = true,
    },
    keymaps = {
        open_home = { '<leader>oh', desc = 'Open Home.md' },
        save_assets = { '<leader>p', desc = 'Paste assets' },
        open_in_obsidian = { '<leader>oo', desc = 'Open in Obsidian' },
        toggle_todo = { '<leader>ot', desc = 'Toggle todo' },
        cleanup = { '<leader>oc', desc = 'Cleanup notes' },
        cleanup_assets = { '<leader>oa', desc = 'Cleanup assets' },
    },
})

vim.api.nvim_set_hl(0, 'VaultpalHelpKey', { link = 'Special' })
vim.api.nvim_set_hl(0, 'VaultpalHelpText', { link = 'Comment' })
vim.api.nvim_set_hl(0, 'VaultpalSummary', { link = 'WarningMsg' })
vim.api.nvim_set_hl(
    0,
    'VaultpalExcluded',
    vim.tbl_extend(
        'force',
        vim.api.nvim_get_hl(0, { name = 'Comment', link = false }),
        { strikethrough = true }
    )
)
