GLOB.timer.start('fzf-lua')
-- buffers & files
vim.keymap.set('n', '<C-s>', ':FzfLua files<CR>', { desc = '[F]iles' })
vim.keymap.set('n', '<leader>b', ':FzfLua buffers<CR>', { desc = '[B]uffers' })
vim.keymap.set('n', '<leader>fq', ':FzfLua quickfix<CR>', { desc = '[Q]uickfix' })
vim.keymap.set('n', '<leader>fQ', ':FzfLua quickfix_stack<CR>', { desc = '[Q]uickfix stack' })
vim.keymap.set('n', '<leader>fl', ':FzfLua loclist<CR>', { desc = '[L]oclist' })
vim.keymap.set('n', '<leader>fL', ':FzfLua loclist_stack<CR>', { desc = '[L]oclist stack' })
-- search
vim.keymap.set('n', '<leader>fw', ':FzfLua grep_cword<CR>', { desc = '[W]ord under cursor' })
vim.keymap.set('x', '<leader>fg', ':FzfLua grep_visual<CR>', { desc = '[G]rep visual' })
vim.keymap.set('n', '<C-/>', ':FzfLua live_grep_native<CR>', { desc = 'Grep live' })
vim.keymap.set('n', '<C-_>', ':FzfLua live_grep_native<CR>', { desc = 'Grep live' })
-- git
vim.keymap.set('n', '<leader>gc', ':FzfLua git_bcommits<CR>', { desc = '[C]ommits buffer' })
vim.keymap.set('n', '<leader>gC', ':FzfLua git_commits<CR>', { desc = '[C]ommits' })
-- misc
vim.keymap.set('n', '<leader><space>', ':FzfLua resume<CR>', { desc = '[R]esume' })
vim.keymap.set('n', '<leader>ff', ':FzfLua builtin<CR>', { desc = '[F]zfLua' })
vim.keymap.set('n', '<leader>fF', ':FzfLua filetypes<CR>', { desc = '[F]iletypes' })
vim.keymap.set('n', '<leader>fh', ':FzfLua helptags<CR>', { desc = '[H]elp' })
vim.keymap.set('n', '<leader>fH', ':FzfLua highlights<CR>', { desc = '[H]ighlights' })
vim.keymap.set('n', '<leader>fc', ':FzfLua commands<CR>', { desc = '[C]ommands' })
vim.keymap.set('n', '<leader>fC', ':FzfLua colorschemes<CR>', { desc = '[C]olorschemes' })
vim.keymap.set('n', '<leader>fm', ':FzfLua marks<CR>', { desc = '[M]arks' })
vim.keymap.set('n', '<leader>fj', ':FzfLua jumps<CR>', { desc = '[J]umps' })
vim.keymap.set('n', '<leader>fr', ':FzfLua registers<CR>', { desc = '[R]egisters' })
vim.keymap.set('n', '<leader>fa', ':FzfLua autocmds<CR>', { desc = '[A]utocmds' })
vim.keymap.set('n', '<leader>fo', ':FzfLua nvim_options<CR>', { desc = '[O]ptions' })
vim.keymap.set('n', '<leader>fk', ':FzfLua keymaps<CR>', { desc = '[K]eymaps' })
vim.keymap.set('n', '<leader>fu', ':FzfLua undotree<CR>', { desc = '[U]ndo' })

require('fzf-lua').register_ui_select()

require('fzf-lua').setup({
    { 'border-fused', 'hide' },
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
            ['<C-d>'] = 'preview-page-down',
            ['<C-u>'] = 'preview-page-up',
        },
    },
    grep = {
        hidden = true,
    },
})
GLOB.timer.stop('fzf-lua')
