return {
  'sphamba/smear-cursor.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function() require('smear_cursor').setup() end,
}
