return {
  'folke/todo-comments.nvim',
  dependencies = 'nvim-lua/plenary.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function() require('todo-comments').setup() end,
}
-- TODO:
-- INFO:
-- NOTE:
-- WARN:
-- WARNING:
-- XXX:
-- FIX:
-- FIXME:
-- FIXIT:
-- ISSUE:
-- BUG:
-- TEST:
-- TESTING:
-- PASSED:
-- FAILED:
-- PERF:
-- OPTIM:
-- PERFORMANCE:
-- OPTIMIZE:
-- HACK:
