-- vim.cmd [[colorscheme catppuccin]]
return {
  "catppuccin/nvim",
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  opts = {
    flavour = "mocha",
    transparent_background = false,
    term_colors = true,
  },
}
