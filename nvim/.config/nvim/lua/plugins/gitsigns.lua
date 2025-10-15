return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('gitsigns').setup {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '', show_count = true },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '', show_count = true },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
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
      on_attach = function()
        local gs = require 'gitsigns'
        vim.keymap.set('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gs.nav_hunk 'next'
          end
        end, { desc = 'Next Hunk' })
        vim.keymap.set('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gs.nav_hunk 'prev'
          end
        end, { desc = 'Prev Hunk' })
        vim.keymap.set('n', '<Leader>gr', function() gs.reset_hunk() end, { desc = '[R]eset Hunk' })
        vim.keymap.set('n', '<Leader>gR', function() gs.reset_buffer() end, { desc = '[R]eset Buffer' })
        vim.keymap.set('n', '<Leader>gp', function() gs.preview_hunk() end, { desc = '[P]review Hunk' })
        vim.keymap.set({ 'n', 'v' }, '<Leader>gs', function() gs.stage_hunk() end, { desc = '[S]tage Hunk' })
        vim.keymap.set({ 'n', 'v' }, '<Leader>gS', function() gs.stage_buffer() end, { desc = '[S]tage Buffer' })
        vim.keymap.set('n', '<Leader>gu', function() gs.undo_stage_hunk() end, { desc = '[U]ndo Hunk' })
        -- vim.keymap.set('n', '<Leader>gb', function() gs.blame_line() end, { desc = '[B]lame Line' }) -- NOTE: use snacks
        -- vim.keymap.set('n', '<Leader>gB', function() gs.blame_line { full = true } end, { desc = '[B]lame Buffer' }) -- NOTE: conflict with snacks
        vim.keymap.set('n', '<Leader>gD', function() gs.diffthis() end, { desc = '[G]it [D]iff' })
        vim.keymap.set(
          'n',
          '<Leader>gt',
          function() gs.toggle_current_line_blame() end,
          { desc = '[T]oggle Line Blame' }
        )
      end,
    }
  end,
}
