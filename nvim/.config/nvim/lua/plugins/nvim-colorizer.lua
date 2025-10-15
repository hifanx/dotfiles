return {
  'catgoose/nvim-colorizer.lua',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    require('colorizer').setup {
      user_default_options = {
        RRGGBBAA = true,
        AARRGGBB = true,
        css = true,
        xterm = true,
        mode = 'virtualtext',
        virtualtext = ' ',
      },
    }
  end,
}
