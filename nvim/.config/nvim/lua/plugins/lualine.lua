return {
  'nvim-lualine/lualine.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'AndreM222/copilot-lualine',
  },
  config = function()
    local c = require('core.palette').catppuccin
    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ themes                                                │
    -- ╰──────────────────────────────────────────────────────────╯
    local theme = function()
      return {
        inactive = {
          a = { fg = c.text, bg = c.base, gui = 'bold' },
          b = { fg = c.text, bg = c.base },
          c = { fg = c.text, bg = c.base },
        },
        visual = {
          a = { fg = c.mantle, bg = c.peach, gui = 'bold' },
          b = { fg = c.peach, bg = c.base },
          c = { fg = c.text, bg = c.base },
        },
        replace = {
          a = { fg = c.mantle, bg = c.maroon, gui = 'bold' },
          b = { fg = c.maroon, bg = c.base },
          c = { fg = c.text, bg = c.base },
        },
        normal = {
          a = { fg = c.mantle, bg = c.blue, gui = 'bold' },
          b = { fg = c.blue, bg = c.base },
          c = { fg = c.text, bg = c.base },
        },
        insert = {
          a = { fg = c.mantle, bg = c.green, gui = 'bold' },
          b = { fg = c.green, bg = c.base },
          c = { fg = c.text, bg = c.base },
        },
        command = {
          a = { fg = c.mantle, bg = c.yellow, gui = 'bold' },
          b = { fg = c.yellow, bg = c.base },
          c = { fg = c.text, bg = c.base },
        },
      }
    end

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ lsp client component                                  │
    -- ╰──────────────────────────────────────────────────────────╯
    local lsp = function()
      local clients = vim.lsp.get_clients()
      local msg = 'No Active Lsp'
      if next(clients) == nil then
        return msg
      else
        local co = {}
        for _, client in ipairs(clients) do
          if client.name ~= 'copilot' then table.insert(co, client.name) end
        end
        if next(co) == nil then
          return msg
        else
          return table.concat(co, '|')
        end
      end
    end

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ lazy status component                                 │
    -- ╰──────────────────────────────────────────────────────────╯
    local lazy_status = require 'lazy.status'
    local lazy = function() return lazy_status.updates() end

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ vim component                                         │
    -- ╰──────────────────────────────────────────────────────────╯
    local vim_icon = function() return '' end

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ conditions for components to show                     │
    -- ╰──────────────────────────────────────────────────────────╯
    local conditions = {
      buffer_not_empty = function() return vim.fn.empty(vim.fn.expand '%:t') ~= 1 end,
      hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
      lazy_status = lazy_status.has_updates,
      is_sif = function() return require('core.utils').is_sif end,
    }

    -- ╭──────────────────────────────────────────────────────────╮
    -- │ ⬇️ setup the thing                                       │
    -- ╰──────────────────────────────────────────────────────────╯
    require('lualine').setup {
      disabled_filetypes = {
        winbar = {
          'noice',
        },
      },
      options = {
        theme = theme,
        globalstatus = true,
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
      },
      sections = {
        lualine_a = {
          {
            vim_icon,
            color = { gui = 'bold' },
          },
        },
        lualine_b = {
          {
            'branch',
            color = { gui = 'bold' },
          },
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
          {
            lazy,
            cond = conditions.lazy_status,
            color = { fg = c.peach },
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
        },
        lualine_y = {
          {
            lsp,
            icon = ' ',
            color = { gui = 'bold' },
          },
        },
        lualine_z = {
          {
            'progress',
            color = { gui = 'bold' },
          },
        },
      },
    }
  end,
}
