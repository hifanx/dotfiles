return {
  {
    'nvim-mini/mini.pick',
    cmd = { 'Pick' },
    dependencies = {
      {
        'nvim-mini/mini.extra',
        config = function() require('mini.extra').setup() end,
      },
    },
    init = function()
      vim.keymap.set('n', '<leader>ff', ':Pick files<CR>', { desc = '[F]iles' })
      vim.keymap.set('n', '<leader>fg', ':Pick grep_live<CR>', { desc = '[G]rep live' })
      vim.keymap.set('n', '<leader>fh', ':Pick help<CR>', { desc = '[H]elp' })
      vim.keymap.set('n', '<leader>fH', ':Pick hl_groups<CR>', { desc = '[H]ighlights' })
      vim.keymap.set('n', '<leader><space>', ':Pick resume<CR>', { desc = '[H]elp' })
      vim.keymap.set('n', '<leader>fi', ':Nerdy<CR>', { desc = '[I]con' })
      vim.keymap.set('n', '<leader>fc', ':Pick commands<CR>', { desc = '[C]ommands' })
      vim.keymap.set('n', '<leader>fC', ':Pick colorschemes<CR>', { desc = '[C]olorschemes' })
      vim.keymap.set('n', '<leader>fk', ':Pick keymaps<CR>', { desc = '[K]eymaps' })
      vim.keymap.set('n', '<leader>fm', ':Pick marks<CR>', { desc = '[M]arks' })
      vim.keymap.set('n', '<leader>fo', ':Pick options<CR>', { desc = '[O]ptions' })
      vim.keymap.set('n', '<leader>fb', ':Pick buf_lines<CR>', { desc = '[B]uffer lines' })
      vim.keymap.set('n', '<leader>fd', ':Pick diagnostic<CR>', { desc = '[D]iagnostics' })
      vim.keymap.set('n', '<leader>e', ':Pick explorer<CR>', { desc = '[E]xplorer' })
      vim.keymap.set('n', '<leader>gc', ':Pick git_commits<CR>', { desc = '[G]it [c]ommits' })
      vim.keymap.set('n', '<leader>gh', ':Pick git_hunks<CR>', { desc = '[G]it [h]unks' })
      vim.keymap.set('n', '<leader>fq', ':Pick list scope="quickfix"<CR>', { desc = '[Q]ickfix' })
      vim.keymap.set('n', '<leader>fl', ':Pick list scope="location-list"<CR>', { desc = '[L]oclist' })
      vim.keymap.set('n', '<leader>fj', ':Pick list scope="jumplist"<CR>', { desc = '[J]umplist' })
    end,
    config = function()
      require('mini.pick').setup({
        -- NOTE: commented out because they are defaults
        mappings = {
          -- caret_left = '<Left>',
          -- caret_right = '<Right>',
          -- choose = '<CR>',
          -- choose_in_split = '<C-s>',
          -- choose_in_tabpage = '<C-t>',
          -- choose_in_vsplit = '<C-v>',
          -- choose_marked = '<M-CR>',
          -- delete_char = '<BS>',
          -- delete_char_right = '<Del>',
          -- delete_left = '<C-u>',
          -- delete_word = '<C-w>',
          -- mark = '<C-x>',
          -- mark_all = '<C-a>',
          move_down = '<C-j>',
          -- move_start = '<C-g>',
          move_up = '<C-k>',
          -- paste = '<C-r>',
          -- refine = '<C-Space>',
          -- refine_marked = '<M-Space>',
          scroll_down = '<C-d>',
          -- scroll_left = '<C-h>',
          -- scroll_right = '<C-l>',
          scroll_up = '<C-u>',
          -- stop = '<Esc>',
          -- toggle_info = '<S-Tab>',
          -- toggle_preview = '<Tab>',
        },
      })
    end,
  },
  {
    'nvim-mini/mini.icons',
    config = function()
      require('mini.icons').setup()
      ---@diagnostic disable-next-line: undefined-global
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
}
