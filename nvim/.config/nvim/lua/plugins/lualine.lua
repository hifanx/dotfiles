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

-- navic component
local navic = require('nvim-navic')
navic.setup({
    highlight = true,
    lsp = {
        auto_attach = true,
    },
})
local function hide_in_width() return vim.fn.winwidth(0) > 80 end

-- winbar filename
local winbar_filename = {
    'filename',
    fmt = function(str)
        if vim.bo.filetype == 'qf' then return ' ' end
        return str
    end,
}

-- ⬇️ theme
local c = require('palette').isekai -- O(1), already cached after colorscheme load
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

local lualine = require('lualine')
lualine.setup({

    options = {
        theme = theme,
        globalstatus = true,
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
    },

    winbar = {

        lualine_c = {
            winbar_filename,
            {
                navic.get_location,
                cond = function() return navic.is_available() and hide_in_width() end,
            },
        },
    },
    inactive_winbar = {
        lualine_c = {
            winbar_filename,
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
                'diff',
                cond = hide_in_width,
                symbols = {
                    added = ' ',
                    modified = ' ',
                    removed = ' ',
                },
            },
            {
                'diagnostics',
                cond = hide_in_width,
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
                cond = hide_in_width,
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
                show_name = true,
                ignore_lsp = {
                    'render-markdown',
                },
            },
            {
                'location',
                cond = hide_in_width,
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

-- hides lualine on dashboard and empty page ([NO NAME])
local function is_dashboard() return vim.fn.bufname() == '' and vim.bo.buftype == '' and vim.bo.filetype == '' end

vim.schedule(function()
    if is_dashboard() then lualine.hide() end
end)

vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufEnter' }, {
    callback = function()
        if is_dashboard() then
            lualine.hide()
        else
            lualine.hide({ unhide = true })
        end
    end,
})
