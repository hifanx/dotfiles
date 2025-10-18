return {
  'max397574/better-escape.nvim',
  event = 'InsertEnter',
  main = 'better_escape',
  config = function() require('better_escape').setup({}) end,
}
