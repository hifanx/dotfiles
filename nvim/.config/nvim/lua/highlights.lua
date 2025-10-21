local M = {}

local c = require('palette').catppuccin

M.custom = {
  MenuSelected = { fg = c.mantle, bg = c.green },
  BorderInvisibleMantle = { fg = c.surface1, bg = c.mantle },
  TitleUnified = { fg = c.mantle, bg = c.yellow },
  FoldedUnified = { fg = c.mauve, bg = c.base },
}

M.default = {
  FloatBorder = { link = 'BorderInvisibleMantle' },
  FloatTitle = { link = 'TitleUnified' },
  MsgSeparator = { link = 'NonText' },
  Folded = { link = 'FoldedUnified' },
  PmenuSel = { link = 'MenuSelected' },
}

M.lsp = {
  LspBorder = { link = 'FloatBorder' },
  LspInfoBorder = { link = 'FloatBorder' },
}

M.render_markdown = {
  RenderMarkdownH1Bg = { bg = c.base },
  RenderMarkdownH2Bg = { bg = c.base },
  RenderMarkdownH3Bg = { bg = c.base },
  RenderMarkdownH4Bg = { bg = c.base },
  RenderMarkdownH5Bg = { bg = c.base },
  RenderMarkdownH6Bg = { bg = c.base },
  RenderMarkdownH1 = { fg = c.red },
  RenderMarkdownH2 = { fg = c.peach },
  RenderMarkdownH3 = { fg = c.yellow },
  RenderMarkdownH4 = { fg = c.green },
  RenderMarkdownH5 = { fg = c.sapphire },
  RenderMarkdownH6 = { fg = c.lavender },
  RenderMarkdownCode = { bg = c.base },
  RenderMarkdownTableRow = { link = 'DiagnosticWarn' },
  RenderMarkdownTableHead = { link = 'DiagnosticError' },
}

M.blink = {
  BlinkCmpMenuBorder = { link = 'FloatBorder' },
  BlinkCmpMenuSelection = { link = 'PmenuSel' },
  BlinkCmpSource = { link = 'DiagnosticWarn' },
}

M.snacks = {
  SnacksNotifierMinimal = { bg = c.base, fg = c.lavender },
  SnacksNotifierHistory = { link = 'NormalFloat' },
  SnacksScratchFooter = { link = 'FloatBorder' },
  SnacksScratchDesc = { link = 'FloatTitle' },
  SnacksScratchTitle = { link = 'DiagnosticWarn' },
  SnacksScratchKey = { link = 'FloatTitle' },
  SnacksInputNormal = { link = 'NormalFloat' },
  SnacksInputBorder = { link = 'FloatBorder' },
  SnacksInputTitle = { link = 'FloatTitle' },
  SnacksInputIcon = { link = 'DiagnosticWarn' },
  SnacksPickerCursorLine = { link = 'PmenuSel' },
  SnacksPickerListCursorLine = { link = 'PmenuSel' },
  SnacksPickerPreviewCursorLine = { link = 'PmenuSel' },
  SnacksPickerToggle = { link = 'FloatTitle' },
  SnacksDashboardFooter = { fg = c.green, bg = 'none' },
  SnacksDashboardHeader = { fg = c.yellow, bg = 'none' },
  SnacksDashboardIcon = { fg = c.lavender, bg = 'none' },
  SnacksDashboardDesc = { fg = c.lavender, bg = 'none' },
  SnacksDashboardKey = { fg = c.peach, bg = 'none' },
}

return M
