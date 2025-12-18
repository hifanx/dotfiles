GLOB.timer.start('render-markdown')
require('render-markdown').setup({
    file_types = { 'markdown' },
    heading = {
        sign = false,
        position = 'overlay',
        icons = { '󰲠  ', '󰲢  ', '󰲤  ', '󰲦  ', '󰲨  ', '󰲪  ' },
    },
    code = {
        language_icon = false,
        language_name = false,
        language_info = false,
        left_pad = 1,
        right_pad = 1,
        language_pad = 0,
        width = 'block',
        border = 'thin',
    },
    pipe_table = { preset = 'heavy', style = 'normal' },
    latex = { enabled = false },
    checkbox = { checked = { scope_highlight = '@markup.strikethrough' } },
})
GLOB.timer.stop('render-markdown')
