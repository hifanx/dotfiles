return {
  'folke/ts-comments.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function() require('ts-comments').setup() end,
}
