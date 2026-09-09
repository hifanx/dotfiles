vim.keymap.set('n', '<Leader>d', function() require('mini.bufremove').delete(0, false) end, { desc = 'Delete buffer' })

-- mini.ai: Extended text objects
-- NORMAL/VISUAL MODE:
--   i{obj}  - Inner text object              | dif      | delete inner function
--   a{obj}  - Around text object             | vaf      | select around function
--
-- OBJECTS: f (function call), a (argument), t (tag), q (quote), b/(/[ (brackets)
--          Uppercase variants select including whitespace
require('mini.ai').setup()

-- mini.align: Align text interactively
-- NORMAL/VISUAL MODE:
--   ga{motion} - Align (interactive)         | gaip=    | align paragraph on =
--   gA{motion} - Align with preview          | gAip,    | align paragraph on ,
--
-- MODIFIERS (during interactive align):
--   s  - change Split pattern
--   j  - change Justify side (left/center/right/none)
--   m  - change Merge delimiter
--   f  - filter lines by Lua pattern
--   i  - ignore lines by Lua pattern
--   p  - pair separator
--   t  - trim whitespace
--   <CR> - confirm
require('mini.align').setup()

local statuscolumn = require('mini.statuscolumn')
local spec = {
    { format = 's=l', sep = ' ' },
    { ltype = 'virt', lnum = '·' },
    { ltype = 'wrap', lnum = '↪' },
    { win = 'inactive', fold = '', lnum = '', sign = '', sep = '' },
}
statuscolumn.setup({ content = statuscolumn.gen_content.main(spec) })

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
        { mode = 'n', keys = '<Leader>f', desc = ' ' },
        { mode = 'n', keys = '<Leader>g', desc = ' ' },
        { mode = 'n', keys = '<Leader>h', desc = ' ' },
    },
})
