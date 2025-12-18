GLOB.timer.start('persistence')
vim.keymap.set('n', '<leader>s', function() require('persistence').load() end, { desc = 'Restore [s]ession' })
vim.keymap.set('n', '<leader>S', function() require('persistence').select() end, { desc = 'Select [s]ession' })

require('persistence').setup()
GLOB.timer.stop('persistence')
