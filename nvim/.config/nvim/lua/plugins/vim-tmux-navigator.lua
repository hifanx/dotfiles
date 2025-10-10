return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
    "TmuxNavigatorProcessList",
  },
  keys = {
    { "<C-h>", ":<C-U>TmuxNavigateLeft<CR>" },
    { "<C-j>", ":<C-U>TmuxNavigateDown<CR>" },
    { "<C-k>", ":<C-U>TmuxNavigateUp<CR>" },
    { "<C-l>", ":<C-U>TmuxNavigateRight<CR>" },
    { "<C-\\>", ":<C-U>TmuxNavigatePrevious<CR>" },
  },
}
