return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('gitsigns').setup {
      {
        signs = {
          add = { text = '▎' },
          change = { text = '▎' },
          delete = { text = '' },
          topdelete = { text = '' },
          changedelete = { text = '▎' },
          untracked = { text = '▎' },
        },
        signs_staged = {
          add = { text = '▎' },
          change = { text = '▎' },
          delete = { text = '' },
          topdelete = { text = '' },
          changedelete = { text = '▎' },
        },
        on_attach = function()
          local gs = require 'gitsigns'
          local m = require('core.utils').map
          m('n', ']h', function()
            if vim.wo.diff then
              vim.cmd.normal { ']c', bang = true }
            else
              gs.nav_hunk 'next'
            end
          end, { desc = 'Next Hunk' })
          m('n', '[h', function()
            if vim.wo.diff then
              vim.cmd.normal { '[c', bang = true }
            else
              gs.nav_hunk 'prev'
            end
          end, { desc = 'Prev Hunk' })
          m('n', '<Leader>gr', function() gs.reset_hunk() end, { desc = '[R]eset Hunk' })
          m('n', '<Leader>gR', function() gs.reset_buffer() end, { desc = '[R]eset Buffer' })
          m('n', '<Leader>gp', function() gs.preview_hunk() end, { desc = '[P]review Hunk' })
          m({ 'n', 'v' }, '<Leader>gs', function() gs.stage_hunk() end, { desc = '[S]tage Hunk' })
          m({ 'n', 'v' }, '<Leader>gS', function() gs.stage_buffer() end, { desc = '[S]tage Buffer' })
          m('n', '<Leader>gu', function() gs.undo_stage_hunk() end, { desc = '[U]ndo Hunk' })
          -- m("n", "<Leader>gb", function() gs.blame_line() end, { desc = "[B]lame Line" }) -- NOTE: use snacks
          -- m("n", "<Leader>gB", function() gs.blame_line { full = true } end, { desc = "[B]lame Buffer" }) -- NOTE: conflict with snacks
          m('n', '<Leader>gD', function() gs.diffthis() end, { desc = '[G]it [D]iff' })
          m('n', '<Leader>gt', function() gs.toggle_current_line_blame() end, { desc = '[T]oggle Line Blame' })
        end,
      },
    }
  end,
}
