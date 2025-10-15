return {
  'ellisonleao/carbon-now.nvim',
  cmd = 'CarbonNow',
  keys = {
    { '<leader>hc', ':CarbonNow<CR>', mode = { 'n', 'v' }, desc = 'Screenshot code' },
  },
  config = function() require('carbon-now').setup { open_cmd = 'open' } end,
}
