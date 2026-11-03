if vim.g.colors_name then vim.cmd('hi clear') end
vim.o.termguicolors = true
vim.g.colors_name = 'isekai' -- name used by :colorscheme

local c = require('palette').isekai

-- terminal colors.
vim.g.terminal_color_0 = c.visual
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = c.blue
vim.g.terminal_color_5 = c.purple
vim.g.terminal_color_6 = c.cyan
vim.g.terminal_color_7 = c.text
vim.g.terminal_color_8 = c.comment
vim.g.terminal_color_9 = c.red_bright
vim.g.terminal_color_10 = c.green_bright
vim.g.terminal_color_11 = c.yellow_bright
vim.g.terminal_color_12 = c.blue_bright
vim.g.terminal_color_13 = c.purple_bright
vim.g.terminal_color_14 = c.cyan_bright
vim.g.terminal_color_15 = c.white

local hl = {
    -- :h highlight-default
    ColorColumn = { link = 'CursorLine' },
    Conceal = { link = 'NonText' },
    CurSearch = { bg = c.yellow_bright, fg = c.base },
    Cursor = { bg = c.green_bright, fg = c.base },
    lCursor = { link = 'Cursor' },
    -- CursorIM --> Cursor
    CursorColumn = { link = 'Cursor' },
    CursorLine = { bg = c.cursorline },
    Directory = { fg = c.blue_bright, bold = true },
    DiffAdd = { bg = c.green_diff },
    DiffChange = { bg = c.blue_diff },
    DiffDelete = { fg = c.comment, bg = c.red_diff },
    DiffText = { bg = c.blue_diff },
    DiffTextAdd = { fg = c.green, bg = c.blue_diff },
    -- EndOfBuffer --> NonText
    TermCursor = { link = 'Cursor' },
    OkMsg = { fg = c.green_bright },
    WarningMsg = { fg = c.yellow_bright },
    ErrorMsg = { fg = c.red_bright },
    StderrMsg = { link = 'ErrorMsg' },
    StdoutMsg = { fg = c.subtext },
    WinSeparator = { fg = c.border },
    Folded = { fg = c.comment },
    -- FoldColumn --> SignColumn
    SignColumn = { bg = c.none },
    -- IncSearch --> Cursearch
    -- Substitute --> Search
    LineNr = { fg = c.comment },
    -- LineNrAbove --> LineNr
    -- LineNrBelow --> LineNr
    CursorLineNr = { fg = c.yellow_bright, bold = true },
    -- CursorLineFold --> FoldColumn
    -- CursorLineSign --> SignColumn
    MatchParen = { fg = c.yellow_bright, bold = true },
    -- MCursor --> Visual
    -- MCursorVisual --> Visual
    ModeMsg = { fg = c.blue_bright },
    -- MsgArea --> cleared
    MsgSeparator = { link = 'WinSeparator' },
    MoreMsg = { fg = c.subtext },
    NonText = { fg = c.border },
    Normal = { fg = c.text },
    NormalFloat = { fg = c.text, bg = c.mantle },
    FloatBorder = { fg = c.border, bg = c.mantle },
    FloatShadow = { bg = c.cursorline },
    FloatShadowThrough = { link = 'FloatShadow' },
    -- FloatTitle --> Title
    -- FloatFooter --> FloatTitle
    -- NormalNC --> cleared
    Pmenu = { fg = c.subtext, bg = c.mantle },
    PmenuSel = { fg = c.base, bg = c.green_bright },
    -- PmenuKind --> Pmenu
    -- PmenuKindSel --> PmenuSel
    PmenuExtra = { fg = c.comment },
    -- PmenuExtraSel --> PmenuSel
    -- PmenuSbar --> Pmenu
    PmenuThumb = { bg = c.border },
    PmenuMatch = { fg = c.yellow_bright },
    PmenuMatchSel = { link = 'PmenuMatch' },
    PmenuBorder = { link = 'FloatBorder' },
    -- PmenuShadow --> FloatShadow
    -- PmenuShadowThrough --> FloatShadowThrough
    -- ComplMatchIns --> cleared
    PreInsert = { fg = c.comment },
    -- ComplHint --> NonText
    -- ComplHintMore --> MoreMsg
    Question = { fg = c.subtext },
    QuickFixLine = { fg = c.base, bg = c.green_bright },
    Search = { fg = c.yellow, bold = true },
    -- SnippetTabstop --> Visual
    -- SnippetTabstopActive --> SnippetTabstop
    -- SpecialKey --> Special
    SpellBad = { sp = c.red_bright, undercurl = true },
    SpellCap = { sp = c.yellow_bright, undercurl = true },
    SpellLocal = { sp = c.green_bright, undercurl = true },
    SpellRare = { sp = c.cyan_bright, undercurl = true },
    StatusLine = { bg = c.none },
    StatusLineNC = { bg = c.none },
    -- StatusLineTerm  --> StatusLine
    -- StatusLineTermNC  --> StatusLineNC
    -- TabLine --> TabLineFill
    -- TabLineFill --> StatusLineNC
    TabLineSel = { fg = c.yellow_bright },
    Title = { fg = c.white, bold = true },
    Visual = { bg = c.visual },
    -- VisualNOS --> Visual
    -- Whitespace --> NonText
    -- WildMenu --> PmenuSel
    WinBar = { bg = c.none },
    WinBarNC = { bg = c.none },

    -- :h group-name
    Comment = { fg = c.comment, italic = true },
    Constant = { fg = c.purple },
    String = { fg = c.green },
    -- Character --> Constant
    Number = { fg = c.green },
    Boolean = { fg = c.green },
    -- Regexp --> Constant
    -- Float --> Number
    Identifier = { fg = c.subtext },
    Function = { fg = c.red },
    Statement = { fg = c.blue },
    -- Conditional --> Statement
    -- Repeat --> Statement
    -- Label --> Statement
    Operator = { fg = c.comment },
    -- Keyword --> Statement
    -- Exception --> Statement
    PreProc = { fg = c.orange },
    -- Include --> PreProc
    -- Define --> PreProc
    -- Macro --> PreProc
    -- PreCondit --> PreProc
    Type = { fg = c.yellow },
    -- StorageClass --> Type
    -- Structure --> Type
    -- Typedef --> Type
    Special = { fg = c.purple },
    SpecialChar = { fg = c.green_bright },
    Tag = { fg = c.red },
    Delimiter = { fg = c.comment },
    SpecialComment = { fg = c.green_bright },
    -- Debug --> Special
    -- Underlined --> underline
    -- Bold --> bold
    -- Italic --> italic
    -- BoldItalic --> bold,italic
    -- Dimmed --> Comment
    -- Ignore --> ctermfg=0, guifg=bg
    Error = { fg = c.red_bright, bold = true },
    Todo = { fg = c.yellow_bright, bold = true },
    Added = { fg = c.green_bright },
    Changed = { fg = c.orange_bright },
    Removed = { fg = c.red_bright },

    -- diagnostics
    -- :h diagnostic-highlights
    DiagnosticError = { fg = c.red_bright },
    DiagnosticWarn = { fg = c.yellow_bright },
    DiagnosticInfo = { fg = c.blue_bright },
    DiagnosticHint = { fg = c.purple_bright },
    DiagnosticOk = { fg = c.green_bright },
    -- DiagnosticVirtualTextError --> DiagnosticError
    -- DiagnosticVirtualTextWarn --> DiagnosticWarn
    -- DiagnosticVirtualTextInfo --> DiagnosticInfo
    -- DiagnosticVirtualTextHint --> DiagnosticHint
    -- DiagnosticVirtualTextOk --> DiagnosticOk
    -- DiagnosticVirtualLinesError
    -- DiagnosticVirtualLinesWarn
    -- DiagnosticVirtualLinesInfo
    -- DiagnosticVirtualLinesHint
    -- DiagnosticVirtualLinesOk
    DiagnosticUnderlineError = { sp = c.red_bright, underline = true },
    DiagnosticUnderlineWarn = { sp = c.yellow_bright, underline = true },
    DiagnosticUnderlineInfo = { sp = c.blue_bright, underline = true },
    DiagnosticUnderlineHint = { sp = c.cyan_bright, underline = true },
    DiagnosticUnderlineOk = { sp = c.green_bright, underline = true },
    -- DiagnosticFloatingError --> DiagnosticError
    -- DiagnosticFloatingWarn --> DiagnosticWarn
    -- DiagnosticFloatingInfo --> DiagnosticInfo
    -- DiagnosticFloatingHint --> DiagnosticHint
    -- DiagnosticFloatingOk --> DiagnosticOk
    -- DiagnosticSignError --> DiagnosticError
    -- DiagnosticSignWarn --> DiagnosticWarn
    -- DiagnosticSignInfo --> DiagnosticInfo
    -- DiagnosticSignHint --> DiagnosticHint
    -- DiagnosticSignOk --> DiagnosticOk
    DiagnosticDeprecated = { sp = c.red_bright, strikethrough = true },
    -- DiagnosticUnnecessary --> Comment

    -- treesitter
    -- :h treesitter-highlight-groups

    ['@variable'] = { fg = c.subtext },
    ['@variable.builtin'] = { link = '@variable' },
    -- ['@variable.parameter'] --> @variable
    -- ['@variable.parameter.builtin'] --> Special
    ['@variable.member'] = { link = '@variable' },

    -- ['@constant'] --> Constant
    ['@constant.builtin'] = { link = '@constant' },
    -- ['@constant.macro'] --> Constant

    -- ['@module'] --> Structure
    ['@module.builtin'] = { link = '@module' },
    -- ['@label'] --> Label

    -- ['@string'] --> String
    -- ['@string.documentation'] --> String
    -- ['@string.regexp'] --> @string.special
    -- ['@string.escape'] --> @string.special
    -- ['@string.special'] --> SpecialChar
    -- ['@string.special.symbol'] --> @string.special
    -- ['@string.special.path'] --> @string.special
    ['@string.special.url'] = { fg = c.cyan, underline = true },

    -- ['@character'] --> Character
    -- ['@character.special'] --> SpecialChar

    -- ['@boolean'] --> Boolean
    -- ['@number'] --> Number
    -- ['@number.float'] --> Float

    -- ['@type'] --> Type
    ['@type.builtin'] = { link = 'Type' },
    -- ['@type.definition'] --> Type

    -- ['@attribute'] --> Macro
    ['@attribute.builtin'] = { link = '@attribute' },
    -- ['@property'] --> Identifier

    -- ['@function'] --> Function
    ['@function.builtin'] = { fg = c.red_bright },
    -- ['@function.call'] --> @function
    -- ['@function.macro'] --> @function

    -- ['@function.method'] --> @function
    -- ['@function.method.call'] --> @function

    ['@constructor'] = { fg = c.orange },
    -- ['@operator'] --> Operator

    -- ['@keyword'] --> Keyword
    -- ['@keyword.coroutine'] --> @keyword
    -- ['@keyword.function'] --> @keyword
    -- ['@keyword.operator'] --> @keyword
    -- ['@keyword.import'] --> @keyword
    -- ['@keyword.type'] --> @keyword
    -- ['@keyword.modifier'] --> @keyword
    -- ['@keyword.repeat'] --> @keyword
    ['@keyword.return'] = { fg = c.red_bright },
    -- ['@keyword.debug'] --> @keyword
    -- ['@keyword.exception'] --> @keyword

    -- ['@keyword.conditional'] --> @keyword
    -- ['@keyword.conditional.ternary'] --> @keyword

    -- ['@keyword.directive'] --> @keyword
    -- ['@keyword.directive.define'] --> @keyword

    -- ['@punctuation'] --> Delimiter
    -- ['@punctuation.delimiter'] --> @punctuation
    -- ['@punctuation.bracket'] --> @punctuation
    ['@punctuation.special'] = { link = '@punctuation' },

    -- ['@comment'] --> Comment
    -- ['@comment.documentation'] --> @comment

    -- ['@comment.error'] --> DiagnosticError
    -- ['@comment.warning'] --> DiagnosticWarn
    -- ['@comment.todo'] --> Todo
    -- ['@comment.note'] --> DiagnosticInfo

    -- ['@markup.strong'] --> cterm=bold, gui=bold
    -- ['@markup.italic'] --> cterm=italic, gui=italic
    -- ['@markup.strikethrough'] --> cterm=strikethrough, gui=strikethrough
    -- ['@markup.underline'] --> cterm=underline, gui=underline

    -- ['@markup.heading'] --> Title
    ['@markup.heading.1'] = { fg = c.purple, bold = true, underline = true },
    ['@markup.heading.2'] = { fg = c.blue, bold = true, underline = true },
    ['@markup.heading.3'] = { fg = c.yellow, bold = true, underline = true },
    ['@markup.heading.4'] = { fg = c.green, bold = true, underline = true },
    ['@markup.heading.5'] = { fg = c.orange, bold = true, underline = true },
    ['@markup.heading.6'] = { fg = c.subtext, bold = true, underline = true },

    ['@markup.quote'] = { fg = c.comment, italic = true },
    ['@markup.math'] = { fg = c.cyan },

    ['@markup.link'] = { fg = c.purple },
    ['@markup.link.label'] = { link = '@markup.link' },
    ['@markup.link.url'] = { link = '@markup.link' },

    ['@markup.raw'] = { fg = c.red, bold = true },
    ['@markup.raw.block'] = { bg = c.mantle },

    ['@markup.list'] = { fg = c.subtext },
    ['@markup.list.checked'] = { fg = c.green, strikethrough = true },
    ['@markup.list.unchecked'] = { fg = c.comment },

    -- ['@diff.plus'] --> Added
    -- ['@diff.minus'] --> Removed
    -- ['@diff.delta'] --> Changed

    -- ['@tag'] --> Tag
    ['@tag.builtin'] = { link = '@tag' },
    -- ['@tag.attribute'] --> @tag
    -- ['@tag.delimiter'] --> @tag

    -- language specific
    ['@constructor.lua'] = { link = '@punctuation.bracket' }, -- For constructor calls and definitions: = {} in Lua.

    -- semantic tokens.
    -- :h lsp-semantic-highlight
    ['@lsp.type.variable'] = vim.empty_dict(),
    ['@lsp.typemod.function.defaultLibrary'] = { link = '@function.builtin' },
    ['@lsp.typemod.function.builtin'] = { link = '@function.builtin' },
    ['@lsp.type.decorator.markdown'] = vim.empty_dict(),

    -- render-markdown
    RenderMarkdownH1Bg = { link = '@markup.heading.1' },
    RenderMarkdownH2Bg = { link = '@markup.heading.2' },
    RenderMarkdownH3Bg = { link = '@markup.heading.3' },
    RenderMarkdownH4Bg = { link = '@markup.heading.4' },
    RenderMarkdownH5Bg = { link = '@markup.heading.5' },
    RenderMarkdownH6Bg = { link = '@markup.heading.6' },
    RenderMarkdownCode = { bg = c.mantle },
    RenderMarkdownCodeInline = { fg = c.red },
    RenderMarkdownTableRow = { link = 'WinSeparator' },
    RenderMarkdownTableHead = { link = 'WinSeparator' },

    -- blink
    -- BlinkCmpMenuSelection --> 'PmenuSel'
    BlinkCmpMenuBorder = { link = 'FloatBorder' },
    BlinkCmpDocBorder = { link = 'FloatBorder' },
    BlinkCmpSignatureHelpBorder = { link = 'FloatBorder' },
    BlinkCmpLabelDeprecated = { link = '@markup.strikethrough' },
    BlinkCmpKindMethod = { link = '@function.method' },
    BlinkCmpKindFunction = { link = '@function' },
    BlinkCmpKindConstructor = { link = '@constructor' },
    BlinkCmpKindField = { link = '@variable.member' },
    BlinkCmpKindVariable = { link = '@variable' },
    BlinkCmpKindClass = { link = '@type' },
    BlinkCmpKindInterface = { link = '@type' },
    BlinkCmpKindModule = { link = '@module' },
    BlinkCmpKindProperty = { link = '@property' },
    BlinkCmpKindUnit = { link = '@number' },
    BlinkCmpKindValue = { link = '@constant' },
    BlinkCmpKindEnum = { link = '@type' },
    BlinkCmpKindKeyword = { link = '@keyword' },
    BlinkCmpKindSnippet = { link = '@markup.raw' },
    BlinkCmpKindColor = { link = '@string.special' },
    BlinkCmpKindFile = { link = '@string.special.path' },
    BlinkCmpKindReference = { link = '@markup.link' },
    BlinkCmpKindFolder = { link = '@string.special.path' },
    BlinkCmpKindEnumMember = { link = '@constant' },
    BlinkCmpKindConstant = { link = '@constant' },
    BlinkCmpKindStruct = { link = '@type' },
    BlinkCmpKindEvent = { link = 'Normal' },
    BlinkCmpKindOperator = { link = '@operator' },
    BlinkCmpKindTypeParameter = { link = '@type' },

    -- navic
    NavicIconsFile = { link = '@string.special.path' },
    NavicIconsModule = { link = '@module' },
    NavicIconsNamespace = { link = '@module' },
    NavicIconsPackage = { link = '@module' },
    NavicIconsClass = { link = '@type' },
    NavicIconsMethod = { link = '@function.method' },
    NavicIconsProperty = { link = '@property' },
    NavicIconsField = { link = '@variable.member' },
    NavicIconsConstructor = { link = '@constructor' },
    NavicIconsEnum = { link = '@type' },
    NavicIconsInterface = { link = '@type' },
    NavicIconsFunction = { link = '@function' },
    NavicIconsVariable = { link = '@variable' },
    NavicIconsConstant = { link = '@constant' },
    NavicIconsString = { link = '@string' },
    NavicIconsNumber = { link = '@number' },
    NavicIconsBoolean = { link = '@boolean' },
    NavicIconsArray = { link = '@punctuation.bracket' },
    NavicIconsObject = { link = '@punctuation.bracket' },
    NavicIconsKey = { link = '@property' },
    NavicIconsNull = { link = '@constant.builtin' },
    NavicIconsEnumMember = { link = '@constant' },
    NavicIconsStruct = { link = '@type' },
    NavicIconsEvent = { link = 'Normal' },
    NavicIconsOperator = { link = '@operator' },
    NavicIconsTypeParameter = { link = '@type' },
    NavicText = { link = 'Normal' },
    NavicSeparator = { link = '@punctuation.delimiter' },

    -- lualine
    LuaLineDiffAdd = { link = 'Added' },
    LuaLineDiffChange = { link = 'Changed' },
    LuaLineDiffDelete = { link = 'Removed' },

    -- fzf-lua
    FzfLuaNormal = { link = 'NormalFloat' },
    FzfLuaBorder = { link = 'FloatBorder' },
    FzfLuaTitle = { link = 'FloatTitle' },
}

for group, spec in pairs(hl) do
    vim.api.nvim_set_hl(0, group, spec)
end
