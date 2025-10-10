return {
  "yetone/avante.nvim",
  enabled = require("core.utils").is_sif(), -- only use on my macbook
  build = vim.fn.has "win32" ~= 0 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
    or "make",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    provider = "copilot",
    input = {
      provider = "snacks",
      provider_opts = {
        title = "Avante Input",
        icon = "",
      },
    },
  },
}
