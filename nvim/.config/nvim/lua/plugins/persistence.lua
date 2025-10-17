return {
  'folke/persistence.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function() require('persistence').setup() end,
}
