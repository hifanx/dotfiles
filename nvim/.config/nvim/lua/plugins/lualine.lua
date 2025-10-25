return {
  'nvim-lualine/lualine.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'nvim-mini/mini.icons',
    'AndreM222/copilot-lualine',
  },
  config = function()
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

    local normal_ish = _G.GLOB.get_hl_value('Normal', 'bg')
    local warn_ish_fg = _G.GLOB.get_hl_value('WarningMsg', 'fg')
    local ok_ish_fg = _G.GLOB.get_hl_value('OkMsg', 'fg')
    local nontext_ish_fg = _G.GLOB.get_hl_value('NonText', 'fg')
    local err_ish_fg = _G.GLOB.get_hl_value('OkMsg', 'fg')

    require('lualine').setup({
      options = {
        theme = (function() -- make section c normal background, keep everything else 'auto'
          local theme = require('lualine.themes.' .. vim.g.colors_name)
          for _, sections in pairs(theme) do
            if sections.c then sections.c.bg = normal_ish end
          end
          return theme
        end)(),
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
            lazy,
            cond = conditions.lazy_status,
            color = { fg = warn_ish_fg },
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
                  enabled = ok_ish_fg,
                  sleep = nontext_ish_fg,
                  disabled = nontext_ish_fg,
                  warning = warn_ish_fg,
                  unknown = err_ish_fg,
                },
              },
              spinners = require('copilot-lualine.spinners').dots,
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
              active = 'lualine_b_visual',
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
