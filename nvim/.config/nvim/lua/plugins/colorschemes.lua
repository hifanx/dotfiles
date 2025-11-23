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
        integrations = {
          gitsigns = true,
          render_markdown = true,
          blink_cmp = { enabled = true, style = 'bordered' },
        },
        color_overrides = {
          mocha = {
            mauve = '#EB6F92',
            lavender = '#CBA6F7',
          },
        },
        custom_highlights = function(c)
          return {
            -- syntax
            Boolean = { fg = c.pink },
            -- default highlights
            Folded = { link = 'MoreMsg' },
            PmenuSel = { fg = c.base, bg = c.green },
            FloatBorder = { fg = c.yellow },
            FloatTitle = { fg = c.yellow },
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
            -- snacks
            SnacksInputNormal = { link = 'NormalFloat' },
            SnacksInputBorder = { link = 'FloatBorder' },
            SnacksInputTitle = { link = 'FloatTitle' },
            SnacksInputIcon = { link = 'DiagnosticWarn' },
            SnacksPickerCursorLine = { link = 'PmenuSel' },
            SnacksPickerListCursorLine = { link = 'PmenuSel' },
            SnacksPickerPreviewCursorLine = { link = 'PmenuSel' },
            SnacksPickerInputCursorLine = { link = 'NormalFloat' },
          }
        end,
      })
      vim.cmd([[colorscheme catppuccin]])
    end,
  },
}
