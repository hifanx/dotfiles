return {
  'nvim-lualine/lualine.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'AndreM222/copilot-lualine',
  },
  config = function()
    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ lazy status component                                 │
    -- ╰──────────────────────────────────────────────────────────╯
    local lazy_status = require('lazy.status')
    local lazy = function() return lazy_status.updates() end

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ mixed indent component                                │
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
    -- │ ⬇️ trailing white spaces component                       │
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
    -- │ ⬇️ theme                                                 │
    -- ╰──────────────────────────────────────────────────────────╯
    local c = require('palette').isekai -- this is O(1) since already required at colorscheme
    local theme = {
      normal = {
        a = { bg = c.white, fg = c.base, gui = 'bold' },
        b = { bg = c.none, fg = c.white },
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
            lazy,
            cond = conditions.lazy_status,
            color = { fg = c.peach },
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
          },
        },
        lualine_x = {
          {
            'buffers',
            show_filename_only = true,
            hide_filename_extension = true,
            show_modified_status = true,
            mode = 0, -- 0: Shows buffer name 1: Shows buffer index 2: Shows buffer name + buffer index 3: Shows buffer number 4: Shows buffer name + buffer number
            max_length = vim.o.columns * 2 / 3,
            filetype_names = {
              lazy = '󰒲 ',
              help = '',
              mason = ' ',
              checkhealth = '󰀯 ',
              ['nvim-pack'] = ' ',
              snacks_dashboard = ' ',
              snacks_input = ' ',
              snacks_notif_history = ' ',
              snacks_picker_list = ' ',
              snacks_picker_input = ' ',
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
  end,
}
