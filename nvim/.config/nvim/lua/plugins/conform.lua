return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<Leader>lf",
      function() require("conform").format { async = true } end,
      mode = "",
      desc = "[F]ormat buffer",
    },
    { "<Leader>hI", ":ConformInfo<CR>", mode = "n", desc = "[C]onform info" },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black" },
      markdown = { "markdownlint" },
      svelte = { "prettier" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      vue = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      graphql = { "prettier" },
      handlebars = { "prettier" },
      sh = { "shfmt" },
      bash = { "shfmt" },
      toml = { "taplo" },
    },
    formatters = {
      shfmt = { prepend_args = { "-i", "2" } },
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    -- format_on_save = {
    --   timeout_ms = 500,
    --   lsp_format = "fallback",
    -- },
  },
}
