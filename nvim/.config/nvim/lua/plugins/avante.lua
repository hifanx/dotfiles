return {
  "yetone/avante.nvim",
  enabled = require("core.utils").is_sif, -- only use on my macbook
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
  config = function(_, opts)
    vim.api.nvim_create_autocmd("FileType", {
      desc = "Enable treesitter for Avante",
      group = vim.api.nvim_create_augroup("avante_treesitter)", { clear = true }),
      pattern = { "Avante" },
      callback = function(ev) require("core.utils").start_treesitter(ev) end,
    })
    require("avante").setup(opts)
  end,
}
