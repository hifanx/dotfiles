return {
  'nvim-mini/mini.nvim',
  event = { 'VeryLazy' },
  lazy = false,
  init = function()
    require('mini.starter').setup()
    vim.keymap.set('n', '<leader>ff', ':Pick files<CR>', { desc = '[F]iles' })
    vim.keymap.set('n', '<leader>fg', ':Pick grep_live<CR>', { desc = '[G]rep live' })
    vim.keymap.set('n', '<leader>fh', ':Pick help<CR>', { desc = '[H]elp' })
    vim.keymap.set('n', '<leader>fH', ':Pick hl_groups<CR>', { desc = '[H]ighlights' })
    vim.keymap.set('n', '<leader><space>', ':Pick resume<CR>', { desc = 'Resume' })
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
    vim.keymap.set('n', '<leader>fr', ':Pick registers<CR>', { desc = '[R]egisters' })
  end,
  config = function()
    require('mini.pick').setup({
      mappings = {
        delete_left = '',
        move_down = '<C-j>',
        move_up = '<C-k>',
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
      },
    })
    require('mini.extra').setup()
    require('mini.icons').setup()
    ---@diagnostic disable-next-line: undefined-global
    MiniIcons.mock_nvim_web_devicons()
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
    require('mini.pairs').setup({
      modes = { command = true },
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
    local miniclue = require('mini.clue')
    miniclue.setup({
      window = {
        delay = 250,
      },
      triggers = {
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },
        { mode = 'i', keys = '<C-x>' },
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },
        { mode = 'n', keys = '<C-w>' },
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
      },
      clues = {
        miniclue.gen_clues.square_brackets(),
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
        { mode = 'n', keys = '<Leader>f', desc = '[F]ind' },
        { mode = 'n', keys = '<Leader>g', desc = '[G]it' },
        { mode = 'n', keys = '<Leader>h', desc = '[H]elper' },
        { mode = 'n', keys = '<Leader>l', desc = '[L]sp' },
      },
    })
  end,
}
