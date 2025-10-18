return {
  'smjonas/inc-rename.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  init = function()
    vim.keymap.set(
      'n',
      '<Leader>r',
      function() return ':IncRename ' .. vim.fn.expand('<cword>') end,
      { desc = 'Inc-[R]ename', expr = true }
    )
  end,
  config = function() require('inc_rename').setup({}) end,
}
