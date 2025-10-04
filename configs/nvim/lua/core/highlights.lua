local M = {}

local c = require("core.palette").catppuccin

-- NOTE:
--       NormalFloat = { fg = c.lavender, bg = c.crust },
--       FloatBorder = { fg = c.crust, bg = c.crust },
--       FloatTitle = { fg = c.lavender, bg = c.crust },
--       NonText = { fg = c.surface0 },

M.mini = {
  MiniFilesTitleFocused = { fg = c.yellow, bold = true },
  MiniFilesCursorLine = { fg = c.mantle, bg = c.green, bold = true },
  MiniPickIconFile = {},
  MiniPickIconDirectory = {},
}

M.telescope = {
  TelescopeBorder = { fg = c.surface1 },
  TelescopeMatching = { fg = c.yellow },
  TelescopeNormal = { bg = c.mantle },
  TelescopePreviewNormal = { bg = c.crust },
  TelescopePreviewTitle = { fg = c.base, bg = c.blue },
  TelescopePreviewBorder = { fg = c.crust, bg = c.crust },
  TelescopePromptBorder = { fg = c.mantle, bg = c.mantle },
  TelescopePromptNormal = { fg = c.lavender, bg = c.mantle },
  TelescopePromptPrefix = { fg = c.red },
  TelescopePromptTitle = { fg = c.mantle, bg = c.red },
  TelescopeResultsNormal = { fg = c.lavender, bg = c.crust },
  TelescopeResultsBorder = { fg = c.crust, bg = c.crust },
  TelescopeResultsTitle = { fg = c.mantle, bg = c.green },
  TelescopeResultsLineNr = { fg = c.text, bg = c.green },
  TelescopeSelection = { fg = c.base, bg = c.green },
  TelescopeSelectionCaret = { fg = c.base, bg = c.green },
}

M.lsp = {
  LspBorder = { fg = c.crust, bg = c.crust },
  LspInfoBorder = { fg = c.crust, bg = c.crust },
}

M.render_markdown = {
  RenderMarkdownH1Bg = { fg = c.red, bg = c.base, bold = true, italic = true },
  RenderMarkdownH2Bg = { fg = c.peach, bg = c.base, bold = true, italic = true },
  RenderMarkdownH3Bg = { fg = c.yellow, bg = c.base, bold = true, italic = true },
  RenderMarkdownH4Bg = { fg = c.green, bg = c.base, bold = true, italic = true },
  RenderMarkdownH5Bg = { fg = c.blue, bg = c.base, bold = true, italic = true },
  RenderMarkdownH6Bg = { fg = c.cyan, bg = c.base, bold = true, italic = true },
  RenderMarkdownCode = { bg = c.mantle },
  RenderMarkdownCodeInline = { bg = c.mantle },
}

M.blink = {
  BlinkCmpMenu = { fg = c.lavender, bg = c.crust },
  BlinkCmpMenuBorder = { fg = c.crust, bg = c.crust },
  BlinkCmpMenuSelection = { fg = c.mantle, bg = c.green },
  -- BlinkCmpScrollBarThumb = {fg = , bg = ,},
  -- BlinkCmpScrollBarGutter = {fg = , bg = ,},
  BlinkCmpLabel = { fg = c.lavender },
  -- BlinkCmpLabelDeprecated = {fg = , bg = ,},
  -- BlinkCmpLabelMatch = {fg = , bg = ,},
  -- BlinkCmpLabelDetail = {fg = , bg = ,},
  -- BlinkCmpLabelDescription = {fg = , bg = ,},
  -- BlinkCmpKind = {fg = , bg = ,},
  BlinkCmpSource = { fg = c.pink },
  -- BlinkCmpGhosckstText = {fg = , bg = ,},
  BlinkCmpDoc = { fg = c.lavender, bg = c.mantle },
  BlinkCmpDocBorder = { fg = c.surface1, bg = c.mantle },
  BlinkCmpDocSeparator = { fg = c.surface1, bg = c.mantle },
  -- BlinkCmpDocCursorLine = {fg = , bg = ,},
  BlinkCmpSignatureHelp = { fg = c.lavender, bg = c.mantle },
  BlinkCmpSignatureHelpBorder = { fg = c.mantle, bg = c.mantle },
  -- BlinkCmpSignatureHelpActiveParameter = {fg = , bg = ,},
}

M.snacks = {
  SnacksDashboardFooter = { fg = c.yellow },
  SnacksDashboardHeader = { fg = c.green },
  SnacksDashboardIcon = { fg = c.lavender },
  SnacksDashboardSpecial = { fg = c.peach },
  SnacksDashboardDesc = { fg = c.lavender },
  SnacksDashboardKey = { fg = c.yellow },
}

for _, definitions in pairs(M) do
  for highlight_name, highlight_attrs in pairs(definitions) do
    vim.api.nvim_set_hl(0, highlight_name, highlight_attrs)
  end
end

return M
