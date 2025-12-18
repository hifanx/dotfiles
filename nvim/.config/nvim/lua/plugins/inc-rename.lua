GLOB.timer.start('inc_rename')
vim.keymap.set(
    'n',
    '<Leader>r',
    function() return ':IncRename ' .. vim.fn.expand('<cword>') end,
    { desc = 'Inc-[R]ename', expr = true }
)

require('inc_rename').setup({})
GLOB.timer.stop('inc_rename')
