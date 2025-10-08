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
    { "<C-h>", "<CMD><C-U>TmuxNavigateLeft<CR>" },
    { "<C-j>", "<CMD><C-U>TmuxNavigateDown<CR>" },
    { "<C-k>", "<CMD><C-U>TmuxNavigateUp<CR>" },
    { "<C-l>", "<CMD><C-U>TmuxNavigateRight<CR>" },
    { "<C-\\>", "<CMD><C-U>TmuxNavigatePrevious<CR>" },
  },
}
