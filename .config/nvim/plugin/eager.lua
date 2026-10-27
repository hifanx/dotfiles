require('mini.icons').setup()

vim.keymap.set(
    'n',
    '<leader>e',
    function() require('oil').toggle_float() end,
    { desc = 'Oil' }
)
require('oil').setup({ -- g? to see help & keymaps
    default_file_explorer = true,
    delete_to_trash = true,
    view_options = {
        show_hidden = true, -- but not .git ↓
        is_always_hidden = function(name, _) return name == '.git' end,
    },
    float = {
        max_width = 0.6,
        max_height = 0.9,
    },
    win_options = {
        signcolumn = 'yes:2',
    },
})
