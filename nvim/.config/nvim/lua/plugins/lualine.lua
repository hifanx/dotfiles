GLOB.timer.start('lualine')
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
        a = { bg = c.lavender, fg = c.base, gui = 'bold' },
        b = { bg = c.none, fg = c.lavender },
        c = { bg = c.none, fg = c.white, gui = 'bold' },
    },
    insert = {
        a = { bg = c.peach, fg = c.base, gui = 'bold' },
        b = { bg = c.none, fg = c.peach },
    },
    visual = {
        a = { bg = c.green, fg = c.base, gui = 'bold' },
        b = { bg = c.none, fg = c.green },
    },
    replace = {
        a = { bg = c.peach, fg = c.base, gui = 'bold' },
        b = { bg = c.none, fg = c.peach },
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
    sections = {
        lualine_a = {
            {
                'mode',
                fmt = function(str) return str:sub(1, 1) end,
                color = { gui = 'bold' },
            },
        },
        lualine_b = {
            { 'branch', icon = { '' } },
        },
        lualine_c = {
            { 'filename' },
            {
                navic_component,
                cond = conditions.navic_available,
            },
        },
        lualine_x = {
            { trailing },
            { indent },
            {
                'copilot',
                cond = conditions.is_sif,
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
                icon = ' ',
                symbols = {
                    separator = '',
                },
                ignore_lsp = { 'copilot' },
                show_name = true,
            },
            { 'location' },
        },
        lualine_z = {
            { 'progress' },
        },
    },
})
GLOB.timer.stop('lualine')
