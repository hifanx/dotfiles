return {
  'yetone/avante.nvim',
  enabled = GLOB.is_sif, -- only use on my macbook
  build = vim.fn.has('win32') ~= 0
      and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
    or 'make',
  event = 'VeryLazy',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      desc = 'Start treesitter for Avante',
      pattern = 'Avante',
      callback = function(ev) vim.treesitter.start(ev.buf) end,
    })

    require('avante').setup({
      provider = 'copilot',
      input = {
        provider = 'snacks',
        provider_opts = {
          title = 'Avante Input',
          icon = '',
        },
      },
    })
  end,
}
