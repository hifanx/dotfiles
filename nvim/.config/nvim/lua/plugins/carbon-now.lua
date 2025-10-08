return {
  "ellisonleao/carbon-now.nvim",
  cmd = "CarbonNow",
  keys = {
    { "<leader>hc", ":CarbonNow<CR>", mode = { "n", "v" }, desc = "Screenshot code" },
  },
  opts = { open_cmd = "open" },
}
