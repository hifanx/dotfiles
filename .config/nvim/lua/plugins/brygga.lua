require('brygga').setup()

vim.keymap.set(
    'x',
    '<leader>as',
    ':Brygga send<CR>',
    { desc = 'Send selection to Claude' }
)
