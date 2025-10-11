return {
  "saghen/blink.cmp",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "fang2hou/blink-copilot",
    { "saghen/blink.compat", opts = {} },
  },
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    local default = {
      "lsp",
      "snippets",
      "path",
      "buffer",
    }

    local ai = {
      "copilot",
      "avante_commands",
      "avante_mentions",
      "avante_shortcuts",
      "avante_files",
    }

    local is_sif = require("core.utils").is_sif()
    if is_sif then vim.list_extend(default, ai) end

    return {
      keymap = {
        preset = "none",
        ["<C-space>"] = false,
        ["<C-w>"] = { "show", "cancel", "fallback" },
        ["<C-y>"] = { "select_and_accept", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback_to_mappings" },
        ["<C-j>"] = { "select_next", "fallback_to_mappings" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-r>"] = { "show_signature", "hide_signature", "fallback" },
      },

      appearance = {
        nerd_font_variant = "mono",
      },

      cmdline = {
        keymap = {
          preset = "none",
          ["<Tab>"] = { "show_and_insert_or_accept_single", "select_next" },
          ["<S-Tab>"] = { "show_and_insert_or_accept_single", "select_prev" },
          ["<C-space>"] = false,
          ["<C-j>"] = { "select_next", "fallback" },
          ["<C-k>"] = { "select_prev", "fallback" },
          ["<Right>"] = { "select_next", "fallback" },
          ["<Left>"] = { "select_prev", "fallback" },
          ["<C-y>"] = { "select_and_accept", "fallback" },
          ["<C-w>"] = { "show", "cancel", "fallback" },
        },
      },

      -- NOTE: Use :BlinkCmp status to view which sources providers are enabled or not enabled
      sources = {
        default = default,
        providers = {
          copilot = {
            name = "copilot",
            module = "blink-copilot",
            score_offset = -10,
            async = true,
            opts = {
              kind_hl = "BlinkCmpKindCopilot",
            },
          },
          path = {
            -- Path completion from cwd instead of current buffer's directory
            opts = { get_cwd = function(_) return vim.fn.getcwd() end },
          },
          avante_commands = {
            name = "avante_commands",
            module = "blink.compat.source",
            score_offset = 10,
            opts = {},
          },
          avante_mentions = {
            name = "avante_mentions",
            module = "blink.compat.source",
            score_offset = 20,
            opts = {},
          },
          avante_shortcuts = {
            name = "avante_shortcuts",
            module = "blink.compat.source",
            score_offset = 30,
            opts = {},
          },
          avante_files = {
            name = "avante_files",
            module = "blink.compat.source",
            score_offset = 40,
            opts = {},
          },
        },
      },
      completion = {
        menu = {
          scrollbar = false,
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
          },
        },
        documentation = {
          auto_show_delay_ms = 200,
          auto_show = true,
        },
      },
    }
  end,
  config = function(_, opts)
    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuOpen",
      callback = function()
        require("copilot.suggestion").dismiss()
        vim.b.copilot_suggestion_hidden = true
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "BlinkCmpMenuClose",
      callback = function() vim.b.copilot_suggestion_hidden = false end,
    })
    require("blink.cmp").setup(opts)
  end,
}
