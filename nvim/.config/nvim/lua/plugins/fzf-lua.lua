-- buffers & files
vim.keymap.set('n', '<C-s>', ':FzfLua files<CR>', { desc = 'Files' })
vim.keymap.set('n', '<leader>b', ':FzfLua buffers<CR>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fq', ':FzfLua quickfix<CR>', { desc = 'Quickfix' })
vim.keymap.set('n', '<leader>fQ', ':FzfLua quickfix_stack<CR>', { desc = 'Quickfix stack' })
vim.keymap.set('n', '<leader>fl', ':FzfLua loclist<CR>', { desc = 'Loclist' })
vim.keymap.set('n', '<leader>fL', ':FzfLua loclist_stack<CR>', { desc = 'Loclist stack' })
-- search
vim.keymap.set('n', '<leader>fw', ':FzfLua grep_cword<CR>', { desc = 'Word under cursor' })
vim.keymap.set('x', '<leader>fg', ':FzfLua grep_visual<CR>', { desc = 'Grep visual' })
vim.keymap.set('n', '<C-/>', ':FzfLua live_grep_native<CR>', { desc = 'Grep live' })
vim.keymap.set('n', '<C-_>', ':FzfLua live_grep_native<CR>', { desc = 'Grep live' })
-- git
vim.keymap.set('n', '<leader>gc', ':FzfLua git_bcommits<CR>', { desc = 'Commits buffer' })
vim.keymap.set('n', '<leader>gC', ':FzfLua git_commits<CR>', { desc = 'Commits' })
-- misc
vim.keymap.set('n', '<leader><space>', ':FzfLua resume<CR>', { desc = 'Resume' })
vim.keymap.set('n', '<leader>ff', ':FzfLua builtin<CR>', { desc = 'FzfLua' })
vim.keymap.set('n', '<leader>fF', ':FzfLua filetypes<CR>', { desc = 'Filetypes' })
vim.keymap.set('n', '<leader>fh', ':FzfLua helptags<CR>', { desc = 'Help' })
vim.keymap.set('n', '<leader>fH', ':FzfLua highlights<CR>', { desc = 'Highlights' })
vim.keymap.set('n', '<leader>fc', ':FzfLua commands<CR>', { desc = 'Commands' })
vim.keymap.set('n', '<leader>fC', ':FzfLua colorschemes<CR>', { desc = 'Colorschemes' })
vim.keymap.set('n', '<leader>fm', ':FzfLua marks<CR>', { desc = 'Marks' })
vim.keymap.set('n', '<leader>fj', ':FzfLua jumps<CR>', { desc = 'Jumps' })
vim.keymap.set('n', '<leader>fr', ':FzfLua registers<CR>', { desc = 'Registers' })
vim.keymap.set('n', '<leader>fa', ':FzfLua autocmds<CR>', { desc = 'Autocmds' })
vim.keymap.set('n', '<leader>fo', ':FzfLua nvim_options<CR>', { desc = 'Options' })
vim.keymap.set('n', '<leader>fk', ':FzfLua keymaps<CR>', { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>fu', ':FzfLua undotree<CR>', { desc = 'Undo' })

require('fzf-lua').setup({
    { 'border-fused', 'hide' },
    ui_select = {},
    defaults = {
        file_icons = 'mini',
        cwd_prompt = false,
        git_icons = false,
    },
    winopts = {
        col = 0.5,
        row = 0.5,
        width = 0.6,
        height = 0.9,
        preview = {
            scrollbar = false,
            layout = 'vertical',
            vertical = 'up:40%',
            winopts = {
                number = false,
            },
        },
    },
    keymap = {
        builtin = {
            -- ['<C-d>'] = 'preview-page-down',
            -- ['<C-u>'] = 'preview-page-up',
        },
    },
    grep = {
        hidden = true,
    },
})
