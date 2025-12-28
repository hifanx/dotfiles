local M = {}

-- stylua: ignore start
M.isekai = {
  none         = 'NONE',
  white        = '#FAFAFA',
  purple       = '#9C89B8',
  red          = '#E06C75',
  orange       = '#F4A261',
  yellow       = '#F9E2AF',
  green        = '#A6E3A1',
  blue         = '#61AFEF',
  red_muted    = '#C48282',
  orange_muted = '#C9803F',
  yellow_muted = '#B5885E',
  green_muted  = '#6C9C6A',
  blue_muted   = '#5897C2',
  lavender     = '#DEE2FF',
  builtin      = '#65999D',
  text         = '#8E9AAF',
  visual       = '#283457',
  comment      = '#355070',
  overlay      = '#585B70',
  surface      = '#252530',
  base         = '#0D1117',
  mantle       = '#080B10',
  crust        = '#020202',
  blue_diff    = '#14334B',
  green_diff   = '#30452E',
  red_diff     = '#500C26',
  orange_diff  = '#30280F',
}

M.catppuccin = {
  rosewater = '#F5E0DC',
  flamingo  = '#F2CDCD',
  pink      = '#F5C2E7',
  mauve     = '#CBA6F7',
  red       = '#F38BA8',
  maroon    = '#EBA0AC',
  peach     = '#FAB387',
  yellow    = '#F9E2AF',
  green     = '#A6E3A1',
  teal      = '#94E2D5',
  sky       = '#89DCEB',
  sapphire  = '#74C7EC',
  blue      = '#89B4FA',
  lavender  = '#B4BEFE',
  text      = '#CDD6F4',
  subtext1  = '#BAC2DE',
  subtext0  = '#A6ADC8',
  overlay2  = '#9399B2',
  overlay1  = '#7F849C',
  overlay0  = '#6C7086',
  surface2  = '#585B70',
  surface1  = '#45475A',
  surface0  = '#313244',
  base      = '#1E1E2E',
  mantle    = '#181825',
  crust     = '#11111B',
}

M.rosepine = {
  base           = '#191724', -- rgb(25, 23, 36), hsl(249deg, 22%, 12%)
  surface        = '#1F1D2E', -- rgb(31, 29, 46), hsl(247deg, 23%, 15%)
  overlay        = '#26233A', -- rgb(38, 35, 58), hsl(248deg, 25%, 18%)
  muted          = '#6E6A86', -- rgb(110, 106, 134), hsl(249deg, 12%, 47%)
  subtle         = '#908CAA', -- rgb(144, 140, 170), hsl(248deg, 15%, 61%)
  text           = '#E0DEF4', -- rgb(224, 222, 244), hsl(245deg, 50%, 91%)
  love           = '#EB6F92', -- rgb(235, 111, 146), hsl(343deg, 76%, 68%)
  gold           = '#F6C177', -- rgb(246, 193, 119), hsl(35deg, 88%, 72%)
  rose           = '#EBBCBA', -- rgb(235, 188, 186), hsl(2deg, 55%, 83%)
  pine           = '#31748F', -- rgb(49, 116, 143), hsl(197deg, 49%, 38%)
  foam           = '#9CCFD8', -- rgb(156, 207, 216), hsl(189deg, 43%, 73%)
  iris           = '#C4A7E7', -- rgb(196, 167, 231), hsl(267deg, 57%, 78%)
  highlight_low  = '#21202E', -- rgb(33, 32, 46), hsl(244deg, 18%, 15%)
  highlight_med  = '#403D52', -- rgb(64, 61, 82), hsl(249deg, 15%, 28%)
  highlight_high = '#524F67', -- rgb(82, 79, 103), hsl(248deg, 13%, 36%)
}

M.onedark = {
  black  = '#282C34',
  red    = '#E06C75',
  green  = '#98C379',
  yellow = '#E5C07B',
  blue   = '#61AFEF',
  purple = '#C678DD',
  cyan   = '#56B6C2',
  gray   = '#ABB2BF',
}

M.kanagawa = {
  fujiWhite     = '#DCD7BA', -- Default foreground
  oldWhite      = '#C8C093', -- Dark foreground (statuslines)
  sumiInk0      = '#16161D', -- Dark background (statuslines and floating windows)
  sumiInk1      = '#1F1F28', -- Default background
  sumiInk2      = '#2A2A37', -- Lighter background (colorcolumn, folds)
  sumiInk3      = '#363646', -- Lighter background (cursorline)
  sumiInk4      = '#54546D', -- Darker foreground (line numbers, fold column, non-text characters), float borders
  waveBlue1     = '#223249', -- Popup background, visual selection background
  waveBlue2     = '#2D4F67', -- Popup selection background, search background
  winterGreen   = '#2B3328', -- Diff Add (background)
  winterYellow  = '#49443C', -- Diff Change (background)
  winterRed     = '#43242B', -- Diff Deleted (background)
  winterBlue    = '#252535', -- Diff Line (background)
  autumnGreen   = '#76946A', -- Git Add
  autumnRed     = '#C34043', -- Git Delete
  autumnYellow  = '#DCA561', -- Git Change
  samuraiRed    = '#E82424', -- Diagnostic Error
  roninYellow   = '#FF9E3B', -- Diagnostic Warning
  waveAqua1     = '#6A9589', -- Diagnostic Info
  dragonBlue    = '#658594', -- Diagnostic Hint
  fujiGray      = '#727169', -- Comments
  springViolet1 = '#938AA9', -- Light foreground
  oniViolet     = '#957FB8', -- Statements and Keywords
  crystalBlue   = '#7E9CD8', -- Functions and Titles
  springViolet2 = '#9CABCA', -- Brackets and punctuation
  springBlue    = '#7FB4CA', -- Specials and builtin functions
  lightBlue     = '#A3D4D5', -- Not used
  waveAqua2     = '#7AA89F', -- Types
  springGreen   = '#98BB6C', -- Strings
  boatYellow1   = '#938056', -- Not used
  boatYellow2   = '#C0A36E', -- Operators, RegEx
  carpYellow    = '#E6C384', -- Identifiers
  sakuraPink    = '#D27E99', -- Numbers
  waveRed       = '#E46876', -- Standout specials 1 (builtin variables)
  peachRed      = '#FF5D62', -- Standout specials 2 (exception handling, return)
  surimiOrange  = '#FFA066', -- Constants, imports, booleans
  katanaGray    = '#717C7C', -- Deprecated
}

M.gruvbox = {
  bg     = '#282828',
  bg0_s  = '#32302F',
  bg0_h  = '#1D2021',
  bg0    = '#282828',
  bg1    = '#3C3836',
  bg2    = '#504945',
  bg3    = '#665C54',
  bg4    = '#7C6F64',
  fg     = '#EBDBB2',
  fg0    = '#FBF1C7',
  fg1    = '#EBDBB2',
  fg2    = '#D5C4A1',
  fg3    = '#BDAE93',
  fg4    = '#A89984',
  red    = '#CC241D',
  green  = '#98971A',
  yellow = '#D79921',
  blue   = '#458588',
  purple = '#B16286',
  aqua   = '#689D6A',
  orange = '#D65D0E',
  gray   = '#A89984',
  silver = '#928374',
}

M.tokyonight = {
  bg               = '#1A1B26',
  bg_dark          = '#16161E',
  bg_float         = '#16161E',
  bg_highlight     = '#292E42',
  bg_popup         = '#16161E',
  bg_search        = '#3D59A1',
  bg_sidebar       = '#16161E',
  bg_statusline    = '#16161E',
  bg_visual        = '#283457',
  black            = '#15161E',
  blue             = '#7AA2F7',
  blue0            = '#3D59A1',
  blue1            = '#2AC3DE',
  blue2            = '#0DB9D7',
  blue5            = '#89DDFF',
  blue6            = '#B4F9F8',
  blue7            = '#394B70',
  border           = '#15161E',
  border_highlight = '#27A1B9',
  comment          = '#565F89',
  cyan             = '#7DCFFF',
  dark3            = '#545C7E',
  dark5            = '#737AA2',
  delta = {
    add    = '#2C5A66',
    delete = '#713137',
  },
  diff = {
    add    = '#20303B',
    change = '#1F2231',
    delete = '#37222C',
    text   = '#394B70',
  },
  error      = '#DB4B4B',
  fg         = '#C0CAF5',
  fg_dark    = '#A9B1D6',
  fg_float   = '#C0CAF5',
  fg_gutter  = '#3B4261',
  fg_sidebar = '#A9B1D6',
  git = {
    add    = '#449DAB',
    change = '#6183BB',
    delete = '#914C54',
    ignore = '#545C7E',
  },
  gitSigns = {
    add    = '#266D6A',
    change = '#536C9E',
    delete = '#B2555B',
  },
  green          = '#9ECE6A',
  green1         = '#73DACA',
  green2         = '#41A6B5',
  hint           = '#1ABC9C',
  info           = '#0DB9D7',
  magenta        = '#BB9AF7',
  magenta2       = '#FF007C',
  orange         = '#FF9E64',
  purple         = '#9D7CD8',
  red            = '#F7768E',
  red1           = '#DB4B4B',
  teal           = '#1ABC9C',
  terminal_black = '#414868',
  todo           = '#7AA2F7',
  warning        = '#E0AF68',
  yellow         = '#E0AF68',
}

M.github = {
  accent = {
    emphasis = '#1F6FEB',
    fg       = '#2F81F7',
    muted    = '#1E4273',
    subtle   = '#132339',
  },
  attention = {
    emphasis = '#9E6A03',
    fg       = '#D29922',
    muted    = '#533D11',
    subtle   = '#272215',
  },
  black = {
    base   = '#0D1117',
    bright = '#161B22',
  },
  blue = {
    base   = '#58A6FF',
    bright = '#79C0FF',
  },
  border = {
    default = '#161B22',
    muted   = '#21262D',
    subtle  = '#24282E',
  },
  canvas = {
    default = '#0D1117',
    inset   = '#010409',
    overlay = '#161B22',
    subtle  = '#161B22',
  },
  closed = {
    emphasis = '#DA3633',
    fg       = '#F85149',
    muted    = '#6B2B2B',
    subtle   = '#301B1E',
  },
  cyan = {
    base   = '#76E3EA',
    bright = '#B3F0FF',
  },
  danger = {
    emphasis = '#DA3633',
    fg       = '#F85149',
    muted    = '#6B2B2B',
    subtle   = '#25171C',
  },
  done = {
    emphasis = '#8957E5',
    fg       = '#A371F7',
    muted    = '#493771',
    subtle   = '#1C1B2D',
  },
  fg = {
    default     = '#E6EDF3',
    muted       = '#7D8590',
    on_emphasis = '#ffffff',
    subtle      = '#6E7681',
  },
  gray = {
    base   = '#6E7681',
    bright = '#6E7681',
  },
  green = {
    base   = '#3FB950',
    bright = '#56D364',
  },
  magenta = {
    base   = '#BC8CFF',
    bright = '#D2A8FF',
  },
  neutral = {
    emphasis      = '#6E7681',
    emphasis_plus = '#6E7681',
    muted         = '#343941',
    subtle        = '#171B22',
  },
  open = {
    emphasis = '#238636',
    fg       = '#3FB950',
    muted    = '#1A4A29',
    subtle   = '#12261E',
  },
  orange = '#F0883E',
  pink = {
    base   = '#F778BA',
    bright = '#FF9BCE',
  },
  red = {
    base   = '#FF7B72',
    bright = '#FFA198',
  },
  severe = {
    emphasis = '#BD561D',
    fg       = '#DB6D28',
    muted    = '#5F361E',
    subtle   = '#221A19',
  },
  sponsors = {
    emphasis = '#BF4B8A',
    fg       = '#DB61A2',
    muted    = '#5F314F',
    subtle   = '#221925',
  },
  success = {
    emphasis = '#238636',
    fg       = '#3FB950',
    muted    = '#1A4A29',
    subtle   = '#12261E',
  },
  white = {
    base   = '#B1BAC4',
    bright = '#B1BAC4',
  },
  yellow = {
    base   = '#D29922',
    bright = '#E3B341',
  },
}

M.vague = {
  bg          = '#141415',
  inactiveBg  = '#1C1C24',
  fg          = '#CDCDCD',
  floatBorder = '#878787',
  line        = '#252530',
  comment     = '#606079',
  builtin     = '#B4D4CF',
  func        = '#C48282',
  string      = '#E8B589',
  number      = '#E0A363',
  property    = '#C3C3D5',
  constant    = '#AEAED1',
  parameter   = '#BB9DBD',
  visual      = '#333738',
  error       = '#D8647E',
  warning     = '#F3BE7C',
  hint        = '#7E98E8',
  operator    = '#90A0B5',
  keyword     = '#6E94B2',
  type        = '#9BB4BC',
  search      = '#405065',
  plus        = '#7FA563',
  delta       = '#F3BE7C',
}
-- stylua: ignore end

return M
