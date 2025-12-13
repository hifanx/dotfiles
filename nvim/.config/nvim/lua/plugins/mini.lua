return {
  'nvim-mini/mini.nvim',
  event = { 'VeryLazy' },
  config = function()
    require('mini.icons').setup()
    --- @diagnostic disable-next-line: undefined-global
    MiniIcons.mock_nvim_web_devicons()
    require('mini.ai').setup()
    require('mini.align').setup()

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
