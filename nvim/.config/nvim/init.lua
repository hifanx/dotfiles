-- bootstrap {{{

_G.GLOB = {}

local LAZY_PLUGIN_SPEC = {}
local function spec(item) table.insert(LAZY_PLUGIN_SPEC, { import = item }) end

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ Namespaced profile                                    │
-- ╰──────────────────────────────────────────────────────────╯
local profile = vim.env.NVIM_PROFILE
local os_name = vim.loop.os_uname().sysname:lower()
-- NOTE: computed once on load and called with O(1) operation
_G.GLOB.is_sif = (os_name == 'darwin' and profile == 'sif')

-- }}}

-- options {{{

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ Option section                                        │
-- ╰──────────────────────────────────────────────────────────╯
local o = vim.opt
local g = vim.g

-- general
g.mapleader = ' '
o.mouse = 'a' -- enable mouse support
o.undofile = true -- enable persistent undo
o.clipboard = 'unnamedplus' -- connection to the system clipboard
o.backup = false -- disable backup
o.confirm = true -- Confirm to save changes before exiting modified buffer
o.iskeyword = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part
o.termguicolors = true

-- ui
o.winborder = 'rounded'
o.cursorline = true -- highlight the text line of the cursor
o.number = true -- show numberline
o.relativenumber = true -- show relative numberline
o.signcolumn = 'yes' -- always show the sign column
o.cmdheight = 1 -- height of the command bar, default: 1

-- wrapping
o.wrap = true -- soft wrap lines
o.showbreak = '↪ '
o.breakindent = true -- make wrapped lines continue visually indented

-- special UI symbols
o.list = true -- show invisible characters.
o.listchars = 'extends:…,nbsp:␣,precedes:…,tab:> ,trail:·'
o.fillchars = 'eob: ,fold:╌,foldclose:,foldopen:'

-- statusline
o.laststatus = 0 -- never a statusline
o.ruler = false -- no position info at cmdline
o.showmode = false -- disable showing modes in command line since it's already in the status line

-- splitting
o.splitbelow = true -- splitting a new window below the current one
o.splitright = true -- splitting a new window at the right of the current one
o.splitkeep = 'screen'

-- scrolling
o.scrolloff = 15 -- minimum number of lines to keep above and below the cursor.

-- editing
o.updatetime = 200 -- length of time to wait before triggering the plugin
o.timeoutlen = 250 -- shorten key timeout length for which-key
o.inccommand = 'split' -- preview substitutions live

-- check spell
o.spell = true
o.spelllang = 'en_us,en_gb,cjk'

-- indenting
o.expandtab = true -- convert tabs to spaces
o.shiftwidth = 2 -- number of space inserted for indentation
o.softtabstop = 2 -- number of spaces that a <Tab> counts for.
o.tabstop = 2 -- number of space in a tab
o.smartindent = true -- do smart auto indenting.

-- searching
o.ignorecase = true -- ignore case during search
o.smartcase = true -- respect case if search pattern has upper case
o.hlsearch = true -- highlight search results as you type.

-- folding
o.foldmethod = 'marker'
o.foldmarker = '{{{,}}}' -- this is the default
o.foldlevel = 0 -- start with all folds closed
o.foldlevelstart = 0 -- open files with folds closed

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ Experimental, update when necessary                   │
-- ╰──────────────────────────────────────────────────────────╯
require('vim._extui').enable({
  enable = true,
  msg = {
    ---@type 'cmd'|'msg' Where to place regular messages, either in the
    ---cmdline or in a separate ephemeral message window.
    target = 'msg',
    timeout = 4000,
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'msg',
  callback = function()
    vim.opt_local.winblend = 30
    vim.opt_local.winhighlight = 'Normal:Normal,FloatBorder:Normal'
  end,
})

--  }}}

-- mappings {{{

-- basic
vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = '[W]rite' })
vim.keymap.set('n', '<C-q>', ':qa<CR>', { desc = '[Q]uit No Save' })
vim.keymap.set('n', '<C-c>', ':close<CR>', { desc = '[C]lose' })
vim.keymap.set('n', '<Leader>y', ':%y+<CR>', { desc = '[Y]ank buffer' })

vim.keymap.set('n', 'H', ':bprev<CR>', { desc = 'Prev Buffer', noremap = false })
vim.keymap.set('n', 'L', ':bnext<CR>', { desc = 'Next Buffer', noremap = false })

vim.keymap.set('n', '=', [[:vertical resize +5<CR>]])
vim.keymap.set('n', '-', [[:vertical resize -5<CR>]])
vim.keymap.set('n', '+', [[:horizontal resize +2<CR>]])
vim.keymap.set('n', '_', [[:horizontal resize -2<CR>]])

-- go to beginning and end
vim.keymap.set('i', '<C-b>', '<ESC>^i', { desc = 'Beginning of Line' })
vim.keymap.set('i', '<C-e>', '<End>', { desc = 'End of Line' })
vim.keymap.set({ 'n', 'o', 'x' }, 'B', '^', { desc = 'Beginning of Line' })
vim.keymap.set({ 'n', 'o', 'x' }, 'E', 'g_', { desc = 'End of Line' })

-- Delete the character to the right of the cursor
vim.keymap.set('i', '<C-D>', '<DEL>')

-- navigate within insert mode
vim.keymap.set('i', '<C-h>', '<Left>', { desc = 'Move Left' })
vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'Move Right' })
vim.keymap.set('i', '<C-j>', '<Down>', { desc = 'Move Down' })
vim.keymap.set('i', '<C-k>', '<Up>', { desc = 'Move Up' })

-- turn the word under cursor to upper case
vim.keymap.set('i', '<C-u>', '<Esc>viwUea', { desc = 'Turn Into Upper Case' })
-- turn the current word into title case
vim.keymap.set('i', '<C-t>', '<Esc>b~lea', { desc = 'Turn Into Title Case' })

-- window management
vim.keymap.set('n', '|', '<C-w>v', { desc = 'Split Vertically' })
vim.keymap.set('n', '\\', '<C-w>s', { desc = 'Split Horizontally' })

-- clear highlights
vim.keymap.set('n', '<Esc>', ':noh<CR>', { desc = 'Clear Highlights' })

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using : :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
vim.keymap.set(
  { 'n', 'x' },
  'j',
  'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
  { desc = 'Move Down', expr = true }
)
vim.keymap.set(
  { 'n', 'x' },
  'k',
  'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
  { desc = 'Move Up', expr = true }
)
vim.keymap.set(
  { 'n', 'v' },
  '<Up>',
  'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
  { desc = 'Move Up', expr = true }
)
vim.keymap.set(
  { 'n', 'v' },
  '<Down>',
  'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
  { desc = 'Move Down', expr = true }
)

-- Line operation
vim.keymap.set({ 'x', 'v' }, '<', '<gv', { desc = 'Indent Line' })
vim.keymap.set({ 'x', 'v' }, '>', '>gv', { desc = 'Indent Line' })
vim.keymap.set('v', 'J', ":move '>+1<CR>gv-gv", { desc = 'Move Text Down' })
vim.keymap.set('v', 'K', ":move '<-2<CR>gv-gv", { desc = 'Move Text Up' })

-- Change text without putting it into register,
-- see https://stackoverflow.com/q/54255/6064933
vim.keymap.set('n', 'c', '"_c')
vim.keymap.set('n', 'C', '"_C')
vim.keymap.set('n', 'cc', '"_cc')
vim.keymap.set('x', 'c', '"_c')

-- Don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
vim.keymap.set(
  'x',
  'p',
  'p:let @+=@0<CR>:let @"=@0<CR>',
  { desc = "Don't Copy Replaced Text" }
)

-- commenting
vim.keymap.set(
  'n',
  'gco',
  'o<esc>Vcx<esc>:normal gcc<CR>fxa<bs>',
  { desc = 'Add Comment Below' }
)
vim.keymap.set(
  'n',
  'gcO',
  'O<esc>Vcx<esc>:normal gcc<CR>fxa<bs>',
  { desc = 'Add Comment Above' }
)

-- }}}

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ ESSENTIALS                                            │
-- ╰──────────────────────────────────────────────────────────╯
spec('plugins.blink') -- completion
spec('plugins.conform') -- format
spec('plugins.mason') -- auto install lsp server, formatter, linter
spec('plugins.nvim-lint') -- linting
spec('plugins.nvim-treesitter') -- syntax highlighting
spec('plugins.snacks') -- XXX:to be deleted

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ EDITOR                                                │
-- ╰──────────────────────────────────────────────────────────╯
spec('plugins.better-escape')
spec('plugins.nvim-autopairs')
spec('plugins.nvim-surround')
spec('plugins.nvim-ts-autotag')
spec('plugins.pangu') -- auto format to add a space between cjk and english letters
spec('plugins.ts-comments') -- enhance neovim's native comments

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ TOOLS                                                 │
-- ╰──────────────────────────────────────────────────────────╯
spec('plugins.carbon-now') -- screenshot code
spec('plugins.inc-rename') -- LSP renaming with immediate visual feedback
spec('plugins.oil')
spec('plugins.vim-tmux-navigator')
spec('plugins.which-key')
spec('plugins.persistence') -- session manager

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ UI                                                    │
-- ╰──────────────────────────────────────────────────────────╯
spec('plugins.catppuccin')
spec('plugins.gitsigns')
spec('plugins.lualine')
spec('plugins.mini-icons')
spec('plugins.nvim-colorizer')
spec('plugins.render-markdown')
spec('plugins.smear-cursor') -- animated cursor
spec('plugins.todo-comments')

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ AI                                                    │
-- ╰──────────────────────────────────────────────────────────╯
spec('plugins.avante')
spec('plugins.copilot')

-- lazy {{{

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch=stable',
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = LAZY_PLUGIN_SPEC,
  defaults = { lazy = true, version = false }, -- always use the latest git commit
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      -- NOTE: see full list:
      -- https://github.com/neovim/neovim/tree/master/runtime/plugin
      disabled_plugins = {
        'tohtml.lua',
        'gzip.vim',
        'man.lua',
        'tarPlugin.vim',
        'zipPlugin.vim',
        'rplugin.vim',
      },
    },
  },
  rocks = {
    enabled = false,
    hererocks = false,
  },
})

vim.keymap.set('n', '<leader>hl', ':Lazy<CR>', { desc = 'Lazy' })

-- }}}

-- lsp {{{

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ disable default keybinds                              │
-- ╰──────────────────────────────────────────────────────────╯
for _, bind in ipairs({ 'grn', 'gra', 'gri', 'grr' }) do
  pcall(vim.keymap.del, 'n', bind)
end

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ setup lsp attach                                      │
-- ╰──────────────────────────────────────────────────────────╯

-- Create augroups ONCE outside the callback
local highlight_augroup =
  vim.api.nvim_create_augroup('lsp-highlight', { clear = true })
local detach_augroup = vim.api.nvim_create_augroup('lsp-detach', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then return end

    -- Buffer-local keymaps (won't duplicate)
    vim.keymap.set(
      'n',
      'gh',
      vim.diagnostic.open_float,
      { buffer = ev.buf, desc = '[G]oto [H]over Diagnostic' }
    )
    vim.keymap.set(
      { 'n', 'v' },
      '<leader>la',
      vim.lsp.buf.code_action,
      { buffer = ev.buf, desc = 'Code [A]ction' }
    )
    vim.keymap.set(
      'n',
      '<leader>lh',
      vim.lsp.buf.signature_help,
      { buffer = ev.buf, desc = 'Signature [H]elp' }
    )
    vim.keymap.set(
      'n',
      '<leader>lr',
      vim.lsp.buf.rename,
      { buffer = ev.buf, desc = '[R]ename' }
    )

    -- CodeLens support
    if
      client.supports_method(client, vim.lsp.protocol.Methods.textDocument_codeLens)
    then
      vim.keymap.set(
        'n',
        '<leader>ll',
        vim.lsp.codelens.refresh,
        { buffer = ev.buf, desc = 'Code[L]ens refresh' }
      )
      vim.keymap.set(
        'n',
        '<leader>lL',
        vim.lsp.codelens.run,
        { buffer = ev.buf, desc = 'Code[L]ens run' }
      )
    end

    -- Inlay hints
    if
      client.supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint)
    then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end

    -- Document highlight - buffer-specific autocmds
    if
      client.supports_method(
        client,
        vim.lsp.protocol.Methods.textDocument_documentHighlight
      )
    then
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = ev.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = ev.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})

vim.api.nvim_create_autocmd('LspDetach', {
  group = detach_augroup,
  callback = function(ev)
    vim.lsp.buf.clear_references()
    -- Clear only buffer-specific autocmds
    vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = ev.buf })
  end,
})

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ setup vim.diagnostic.Config                           │
-- ╰──────────────────────────────────────────────────────────╯

local diagnostic_opts = {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN] = ' ',
      [vim.diagnostic.severity.HINT] = ' ',
      [vim.diagnostic.severity.INFO] = ' ',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
      [vim.diagnostic.severity.WARN] = 'DiagnosticWarn',
      [vim.diagnostic.severity.HINT] = 'DiagnosticHint',
      [vim.diagnostic.severity.INFO] = 'DiagnosticInfo',
    },
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    header = '',
  },
}

vim.diagnostic.config(diagnostic_opts)

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ server specific capabilities                          │
-- ╰──────────────────────────────────────────────────────────╯

local capabilities = vim.lsp.protocol.make_client_capabilities()

local has_blink = pcall(require, 'blink.cmp')
if has_blink then
  capabilities = vim.tbl_deep_extend(
    'force',
    capabilities,
    require('blink.cmp').get_lsp_capabilities({}, false)
  )
end

local has_markdown_oxide = vim.fn.executable('markdown-oxide') == 1
if has_markdown_oxide then
  capabilities = vim.tbl_deep_extend('force', capabilities, {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  })
end

vim.lsp.config('*', {
  capabilities = capabilities,
})

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ this is where magic happens                           │
-- ╰──────────────────────────────────────────────────────────╯

local servers = {
  'cssls',
  'lua_ls',
  'bashls',
  'yamlls',
  'jsonls',
  'markdown_oxide',
  'taplo',
  'pyright',
  'docker_language_server',
}

vim.lsp.enable(servers)

-- }}}

-- autocmd {{{

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight_yanked_text', { clear = true }),
  callback = function() vim.hl.on_yank({ higroup = 'IncSearch', timeout = 300 }) end,
})

vim.api.nvim_create_autocmd('ColorScheme', {
  desc = 'Set highlights after colorscheme loaded',
  group = vim.api.nvim_create_augroup('highlight_colorscheme', { clear = true }),
  callback = function()
    local M = require('highlights')
    for _, group in pairs(M) do
      for name, attrs in pairs(group) do
        vim.api.nvim_set_hl(0, name, attrs)
      end
    end
    vim.notify(
      'Colorscheme loaded and highlights set',
      vim.log.levels.INFO,
      { title = 'Neovim' }
    )
  end,
})

vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  desc = 'Show lsp line diagnostics automatically in hover window',
  group = vim.api.nvim_create_augroup('hover_diagnostics', { clear = true }),
  callback = function() vim.diagnostic.open_float(nil, { focus = false }) end,
})

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Proper "formatoptions"',
  group = vim.api.nvim_create_augroup('formatoptions', { clear = true }),
  callback = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end,
})

-- }}}

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ SET COLORSCHEME                                       │
-- ╰──────────────────────────────────────────────────────────╯
vim.cmd([[colorscheme catppuccin]])
