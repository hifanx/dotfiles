return {
  {
    'catppuccin/nvim',
    cond = false,
    lazy = false,
    priority = 1000,
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha',
        transparent_background = false,
        term_colors = true,
      })
      -- vim.cmd([[colorscheme catppuccin]])
    end,
  },
  {
    'Shatur/neovim-ayu',
    cond = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('ayu').setup({ mirage = true })
      -- vim.cmd([[colorscheme ayu]])
    end,
  },
  {
    'xeind/nightingale.nvim',
    cond = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('nightingale').setup({})
      -- vim.cmd([[colorscheme nightingale]])
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    cond = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('kanagawa').setup({
        theme = 'wave',
        commentStyle = { italic = true },
        keywordStyle = { italic = true },
      })
      -- vim.cmd([[colorscheme kanagawa]])
      -- vim.cmd([[colorscheme kanagawa-wave]])
      -- vim.cmd([[colorscheme kanagawa-dragon]])
      -- vim.cmd([[colorscheme kanagawa-lotus]])
    end,
  },
  {
    'EdenEast/nightfox.nvim',
    cond = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('nightfox').setup({})
      -- vim.cmd([[colorscheme nightfox]])
      -- vim.cmd([[colorscheme duskfox]])
      -- vim.cmd([[colorscheme carbonfox]])
    end,
  },
  {
    'projekt0n/github-nvim-theme',
    cond = false,
    name = 'github-theme',
    lazy = false,
    priority = 1000,
    config = function()
      require('github-theme').setup({
        options = {
          styles = {
            comments = 'italic',
            keywords = 'italic',
          },
        },
      })
      -- vim.cmd([[colorscheme github_dark_default]])
      -- vim.cmd([[colorscheme github_dark_tritanopia]])
    end,
  },
  {
    'everviolet/nvim',
    -- cond = false,
    lazy = false,
    name = 'evergarden',
    priority = 1000,
    config = function()
      require('evergarden').setup({
        theme = {
          variant = 'winter', -- 'winter'|'fall'|'spring'|'summer'
          accent = 'skye',
        },
      })
      vim.cmd([[colorscheme evergarden]])
    end,
  },
  {
    'vague-theme/vague.nvim',
    cond = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('vague').setup({
        style = {
          keywords = 'italic',
        },
      })
      -- vim.cmd([[colorscheme vague]])
    end,
  },
}
