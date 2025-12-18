-- bootstrap {{{

vim.loader.enable()

_G.GLOB = {}

-- namespaced profile
local os_name = vim.loop.os_uname().sysname:lower()
local hostname = vim.loop.os_gethostname()
GLOB.is_sif = (os_name == 'darwin' and hostname:find('sif') ~= nil)

-- }}}
-- {{{ colorscheme

vim.cmd([[colorscheme isekai]])

-- }}}
-- options {{{

local o = vim.opt
local g = vim.g

-- general
g.mapleader = ' '
o.undofile = true -- enable persistent undo
o.backup = false -- disable backup
o.confirm = true -- Confirm to save changes before exiting modified buffer
o.iskeyword = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part, default "@,48-57,_,192-255"
o.termguicolors = true

-- ui
o.winborder = 'rounded'
o.cursorline = true -- highlight the text line of the cursor
o.number = true -- show numberline
o.relativenumber = true -- show relative numberline
o.signcolumn = 'yes' -- always show the sign column

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

vim.schedule(function() require('vim._extui').enable({}) end)

--  }}}
-- mappings {{{

-- basic
vim.keymap.set('n', '<C-c>', ':close<CR>', { desc = '[C]lose' })
vim.keymap.set('n', '<Leader>y', ':%y+<CR>', { desc = '[Y]ank buffer' })

vim.keymap.set('n', 'H', ':bprev<CR>', { desc = 'Prev buffer', noremap = false })
vim.keymap.set('n', 'L', ':bnext<CR>', { desc = 'Next buffer', noremap = false })

vim.keymap.set('n', '=', [[:vertical resize +5<CR>]])
vim.keymap.set('n', '-', [[:vertical resize -5<CR>]])
vim.keymap.set('n', '+', [[:horizontal resize +2<CR>]])
vim.keymap.set('n', '_', [[:horizontal resize -2<CR>]])

-- delete the character to the right of the cursor
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

-- allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using : :map
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
vim.keymap.set({ 'n', 'x' }, 'j', 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { desc = 'Move down', expr = true })
vim.keymap.set({ 'n', 'x' }, 'k', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = 'Move up', expr = true })
vim.keymap.set({ 'n', 'v' }, '<Up>', 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { desc = 'Move up', expr = true })
vim.keymap.set(
    { 'n', 'v' },
    '<Down>',
    'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
    { desc = 'Move down', expr = true }
)

-- line operation
vim.keymap.set({ 'x', 'v' }, '<', '<gv', { desc = 'Indent line' })
vim.keymap.set({ 'x', 'v' }, '>', '>gv', { desc = 'Indent line' })
vim.keymap.set('v', 'J', ":move '>+1<CR>gv-gv", { desc = 'Move text down' })
vim.keymap.set('v', 'K', ":move '<-2<CR>gv-gv", { desc = 'Move text up' })

-- change text without putting it into register,
-- see https://stackoverflow.com/q/54255/6064933
vim.keymap.set('n', 'c', '"_c')
vim.keymap.set('n', 'C', '"_C')
vim.keymap.set('n', 'cc', '"_cc')
vim.keymap.set('x', 'c', '"_c')

-- don't copy the replaced text after pasting in visual mode
-- https://vim.fandom.com/wiki/Replace_a_word_with_yanked_text#Alternative_mapping_for_paste
vim.keymap.set('x', 'p', 'p:let @+=@0<CR>:let @"=@0<CR>', { desc = "Don't copy replaced text" })

-- commenting
vim.keymap.set('n', 'gco', 'o<esc>Vcx<esc>:normal gcc<CR>fxa<bs>', { desc = 'Add comment below' })
vim.keymap.set('n', 'gcO', 'O<esc>Vcx<esc>:normal gcc<CR>fxa<bs>', { desc = 'Add comment above' })

-- }}}
-- autocmd {{{

vim.api.nvim_create_autocmd('FileType', {
    desc = 'Enable spell check lazily and conditionally',
    pattern = { 'markdown', 'text', 'gitcommit' },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = { 'en_us', 'en_gb', 'cjk' }
    end,
})

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

-- }}}

vim.pack.add({
    -- ⬇️ EDITOR
    'https://github.com/fang2hou/blink-copilot.git',
    'https://github.com/rafamadriz/friendly-snippets.git',
    { src = 'https://github.com/saghen/blink.cmp.git', version = vim.version.range('*') },
    'https://github.com/stevearc/conform.nvim.git',
    'https://github.com/ibhagwan/fzf-lua.git',
    'https://github.com/mason-org/mason.nvim.git',
    'https://github.com/nvim-mini/mini.nvim.git',
    'https://github.com/nvim-treesitter/nvim-treesitter.git',
    -- ⬇️ TOOLS
    'https://github.com/smjonas/inc-rename.nvim.git',
    'https://github.com/j-hui/fidget.nvim.git',
    'https://github.com/stevearc/oil.nvim.git',
    'https://github.com/hotoo/pangu.vim.git',
    'https://github.com/folke/persistence.nvim.git',
    'https://github.com/christoomey/vim-tmux-navigator.git',
    -- ⬇️ UI
    'https://github.com/lewis6991/gitsigns.nvim.git',
    'https://github.com/AndreM222/copilot-lualine.git',
    'https://github.com/SmiteshP/nvim-navic.git',
    'https://github.com/nvim-lualine/lualine.nvim.git',
    'https://github.com/brenoprata10/nvim-highlight-colors.git',
    'https://github.com/MeanderingProgrammer/render-markdown.nvim.git',
    -- ⬇️ AI
    'https://github.com/zbirenbaum/copilot.lua.git',
})

-- lsp {{{

-- disable default keybinds
for _, bind in ipairs({ 'grn', 'gra', 'gri', 'grr', 'grt' }) do
    pcall(vim.keymap.del, 'n', bind)
end

-- setup lsp attach
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

        if client.supports_method(client, vim.lsp.protocol.Methods.textDocument_codeLens) then
            vim.keymap.set(
                'n',
                '<leader>ll',
                vim.lsp.codelens.refresh,
                { buffer = ev.buf, desc = 'Code[L]ens refresh' }
            )
            vim.keymap.set('n', '<leader>lL', vim.lsp.codelens.run, { buffer = ev.buf, desc = 'Code[L]ens run' })
        end

        if client.supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.keymap.set(
                'n',
                '<leader>li',
                function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end,
                { desc = 'Toggle [I]nlay hint' }
            )
        end

        if client.supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local hl_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = ev.buf,
                group = hl_augroup,
                callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = ev.buf,
                group = hl_augroup,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

vim.api.nvim_create_autocmd('LspDetach', {
    group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
    callback = function(ev)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = ev.buf })
    end,
})

-- vim.diagnostic.Config
vim.diagnostic.config({
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
})

-- server specific capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()

local has_blink = vim.pack.get({ 'blink.cmp' }, { info = false })[1].active
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

-- this is where magic happens
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
-- {{{ eager require

require('mini.starter').setup()

vim.keymap.set('n', '<leader>hf', ':Fidget history<CR>', { desc = '[F]idget history' })
require('fidget').setup({
    notification = {
        filter = vim.log.levels.DEBUG,
        override_vim_notify = true,
    },
})

vim.keymap.set('n', '<leader>o', function() require('oil').toggle_float() end, { desc = '[O]il' })
require('oil').setup({
    default_file_explorer = true,
    delete_to_trash = true,
    view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _) return name == '.git' end,
    },
    float = {
        max_width = 0.6,
        max_height = 0.9,
    },
    use_default_keymaps = true,
    -- See :help oil-actions for a list of all available actions
    keymaps = { -- these are defaults.
        ['g?'] = { 'actions.show_help', mode = 'n' },
        ['<CR>'] = 'actions.select',
        ['<C-s>'] = { 'actions.select', opts = { vertical = true } },
        ['<C-h>'] = { 'actions.select', opts = { horizontal = true } },
        ['<C-t>'] = { 'actions.select', opts = { tab = true } },
        ['<C-p>'] = 'actions.preview',
        ['<C-c>'] = { 'actions.close', mode = 'n' },
        ['<C-l>'] = 'actions.refresh',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
        ['`'] = { 'actions.cd', mode = 'n' },
        ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
        ['gs'] = { 'actions.change_sort', mode = 'n' },
        ['gx'] = 'actions.open_external',
        ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
        ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
    },
})

-- }}}
-- {{{ not so fast

local function not_so_fast(path)
    local co = coroutine.running()
    vim.schedule(function()
        dofile(path)
        coroutine.resume(co)
    end)
    coroutine.yield()
end

coroutine.wrap(function()
    local groups = {
        vim.api.nvim_get_runtime_file('lua/plugins/*.lua', true),
    }

    for _, files in ipairs(groups) do
        for _, path in ipairs(files) do
            not_so_fast(path)
        end
    end

    GLOB.timer.report()
end)()

-- }}}
