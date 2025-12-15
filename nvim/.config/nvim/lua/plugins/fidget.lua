return {
  'j-hui/fidget.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('fidget').setup({
      notification = {
        override_vim_notify = true,
      },
    })
  end,
}
