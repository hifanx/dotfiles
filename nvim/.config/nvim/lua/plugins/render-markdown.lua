return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ft = { 'markdown', 'Avante' },
  config = function()
    require('render-markdown').setup({
      lsp = { enabled = true },
      file_types = { 'markdown', 'Avante' },
      heading = {
        sign = false,
        position = 'inline',
        icons = { '󰲠  ', '󰲢  ', '󰲤  ', '󰲦  ', '󰲨  ', '󰲪  ' },
      },
      code = {
        language_icon = false,
        language_name = false,
        language_info = false,
        width = 'block',
        left_pad = 2,
        right_pad = 2,
        language_pad = 2,
        border = 'thick',
      },
      pipe_table = { preset = 'heavy', style = 'normal' },
      latex = { enabled = false },
      checkbox = { checked = { scope_highlight = '@markup.strikethrough' } },
    })
  end,
}
