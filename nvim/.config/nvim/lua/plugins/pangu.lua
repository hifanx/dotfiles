return {
  "hotoo/pangu.vim",
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "PanguAll" },
  config = function()
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.markdown", "*.md", "*.text", "*.txt", "*.wiki", "*.cnx" },
      desc = "Auto format text files with Pangu if available",
      callback = function()
        pcall(function() vim.cmd "PanguAll" end)
      end,
    })
  end,
}
