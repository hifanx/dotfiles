return {
  'smjonas/inc-rename.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    {
      '<Leader>r',
      function() return ':IncRename ' .. vim.fn.expand '<cword>' end,
      desc = 'Inc-[R]ename',
      expr = true,
    },
  },
  config = function() require('inc_rename').setup {} end,
}
