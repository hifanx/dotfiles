return {
  'nvim-lualine/lualine.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'nvim-mini/mini.icons',
    'AndreM222/copilot-lualine',
  },
  config = function()
    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ themes                                                │
    -- ╰──────────────────────────────────────────────────────────╯
    local c = require('palette').catppuccin
    local theme = function()
      return {
        inactive = {
          a = { fg = c.subtext0, bg = c.base },
          b = { fg = c.subtext0, bg = c.surface0 },
          c = { fg = c.subtext0, bg = c.base },
        },
        visual = {
          a = { fg = c.mantle, bg = c.peach },
          b = { fg = c.peach, bg = c.surface0 },
          c = { fg = c.subtext0, bg = c.base },
        },
        replace = {
          a = { fg = c.mantle, bg = c.maroon },
          b = { fg = c.maroon, bg = c.surface0 },
          c = { fg = c.subtext0, bg = c.base },
        },
        normal = {
          a = { fg = c.mantle, bg = c.blue },
          b = { fg = c.blue, bg = c.surface0 },
          c = { fg = c.subtext0, bg = c.base },
        },
        insert = {
          a = { fg = c.mantle, bg = c.green },
          b = { fg = c.green, bg = c.surface0 },
          c = { fg = c.subtext0, bg = c.base },
        },
        command = {
          a = { fg = c.mantle, bg = c.yellow },
          b = { fg = c.yellow, bg = c.surface0 },
          c = { fg = c.subtext0, bg = c.base },
        },
      }
    end

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ lazy status component                                 │
    -- ╰──────────────────────────────────────────────────────────╯
    local lazy_status = require('lazy.status')
    local lazy = function() return lazy_status.updates() end

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ Mixed indent component                                │
    -- ╰──────────────────────────────────────────────────────────╯
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

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ Trailing white spaces component                       │
    -- ╰──────────────────────────────────────────────────────────╯
    local trailing = function()
      local space = vim.fn.search([[\s\+$]], 'nwc')
      return space ~= 0 and 'TW:' .. space or ''
    end

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ conditions for components to show                     │
    -- ╰──────────────────────────────────────────────────────────╯
    local conditions = {
      buffer_not_empty = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 end,
      hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
      lazy_status = lazy_status.has_updates,
      is_sif = function() return GLOB.is_sif end,
    }

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ setup the thing                                       │
    -- ╰──────────────────────────────────────────────────────────╯
    require('lualine').setup({
      options = {
        theme = theme,
        globalstatus = true,
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          { 'mode', icon = '' },
        },
        lualine_b = {
          { 'branch', icon = { ' ' } },
        },
        lualine_c = {
          {
            'diff',
            cond = conditions.hide_in_width,
            symbols = {
              added = ' ',
              modified = ' ',
              removed = ' ',
            },
            diff_color = {
              added = { fg = c.green },
              modified = { fg = c.peach },
              removed = { fg = c.red },
            },
          },
          { trailing },
          { indent },
          { function() return '%=' end },
          {
            'diagnostics',
            sources = { 'nvim_diagnostic' },
            symbols = {
              error = ' ',
              warn = ' ',
              info = ' ',
              hint = ' ',
            },
            diagnostics_color = {
              color_error = { link = 'DiagnosticError' },
              color_warn = { link = 'DiagnosticWarn' },
              color_info = { link = 'DiagnosticInfo' },
              color_hint = { link = 'DiagnosticHint' },
            },
          },
        },
        lualine_x = {
          { lazy, cond = conditions.lazy_status, color = { fg = c.peach } },
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
                  sleep = c.sky,
                  disabled = c.yellow,
                  warning = c.peach,
                  unknown = c.red,
                },
              },
              spinners = require('copilot-lualine.spinners').dots,
              spinner_color = c.yellow,
            },
            show_colors = true,
            show_loading = true,
          },
          {
            'buffers',
            show_filename_only = true,
            hide_filename_extension = true,
            show_modified_status = true,
            mode = 0, -- 0: Shows buffer name 1: Shows buffer index 2: Shows buffer name + buffer index 3: Shows buffer number 4: Shows buffer name + buffer number
            max_length = vim.o.columns * 2 / 3,
            filetype_names = {
              TelescopePrompt = ' ',
              snacks_dashboard = ' ',
              snacks_input = ' ',
              snacks_notif_history = ' ',
              snacks_picker_list = ' ',
              snacks_picker_input = ' ',
              fzf = ' ',
              NvimTree = ' ',
              lazy = '󰒲 ',
              help = '',
              mason = ' ',
              Avante = ' ',
              AvanteInput = ' ',
              AvanteTodos = ' ',
              AvanteSelectedFiles = ' ',
              checkhealth = '󰀯 ',
            },
            buffers_color = {
              active = 'lualine_b_command',
              inactive = 'lualine_c_inactive',
            },
            symbols = {
              modified = '',
              alternate_file = '', -- Text to show to identify the alternate file
              directory = ' ', -- Text to show when the buffer is a directory
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
        },
        lualine_z = {
          { 'progress' },
        },
      },
    })
  end,
}
