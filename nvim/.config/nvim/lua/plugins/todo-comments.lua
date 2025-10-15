return {
  'folke/todo-comments.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function() require('todo-comments').setup() end,
}
-- TODO:
-- WARN:
-- FIX:
-- TEST:
-- INFO:
-- PERF:
-- HACK:
