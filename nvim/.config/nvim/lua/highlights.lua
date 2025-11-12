local M = {}

local bg_normal = GLOB.get_hl_value('Normal', 'bg')
local bg_ok = GLOB.get_hl_value('OkMsg', 'fg')

-- NOTE: ⬇️ linking logic: plugin => default_hl

M.default_hl = {
  MsgSeparator = { link = 'WinSeparator' },
  Folded = { link = 'MoreMsg' },
  PmenuSel = { fg = bg_normal, bg = bg_ok },
}

M.render_markdown = {
  RenderMarkdownH1Bg = { bg = bg_normal },
  RenderMarkdownH2Bg = { bg = bg_normal },
  RenderMarkdownH3Bg = { bg = bg_normal },
  RenderMarkdownH4Bg = { bg = bg_normal },
  RenderMarkdownH5Bg = { bg = bg_normal },
  RenderMarkdownH6Bg = { bg = bg_normal },
  RenderMarkdownTableRow = { link = 'DiagnosticWarn' },
  RenderMarkdownTableHead = { link = 'DiagnosticError' },
}

M.mini = {
  MiniPickMatchCurrent = { link = 'PmenuSel' },
}

return M
