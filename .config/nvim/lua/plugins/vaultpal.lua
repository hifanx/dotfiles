if vim.g.profile ~= 'sif' then return end
--[[ vaultpal comes with the following defaults (lists replace, never merge):
require('vaultpal').setup({
    roots = {},                -- the vault roots
    assets_dir = 'assets',     -- the assets folder, relative to each vault root
    toggle_todo = '<CR>',      -- buffer-local key in vault files; false disables
    keymaps = {                -- { lhs, desc? } each, or false; set only when Nvim starts in a vault
        open_home = false,
        open_in_obsidian = false,
        cleanup_notes = false,
        cleanup_assets = false,
        preview = false,
        paste_assets = false,
    },
    cleanup = {
        working_dirs = { '1.Projects', '2.Areas', '3.Resources', '4.Archive' }, -- folders of hub notes
        trash = true,          -- true: move to the macOS Trash; false: delete permanently
        excluded = { 'AGENTS.md', 'CLAUDE.md', 'README.md' }, -- vault-relative paths kept by both cleanups
        max_width = 0.6,       -- review width cap, fraction of 'columns'
        max_height = 0.9,      -- review height cap, fraction of the editor height
        keymaps = {            -- keys in the review
            exclude = '<Space>',
            open = 'o',
            cancel = 'q',
            confirm = '<CR>',
        },
    },
})
]]

require('vaultpal').setup({
    roots = {
        '~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Obsidian',
        '/Volumes/Code/vp-vault',
    },
    keymaps = {
        open_home = { '<leader>oh', 'Open Home.md' },
        open_in_obsidian = { '<leader>oo', 'Open in obsidian' },
        paste_assets = { '<leader>p', 'Paste assets' },
        cleanup_assets = { '<leader>oa', 'Cleanup assets' },
        cleanup_notes = { '<leader>oc', 'Cleanup notes' },
        preview = { 'K', 'Preview' },
    },
})
