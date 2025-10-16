return {
  'christoomey/vim-tmux-navigator',
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
    'TmuxNavigatorProcessList',
  },
  init = function()
    vim.keymap.set('n', '<C-h>', ':<C-U>TmuxNavigateLeft<CR>')
    vim.keymap.set('n', '<C-j>', ':<C-U>TmuxNavigateDown<CR>')
    vim.keymap.set('n', '<C-k>', ':<C-U>TmuxNavigateUp<CR>')
    vim.keymap.set('n', '<C-l>', ':<C-U>TmuxNavigateRight<CR>')
    vim.keymap.set('n', '<C-\\>', ':<C-U>TmuxNavigatePrevious<CR>')
  end,
}
