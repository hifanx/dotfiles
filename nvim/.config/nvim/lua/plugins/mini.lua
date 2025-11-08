return {
  'nvim-mini/mini.nvim',
  cmd = { 'Pick' },
  init = function()
    -- Picker keymaps
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
    -- mini.pick: Fuzzy finder
    require('mini.pick').setup({
      mappings = {
        delete_left = '',
        move_down = '<C-j>',
        move_up = '<C-k>',
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
      },
    })

    -- mini.extra: Extra functionality for mini.pick
    require('mini.extra').setup()

    -- mini.icons: Icon provider
    require('mini.icons').setup()
    ---@diagnostic disable-next-line: undefined-global
    MiniIcons.mock_nvim_web_devicons()

    -- mini.ai: Extended textobjects
    require('mini.ai').setup()

    -- mini.surround: Surround text objects
    -- NORMAL MODE:
    --   sa{motion}{char} - Add surround          | saiw"    | word  -> "word"
    --   sd{char}         - Delete surround       | sd"      | "word" -> word
    --   sr{old}{new}     - Replace surround      | sr"'     | "word" -> 'word'
    --   sf{char}         - Find right surround   | sf)      | moves to next )
    --   sF{char}         - Find left surround    | sF(      | moves to prev (
    --   sh               - Highlight surround    | sh"      | highlights ""
    --
    -- VISUAL MODE:
    --   sa{char}         - Add surround to sel   | V,sa"    | word -> "word"
    --
    -- COMMON CHARS: ( ) [ ] { } < > " ' ` t (tag)
    require('mini.surround').setup()

    -- mini.pairs: Auto-pairs
    require('mini.pairs').setup({
      modes = { command = true },

      -- Better control on whether to pair the symbol or not
      mappings = {
        ['('] = {
          action = 'open',
          pair = '()',
          neigh_pattern = '[^\\][^%w]', -- ✅ Don't pair before word chars
          register = { cr = false },
        },
        ['['] = {
          action = 'open',
          pair = '[]',
          neigh_pattern = '[^\\][^%w]', -- ✅ Don't pair before word chars
          register = { cr = false },
        },
        ['{'] = {
          action = 'open',
          pair = '{}',
          neigh_pattern = '[^\\][^%w]', -- ✅ Don't pair before word chars
          register = { cr = false },
        },

        [')'] = { action = 'close', pair = '()', register = { cr = false } },
        [']'] = { action = 'close', pair = '[]', register = { cr = false } },
        ['}'] = { action = 'close', pair = '{}', register = { cr = false } },

        ['"'] = {
          action = 'closeopen',
          pair = '""',
          neigh_pattern = '[^\\][^%a]', -- Don't pair before letters
          register = { cr = false },
        },
        ["'"] = {
          action = 'closeopen',
          pair = "''",
          neigh_pattern = '[^%a\\][^%a]', -- Don't pair after/before letters
          register = { cr = false },
        },
        ['`'] = {
          action = 'closeopen',
          pair = '``',
          neigh_pattern = '[^\\][^%a]',
          register = { cr = false },
        },
      },
    })
  end,
}
