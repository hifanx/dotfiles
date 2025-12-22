vim.keymap.set('n', '<C-x>', function() require('mini.bufremove').delete() end, { desc = 'Delete buffer' })

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
