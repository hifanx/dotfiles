vim.keymap.set('n', '<leader>hf', ':Fidget history<CR>', { desc = '[F]idget history' })
require('fidget').setup({
    notification = {
        filter = vim.log.levels.DEBUG,
        override_vim_notify = true,
    },
})
