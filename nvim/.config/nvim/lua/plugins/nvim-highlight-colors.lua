return {
  'brenoprata10/nvim-highlight-colors',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('nvim-highlight-colors').setup({
      enable_hex = false,
    })
  end,
}
