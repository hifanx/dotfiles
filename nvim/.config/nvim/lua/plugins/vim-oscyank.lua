return {
  "ojroques/vim-oscyank",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<Leader>y", "<Plug>OSCYankOperator", mode = "n", desc = "OSC[Y]ank" },
    { "<Leader>y", "<Plug>OSCYankVisual", mode = "v", desc = "OSC[Y]ank Visual" },
  },
}
