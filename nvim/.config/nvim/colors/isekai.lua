if vim.g.colors_name then vim.cmd('hi clear') end
vim.o.termguicolors = true
vim.g.colors_name = 'isekai' -- name used by :colorscheme

local c = { -- yanked from catppuccin
  none = 'NONE',
  rosewater = '#F5E0DC',
  flamingo = '#F2CDCD',
  pink = '#F5C2E7',
  mauve = '#CBA6F7',
  red = '#F38BA8',
  maroon = '#EBA0AC',
  peach = '#FAB387',
  yellow = '#F9E2AF',
  green = '#A6E3A1',
  teal = '#94E2D5',
  sky = '#89DCEB',
  sapphire = '#74C7EC',
  blue = '#89B4FA',
  lavender = '#B4BEFE',
  text = '#CDD6F4',
  subtext1 = '#BAC2DE',
  subtext0 = '#A6ADC8',
  overlay2 = '#9399B2',
  overlay1 = '#7F849C',
  overlay0 = '#6C7086',
  surface2 = '#585B70',
  surface1 = '#45475A',
  surface0 = '#313244',
  base = '#1E1E2E',
  mantle = '#181825',
  crust = '#11111B',
  blue_dark = '#19272C',
  green_dark = '#22372c',
  red_dark = '#342231',
  peach_dark = '#564629',
}

-- terminal colors.
vim.g.terminal_color_0 = c.overlay0
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = c.mauve
vim.g.terminal_color_5 = c.pink
vim.g.terminal_color_6 = c.sapphire
vim.g.terminal_color_7 = c.rosewater
vim.g.terminal_color_8 = c.overlay1
vim.g.terminal_color_9 = c.red
vim.g.terminal_color_10 = c.green
vim.g.terminal_color_11 = c.yellow
vim.g.terminal_color_12 = c.blue
vim.g.terminal_color_13 = c.flamingo
vim.g.terminal_color_14 = c.sky
vim.g.terminal_color_15 = c.rosewater
vim.g.terminal_color_background = c.base
vim.g.terminal_color_foreground = c.text

local hl = {
  -- :h highlight-default
  Normal = { fg = c.text, bg = c.base }, -- normal text
  NormalNC = { fg = c.text, bg = c.base }, -- normal text in non-current windows
  NormalFloat = { fg = c.text, bg = c.mantle }, -- Normal text in floating windows.
  Cursor = { fg = c.bg, bg = c.dan_huang }, -- character under the cursor
  lCursor = { fg = c.bg, bg = c.dan_huang }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
  CursorIM = { fg = c.bg, bg = c.dan_huang }, -- like Cursor, but used when in IME mode |CursorIM|
  CursorColumn = { bg = c.mantle }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
  CursorLine = { bg = c.surface0 }, -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if forecrust (ctermfg OR guifg) is not set.
  CursorLineNr = { fg = c.peach }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line. highlights the number in numberline.
  LineNr = { fg = c.surface1 }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
  SignColumn = { fg = c.surface1 }, -- column where |signs| are displayed
  FoldColumn = { fg = c.overlay0 }, -- 'foldcolumn'
  Folded = { fg = c.blue, bg = c.base }, -- line used for closed folds
  VertSplit = { fg = c.crust }, -- the column separating vertically split windows
  WinSeparator = { fg = c.crust }, -- separator between window splits
  WinBar = { fg = c.rosewater }, -- window bar of current window
  WinBarNC = { link = 'WinBar' }, -- window bar of not-current windows
  FloatBorder = { fg = c.yellow, bg = c.mantle }, -- border of floating windows
  FloatTitle = { fg = c.yellow, bg = c.mantle }, -- Title of floating windows
  Pmenu = { fg = c.overlay2, bg = c.mantle }, -- Popup menu: normal item.
  PmenuSel = { fg = c.mantle, bg = c.green }, -- Popup menu: selected item.
  PmenuMatch = { fg = c.peach }, -- Popup menu: matching text.
  PmenuMatchSel = { bold = true }, -- Popup menu: matching text in selected item; is combined with |hl-PmenuMatch| and |hl-PmenuSel|.
  PmenuSbar = { bg = c.surface0 }, -- Popup menu: scrollbar.
  PmenuThumb = { bg = c.overlay0 }, -- Popup menu: Thumb of the scrollbar.
  PmenuExtra = { fg = c.overlay0 }, -- Popup menu: normal item extra text.
  PmenuExtraSel = { bg = c.surface0, fg = c.overlay0, bold = true }, -- Popup menu: selected item extra text.
  PmenuBorder = { link = 'FloatBorder' }, -- Popup menu: border
  ComplMatchIns = { link = 'PreInsert' }, -- Matched text of the currently inserted completion.
  PreInsert = { fg = c.overlay2 }, -- Text inserted when "preinsert" is in 'completeopt'.
  ComplHint = { fg = c.subtext0 }, -- Virtual text of the currently selected completion.
  ComplHintMore = { link = 'Question' }, -- The additional information of the virtual text.
  Visual = { bg = c.surface2, bold = true }, -- Visual mode selection
  VisualNOS = { link = 'Visual' }, -- Visual mode selection when vim is "Not Owning the Selection".
  MatchParen = { fg = c.peach, bg = c.surface0, bold = true }, -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
  Search = { bg = c.peach, fg = c.mantle }, -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
  CurSearch = { bg = c.red, fg = c.mantle }, -- 'cursearch' highlighting: highlights the current search you're on differently
  Substitute = { bg = c.surface1, fg = c.peach }, -- |:substitute| replacement text highlighting
  DiffAdd = { bg = c.green_dark }, -- diff mode: Added line |diff.txt|
  DiffChange = { bg = c.peach_dark }, -- diff mode: Changed line |diff.txt|
  DiffDelete = { bg = c.red_dark }, -- diff mode: Deleted line |diff.txt|
  DiffText = { fg = c.peach, bg = c.peach_dark }, -- diff mode: Changed text within a changed line |diff.txt|
  DiffTextAdd = { fg = c.green, bg = c.green_dark }, -- diff mode: Added text within a changed line (variant)
  SpellBad = { sp = c.red, undercurl = true }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
  SpellCap = { sp = c.yellow, undercurl = true }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
  SpellLocal = { sp = c.blue, undercurl = true }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
  SpellRare = { sp = c.green, undercurl = true }, -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
  StatusLine = { fg = c.overlay1, bg = c.base }, -- status line of current window
  StatusLineNC = { fg = c.overlay1, bg = c.base }, -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
  TabLine = { bg = c.crust, fg = c.overlay0 }, -- tab pages line, not active tab page label
  TabLineFill = { bg = c.mantle }, -- tab pages line, where there are no labels
  TabLineSel = { link = 'Normal' }, -- tab pages line, active tab page label
  ErrorMsg = { fg = c.red }, -- error messages on the command line
  WarningMsg = { fg = c.yellow }, -- warning messages
  OkMsg = { fg = c.green }, -- success messages
  ModeMsg = { fg = c.yellow, bold = true }, -- 'showmode' message (e.g., "-- INSERT -- ")
  MoreMsg = { fg = c.blue }, -- |more-prompt|
  MsgArea = { bg = c.base }, -- Area for messages and cmdline, don't set this highlight because of https://github.com/neovim/neovim/issues/17832
  MsgSeparator = { link = 'WinSeparator' }, -- Separator for scrolled messages, `msgsep` flag of 'display'
  Question = { fg = c.peach }, -- |hit-enter| prompt and yes/no questions
  NonText = { fg = c.surface2 }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
  EndOfBuffer = { fg = c.overlay0 }, -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
  SpecialKey = { link = 'NonText' }, -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' textspace. |hl-Whitespace|
  Whitespace = { fg = c.surface2 }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
  Conceal = { fg = c.surface1 }, -- placeholder characters substituted for concealed text (see 'conceallevel')
  ColorColumn = { bg = c.mantle }, -- used for the columns set with 'colorcolumn'
  Directory = { fg = c.blue }, -- directory names (and other special names in listings)
  Title = { fg = c.yellow, bold = true }, -- titles for output from ":set all", ":autocmd" etc.
  QuickFixLine = { bg = c.surface2, bold = true }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
  WildMenu = { bg = c.green }, -- current match in 'wildmenu' completion

  -- :h group-name
  Comment = { fg = c.overlay1, italic = true }, -- comments
  Constant = { fg = c.sapphire }, -- any constant
  String = { fg = c.green }, -- a string constant: "this is a string"
  Character = { fg = c.teal }, -- a character constant: 'c', '\n'
  Number = { fg = c.peach }, --	a number constant: 234, 0xff
  Boolean = { fg = c.peach }, -- a boolean constant: TRUE, false
  Float = { link = 'Number' }, -- a floating point constant: 2.3e10
  Identifier = { fg = c.lavender }, -- any variable name
  Function = { fg = c.blue }, -- function name (also: methods for classes)
  Statement = { fg = c.mauve }, -- any statement
  Conditional = { fg = c.mauve }, -- if, then, else, endif, switch, etc.
  Repeat = { fg = c.mauve }, -- for, do, while, etc.
  Label = { fg = c.lavender }, -- case, default, etc.
  Operator = { fg = c.teal }, -- "sizeof", "+", "*", etc.
  Keyword = { fg = c.red, italic = true }, -- any other keyword
  Exception = { fg = c.peach }, -- try, catch, throw
  PreProc = { fg = c.mauve }, -- generic Preprocessor
  Include = { fg = c.mauve }, -- preprocessor #include
  Define = { link = 'PreProc' }, -- preprocessor #define
  Macro = { fg = c.pink }, -- same as Define
  PreCondit = { link = 'PreProc' }, -- preprocessor #if, #else, #endif, etc.
  Type = { fg = c.yellow }, -- int, long, char, etc.
  StorageClass = { fg = c.yellow }, -- static, register, volatile, etc.
  Structure = { fg = c.yellow, italic = true }, -- struct, union, enum, etc.
  Typedef = { link = 'Type' }, -- a typedef
  Special = { fg = c.pink }, -- any special symbol
  SpecialChar = { link = 'Special' }, -- special character in a constant
  Tag = { fg = c.lavender, bold = true }, -- you can use CTRL-] on this
  Delimiter = { fg = c.overlay2 }, -- character that needs attention
  SpecialComment = { link = 'Special' }, -- special things inside a comment
  Debug = { link = 'Special' }, -- debugging statements
  Underlined = { underline = true }, -- text that stands out, HTML links
  Ignore = {}, -- left blank, hidden  |hl-Ignore|
  Error = { fg = c.red }, -- any erroneous construct
  Todo = { fg = c.base, bg = c.flamingo, bold = true }, -- anything that needs extra attention; mostly the keywords TODO FIXME and XXX
  Added = { fg = c.green }, -- added line in a diff
  Changed = { fg = c.peach }, -- changed line in a diff
  Removed = { fg = c.red }, -- removed line in a diff

  -- diagnostics
  -- :h diagnostic-highlights
  DiagnosticError = { fg = c.red }, -- error diagnostics
  DiagnosticWarn = { fg = c.yellow }, -- warning diagnostics
  DiagnosticInfo = { fg = c.blue }, -- info diagnostics
  DiagnosticHint = { fg = c.lavender }, -- hint diagnostics

  -- treesitter
  -- :h treesitter-highlight-groups
  -- ordered by `treesitter-highlight-groups` in how they are documented
  -- so don't delete stuff, commented out ones are the defaults.
  ['@variable'] = { fg = c.text }, -- various variable names
  ['@variable.builtin'] = { fg = c.red }, -- built-in variable names (e.g. `this`, `self`)
  ['@variable.parameter'] = { fg = c.mauve }, -- parameters of a function
  ['@variable.parameter.builtin'] = { fg = c.mauve }, -- special parameters (e.g. `_`, `it`)
  ['@variable.member'] = { fg = c.lavender }, -- object and struct fields

  -- ['@constant'] = { link = 'Constant' }, -- constant identifiers
  ['@constant.builtin'] = { link = 'Constant' }, -- built-in constant values
  ['@constant.macro'] = { link = 'Macro' }, -- constants defined by the preprocessor

  -- ['@module'] = { link = 'Structure' }, -- modules or namespaces
  ['@module.builtin'] = { link = 'Structure' }, -- built-in modules or namespaces
  -- ['@label'] = { link = 'Label' }, -- `GOTO` and other labels (e.g. `label:` in C), including heredoc labels

  -- ['@string'] = { link = 'String' }, -- string literals
  ['@string.documentation'] = { fg = c.teal }, -- string documenting code (e.g. Python docstrings)
  -- ['@string.regexp'] = { link = '@string.special' }, -- regular expressions
  -- ['@string.escape'] = { link = '@string.special' }, -- escape sequences
  ['@string.special'] = { link = 'Special' }, -- other special strings (e.g. dates)
  -- ['@string.special.symbol'] = { link = '@string.special' }, -- symbols or atoms
  -- ['@string.special.path'] = { link = '@string.special' }, -- filenames
  ['@string.special.url'] = { fg = c.subtext0, underline = true }, -- URIs (e.g. hyperlinks)

  -- ['@character'] = { link = 'Character' }, -- character literals
  -- ['@character.special'] = { link = 'SpecialChar' }, -- special characters (e.g. wildcards)

  -- ['@boolean'] = { link = 'Boolean' }, -- boolean literals
  -- ['@number'] = { link = 'Number' }, -- numeric literals
  -- ['@number.float'] = { link = 'Float' }, -- number literals

  -- ['@type'] = { link = 'Type' }, -- type or class definitions and annotations
  ['@type.builtin'] = { link = 'Type' }, -- built-in types
  ['@type.definition'] = { link = 'Typedef' }, -- identifiers in type definitions (e.g. `typedef <type> <identifier>` in C)

  -- ['@attribute'] = { link = 'Macro' }, -- attribute annotations (e.g. Python decorators, Rust lifetimes)
  ['@attribute.builtin'] = { link = '@attribute' }, -- builtin annotations (e.g. `@property` in Python)
  -- ['@property'] = { link = 'Identifier' }, -- the key in key/value pairs

  -- ['@function'] = { link = 'Function' }, -- function definitions
  ['@function.builtin'] = { fg = c.peach }, -- built-in functions
  ['@function.call'] = { link = 'Function' }, -- function calls
  ['@function.macro'] = { link = 'Macro' }, -- preprocessor macros

  ['@function.method'] = { link = 'Function' }, -- method definitions
  ['@function.method.call'] = { link = 'Function' }, -- method calls

  ['@constructor'] = { fg = c.teal }, -- constructor calls and definitions
  -- ['@operator'] = { link = 'Operator' }, -- symbolic operators (e.g. `+`, `*`)

  -- ['@keyword'] = { link = 'Keyword' }, -- keywords not fitting into specific categories
  -- ['@keyword.coroutine'] = {}, -- keywords related to coroutines (e.g. `go` in Go, `async/await` in Python)
  -- ['@keyword.function'] = {}, -- keywords that define a function (e.g. `func` in Go, `def` in Python)
  -- ['@keyword.operator'] = {}, -- operators that are English words (e.g. `and`, `or`)
  ['@keyword.import'] = { link = 'Include' }, -- keywords for including or exporting modules (e.g. `import`, `from` in Python)
  -- ['@keyword.type'] = {}, -- keywords describing namespaces and composite types (e.g. `struct`, `enum`)
  -- ['@keyword.modifier'] = {}, -- keywords modifying other constructs (e.g. `const`, `static`, `public`)
  ['@keyword.repeat'] = { link = 'Repeat' }, -- keywords related to loops (e.g. `for`, `while`)
  -- ['@keyword.return'] = {}, -- keywords like `return` and `yield`
  ['@keyword.debug'] = { link = 'Exception' }, -- keywords related to debugging
  ['@keyword.exception'] = { link = 'Exception' }, -- keywords related to exceptions (e.g. `throw`, `catch`)

  ['@keyword.conditional'] = { link = 'Conditional' }, -- keywords related to conditionals (e.g. `if`, `else`)
  ['@keyword.conditional.ternary'] = { link = 'Operator' }, -- ternary operator (e.g. `?`, `:`)

  ['@keyword.directive'] = { link = 'PreProc' }, -- various preprocessor directives and shebangs
  ['@keyword.directive.define'] = { link = 'Define' }, -- preprocessor definition directives

  -- ['@punctuation.delimiter'] = {}, -- delimiters (e.g. `;`, `.`, `,`)
  -- ['@punctuation.bracket'] = {}, -- brackets (e.g. `()`, `{}`, `[]`)
  ['@punctuation.special'] = { link = '@punctuation' }, -- special symbols (e.g. `{}` in string interpolation)

  -- ['@comment'] = { link = 'Comment' }, -- line and block comments
  -- ['@comment.documentation'] = {}, -- comments documenting code

  -- ['@comment.error'] = { link = 'DiagnosticError' }, -- error-type comments (e.g. `ERROR`, `FIXME`, `DEPRECATED`)
  -- ['@comment.warning'] = { link = 'DiagnosticWarn' }, -- warning-type comments (e.g. `WARNING`, `FIX`, `HACK`)
  -- ['@comment.todo'] = { link = 'Todo' }, -- todo-type comments (e.g. `TODO`, `WIP`)
  -- ['@comment.note'] = { link = 'DiagnosticInfo' }, -- note-type comments (e.g. `NOTE`, `INFO`, `XXX`)

  ['@markup.strong'] = { fg = c.lavender, bold = true }, -- bold text
  ['@markup.italic'] = { fg = c.lavender, italic = true }, -- italic text
  ['@markup.strikethrough'] = { fg = c.subtext0, strikethrough = true }, -- struck-through text
  ['@markup.underline'] = { link = 'Underlined' }, -- underlined text (only for literal underline markup!)

  ['@markup.heading'] = { fg = c.peach, bold = true }, -- headings, titles (including markers)

  ['@markup.quote'] = { fg = c.subtext0 }, -- block quotes
  ['@markup.math'] = { fg = c.pink }, -- math environments (e.g. `$ ... $` in LaTeX)

  ['@markup.link'] = { fg = c.blue }, -- text references, footnotes, citations, etc.
  ['@markup.link.label'] = { fg = c.blue }, -- link, reference descriptions
  ['@markup.link.url'] = { fg = c.blue, underline = true, italic = true }, -- URL-style links

  ['@markup.raw'] = { fg = c.maroon, bold = true }, -- literal or verbatim text (e.g. inline code, python """)
  -- ['@markup.raw.block'] = {}, -- literal or verbatim text as a stand-alone block

  ['@markup.list'] = { fg = c.teal }, -- list markers
  ['@markup.list.checked'] = { fg = c.green, strikethrough = true }, -- checked todo-style list markers
  ['@markup.list.unchecked'] = { fg = c.overlay1 }, -- unchecked todo-style list markers

  -- ['@diff.plus'] = { link = 'Added' }, -- added text (for diff files)
  -- ['@diff.minus'] = { link = 'Changed' }, -- deleted text (for diff files)
  -- ['@diff.delta'] = { link = 'Removed' }, -- changed text (for diff files)

  -- ['@tag'] = { link = 'Tag' }, -- XML-style tag names (e.g. in XML, HTML, etc.)
  -- ['@tag.builtin'] = { link = 'Special' }, -- builtin tag names (e.g. HTML5 tags)
  -- ['@tag.attribute'] = {}, -- XML-style tag attributes
  -- ['@tag.delimiter'] = {}, -- XML-style tag delimiters

  -- language specific
  ['@constructor.lua'] = { link = '@punctuation.bracket' }, -- For constructor calls and definitions: = {} in Lua.
  ['@constructor.python'] = { fg = c.sapphire }, -- __init__(), __new__().

  -- semantic tokens.
  -- :h lsp-semantic-highlight
  ['@lsp.type.variable'] = {},
  ['@lsp.typemod.function.defaultLibrary'] = { link = '@function.builtin' },
  ['@lsp.typemod.function.builtin'] = { link = '@function.builtin' },

  -- render-markdown
  RenderMarkdownH1Bg = { bg = c.base },
  RenderMarkdownH2Bg = { bg = c.base },
  RenderMarkdownH3Bg = { bg = c.base },
  RenderMarkdownH4Bg = { bg = c.base },
  RenderMarkdownH5Bg = { bg = c.base },
  RenderMarkdownH6Bg = { bg = c.base },

  -- blink
  BlinkCmpMenuSelection = { link = 'PmenuSel' },

  -- snacks
  SnacksInputNormal = { link = 'NormalFloat' },
  SnacksInputBorder = { link = 'FloatBorder' },
  SnacksInputTitle = { link = 'FloatTitle' },
  SnacksInputIcon = { link = 'DiagnosticWarn' },
  SnacksPickerCursorLine = { link = 'PmenuSel' },
  SnacksPickerListCursorLine = { link = 'PmenuSel' },
  SnacksPickerInputCursorLine = { link = 'NormalFloat' },
}

for group, spec in pairs(hl) do
  vim.api.nvim_set_hl(0, group, spec)
end
