require('render-markdown').setup({
    file_types = { 'markdown' },
    completions = { lsp = { enabled = true } },
    heading = {
        sign = false,
        position = 'inline',
        icons = { '󰼏  ', '󰼐  ', '󰼑  ', '󰼒  ', '󰼓  ', '󰼔  ' },
    },
    code = {
        left_pad = 2,
        right_pad = 2,
        sign = false,
        width = 'block',
        border = 'thick',

        language_icon = true,
        language_name = false,
        language_border = '',
        language_left = '█',
        language_right = '',
    },
    pipe_table = { preset = 'heavy', cell = 'trimmed', style = 'normal' },
    latex = { enabled = false },
    checkbox = { checked = { scope_highlight = '@markup.strikethrough' } },
})
