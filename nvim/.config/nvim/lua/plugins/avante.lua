return {
  "yetone/avante.nvim",
  enabled = require("core.utils").is_sif(), -- only use on my macbook
  build = "make BUILD_FROM_SOURCE=true",
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
