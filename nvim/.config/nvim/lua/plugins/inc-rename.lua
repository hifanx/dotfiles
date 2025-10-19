return {
  'smjonas/inc-rename.nvim',
  event = { 'LspAttach' },
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
