vim.keymap.set(
    'n',
    '<Leader>r',
    function() return ':IncRename ' .. vim.fn.expand('<cword>') end,
    { desc = 'Inc-Rename', expr = true }
)

require('inc_rename').setup({})
