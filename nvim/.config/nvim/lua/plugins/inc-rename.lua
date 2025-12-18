vim.keymap.set(
    'n',
    '<Leader>r',
    function() return ':IncRename ' .. vim.fn.expand('<cword>') end,
    { desc = 'Inc-[R]ename', expr = true }
)

require('inc_rename').setup({})
