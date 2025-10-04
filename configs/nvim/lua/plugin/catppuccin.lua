-- vim.cmd [[colorscheme catppuccin]]
return {
  "catppuccin/nvim",
  -- enabled = false,
  lazy = false,
  priority = 1000,
  name = "catppuccin",
  opts = function()
    return {
      flavour = "mocha",
      transparent_background = false,
      term_colors = true,

      integrations = {
        mason = true,
        treesitter_context = true,
        which_key = true,
        blink_cmp = true,
        render_markdown = true,
      },
    }
  end,
}
