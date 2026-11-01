vim.keymap.set('n', '<leader>ac', ':Herdr comment<CR>', { desc = 'Comment' })
vim.keymap.set(
    'x',
    '<leader>ac',
    function() require('herdr-nvim').comment_selection() end,
    { desc = 'Comment' }
)
vim.keymap.set('n', '<leader>al', ':Herdr list<CR>', { desc = 'List comments' })
vim.keymap.set('n', '<leader>as', ':Herdr send<CR>', { desc = 'Send comments' })
vim.keymap.set(
    'n',
    '<leader>aS',
    ':Herdr submit<CR>',
    { desc = 'Submit comments' }
)
vim.keymap.set(
    'n',
    '<leader>ar',
    ':Herdr ref<CR>',
    { desc = 'Reference comments' }
)
require('herdr-nvim').setup({ keymaps = false })
