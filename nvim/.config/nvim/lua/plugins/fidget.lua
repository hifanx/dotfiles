return {
  'j-hui/fidget.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  init = function() vim.keymap.set('n', '<leader>hf', ':Fidget history<CR>', { desc = '[F]idget history' }) end,
  config = function()
    require('fidget').setup({
      notification = {
        filter = vim.log.levels.DEBUG,
        override_vim_notify = true,
      },
    })
  end,
}
