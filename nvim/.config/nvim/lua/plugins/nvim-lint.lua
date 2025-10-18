return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require('lint')

    lint.linters_by_ft = {
      python = { 'ruff' },
      markdown = { 'markdownlint' },
    }

    lint.linters.markdownlint.args = { '--disable MD013' }

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('lint', { clear = true }),
      callback = function() lint.try_lint() end,
    })
  end,
}
