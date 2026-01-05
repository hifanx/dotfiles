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
o.pumborder = 'rounded'
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
o.shiftwidth = 4 -- number of space inserted for indentation
o.softtabstop = 4 -- number of spaces that a <Tab> counts for.
o.tabstop = 4 -- number of space in a tab
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
vim.schedule(function() -- to avoid increasing startup-time
    o.clipboard = 'unnamedplus' -- connection to the system clipboard
end)

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

vim.api.nvim_create_autocmd({ 'InsertLeave', 'WinEnter' }, {
    desc = 'No cusorline in INSERT or inactive',
    group = vim.api.nvim_create_augroup('CursorLineToggle', { clear = true }),
    callback = function() vim.opt_local.cursorline = true end,
})

vim.api.nvim_create_autocmd({ 'InsertEnter', 'WinLeave' }, {
    desc = 'Cusorline when not in INSERT and active',
    group = 'CursorLineToggle',
    callback = function() vim.opt_local.cursorline = false end,
})

-- }}}

vim.pack.add({
    -- ⬇️ EDITOR
    'https://github.com/fang2hou/blink-copilot.git',
    { src = 'https://github.com/saghen/blink.cmp.git', version = vim.version.range('*') },
    'https://github.com/stevearc/conform.nvim.git',
    'https://github.com/ibhagwan/fzf-lua.git',
    'https://github.com/L3MON4D3/LuaSnip.git',
    'https://github.com/nvim-mini/mini.nvim.git',
    'https://github.com/nvim-treesitter/nvim-treesitter.git',
    -- ⬇️ TOOLS
    'https://github.com/mason-org/mason.nvim.git',
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

-- setup lsp attach
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if not client then return end

        vim.keymap.set('n', 'grd', vim.lsp.buf.definition, { desc = 'LSP [D]efinition' })
        vim.keymap.set('n', 'grD', vim.lsp.buf.declaration, { desc = 'LSP [D]eclaration' })
        vim.keymap.set('n', 'gh', vim.diagnostic.open_float, { buffer = ev.buf, desc = 'LSP [H]over Diagnostic' })

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
            vim.api.nvim_create_autocmd('LspDetach', {
                group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
                callback = function(ev1)
                    vim.lsp.buf.clear_references()
                    vim.api.nvim_clear_autocmds({ group = 'lsp-highlight', buffer = ev1.buf })
                end,
            })
        end
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

require('mini.starter').setup() -- self explanatory
require('mini.icons').setup() -- dependency for oil.nvim and others

vim.keymap.set('n', '<leader>o', function() require('oil').toggle_float() end, { desc = '[O]il' })
require('oil').setup({ -- g? to see help & keymaps
    default_file_explorer = true,
    delete_to_trash = true,
    view_options = {
        show_hidden = true, -- but not .git ↓
        is_always_hidden = function(name, _) return name == '.git' end,
    },
    float = {
        max_width = 0.6,
        max_height = 0.9,
    },
})

-- }}}
-- {{{ not so fast

-- lualine {{{
vim.api.nvim_create_autocmd({ 'BufReadPre', 'BufNewFile' }, {
    once = true,
    callback = function()
        -- mixed indent component
        local indent = function()
            local space_pat = [[\v^ +]]
            local tab_pat = [[\v^\t+]]
            local space_indent = vim.fn.search(space_pat, 'nwc')
            local tab_indent = vim.fn.search(tab_pat, 'nwc')
            local mixed = (space_indent > 0 and tab_indent > 0)
            local mixed_same_line
            if not mixed then
                mixed_same_line = vim.fn.search([[\v^(\t+ | +\t)]], 'nwc')
                mixed = mixed_same_line > 0
            end
            if not mixed then return '' end
            if mixed_same_line ~= nil and mixed_same_line > 0 then return 'MI:' .. mixed_same_line end
            local space_indent_cnt = vim.fn.searchcount({ pattern = space_pat, max_count = 1e3 }).total
            local tab_indent_cnt = vim.fn.searchcount({ pattern = tab_pat, max_count = 1e3 }).total
            if space_indent_cnt > tab_indent_cnt then
                return 'MI:' .. tab_indent
            else
                return 'MI:' .. space_indent
            end
        end

        -- trailing white spaces component
        local trailing = function()
            local space = vim.fn.search([[\s\+$]], 'nwc')
            return space ~= 0 and 'TW:' .. space or ''
        end

        -- navic coponent
        local navic = require('nvim-navic')
        navic.setup({
            highlight = true,
            lsp = {
                auto_attach = true,
            },
        })
        local function navic_component() return navic.get_location() end

        -- conditions for components to show
        local conditions = {
            buffer_not_empty = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 end,
            hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
            is_sif = function() return GLOB.is_sif end,
            navic_available = function() return navic.is_available() end,
        }

        -- ⬇️ theme
        local c = require('palette').isekai -- this is O(1) since already required at colorscheme
        local theme = {
            normal = {
                a = { bg = c.white, fg = c.base, gui = 'bold' },
                b = { bg = c.none, fg = c.white },
                c = { bg = c.none, fg = c.white, gui = 'bold' },
            },
            insert = {
                a = { bg = c.orange, fg = c.base, gui = 'bold' },
                b = { bg = c.none, fg = c.orange },
            },
            visual = {
                a = { bg = c.green, fg = c.base, gui = 'bold' },
                b = { bg = c.none, fg = c.green },
            },
            replace = {
                a = { bg = c.orange, fg = c.base, gui = 'bold' },
                b = { bg = c.none, fg = c.orange },
            },
            command = {
                a = { bg = c.red, fg = c.base, gui = 'bold' },
                b = { bg = c.none, fg = c.red },
            },
            inactive = {
                a = { bg = c.none, fg = c.blue, gui = 'bold' },
                b = { bg = c.none, fg = c.overlay },
                c = { bg = c.none, fg = c.overlay },
            },
        }

        -- ⬇️ setup the thing
        require('lualine').setup({
            options = {
                theme = theme,
                globalstatus = true,
                section_separators = { left = '', right = '' },
                component_separators = { left = '', right = '' },
            },
            winbar = {

                lualine_c = {
                    { 'filename' },
                    {
                        navic_component,
                        cond = conditions.navic_available and conditions.hide_in_width,
                    },
                },
            },
            inactive_winbar = {
                lualine_c = {
                    { 'filename' },
                },
            },
            sections = {
                lualine_a = {
                    {
                        'mode',
                        fmt = function(str) return str:sub(1, 1) end,
                        color = { gui = 'bold' },
                        separator = { right = '▓▒░' },
                    },
                },
                lualine_b = {
                    { 'branch', icon = { '' } },
                },
                lualine_c = {
                    {
                        'buffers',
                        show_filename_only = true,
                        hide_filename_extension = true,
                        show_modified_status = true,
                        mode = 0, -- 0: Shows buffer name 1: Shows buffer index 2: Shows buffer name + buffer index 3: Shows buffer number 4: Shows buffer name + buffer number
                        max_length = vim.o.columns * 2 / 3,
                        filetype_names = {
                            help = '',
                            mason = ' ',
                            checkhealth = '󰀯 ',
                        },
                        buffers_color = {
                            active = 'lualine_c_normal',
                            inactive = 'lualine_c_inactive',
                        },
                        symbols = {
                            modified = '',
                            alternate_file = '', -- Text to show to identify the alternate file
                            directory = ' ', -- Text to show when the buffer is a directory
                        },
                    },
                },
                lualine_x = {
                    { trailing },
                    { indent },
                    {
                        'copilot',
                        cond = conditions.is_sif and conditions.hide_in_width,
                        symbols = {
                            status = {
                                icons = {
                                    enabled = ' ',
                                    sleep = ' ',
                                    disabled = ' ',
                                    warning = ' ',
                                    unknown = ' ',
                                },
                                hl = {
                                    enabled = c.green,
                                    sleep = c.green,
                                    disabled = c.overlay,
                                    warning = c.yellow,
                                    unknown = c.red,
                                },
                            },
                            spinners = require('copilot-lualine.spinners').dots,
                        },
                        show_colors = true,
                        show_loading = true,
                    },
                    {
                        'diff',
                        cond = conditions.hide_in_width,
                        symbols = {
                            added = ' ',
                            modified = ' ',
                            removed = ' ',
                        },
                    },
                    {
                        'diagnostics',
                        cond = conditions.hide_in_width,
                        sources = { 'nvim_diagnostic' },
                        symbols = {
                            error = ' ',
                            warn = ' ',
                            info = ' ',
                            hint = ' ',
                        },
                    },
                },
                lualine_y = {
                    {
                        'lsp_status',
                        cond = conditions.hide_in_width,
                        icon = ' ',
                        symbols = {
                            separator = '',
                            spinner = {
                                '▰▱▱▱▱▱▱',
                                '▰▰▱▱▱▱▱',
                                '▰▰▰▱▱▱▱',
                                '▰▰▰▰▱▱▱',
                                '▰▰▰▰▰▱▱',
                                '▰▰▰▰▰▰▱',
                                '▰▰▰▰▰▰▰',
                                '▰▱▱▱▱▱▱',
                            },
                        },
                        ignore_lsp = { 'copilot' },
                        show_name = true,
                    },
                    {
                        'location',
                        cond = conditions.hide_in_width,
                    },
                },
                lualine_z = {
                    {
                        'progress',
                        separator = { left = '░▒▓' },
                    },
                },
            },
        })
    end,
})

-- }}}

vim.api.nvim_create_autocmd('VimEnter', {
    once = true,
    callback = function()
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
        end)()
    end,
})

-- }}}
