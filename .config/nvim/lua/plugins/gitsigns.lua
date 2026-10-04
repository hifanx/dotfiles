require('gitsigns').setup({
    signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '▎', show_count = true },
        topdelete = { text = '▎', show_count = true },
        changedelete = { text = '▎', show_count = true },
        untracked = { text = '▎' },
    },
    signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '▎', show_count = true },
        topdelete = { text = '▎', show_count = true },
        changedelete = { text = '▎', show_count = true },
        untracked = { text = '▎' },
    },
    count_chars = {
        [1] = '¹',
        [2] = '²',
        [3] = '³',
        [4] = '⁴',
        [5] = '⁵',
        [6] = '⁶',
        [7] = '⁷',
        [8] = '⁸',
        [9] = '⁹',
        ['+'] = '⁺',
    },
    attach_to_untracked = true,
    on_attach = function()
        local gs = require('gitsigns')
        vim.keymap.set('n', ']h', function()
            if vim.wo.diff then
                vim.cmd.normal({ ']c', bang = true })
            else
                gs.nav_hunk('next')
            end
        end, { desc = 'Next hunk' })
        vim.keymap.set('n', '[h', function()
            if vim.wo.diff then
                vim.cmd.normal({ '[c', bang = true })
            else
                gs.nav_hunk('prev')
            end
        end, { desc = 'Prev hunk' })
        vim.keymap.set('n', '<Leader>gr', function() gs.reset_hunk() end, { desc = 'Reset hunk' })
        vim.keymap.set('n', '<Leader>gR', function() gs.reset_buffer() end, { desc = 'Reset buffer' })
        vim.keymap.set('n', '<Leader>gp', function() gs.preview_hunk() end, { desc = 'Preview hunk' })
        vim.keymap.set({ 'n', 'v' }, '<Leader>gs', function() gs.stage_hunk() end, { desc = 'Stage hunk' })
        vim.keymap.set({ 'n', 'v' }, '<Leader>gS', function() gs.stage_buffer() end, { desc = 'Stage buffer' })
        vim.keymap.set('n', '<Leader>gu', function() gs.undo_stage_hunk() end, { desc = 'Undo hunk' })
        vim.keymap.set('n', '<Leader>gb', function() gs.blame_line() end, { desc = 'Blame line' })
        vim.keymap.set('n', '<Leader>gB', function() gs.blame_line({ full = true }) end, { desc = 'Blame buffer' })
        vim.keymap.set('n', '<Leader>gd', function() gs.diffthis() end, { desc = 'Git Diff' })
        vim.keymap.set('n', '<Leader>gt', function() gs.toggle_current_line_blame() end, { desc = 'Toggle line blame' })
    end,
})
