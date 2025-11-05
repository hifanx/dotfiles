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
        styles = {
          comments = { 'italic' },
          keywords = { 'italic' },
        },
        float = {
          solid = true,
        },
        lsp_styles = {
          inlay_hints = {
            background = false,
          },
        },
      })
      -- vim.cmd([[colorscheme catppuccin]])
    end,
  },
  {
    'rebelot/kanagawa.nvim',
    cond = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('kanagawa').setup({
        theme = 'wave', -- dragon, lotus, wave
        commentStyle = { italic = true },
        keywordStyle = { italic = true },
      })
      -- vim.cmd([[colorscheme kanagawa]])
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
  {
    'folke/tokyonight.nvim',
    cond = false,
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        style = 'night',
      })
      -- vim.cmd([[colorscheme tokyonight]])
    end,
  },
  {
    'rose-pine/neovim',
    cond = false,
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function()
      require('rose-pine').setup({
        variant = 'auto', -- auto, main, moon, or dawn
        dark_variant = 'main', -- main, moon, or dawn
        styles = {
          bold = true,
          italic = true,
          transparency = false,
        },
      })
      -- vim.cmd([[colorscheme rose-pine]])
    end,
  },
  {
    'sainnhe/everforest',
    cond = false,
    lazy = false,
    priority = 1000,
    -- config = function()
    --   vim.g.everforest_background = 'hard'
    --   vim.g.everforest_enable_italic = true
    --   vim.g.everforest_float_style = 'dim'
    --   vim.g.everforest_diagnostic_text_highlight = true
    --   vim.g.everforest_diagnostic_virtual_text = 'colored'
    --   vim.cmd([[color everforest]])
    -- end,
  },
}
