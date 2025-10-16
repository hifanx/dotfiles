return {
  'nvim-mini/mini.icons',
  config = function()
    require('mini.icons').setup()
    ---@diagnostic disable-next-line: undefined-global
    MiniIcons.mock_nvim_web_devicons()
  end,
}
