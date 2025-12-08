-- bootstrap {{{

local profiler = require('profiler')

profiler.start('bootstrap')

_G.GLOB = {}

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ Namespaced profile                                    │
-- ╰──────────────────────────────────────────────────────────╯

local os_name = vim.loop.os_uname().sysname:lower()
local hostname = vim.loop.os_gethostname()

-- computed once on load and called with O(1) operation
_G.GLOB.is_sif = (os_name == 'darwin' and hostname:find('sif') ~= nil)

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ Util functions                                        │
-- ╰──────────────────────────────────────────────────────────╯

---Retrieve a value from a highlight group with fallback warnings
---@param hl_group string The highlight group name (e.g., "Normal", "Comment")
---@param attr string The attribute to retrieve ("fg", "bg", "sp", "bold", "italic", etc.)
---@param fallback any Optional fallback value to return if not found
---@return any|nil The attribute value or fallback/nil (colors always returned as hex strings)
function _G.GLOB.get_hl_value(hl_group, attr, fallback)
  local hl = vim.api.nvim_get_hl(0, { name = hl_group, link = false, create = false })

  if vim.tbl_isempty(hl) then
    vim.notify(
      string.format("Trying to retrieve from '%s' but highlight group doesn't exist", hl_group),
      vim.log.levels.WARN
    )
    return fallback
  end

  if hl[attr] == nil then
    vim.notify(
      string.format("Trying to retrieve from '%s' but '%s' doesn't exist", hl_group, attr),
      vim.log.levels.WARN
    )
    return fallback
  end

  local value = hl[attr]

  -- Always convert color values to hex
  local color_attrs = { fg = true, bg = true, sp = true }
  if color_attrs[attr] and type(value) == 'number' then return string.format('#%06x', value) end

  return value
end

profiler.stop('bootstrap')

-- }}}
-- {{{ colorscheme

profiler.start('colorscheme')

vim.cmd([[colorscheme isekai]])

profiler.stop('colorscheme')

-- }}}
-- options {{{

profiler.start('options')
-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ Option section                                        │
-- ╰──────────────────────────────────────────────────────────╯
local o = vim.opt
local g = vim.g

-- general
g.mapleader = ' '
o.mouse = 'a' -- enable mouse support
o.undofile = true -- enable persistent undo
o.backup = false -- disable backup
o.confirm = true -- Confirm to save changes before exiting modified buffer
o.iskeyword = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part
o.termguicolors = true
o.autoread = true

-- ui
o.winborder = 'solid'
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
o.fillchars = 'eob: ,fold:┄,foldclose:,foldopen:'

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

-- clipboard
o.clipboard = 'unnamedplus' -- connection to the system clipboard
if vim.env.SSH_CONNECTION then
  local function vim_paste()
    local content = vim.fn.getreg('"')
    return vim.split(content, '\n')
  end

  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = vim_paste,
      ['*'] = vim_paste,
    },
  }
end

-- disable some default providers
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0

-- see full list:
-- https://github.com/neovim/neovim/tree/master/runtime/plugin
g.loaded_2html_plugin = 1
g.loaded_gzip = 1
g.loaded_man = 1
g.loaded_tarPlugin = 1
g.loaded_zipPlugin = 1
g.loaded_remote_plugins = 1

-- ╭──────────────────────────────────────────────────────────╮
-- │ ⬇️ Experimental, update when necessary                   │
-- ╰──────────────────────────────────────────────────────────╯

vim.schedule(function()
  require('vim._extui').enable({
    enable = true,
    msg = {
      target = 'msg',
      timeout = 4000,
    },
  })
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'msg',
    callback = function()
      vim.opt_local.winblend = 30
      vim.opt_local.winborder = 'none'
      vim.opt_local.winhighlight = 'Normal:Comment,FloatBorder:Normal'
    end,
  })
end)

profiler.stop('options')

--  }}}
-- mappings {{{

profiler.start('mappings')

vim.schedule(function()
  -- basic
  vim.keymap.set('n', '<C-c>', ':close<CR>', { desc = '[C]lose' })
  vim.keymap.set('n', '<Leader>y', ':%y+<CR>', { desc = '[Y]ank buffer' })

  vim.keymap.set('n', 'H', ':bprev<CR>', { desc = 'Prev buffer', noremap = false })
  vim.keymap.set('n', 'L', ':bnext<CR>', { desc = 'Next buffer', noremap = false })

  vim.keymap.set('n', '=', [[:vertical resize +5<CR>]])
  vim.keymap.set('n', '-', [[:vertical resize -5<CR>]])
  vim.keymap.set('n', '+', [[:horizontal resize +2<CR>]])
  vim.keymap.set('n', '_', [[:horizontal resize -2<CR>]])

  -- Delete the character to the right of the cursor
  vim.keymap.set('i', '<C-D>', '<DEL>')

  -- navigate within insert mode
  vim.keymap.set('i', '<C-h>', '<Left>', { desc = 'Move left' })
  vim.keymap.set('i', '<C-l>', '<Right>', { desc = 'Move right' })
  vim.keymap.set('i', '<C-j>', '<Down>', { desc = 'Move down' })
  vim.keymap.set('i', '<C-k>', '<Up>', { desc = 'Move up' })

  -- turn the word under cursor to upper case
  vim.keymap.set('i', '<C-u>', '<Esc>viwUea', { desc = 'Turn into upper case' })
  -- turn the current word into title case
  vim.keymap.set('i', '<C-t>', '<Esc>b~lea', { desc = 'Turn into title case' })

  -- window management
  vim.keymap.set('n', '|', '<C-w>v', { desc = 'Split vertically' })
  vim.keymap.set('n', '\\', '<C-w>s', { desc = 'Split horizontally' })

  -- clear highlights
  vim.keymap.set('n', '<Esc>', ':noh<CR>', { desc = 'Clear highlights' })

  -- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
  -- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
  -- empty mode is same as using : :map
  -- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
  vim.keymap.set({ 'n', 'x' }, 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = 'Move down', expr = true })
  vim.keymap.set({ 'n', 'x' }, 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = 'Move up', expr = true })
  vim.keymap.set(
    { 'n', 'v' },
    '<Up>',
    'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
    { desc = 'Move up', expr = true }
  )
  vim.keymap.set(
    { 'n', 'v' },
    '<Down>',
    'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
    { desc = 'Move down', expr = true }
  )

  -- Line operation
  vim.keymap.set({ 'x', 'v' }, '<', '<gv', { desc = 'Indent line' })
  vim.keymap.set({ 'x', 'v' }, '>', '>gv', { desc = 'Indent line' })
  vim.keymap.set('v', 'J', ":move '>+1<CR>gv-gv", { desc = 'Move text down' })
  vim.keymap.set('v', 'K', ":move '<-2<CR>gv-gv", { desc = 'Move text up' })

  -- Change text without putting it into register,
  -- see https://stackoverflow.com/q/54255/6064933
  vim.keymap.set('n', 'c', '"_c')
  vim.keymap.set('n', 'C', '"_C')
  vim.keymap.set('n', 'cc', '"_cc')
  vim.keymap.set('x', 'c', '"_c')

  -- Don't copy the replaced text after pasting in visual mode
  -- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
  vim.keymap.set('x', 'p', 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Don't copy replaced text" })

  -- commenting
  vim.keymap.set('n', 'gco', 'o<esc>Vcx<esc>:normal gcc<CR>fxa<bs>', { desc = 'Add comment below' })
  vim.keymap.set('n', 'gcO', 'O<esc>Vcx<esc>:normal gcc<CR>fxa<bs>', { desc = 'Add comment above' })

  -- messages
  vim.keymap.set('n', '<Leader>m', ':messages<CR>', { desc = '[M]essages' })
end)

profiler.stop('mappings')

-- }}}
-- autocmd {{{

profiler.start('autocmd')

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text, cycle numbered registers',
  group = vim.api.nvim_create_augroup('highlight_yanked_text', { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = 'IncSearch', timeout = 300 })
    -- yank ring
    -- credit: https://github.com/justinmk/config/blob/be345533e05db933baa587f901e08061de5579fa/.config/nvim/init.lua#L676
    if vim.v.event.operator == 'y' then
      for i = 9, 1, -1 do -- Shift all numbered registers.
        vim.fn.setreg(tostring(i), vim.fn.getreg(tostring(i - 1)))
      end
    end
  end,
})

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Proper "formatoptions"',
  group = vim.api.nvim_create_augroup('formatoptions', { clear = true }),
  callback = function() vim.cmd('setlocal formatoptions-=c formatoptions-=o') end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore cursor to last edit position',
  group = vim.api.nvim_create_augroup('restore_cursor_position', { clear = true }),
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Auto resize splits on terminal resize',
  command = 'wincmd =',
})

vim.api.nvim_create_autocmd('BufRead', {
  desc = 'Syntax highlight for env files',
  group = vim.api.nvim_create_augroup('dotenv', { clear = true }),
  pattern = { '.env', '.env.*', '.secrets' },
  callback = function() vim.bo.filetype = 'dosini' end,
})

vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
  desc = 'Show cursorline only in active window',
  group = vim.api.nvim_create_augroup('active_cursorline', { clear = true }),
  callback = function() vim.opt_local.cursorline = true end,
})

vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
  desc = 'Hide cursorline in inactive window',
  group = 'active_cursorline',
  callback = function() vim.opt_local.cursorline = false end,
})

profiler.stop('autocmd')

-- }}}
-- lazy {{{

profiler.start('lazy')

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
vim.keymap.set('n', '<leader>hl', ':Lazy<CR>', { desc = '[L]azy' })

-- }}}

require('lazy').setup({
  spec = {
    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ EDITOR                                                │
    -- ╰──────────────────────────────────────────────────────────╯
    { import = 'plugins.blink' }, -- completion
    { import = 'plugins.conform' }, -- format
    { import = 'plugins.mason' }, -- auto install lsp server, formatter, linter
    { import = 'plugins.mini' }, -- editor, icons and more
    { import = 'plugins.nvim-treesitter' }, -- syntax highlighting
    { import = 'plugins.snacks' }, -- quality of life plugins
    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ TOOLS                                                 │
    -- ╰──────────────────────────────────────────────────────────╯
    { import = 'plugins.inc-rename' }, -- LSP renaming with immediate visual feedback
    { import = 'plugins.oil' },
    { import = 'plugins.pangu' }, -- auto format to add a space between cjk and english letters
    { import = 'plugins.persistence' }, -- session manager
    { import = 'plugins.vim-tmux-navigator' },
    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ UI                                                    │
    -- ╰──────────────────────────────────────────────────────────╯
    { import = 'plugins.gitsigns' },
    { import = 'plugins.lualine' },
    { import = 'plugins.nvim-highlight-colors' },
    { import = 'plugins.render-markdown' },
    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ AI                                                    │
    -- ╰──────────────────────────────────────────────────────────╯
    { import = 'plugins.copilot' },
  },
  defaults = { lazy = true, version = false }, -- always use the latest git commit
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  rocks = {
    enabled = false,
    hererocks = false,
  },
})

profiler.stop('lazy')

-- lsp {{{

profiler.start('lsp')

local function lsp()
  -- ╭──────────────────────────────────────────────────────────╮
  -- │ ⬇️ disable default keybinds                              │
  -- ╰──────────────────────────────────────────────────────────╯
  for _, bind in ipairs({ 'grn', 'gra', 'gri', 'grr', 'grt' }) do
    pcall(vim.keymap.del, 'n', bind)
  end

  -- ╭──────────────────────────────────────────────────────────╮
  -- │ ⬇️ setup lsp attach                                      │
  -- ╰──────────────────────────────────────────────────────────╯

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(ev)
      local client = vim.lsp.get_client_by_id(ev.data.client_id)
      if not client then return end

      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP [D]efinition' })
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP [D]eclaration' })
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { nowait = true, desc = 'LSP [R]eferences' })
      vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, { desc = 'LSP [I]mplementation' })
      vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, { desc = 'LSP T[y]pe Definition' })

      vim.keymap.set('n', 'gh', vim.diagnostic.open_float, { buffer = ev.buf, desc = 'LSP [H]over Diagnostic' })
      vim.keymap.set({ 'n', 'v' }, '<leader>la', vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'Code [A]ction' })
      vim.keymap.set('n', '<leader>lh', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = 'Signature [H]elp' })
      vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { buffer = ev.buf, desc = '[R]ename' })

      -- CodeLens support
      if client.supports_method(client, vim.lsp.protocol.Methods.textDocument_codeLens) then
        vim.keymap.set('n', '<leader>ll', vim.lsp.codelens.refresh, { buffer = ev.buf, desc = 'Code[L]ens refresh' })
        vim.keymap.set('n', '<leader>lL', vim.lsp.codelens.run, { buffer = ev.buf, desc = 'Code[L]ens run' })
      end

      -- Inlay hints
      if client.supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint) then
        vim.keymap.set(
          'n',
          '<leader>li',
          function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
          { desc = 'Toggle [I]nlay hint' }
        )
      end
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
    virtual_text = {
      virt_text_pos = 'eol_right_align',
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      border = 'rounded',
      header = '',
    },
  }

  vim.diagnostic.config(diagnostic_opts)

  -- ╭──────────────────────────────────────────────────────────╮
  -- │ ⬇️ server specific capabilities                          │
  -- ╰──────────────────────────────────────────────────────────╯

  local capabilities = vim.lsp.protocol.make_client_capabilities()

  local has_blink = require('lazy.core.config').plugins['blink.cmp'] ~= nil
  if has_blink then
    capabilities = vim.tbl_deep_extend('force', capabilities, {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    })
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
    'basedpyright',
    'docker_language_server',
  }

  vim.lsp.enable(servers)
end

vim.schedule(lsp)

profiler.stop('lsp')

-- }}}
-- {{{ timer

profiler.report()

-- }}}
