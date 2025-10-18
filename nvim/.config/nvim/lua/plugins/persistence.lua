return {
  'folke/persistence.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  init = function()
    vim.keymap.set(
      'n',
      '<leader>s',
      function() require('persistence').load() end,
      { desc = 'Restore [S]ession' }
    )
    vim.keymap.set(
      'n',
      '<leader>S',
      function() require('persistence').select() end,
      { desc = 'Select [S]ession' }
    )
  end,
  config = function() require('persistence').setup() end,
}
