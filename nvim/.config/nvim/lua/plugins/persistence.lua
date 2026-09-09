vim.keymap.set('n', '<leader>s', function() require('persistence').load() end, { desc = 'Restore session' })
vim.keymap.set('n', '<leader>S', function() require('persistence').select() end, { desc = 'Select session' })

require('persistence').setup()
