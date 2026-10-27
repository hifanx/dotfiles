vim.keymap.set(
    'n',
    '<leader>d',
    function() require('mini.bufremove').delete(0, false) end,
    { desc = 'Delete buffer' }
)

-- mini.ai: Extended text objects
-- NORMAL/VISUAL MODE:
--   i{obj}  - Inner text object              | dif      | delete inner function
--   a{obj}  - Around text object             | vaf      | select around function
--
-- OBJECTS: f (function call), a (argument), t (tag), q (quote), b/(/[ (brackets)
--          Uppercase variants select including whitespace
require('mini.ai').setup()

local statuscolumn = require('mini.statuscolumn')
local spec = {
    { format = 's=l', sep = ' ' },
    { ltype = 'virt', lnum = '·' },
    { ltype = 'wrap', lnum = '↪' },
    { win = 'inactive', fold = '', lnum = '', sign = '', sep = '' },
}
statuscolumn.setup({ content = statuscolumn.gen_content.main(spec) })

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
        { mode = 'n', keys = '<leader>o', desc = ' ' },
    },
})

require('mini.input').setup()
