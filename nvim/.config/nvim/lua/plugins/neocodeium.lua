local neocodeium = require('neocodeium')
neocodeium.setup({
    show_label = false,
    -- disable in .env
    filter = function(bufnr)
        if vim.endswith(vim.api.nvim_buf_get_name(bufnr), '.env') then return false end
        return true
    end,
})
vim.keymap.set('i', '<C-.>', neocodeium.accept)
vim.keymap.set('i', '<C-,>', neocodeium.accept_word)
vim.keymap.set('i', '<C-/>', neocodeium.accept_line)
vim.keymap.set('i', '<C-c>', function() neocodeium.cycle_or_complete(1) end)
