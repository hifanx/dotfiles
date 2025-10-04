return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
  ft = { "markdown", "Avante" },
  opts = {
    file_types = { "markdown", "Avante" },
    heading = {
      position = "inline",
      icons = { "󰼏 ", "󰼐 ", "󰼑 ", "󰼒 ", "󰼓 ", "󰼔 " },
    },
    code = {
      sign = false,
      style = "full",
      width = "block",
      left_pad = 2,
      right_pad = 2,
      language_pad = 2,
      border = "thick",
    },
    pipe_table = {
      preset = "double",
    },
    latex = { enabled = false },
  },
}
