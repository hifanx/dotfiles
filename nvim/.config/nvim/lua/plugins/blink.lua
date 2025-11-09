return {
  'saghen/blink.cmp',
  dependencies = {
    'rafamadriz/friendly-snippets',
    'fang2hou/blink-copilot',
  },
  version = '*',
  event = { 'InsertEnter', 'CmdlineEnter' },
  config = function()
    if pcall(require, 'copilot') then
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
          require('copilot.suggestion').dismiss()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuClose',
        callback = function() vim.b.copilot_suggestion_hidden = false end,
      })
    end

    local default = {
      'lsp',
      'snippets',
      'path',
      'buffer',
    }

    local ai = {
      'copilot',
    }

    local is_sif = GLOB.is_sif
    if is_sif then vim.list_extend(default, ai) end

    require('blink.cmp').setup({
      keymap = {
        preset = 'none',
        ['<C-space>'] = false,
        ['<C-w>'] = { 'show', 'cancel', 'fallback' },
        ['<C-y>'] = { 'select_and_accept', 'fallback' },
        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        ['<C-r>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },

      cmdline = {
        keymap = {
          preset = 'none',
          ['<Tab>'] = { 'show_and_insert_or_accept_single', 'select_next' },
          ['<S-Tab>'] = { 'show_and_insert_or_accept_single', 'select_prev' },
          ['<C-space>'] = false,
          ['<C-j>'] = { 'select_next', 'fallback' },
          ['<C-k>'] = { 'select_prev', 'fallback' },
          ['<Right>'] = { 'select_next', 'fallback' },
          ['<Left>'] = { 'select_prev', 'fallback' },
          ['<C-y>'] = { 'select_and_accept', 'fallback' },
          ['<C-w>'] = { 'show', 'cancel', 'fallback' },
        },
        completion = {
          list = {
            selection = {
              preselect = false,
              auto_insert = false,
            },
          },
          menu = { auto_show = true },
        },
      },

      -- NOTE: Use :BlinkCmp status to view which sources providers are enabled or not enabled
      sources = {
        default = default,
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = -10,
            async = true,
            opts = {
              kind_hl = 'BlinkCmpKindCopilot',
            },
          },
          path = {
            -- Path completion from cwd instead of current buffer's directory
            opts = { get_cwd = function(_) return vim.fn.getcwd() end },
          },
        },
      },
      completion = {
        menu = {
          scrollbar = false,
          draw = {
            treesitter = { 'lsp' },
            columns = {
              { 'kind_icon' },
              { 'label', 'label_description', gap = 1 },
              { 'source_name' },
            },
          },
        },
        documentation = {
          auto_show_delay_ms = 0,
          auto_show = true,
          window = {
            border = 'rounded',
          },
        },
        ghost_text = {
          enabled = true,
        },
      },
    })
  end,
}
