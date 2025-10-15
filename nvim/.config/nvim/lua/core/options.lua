local o = vim.opt
local g = vim.g

g.mapleader = ' '
g.gmaplocalleader = ','

o.winborder = 'solid'
o.undofile = true -- enable persistent undo
o.number = true -- show numberline
o.relativenumber = true -- show relative numberline
o.mouse = 'a' -- enable mouse support
o.laststatus = 3 -- global statusline
o.cmdheight = 1 -- height of the command bar, default: 1
o.backup = false -- disable backup
o.showmode = false -- disable showing modes in command line since it's already in the status line
o.smartindent = true -- do smart autoindenting.
o.confirm = true -- Confirm to save changes before exiting modified buffer
o.scrolloff = 15 -- minimum number of lines to keep above and below the cursor.
o.hlsearch = true -- highlight search results as you type.

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
o.ignorecase = true
o.smartcase = true

o.signcolumn = 'yes' -- always show the sign column
o.updatetime = 200 -- length of time to wait before triggering the plugin
o.timeoutlen = 250 -- shorten key timeout length for which-key

o.splitbelow = true -- splitting a new window below the current one
o.splitright = true -- splitting a new window at the right of the current one
o.splitkeep = 'screen'

o.cursorline = true -- highlight the text line of the cursor
o.clipboard = 'unnamedplus' -- connection to the system clipboard

o.inccommand = 'split' -- preview substitutions live
o.expandtab = true -- enable the use of space in tab
o.shiftwidth = 2 -- number of space inserted for indentation
o.softtabstop = 2 -- number of spaces that a <Tab> counts for.
o.tabstop = 2 -- number of space in a tab

o.shortmess:append 'sI'
o.spelllang = 'en_us,en_gb,cjk'
o.spell = true
o.wrap = true -- soft wrap lines
o.breakindent = true -- make wrapped lines continue visually indented
o.showbreak = '↪ '
o.list = true -- show invisible characters.
o.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
o.fillchars = {
  eob = ' ', -- Empty lines at the end of buffer
  msgsep = '‾', -- Message separator
}

o.termguicolors = true

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
