return {
  {
    -- vim.cmd([[colorscheme catppuccin]])
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha',
        transparent_background = false,
        term_colors = true,
      })
    end,
  },
  {
    -- vim.cmd([[colorscheme ayu]])
    'Shatur/neovim-ayu',
    enabled = false,
    lazy = false,
    priority = 1000,
    config = function() require('ayu').setup({ mirage = true }) end,
  },
  {
    -- vim.cmd([[colorscheme nightingale]])
    'xeind/nightingale.nvim',
    lazy = false,
    priority = 1000,
    config = function() require('nightingale').setup({}) end,
  },
}
