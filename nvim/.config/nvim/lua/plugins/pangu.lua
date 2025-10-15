return {
  'hotoo/pangu.vim',
  cmd = { 'PanguAll' },
  init = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = { '*.markdown', '*.md', '*.text', '*.txt', '*.wiki', '*.cnx' },
      desc = 'Auto format text files with Pangu if available',
      callback = function()
        pcall(function() vim.cmd 'PanguAll' end)
        vim.notify('Format with Pangu', vim.log.levels.INFO)
      end,
    })
  end,
}
