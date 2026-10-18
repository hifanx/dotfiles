require('herdr-nvim').setup({ keymaps = false })
vim.keymap.set('n', '<leader>hc', ':Herdr comment<CR>', { desc = 'Comment' })
vim.keymap.set(
    'x',
    '<leader>hc',
    function() require('herdr-nvim').comment_selection() end,
    { desc = 'Comment' }
)
vim.keymap.set('n', '<leader>hl', ':Herdr list<CR>', { desc = 'List comments' })
vim.keymap.set('n', '<leader>hs', ':Herdr send<CR>', { desc = 'Send comments' })
vim.keymap.set(
    'n',
    '<leader>hS',
    ':Herdr submit<CR>',
    { desc = 'Submit comments' }
)
vim.keymap.set(
    'n',
    '<leader>hr',
    ':Herdr ref<CR>',
    { desc = 'Reference comments' }
)
