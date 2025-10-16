return {
  'ellisonleao/carbon-now.nvim',
  cmd = 'CarbonNow',
  init = function() vim.keymap.set({ 'n', 'v' }, '<leader>hc', ':CarbonNow<CR>', { desc = 'Screenshot code' }) end,
  config = function() require('carbon-now').setup { open_cmd = 'open' } end,
}
