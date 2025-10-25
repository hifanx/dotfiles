local M = {}

local bg_normal = GLOB.get_hl_value('Normal', 'bg')

-- NOTE: ⬇️ linking logic: plugin => default_hl

M.default_hl = {
  MsgSeparator = { link = 'NonText' },
  Folded = { link = 'MoreMsg' },
}

M.render_markdown = {
  RenderMarkdownH1Bg = { bg = bg_normal },
  RenderMarkdownH2Bg = { bg = bg_normal },
  RenderMarkdownH3Bg = { bg = bg_normal },
  RenderMarkdownH4Bg = { bg = bg_normal },
  RenderMarkdownH5Bg = { bg = bg_normal },
  RenderMarkdownH6Bg = { bg = bg_normal },
  RenderMarkdownCode = { bg = bg_normal },
  RenderMarkdownTableRow = { link = 'DiagnosticWarn' },
  RenderMarkdownTableHead = { link = 'DiagnosticError' },
}

return M
