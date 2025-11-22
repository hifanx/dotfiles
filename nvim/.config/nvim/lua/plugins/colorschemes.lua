return {
  {
    'catppuccin/nvim',
    lazy = false,
    priority = 1000,
    name = 'catppuccin',
    config = function()
      require('catppuccin').setup({
        flavour = 'mocha',
        default_integrations = false,
        transparent_background = false,
        term_colors = true,
        styles = {
          comments = { 'italic' },
          keywords = { 'italic' },
        },
        lsp_styles = {
          inlay_hints = {
            background = false,
          },
        },
        color_overrides = {
          mocha = {
            mauve = '#E06C75',
            lavender = '#C0CAF5',
          },
        },
        custom_highlights = function(c)
          return {
            -- default highlights
            Folded = { link = 'MoreMsg' },
            PmenuSel = { fg = c.base, bg = c.green },
            -- render-markdown
            RenderMarkdownH1Bg = { bg = c.base },
            RenderMarkdownH2Bg = { bg = c.base },
            RenderMarkdownH3Bg = { bg = c.base },
            RenderMarkdownH4Bg = { bg = c.base },
            RenderMarkdownH5Bg = { bg = c.base },
            RenderMarkdownH6Bg = { bg = c.base },
            RenderMarkdownTableRow = { link = 'DiagnosticWarn' },
            RenderMarkdownTableHead = { link = 'DiagnosticError' },
            -- blink
            BlinkCmpMenuSelection = { link = 'PmenuSel' },
          }
        end,
      })
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
}
